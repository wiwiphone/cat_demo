//
//  ActivityInfo.m
//  XianMao
//
//  Created by simon on 2/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ActivityInfo.h"
#import "ZeroingWeakRef.h"
#import "NetworkAPI.h"
#import "GoodsInfo.h"
#import "SynthesizeSingleton.h"
#import "WeakTimerTarget.h"
#import "NSMutableArray+WeakReferences.h"

@implementation ActivityBaseInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (void)dealloc
{
    
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _startTime = [dict longLongValueForKey:@"start_time" defaultValue:0];
        _endTime = [dict longLongValueForKey:@"end_time" defaultValue:0];
        _remainTime = [dict integerValueForKey:@"remain_time" defaultValue:0];
        _isFinished = [dict integerValueForKey:@"is_finished" defaultValue:0]>0?YES:NO;
        
        _redirectUri = [dict stringValueForKey:@"redirect_uri"];
        
        _activityDesc = [dict stringValueForKey:@"activityDesc"];
        _activityId = [dict integerValueForKey:@"activity_id"];
        _activityName = [dict stringValueForKey:@"activity_name"];
        _coverUrl = [dict stringValueForKey:@"cover"];
        _coverHeight = [dict integerValueForKey:@"cover_height"];
        _coverWidth = [dict integerValueForKey:@"cover_width"];
        
        _originShopPrice = [dict floatValueForKey:@"origin_shop_price"];//日常价
        _activityPrice = [dict floatValueForKey:@"activity_price"];//活动价
        [[ActivityInfoManager sharedInstance] storeData:self];
    }
    return self;
}

//"activity_desc" = "\U4e94\U4e00\U52b3\U52a8\U8282\U4e13\U573a \U7684\U63cf\U8ff0";
//"activity_id" = 1;
//"activity_name" = "\U4e94\U4e00\U52b3\U52a8\U8282\U4e13\U573a";
//cover = "http://aidingmao.qiniudn.com/boss/img/8e568b20-b1b9-11e4-9dda-1344719f94e4.jpg?imageView2/2/w/640";
//"cover_height" = 1200;
//"cover_width" = 1920;
//"end_time" = 1430571132000;
//"is_finished" = 0;
//"redirect_uri" = "http://aidingmao.com/";
//"remain_time" = 726737;
//"start_time" = 1429793782000;

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
}

- (NSString*)remainHoursString {
    NSInteger hours = _remainTime/3600;
    if (hours>99) {
        hours = 99;
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%ld",(long)hours];
    if ([str length]<2) {
        [str insertString:@"0" atIndex:0];
    }
    return str;
}

- (NSString*)remainMinutesString {
    NSInteger mins = (_remainTime%3600)/60;
    if (mins>60) {
        mins = mins;
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%ld",(long)mins];
    if ([str length]<2) {
        [str insertString:@"0" atIndex:0];
    }
    return str;
}

- (NSString*)remainSecondsString {
    NSInteger mins = (_remainTime%3600)%60;
    if (mins>60) {
        mins = mins;
    }
    NSMutableString *str = [[NSMutableString alloc] init];
    [str appendFormat:@"%ld",(long)mins];
    if ([str length]<2) {
        [str insertString:@"0" atIndex:0];
    }
    return str;
}

- (BOOL)updateWithActivityInfo:(ActivityBaseInfo*)other
{
    self.startTime = other.startTime;
    self.endTime = other.endTime;
    self.remainTime = other.remainTime;
    self.isFinished = other.isFinished;
    
    return YES;//always return data changed
}


@end

@implementation ActivityGoodsInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super initWithDict:dict];
    if (self) {
        _recommendGoodsInfo = [RecommendGoodsInfo createWithDict:[dict dictionaryValueForKey:@"goods"]];
    }
    return self;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
}

@end


