//
//  ReturnGoodsResultCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReturnGoodsResultCell.h"

@implementation ReturnGoodsResultCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ReturnGoodsResultCell class]);
    });
    return __reuseIdentifier;
}

+(CGFloat)rowHeightForPortrait
{
    CGFloat height = 170;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ReturnGoodsResultCell class]];
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    
}

-(UIView *)containerView
{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectZero];
        _containerView.backgroundColor = [UIColor colorWithHexString:@"434342"];
        _containerView.layer.cornerRadius = 3;
    }
    return _containerView;
}

-(UIView *)triangleView
{
    if (!_triangleView) {
        _triangleView = [[UIView alloc] initWithFrame:CGRectZero];
        _triangleView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"black_triangle"]];
    }
    return _triangleView;
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.containerView];
        [self.contentView addSubview:self.triangleView];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 20, 0, 20));
    }];
    
    [self.triangleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.right.equalTo(self.containerView.mas_left);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

@end
