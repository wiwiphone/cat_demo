//
//  SendsaleActionCell.h
//  XianMao
//
//  Created by WJH on 17/3/2.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SendSaleVo.h"

@interface SendsaleActionCell : BaseTableViewCell

@property (nonatomic, copy) void(^handleActionToConsigmentBlcok)(NSString * consigmentSn);
@property (nonatomic, copy) void(^handleActionSeeLogisticsBlcok)(SendSaleVo * sendVo);
@property (nonatomic, copy) void(^handleActionContactAppraiserBlcok)(NSInteger estimatorId);
@property (nonatomic, copy) void(^handleActionSeeGoodsDetailBlcok)();
@property (nonatomic, copy) void(^handleActionConfirmReceiptBlcok)();



+ (NSString*)reuseIdentifier;
+ (NSString *)cellKeyForsendVo;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(SendSaleVo *)sendVo;
- (void)updateCellWithDict:(NSDictionary*)dict;
@end
