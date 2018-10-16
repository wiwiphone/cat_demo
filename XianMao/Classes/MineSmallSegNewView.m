//
//  MineSmallSegNewView.m
//  XianMao
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MineSmallSegNewView.h"

@implementation MineSmallSegNewView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
        [self addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(16);
            make.right.equalTo(self.mas_right).offset(-16);
            make.height.equalTo(@0.5);
        }];
        
    }
    return self;
}

@end
