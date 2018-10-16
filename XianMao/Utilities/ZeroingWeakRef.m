//
//  ZeroingWeakRef.m
//  XianMao
//
//  Created by simon on 12/30/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ZeroingWeakRef.h"
#import <CommonCrypto/CommonDigest.h>

#import <dlfcn.h>
#import <libkern/OSAtomic.h>
#import <objc/runtime.h>
#import <mach/mach.h>
#import <mach/port.h>
#import <pthread.h>


@interface NSObject (ZeroingWeakRefSwizzled)
- (void)ZeroingWeakRef_KVO_original_release;
- (void)ZeroingWeakRef_KVO_original_dealloc;
- (void)ZeroingWeakRef_KVO_original_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;
- (void)ZeroingWeakRef_KVO_original_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath;
- (void)ZeroingWeakRef_KVO_original_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(void *)context;
@end


static void EnsureCustomSubclass(id obj);

@interface ZeroingWeakRef ()

- (void)_zeroTarget;
- (void)_executeCleanupBlockWithTarget: (id)target;

@end


static id (*objc_loadWeak_fptr)(id *location);
static id (*objc_storeWeak_fptr)(id *location, id obj);

@interface _ZeroingWeakRefCleanupHelper : NSObject
{
    ZeroingWeakRef *_ref;
    id _target;
}

- (id)initWithRef: (ZeroingWeakRef *)ref target: (id)target;

@end

@implementation _ZeroingWeakRefCleanupHelper

- (id)initWithRef: (ZeroingWeakRef *)ref target: (id)target
{
    if((self = [self init]))
    {
        objc_storeWeak_fptr(&_ref, ref);
        _target = target;
    }
    return self;
}

- (void)dealloc
{
    ZeroingWeakRef *ref = objc_loadWeak_fptr(&_ref);
    [ref _executeCleanupBlockWithTarget: _target];
    objc_storeWeak_fptr(&_ref, nil);
    
    [super dealloc];
}

@end


@implementation ZeroingWeakRef

static pthread_mutex_t gMutex;
static CFMutableDictionaryRef gObjectWeakRefsMap; // maps (non-retained) objects to CFMutableSetRefs containing weak refs
static NSMutableSet *gCustomSubclasses;
static NSMutableDictionary *gCustomSubclassMap; // maps regular classes to their custom subclasses

+ (void)initialize
{
    if(self == [ZeroingWeakRef class])
    {
        pthread_mutexattr_t mutexattr;
        pthread_mutexattr_init(&mutexattr);
        pthread_mutexattr_settype(&mutexattr, PTHREAD_MUTEX_RECURSIVE);
        pthread_mutex_init(&gMutex, &mutexattr);
        pthread_mutexattr_destroy(&mutexattr);
        
        gObjectWeakRefsMap = CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
        gCustomSubclasses = [[NSMutableSet alloc] init];
        gCustomSubclassMap = [[NSMutableDictionary alloc] init];
        
        // see if the 10.7 ZWR runtime functions are available
        // nothing special about objc_allocateClassPair, it just
        // seems like a reasonable and safe choice for finding
        // the runtime functions
        
        Dl_info info;
        int success = dladdr(objc_allocateClassPair, &info);
        if(success)
        {
            // note: we leak the handle because it's inconsequential
            // and technically, the fptrs would be invalid after a dlclose
            void *handle = dlopen(info.dli_fname, RTLD_LAZY | RTLD_GLOBAL);
            if(handle)
            {
                objc_loadWeak_fptr = dlsym(handle, "objc_loadWeak");
                objc_storeWeak_fptr = dlsym(handle, "objc_storeWeak");
                
                // if either one failed, make sure both are zeroed out
                // this is probably unnecessary, but good paranoia
                if(!objc_loadWeak_fptr || !objc_storeWeak_fptr)
                {
                    objc_loadWeak_fptr = NULL;
                    objc_storeWeak_fptr = NULL;
                }
            }
        }
    }
}

static void WhileLocked(void (^block)(void))
{
    pthread_mutex_lock(&gMutex);
    block();
    pthread_mutex_unlock(&gMutex);
}
#define WhileLocked(block) WhileLocked(^block)

