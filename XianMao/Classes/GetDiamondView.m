//
//  GetDiamondView.m
//  XianMao
//
//  Created by WJH on 16/11/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GetDiamondView.h"
#import "Command.h"
#import "NetworkManager.h"
#import "Session.h"
#import "MeowUserSignVo.h"
#import "WebViewController.h"
#import "AnimatedGIFImageSerialization.h"



NSString *const kGetDiamondView = @"kGetDiamondView";

@interface GetDiamondView()

@property (nonatomic, strong) CommandButton * receiveBtn;
@property (nonatomic, strong) UIView * contentView;
@property (nonatomic, strong) UILabel * descLbl;
@property (nonatomic, strong) UILabel * growUpLbl;
@property (nonatomic, strong) UIImageView * growUpIcon;
@property (nonatomic, strong) UILabel * growUpNum;
@property (nonatomic, strong) UIImageView * catImg;
@property (nonatomic, strong) TapDetectingImageView * closeBtn;
@property (nonatomic, strong) MeowCatVo * meowCatVo;

@end

@implementation GetDiamondView


-(CommandButton *)receiveBtn
{
    if (!_receiveBtn) {
        _receiveBtn = [[CommandButton alloc] init];
        _receiveBtn.layer.masksToBounds = YES;
        _receiveBtn.layer.cornerRadius = 25;
        _receiveBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _receiveBtn.backgroundColor = [UIColor colorWithHexString:@"f4433e"];
        [_receiveBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    }
    return _receiveBtn;
}

-(TapDetectingImageView *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[TapDetectingImageView alloc] init];
        _closeBtn.image = [UIImage imageNamed:@"closeBtn_wjh_new"];
    }
    return _closeBtn;
}

-(UILabel *)growUpLbl{
    if (!_growUpLbl) {
        _growUpLbl = [[UILabel alloc] init];
        _growUpLbl.text = @"成长值";
        _growUpLbl.font = [UIFont systemFontOfSize:15];
        _growUpLbl.textColor = [UIColor colorWithHexString:@"7e7e7e"];
        [_growUpLbl sizeToFit];
    }
    return _growUpLbl;
}

-(UIImageView *)growUpIcon{
    if (!_growUpIcon) {
        _growUpIcon = [[UIImageView alloc] init];
        _growUpIcon.image = [UIImage imageNamed:@"growUpIcon"];
    }
    return _growUpIcon;
}

-(UILabel *)growUpNum{
    if (!_growUpNum) {
        _growUpNum = [[UILabel alloc] init];
        _growUpNum.font = [UIFont systemFontOfSize:15];
        _growUpNum.textColor = [UIColor colorWithHexString:@"ffb11f"];
        [_growUpNum sizeToFit];
    }
    return _growUpNum;
}

-(UIImageView *)catImg{
    if (!_catImg) {
        _catImg = [[UIImageView alloc] init];
        _catImg.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _catImg;
}

-(UILabel *)descLbl
{
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] init];
        _descLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        _descLbl.font = [UIFont systemFontOfSize:15];
        _descLbl.numberOfLines = 0;
        _descLbl.textAlignment = NSTextAlignmentCenter;
        [_descLbl sizeToFit];
    }
    return _descLbl;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.8f];
        [self drawView];
        
        
        WEAKSELF;
        self.closeBtn.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer){
            [weakSelf dismissGetDiamondView];
        };
        
        
        //立即领取喵钻
        self.receiveBtn.handleClickBlock = ^(CommandButton * sender){
//            NSInteger userId = [Session sharedInstance].currentUserId;
//            NSDictionary * params = @{@"user_id":[NSNumber numberWithInteger:userId]};
//            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"meow" path:@"user_sign" parameters:params completionBlock:^(NSDictionary *data) {
//                MeowUserSignVo * userSignVo = [MeowUserSignVo createWithDict:data[@"Record"]];
//                if (userSignVo) {
//                    weakSelf.descLbl.text = [NSString stringWithFormat:@"领取成功,\n您攒了%ld个喵钻啦",userSignVo.meowNumber];
//                    [weakSelf.receiveBtn setTitle:@"进去看看   >" forState:UIControlStateNormal];
//                    if (userSignVo.signType == 1) {
//                        weakSelf.receiveBtn.handleClickBlock =^(CommandButton *sender){
//                            [UIView animateWithDuration:0.3f animations:^{
//                                weakSelf.alpha = 0;
//                            } completion:^(BOOL finished) {
//                                [weakSelf removeFromSuperview];
//                                WebViewController * webView = [[WebViewController alloc] init];
//                                webView.url = [NSString stringWithFormat:@"http://m.aidingmao.com/meow"];
//                                [[CoordinatingController sharedInstance] pushViewController:webView animated:YES];
//                            }];
//                        };
//                    }
//                    
//                }
//                
//            } failure:^(XMError *error) {
//                [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8 forView:[UIApplication sharedApplication].keyWindow];
//            } queue:nil]];
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf removeFromSuperview];
                WebViewController * webView = [[WebViewController alloc] init];
                webView.url = [NSString stringWithFormat:@"http://m.aidingmao.com/meow"];
                [[CoordinatingController sharedInstance] pushViewController:webView animated:YES];
            }];
        };
        
    }
    return self;
}

