//
//  ProtocolViewController.h
//  XianMao
//
//  Created by 阿杜 on 16/7/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface ProtocolViewController : BaseViewController

@property (nonatomic,copy) NSString * barTitle;
@property (nonatomic,copy) NSString * orderID;
@property (nonatomic,copy) NSString * type; //type 0:退货协议 1:回购协议

@end
