//
//  SetCellView1.m
//  XianMao
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SetCellView1.h"
#import "Masonry.h"

@interface SetCellView1 ()

@property (nonatomic, strong) UILabel *titleLbl;


@end

@implementation SetCellView1

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"807f7f"];
        _titleLbl.text = @"每日推送上限";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UILabel *)rigthLbl{
    if (!_rigthLbl) {
        _rigthLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _rigthLbl.font = [UIFont systemFontOfSize:15.f];
        _rigthLbl.textColor = [UIColor colorWithHexString:@"807f7f"];
        _rigthLbl.text = @"不限";
        [_rigthLbl sizeToFit];
    }
    return _rigthLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLbl];
        [self addSubview:self.rigthLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.rigthLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-15);
        make.centerY.equalTo(self.mas_centerY);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if ([self.setCellView1Delegate respondsToSelector:@selector(touchBegin)]) {
        [self.setCellView1Delegate touchBegin];
    }
}

@end
