//
//  InvitationPersonNumCell.m
//  XianMao
//
//  Created by apple on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "InvitationPersonNumCell.h"
#import "Command.h"
#import "CardViewController.h"
#import "URLScheme.h"

@interface InvitationPersonNumCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) CommandButton *cardQuanBtn;
@property (nonatomic, strong) XMWebImageView *quanImageView;
@property (nonatomic, strong) UIButton *quanTitle;
@property (nonatomic, strong) UILabel *quanNumLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *contentMarketLbl;
@property (nonatomic, strong) UILabel *contentLbl1;
@property (nonatomic, strong) CommandButton *shareBtn;
@end

@implementation InvitationPersonNumCell

-(UILabel *)contentLbl1{
    if (!_contentLbl1) {
        _contentLbl1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl1.font = [UIFont systemFontOfSize:12.f];
        _contentLbl1.textColor = [UIColor colorWithHexString:@"999999"];
        [_contentLbl1 sizeToFit];
        _contentLbl1.text = @"标志的商品可用";
    }
    return _contentLbl1;
}

-(UILabel *)contentMarketLbl{
    if (!_contentMarketLbl) {
        _contentMarketLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentMarketLbl.font = [UIFont systemFontOfSize:10.f];
        _contentMarketLbl.textColor = [UIColor colorWithHexString:@"fe2d56"];
        _contentMarketLbl.layer.borderColor = [UIColor colorWithHexString:@"fe2d56"].CGColor;
        _contentMarketLbl.layer.borderWidth = 0.5;
        [_contentMarketLbl sizeToFit];
        _contentMarketLbl.text = @"商城";
        
    }
    return _contentMarketLbl;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:12.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_contentLbl sizeToFit];
        _contentLbl.text = @"标题带";
    }
    return _contentLbl;
}

-(UILabel *)quanNumLbl{
    if (!_quanNumLbl) {
        _quanNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _quanNumLbl.font = [UIFont systemFontOfSize:25.f];
        _quanNumLbl.textColor = [UIColor colorWithHexString:@"ff752b"];
        [_quanNumLbl sizeToFit];
    }
    return _quanNumLbl;
}

-(UIButton *)quanTitle{
    if (!_quanTitle) {
        _quanTitle = [[UIButton alloc] initWithFrame:CGRectZero];
        [_quanTitle setTitle:@" 商城购物券" forState:UIControlStateNormal];
        [_quanTitle setTitleColor:[UIColor colorWithHexString:@"ff752b"] forState:UIControlStateNormal];
        _quanTitle.titleLabel.font = [UIFont systemFontOfSize:20.f];
        [_quanTitle setImage:[UIImage imageNamed:@"Person_Quan_Money"] forState:UIControlStateNormal];
        [_quanTitle sizeToFit];
    }
    return _quanTitle;
}

-(XMWebImageView *)quanImageView{
    if (!_quanImageView) {
        _quanImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _quanImageView.image = [UIImage imageNamed:@"Person_Quan_Image"];
        [_quanImageView sizeToFit];
    }
    return _quanImageView;
}

-(CommandButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _shareBtn.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
        [_shareBtn setTitle:@"分享App给好友" forState:UIControlStateNormal];
        [_shareBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _shareBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _shareBtn.layer.masksToBounds = YES;
        _shareBtn.layer.cornerRadius = 20.f;
    }
    return _shareBtn;
}

-(CommandButton *)cardQuanBtn{
    if (!_cardQuanBtn) {
        _cardQuanBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_cardQuanBtn setTitle:@"查看卡券 >" forState:UIControlStateNormal];
        [_cardQuanBtn setTitleColor:[UIColor colorWithHexString:@"ff752b"] forState:UIControlStateNormal];
        _cardQuanBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
        _cardQuanBtn.layer.masksToBounds = YES;
        _cardQuanBtn.layer.cornerRadius = 5.f;
        _cardQuanBtn.layer.borderColor = [UIColor colorWithHexString:@"ff752b"].CGColor;
        _cardQuanBtn.layer.borderWidth = 1.f;
    }
    return _cardQuanBtn;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([InvitationPersonNumCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 260-40;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(InvitationVo *)invationVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[InvitationPersonNumCell class]];
    if (invationVo)[dict setObject:invationVo forKey:@"invationVo"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.cardQuanBtn];
        [self.contentView addSubview:self.quanImageView];
        [self.quanImageView addSubview:self.quanTitle];
        [self.quanImageView addSubview:self.quanNumLbl];
        [self.quanImageView addSubview:self.contentLbl];
        [self.quanImageView addSubview:self.contentMarketLbl];
        [self.quanImageView addSubview:self.contentLbl1];
//        [self.contentView addSubview:self.shareBtn];
        
        self.cardQuanBtn.handleClickBlock = ^(CommandButton *sender){
            CardViewController *viewController = [[CardViewController alloc] init];
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
        
        self.shareBtn.handleClickBlock = ^(CommandButton *sender){
            UIImage *image = [UIImage imageNamed:@"AppIcon_120"];
            [[CoordinatingController sharedInstance] shareWithTitle:@"给你看个买卖奢侈品的App，很不错哟~"
                                                              image:image
                                                                url:kAppShareUrl
                                                            content:@"权威鉴定、快速出货、奢品顾问、超值特卖。\n爱丁猫·会买奢侈品·Just take it"];
        };
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.cardQuanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.equalTo(@58);
        make.height.equalTo(@20);
    }];
    
    [self.quanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(30);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.quanTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.quanImageView.mas_top).offset(22);
        make.left.equalTo(self.quanImageView.mas_left).offset(22);
    }];
    
    [self.quanNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.quanImageView.mas_right).offset(-22);
        make.centerY.equalTo(self.quanTitle.mas_centerY);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.quanImageView.mas_bottom).offset(-25);
        make.left.equalTo(self.quanImageView.mas_left).offset(22);
    }];
    
    [self.contentMarketLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentLbl.mas_centerY);
        make.left.equalTo(self.contentLbl.mas_right).offset(2);
//        make.width.equalTo(@(self.contentMarketLbl.width+1));
//        make.height.equalTo(@(self.contentMarketLbl.height+1));
    }];
    
    [self.contentLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentLbl.mas_centerY);
        make.left.equalTo(self.contentMarketLbl.mas_right).offset(2);
    }];
    
//    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-30);
//        make.left.equalTo(self.contentView.mas_left).offset(70);
//        make.right.equalTo(self.contentView.mas_right).offset(-70);
//        make.height.equalTo(@40);
//    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    InvitationVo *invtationVo = dict[@"invationVo"];
    self.titleLbl.text = [NSString stringWithFormat:@"我累计邀请%ld人，共获得%ld张券", invtationVo.invite_num, invtationVo.bonus_num];
    self.quanNumLbl.text = [NSString stringWithFormat:@"×%ld", invtationVo.bonus_num];
}

@end
