//
//  BankModel.h
//  yuncangcat
//
//  Created by 阿杜 on 16/8/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JSONModel.h"

@interface BankModel : JSONModel

@property (nonatomic,copy) NSString * bankImg;
@property (nonatomic,copy) NSString * bankName;
@property (nonatomic,copy) NSString * createtime;
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * isDelete;
@property (nonatomic,copy) NSString * primaryKey;

@end
