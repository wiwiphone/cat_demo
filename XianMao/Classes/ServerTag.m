//
//  ServerTag.m
//  XianMao
//
//  Created by 阿杜 on 16/9/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ServerTag.h"


@implementation ServerTag

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title imageUrl:(NSString *)imageUrl
{
    if (self = [super initWithFrame:frame]) {
        
        UILabel * titleLbl = [[UILabel alloc] init];
        titleLbl.text = title;
        titleLbl.font = [UIFont systemFontOfSize:11];
        titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [titleLbl sizeToFit];
        [self addSubview:titleLbl];
        
        
        XMWebImageView * icon = [[XMWebImageView alloc] init];
        [icon setImageWithURL:imageUrl XMWebImageScaleType:XMWebImageScale100x100];
        [self addSubview:icon];
        
        
        [icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(icon.mas_right).offset(5);
        }];
        
    }
    return self;
}

@end
