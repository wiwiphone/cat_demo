//
//  ZeroingWeakRef.h
//  XianMao
//
//  Created by simon on 12/30/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZeroingWeakRef : NSObject
{
    id _target;
    BOOL _nativeZWR;
    void (^_cleanupBlock)(id target);
}

+ (BOOL)canRefCoreFoundationObjects;

+ (id)refWithTarget: (id)target;

- (id)initWithTarget: (id)target;

- (void)setCleanupBlock: (void (^)(id target))block;

- (id)target;

@end


@interface NSNotificationCenter (ZeroingWeakRefAdditions)

- (void)addWeakObserver: (id)observer selector: (SEL)selector name: (NSString *)name object: (id)object;

@end


@interface ZeroingWeakDictionary : NSMutableDictionary

@end

@interface ZeroingWeakArray : NSMutableArray

@end