-(void)drawView{
    
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor whiteColor];
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.cornerRadius = 10;
        [self addSubview:self.contentView];
        
        [self.contentView addSubview:self.growUpLbl];
        [self.contentView addSubview:self.growUpIcon];
        [self.contentView addSubview:self.growUpNum];
        [self.contentView addSubview:self.catImg];
        [self.contentView addSubview:self.descLbl];
        [self.contentView addSubview:self.receiveBtn];
        [self addSubview:self.closeBtn];
        [self customUI];
    }
    
}


- (void)dismissGetDiamondView {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

+(BOOL)isNeedShowGetDiamondView
{
    BOOL isFirstStart = NO;
    NSDate *lastTime =  [[NSUserDefaults standardUserDefaults] objectForKey:kGetDiamondView];
    BOOL result = [GetDiamondView compareDate:lastTime];
    if (result == YES || lastTime == nil)
    {
        isFirstStart = YES;
    }
    
    return isFirstStart;
}

+ (BOOL)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return NO;
    } else{
        return YES;
    }
}

-(void)showGetDiamondView:(MeowCatVo *)meowCatVo
{
    _meowCatVo = meowCatVo;
    if (meowCatVo) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kGetDiamondView];
        NSDate * BeiJingDate = [[NSDate date] dateByAddingTimeInterval:8*60*60];
        [[NSUserDefaults standardUserDefaults] setObject:BeiJingDate forKey:kGetDiamondView];
        if (meowCatVo.growth > 0) {
            _growUpNum.text = [NSString stringWithFormat:@"%ld/%ld",(long)meowCatVo.growth,meowCatVo.cycle];
            _growUpNum.hidden = NO;
            _growUpLbl.hidden = NO;
            _growUpIcon.hidden = NO;
        }else{
            _growUpNum.hidden = YES;
            _growUpLbl.hidden = YES;
            _growUpIcon.hidden = YES;
        }
        
        _descLbl.text = meowCatVo.feedDesc;
        NSString * buttonTitle = [meowCatVo buttonTitle];
        [_receiveBtn setTitle:buttonTitle forState:UIControlStateNormal];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            UIImage * image = UIImageWithAnimatedGIFData([NSData dataWithContentsOfURL:[NSURL URLWithString:meowCatVo.catImg]], 1, 0, nil);
            dispatch_async(dispatch_get_main_queue(), ^{
                _catImg.image = image;
            });
        });
        
    }
    [[CoordinatingController sharedInstance].mainViewController.view addSubview:self];
    
}

-(void)customUI
{
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*318, 380));
    }];

    [self.growUpLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    
    [self.growUpIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.growUpLbl.mas_right).offset(10);
    }];
    
    [self.growUpNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.growUpIcon.mas_right).offset(10);
    }];
    
    [self.catImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(30);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*290, 200*(kScreenWidth/375*290)/290));
    }];
    
    [self.receiveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*198, 50));
    }];
    
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentView.mas_bottom).offset(40);
    }];
    
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.catImg.mas_bottom).offset(5);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
}

@end

