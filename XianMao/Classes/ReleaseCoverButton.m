//
//  ReleaseCoverButton.m
//  XianMao
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReleaseCoverButton.h"
#import "Masonry.h"

@interface ReleaseCoverButton ()

@property (nonatomic, strong) UILabel *releaseRecoverLbl;
@property (nonatomic, strong) UILabel *releaseRecoverTextLbl;

@end

@implementation ReleaseCoverButton

-(UILabel *)releaseRecoverLbl{
    if (!_releaseRecoverLbl) {
        _releaseRecoverLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _releaseRecoverLbl.text = @"求回收";
        _releaseRecoverLbl.font = [UIFont boldSystemFontOfSize:14.f];
        _releaseRecoverLbl.textAlignment = NSTextAlignmentCenter;
        _releaseRecoverLbl.textColor = [UIColor colorWithHexString:@"2ca6e0"];
    }
    return _releaseRecoverLbl;
}

-(UILabel *)releaseRecoverTextLbl{
    if (!_releaseRecoverTextLbl) {
        _releaseRecoverTextLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        _releaseRecoverTextLbl.text = @"爱丁猫数据匹配，推送给回收商报价，您择优销售";
        _releaseRecoverTextLbl.textColor = [UIColor colorWithHexString:@"989898"];
        _releaseRecoverTextLbl.text = @"快速变现";
        _releaseRecoverTextLbl.font = [UIFont systemFontOfSize:9.f];
        _releaseRecoverTextLbl.textAlignment = NSTextAlignmentCenter;
        _releaseRecoverTextLbl.numberOfLines = 0;
    }
    return _releaseRecoverTextLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.releaseRecoverLbl];
        [self addSubview:self.releaseRecoverTextLbl];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
//    [self.releaseRecoverLbl layoutSubviews];
//    [self.releaseRecoverTextLbl layoutSubviews];
    
    [self.releaseRecoverLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_centerY).offset(-5);
    }];
    if ([[UIDevice currentDevice] systemVersion].doubleValue >= 7.0 && [[UIDevice currentDevice] systemVersion].doubleValue < 8.0) {
        //适配iOS7.0 防止crash
        [self.releaseRecoverTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.releaseRecoverLbl.mas_bottom).offset(5);
            //        make.left.equalTo(self.mas_left).offset(10);
            //        make.right.equalTo(self.mas_right).offset(-10);
        }];
    } else {
        [self.releaseRecoverTextLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.releaseRecoverLbl.mas_bottom).offset(5);
            make.left.equalTo(self.mas_left).offset(10);
            make.right.equalTo(self.mas_right).offset(-10);
        }];
    }
    
}

@end
