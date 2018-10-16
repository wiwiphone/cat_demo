//
//  AssessLoadingView.m
//  XianMao
//
//  Created by WJH on 17/1/20.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "AssessLoadingView.h"
#import "AnimatedGIFImageSerialization.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"

@interface AssessLoadingView()

@property (nonatomic, strong) FLAnimatedImageView * LoadingImage;
@property (nonatomic, strong) UILabel * descLbl;

@end

@implementation AssessLoadingView


-(UILabel *)descLbl{
    if (!_descLbl) {
        _descLbl = [[UILabel alloc] init];
        _descLbl.font = [UIFont systemFontOfSize:14];
        _descLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _descLbl.text = @"数据仅供趣味参考";
        [_descLbl sizeToFit];
    }
    return _descLbl;
}

-(FLAnimatedImageView *)LoadingImage{
    if (!_LoadingImage) {
        _LoadingImage = [[FLAnimatedImageView alloc] init];
        FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"assess_loading" ofType:@"gif"]]];
        _LoadingImage.animatedImage = image;
        _LoadingImage.backgroundColor = [UIColor whiteColor];
    }
    return _LoadingImage;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorWithHexString:@"ffdd39"];
        [self addSubview:self.LoadingImage];
        [self addSubview:self.descLbl];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self.LoadingImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(100);
        make.centerX.equalTo(self.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth, kScreenWidth));
    }];
    
    [self.descLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
}

@end
