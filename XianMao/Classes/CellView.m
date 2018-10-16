//
//  CellView.m
//  XianMao
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CellView.h"
#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface CellView ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *rigthLbl;

@end

@implementation CellView

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"807f7f"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UISwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectZero];
    }
    return _switchBtn;
}

-(UILabel *)rigthLbl{
    if (!_rigthLbl) {
        _rigthLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _rigthLbl.font = [UIFont systemFontOfSize:15.f];
        _rigthLbl.textColor = [UIColor colorWithHexString:@"c8c9ca"];
        _rigthLbl.text = @"不限";
        [_rigthLbl sizeToFit];
    }
    return _rigthLbl;
}

-(instancetype)initWithTitle:(NSString *)title andIsHaveSeleted:(BOOL)isYes andIsAlrSet:(BOOL)isSet{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLbl];
        [self addSubview:self.switchBtn];
        [self addSubview:self.rigthLbl];
        
        self.titleLbl.text = title;
        
        if (!isSet) {
            self.alpha = 0.7;
            self.switchBtn.userInteractionEnabled = NO;
        } else {
            self.alpha = 1;
            self.switchBtn.userInteractionEnabled = YES;
        }
        
        if (isYes) {
            self.switchBtn.hidden = NO;
            self.rigthLbl.hidden = YES;
        } else {
            self.switchBtn.hidden = YES;
            self.rigthLbl.hidden = NO;
        }

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.rigthLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

-(void)getRecoverUserInfo:(RecoverUserInfo *)userInfo{
    if (userInfo) {
        if (userInfo.pushMaxNum == 0) {
            self.rigthLbl.text = @"不限";
        } else {
            self.rigthLbl.text = [NSString stringWithFormat:@"%ld条", userInfo.pushMaxNum];
        }
        
        if (userInfo.isCanPush) {
            self.switchBtn.on = YES;
        } else {
            self.switchBtn.on = NO;
        }
        
        if (userInfo.isCanEvenPush) {
            self.switchBtn.on = YES;
        } else {
            self.switchBtn.on = NO;
        }
    }
}

-(void)getReceiveNum:(id)receiveNum{
    self.rigthLbl.text = [NSString stringWithFormat:@"%@条", receiveNum];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.cellViewDelegate respondsToSelector:@selector(touchBegin)]) {
        [self.cellViewDelegate touchBegin];
    }
}

@end

@interface CellView1 ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *rigthLbl;

@end

@implementation CellView1

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"807f7f"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UISwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectZero];
    }
    return _switchBtn;
}

-(UILabel *)rigthLbl{
    if (!_rigthLbl) {
        _rigthLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _rigthLbl.font = [UIFont systemFontOfSize:15.f];
        _rigthLbl.textColor = [UIColor colorWithHexString:@"c8c9ca"];
        _rigthLbl.text = @"不限";
        [_rigthLbl sizeToFit];
    }
    return _rigthLbl;
}

-(instancetype)initWithTitle:(NSString *)title andIsHaveSeleted:(BOOL)isYes andIsAlrSet:(BOOL)isSet{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLbl];
        [self addSubview:self.switchBtn];
        [self addSubview:self.rigthLbl];
        
        self.titleLbl.text = title;
        
        if (!isSet) {
            self.alpha = 0.7;
            self.switchBtn.userInteractionEnabled = NO;
        } else {
            self.alpha = 1;
            self.switchBtn.userInteractionEnabled = YES;
        }
        
        if (isYes) {
            self.switchBtn.hidden = NO;
            self.rigthLbl.hidden = YES;
        } else {
            self.switchBtn.hidden = YES;
            self.rigthLbl.hidden = NO;
        }
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.rigthLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

-(void)getRecoverUserInfo:(RecoverUserInfo *)userInfo{
    if (userInfo) {
        if (userInfo.pushMaxNum == 0) {
            self.rigthLbl.text = @"不限";
        } else {
            self.rigthLbl.text = [NSString stringWithFormat:@"%ld条", userInfo.pushMaxNum];
        }
        
        if (userInfo.isCanPush) {
            self.hidden = NO;
        } else {
            self.hidden = YES;
        }
        
        if (userInfo.isCanEvenPush) {
            self.switchBtn.on = YES;
        } else {
            self.switchBtn.on = NO;
        }
    }
}

-(void)getReceiveNum:(NSNumber *)receiveNum{
    if ([receiveNum isEqualToNumber:@0]) {
        self.rigthLbl.text = @"不限";
    } else {
        self.rigthLbl.text = [NSString stringWithFormat:@"%@条", receiveNum];
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.cellViewDelegate respondsToSelector:@selector(touchBegin)]) {
        [self.cellViewDelegate touchBegin];
    }
}

@end

@interface CellView2 ()

@property (nonatomic, strong) UILabel *titleLbl;

@property (nonatomic, strong) UILabel *rigthLbl;

@end

@implementation CellView2

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"807f7f"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UISwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectZero];
    }
    return _switchBtn;
}

-(UILabel *)rigthLbl{
    if (!_rigthLbl) {
        _rigthLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _rigthLbl.font = [UIFont systemFontOfSize:15.f];
        _rigthLbl.textColor = [UIColor colorWithHexString:@"c8c9ca"];
        _rigthLbl.text = @"不限";
        [_rigthLbl sizeToFit];
    }
    return _rigthLbl;
}

-(instancetype)initWithTitle:(NSString *)title andIsHaveSeleted:(BOOL)isYes andIsAlrSet:(BOOL)isSet{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLbl];
        [self addSubview:self.switchBtn];
        [self addSubview:self.rigthLbl];
        
        self.titleLbl.text = title;
        
        if (!isSet) {
            self.alpha = 0.7;
            self.switchBtn.userInteractionEnabled = NO;
        } else {
            self.alpha = 1;
            self.switchBtn.userInteractionEnabled = YES;
        }
        
        if (isYes) {
            self.switchBtn.hidden = NO;
            self.rigthLbl.hidden = YES;
        } else {
            self.switchBtn.hidden = YES;
            self.rigthLbl.hidden = NO;
        }
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.switchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.rigthLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

-(void)getRecoverUserInfo:(RecoverUserInfo *)userInfo{
    if (userInfo) {
        if (userInfo.pushMaxNum == 0) {
            self.rigthLbl.text = @"不限";
        } else {
            self.rigthLbl.text = [NSString stringWithFormat:@"%ld条", (long)userInfo.pushMaxNum];
        }
        
        if (userInfo.isCanPush) {
            self.hidden = NO;
        } else {
            self.hidden = YES;
        }
        
        if (userInfo.isCanEvenPush) {
            self.switchBtn.on = YES;
        } else {
            self.switchBtn.on = NO;
        }
    }
}

-(void)getReceiveNum:(id)receiveNum{
    self.rigthLbl.text = [NSString stringWithFormat:@"%@条", receiveNum];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.cellViewDelegate respondsToSelector:@selector(touchBegin)]) {
        [self.cellViewDelegate touchBegin];
    }
}

@end
