//
//  WithdrawAccountCell.m
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WithdrawAccountCell.h"

@interface WithdrawAccountCell()

@property (nonatomic, strong) XMWebImageView * icon;
@property (nonatomic, strong) UILabel * account;
@property (nonatomic, strong) UILabel * desc;
@property (nonatomic, strong) UIImageView * arrowImg;

@end

@implementation WithdrawAccountCell

-(UIImageView *)arrowImg
{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.image = [UIImage imageNamed:@"arrow_new"];
    }
    return _arrowImg;
}

-(XMWebImageView *)icon
{
    if (!_icon) {
        _icon = [[XMWebImageView alloc] init];
        _icon.layer.masksToBounds = YES;
        _icon.layer.cornerRadius = 15;
    }
    return _icon;
}

-(UILabel *)account
{
    if (!_account) {
        _account = [[UILabel alloc] init];
        _account.font = [UIFont systemFontOfSize:15];
        _account.textColor = [UIColor colorWithHexString:@"434342"];
        [_account sizeToFit];
    }
    return _account;
}

-(UILabel *)desc
{
    if (!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.font = [UIFont systemFontOfSize:12];
        _desc.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_desc sizeToFit];
    }
    return _desc;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([WithdrawAccountCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 60;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(WithdrawalsAccountVo *)WithdrawalsAccountVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[WithdrawAccountCell class]];
    if (WithdrawalsAccountVo) {
        [dict setObject:WithdrawalsAccountVo forKey:[WithdrawAccountCell cellDictForWithdrawalsAccount]];
    }
    return dict;
}

+(NSString *)cellDictForWithdrawalsAccount
{
    return @"withdrawalsAccountVo";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.account];
        [self.contentView addSubview:self.desc];
        [self.contentView addSubview:self.arrowImg];
        
    }
    return self;
}


-(void)updateCellWithDict:(NSDictionary *)dict{
    
    WithdrawalsAccountVo *  withdrawalsAccount = [dict objectForKey:[WithdrawAccountCell cellDictForWithdrawalsAccount]];
    if (withdrawalsAccount.icon.length > 0) {
        [self.icon setImageWithURL:withdrawalsAccount.icon XMWebImageScaleType:XMWebImageScaleNone];
    }
    
    self.account.text = [NSString stringWithFormat:@"%@",withdrawalsAccount.bankName];
    self.desc.text = [NSString stringWithFormat:@"%@",withdrawalsAccount.breviaryAccount];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    
    [self.account mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(15);
        make.bottom.equalTo(self.icon.mas_centerY).offset(5);
    }];
    
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(15);
        make.top.equalTo(self.icon.mas_centerY).offset(5);
    }];
    
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}

@end
