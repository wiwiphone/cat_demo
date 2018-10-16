//
//  PayZhaoHangReg.h
//  XianMao
//
//  Created by apple on 16/5/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface PayZhaoHangReg : JSONModel

@property (nonatomic, copy) NSString *Amount;
@property (nonatomic, copy) NSString *BillNo;
@property (nonatomic, copy) NSString *BranchID;
@property (nonatomic, copy) NSString *CoNo;
@property (nonatomic, copy) NSString *Date;
@property (nonatomic, copy) NSString *ExpireTimeSpan;
@property (nonatomic, copy) NSString *MerchantCode;
@property (nonatomic, copy) NSString *MerchantPara;
@property (nonatomic, copy) NSString *MerchantRetPara;
@property (nonatomic, copy) NSString *MerchantRetUrl;
@property (nonatomic, copy) NSString *MerchantUrl;
@property (nonatomic, copy) NSString *pay_url;
@property (nonatomic, copy) NSString *MfcISAPICommand;

@end
