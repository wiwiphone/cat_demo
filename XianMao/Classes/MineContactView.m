//
//  MineContactView.m
//  XianMao
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineContactView.h"
#import "Masonry.h"

@interface MineContactView ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation MineContactView

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"eaebeb"];
    }
    return _lineView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLbl.text = @"联系我们";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLbl];
        [self addSubview:self.lineView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(18);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@1);
    }];
}

@end
