//
//  InformationCell.h
//  XianMao
//
//  Created by 阿杜 on 16/8/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NoticesModel.h"

@interface InformationCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * numlbl;
@property (nonatomic,strong) NoticesModel * model;

-(void)updateCellWithDict:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(NoticesModel *)model;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSString *)reuseIdentifier;
+ (NSString *)cellForkey;


@end