@interface ActivityInfoManager ()
@property(nonatomic,strong) NSMutableDictionary *itemsDict;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) NSTimer *syncStatusTimer;
@property(nonatomic,strong) HTTPRequest *request;
@property(nonatomic,strong) NSMutableArray *observers;
@end

@implementation ActivityInfoManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ActivityInfoManager, sharedInstance);

- (void)initialize
{
    _itemsDict = [[NSMutableDictionary alloc] initWithCapacity:80];
}

- (void)dealloc
{
     [self stopTimer];
}

- (void)addObserver:(id<ActivityInfoManagerObserver>)observer
{
    if (!_observers) {
        _observers = [NSMutableArray noRetainingArray];
    }
    if (![_observers containsObject:observer]) {
        [_observers addObject:observer];
    }
}

- (void)removeObserver:(id<ActivityInfoManagerObserver>)observer
{
    if (_observers) {
        [_observers removeObject:observer];
    }
}

- (ActivityBaseInfo*)dataForKey:(NSString*)goodsId {
    ZeroingWeakRef *ref = [_itemsDict objectForKey:goodsId];
    id obj = [ref target];
    // clean out keys whose objects have gone away
    if(ref && !obj)
        [_itemsDict removeObjectForKey:goodsId];
    return obj;
}

- (void)storeData:(ActivityBaseInfo*)activityInfo
{
    NSString *key = [NSString stringWithFormat:@"%@",activityInfo];
    if ([key length]>0 && activityInfo) {
        ActivityBaseInfo *tempItem = [self dataForKey:key];
        if (tempItem) {
            if ([tempItem respondsToSelector:@selector(updateWithActivityInfo:)]) {
                [tempItem updateWithActivityInfo:activityInfo];
            }
        } else {
            WEAKSELF;
            ZeroingWeakRef *ref = [ZeroingWeakRef refWithTarget:activityInfo];
            [ref setCleanupBlock:^(id target) {
                [weakSelf.itemsDict removeObjectForKey:key];
                if ([weakSelf.itemsDict count]==0) {
                    [weakSelf stopTimer];
                }
            }];
            [_itemsDict setObject:ref forKey:key];
        }
    }
    
    BOOL hasActivityGoods = NO;
    NSArray *allValues = [_itemsDict allValues];
    for (ZeroingWeakRef *ref in allValues) {
        if ([ref.target isKindOfClass:[ActivityBaseInfo class]]) {
            ActivityBaseInfo *info = (ActivityBaseInfo*)ref.target;
            if (!info.isFinished && info.remainTime>0) {
                hasActivityGoods = YES;
            }
        }
    }
    if (hasActivityGoods) {
        [self startTimer];
    } else {
        [self stopTimer];
    }
}

- (void)startTimer
{
    [_timer invalidate];
    WeakTimerTarget *target = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:target selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
}

- (void)stopTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)onTimer:(NSTimer*)theTimer
{
    BOOL hasActivityGoods = NO;
//
    NSArray *allKeys = [_itemsDict allKeys];
    for (NSString *goodsId in allKeys) {
        ZeroingWeakRef *ref = [_itemsDict objectForKey:goodsId];
        ActivityBaseInfo *info = (ActivityBaseInfo*)ref.target;
        if ([info isKindOfClass:[ActivityBaseInfo class]]) {
            if (!info.isFinished && info.remainTime>0) {
                info.remainTime -= 1;
            }
            if (info.remainTime<=0) {
                info.remainTime=0;
                info.isFinished = YES;
            }
            ///...
            if (!info.isFinished && info.remainTime>0) {
                hasActivityGoods = YES;
            }
        }
    }
    
    if (!hasActivityGoods) {
        [self stopTimer];
    }
    
    if (_observers) {
        for (id<ActivityInfoManagerObserver> observer in _observers) {
            if (observer && [observer respondsToSelector:@selector(activityInfoManagerTickNotification)]) {
                [observer activityInfoManagerTickNotification];
            }
        }
    }
    
}

@end



