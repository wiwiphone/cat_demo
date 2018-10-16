//
//  MBMessageProxy.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBMessageProxy.h"
#import "MBDefaultNotification.h"
#import "MBGlobalFacade.h"
#import "MBUtil.h"
#import "MBCommand.h"

static char kMBNSMethodSignatureNotFoundKey;

@interface NSMethodSignature (MB)


@end

@implementation NSMethodSignature (MB)
- (BOOL)_$isMBNotFound {
    NSNumber *notFound = objc_getAssociatedObject(self, &kMBNSMethodSignatureNotFoundKey);
    return notFound ? [notFound boolValue] : NO;
}

- (void)_$setMBNotFound:(BOOL)yesOrNO {
    objc_setAssociatedObject(self, &kMBNSMethodSignatureNotFoundKey, [NSNumber numberWithBool:yesOrNO], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end


@implementation MBMessageProxy {
@private
    Class _proxyClass;
    NSUInteger _key;
}

- (id)initWithClass:(Class)proxyClass andKey:(NSUInteger)key; {
    _proxyClass = proxyClass;
    _key = key;
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    NSMethodSignature *sig;
    if (MBClassHasProtocol(_proxyClass, @protocol(MBStaticCommand))) {
        sig = [_proxyClass methodSignatureForSelector:sel];
    } else {
        sig = [_proxyClass instanceMethodSignatureForSelector:sel];
    }
    if (sig) {
        [sig _$setMBNotFound:NO];
        return sig;
    } else {
        NSMethodSignature *signature = [[self class] methodSignatureForSelector:@selector(__$$__NullMethod)];
        [signature _$setMBNotFound:YES];
        return signature;
    }
    //return sig ? : [super methodSignatureForSelector:sel];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    NSMethodSignature *signature = invocation.methodSignature;
    if (signature._$isMBNotFound) {
        NSLog(@"MBMvc You Invoke a Selector [%@] which is not exist in Class[%@]",
              NSStringFromSelector(invocation.selector),
              _proxyClass
              );
        return;
    }
    objc_setAssociatedObject(self, &kMBNSMethodSignatureNotFoundKey, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    NSMutableArray *needReleaseBlocks = [NSMutableArray arrayWithCapacity:2];
    //判断参数有Block 就进行copy
    MB_LOG(@"proxy selector[%@]", NSStringFromSelector(invocation.selector));
    for (NSUInteger i = 0; i < signature.numberOfArguments; i++) {
        char const *type = [signature getArgumentTypeAtIndex:i];
        if (strcmp(@encode(void (^)()), type) == 0) {
            void *block = NULL;
            [invocation getArgument:&block
                            atIndex:i];
            if (block) {
                id blockObj = (__bridge id) block;
                if ([blockObj isKindOfClass:NSClassFromString(@"NSBlock")]) {
                    void *blockCopied = Block_copy(block);
                    [invocation setArgument:&blockCopied
                                    atIndex:i];
                    [needReleaseBlocks addObject:[NSValue valueWithPointer:blockCopied]];
                }
            }
        }
    }
    
    if (!invocation.argumentsRetained) {
        [invocation retainArguments];
    }
    
    //对copy的Block 进行release
    if (needReleaseBlocks.count > 0) {
        for (NSValue *value in needReleaseBlocks) {
            void *needReleaseBlock = [value pointerValue];
            MB_LOG(@"release block ptr [%p]", needReleaseBlock);
            Block_release(needReleaseBlock);
        }
    }
    MBDefaultNotification *notification = [[MBDefaultNotification alloc]
                                             initWithName:MBProxyHandlerName(_key, _proxyClass)
                                             key:_key
                                             body:invocation];
    MBGlobalSendMBNotification(notification);
}


+ (void)__$$__NullMethod {
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    if (MBClassHasProtocol(_proxyClass, @protocol(MBStaticCommand))) {
        return [_proxyClass respondsToSelector:aSelector];
    } else {
        return [_proxyClass instancesRespondToSelector:aSelector];
    }
}


- (BOOL)isProxy {
    return YES;
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_proxyClass isSubclassOfClass:aClass];
}


- (BOOL)isMemberOfClass:(Class)aClass {
    return _proxyClass == aClass;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_proxyClass conformsToProtocol:aProtocol];
}


@end

