//
//  offeredTopImageCell.h
//  XianMao
//
//  Created by 阿杜 on 16/3/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ASScroll.h"
#import "RecoveryGoodsDetail.h"
#import "MJPhotoBrowser.h"

@interface offeredTopImageCell : BaseTableViewCell

@property (nonatomic, strong) ASScroll *asScroll;
@property (nonatomic, strong) XMWebImageView *recoverImageView;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *imageViewItems;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)bidVO;
- (void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO;

@end