static void AddWeakRefToObject(id obj, ZeroingWeakRef *ref)
{
    CFMutableSetRef set = (void *)CFDictionaryGetValue(gObjectWeakRefsMap, obj);
    if(!set)
    {
        set = CFSetCreateMutable(NULL, 0, NULL);
        CFDictionarySetValue(gObjectWeakRefsMap, obj, set);
        CFRelease(set);
    }
    CFSetAddValue(set, ref);
}

static void RemoveWeakRefFromObject(id obj, ZeroingWeakRef *ref)
{
    CFMutableSetRef set = (void *)CFDictionaryGetValue(gObjectWeakRefsMap, obj);
    CFSetRemoveValue(set, ref);
}

static void ClearWeakRefsForObject(id obj)
{
    CFMutableSetRef set = (void *)CFDictionaryGetValue(gObjectWeakRefsMap, obj);
    if(set)
    {
        NSSet *setCopy = [[NSSet alloc] initWithSet: (NSSet *)set];
        [setCopy makeObjectsPerformSelector: @selector(_zeroTarget)];
        [setCopy makeObjectsPerformSelector: @selector(_executeCleanupBlockWithTarget:) withObject: obj];
        [setCopy release];
        CFDictionaryRemoveValue(gObjectWeakRefsMap, obj);
    }
}

static Class GetCustomSubclass(id obj)
{
    Class class = object_getClass(obj);
    while(class && ![gCustomSubclasses containsObject: class])
        class = class_getSuperclass(class);
    return class;
}

static Class GetRealSuperclass(id obj)
{
    Class class = GetCustomSubclass(obj);
    NSCAssert1(class, @"Coudn't find ZeroingWeakRef subclass in hierarchy starting from %@, should never happen", object_getClass(obj));
    return class_getSuperclass(class);
}

static BOOL CanNativeZWR(id obj)
{
    return YES;
}

static void CustomSubclassRelease(id self, SEL _cmd)
{
    Class superclass = GetRealSuperclass(self);
    IMP superRelease = class_getMethodImplementation(superclass, @selector(release));
    WhileLocked({
        ((void (*)(id, SEL))superRelease)(self, _cmd);
    });
}

static void CustomSubclassDealloc(id self, SEL _cmd)
{
    ClearWeakRefsForObject(self);
    Class superclass = GetRealSuperclass(self);
    IMP superDealloc = class_getMethodImplementation(superclass, @selector(dealloc));
    ((void (*)(id, SEL))superDealloc)(self, _cmd);
}

static Class CustomSubclassClassForCoder(id self, SEL _cmd)
{
    Class class = GetCustomSubclass(self);
    Class superclass = class_getSuperclass(class);
    IMP superClassForCoder = class_getMethodImplementation(superclass, @selector(classForCoder));
    Class classForCoder = ((id (*)(id, SEL))superClassForCoder)(self, _cmd);
    if(classForCoder == class)
        classForCoder = superclass;
    return classForCoder;
}

static void KVOSubclassRelease(id self, SEL _cmd)
{
    IMP originalRelease = class_getMethodImplementation(object_getClass(self), @selector(ZeroingWeakRef_KVO_original_release));
    WhileLocked({
        ((void (*)(id, SEL))originalRelease)(self, _cmd);
    });
}

static void KVOSubclassDealloc(id self, SEL _cmd)
{
    ClearWeakRefsForObject(self);
    IMP originalDealloc = class_getMethodImplementation(object_getClass(self), @selector(ZeroingWeakRef_KVO_original_dealloc));
    ((void (*)(id, SEL))originalDealloc)(self, _cmd);
}

static void KVOSubclassRemoveObserverForKeyPath(id self, SEL _cmd, id observer, NSString *keyPath)
{
    WhileLocked({
        IMP originalIMP = class_getMethodImplementation(object_getClass(self), @selector(ZeroingWeakRef_KVO_original_removeObserver:forKeyPath:));
        ((void (*)(id, SEL, id, NSString *))originalIMP)(self, _cmd, observer, keyPath);
        
        EnsureCustomSubclass(self);
    });
}

