//
//  AutotrophyVo.h
//  XianMao
//
//  Created by apple on 16/9/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "PromiseVo.h"

@interface AutotrophyVo : JSONModel

@property (nonatomic, strong) NSArray<PromiseVo> *promiseList;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger weight;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, copy) NSString *redirectUrl;

@end

