//
//  offeredUserInfoCell.h
//  XianMao
//
//  Created by 阿杜 on 16/3/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecoveryGoodsVo.h"

typedef void(^handleIconImageView)();
@interface offeredUserInfoCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)bidVO;
- (void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO;

@property (nonatomic, copy) handleIconImageView handleIcon;

@end
