//
//  ReceivePersonCell.m
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReceivePersonCell.h"

@interface ReceivePersonCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *rightLbl;

@property (nonatomic, strong) UILabel *nameSubLbl;
@end

@implementation ReceivePersonCell

-(UILabel *)nameSubLbl{
    if (!_nameSubLbl) {
        _nameSubLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameSubLbl.font = [UIFont systemFontOfSize:15.f];
        _nameSubLbl.textColor = [UIColor colorWithHexString:@"ff752b"];
        [_nameSubLbl sizeToFit];
    }
    return _nameSubLbl;
}

-(UILabel *)rightLbl{
    if (!_rightLbl) {
        _rightLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _rightLbl.font = [UIFont systemFontOfSize:15.f];
        _rightLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_rightLbl sizeToFit];
    }
    return _rightLbl;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:13.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLbl.font = [UIFont systemFontOfSize:15.f];
        _nameLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_nameLbl sizeToFit];
    }
    return _nameLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.cornerRadius = 22;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ReceivePersonCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 72;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(InvitationUserVo *)invUserVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ReceivePersonCell class]];
    if (invUserVo)[dict setObject:invUserVo forKey:@"invUserVo"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nameLbl];
        [self.contentView addSubview:self.contentLbl];
        [self.contentView addSubview:self.rightLbl];
        [self.contentView addSubview:self.nameSubLbl];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.width.equalTo(@44);
        make.height.equalTo(@44);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_centerY).offset(-5);
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_centerY).offset(5);
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
    }];
    
    [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-18);
    }];
    
    [self.nameSubLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLbl.mas_centerY);
        make.left.equalTo(self.nameLbl.mas_right).offset(3);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    InvitationUserVo *invUserVo = dict[@"invUserVo"];
    
    [self.iconImageView setImageWithURL:invUserVo.refUserAvatar placeholderImage:[UIImage imageNamed:@"placeholder_mine_new"] XMWebImageScaleType:XMWebImageScale160x160];
    self.nameLbl.text = invUserVo.typeName;
    self.nameSubLbl.text = invUserVo.refUsername;
    self.contentLbl.text = invUserVo.createtime;
    self.rightLbl.text = [NSString stringWithFormat:@"+%ld", invUserVo.rewardMoney];
    
}

@end
