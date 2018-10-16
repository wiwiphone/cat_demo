//
//  RecommendationView.m
//  XianMao
//
//  Created by 阿杜 on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecommendationView.h"
#import "RecommendationCell.h"
#import "GoodsDetailViewController.h"


@interface RecommendationView()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UILabel * label2;
@property (nonatomic, strong) UIView * view1;
@property (nonatomic, strong) UIView * view2;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSMutableArray * dataSources;

@end

@implementation RecommendationView


-(UILabel *)label
{
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.text = @"顾问推荐";
        _label.textColor = [UIColor colorWithHexString:@"333333"];
        _label.font = [UIFont systemFontOfSize:13];
        [_label sizeToFit];
        _label.textAlignment = NSTextAlignmentLeft;
    }
    return _label;
}

-(UILabel *)label2
{
    if (!_label2) {
        _label2 = [[UILabel alloc] init];
        _label2.text = @"Recommendation";
        _label2.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _label2.font = [UIFont systemFontOfSize:13];
        [_label2 sizeToFit];
        _label2.textAlignment = NSTextAlignmentLeft;
    }
    return _label2;
}

-(UIView *)view1
{
    if (!_view1) {
        _view1 = [[UIView alloc] init];
        _view1.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _view1;
}

-(UIView *)view2
{
    if (!_view2) {
        _view2 = [[UIView alloc] init];
        _view2.backgroundColor = [UIColor colorWithHexString:@"E5E5E5"];
    }
    return _view2;
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(88, 148);
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[RecommendationCell class] forCellWithReuseIdentifier:@"cell"];
        
    }
    return _collectionView;
}

-(instancetype)initWithFrame:(CGRect)frame adviserModel:(NSMutableArray *)adviser
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.dataSources = adviser;
        [self addSubview:self.label];
        [self addSubview:self.label2];
        [self addSubview:self.view1];
        [self addSubview:self.view2];
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark collectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AdviserGoodsModel * model = self.dataSources[indexPath.item];
    [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:model.goods_id animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RecommendationCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    AdviserGoodsModel * model = self.dataSources[indexPath.item];
    cell.model = model;
    return cell;
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(16);
        make.left.equalTo(self.mas_left).offset(12);
    }];
    
    [self.view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_top);
        make.bottom.equalTo(self.label.mas_bottom);
        make.left.equalTo(self.label.mas_right).offset(10);
        make.width.mas_equalTo(0.5);
    }];
    
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(16);
        make.left.equalTo(self.view1.mas_right).offset(10);
    }];
    
    [self.view2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).offset(16);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(12);
        make.height.mas_equalTo(0.5);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view2.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left).offset(12);
    }];
    
}

@end
