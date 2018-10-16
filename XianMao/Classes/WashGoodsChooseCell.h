//
//  WashGoodsChooseCell.h
//  XianMao
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsGuarantee.h"

typedef void(^clickXihuChooseBtn)(UIButton *sender);

@interface WashGoodsChooseCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsGuarantee *)guarantee;
-(void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) clickXihuChooseBtn clickXihuChooseBtn;
@end
