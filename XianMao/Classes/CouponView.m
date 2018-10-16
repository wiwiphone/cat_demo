//
//  CouponView.m
//  XianMao
//
//  Created by WJH on 16/12/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CouponView.h"
#import "CardViewController.h"
#import "BonusInfo.h"
#import "PayViewController.h"

@interface CouponView()

@property (nonatomic, strong) UIImageView * icon;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * privilege;
@property (nonatomic, strong) UIImageView * arrowImg;
@property (nonatomic, strong) NSMutableArray * bounsArray;

@end

@implementation CouponView

-(UIImageView *)icon{
    if (!_icon) {
        _icon = [[UIImageView alloc] initWithFrame:CGRectZero];
        _icon.image = [UIImage imageNamed:@"quan_wjh"];
    }
    return _icon;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = [UIColor colorWithHexString:@"434342"];
        _title.text = @"优惠券";
        [_title sizeToFit];
    }
    return _title;
}

- (UILabel *)privilege{
    if (!_privilege) {
        _privilege = [[UILabel alloc] init];
        _privilege.textColor = [UIColor colorWithHexString:@"f4433e"];
        _privilege.font = [UIFont systemFontOfSize:14];
        [_privilege sizeToFit];
    }
    return _privilege;
}

-(UIImageView *)arrowImg{
    if (!_arrowImg) {
        _arrowImg = [[UIImageView alloc] init];
        _arrowImg.image = [UIImage imageNamed:@"arrow_new"];
    }
    return _arrowImg;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.icon];
        [self addSubview:self.title];
        [self addSubview:self.privilege];
        [self addSubview:self.arrowImg];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(5);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.privilege mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.arrowImg.mas_left);
    }];
}


- (BonusInfo *)getbouns:(NSMutableArray *)bounsArray{
    _bounsArray = bounsArray;
 
    BonusInfo * newBonusInfo = [[BonusInfo alloc] init];
    newBonusInfo.bonusId = @"";
    for (BonusInfo * bounsInfo in bounsArray) {
        if (bounsInfo.canUse == 1) {
            if (bounsInfo.bonusDesc.length > 0) {
                self.title.text = bounsInfo.bonusDesc;
            }else{
                self.title.text = @"优惠券";
            }
            if (bounsInfo.amount > 0) {
                self.privilege.text = [NSString stringWithFormat:@"-¥%.2f",bounsInfo.amount];
            }else{
                self.privilege.text = @"";
            }
            newBonusInfo = bounsInfo;
            break;
        }
    }
    return newBonusInfo;
}


-(CGFloat)getBounsInfo:(BonusInfo *)bonusInfo{
    
    if (bonusInfo.bonusDesc.length > 0) {
        self.title.text = bonusInfo.bonusDesc;
    }else{
        self.title.text = @"优惠券";
    }
    
    if (bonusInfo.amount > 0) {
        self.privilege.text = [NSString stringWithFormat:@"-¥%.2f",bonusInfo.amount];
    }else{
        self.privilege.text = @"";
    }
    
    CGFloat amount = bonusInfo.amount;
    
    if (bonusInfo.bonusId.integerValue == -1000) {
        self.privilege.text = @"不使用优惠券";
        self.title.text = @"优惠券";
    }
    return amount;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.selectBouns) {
        self.selectBouns(self.bounsArray);
    }
}



@end
