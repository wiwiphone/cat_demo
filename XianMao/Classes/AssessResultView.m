//
//  AssessResultView.m
//  XianMao
//
//  Created by apple on 17/1/20.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "AssessResultView.h"
#import "Command.h"
#import "DZ_ScaleCircle.h"

@interface AssessResultView ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) XMWebImageView *iconPicView;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIView *whiteView;
@property (nonatomic, strong) CommandButton *publishSendSale;
@property (nonatomic, strong) CommandButton *goonHappy;
@property (nonatomic, strong) UILabel *bottomContentLbl;
@property (nonatomic, strong) XMWebImageView *handImageView;
@property (nonatomic, strong) XMWebImageView *questionImageView;
@property (nonatomic, strong) UIImageView * resultImageView;
@property (nonatomic, strong) UIImageView *scaleView;
@property (nonatomic, strong) UILabel *scaleLbl;
@property (nonatomic, strong) UILabel *EvaluationPrice;

@end

@implementation AssessResultView

-(XMWebImageView *)questionImageView{
    if (!_questionImageView) {
        _questionImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _questionImageView.image = [UIImage imageNamed:@"assess_question"];
        [_questionImageView sizeToFit];
    }
    return _questionImageView;
}

-(UIImageView *)resultImageView{
    if (!_resultImageView) {
        _resultImageView = [[UIImageView alloc] init];
        _resultImageView.backgroundColor = [UIColor redColor];
        _resultImageView.contentMode =  UIViewContentModeScaleAspectFill;
        _resultImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _resultImageView.clipsToBounds  = YES;
    }
    return _resultImageView;
}

-(XMWebImageView *)handImageView{
    if (!_handImageView) {
        _handImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _handImageView.image = [UIImage imageNamed:@"assess_hand"];
        [_handImageView sizeToFit];
    }
    return _handImageView;
}

-(UILabel *)scaleLbl{
    if (!_scaleLbl) {
        _scaleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _scaleLbl.font = [UIFont boldSystemFontOfSize:15.f];
        _scaleLbl.textColor = [UIColor colorWithHexString:@"000000"];
        [_scaleLbl sizeToFit];

    }
    return _scaleLbl;
}

-(UILabel *)bottomContentLbl{
    if (!_bottomContentLbl) {
        _bottomContentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottomContentLbl.font = [UIFont systemFontOfSize:15.f];
        _bottomContentLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_bottomContentLbl sizeToFit];
        _bottomContentLbl.text = @"数据仅供趣味参考，建议询价寄卖";
    }
    return _bottomContentLbl;
}

-(CommandButton *)goonHappy{
    if (!_goonHappy) {
        _goonHappy = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_goonHappy setTitle:@"换个好货继续估价" forState:UIControlStateNormal];
        [_goonHappy setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _goonHappy.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _goonHappy.backgroundColor = [UIColor clearColor];
        _goonHappy.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        _goonHappy.layer.borderWidth = 1.f;
        _goonHappy.layer.masksToBounds = YES;
        _goonHappy.layer.cornerRadius = 20;
    }
    return _goonHappy;
}

-(CommandButton *)publishSendSale{
    if (!_publishSendSale) {
        _publishSendSale = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_publishSendSale setTitle:@"发布寄卖" forState:UIControlStateNormal];
        [_publishSendSale setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _publishSendSale.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _publishSendSale.backgroundColor = [UIColor colorWithHexString:@"000000"];
        _publishSendSale.layer.masksToBounds = YES;
        _publishSendSale.layer.cornerRadius = 20;
    }
    return _publishSendSale;
}

-(UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:CGRectZero];
        _whiteView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _whiteView.layer.masksToBounds = YES;
        _whiteView.layer.cornerRadius = 10;
    }
    return _whiteView;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:14.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_contentLbl sizeToFit];
        _contentLbl.text = @"小喵保守估算，这货能值这个数：";
    }
    return _contentLbl;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _scrollView;
}

-(XMWebImageView *)iconPicView{
    if (!_iconPicView) {
        _iconPicView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconPicView.image = [UIImage imageNamed:@"drawAround_small"];
    }
    return _iconPicView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    }
    return _bottomView;
}

-(UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        _topView.backgroundColor = [UIColor colorWithHexString:@"ffdd39"];
    }
    return _topView;
}

-(UILabel *)EvaluationPrice{
    if (!_EvaluationPrice) {
        _EvaluationPrice = [[UILabel alloc] init];
        _EvaluationPrice.font = [UIFont systemFontOfSize:14];
        _EvaluationPrice.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_EvaluationPrice sizeToFit];
        _EvaluationPrice.textAlignment = NSTextAlignmentCenter;
        _EvaluationPrice.numberOfLines = 0;
    }
    return _EvaluationPrice;
}

