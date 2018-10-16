//
//  SetCellView2.m
//  XianMao
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SetCellView2.h"
#import "Masonry.h"

@interface SetCellView2 ()

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation SetCellView2

-(UISwitch *)switchBtn{
    if (!_switchBtn) {
        _switchBtn = [[UISwitch alloc] initWithFrame:CGRectZero];
    }
    return _switchBtn;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"807f7f"];
        _titleLbl.text = @"夜间免打扰";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLbl];
        [self addSubview:self.switchBtn];
        self.switchBtn.onTintColor = [UIColor colorWithHexString:@"1a1a1a"];
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
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.setCellView2Delegate respondsToSelector:@selector(touchBegin)]) {
        [self.setCellView2Delegate touchBegin];
    }
}

@end