static void KVOSubclassRemoveObserverForKeyPathContext(id self, SEL _cmd, id observer, NSString *keyPath, void *context)
{
    WhileLocked({
        IMP originalIMP = class_getMethodImplementation(object_getClass(self), @selector(ZeroingWeakRef_KVO_original_removeObserver:forKeyPath:context:));
        ((void (*)(id, SEL, id, NSString *, void *))originalIMP)(self, _cmd, observer, keyPath, context);
        
        EnsureCustomSubclass(self);
    });
}

static BOOL IsTollFreeBridged(Class class, id obj)
{
    NSString *className = NSStringFromClass(class);
    return [className hasPrefix:@"NSCF"] || [className hasPrefix:@"__NSCF"];
}

static BOOL IsConstantObject(id obj)
{
    unsigned int retainCount = [obj retainCount];
    return retainCount == UINT_MAX || retainCount == INT_MAX;
}

static BOOL IsKVOSubclass(id obj)
{
    return [obj class] == class_getSuperclass(object_getClass(obj));
}

static Class CreatePlainCustomSubclass(Class class)
{
    NSString *newName = [NSString stringWithFormat: @"%s_ZeroingWeakRefSubclass", class_getName(class)];
    const char *newNameC = [newName UTF8String];
    
    Class subclass = objc_allocateClassPair(class, newNameC, 0);
    
    Method release = class_getInstanceMethod(class, @selector(release));
    Method dealloc = class_getInstanceMethod(class, @selector(dealloc));
    Method classForCoder = class_getInstanceMethod(class, @selector(classForCoder));
    class_addMethod(subclass, @selector(release), (IMP)CustomSubclassRelease, method_getTypeEncoding(release));
    class_addMethod(subclass, @selector(dealloc), (IMP)CustomSubclassDealloc, method_getTypeEncoding(dealloc));
    class_addMethod(subclass, @selector(classForCoder), (IMP)CustomSubclassClassForCoder, method_getTypeEncoding(classForCoder));
    
    objc_registerClassPair(subclass);
    
    return subclass;
}

static void PatchKVOSubclass(Class class)
{
    //    NSLog(@"Patching KVO class %s", class_getName(class));
    Method removeObserverForKeyPath = class_getInstanceMethod(class, @selector(removeObserver:forKeyPath:));
    Method release = class_getInstanceMethod(class, @selector(release));
    Method dealloc = class_getInstanceMethod(class, @selector(dealloc));
    
    class_addMethod(class,
                    @selector(ZeroingWeakRef_KVO_original_removeObserver:forKeyPath:),
                    method_getImplementation(removeObserverForKeyPath),
                    method_getTypeEncoding(removeObserverForKeyPath));
    class_addMethod(class, @selector(ZeroingWeakRef_KVO_original_release), method_getImplementation(release), method_getTypeEncoding(release));
    class_addMethod(class, @selector(ZeroingWeakRef_KVO_original_dealloc), method_getImplementation(dealloc), method_getTypeEncoding(dealloc));
    
    class_replaceMethod(class,
                        @selector(removeObserver:forKeyPath:),
                        (IMP)KVOSubclassRemoveObserverForKeyPath,
                        method_getTypeEncoding(removeObserverForKeyPath));
    class_replaceMethod(class, @selector(release), (IMP)KVOSubclassRelease, method_getTypeEncoding(release));
    class_replaceMethod(class, @selector(dealloc), (IMP)KVOSubclassDealloc, method_getTypeEncoding(dealloc));
    
    // The context variant is only available on 10.7/iOS5+, so only perform that override if the method actually exists.
    Method removeObserverForKeyPathContext = class_getInstanceMethod(class, @selector(removeObserver:forKeyPath:context:));
    if(removeObserverForKeyPathContext)
    {
        class_addMethod(class,
                        @selector(ZeroingWeakRef_KVO_original_removeObserver:forKeyPath:context:),
                        method_getImplementation(removeObserverForKeyPathContext),
                        method_getTypeEncoding(removeObserverForKeyPathContext));
        class_replaceMethod(class,
                            @selector(removeObserver:forKeyPath:context:),
                            (IMP)KVOSubclassRemoveObserverForKeyPathContext,
                            method_getTypeEncoding(removeObserverForKeyPathContext));
        
    }
}

