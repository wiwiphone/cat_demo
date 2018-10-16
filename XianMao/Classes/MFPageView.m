//
//  MFPageView.m
//  XianMao
//
//  Created by apple on 15/12/18.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import "MFPageView.h"
#import "MFPageViewCell.h"

@interface MFPageView () <UICollectionViewDataSource, UICollectionViewDelegate>

@end

static NSString *ID = @"MFPAGEVIEWID";
@implementation MFPageView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        [self registerClass:[MFPageViewCell class] forCellWithReuseIdentifier:ID];
        
        //设置样式
        self.bounces = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        
        self.delegate = self;
        self.dataSource = self;
        
        [self scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:10000 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    return self;
}

#pragma mark --------------CollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1000 * 1000;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MFPageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor orangeColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"%ld", indexPath.item);
}

@end
