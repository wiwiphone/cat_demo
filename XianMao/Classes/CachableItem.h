//
//  CachableItem.h
//  XianMao
//
//  Created by simon on 12/31/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CachableItem <NSObject>
@optional

- (BOOL)updateWithItem:(id<CachableItem>)item;

@end
