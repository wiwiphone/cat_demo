//
//  RecoveryDanListGoodsCell.h
//  XianMao
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
@class RecoveryGoodsVo;
@interface RecoveryDanListGoodsCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO andCellDictTwo:(RecoveryGoodsVo *)goodsVOTwo;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
