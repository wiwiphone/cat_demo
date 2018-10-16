//
//  RemindingPublishView.m
//  XianMao
//
//  Created by WJH on 16/10/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RemindingPublishView.h"


NSString *const remindingPublishTime = @"remindingPublishTime";

@interface RemindingPublishView()
@property (nonatomic, strong) UILabel * remindingLbl;
@property (nonatomic, strong) UIButton * tapCloseBtn;

@end

@implementation RemindingPublishView


-(UILabel *)remindingLbl
{
    if (!_remindingLbl) {
        _remindingLbl = [[UILabel alloc] init];
        _remindingLbl.text = @"发布你的闲置\n奢侈品";
        _remindingLbl.font = [UIFont systemFontOfSize:14];
        _remindingLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _remindingLbl.textAlignment = NSTextAlignmentCenter;
        _remindingLbl.numberOfLines = 0;
        [_remindingLbl sizeToFit];
    }
    return _remindingLbl;
}

-(UIButton *)tapCloseBtn
{
    if (!_tapCloseBtn) {
        _tapCloseBtn = [[UIButton alloc] init];
    }
    return _tapCloseBtn;
}


-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.image = [UIImage imageNamed:@"RemindingImage"];
        self.userInteractionEnabled = YES;
        [self addSubview:self.remindingLbl];
        [self addSubview:self.tapCloseBtn];
        
        [self.tapCloseBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventAllTouchEvents];
    }
    return self;
}

-(void)closeBtnClick
{
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:remindingPublishTime];
    NSDate * BeiJingDate = [[NSDate date] dateByAddingTimeInterval:8*60*60];
    [[NSUserDefaults standardUserDefaults] setObject:BeiJingDate forKey:remindingPublishTime];
}

+(BOOL)isNeedShowRemindingPublishView
{
    BOOL isFirstStart = NO;
    NSDate *lastTime =  [[NSUserDefaults standardUserDefaults] objectForKey:remindingPublishTime];
    NSDate *compare = [lastTime dateByAddingTimeInterval:60*60*24*3];
    NSDate *nowDate = [[NSDate date] dateByAddingTimeInterval:8*60*60];
    NSComparisonResult result = [compare compare:nowDate];
    if (result == NSOrderedAscending || lastTime == nil)
    {
        isFirstStart = YES;
    }

    return isFirstStart;
}

-(void)layoutSubviews
{
   [self.remindingLbl mas_makeConstraints:^(MASConstraintMaker *make) {
       make.center.equalTo(self);
   }];
    
    [self.tapCloseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.size.mas_equalTo(CGSizeMake(80, 80));
    }];
}

@end
