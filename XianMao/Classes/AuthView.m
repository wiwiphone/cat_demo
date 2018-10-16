//
//  AuthView.m
//  XianMao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "AuthView.h"
#import "Masonry.h"
#import "SDWebImageManager.h"
#import <Foundation/NSObject.h>
#import <Foundation/NSDate.h>
#import <CoreFoundation/CFRunLoop.h>
#import "NSDate+Category.h"

#import "OrderInfo.h"

@interface AuthView ()

@property (nonatomic, strong) HighestBidVo *authBidVO;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *recoverPriceLbl;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *promptLbl;
@property (nonatomic, strong) UIButton *timeBtn;
@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,assign) NSInteger goodsLockRemainTime;

@property (nonatomic, assign) long long time;

@end

@implementation AuthView

-(UIButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_timeBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_timeBtn sizeToFit];
    }
    return _timeBtn;
}

-(UILabel *)promptLbl{
    if (!_promptLbl) {
        _promptLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _promptLbl.font = [UIFont systemFontOfSize:12.f];
        _promptLbl.textColor = [UIColor colorWithHexString:@"9e9e9f"];
//        _promptLbl.text = @"已授权，等待买家下单";
        [_promptLbl sizeToFit];
    }
    return _promptLbl;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"c7c7c7"];
    }
    return _lineView;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 15;
    }
    return _iconImageView;
}

-(UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.font = [UIFont systemFontOfSize:13.f];
        _userName.textColor = [UIColor colorWithHexString:@"595757"];
        [_userName sizeToFit];
    }
    return _userName;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:11.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:13.f];
        _priceLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UILabel *)recoverPriceLbl{
    if (!_recoverPriceLbl) {
        _recoverPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _recoverPriceLbl.font = [UIFont systemFontOfSize:11.f];
        _recoverPriceLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_recoverPriceLbl sizeToFit];
    }
    return _recoverPriceLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.iconImageView];
        [self addSubview:self.userName];
        [self addSubview:self.contentLbl];
        [self addSubview:self.priceLbl];
        [self addSubview:self.recoverPriceLbl];
        [self addSubview:self.lineView];
        [self addSubview:self.promptLbl];
        [self addSubview:self.timeBtn];
        
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(remTimer) name:@"remTimer" object:nil];

        
    }
    return self;
}

-(void)remTimer{
    [self.timer invalidate];
}

-(void)timerFired:(NSTimer *)timer{
    if (self.goodsLockRemainTime == 0) {
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.time/1000];
//        NSInteger time = [date minute] * 60;
        NSInteger time = self.time / 1000;
        self.goodsLockRemainTime = time;
    } else {
        self.goodsLockRemainTime -= 1;
//        self.time = self.goodsLockRemainTime * 1000;
    }
    NSLog(@"---%lld", self.time);
    NSLog(@"%ld", self.goodsLockRemainTime);
//    NSLog(@"%lld", self.time);
    
    [self.timeBtn setTitle:[self remainTimeString] forState:UIControlStateNormal];
    if (self.goodsLockRemainTime == 0) {
        [self.timer invalidate];
        self.timer = nil;
        [self.timeBtn setTitle:@"授权超时，请重新授权" forState:UIControlStateNormal];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadAuthView" object:nil];
    }
}

-(void)setUpUI{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(28);
        make.left.equalTo(self.mas_left).offset(17);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.top.equalTo(self.iconImageView.mas_top);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-22);
        make.top.equalTo(self.iconImageView.mas_top);
    }];
    
    [self.recoverPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-22);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(24);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineView.mas_bottom).offset(14);
        make.left.equalTo(self.iconImageView.mas_left);
    }];
    
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.promptLbl.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //适配iOS7.0 布局移动到setUpUI中
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(28);
//        make.left.equalTo(self.mas_left).offset(17);
//        make.width.equalTo(@30);
//        make.height.equalTo(@30);
//    }];
//    
//    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImageView.mas_right).offset(10);
//        make.top.equalTo(self.iconImageView.mas_top);
//    }];
//    
//    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.iconImageView.mas_right).offset(10);
//        make.bottom.equalTo(self.iconImageView.mas_bottom);
//    }];
//    
//    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-22);
//        make.top.equalTo(self.iconImageView.mas_top);
//    }];
//    
//    [self.recoverPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-22);
//        make.bottom.equalTo(self.iconImageView.mas_bottom);
//    }];
//    
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.iconImageView.mas_bottom).offset(24);
//        make.left.equalTo(self.mas_left).offset(15);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.height.equalTo(@1);
//    }];
//    
//    [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.lineView.mas_bottom).offset(14);
//        make.left.equalTo(self.iconImageView.mas_left);
//    }];
//    
//    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.promptLbl.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(-15);
//    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_timer invalidate];
    _timer = nil;
}

- (NSString*)remainTimeString {
    long min = (long)_goodsLockRemainTime/60;
    long sec = (long)_goodsLockRemainTime%60;
    NSLog(@"%ld-------%ld--------%ld", min, sec, self.goodsLockRemainTime);
    
    NSMutableString *minString = nil;
    if (min<10) {
        minString = [NSMutableString stringWithFormat:@"0%ld分",min];
    } else {
        minString = [NSMutableString stringWithFormat:@"%ld分",min];
    }
    NSMutableString *secString = nil;
    if (sec<10) {
        secString = [NSMutableString stringWithFormat:@"0%ld秒",sec];
    } else {
        secString = [NSMutableString stringWithFormat:@"%ld秒",sec];
    }
    return [NSString stringWithFormat:@"%@%@",minString,secString];
}

-(void)getBidVO:(HighestBidVo *)authBidVO andGoodsDetail:(RecoveryGoodsDetail *)goodsDeatil{
    self.authBidVO = authBidVO;
    
    if (authBidVO.orderExpTime > 0) {
        self.time = self.authBidVO.orderExpTime;
    } else {
        self.time = self.authBidVO.authExpTime;
    }
    
    if (authBidVO.payId) {
        self.timeBtn.hidden = YES;
    }
    
    RecoveryUserVo *userVO = authBidVO.recoveryUserVo;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userVO.avatar] placeholderImage:nil];
    self.userName.text = userVO.username;
    self.contentLbl.text = [NSString stringWithFormat:@"成功收货%ld件", userVO.recoveryNum];
    self.priceLbl.text = [NSString stringWithFormat:@"%.2f", authBidVO.price];
    self.recoverPriceLbl.text = @"回收价";
    self.promptLbl.text = goodsDeatil.desc;
    NSLog(@"------------------------------------%lld", self.authBidVO.authExpTime);

    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    [self.timer fire];
//    NSString *time = [NSString stringWithFormat:@"%ld", [date minute]];
    [self setUpUI];
}

@end
