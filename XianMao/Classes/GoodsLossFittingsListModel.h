//
//  GoodsLossFittingsListModel.h
//  XianMao
//
//  Created by 阿杜 on 16/7/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@protocol GoodsLossFittingsListModel;

@interface GoodsLossFittingsListModel : JSONModel


@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * createtime;
@property (nonatomic,copy) NSString * updatetime;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * pic;
@property (nonatomic,copy) NSString * number;
@property (nonatomic,copy) NSString * info;
@property (nonatomic,copy) NSString * type;
@property (nonatomic,copy) NSString * price;
@property (nonatomic,copy) NSString * primaryKey;


@end
