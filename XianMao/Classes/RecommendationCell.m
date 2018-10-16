//
//  RecommendationCell.m
//  XianMao
//
//  Created by 阿杜 on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecommendationCell.h"

@interface RecommendationCell()

@property (nonatomic, strong) XMWebImageView * imageView;
@property (nonatomic, strong) UILabel * price;

@end

@implementation RecommendationCell

-(void)setModel:(AdviserGoodsModel *)model
{
    [_imageView setImageWithURL:model.thumb_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale100x100];
    _price.text = [NSString stringWithFormat:@"¥%.2f",model.shop_price];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(0, 16, 88, 88)];
        _imageView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.imageView];
        
        _price = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imageView.frame), self.contentView.width, 33)];
        _price.font = [UIFont systemFontOfSize:13];
        _price.textColor = [UIColor colorWithHexString:@"333333"];
        _price.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.price];
        
    }
    return self;
}

@end
