//
//  SupportvalueCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BuybackOrderModel.h"

@interface SupportvalueCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * SupportLbl;
@property (nonatomic,strong) UILabel * predictLbl;


@property (nonatomic,strong) UIView * container;
@property (nonatomic,strong) UIImageView * triangle;

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSString *)reuseIdentifier;
+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(BuybackOrderModel *)BuybackOrderModel;
@end
