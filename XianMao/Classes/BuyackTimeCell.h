//
//  BuyackTimeCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BuyackTimeCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * timeLbl;
@property (nonatomic,strong) UILabel * time;

+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;
+ (NSString *)reuseIdentifier;
+(CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(NSString *)title andDateString:(NSString *)dateStr;
@end
