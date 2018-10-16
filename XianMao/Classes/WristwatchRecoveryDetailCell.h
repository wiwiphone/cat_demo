//
//  WristwatchRecoveryDetailCell.h
//  XianMao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "GoodsFittings.h"
#import "BuybackOrderModel.h"


@interface WristwatchRecoveryDetailCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(GoodsFittings *)fitting;
+ (NSMutableDictionary*)buildCell:(BuybackOrderModel *)BuybackOrderModel;



- (void)updateCellWithDict:(NSDictionary *)dict;

@end
