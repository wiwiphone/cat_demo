//
//  ImageAndTitleVerticalButton.m
//  XianMao
//
//  Created by WJH on 17/3/1.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ImageAndTitleVerticalButton.h"

static CGFloat kTextTopPadding = 10;
static CGFloat kSubTitlePadding = 5;

@implementation ImageAndTitleVerticalButton


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        _subTitle = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitle.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _subTitle.font = [UIFont systemFontOfSize:12];
        _subTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subTitle];
    }
    return self;
}


-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Move the image to the top and center it horizontally
    CGRect imageFrame = self.imageView.frame;
    imageFrame.origin.y = 0;
    imageFrame.origin.x = (self.frame.size.width / 2) - (imageFrame.size.width / 2);
    self.imageView.frame = imageFrame;
    
    // Adjust the label size to fit the text, and move it below the image
    CGRect titleLabelFrame = self.titleLabel.frame;
    NSDictionary *Tdic  = [[NSDictionary alloc]initWithObjectsAndKeys:self.titleLabel.font,NSFontAttributeName, nil];
    
    CGRect  labelSize  = [self.titleLabel.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:Tdic context:nil];
    titleLabelFrame.size.width = labelSize.size.width;
    titleLabelFrame.size.height = labelSize.size.height;
    titleLabelFrame.origin.x = (self.frame.size.width / 2) - (labelSize.size.width / 2);
    titleLabelFrame.origin.y = self.imageView.frame.origin.y + self.imageView.frame.size.height + kTextTopPadding;
    self.titleLabel.frame = titleLabelFrame;
    
    _subTitle.frame = CGRectMake(-10, CGRectGetMaxY(self.titleLabel.frame)+kSubTitlePadding, self.frame.size.width+20, 20);
    
}

@end
