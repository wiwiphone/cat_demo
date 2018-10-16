//
//  MatchTableViewCell.m
//  XianMao
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MatchTableViewCell.h"
#import "Masonry.h"

@interface MatchTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIButton *chatBtn;
@property (nonatomic, strong) RecommendUser *recommendUser ;

@end

@implementation MatchTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([MatchTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecommendUser*)recommendUser {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[MatchTableViewCell class]];
    if (recommendUser)[dict setObject:recommendUser forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 60;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"recommendUser";
}

-(UIButton *)chatBtn{
    if (!_chatBtn) {
        _chatBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chatBtn setTitle:@"聊一聊" forState:UIControlStateNormal];
        _chatBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_chatBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        _chatBtn.layer.masksToBounds = YES;
        _chatBtn.layer.cornerRadius = 8;
        _chatBtn.layer.borderWidth = 1;
        _chatBtn.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
    }
    return _chatBtn;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:10.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_contentLbl sizeToFit];
//        _contentLbl.text = @"11111";
    }
    return _contentLbl;
}

-(UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.font = [UIFont systemFontOfSize:10.f];
        _userName.textColor = [UIColor colorWithHexString:@"595757"];
        [_userName sizeToFit];
//        _userName.text = @"aa";
    }
    return _userName;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 16;
        _iconImageView.backgroundColor = [UIColor grayColor];
    }
    return _iconImageView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.contentLbl];
        [self.contentView addSubview:self.chatBtn];
        
        [self.chatBtn addTarget:self action:@selector(clickChatBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)clickChatBtn{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushChatBtn" object:self.recommendUser];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(15);
    }];
    
    [self.chatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@70);
        make.height.equalTo(@30);
    }];
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    RecommendUser *recommendUser = dict[@"recommendUser"];
    self.recommendUser = recommendUser;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:recommendUser.avatar] placeholderImage:[UIImage imageNamed:@"login_avatar"]];
    self.userName.text = recommendUser.username;
    self.contentLbl.text = [NSString stringWithFormat:@"成功收货%ld件", recommendUser.recoveryNum];
    
    [self setNeedsLayout];
}

@end
