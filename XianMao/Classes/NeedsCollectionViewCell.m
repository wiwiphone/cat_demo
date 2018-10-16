//
//  NeedsCollectionViewCell.m
//  XianMao
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "NeedsCollectionViewCell.h"

@interface NeedsCollectionViewCell ()



@end

@implementation NeedsCollectionViewCell

-(XMWebImageView *)imageView{
    if (!_imageView) {
        _imageView = [[XMWebImageView alloc] initWithFrame:self.bounds];
    }
    return _imageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

-(void)getNeedsAttrmendVo:(NeedsAttachmentVo *)NeedsAttachmentVo{
    
    [self.imageView setImageWithURL:NeedsAttachmentVo.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale240x240];
    
}

@end
