//
//  NewPageCollectionViewCell.m
//  NewPage
//
//  Created by apple on 16/1/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NewPageCollectionViewCell.h"

@interface NewPageCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation NewPageCollectionViewCell



-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _imageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

-(void)setImageName:(UIImage *)imageName{
    _imageName = imageName;
    self.imageView.image = imageName;
//    if (kScreenHeight == 480 && kScreenWidth == 320) {
//        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, -70, kScreenWidth, 530)];
//        
//    }
    
}

@end
