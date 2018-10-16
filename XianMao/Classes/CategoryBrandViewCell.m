//
//  CategoryBrandViewCell.m
//  XianMao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CategoryBrandViewCell.h"
#import "Masonry.h"
#import "CateScrollView.h"
#import "BrandHotView.h"

@interface CategoryBrandViewCell ()

@property (nonatomic, strong) NSMutableArray *dataArr;
@property (nonatomic, strong) CateScrollView *scrollView;
@property (nonatomic, strong) BrandHotView *brandHotView;

@end

@implementation CategoryBrandViewCell

-(BrandHotView *)brandHotView{
    if (!_brandHotView) {
        _brandHotView = [[BrandHotView alloc] initWithFrame:CGRectZero];
    }
    return _brandHotView;
}

-(CateScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[CateScrollView alloc] initWithFrame:CGRectZero];
    }
    return _scrollView;
}

-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc] init];
    }
    return _dataArr;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)setIndex:(NSInteger)index{
    _index = index;
    if (self.index == 1) {
        [self.contentView addSubview:self.scrollView];
    } else if (self.index == 2) {
        [self.contentView addSubview:self.brandHotView];
    }
    [self setUpUI];
}

-(void)setUpUI{
    if (self.index == 1) {
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.bottom.equalTo(self.contentView.mas_bottom);
        }];
    } else if (self.index == 2) {
        [self.brandHotView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
}


@end
