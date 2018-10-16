//
//  VerifyCell.m
//  XianMao
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "VerifyCell.h"
#import "DataSources.h"
#import "Masonry.h"
#import "Command.h"

@interface VerifyCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *goodsName;
@property (nonatomic, strong) UILabel *hopePrice;
@property (nonatomic, strong) UIView *subView;
@property (nonatomic, strong) UIImageView *clockImageView;
@property (nonatomic, strong) UILabel *subLbl;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *notSoldLbl;
@property (nonatomic, strong) UILabel *aboutPrice;
@property (nonatomic, strong) UILabel *scheduleLbl;
@property (nonatomic, strong) CommandButton *bottomLeftBtn;
@property (nonatomic, strong) CommandButton *bottomRightBtn;
@end

@implementation VerifyCell

-(CommandButton *)bottomRightBtn{
    if (!_bottomRightBtn) {
        _bottomRightBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _bottomRightBtn.backgroundColor = [UIColor colorWithHexString:@"252525"];
        [_bottomRightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomRightBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _bottomRightBtn.layer.masksToBounds = YES;
        _bottomRightBtn.layer.cornerRadius = 3;
    }
    return _bottomRightBtn;
}

-(CommandButton *)bottomLeftBtn{
    if (!_bottomLeftBtn) {
        _bottomLeftBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _bottomLeftBtn.backgroundColor = [UIColor colorWithHexString:@"252525"];
        [_bottomLeftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bottomLeftBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _bottomLeftBtn.layer.masksToBounds = YES;
        _bottomLeftBtn.layer.cornerRadius = 3;
    }
    return _bottomLeftBtn;
}

-(UILabel *)scheduleLbl{
    if (!_scheduleLbl) {
        _scheduleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _scheduleLbl.font = [UIFont systemFontOfSize:15.f];
        _scheduleLbl.textColor = [UIColor colorWithHexString:@"ff6666"];
        [_scheduleLbl sizeToFit];
    }
    return _scheduleLbl;
}

-(UILabel *)aboutPrice{
    if (!_aboutPrice) {
        _aboutPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _aboutPrice.font = [UIFont systemFontOfSize:15.f];
        _aboutPrice.textColor = [UIColor colorWithHexString:@"c2a79d"];
        [_aboutPrice sizeToFit];
    }
    return _aboutPrice;
}

-(UILabel *)notSoldLbl{
    if (!_notSoldLbl) {
        _notSoldLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _notSoldLbl.font = [UIFont systemFontOfSize:11.f];
        _notSoldLbl.textColor = [UIColor colorWithHexString:@"ff6666"];
        _notSoldLbl.numberOfLines = 0;
        [_notSoldLbl sizeToFit];
    }
    return _notSoldLbl;
}

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.font = [UIFont systemFontOfSize:11.f];
        _subLbl.textColor = [UIColor colorWithHexString:@"95989a"];
        _subLbl.numberOfLines = 0;
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(UIImageView *)clockImageView{
    if (!_clockImageView) {
        _clockImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _clockImageView.image = [UIImage imageNamed:@"verify_clock"];
    }
    return _clockImageView;
}

-(UIView *)subView{
    if (!_subView) {
        _subView = [[UILabel alloc] initWithFrame:CGRectZero];
        _subView.backgroundColor = [UIColor colorWithHexString:@"f0ebeb"];
    }
    return _subView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(UILabel *)hopePrice{
    if (!_hopePrice) {
        _hopePrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _hopePrice.font = [UIFont systemFontOfSize:15.f];
        _hopePrice.textColor = [UIColor colorWithHexString:@"c2a79d"];
        [_hopePrice sizeToFit];
    }
    return _hopePrice;
}

-(UILabel *)goodsName{
    if (!_goodsName) {
        _goodsName = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsName.font = [UIFont systemFontOfSize:15.f];
        _goodsName.textColor = [UIColor colorWithHexString:@"525252"];
    }
    return _goodsName;
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

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([VerifyCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    VerifyModel *verifyModel = dict[@"verifyModel"];
    CGFloat height = 0;
    if (verifyModel.systemStatus == 6 || verifyModel.systemStatus == 5 || verifyModel.systemStatus == 7 || verifyModel.systemStatus == 8 || verifyModel.systemStatus == 10 || verifyModel.systemStatus == 11) {
        height = 114 + 45;
    } else {
        height = 114;
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(VerifyModel *)verifyModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[VerifyCell class]];
    if (verifyModel)[dict setObject:verifyModel forKey:@"verifyModel"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        
//        [self.bottomLeftBtn addTarget:self action:@selector(clickLeftBtn) forControlEvents:UIControlEventTouchUpInside];
//        [self.bottomRightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
}

//-(void)clickRightBtn{
//    [[CoordinatingController sharedInstance] showHUD:@"待开发rightBtn" hideAfterDelay:0.8];
//}
//
//-(void)clickLeftBtn{
//    [[CoordinatingController sharedInstance] showHUD:@"待开发leftBtn" hideAfterDelay:0.8];
//}

-(void)updateCellWithDict:(NSDictionary *)dict{
    WEAKSELF;
    VerifyModel *verifyModel = dict[@"verifyModel"];
    
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.goodsName];
    [self.contentView addSubview:self.hopePrice];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(17);
        make.top.equalTo(self.contentView.mas_top).offset(17);
        make.width.equalTo(@84);
        make.height.equalTo(@84);
    }];
    
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-17);
    }];
    
    [self.hopePrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsName.mas_bottom).offset(5);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    if (verifyModel.systemStatus == 4) {
        [self.contentView addSubview:self.aboutPrice];
        [self.aboutPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-17);
            make.centerY.equalTo(self.hopePrice.mas_centerY);
        }];
        self.aboutPrice.text = [NSString stringWithFormat:@"估值价 ¥%.2f", verifyModel.estimationPrice];
    }
    
    if (verifyModel.message.length > 0) {
        [self.contentView addSubview:self.subView];
        [self.contentView addSubview:self.clockImageView];
        [self.contentView addSubview:self.subLbl];
        self.subView.hidden = NO;
        self.clockImageView.hidden = NO;
        self.subLbl.hidden = NO;
        CGSize goodsNameSize = [verifyModel.message sizeWithFont:[UIFont systemFontOfSize:11.f]
                                          constrainedToSize:CGSizeMake(kScreenWidth-84-17-10-5-17-5,MAXFLOAT)
                                              lineBreakMode:NSLineBreakByWordWrapping];
        [self.subView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-17);
            make.bottom.equalTo(self.iconImageView.mas_bottom);
            make.height.equalTo(@(goodsNameSize.height+10));
        }];
        
        [self.clockImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.subView.mas_left).offset(10);
            make.centerY.equalTo(self.subView.mas_centerY);
            make.width.equalTo(@14);
            make.height.equalTo(@14);
        }];
        
        [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.clockImageView.mas_right).offset(5);
            make.centerY.equalTo(self.subView.mas_centerY);
            make.right.equalTo(self.subView.mas_right).offset(-5);
        }];
        
        self.subLbl.text = verifyModel.message;
    } else {
        self.subView.hidden = YES;
        self.clockImageView.hidden = YES;
        self.subLbl.hidden = YES;
    }
    
    if (verifyModel.systemStatus == 1 || verifyModel.systemStatus == 8 || verifyModel.systemStatus == 2) {
        [self.contentView addSubview:self.scheduleLbl];
        [self.scheduleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.bottom.equalTo(self.iconImageView.mas_bottom);
        }];
        self.scheduleLbl.text = verifyModel.warnMessage;
        self.scheduleLbl.hidden = NO;
        self.notSoldLbl.hidden = YES;
    } else {
        self.scheduleLbl.hidden = YES;
        [self.contentView addSubview:self.notSoldLbl];
        self.notSoldLbl.hidden = NO;
        [self.notSoldLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.iconImageView.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.top.equalTo(self.hopePrice.mas_bottom).offset(5);
        }];
        self.notSoldLbl.text = verifyModel.warnMessage;
    }
    
    
    
    if (verifyModel.systemStatus == 6 || verifyModel.systemStatus == 5 || verifyModel.systemStatus == 7 || verifyModel.systemStatus == 8 || verifyModel.systemStatus == 10 || verifyModel.systemStatus == 11) {
        [self.contentView addSubview:self.bottomView];
        [self.bottomView addSubview:self.lineView];
        self.lineView.hidden = NO;
        self.bottomView.hidden = NO;
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImageView.mas_bottom).offset(15);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@45);
        }];
        
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bottomView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.height.equalTo(@0.5);
        }];
        
        [self.contentView addSubview:self.bottomLeftBtn];
        [self.contentView addSubview:self.bottomRightBtn];
        self.bottomRightBtn.hidden = NO;
        self.bottomLeftBtn.hidden = NO;
        
        [self.bottomRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomView.mas_right).offset(-17);
            make.centerY.equalTo(self.bottomView.mas_centerY);
            make.width.equalTo(@70);
            make.height.equalTo(@25);
        }];
        
        [self.bottomLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomRightBtn.mas_left).offset(-13);
            make.centerY.equalTo(self.bottomView.mas_centerY);
            make.width.equalTo(@70);
            make.height.equalTo(@25);
        }];
    } else {
        self.bottomRightBtn.hidden = YES;
        self.bottomLeftBtn.hidden = YES;
        self.bottomView.hidden = YES;
        self.lineView.hidden = YES;
    }
    
    [self.iconImageView setImageWithURL:verifyModel.img placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.goodsName.text = verifyModel.goodsName;
    if (verifyModel.goodsStatus != 14 || verifyModel.systemStatus != 3 || verifyModel.systemStatus != 8) {
        self.hopePrice.text = [NSString stringWithFormat:@"期望价 ¥%ld", verifyModel.userHopePrice];
    }
    
    if (verifyModel.systemStatus == 8) {
        self.hopePrice.text = [NSString stringWithFormat:@"出手价 ¥%.2f", verifyModel.sellPrice];
        self.aboutPrice.hidden = YES;
    } else {
        self.aboutPrice.hidden = NO;
    }

    if (verifyModel.systemStatus == 6) {
        self.bottomLeftBtn.hidden = NO;
        self.bottomRightBtn.hidden = NO;
        [self.bottomLeftBtn setTitle:@"发货" forState:UIControlStateNormal];
        [self.bottomRightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        self.bottomView.hidden = NO;
    } else if (verifyModel.systemStatus == 5) {
        self.bottomLeftBtn.hidden = YES;
        self.bottomRightBtn.hidden = NO;
        [self.bottomRightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        self.bottomView.hidden = NO;
    } else if (verifyModel.systemStatus == 7 || verifyModel.systemStatus == 8) {
        self.bottomLeftBtn.hidden = YES;
        self.bottomRightBtn.hidden = NO;
        [self.bottomRightBtn setTitle:@"申请寄回" forState:UIControlStateNormal];
        self.bottomView.hidden = NO;
    } else if (verifyModel.systemStatus == 10) {
        self.bottomLeftBtn.hidden = YES;
        self.bottomRightBtn.hidden = NO;
        [self.bottomRightBtn setTitle:@"确认上架" forState:UIControlStateNormal];
        self.bottomView.hidden = NO;
    } else if (verifyModel.systemStatus == 11) {
        self.bottomLeftBtn.hidden = NO;
        self.bottomRightBtn.hidden = NO;
        [self.bottomLeftBtn setTitle:@"确认收货" forState:UIControlStateNormal];
        [self.bottomRightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
        self.bottomView.hidden = NO;
    } else {
        self.bottomLeftBtn.hidden = YES;
        self.bottomRightBtn.hidden = YES;
        self.bottomView.hidden = YES;
    }
    
    self.bottomLeftBtn.handleClickBlock = ^(CommandButton *sender){
        if (verifyModel.systemStatus == 6) {
            if (weakSelf.sendGoods) {
                weakSelf.sendGoods(verifyModel.goodsSn);
            }
        } else if (verifyModel.systemStatus == 5) {
            
        } else if (verifyModel.systemStatus == 7 || verifyModel.systemStatus == 8) {
            
        } else if (verifyModel.systemStatus == 10) {
            
        } else if (verifyModel.systemStatus == 11) {
            if (weakSelf.affirmGoods) {
                weakSelf.affirmGoods(verifyModel.goodsSn);
            }
        }
    };
    
    self.bottomRightBtn.handleClickBlock = ^(CommandButton *sender){
        if (verifyModel.systemStatus == 6) {
            if (weakSelf.lookLogistics) {
                weakSelf.lookLogistics(verifyModel);
            }
        } else if (verifyModel.systemStatus == 5) {
            if (weakSelf.lookLogistics) {
                weakSelf.lookLogistics(verifyModel);
            }
        } else if (verifyModel.systemStatus == 7 || verifyModel.systemStatus == 8) {
            if (weakSelf.sendBackGoods) {
                weakSelf.sendBackGoods(verifyModel.goodsSn);
            }
        } else if (verifyModel.systemStatus == 10) {
            if (weakSelf.surePutaway) {
                weakSelf.surePutaway(verifyModel.goodsSn);
            }
        } else if (verifyModel.systemStatus == 11) {
            if (weakSelf.lookLogistics) {
                weakSelf.lookLogistics(verifyModel);
            }
        }
    };
}

@end
