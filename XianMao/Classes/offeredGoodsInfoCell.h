//
//  offeredGoodsInfoCell.h
//  XianMao
//
//  Created by 阿杜 on 16/3/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecoveryGoodsVo.h"
#import "HighestBidVo.h"
#import "RecoveryGoodsDetail.h"
#import "MJPhotoBrowser.h"

@interface offeredGoodsInfoCell : BaseTableViewCell<MJPhotoBrowserDelegate>

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSDictionary*)buildCellDict:(RecoveryGoodsDetail*)bidVO;
- (void)updateCellWithDict:(RecoveryGoodsDetail *)recoveryGoodsDetailVO andDict:(NSDictionary *)dict;

@property (nonatomic, strong) XMWebImageView *recoverImageView;

@end
