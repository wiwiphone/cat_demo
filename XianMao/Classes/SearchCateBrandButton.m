//
//  SearchCateBrandButton.m
//  XianMao
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SearchCateBrandButton.h"
#import "Masonry.h"

@interface SearchCateBrandButton ()

@property (nonatomic, strong) UIButton *btn;

@end

@implementation SearchCateBrandButton

-(UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btn setImage:[UIImage imageNamed:@"search_gray_new"] forState:UIControlStateNormal];
        [_btn setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, -5);
        _btn.userInteractionEnabled = NO;
    }
    return _btn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.btn];
        
        [self setUpUI];
    }
    return self;
}

-(void)getShowText:(NSString *)showText
{
    [_btn setTitle:showText forState:UIControlStateNormal];
}

-(void)setUpUI{
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
