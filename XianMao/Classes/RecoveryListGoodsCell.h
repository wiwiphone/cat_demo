//
//  RecoveryListGoodsCell.h
//  XianMao
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecoveryGoodsVo.h"

typedef void(^pushGoodsDetailController)(NSString *goods_id);

@interface RecoveryListGoodsCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO andCellDictTwo:(RecoveryGoodsVo *)goodsVOTwo;
-(void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) pushGoodsDetailController pushGoodsDetailController;

@end
