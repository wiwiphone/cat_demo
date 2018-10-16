//
//  NSObject+PerformBlock.m
//  XianMao
//
//  Created by simon on 1/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "NSObject+PerformBlock.h"

@interface NSObject (NPMainThreadBlocksPrivate)
- (void)_npMainThreadBlockExecute:(void (^)())theBlock;
@end


@implementation NSObject (PerformBlock)

- (void)performBlockOnMainThread:(void (^)())theBlock waitUntilDone:(BOOL)wait {
    [self performSelectorOnMainThread:@selector(_npMainThreadBlockExecute:) withObject:theBlock waitUntilDone:wait];
}

- (void)performBlockOnMainThread:(void (^)())theBlock waitUntilDone:(BOOL)wait modes:(NSArray *)modes {
    [self performSelectorOnMainThread:@selector(_npMainThreadBlockExecute:) withObject:theBlock waitUntilDone:wait modes:modes];
}

- (void)_npMainThreadBlockExecute:(void (^)())theBlock {
    theBlock();
}

@end
