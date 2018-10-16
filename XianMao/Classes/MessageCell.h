//
//  MessageCell.h
//  XianMao
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsDetailInfo.h"

@interface MessageCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(NSMutableArray *)commentArr andSellerId:(NSInteger)sellerId;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
