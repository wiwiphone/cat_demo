//
//  VerifyCell.h
//  XianMao
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SwipeTableViewCell.h"
#import "VerifyModel.h"

typedef void(^sendGoods)(NSString *goodsId);
typedef void(^lookLogistics)(VerifyModel *verifyModel);
typedef void(^surePutaway)(NSString *goodsId);
typedef void(^sendBackGoods)(NSString *goodsId);
typedef void(^affirmGoods)(NSString *goodsId);

@interface VerifyCell : SwipeTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(VerifyModel*)VerifyModel;

- (void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) sendGoods sendGoods;
@property (nonatomic, copy) lookLogistics lookLogistics;
@property (nonatomic, copy) surePutaway surePutaway;
@property (nonatomic, copy) sendBackGoods sendBackGoods;
@property (nonatomic, copy) affirmGoods affirmGoods;

@end
