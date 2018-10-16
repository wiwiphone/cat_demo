//
//  LogisticsMessageView.h
//  XianMao
//
//  Created by WJH on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderDetailInfo.h"

@interface LogisticsMessageView : UIView

@property (nonatomic, copy) void(^handleReviseMailSnBlack)();

- (void)getMainInfo:(MailInfo *)mailInfo orderInfo:(OrderInfo *)orderInfo;
- (void)updataAfterRevise:(NSString *)mailCOM mainSN:(NSString *)mainSN;

@end
