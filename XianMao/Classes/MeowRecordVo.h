//
//  MeowRecordVo.h
//  XianMao
//
//  Created by WJH on 16/11/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MeowRecordVo : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger meowNumber;//喵钻数
@property (nonatomic, assign) NSInteger continueSignedDays;//连续签到天数
@property (nonatomic, assign) NSInteger todaySignedType;//0未签到 1已签到
@property (nonatomic, assign) NSInteger dayMeowNumber;//今天签到领取的喵钻数
@property (nonatomic, strong) NSArray * meowRecordDetailList;
@property (nonatomic, assign) NSInteger isRemind; //是否签到提醒 0 ，不提醒  1，提醒


-(instancetype)initWithDict:(NSDictionary *)dict;
+(instancetype)createWithDict:(NSDictionary *)dict;
-(BOOL)todaySignedTypeYesOrNo;
-(BOOL)isNeedRemind;

@end