static void RegisterCustomSubclass(Class subclass, Class superclass)
{
    [gCustomSubclassMap setObject: subclass forKey: (id <NSCopying>) superclass];
    [gCustomSubclasses addObject: subclass];
}

static Class CreateCustomSubclass(Class class, id obj)
{
    if(IsTollFreeBridged(class, obj))
    {
//        NSCAssert2(0, @"Cannot create zeroing weak reference to object of type %@ with COREFOUNDATION_HACK_LEVEL set to %d", class, COREFOUNDATION_HACK_LEVEL);
        return class;
    }
    else if(IsKVOSubclass(obj))
    {
        PatchKVOSubclass(class);
        return class;
    }
    else
    {
        return CreatePlainCustomSubclass(class);
    }
}
static void EnsureCustomSubclass(id obj)
{
    if(!GetCustomSubclass(obj) && !IsConstantObject(obj))
    {
        Class class = object_getClass(obj);
        Class subclass = [gCustomSubclassMap objectForKey: class];
        if(!subclass)
        {
            subclass = CreateCustomSubclass(class, obj);
            RegisterCustomSubclass(subclass, class);
        }
        
        // only set the class if the current one is its superclass
        // otherwise it's possible that it returns something farther up in the hierarchy
        // and so there's no need to set it then
        if(class_getSuperclass(subclass) == class)
            object_setClass(obj, subclass);
    }
}

static void RegisterRef(ZeroingWeakRef *ref, id target)
{
    WhileLocked({
        EnsureCustomSubclass(target);
        AddWeakRefToObject(target, ref);
    });
}

static void UnregisterRef(ZeroingWeakRef *ref)
{
    WhileLocked({
        id target = ref->_target;
        
        if(target)
            RemoveWeakRefFromObject(target, ref);
    });
}

+ (BOOL)canRefCoreFoundationObjects
{
    return objc_storeWeak_fptr!=NULL;
}

+ (id)refWithTarget: (id)target
{
    return [[[self alloc] initWithTarget: target] autorelease];
}

- (id)initWithTarget: (id)target
{
    if((self = [self init]))
    {
        if(objc_storeWeak_fptr && CanNativeZWR(target))
        {
            objc_storeWeak_fptr(&_target, target);
            _nativeZWR = YES;
        }
        else
        {
            _target = target;
            RegisterRef(self, target);
        }
    }
    return self;
}


- (void)dealloc
{
    if(objc_storeWeak_fptr && _nativeZWR)
        objc_storeWeak_fptr(&_target, nil);
    else
        UnregisterRef(self);
    
    [_cleanupBlock release];
    [super dealloc];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@: %p -> %@>", [self class], self, [self target]];
}

- (void)setCleanupBlock: (void (^)(id target))block
{
    block = [block copy];
    [_cleanupBlock release];
    _cleanupBlock = block;
    
    if(objc_loadWeak_fptr && _nativeZWR)
    {
        // wrap a pool around this code, otherwise it artificially extends
        // the lifetime of the target object
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        id target = [self target];
        if(target != nil) @synchronized(target)
        {
            static void *associatedKey = &associatedKey;
            NSMutableSet *cleanupHelpers = objc_getAssociatedObject(target, associatedKey);
            
            if(cleanupHelpers == nil)
            {
                cleanupHelpers = [NSMutableSet set];
                objc_setAssociatedObject(target, associatedKey, cleanupHelpers, OBJC_ASSOCIATION_RETAIN);
            }
            
            _ZeroingWeakRefCleanupHelper *helper = [[_ZeroingWeakRefCleanupHelper alloc] initWithRef: self target: target];
            [cleanupHelpers addObject:helper];
            
            [helper release];
        }
        
        [pool release];
    }
}

- (id)target
{
    if(objc_loadWeak_fptr && _nativeZWR)
    {
        return objc_loadWeak_fptr(&_target);
    }
    else
    {
        __block id ret;
        WhileLocked({
            ret = [_target retain];
        });
        return [ret autorelease];
    }
}

- (void)_zeroTarget
{
    _target = nil;
}

- (void)_executeCleanupBlockWithTarget: (id)target
{
    if(_cleanupBlock)
    {
        _cleanupBlock(target);
        [_cleanupBlock release];
        _cleanupBlock = nil;
    }
}

