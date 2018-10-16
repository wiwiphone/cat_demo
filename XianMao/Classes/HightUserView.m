//
//  HightUserView.m
//  XianMao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "HightUserView.h"
#import "Masonry.h"
#import "SDWebImageManager.h"
#import "NSDate+Category.h"
#import "RecoveryUserVo.h"

@interface HightUserView ()

@property (nonatomic, strong) UIView *timeView;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) UIView *smallLineView;
@property (nonatomic, strong) UILabel *textLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *moneyLbl;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *authorizeBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *promptLbl;

@property (nonatomic, strong) HighestBidVo *bidVO;
@property (nonatomic, strong) RecoveryGoodsDetail *goodsDetail;
@property (nonatomic, strong) RecoveryGoodsVo *recoverGoodsVO;
@property (nonatomic, strong) RecoveryUserVo *userVO;
@property (nonatomic, strong) UIButton *iconImageBtn;

@end

@implementation HightUserView

-(UIButton *)iconImageBtn{
    if (!_iconImageBtn) {
        _iconImageBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _iconImageBtn;
}

-(UILabel *)promptLbl{
    if (!_promptLbl) {
        _promptLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _promptLbl.text = @"下拉刷新报价榜";
        _promptLbl.font = [UIFont systemFontOfSize:14.f];
        _promptLbl.textColor = [UIColor colorWithHexString:@"dbdcdc"];
        [_promptLbl sizeToFit];
    }
    return _promptLbl;
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

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"c7c7c7"];
    }
    return _lineView;
}

-(UIButton *)authorizeBtn{
    if (!_authorizeBtn) {
        _authorizeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_authorizeBtn setTitle:@"聊一聊" forState:UIControlStateNormal];
        _authorizeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_authorizeBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        _authorizeBtn.layer.masksToBounds = YES;
        _authorizeBtn.layer.cornerRadius = 8;
        _authorizeBtn.layer.borderWidth = 1;
        _authorizeBtn.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
    }
    return _authorizeBtn;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textColor = [UIColor colorWithHexString:@"888888"];
        _contentLabel.font = [UIFont systemFontOfSize:10.f];
        [_contentLabel sizeToFit];
        
    }
    return _contentLabel;
}

-(UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLabel.textColor = [UIColor colorWithHexString:@"595757"];
        _nameLabel.font = [UIFont systemFontOfSize:13.f];
        [_nameLabel sizeToFit];
        
    }
    return _nameLabel;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 23;
        _iconImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _iconImageView;
}

-(UILabel *)moneyLbl{
    if (!_moneyLbl) {
        _moneyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _moneyLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _moneyLbl.font = [UIFont systemFontOfSize:18.f];
//        _moneyLbl.text = @"5200元";
        [_moneyLbl sizeToFit];
    }
    return _moneyLbl;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor colorWithHexString:@"595757"];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLabel];
        [self addSubview:self.moneyLbl];
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.contentLabel];
        [self addSubview:self.authorizeBtn];
        [self addSubview:self.lineView];
        
        [self addSubview:self.timeView];
        [self.timeView addSubview:self.timeBtn];
        [self.timeView addSubview:self.smallLineView];
        [self addSubview:self.textLabel];
        [self addSubview:self.promptLbl];
        [self addSubview:self.iconImageBtn];
        
        [self.iconImageBtn addTarget:self action:@selector(clickAuthorize) forControlEvents:UIControlEventTouchUpInside];
        [self.authorizeBtn addTarget:self action:@selector(clickAuthorize) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickAuthorize{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushChatController" object:self.bidVO];
}

-(void)setData{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.recoverGoodsVO.updatetime/1000];
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%@", [date formattedDateDescription]] forState:UIControlStateNormal];
    self.moneyLbl.text = [NSString stringWithFormat:@"%.2f元", self.bidVO.price];
    self.titleLabel.text = [NSString stringWithFormat:@"共收到%ld次报价，当前最高报价：", self.goodsDetail.total_bid_num];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.userVO.avatar] placeholderImage:[UIImage imageNamed:@"login_avatar"]];
    self.nameLabel.text = self.userVO.username;//_nameLabel.text = @"米兰购";
    self.contentLabel.text = [NSString stringWithFormat:@"成功收货%ld件", self.userVO.recoveryNum];
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
    
    [self.promptLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.textLabel.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textLabel.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
    }];
    
    [self.moneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moneyLbl.mas_bottom).offset(15);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@46);
        make.height.equalTo(@46);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(12);
        make.centerX.equalTo(self.mas_centerX).offset(-63);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(5);
        make.left.equalTo(self.nameLabel.mas_left);
    }];
    
    [self.authorizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(12);
        make.centerX.equalTo(self.mas_centerX).offset(45);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
    [self.iconImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_left);
        make.right.equalTo(self.iconImageView.mas_right);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
    }];
}

-(void)getHighUser:(HighestBidVo *)bidVO andGoodsDetail:(RecoveryGoodsDetail *)goodsDetail andRecoveryVO:(RecoveryGoodsVo *)goodsVO  andDict:(NSDictionary *)dict{
    self.bidVO = bidVO;
    self.goodsDetail = goodsDetail;
    self.recoverGoodsVO = goodsVO;
    
    NSDictionary *userDict = dict[@"highestBidVo"];
    if (userDict != nil) {
        RecoveryUserVo *userVO = [[RecoveryUserVo alloc] initWithJSONDictionary:[userDict dictionaryValueForKey:@"recoveryUserVo"]];
        self.userVO = userVO;
        NSLog(@"%@", userVO.avatar);
    }
    [self setData];
}

@end
