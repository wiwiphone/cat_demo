//
//  RecoverTableViewCell.m
//  XianMao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverTableViewCell.h"
#import "Masonry.h"
@interface RecoverTableViewCell ()

@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIButton *authorizeBtn;

@property (nonatomic, strong) RecoveryUserVo *userVO;
@property (nonatomic, strong) HighestBidVo *bidVO;

@end

@implementation RecoverTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoverTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(HighestBidVo*)bidVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoverTableViewCell class]];
    if (bidVO)[dict setObject:bidVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 60;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"bidVO";
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

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.textColor = [UIColor colorWithHexString:@"595757"];
        _contentLbl.font = [UIFont systemFontOfSize:11.f];
        [_contentLbl sizeToFit];
        _contentLbl.text = @"bbbbbbbb";
    }
    return _contentLbl;
}

-(UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.textColor = [UIColor colorWithHexString:@"595757"];
        _userName.font = [UIFont systemFontOfSize:11.f];
        [_userName sizeToFit];
        _userName.text = @"aaaaa";
    }
    return _userName;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 14;
        _iconImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _iconImageView;
}

-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.textColor = [UIColor blackColor];
        _priceLabel.font = [UIFont systemFontOfSize:12.f];
        _priceLabel.textAlignment = NSTextAlignmentLeft;
        [_priceLabel sizeToFit];
        _priceLabel.text = @"3333";
    }
    return _priceLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.priceLabel];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.contentLbl];
        [self.contentView addSubview:self.authorizeBtn];
        
        [self.authorizeBtn addTarget:self action:@selector(clickAuthBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickAuthBtn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushChatController" object:self.bidVO];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pushChatController" object:nil];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@80);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.priceLabel.mas_right).offset(15);
        make.width.equalTo(@28);
        make.height.equalTo(@28);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
    }];
    
    [self.authorizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    HighestBidVo *bidVO = dict[@"bidVO"];
    RecoveryUserVo *userVO = bidVO.recoveryUserVo;
    self.bidVO = bidVO;
    self.userVO = userVO;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userVO.avatar] placeholderImage:nil];
    self.userName.text = userVO.username;
    self.contentLbl.text = [NSString stringWithFormat:@"成功收货%ld件", userVO.recoveryNum];
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元", bidVO.price];
    
    [self setNeedsLayout];
}

@end
