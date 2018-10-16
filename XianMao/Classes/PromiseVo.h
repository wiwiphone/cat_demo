//
//  PromiseVo.h
//  XianMao
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@protocol  PromiseVo;

@interface PromiseVo : JSONModel

@property (nonatomic, copy) NSString * describe;
@property (nonatomic, copy) NSString * entry;
@property (nonatomic, copy) NSString * url;

@end
