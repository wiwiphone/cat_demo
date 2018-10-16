//
//  ItemizedAccountCell.h
//  XianMao
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AccountLogVo.h"

@interface ItemizedAccountCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(AccountLogVo*)logVo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
