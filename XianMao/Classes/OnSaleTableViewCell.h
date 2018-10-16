//
//  OnSaleTableViewCell.h
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ScrollLabelView.h"

@class GoodsInfo;
@class RecoveryGoodsDetail;
@class RecoveryGoodsVo;


@interface OnSaleTableViewCell : BaseTableViewCell

@property (nonatomic, strong) ScrollLabelView * scrollLabel;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo;
+ (NSMutableDictionary*)buildRecoverCellDict:(RecoveryGoodsDetail*)goodsDetail;
+ (NSString*)cellDictKeyForGoodsInfo;
+ (NSString*)cellDictKeyForGoodsDetail;
- (void)updateCellWithDict:(NSDictionary *)dict;

-(void)getIsChatCome:(NSInteger)isChatCome;

@property (nonatomic, assign) NSInteger type;
@property(nonatomic,copy) void(^handleApplyOffSaleBlock)(GoodsInfo *goodsInfo);
@property(nonatomic,copy) void(^handleOnSaleBlock)(GoodsInfo *goodsInfo, RecoveryGoodsVo *goodsVO);
@property(nonatomic,copy) void(^handleOffSaleBlock)(GoodsInfo *goodsInfo, RecoveryGoodsVo *goodsVO);
@property(nonatomic,copy) void(^handleEditBlock)(GoodsInfo *goodsInfo, RecoveryGoodsDetail *goodsDeatil);
@property(nonatomic,copy) void(^handleRefreshBlock)(GoodsInfo *goodsInfo);
@property(nonatomic,copy) void(^handleDeleteBlock)(NSString *goodsId);
@property(nonatomic,copy) void(^handleRreshenBlock)(GoodsInfo *goodsInfo);

@end


@interface OnSaleTableViewCellPublished : OnSaleTableViewCell

@end

@interface LockedOrSoldTableViewCell : OnSaleTableViewCell

@property(nonatomic,copy) void(^handleGoodsOrdersBlock)(NSString *goodsId);

@end

@interface SelectOnSaleTableViewCell : OnSaleTableViewCell

@end

