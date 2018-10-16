//
//  CertificationModel.h
//  XianMao
//
//  Created by 阿杜 on 16/4/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

//这个是渠道来源数组内部model,不是认证的model,名字错了
@interface CertificationModel : JSONModel

@property (nonatomic, assign) NSString *attr_id;
@property (nonatomic, strong) NSString *attr_value;
//@property (nonatomic, assign) BOOL is_must;

@end
