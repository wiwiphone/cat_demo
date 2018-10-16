//
//  RecoverDetailTableViewCell.h
//  XianMao
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecoveryGoodsVo.h"
@interface RecoverDetailTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)bidVO;
- (void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO;

@end
