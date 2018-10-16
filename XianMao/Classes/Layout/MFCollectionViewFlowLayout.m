//
//  MFCollectionViewFlowLayout.m
//  XianMao
//
//  Created by apple on 16/11/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MFCollectionViewFlowLayout.h"

@implementation MFCollectionViewFlowLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)prepareLayout{
    
    [super prepareLayout];
    //设置内边距
    CGFloat inset = (self.collectionView.frame.size.width - self.itemSize.width)*0.5;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    //设置滚动方向
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    //获得super已经计算好的属性
    NSArray *orignal = [super layoutAttributesForElementsInRect:rect];
    NSArray *array = [[NSArray alloc] initWithArray:orignal copyItems:YES];
    
//    //计算collectionView中心点位置
//    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
//    
//    for (UICollectionViewLayoutAttributes *attri in array) {
//    
////        cell中心点 和 collectionView最中心点x 的间距
//        CGFloat space = ABS(attri.center.x -  centerX) ;
//        
////        根据距离算缩放比例
//        CGFloat scale = 1- space/(self.collectionView.frame.size.width/2);
//        //进行缩放
//        attri.transform = CGAffineTransformMakeScale(scale, scale);
//    }
    return array;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //计算出最终显示的矩形框
    CGRect rect ;
    rect.origin.x = proposedContentOffset.x;
    rect.origin.y = 0;
    rect.size = self.collectionView.frame.size;
    
    //获得super已经计算好的属性
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    //计算CollectionView 最中心点x 的值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width/2;
    
    //存放最小的间距
    CGFloat minSpace = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attr in array) {
        
        if (ABS(minSpace) > ABS(attr.center.x - centerX)) {
            
            minSpace = attr.center.x - centerX;
        }
    }
    
    //修改原有的偏移量
    proposedContentOffset.x += minSpace;
    return proposedContentOffset;
}

@end
