//
//  OverlayTapDetectingView.m
//  XianMao
//
//  Created by WJH on 17/3/1.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "OverlayTapDetectingView.h"

@implementation OverlayTapDetectingView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView * icon = [[UIImageView alloc] init];
        icon.layer.masksToBounds = YES;
        icon.layer.cornerRadius = 3;
        icon.image = [UIImage imageNamed:@"guajiaIcon"];
        [self addSubview:icon];
        
        UILabel * title = [[UILabel alloc] init];
        title.font = [UIFont systemFontOfSize:15];
        title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        title.text = @"趣味估价";
        [title sizeToFit];
        [self addSubview:title];
        
        
        UILabel * subTitle = [[UILabel alloc] init];
        subTitle.font = [UIFont systemFontOfSize:14];
        subTitle.text = @"看看你的奢侈品值多少?";
        subTitle.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [subTitle sizeToFit];
        [self addSubview:subTitle];
        
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(10);
            make.size.mas_equalTo(CGSizeMake(48, 48));
        }];
        
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(10);
            make.bottom.equalTo(icon.mas_centerY).offset(-2.5);
        }];
        
        [subTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(icon.mas_right).offset(10);
            make.top.equalTo(icon.mas_centerY).offset(2.5);
        }];
        
    }
    return self;
}

@end
