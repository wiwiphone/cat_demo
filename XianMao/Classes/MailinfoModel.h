//
//  MailinfoModel.h
//  XianMao
//
//  Created by 阿杜 on 16/7/6.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface MailinfoModel : JSONModel

@property (nonatomic,copy) NSString * mail_sn;
@property (nonatomic,copy) NSString * mail_com;
@property (nonatomic,copy) NSString * mail_type;

@end
