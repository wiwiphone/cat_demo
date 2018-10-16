//
//  IdleScrollView.m
//  XianMao
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "IdleScrollView.h"
#import "PictureItem.h"
#import "ASScroll.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface IdleScrollView () <MJPhotoBrowserDelegate, ASScrollViewDelegate>

@property (nonatomic, strong) ASScroll *scrollImageView;
@property (nonatomic, strong) NSMutableArray *arr;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSArray *gallary;
@property (nonatomic, strong) GoodsInfo *goodsInfo;

@property (nonatomic, strong) NSMutableArray *photoArr;
@end

@implementation IdleScrollView

-(NSMutableArray *)photoArr{
    if (!_photoArr) {
        _photoArr = [[NSMutableArray alloc] init];
    }
    return _photoArr;
}

-(NSArray *)gallary{
    if (!_gallary) {
        _gallary = [[NSArray alloc] init];
    }
    return _gallary;
}

-(NSMutableArray *)imageArr{
    if (!_imageArr) {
        _imageArr = [[NSMutableArray alloc] init];
    }
    return _imageArr;
}

-(NSMutableArray *)arr{
    if (!_arr) {
        _arr = [[NSMutableArray alloc] init];
    }
    return _arr;
}

-(ASScroll *)scrollImageView{
    if (!_scrollImageView) {
        _scrollImageView = [[ASScroll alloc] init];
        _scrollImageView.delegate = self;
    }
    return _scrollImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)getPicData:(NSArray *)picData andGoodsInfo:(GoodsInfo *)goodsInfo{
    self.gallary = picData;
    self.goodsInfo = goodsInfo;
    [self.arr removeAllObjects];
    if (self.subviews.count != 0) {
        [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    for (int i = 0; i < self.gallary .count; i++) {
        PictureItem *item = self.gallary [i];
        
        NSLog(@"%ld", self.subviews.count);
        
        XMWebImageView *imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(i*((kScreenWidth/3+10)+10), 0, kScreenWidth/3+10, self.height)];
        imageView.tag = i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?imageView2/3/w/200/h/100/q/90",item.picUrl]]];
        imageView.backgroundColor = [UIColor colorWithHexString:@"c7c7c7"];
        [self addSubview:imageView];
        [self.arr addObject:item.picUrl];
//        MJPhoto *mjPhoto = [[MJPhoto alloc] init];
//        mjPhoto.url = [NSURL URLWithString:item.picUrl];
//        [self.photoArr addObject:mjPhoto];
        WEAKSELF;
        imageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
            [self.imageArr removeAllObjects];
            for (int i = 0; i<weakSelf.gallary .count; i++) {
                PictureItem *item = weakSelf.gallary [i];
                XMWebImageView *imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(i*((kScreenWidth/3+10)+10), 0, kScreenWidth/3+10, self.height)];
                [imageView setImageWithURL:item.picUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
                
                [weakSelf.imageArr addObject:imageView];
            }
//            MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//            browser.delegate = self;
//            browser.photos = self.photoArr;
//            browser.currentPhotoIndex = 0;
//            [[CoordinatingController sharedInstance] presentViewController:browser animated:YES completion:nil];
            [weakSelf didClickViewPage:view imageViewImage:weakSelf.imageArr];
        };
    }
    self.contentSize = CGSizeMake((self.gallary.count*(kScreenWidth/3+10))+(10*(self.gallary .count-1)), self.height);
}

- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    [_scrollImageView setCurrentPage:index];
}

-(void)didClickViewPage:(UIImageView *)imageView imageViewImage:(NSArray *)imageViewArray
{
    // 1.封装图片数据
    //    NSMutableArray *imageViewArray = [NSMutableArray arrayWithObject:XMImageView];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.arr count]];
    for (NSInteger i=0;i< [self.arr count];i++) {
        
        //        MainPic *item = (MainPic*)[self.gallaryItems objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        NSString *QNDownloadUrl = nil;
        
        QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:self.arr[i] isWebP:NO scaleType:XMWebImageScale480x480];
        
        photo.url = [NSURL URLWithString:QNDownloadUrl]; // 图片路径
        if (i<imageViewArray.count) {
            photo.srcImageView = [imageViewArray objectAtIndex:i];
        } else {
            photo.srcImageView = imageView; // 来源于哪个UIImageView
        }
        [photos addObject:photo];
    }
    
    if ([photos count]>0) {
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.goodsId = self.goodsInfo.goodsId;
        browser.currentPhotoIndex = imageView.tag; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        browser.delegate = self;
        [browser show];
    }
}

@end
