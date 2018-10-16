//
//  TopTagView.m
//  XianMao
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "TopTagView.h"
#import "Masonry.h"

@interface TopTagView ()

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation TopTagView

-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.image = [UIImage imageNamed:@"arrowTagView"];
    }
    return _imageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.imageView];
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@15.5f);
        make.height.equalTo(@9.f);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //适配ios7.0 将布局移动到setUpUI中
//    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.centerX.equalTo(self.mas_centerX);
//        make.width.equalTo(@15.5f);
//        make.height.equalTo(@9.f);
//    }];
    
//    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.imageView.mas_bottom);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
    
    
}

@end
