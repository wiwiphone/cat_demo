//
//  BankCard.h
//  yuncangcat
//
//  Created by 阿杜 on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JSONModel.h"

@interface BankCard : JSONModel

@property (nonatomic,copy) NSString * bankCard;
@property (nonatomic,copy) NSString * bankId;
@property (nonatomic,copy) NSString * bankImg;
@property (nonatomic,copy) NSString * bankName;
@property (nonatomic,copy) NSString * identityCard;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * userId;

@end
