//
//  SecionTitleCell.h
//  XianMao
//
//  Created by 阿杜 on 16/6/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SecionTitleCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,assign) int  number;

+(NSString *)reuseIdentifier;
+(NSMutableDictionary *)buildCellTitle:(NSString *)title;
+(CGFloat) rowHeightForPortrait;
-(void)updateCellWithDict:(NSDictionary *)dict;
@end
