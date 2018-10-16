//
//  NSMutableArray+NonRetainingObjects.h
//  alover
//
//  Created by simon cai on 8/12/14.
//  Copyright (c) 2014 alover.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (WeakReferences)

+ (id)noRetainingArray;
+ (id)noRetainingArrayWithCapacity:(NSUInteger)capacity;

@end

@interface NSMutableDictionary (WeakReferences)

+ (id)noRetainingDictionary;
+ (id)noRetainingDictionaryWithCapacity:(NSUInteger)capacity;

@end
