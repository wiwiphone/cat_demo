//
//  FilterButton.m
//  XianMao
//
//  Created by 阿杜 on 16/9/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FilterButton.h"

@implementation FilterButton

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont systemFontOfSize:12];
        [self bringSubviewToFront:self.titleLabel];
    }
    return self;
}

@end
