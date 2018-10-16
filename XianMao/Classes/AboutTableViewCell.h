//
//  AboutTableViewCell.h
//  XianMao
//
//  Created by darren on 15/1/23.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface AboutTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;

+ (NSMutableDictionary*)buildCellDict:(NSString*)title;

- (void)updateCellWithDict:(NSDictionary*)dict;

@end
