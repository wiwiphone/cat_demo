//
//  NSObject+PerformBlock.h
//  XianMao
//
//  Created by simon on 1/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface NSObject (PerformBlock)

- (void)performBlockOnMainThread:(void (^)())theBlock waitUntilDone:(BOOL)wait;

- (void)performBlockOnMainThread:(void (^)())theBlock waitUntilDone:(BOOL)wait modes:(NSArray *)modes;

@end
