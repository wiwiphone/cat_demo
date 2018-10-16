//
//  BusineTitle.h
//  XianMao
//
//  Created by 阿杜 on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BusineTitleCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * busineTitleLbl;
@property (nonatomic,strong) UILabel * timeLal;


+ (NSString *)reuseIdentifier;
+(CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
+(NSMutableDictionary *)buildCellTime:(NSString *)time title:(BOOL)isShow;
-(void)updateCellWithDict:(NSDictionary *)dict;
@end
