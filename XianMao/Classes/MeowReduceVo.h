//
//  MeowReduceVo.h
//  XianMao
//
//  Created by apple on 16/12/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface MeowReduceVo : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *goodsSn;
@property (nonatomic, assign) CGFloat meowNumber;
@property (nonatomic, assign) CGFloat meowReducePrice;

@end
