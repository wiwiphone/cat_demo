//
//  PublishListView.m
//  yuncangcat
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishListView.h"

@interface PublishListView ()

@property (nonatomic,strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation PublishListView

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.numberOfLines = 0;
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        
    }
    return self;
}

-(void)getTipModel:(TipItemVo *)tipVo{
    CGFloat margin = 0;
    [self addSubview:self.titleLbl];
    self.titleLbl.text = tipVo.tip;
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-80);
    }];
    CGSize size = [self.titleLbl sizeThatFits:CGSizeMake(kScreenWidth-100, CGFLOAT_MAX)];
    margin += size.height;
    margin += 10;
    
    for (int i = 0; i < tipVo.picGuide.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i%4*70)+(i%4*10), margin + (i/4*70)+(i/4*10), 70, 70)];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tipVo.picGuide[i]]]];
        [self addSubview:imageView];
    }
}

@end
