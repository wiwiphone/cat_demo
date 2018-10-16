//
//  MeowCatVo.h
//  XianMao
//
//  Created by WJH on 17/1/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface MeowCatVo : JSONModel

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger meowNumber;
@property (nonatomic, assign) NSInteger dayMeowNumber;
@property (nonatomic, assign) NSInteger feedCatNum;
@property (nonatomic, assign) NSInteger growth;
@property (nonatomic, assign) NSInteger cycle;
@property (nonatomic, assign) NSInteger gender;//性别 0，美眉； 1，帅猫
@property (nonatomic, copy) NSString * catImg;
@property (nonatomic, copy) NSString * feedDesc;
@property (nonatomic, copy) NSString * addendaDesc;
@property (nonatomic, assign) NSInteger operateType;//操作类型 0，领养新猫 ；1，立即喂食 2，明天再喂 3，开始补喂
@property (nonatomic, copy) NSString * catImgFH;
@property (nonatomic, assign) NSInteger isRemind;//是否喂养提醒 0 ，不提醒  1，提醒


- (NSString *)buttonTitle;
- (BOOL)isNeedRemind;

@end
