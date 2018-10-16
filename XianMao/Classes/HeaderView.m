//
//  HeaderView.m
//  XianMao
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "HeaderView.h"
#import "RecoveryGoodsVo.h"

#import "RecoverLoadView.h"
#import "HightUserView.h"
#import "AuthView.h"

#import "Masonry.h"
#import "SDWebImageManager.h"
#import "NSDate+Category.h"
#import "DataSources.h"
@interface HeaderView ()

@property (nonatomic, strong) XMWebImageView *goodsButton;
@property (nonatomic, strong) UILabel *goodsTagBtnNew;
@property (nonatomic, strong) UILabel *explainBtn;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) RecoverLoadView *recoverLoadView;
@property (nonatomic, strong) HightUserView *userView;
@property (nonatomic, strong) AuthView *authView;
@property (nonatomic, strong) UIButton *authClickBtn;

@property (nonatomic, strong) RecoveryGoodsVo *recoveryGoodsVO;
@property (nonatomic, strong) HighestBidVo *bigVO;
@property (nonatomic, strong) RecoveryGoodsDetail *goodsDetail;
@property (nonatomic, strong) HighestBidVo *authBidVO;

@end

@implementation HeaderView

-(UIButton *)authClickBtn{
    if (!_authClickBtn) {
        _authClickBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _authClickBtn;
}

-(AuthView *)authView{
    if (!_authView) {
        _authView = [[AuthView alloc] initWithFrame:CGRectZero];
    }
    return _authView;
}

-(HightUserView *)userView{
    if (!_userView) {
        _userView = [[HightUserView alloc] initWithFrame:CGRectZero];
    }
    return _userView;
}

-(RecoverLoadView *)recoverLoadView{
    if (!_recoverLoadView) {
        _recoverLoadView = [[RecoverLoadView alloc] initWithFrame:CGRectZero];
    }
    return _recoverLoadView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];
    }
    return _lineView;
}

-(UILabel *)explainBtn{
    if (!_explainBtn) {
        _explainBtn = [[UILabel alloc] initWithFrame:CGRectZero];
//        _explainBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
//        [_explainBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
//        [_explainBtn setTitle:@"explain" forState:UIControlStateNormal];
        _explainBtn.font = [UIFont systemFontOfSize:15.f];
//        _explainBtn.text = @"explain";
        _explainBtn.numberOfLines = 0;
        _explainBtn.textColor = [UIColor colorWithHexString:@"595757"];
        [_explainBtn sizeToFit];
        
    }
    return _explainBtn;
}

-(UILabel *)goodsTagBtnNew{
    if (!_goodsTagBtnNew) {
        _goodsTagBtnNew = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsTagBtnNew.font = [UIFont systemFontOfSize:15.f];
//        _goodsTagBtnNew.text = @"98成新";
        _goodsTagBtnNew.numberOfLines = 0;
        _goodsTagBtnNew.textColor = [UIColor colorWithHexString:@"595757"];
        [_goodsTagBtnNew sizeToFit];
    }
    return _goodsTagBtnNew;
}

