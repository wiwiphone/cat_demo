//
//  GoodsDetailBottomTagsCell.m
//  XianMao
//
//  Created by simon on 1/28/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "GoodsDetailBottomTagsCell.h"

@implementation GoodsDetailBottomTagsCell {
    UIButton *_btn1;
    UIButton *_btn2;
    UIButton *_btn3;
    UIButton *_btn4;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsDetailBottomTagsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 125.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsDetailBottomTagsCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        _btn1 = [[UIButton alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:_btn1];
        
        _btn2 = [[UIButton alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:_btn2];
        
        _btn3 = [[UIButton alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:_btn3];
        
        _btn4 = [[UIButton alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:_btn4];
        
        [_btn1 setImage:[UIImage imageNamed:@"btmTags_z.png"] forState:UIControlStateDisabled];
        [_btn1 setTitle:@"正品保证" forState:UIControlStateNormal];
        _btn1.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _btn1.titleEdgeInsets = UIEdgeInsetsMake(70, -50, 0, 0);
        _btn1.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _btn1.enabled = NO;
        [_btn1 setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateDisabled];
        
        [_btn2 setImage:[UIImage imageNamed:@"btmTags_j.png"] forState:UIControlStateDisabled];
        [_btn2 setTitle:@"权威鉴定" forState:UIControlStateNormal];
        _btn2.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _btn2.titleEdgeInsets = UIEdgeInsetsMake(70, -50, 0, 0);
        _btn2.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _btn2.enabled = NO;
        [_btn2 setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateDisabled];
        
        [_btn3 setImage:[UIImage imageNamed:@"btmTags_7.png"] forState:UIControlStateDisabled];
        [_btn3 setTitle:@"七天包退" forState:UIControlStateNormal];
        _btn3.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _btn3.titleEdgeInsets = UIEdgeInsetsMake(70, -50, 0, 0);
        _btn3.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _btn3.enabled = NO;
        [_btn3 setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateDisabled];
        
        [_btn4 setImage:[UIImage imageNamed:@"btmTags_pay.png"] forState:UIControlStateDisabled];
        [_btn4 setTitle:@"平台担保" forState:UIControlStateNormal];
        _btn4.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        _btn4.titleEdgeInsets = UIEdgeInsetsMake(70, -50, 0, 0);
        _btn4.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _btn4.enabled = NO;
        [_btn4 setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateDisabled];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = 50.f;
    CGFloat sepWidth = (self.contentView.width-60-4*50)/3;
    CGFloat marginLeft = 30.f;
    
    _btn1.frame = CGRectMake(marginLeft, 24, 50, self.contentView.height-24);
    marginLeft += width;
    marginLeft += sepWidth;
    _btn2.frame = CGRectMake(marginLeft, 24, 50, self.contentView.height-24);
    marginLeft += width;
    marginLeft += sepWidth;
    _btn3.frame = CGRectMake(marginLeft, 24, 50, self.contentView.height-24);
    marginLeft += width;
    marginLeft += sepWidth;
    _btn4.frame = CGRectMake(marginLeft, 24, 50, self.contentView.height-24);
}

@end