@end



@implementation NSNotificationCenter (ZeroingWeakRefAdditions)

- (void)addWeakObserver:(id)observer selector: (SEL)selector name: (NSString *)name object:(id)object
{
    ZeroingWeakRef *ref = [[ZeroingWeakRef alloc] initWithTarget: observer];
    
    id noteObj = [self addObserverForName: name object:object queue: nil usingBlock: ^(NSNotification *note) {
        id observer = [ref target];
        if ([observer respondsToSelector:selector]) {
            [observer performSelector:selector withObject: note];
        }
    }];
    
    [ref setCleanupBlock: ^(id target) {
        [self removeObserver: noteObj];
    }];
}

@end


@implementation ZeroingWeakDictionary {
    NSMutableDictionary *_dict;
}

- (id)init
{
    if((self = [super init]))
    {
        _dict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [_dict release];
    [super dealloc];
}

- (NSUInteger)count
{
    return [_dict count];
}

- (id)objectForKey: (id)aKey
{
    ZeroingWeakRef *ref = [_dict objectForKey: aKey];
    id obj = [ref target];
    
    // clean out keys whose objects have gone away
    if(ref && !obj)
        [_dict removeObjectForKey: aKey];
    
    return obj;
}

- (NSEnumerator *)keyEnumerator
{
    // enumerate over a copy because -objectForKey: mutates
    // which could cause an exception in code that should
    // appear to be correct
    return [[_dict allKeys] objectEnumerator];
}

- (void)removeObjectForKey: (id)aKey
{
    [_dict removeObjectForKey: aKey];
}

- (void)setObject: (id)anObject forKey: (id)aKey
{
    [_dict setObject: [ZeroingWeakRef refWithTarget: anObject]
              forKey: aKey];
}


@end




@implementation ZeroingWeakArray {
    NSMutableArray *_weakRefs;
}

- (id)init
{
    return [self initWithCapacity:0];
}

- (id)initWithCapacity:(NSUInteger)numItems
{
    if((self = [super init]))
    {
        _weakRefs = [[NSMutableArray alloc] initWithCapacity:numItems];
    }
    return self;
}

- (id)initWithObjects:(const id [])objects count:(NSUInteger)cnt
{
    self = [self initWithCapacity:cnt];
    
    for(NSInteger i = 0; i < cnt; i++)
        if(objects[i] != nil)
            [self addObject:objects[i]];
    
    return self;
}

- (void)dealloc
{
    [_weakRefs release];
    [super dealloc];
}

- (NSUInteger)count
{
    return [_weakRefs count];
}

- (id)objectAtIndex: (NSUInteger)index
{
    return [[_weakRefs objectAtIndex: index] target];
}

- (void)addObject: (id)anObject
{
    [_weakRefs addObject: [ZeroingWeakRef refWithTarget: anObject]];
}

- (void)insertObject: (id)anObject atIndex: (NSUInteger)index
{
    [_weakRefs insertObject: [ZeroingWeakRef refWithTarget: anObject]
                    atIndex: index];
}

- (void)removeLastObject
{
    [_weakRefs removeLastObject];
}

- (void)removeObjectAtIndex: (NSUInteger)index
{
    [_weakRefs removeObjectAtIndex: index];
}

- (void)replaceObjectAtIndex: (NSUInteger)index withObject: (id)anObject
{
    [_weakRefs replaceObjectAtIndex: index
                         withObject: [ZeroingWeakRef refWithTarget: anObject]];
}

- (id)copyWithZone:(NSZone *)zone
{
    id *objects = calloc([self count], sizeof(id));
    NSInteger count = 0;
    
    for(id obj in self)
        if(obj != nil)
        {
            objects[count] = obj;
            count++;
        }
    
    NSArray *ret = [[NSArray alloc] initWithObjects:objects count:count];
    
    free(objects);
    
    return ret;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    id *objects = calloc([self count], sizeof(id));
    NSInteger count = 0;
    
    for(id obj in self)
        if(obj != nil)
        {
            objects[count] = obj;
            count++;
        }
    
    NSArray *ret = [[NSMutableArray alloc] initWithObjects:objects count:count];
    
    free(objects);
    
    return ret;
}

@end


