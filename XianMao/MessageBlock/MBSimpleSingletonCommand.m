//
//  MBSimpleSingletonCommand.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <pthread.h>
#import "MBSimpleSingletonCommand.h"

static NSMutableDictionary *_commandInstanceMap = nil;
static dispatch_once_t _oncePredicate_CommandInstanceMap;

static pthread_rwlock_t _lock;

@implementation MBSimpleSingletonCommand
+ (MBSimpleSingletonCommand *)instance {
    NSString *className = NSStringFromClass(self);
    dispatch_once(&_oncePredicate_CommandInstanceMap, ^{
        pthread_rwlock_init(&_lock, NULL);
        if (_commandInstanceMap == nil) {
            _commandInstanceMap = [[NSMutableDictionary alloc] init];
        }
    }
                  );
    MBSimpleSingletonCommand *_instance = nil;
    pthread_rwlock_rdlock(&_lock);
    _instance = [_commandInstanceMap objectForKey:className];
    pthread_rwlock_unlock(&_lock);
    if (_instance) {
        return _instance;
    } else {
        pthread_rwlock_wrlock(&_lock);
        _instance = [_commandInstanceMap objectForKey:className];
        if (!_instance) {
            _instance = [[self alloc] init];
            [_commandInstanceMap setObject:_instance forKey:className];
        }
        pthread_rwlock_unlock(&_lock);
        return _instance;
    }
}
@end
