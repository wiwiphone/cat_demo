//
//  SendGoodsTimeCell.h
//  yuncangcat
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SendGoodsTimeCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSString *)data;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end