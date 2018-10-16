

#if __has_feature(objc_arc)
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname, accessorname) \
+ (classname *)accessorname\
{\
static classname *accessorname = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
accessorname = [[classname alloc] init];\
if (accessorname && [accessorname respondsToSelector:@selector(initialize)]) { \
[accessorname initialize]; \
} \
});\
return accessorname;\
}
#else
#define SYNTHESIZE_SINGLETON_FOR_CLASS(classname, accessorname) \
static classname *shared##classname = nil; \
+ (void)cleanupFromTerminate \
{ \
classname *temp = shared##classname; \
shared##classname = nil; \
[temp dealloc]; \
} \
+ (void)registerForCleanup \
{ \
[[NSNotificationCenter defaultCenter] addObserver:self \
selector:@selector(cleanupFromTerminate) \
name:UIApplicationWillTerminateNotification \
object:nil]; \
} \
+ (classname *)accessorname \
{ \
static dispatch_once_t p; \
dispatch_once(&p, \
^{ \
if (shared##classname == nil) \
{ \
NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init]; \
shared##classname = [[self alloc] init]; \
if ([shared##classname respondsToSelector:@selector(initialize)]) { \
[shared##classname initialize]; \
} \
[self registerForCleanup]; \
[pool drain]; \
} \
}); \
return shared##classname; \
} \
+ (id)allocWithZone:(NSZone *)zone \
{ \
static dispatch_once_t p; \
__block classname* temp = nil; \
dispatch_once(&p, \
^{ \
if (shared##classname == nil) \
{ \
temp = shared##classname = [super allocWithZone:zone]; \
} \
}); \
return temp; \
} \
- (id)copyWithZone:(NSZone *)zone { return self; } \
- (id)retain { return self; } \
- (NSUInteger)retainCount { return NSUIntegerMax; } \
- (oneway void)release { } \
- (id)autorelease { return self; }
#endif