-(instancetype)init{
    if (self = [super init]) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.topView];
        [self.scrollView addSubview:self.bottomView];
        [self.topView addSubview:self.iconPicView];
        [self.topView addSubview:self.contentLbl];
        [self.topView addSubview:self.whiteView];
        [self.topView addSubview:self.handImageView];
        [self.topView addSubview:self.questionImageView];
        
        [self.bottomView addSubview:self.publishSendSale];
        [self.bottomView addSubview:self.goonHappy];
        [self.bottomView addSubview:self.bottomContentLbl];
        [self.iconPicView addSubview:self.resultImageView];
        
        self.scaleView = [[UIImageView alloc] initWithFrame:CGRectMake((kScreenWidth-112)/2-10, 17, 112, 112)];
        //  四个区域的颜色
        self.scaleView.image = [UIImage imageNamed:@"scaleView_bg"];
        [self.whiteView addSubview:self.scaleView];
        [self.whiteView addSubview:self.scaleLbl];
        [self.scaleView addSubview:self.EvaluationPrice];
        
        WEAKSELF;
        self.goonHappy.handleClickBlock = ^(CommandButton * sender){
            if (weakSelf.handAssessAgainBlcok) {
                weakSelf.handAssessAgainBlcok();
            }
        };
        
        self.publishSendSale.handleClickBlock = ^(CommandButton * sender){
            if (weakSelf.handSaleActionBlock) {
                weakSelf.handSaleActionBlock();
            }
        };
        

    }
    return self;
}


- (void)getAssessResultInfo:(EvaluationVo *)evaluationVo image:(UIImage *)image{
    
    
    if (image) {
        self.resultImageView.image = image;
        
    }
    _scaleLbl.text = evaluationVo.desc;
    _EvaluationPrice.text = [NSString stringWithFormat:@"¥\n%.2f\n保守价",evaluationVo.evaluation_price];
    //    NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:_EvaluationPrice.text];
    //    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    //    [paragraphStyle1 setLineSpacing:5.0];
    //    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [_EvaluationPrice.text length])];
    //    [_EvaluationPrice setAttributedText:attributedString1];
    [self layoutSubviews];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];

    [self.EvaluationPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.scaleView);
    }];
    
    if (self.isNotFound) {
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(407));
        }];
    } else {
        [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.scrollView.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(464));
        }];
    }
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(20);
    }];
    
    if (self.isNotFound) {
        [self.iconPicView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_top).offset(55);
            make.centerX.equalTo(self.topView.mas_centerX);
            make.width.equalTo(@276);
            make.height.equalTo(@267);
        }];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconPicView.mas_bottom).offset(30);
            make.centerX.equalTo(self.topView.mas_centerX);
        }];
        
        [self.questionImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.topView.mas_left).offset(35);
            make.bottom.equalTo(self.topView.mas_bottom).offset(-30);
        }];
    } else {
        [self.iconPicView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topView.mas_top).offset(25);
            make.centerX.equalTo(self.topView.mas_centerX);
            make.width.equalTo(@216);
            make.height.equalTo(@209);
        }];
        
        [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconPicView.mas_bottom).offset(14);
            make.centerX.equalTo(self.topView.mas_centerX);
        }];
    }
    
    
    
    if (self.isNotFound) {
        [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.iconPicView.mas_centerX).offset(-5);
            make.centerY.equalTo(self.iconPicView.mas_centerY).offset(-5);
            make.size.mas_equalTo(CGSizeMake(276 - 50, 267 - 50));
        }];
    }else{
        [self.resultImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.iconPicView.mas_centerX).offset(-5);
            make.centerY.equalTo(self.iconPicView.mas_centerY).offset(-5);
            make.size.mas_equalTo(CGSizeMake(216 - 50, 209 - 50));
        }];
    }
    
    
    [self.whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentLbl.mas_bottom).offset(15);
        make.left.equalTo(self.topView.mas_left).offset(10);
        make.right.equalTo(self.topView.mas_right).offset(-10);
        make.bottom.equalTo(self.topView.mas_bottom).offset(-15);
    }];
    
    if (self.isNotFound) {
        [self.handImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topView.mas_right);
            make.bottom.equalTo(self.topView.mas_bottom);
        }];
    } else {
        [self.handImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topView.mas_right);
            make.centerY.equalTo(self.topView.mas_centerY);
        }];
    }
    
    [self.publishSendSale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(22);
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.width.equalTo(@274);
        make.height.equalTo(@40);
    }];
    
    [self.goonHappy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.publishSendSale.mas_bottom).offset(10);
        make.centerX.equalTo(self.bottomView.mas_centerX);
        make.width.equalTo(@274);
        make.height.equalTo(@40);
    }];
    
    [self.bottomContentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goonHappy.mas_bottom).offset(20);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.scaleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scaleView.mas_bottom).offset(10);
        make.centerX.equalTo(self.whiteView.mas_centerX);
    }];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, self.topView.height + self.bottomView.height);

}


-(void)setIsNotFound:(BOOL)isNotFound{
    _isNotFound = isNotFound;
    if (isNotFound) {
        self.whiteView.hidden = YES;
        self.scaleView.hidden = YES;
        self.scaleLbl.hidden = YES;
        self.questionImageView.hidden = NO;
        self.contentLbl.text = @"这是什么鬼，小喵猜不到呀！";
        self.iconPicView.image = [UIImage imageNamed:@"drawAround_big"];
    } else {
        self.whiteView.hidden = NO;
        self.scaleView.hidden = NO;
        self.scaleLbl.hidden = NO;
        self.questionImageView.hidden = YES;
        self.contentLbl.text = @"小喵保守估算，这货能值这个数：";
        self.iconPicView.image = [UIImage imageNamed:@"drawAround_small"];
    }
    
    [self layoutSubviews];
}

@end
