//
//  ActivityInfo.h
//  XianMao
//
//  Created by simon on 2/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RecommendGoodsInfo.h"

@interface ActivityBaseInfo : NSObject <NSCoding>

@property(nonatomic,assign) long long startTime;
@property(nonatomic,assign) long long endTime;
@property(nonatomic,assign) NSInteger remainTime;
@property(nonatomic,assign) BOOL isFinished;

@property(nonatomic,copy) NSString *redirectUri;

@property (nonatomic, assign) CGFloat originShopPrice;
@property (nonatomic, assign) CGFloat activityPrice;

@property(nonatomic,copy) NSString *activityDesc;
@property(nonatomic,assign) NSInteger activityId;
@property(nonatomic,copy) NSString *activityName;
@property(nonatomic,copy) NSString *coverUrl;
@property(nonatomic,assign) NSInteger coverHeight;
@property(nonatomic,assign) NSInteger coverWidth;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (NSString*)remainHoursString;
- (NSString*)remainMinutesString;
- (NSString*)remainSecondsString;

@end

@interface ActivityGoodsInfo : ActivityBaseInfo

@property(nonatomic,strong) RecommendGoodsInfo *recommendGoodsInfo;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

@protocol ActivityInfoManagerObserver;

@interface ActivityInfoManager : NSObject

+ (instancetype)sharedInstance;
- (void)storeData:(ActivityBaseInfo*)activityInfo;
- (void)addObserver:(id<ActivityInfoManagerObserver>)observer;
- (void)removeObserver:(id<ActivityInfoManagerObserver>)observer;
@end

@protocol ActivityInfoManagerObserver <NSObject>
@optional
- (void)activityInfoManagerTickNotification;
@end





