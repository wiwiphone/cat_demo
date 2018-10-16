//
//  InviteHeaderTableViewCell.m
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "InviteHeaderTableViewCell.h"

@interface InviteHeaderTableViewCell ()

@property (nonatomic, strong) XMWebImageView *bgImageView;
@property (nonatomic, strong) UIView *iconBgView;
@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UIView *blackView;

@end

@implementation InviteHeaderTableViewCell

-(UIView *)blackView{
    if (!_blackView) {
        _blackView = [[UIView alloc] initWithFrame:CGRectZero];
        _blackView.backgroundColor = [UIColor blackColor];
        _blackView.alpha = 0.5;
    }
    return _blackView;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.cornerRadius = 43;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

-(UIView *)iconBgView{
    if (!_iconBgView) {
        _iconBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _iconBgView.backgroundColor = [UIColor whiteColor];
        _iconBgView.layer.cornerRadius = 45;
        _iconBgView.layer.masksToBounds = YES;
    }
    return _iconBgView;
}

-(XMWebImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
    }
    return _bgImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([InviteHeaderTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 196;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(User *)user
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[InviteHeaderTableViewCell class]];
    if (user)[dict setObject:user forKey:@"user"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.bgImageView];
        [self.bgImageView addSubview:self.blackView];
        [self.bgImageView addSubview:self.iconBgView];
        [self.iconBgView addSubview:self.iconImageView];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.bgImageView);
    }];
    
    [self.iconBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.centerY.equalTo(self.bgImageView.mas_centerY);
        make.width.equalTo(@90);
        make.height.equalTo(@90);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.iconBgView.mas_centerX);
        make.centerY.equalTo(self.iconBgView.mas_centerY);
        make.width.equalTo(@86);
        make.height.equalTo(@86);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    User *user = dict[@"user"];
    [self.bgImageView setImageWithURL:user.frontUrl placeholderImage:[UIImage imageNamed:@"mine_front_default"] size:CGSizeMake(kScreenWidth*2,kScreenWidth*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
    [self.iconImageView setImageWithURL:user.avatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_mine_new"] XMWebImageScaleType:XMWebImageScale160x160];
}

@end
