//
//  RecoverDetailTopCell.h
//  XianMao
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecoveryGoodsDetail.h"

@interface RecoverDetailTopCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)bidVO;
- (void)updateCellWithDict:(RecoveryGoodsDetail *)goodsDetail;

@end
