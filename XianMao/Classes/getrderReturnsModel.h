//
//  getrderReturnsModel.h
//  XianMao
//
//  Created by 阿杜 on 16/7/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "orderReturnItemListModel.h"

@interface getrderReturnsModel : JSONModel
@property (nonatomic,copy) NSString * message;
@property (nonatomic,copy) NSString * totalAmount;
@property (nonatomic,copy) NSString * totalAmountStr;
@property (nonatomic,strong) NSArray<orderReturnItemListModel> * orderReturnItemList;

@end
