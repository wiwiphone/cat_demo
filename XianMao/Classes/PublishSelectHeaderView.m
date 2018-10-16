//
//  PublishSelectHeaderView.m
//  XianMao
//
//  Created by 阿杜 on 16/3/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PublishSelectHeaderView.h"

#define kBaseTag 10000

@implementation PublishSelectHeaderView {
    
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)updateWithArr:(NSArray *)arr {
    self.dataArr = [arr copy];
    
//    UIView *headerTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
//    headerTitleView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
//    [self addSubview:headerTitleView];
//    //添加头 稍后算  Mark
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//    titleLbl.text = @"热门推荐";
//    titleLbl.backgroundColor = [UIColor blackColor];
//    titleLbl.font = [UIFont systemFontOfSize:10.f];
//    [titleLbl sizeToFit];
//    [headerTitleView addSubview:titleLbl];
//    titleLbl.frame = CGRectMake((20 - titleLbl.height) / 2, 15, titleLbl.width, titleLbl.height);
    
    for (int i = 0; i < arr.count; i++) {
        PublishHeaderCellView *view = [[PublishHeaderCellView alloc] initWithFrame:CGRectMake(0, (i * self.height / arr.count), kScreenWidth, self.height / arr.count)];
        view.tag = kBaseTag + i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [view addGestureRecognizer:tap];
        
        [view setupUI];
        [view updateWithDict:arr[i]];
        [self addSubview:view];
    }
}


- (void)tapAction:(UITapGestureRecognizer *)tap {
    NSLog(@"%ld", tap.view.tag - kBaseTag);
    if ([self.delegate respondsToSelector:@selector(headerViewTapAction:)]) {
        [self.delegate headerViewTapAction:tap.view.tag - kBaseTag];
    }
}

@end

@implementation PublishHeaderCellView {
    UILabel *_nameLbl;
//    UILabel *_summaryLbl;
//    UIImageView *_flagView;
//    UIImageView *_rightArrowView;
//    CALayer *_middleLine;
    CALayer *_bottomLine;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _nameLbl = [[UIInsetLabel alloc] initWithFrame:CGRectNull andInsets:UIEdgeInsetsMake(0, 15, 0, 15+17)];
        _nameLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _nameLbl.font = [UIFont systemFontOfSize:14.f];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.backgroundColor = [UIColor whiteColor];
//        _nameLbl.backgroundColor = [UIColor redColor];
        [self addSubview:_nameLbl];
        
//        _summaryLbl = [[UILabel alloc] initWithFrame:CGRectNull];
//        _summaryLbl.textColor = [UIColor colorWithHexString:@"aaaaaa"];
//        _summaryLbl.font = [UIFont systemFontOfSize:11.f];
//        _summaryLbl.textAlignment = NSTextAlignmentLeft;
//        _summaryLbl.numberOfLines = 0;
//        _summaryLbl.backgroundColor = [UIColor yellowColor];
//        [self addSubview:_summaryLbl];
        
        
//        _flagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"checked_big"]];
//        _flagView.hidden = YES;
//        [self addSubview:_flagView];
        
//        _rightArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow_gray"]];
//        _rightArrowView.hidden = YES;
//        [self addSubview:_rightArrowView];
        
//        _middleLine = [CALayer layer];
//        _middleLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
//        [self.layer addSublayer:_middleLine];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_bottomLine];
    }
    return self;
}

- (void)setupUI {
//    CGFloat height = [[self class] cellHeight];
    
    _nameLbl.frame = CGRectMake(0, 0, kScreenWidth, self.height);
    
//    _flagView.frame = CGRectMake(self.width-15-_flagView.width, (self.height-_flagView.height)/2, _flagView.width, _flagView.height);
//    _rightArrowView.frame = CGRectMake(self.width-15-_rightArrowView.width, (self.height-_rightArrowView.height)/2, _rightArrowView.width, _rightArrowView.height);
    
//    _middleLine.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
    
//    _summaryLbl.frame = CGRectMake(15, 0, kScreenWidth-15.f-15, 0);
//    [_summaryLbl sizeToFit];
//    _summaryLbl.frame = CGRectMake(15, self.height+8, kScreenWidth-30, _summaryLbl.height);
    
    _bottomLine.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)updateWithDict:(NSDictionary *)dict {
    
//    if ([_summaryLbl.text length]>0) {
//        _summaryLbl.hidden = NO;
//        _middleLine.hidden = NO;
//    } else {
//        _summaryLbl.hidden = YES;
//        _middleLine.hidden = YES;
//    }
    /*
     "brand_id": 7602,
     "brand_name": "爱彼",
     "brand_en_name": "AUDEMARS PIGUET",
     "logo_url": "http://static1.aidingmao.com/tb_import/20150822/42d6cdf953e1cacfe56c91507f2c202c.jpg"
     */
    _nameLbl.text = [dict objectForKey:@"brand_name"];
}

@end
