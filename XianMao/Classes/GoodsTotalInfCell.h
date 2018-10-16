//
//  GoodsTotalInfCell.h
//  XianMao
//
//  Created by apple on 16/11/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef void(^scrollTableInfIndexP)(NSInteger index);

@interface GoodsTotalInfCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo *)detailInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) scrollTableInfIndexP scrollTableInfIndexP;

@end
