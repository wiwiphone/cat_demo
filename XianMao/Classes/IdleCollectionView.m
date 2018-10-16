//
//  IdleCollectionView.m
//  XianMao
//
//  Created by apple on 16/10/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "IdleCollectionView.h"
#import "IdleCollectionViewCell.h"
#import "MJPhotoBrowser.h"
#import "ASScroll.h"
#import "MJPhoto.h"
#import "SDPhotoBrowser.h"

@interface IdleCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, MJPhotoBrowserDelegate, SDPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *picData;
@property (nonatomic, strong) GoodsInfo *goodsInfo;

@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *itemUrlArr;
@property (nonatomic, strong) ASScroll *scrollImageView;
@end

@implementation IdleCollectionView

-(NSMutableArray *)itemUrlArr{
    if (!_itemUrlArr) {
        _itemUrlArr = [[NSMutableArray alloc] init];
    }
    return _itemUrlArr;
}

-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        
        self.delegate = self;
        self.dataSource = self;
        
        [self registerClass:[IdleCollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
        
    }
    return self;
}

-(void)getPicData:(NSArray *)picData andGoodsInfo:(GoodsInfo *)goodsInfo{
    self.picData = picData;
    self.goodsInfo = goodsInfo;
    
    [self reloadData];
}

- (void)getPicData:(NSArray *)picData{
    self.picData = picData;
    [self reloadData];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.picData.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    IdleCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    
    [cell getPictureItem:self.picData[indexPath.item]];
    cell.imageView.tag = indexPath.item;
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
        WEAKSELF;
    [weakSelf.imageArr removeAllObjects];
    [weakSelf.itemUrlArr removeAllObjects];

    for (int i = 0; i < weakSelf.picData.count; i++) {
        PictureItem *item = weakSelf.picData [i];
        XMWebImageView *imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(i*((kScreenWidth/3+10)+10), 0, kScreenWidth/3+10, self.height)];
        [imageView setImageWithURL:item.picUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        
        [weakSelf.imageArr addObject:imageView];
        [weakSelf.itemUrlArr addObject:item.picUrl];
    }
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = weakSelf.imageArr.count;
    photoBrowser.sourceImagesContainerView = self;
    photoBrowser.goodsId = self.goodsInfo.goodsId;
    [photoBrowser show];
}

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    IdleCollectionViewCell *cell = (IdleCollectionViewCell *)[self collectionView:self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.imageView.image;
    
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.itemUrlArr[index];
    return [NSURL URLWithString:urlStr];
}


@end
