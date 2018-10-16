//
//  AccountCard.h
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "CardPic.h"

@interface AccountCard : JSONModel

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger cardType;//1:消费卡 2:鉴定卡 3:洗护卡
@property (nonatomic, strong) CardPic * cardPic;
@property (nonatomic, copy) NSString * cardDesc;
@property (nonatomic, copy) NSString * cardName;
@property (nonatomic, assign) double cardMoney;
@property (nonatomic, assign) double cardCanPayMoney;

@end
