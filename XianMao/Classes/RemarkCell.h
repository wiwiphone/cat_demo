//
//  RemarkCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface RemarkCell : BaseTableViewCell


@property (nonatomic,strong) UIView * containerView;
@property (nonatomic,strong) UILabel * remarkLabel;
@property (nonatomic,strong) UIImageView * imageview;
+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+(NSMutableDictionary *)buildCellTitle:(NSString *)title;

@end
