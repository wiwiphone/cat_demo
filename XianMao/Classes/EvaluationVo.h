//
//  EvaluationVo.h
//  XianMao
//
//  Created by WJH on 17/2/6.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface EvaluationVo : JSONModel


@property (nonatomic, copy) NSString * desc;
@property (nonatomic, assign) double evaluation_price;

@end