-(XMWebImageView *)goodsButton{
    if (!_goodsButton) {
        _goodsButton = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _goodsButton.userInteractionEnabled = YES;
        _goodsButton.contentMode = UIViewContentModeScaleAspectFill;
        _goodsButton.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _goodsButton.clipsToBounds = YES;
    }
    return _goodsButton;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.goodsButton];
        [self addSubview:self.goodsTagBtnNew];
        [self addSubview:self.explainBtn];
        [self addSubview:self.lineView];
        [self addSubview:self.authView];
        [self.authView addSubview:self.authClickBtn];
            NSLog(@"%@", self.subviews);
        [self.authClickBtn addTarget:self action:@selector(clickAuthClickBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickAuthClickBtn{
    if ([self.headerDelegate respondsToSelector:@selector(pushChatViewController:)]) {
        [self.headerDelegate pushChatViewController:self.authBidVO];
    }
}

-(void)setUI{
    
    [self.goodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20.f);
        make.left.equalTo(self.mas_left).offset(25.f);
        make.height.equalTo(@90);
        make.width.equalTo(@90);
    }];
    
    [self.goodsTagBtnNew mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsButton.mas_top);
        make.left.equalTo(self.goodsButton.mas_right).offset(15.f);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@42);
    }];
    
    [self.explainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsTagBtnNew.mas_bottom).offset(6.f);
        make.left.equalTo(self.goodsTagBtnNew.mas_left);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@42);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsButton.mas_bottom).offset(20);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@5);
    }];
    
    if (self.authBidVO) {
//        这里有点问题，稍后在写（跳转到授权回收商页面）已解决
        self.authView.hidden = NO;
        self.userView.hidden = YES;
        
    } else {
        if (self.bigVO.userId) {
            [self addSubview:self.userView];
            self.userView.hidden = NO;
            self.recoverLoadView.hidden = YES;
            self.authView.hidden = YES;
        } else {
            [self addSubview:self.recoverLoadView];
            self.recoverLoadView.hidden = NO;
            self.authView.hidden = YES;
            self.userView.hidden = NO;
        }
    }
    
    if (self.authBidVO) {
        [self.authView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@122);
        }];
        
        [self.authClickBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@122);
        }];
        
    } else {
        if (self.bigVO.userId) {
            [self.userView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lineView.mas_bottom);
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.bottom.equalTo(self.mas_bottom);
            }];
        } else {
            [self.recoverLoadView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lineView.mas_bottom);
                make.left.equalTo(self.mas_left);
                make.right.equalTo(self.mas_right);
                make.bottom.equalTo(self.mas_bottom);
            }];
        }
    }
    [self setNeedsDisplay];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.authView layoutSubviews];
    [self.recoverLoadView layoutSubviews];
    [self.userView layoutSubviews];
    //适配iOS7.0 布局移动到setUpUI中
//    [self.goodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top).offset(20.f);
//        make.left.equalTo(self.mas_left).offset(25.f);
//        make.height.equalTo(@90);
//        make.width.equalTo(@90);
//    }];
//    
//    [self.goodsTagBtnNew mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.goodsButton.mas_top);
//        make.left.equalTo(self.goodsButton.mas_right).offset(15.f);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.height.equalTo(@42);
//    }];
//    
//    [self.explainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.goodsTagBtnNew.mas_bottom).offset(6.f);
//        make.left.equalTo(self.goodsTagBtnNew.mas_left);
//        make.right.equalTo(self.mas_right).offset(-15);
//        make.height.equalTo(@42);
//    }];
//    
//    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.goodsButton.mas_bottom).offset(20);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.height.equalTo(@5);
//    }];
    
}

-(void)getRecoveryGoodsVO:(RecoveryGoodsVo *)recoveryGoodsVo andMianPic:(MainPic *)mainPic andBigVO:(HighestBidVo *)bigVO andGoodsDetail:(RecoveryGoodsDetail *)goodsDetail andDict:(NSDictionary *)dict{
    self.goodsTagBtnNew.text = recoveryGoodsVo.goodsName;
    self.explainBtn.text = recoveryGoodsVo.goodsBrief;
    [self.goodsButton setImageWithURL:mainPic.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.recoveryGoodsVO = recoveryGoodsVo;
    self.bigVO = bigVO;
    RecoveryGoodsDetail *recoverGoodsDetail = [[RecoveryGoodsDetail alloc] initWithJSONDictionary:dict];
    self.goodsDetail = recoverGoodsDetail;
    
    HighestBidVo *authBidVO = [[HighestBidVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"authBidVo"]];
    self.authBidVO = authBidVO;
    
    if (authBidVO) {

        [self.authView getBidVO:authBidVO andGoodsDetail:recoverGoodsDetail];
        
    } else {
        if (self.bigVO.userId) {
            [self.userView getHighUser:bigVO andGoodsDetail:recoverGoodsDetail andRecoveryVO:recoveryGoodsVo andDict:dict];
        } else {
            [self.recoverLoadView getRecoveryVO:recoveryGoodsVo];
        }
    }
    
    [self setUI];
    [self setNeedsDisplay];
}

@end
