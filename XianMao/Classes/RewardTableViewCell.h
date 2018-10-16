//
//  RewardTableViewCell.h
//  XianMao
//
//  Created by simon cai on 25/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class RewardRecordItem;

@interface RewardTitleTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(RewardRecordItem*)item;

@end

@interface RewardTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(RewardRecordItem*)item;

@end

#import "JSONModel.h"

@interface RewardRecordItem : JSONModel

@property(nonatomic,copy) NSString *username;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,copy) NSString *type_desc;
@property(nonatomic,assign) double reward_money;

@end

extern NSString *formatRewardMoney(double money);