//
//  MineUserHomeCell.m
//  XianMao
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineUserHomeCell.h"
#import "Masonry.h"
#import "Session.h"
#import "ADMShoppingCentreViewController.h"

@interface MineUserHomeCell ()


@property (nonatomic, strong) UIImageView *rigthArrowImage;


@end

@implementation MineUserHomeCell

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.text = @"管理我售出的闲置";
        _subLbl.font = [UIFont systemFontOfSize:15.f];
        _subLbl.textColor = [UIColor colorWithHexString:@"95989a"];
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.text = @"我的闲置";
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIImageView *)rigthArrowImage{
    if (!_rigthArrowImage) {
        _rigthArrowImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rigthArrowImage.image = [UIImage imageNamed:@"Right_Allow_New_MF"];
    }
    return _rigthArrowImage;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLbl];
        [self addSubview:self.rigthArrowImage];
        [self addSubview:self.subLbl];
        [self setUpUI];
    }
    return self;
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[CoordinatingController sharedInstance] gotoUserHomeViewController:[Session sharedInstance].currentUserId
                                                               animated:YES];
    //    ADMShoppingCentreViewController *viewController = [[ADMShoppingCentreViewController alloc] init];
    //    viewController.userId = [Session sharedInstance].currentUserId;
    //    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
}

-(void)setUpUI{
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.rigthArrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@9);
        make.height.equalTo(@14.5);
    }];
    
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rigthArrowImage.mas_left).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
