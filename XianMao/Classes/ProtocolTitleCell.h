//
//  ProtocolTitleCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProtocolTitleCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * title;


+ (NSString *)reuseIdentifier;
+(CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+(NSMutableDictionary *)buildCellTitle:(NSString *)title;
-(void)updateCellWithDict:(NSDictionary *)dict;
@end
