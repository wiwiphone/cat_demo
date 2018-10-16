//
//  OfferedTitleCell.h
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecoveryGoodsVo.h"

typedef void(^handleIconImageView)();

@interface OfferedTitleCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)bidVO;
- (void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO;

@property (nonatomic, copy) handleIconImageView handleIcon;

@end
