//
//  MessageTitleCell.h
//  XianMao
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsDetailInfo.h"

@interface MessageTitleCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo *)detailInfo;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
