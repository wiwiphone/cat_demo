//
//  SendSaleTableViewCell.h
//  XianMao
//
//  Created by WJH on 17/2/8.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SendSaleVo.h"

@interface SendSaleTableViewCell : BaseTableViewCell

@property (nonatomic, copy) void(^handleActionToConsigmentBlcok)(NSString * consigmentSn);
@property (nonatomic, copy) void(^handleActionSeeLogisticsBlcok)(SendSaleVo * sendVo);
@property (nonatomic, copy) void(^handleActionContactAppraiserBlcok)(NSInteger estimatorId);
@property (nonatomic, copy) void(^handleActionSeeGoodsDetailBlcok)(NSString * goodsSn);
@property (nonatomic, copy) void(^handleActionConfirmReceiptBlcok)();
@property (nonatomic, copy) void(^handleActionConfirmDeleteBlcok)(NSInteger ID);

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(SendSaleVo *)sendVo;
- (void)updateCellWithDict:(NSDictionary*)dict;
+ (NSString *)cellKeyForsendVo;

@end
