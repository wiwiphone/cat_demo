//
//  IdleCollectionViewCell.m
//  XianMao
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "IdleCollectionViewCell.h"

@interface IdleCollectionViewCell ()

@property (nonatomic, strong) PictureItem *item;

@end

@implementation IdleCollectionViewCell

-(XMWebImageView *)imageView{
    if (!_imageView) {
        _imageView = [[XMWebImageView alloc] initWithFrame:self.bounds];
        _imageView.backgroundColor = [UIColor colorWithHexString:@"c7c7c7"];
    }
    return _imageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

-(void)getPictureItem:(PictureItem *)item{
    self.item = item;
    [self.contentView addSubview:self.imageView];
//    [self.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/3/w/200/h/100/q/90",self.item.picUrl]]];
    [self.imageView setImageWithURL:self.item.picUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
//    [self.contentView setNeedsDisplay];
}

@end
