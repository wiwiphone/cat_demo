//
//  RecoverLoadView.m
//  XianMao
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverLoadView.h"
#import "Masonry.h"
#import "NSDate+Category.h"

@interface RecoverLoadView ()


@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *promptLbl;
@property (nonatomic, strong) UIButton *matchBtn;
@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) UIView *smallLineView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *premptLbl;

@end

@implementation RecoverLoadView

-(UILabel *)premptLbl{
    if (!_premptLbl) {
        _premptLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _premptLbl.textColor = [UIColor colorWithHexString:@"9e9e9f"];
        _premptLbl.font = [UIFont systemFontOfSize:14.f];
        _premptLbl.text = @"下拉刷新报价榜";
        [_premptLbl sizeToFit];
    }
    return _premptLbl;
}

-(UILabel *)textLabel{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.text = @"回收商报价";
        _textLabel.font = [UIFont systemFontOfSize:14.f];
        _textLabel.textColor = [UIColor colorWithHexString:@"c2a79d"];
        [_textLabel sizeToFit];
    }
    return _textLabel;
}

-(UIView *)smallLineView{
    if (!_smallLineView) {
        _smallLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _smallLineView.backgroundColor = [UIColor colorWithHexString:@"c7c7c7"];
    }
    return _smallLineView;
}

-(UIButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_timeBtn setImage:[UIImage imageNamed:@"recover_time_MF"] forState:UIControlStateNormal];
        //        [_timeBtn setTitle:@"10分钟" forState:UIControlStateNormal];
        [_timeBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_timeBtn sizeToFit];
    }
    return _timeBtn;
}

-(UIView *)timeView{
    if (!_timeView) {
        _timeView = [[UIView alloc] initWithFrame:CGRectZero];
        _timeView.backgroundColor = [UIColor whiteColor];
    }
    return _timeView;
}

-(UIButton *)matchBtn{
    if (!_matchBtn) {
        _matchBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_matchBtn setTitle:@"自助匹配>>" forState:UIControlStateNormal];
        _matchBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_matchBtn setTitleColor:[UIColor colorWithHexString:@"6b93e1"] forState:UIControlStateNormal];
        [_matchBtn sizeToFit];
    }
    return _matchBtn;
}

-(UILabel *)promptLbl{
    if (!_promptLbl) {
        _promptLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _promptLbl.text = @"收到报价之前，您还可以";
        _promptLbl.font = [UIFont systemFontOfSize:14.f];
        _promptLbl.textColor = [UIColor colorWithHexString:@"9e9e9f"];
        [_promptLbl sizeToFit];
    }
    return _promptLbl;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.text = @"商品信息已推送给回收商，\n"
        "请等待报价...";
        _contentLbl.font = [UIFont systemFontOfSize:14.f];
        _contentLbl.numberOfLines = 0;
        _contentLbl.textColor = [UIColor colorWithHexString:@"9e9e9f"];
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}



-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.contentLbl];
        [self addSubview:self.promptLbl];
        [self addSubview:self.matchBtn];
        [self addSubview:self.timeView];
        [self.timeView addSubview:self.timeBtn];
        [self.timeView addSubview:self.smallLineView];
        [self addSubview:self.textLabel];
        [self addSubview:self.premptLbl];
        
        [self.matchBtn addTarget:self action:@selector(matchPushClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)matchPushClick{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushMatchController" object:nil];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getRecoveryVO:(RecoveryGoodsVo *)goodsVO{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:goodsVO.updatetime/1000];
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%@", [date formattedDateDescription]] forState:UIControlStateNormal];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.timeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@39);
    }];
    
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeView.mas_left).offset(15);
        make.bottom.equalTo(self.timeView.mas_bottom).offset(-8);
        make.width.equalTo(@200);
        make.height.equalTo(@15);
    }];
    
    [self.smallLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeView.mas_left).offset(15);
        make.top.equalTo(self.timeBtn.mas_bottom).offset(10);
        make.right.equalTo(self.timeView.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.smallLineView.mas_bottom).offset(13);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(10);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLbl.mas_bottom).offset(67);
        make.centerX.equalTo(self.mas_centerX).offset(-35);
    }];
    
    [self.matchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.promptLbl.mas_centerY);
        make.left.equalTo(self.promptLbl.mas_right).offset(5);
    }];
    
    [self.premptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.top.equalTo(self.textLabel.mas_top);
    }];
}

@end
