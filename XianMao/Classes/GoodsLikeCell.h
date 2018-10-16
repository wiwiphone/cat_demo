//
//  GoodsLikeCell.h
//  XianMao
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsDetailInfo.h"

typedef void(^clickLikeBtn)();

@interface GoodsLikeCell : BaseTableViewCell

@property (nonatomic, strong) UIButton *likeLbl;

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo *)detailInfo;
-(void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) clickLikeBtn clickLikeBtn;

@end
