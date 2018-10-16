//
//  WeixinCopyCell.h
//  XianMao
//
//  Created by apple on 16/11/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AdviserPage.h"

@interface WeixinCopyCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(AdviserPage*)adviser;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
