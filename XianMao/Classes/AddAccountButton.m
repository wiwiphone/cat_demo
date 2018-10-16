//
//  AddAccountButton.m
//  XianMao
//
//  Created by WJH on 16/11/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "AddAccountButton.h"
#import "UIImage+Addtions.h"

@interface AddAccountButton()

@property (nonatomic, strong) UIButton * title;
@property (nonatomic, strong) UILabel * desc;
@property (nonatomic, strong) UIView * line;

@end


@implementation AddAccountButton

-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _line;
}

-(UIButton *)title
{
    if (!_title) {
        _title = [[UIButton alloc] init];
        _title.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_title setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _title.userInteractionEnabled = NO;
        [_title sizeToFit];
    }
    return _title;
}

-(UILabel *)desc
{
    if (!_desc) {
        _desc = [[UILabel alloc] init];
        _desc.font = [UIFont systemFontOfSize:12];
        _desc.textColor = [UIColor colorWithHexString:@"f4433e"];
        _desc.userInteractionEnabled = NO;
        [_desc sizeToFit];
    }
    return _desc;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.title];
        [self addSubview:self.desc];
        [self addSubview:self.line];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.desc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_centerY).offset(5);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.height.equalTo(@1);
        make.bottom.equalTo(self.mas_bottom);
    }];
}


-(void)setAddAccountVo:(AddAccountIconVo *)addAccountVo
{
    _addAccountVo = addAccountVo;
    if (addAccountVo.caption.length > 0) {
        self.desc.text = addAccountVo.caption;
    }
    if (addAccountVo.icon.length > 0) {
        UIImage * images=[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:addAccountVo.icon]]];
        [self.title setImage:[images scaleToSize:CGSizeMake(15, 15)] forState:UIControlStateNormal];
        [self.title setTitle:[NSString stringWithFormat:@" %@", addAccountVo.name] forState:UIControlStateNormal];
    }
}

@end
