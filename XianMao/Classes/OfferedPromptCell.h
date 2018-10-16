//
//  OfferedPromptCell.h
//  XianMao
//
//  Created by apple on 16/2/3.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecoveryGoodsVo.h"

@interface OfferedPromptCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(RecoveryGoodsVo*)goodsVO;
+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo *)goodsVO;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
