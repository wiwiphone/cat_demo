//
//  ReleaseButton.m
//  XianMao
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReleaseButton.h"
#import "Masonry.h"

@interface ReleaseButton ()

@property (nonatomic, strong) UILabel *releaseNofmLbl;
@property (nonatomic, strong) UILabel *releaseNofmTextLbl;

@end

@implementation ReleaseButton

-(UILabel *)releaseNofmLbl{
    if (!_releaseNofmLbl) {
        _releaseNofmLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _releaseNofmLbl.text = @"自己卖";
        _releaseNofmLbl.font = [UIFont boldSystemFontOfSize:14.f];
        _releaseNofmLbl.textAlignment = NSTextAlignmentCenter;
        _releaseNofmLbl.textColor = [UIColor colorWithHexString:@"f29600"];
    }
    return _releaseNofmLbl;
}

-(UILabel *)releaseNofmTextLbl{
    if (!_releaseNofmTextLbl) {
        _releaseNofmTextLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        _releaseNofmTextLbl.text = @"自己定价，发送到您的爱丁猫店铺销售";
        _releaseNofmTextLbl.text = @"自主定价";
        _releaseNofmTextLbl.textColor = [UIColor colorWithHexString:@"989898"];
        _releaseNofmTextLbl.font = [UIFont systemFontOfSize:9.f];
        _releaseNofmTextLbl.numberOfLines = 0;
        _releaseNofmTextLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _releaseNofmTextLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.releaseNofmLbl];
        [self addSubview:self.releaseNofmTextLbl];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self.releaseNofmLbl layoutSubviews];
//    [self.releaseNofmTextLbl layoutSubviews];
    
    [self.releaseNofmLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_centerY).offset(-5);
    }];
    
    [self.releaseNofmTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.releaseNofmLbl.mas_bottom).offset(5);
        make.left.equalTo(self.mas_left).offset(10);
        make.right.equalTo(self.mas_right).offset(-10);
    }];
}

@end
