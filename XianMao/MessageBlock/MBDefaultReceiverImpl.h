//
//  MBDefaultReceiverImpl.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MBFacade.h"
#import "MBGlobalFacade.h"
#import "MBUtil.h"
#import "MBDefaultMessageReceiver.h"

//用于直接嵌入代码使其成为Receiver

//#define MBDefaultReceiverImpl                                                                            \
//id <MBFacade> _$MBFacade;                                                                              \
//NSMutableSet *_$MBObserver;                                                                              \
//}                                                                                                          \
//\
//- (id <MBFacade>)MBFacade {                                                                            \
//return _$MBFacade ? : [MBGlobalFacade instance];                                                       \
//}                                                                                                          \
//\
//- (void)setMBFacade:(id <MBFacade>)MBFacade {                                                        \
//if (self.MBFacade != MBFacade) {                                                                       \
//[self.MBFacade unsubscribeNotification:self];                                                            \
//_$MBFacade = MBFacade;                                                                                 \
//[self.MBFacade subscribeNotification:self];                                                              \
//}                                                                                                          \
//}                                                                                                          \
//\
//- (const NSUInteger)notificationKey {                                                                      \
//return MBGetDefaultNotificationKey(self);                                                                \
//}                                                                                                          \
//\
//- (id)initWithMBFacade:(id <MBFacade>)MBFacade {                                                     \
//self = [super init];                                                                                       \
//if (self) {                                                                                                \
//self.MBFacade = MBFacade;                                                                              \
//}                                                                                                          \
//return self;                                                                                               \
//}                                                                                                          \
//\
//\
//- (void)handlerNotification:(id <MBNotification>)notification {                                          \
//MBAutoHandlerReceiverNotification(self, notification);                                                   \
//}                                                                                                          \
//\
//- (NSSet *)listReceiveNotifications {                                                                      \
//return MBListAllReceiverHandlerName(self, [MBDefaultMessageReceiver class]);                           \
//}                                                                                                          \
//\
//- (NSSet *)_$listObserver {                                                                                \
//return _$MBObserver;                                                                                     \
//}                                                                                                          \
//\
//- (void)_$addObserver:(id)observer {                                                                       \
//_$MBObserver = _$MBObserver ? : [NSMutableSet setWithCapacity:1];                                      \
//[_$MBObserver addObject:observer];                                                                       \
//}                                                                                                          \
//\
//- (void)_$removeObserver:(id)observer {                                                                    \
//[_$MBObserver removeObject:observer];                                                                    \
//}                                                                                                          \
//\
//- (void)autoBindingKeyPath {                                                                               \
//MBAutoBindingKeyPath(self);                                                                              \
//}

