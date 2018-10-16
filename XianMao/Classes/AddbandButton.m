//
//  AddbandButton.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/11.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AddbandButton.h"
#import "AddBandCardViewController.h"

@interface AddbandButton()

@property (nonatomic,strong) UIImageView * imageview;
@property (nonatomic,strong) UILabel * title;


@end

@implementation AddbandButton

-(UIImageView *)imageview
{
    if (!_imageview) {
        _imageview = [[UIImageView alloc] init];
        _imageview.image = [UIImage imageNamed:@"addBank"];
    }
    return _imageview;
}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.text = @"添加银行卡";
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = [UIColor colorWithHexString:@"434342"];
    }
    return _title;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor  = [UIColor whiteColor];
        [self addSubview:self.imageview];
        [self addSubview:self.title];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(kScreenWidth/375*138);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.imageview.mas_right);
    }];
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    AddBandCardViewController * add = [[AddBandCardViewController alloc] init];
    [[CoordinatingController sharedInstance] pushViewController:add animated:YES];
}

@end
