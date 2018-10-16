//
//  GoodsStatusView.m
//  XianMao
//
//  Created by simon on 3/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "GoodsStatusMaskView.h"
#import "OrderLockInfo.h"
#import "WeakTimerTarget.h"

@interface GoodsStatusMaskView ()
@property(nonatomic,assign) BOOL isCircle;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger goodsLockRemainTime; //默认锁定三分钟
@property(nonatomic,strong) UILabel *timerLbl;
@property(nonatomic,assign) NSInteger timerCounter;
@end

@implementation GoodsStatusMaskView {
    
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (id)init {
    GoodsStatusMaskView *view = [[GoodsStatusMaskView alloc] initWithFrame:CGRectNull];
    return view;
}

- (id)initForCircle:(CGFloat)diameter {
    GoodsStatusMaskView *view = [self initWithFrame:CGRectMake(0, 0, diameter, diameter)];
    view.layer.cornerRadius = diameter/2;
    return view;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _statusLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _statusLbl.textColor = [UIColor whiteColor];
        _statusLbl.font = [UIFont systemFontOfSize:self.width>=90?17.5f:13.5f];
        _statusLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_statusLbl];
        
        _timerLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timerLbl.textColor = [UIColor whiteColor];
        _timerLbl.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:_timerLbl];
        _timerLbl.hidden = YES;
        _timerLbl.textAlignment = NSTextAlignmentCenter;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_statusLbl sizeToFit];
    if ([_timerLbl isHidden]) {
        _statusLbl.frame = CGRectMake((self.width-_statusLbl.width)/2, (self.height-_statusLbl.height)/2, _statusLbl.width, _statusLbl.height);
    } else {
        _statusLbl.frame = CGRectMake((self.width-_statusLbl.width)/2, (self.height-_statusLbl.height)/2-5, _statusLbl.width, _statusLbl.height);
    }
    
    [_timerLbl sizeToFit];
    _timerLbl.frame = CGRectMake(0, _statusLbl.top+_statusLbl.height+2, self.width, _timerLbl.height);
}

- (void)setStatusString:(NSString *)statusString {
    _statusLbl.text = statusString;
    [self setNeedsLayout];
}

- (void)setOrerLockInfo:(OrderLockInfo *)orerLockInfo
{
    [_timer invalidate];
    _timer = nil;
    if (orerLockInfo && orerLockInfo.remainTime>0) {
        _goodsLockRemainTime = orerLockInfo.remainTime;
        
        _timerCounter = 0;
        
        WeakTimerTarget *weakTimerTarget = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:weakTimerTarget selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
        
        _timerLbl.hidden = NO;
        _timerLbl.text = [self remainTimeString];
        [self setNeedsLayout];
    } else {
        _timerLbl.hidden = YES;
    }
    [self setNeedsLayout];
}

- (void)onTimer:(NSTimer*)theTimer
{
    _timerCounter+=200;
    if (_timerCounter>=1000) {
        _timerCounter = 0;
        
        _goodsLockRemainTime -= 1;
        if (_goodsLockRemainTime<=0) {
            _goodsLockRemainTime = 0;
            [_timer invalidate];
            _timer = nil;
            
            _timerLbl.hidden = YES;
            
            if (_delegate && [_delegate respondsToSelector:@selector(goodsStatusMaskViewGoodsUnLocked:)]) {
                [_delegate goodsStatusMaskViewGoodsUnLocked:self];
            }
        }
        
        _timerLbl.text = [self remainTimeString];
    }
}

- (NSString*)remainTimeString {
    long min = (long)_goodsLockRemainTime/60;
    long sec = (long)_goodsLockRemainTime%60;
    NSMutableString *minString = nil;
    if (min<10) {
        minString = [NSMutableString stringWithFormat:@"0%ld分",min];
    } else if (min >= 10 && min <= 60) {
        minString = [NSMutableString stringWithFormat:@"%ld分",min];
    } else {
        minString = [NSMutableString stringWithFormat:@"%ld小时%ld分",min/60, min%60];
    }
    
    NSMutableString *secString = nil;
    if (sec<10) {
        secString = [NSMutableString stringWithFormat:@"0%ld秒",sec];
    } else {
        secString = [NSMutableString stringWithFormat:@"%ld秒",sec];
    }
    return [NSString stringWithFormat:@"%@%@",minString,secString];
}

@end


