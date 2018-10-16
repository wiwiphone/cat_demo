//
//  JDServiceVo.h
//  XianMao
//
//  Created by apple on 16/12/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface JDServiceVo : JSONModel

@property (nonatomic, assign) NSInteger serviceType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) CGFloat fee;
@property (nonatomic, assign) CGFloat originFee;

@end
