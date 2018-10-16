//
//  MFPageViewCell.m
//  XianMao
//
//  Created by apple on 15/12/18.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import "MFPageViewCell.h"

@interface MFPageViewCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation MFPageViewCell


//懒加载控件
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

/*
    我需要数据数据。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。。
 */


@end
