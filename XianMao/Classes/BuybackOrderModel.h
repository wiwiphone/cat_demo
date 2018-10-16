//
//  BuybackOrderModel.h
//  XianMao
//
//  Created by 阿杜 on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "GoodsFittingsListModel.h"
#import "GoodsLossFittingsListModel.h"

@interface BuybackOrderModel : JSONModel

@property (nonatomic,copy) NSString * warringMessage;
@property (nonatomic,copy) NSString * supportMessage;
@property (nonatomic,copy) NSString * goodsName;
@property (nonatomic,copy) NSString * shopPrice;
@property (nonatomic,copy) NSString * realPrice;
@property (nonatomic,copy) NSString * pic;
@property (nonatomic,copy) NSString * buyBackInfoMessage;
@property (nonatomic,copy) NSString * count;
@property (nonatomic,copy) NSString * strapName;
@property (nonatomic,copy) NSString * strapInfo;
@property (nonatomic,copy) NSString * strapPic;
@property (nonatomic,copy) NSString * receivedTime;
@property (nonatomic,copy) NSString * phone;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * userName;
@property (nonatomic,copy) NSString * priceInfo;
@property (nonatomic,strong) NSArray<GoodsFittingsListModel> * goodsCommoonFittingsList; //寄回明细
@property (nonatomic,strong) NSArray<GoodsLossFittingsListModel> * goodsLossFittingsList;


@end





