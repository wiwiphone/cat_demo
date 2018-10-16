//
//  WithdrawSucViewController.h
//  yuncangcat
//
//  Created by 阿杜 on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "WithdrawalsAccountVo.h"

@interface WithdrawSucViewController : BaseViewController
@property (nonatomic,strong) WithdrawalsAccountVo * withdrawalsVo;
@property (nonatomic,copy) NSString * WithdrawMoeny;

@end
