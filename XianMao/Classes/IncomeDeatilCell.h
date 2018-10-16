//
//  IncomeDeatilCell.h
//  yuncangcat
//
//  Created by 阿杜 on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AccountLogVo.h"

@interface IncomeDeatilCell : BaseTableViewCell


+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(AccountLogVo *)model;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
