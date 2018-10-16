//
//  PayWayDO.h
//  XianMao
//
//  Created by simon cai on 7/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface PayWayDO : JSONModel
@property(nonatomic,assign) NSInteger pay_way;
@property(nonatomic,copy) NSString *pay_name;
@property(nonatomic,copy) NSString *icon_url;
@property (nonatomic, copy) NSString *desc;

- (NSString*)localIconName;
@end


//                                     "pay_way": 0,
//                                     "pay_name": "支付宝支付",
//                                     "icon_url":
