//
//  ChatHeaderView.m
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ChatHeaderView.h"
#import "Masonry.h"
#import "SDWebImageManager.h"
#import "MainPic.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "WCAlertView.h"
#import "DataSources.h"

@interface ChatHeaderView ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbael;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIButton *authButton;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) RecoveryGoodsVo *goodsVO;
@property (nonatomic, strong) HighestBidVo *bidVO;

@end

@implementation ChatHeaderView

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];
    }
    return _bottomView;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

-(UILabel *)titleLbael{
    if (!_titleLbael) {
        _titleLbael = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbael.font = [UIFont systemFontOfSize:15.f];
        _titleLbael.textColor = [UIColor colorWithHexString:@"595757"];
        [_titleLbael sizeToFit];
    }
    return _titleLbael;
}

-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.font = [UIFont systemFontOfSize:15.f];
        _priceLabel.textColor = [UIColor colorWithHexString:@"595757"];
        [_priceLabel sizeToFit];
    }
    return _priceLabel;
}

-(UIButton *)authButton{
    if (!_authButton) {
        _authButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _authButton.layer.borderWidth = 1;
        _authButton.layer.masksToBounds = YES;
        _authButton.layer.cornerRadius = 5;
        _authButton.layer.borderColor = [UIColor colorWithHexString:@"888888"].CGColor;
        _authButton.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_authButton setTitle:@"卖给他" forState:UIControlStateNormal];
        [_authButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
    }
    return _authButton;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLbael];
        [self addSubview:self.priceLabel];
        [self addSubview:self.authButton];
        [self addSubview:self.bottomView];
        
        [self.authButton addTarget:self action:@selector(clickAuthBtns) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickAuthBtns{
//    WEAKSELF;
    
    
    
//    WCAlertView *alertView = [WCAlertView showAlertWithTitle:@"提示" message:@"确认授权?" customizationBlock:^(WCAlertView *alertView) {
//        
//    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//        
//        if (buttonIndex == 0) {
//            
//        } else {
//            [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getAuthBid:self.goodsVO.goodsSn andUserID:self.bidVO.userId completion:^(NSDictionary *data) {
//                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"finishAuth" object:nil];
//
//            } failure:^(XMError *error) {
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//                [alert show];
//            }]];
//        }
//    } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    [alertView show];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"finishAuth" object:nil];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //适配iOS7.0 布局移动到setUpUI中
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(10);
//        make.left.equalTo(self.mas_left).offset(15);
//        make.width.equalTo(@40);
//        make.height.equalTo(@40);
//    }];
//
//    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.iconImageView.mas_bottom);
//        make.left.equalTo(self.iconImageView.mas_right).offset(10);
//    }];
//    
//    [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.iconImageView.mas_top);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.width.equalTo(@57);
//        make.height.equalTo(@25);
//    }];
//    
//    [self.titleLbael mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.iconImageView.mas_top);
//        make.left.equalTo(self.iconImageView.mas_right).offset(10);
//        make.right.equalTo(self.authButton.mas_left).offset(-50);
//    }];
//    
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.bottom.equalTo(self.mas_bottom);
//        make.right.equalTo(self.mas_right);
//        make.height.equalTo(@5);
//    }];
    
}

-(void)setUpUI{
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_left).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.authButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@57);
        make.height.equalTo(@25);
    }];
    
    [self.titleLbael mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.authButton.mas_left).offset(-50);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@5);
    }];
}

-(void)getHeaderViewGoodsVO:(RecoveryGoodsVo *)goodsVO andBidVO:(HighestBidVo *)bidVO andGoodsDeatil:(RecoveryGoodsDetail *)goodsDetail{
    self.goodsVO = goodsVO;
    self.bidVO = bidVO;
    MainPic *mainPic = goodsVO.mainPic;
    [self.iconImageView setImageWithURL:mainPic.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.titleLbael.text = goodsVO.goodsName;
    self.priceLabel.text = [NSString stringWithFormat:@"%.2f元", bidVO.price];
    if (bidVO.isAuth) {
        [self.authButton setTitle:@"已授权" forState:UIControlStateNormal];
        self.authButton.userInteractionEnabled = NO;
        self.authButton.layer.borderColor = [UIColor colorWithHexString:@"dbdcdc"].CGColor;
        [self.authButton setTitleColor:[UIColor colorWithHexString:@"dcdddd"] forState:UIControlStateNormal];
    } else {
        [self.authButton setTitle:@"卖给他" forState:UIControlStateNormal];
        self.authButton.userInteractionEnabled =YES;
        self.authButton.layer.borderColor = [UIColor colorWithHexString:@"888888"].CGColor;
        [self.authButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
    }
    [self setUpUI];
}

@end
