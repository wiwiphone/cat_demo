//
//  MineSeekCell.m
//  XianMao
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "MineSeekCell.h"
#import "NSDate+Additions.h"
#import "NSDate+Category.h"
#import "NeedsAttachmentVo.h"
#import "NeedsCollectionViewCell.h"
#import "SDPhotoBrowser.h"
#import "Command.h"
#import "GoodsDetailViewController.h"

@interface MineSeekCell () <UICollectionViewDataSource, UICollectionViewDelegate, SDPhotoBrowserDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *finishLbl;
@property (nonatomic, strong) NSMutableArray *needPicArr;
@property (nonatomic, strong) TapDetectingLabel *checkGoodsDeatil;
@property (nonatomic, strong) NSMutableArray *imageArr;
@property (nonatomic, strong) NSMutableArray *itemUrlArr;
@property (nonatomic, copy) NSString * goodsSn;
@end

@implementation MineSeekCell

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

-(UILabel *)finishLbl{
    if (!_finishLbl) {
        _finishLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _finishLbl.font = [UIFont systemFontOfSize:14.f];
        _finishLbl.textColor = [UIColor colorWithHexString:@"888888"];
        [_finishLbl sizeToFit];
    }
    return _finishLbl;
}

-(UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.font = [UIFont systemFontOfSize:14.f];
        _timeLbl.textColor = [UIColor colorWithHexString:@"888888"];
        [_timeLbl sizeToFit];
    }
    return _timeLbl;
}

-(TapDetectingLabel *)checkGoodsDeatil{
    if (!_checkGoodsDeatil) {
        _checkGoodsDeatil = [[TapDetectingLabel alloc] initWithFrame:CGRectZero];
        _checkGoodsDeatil.font = [UIFont systemFontOfSize:14.f];
        _checkGoodsDeatil.textColor = [UIColor colorWithHexString:@"457FB9"];
        _checkGoodsDeatil.text = @"查看匹配商品 >";
        [_checkGoodsDeatil sizeToFit];
    }
    return _checkGoodsDeatil;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
        _titleLbl.numberOfLines = 0;
    }
    return _titleLbl;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(100, 100);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 5;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([MineSeekCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat rowHeight = 0;
    NeedModel *needModel = [dict objectForKey:@"needModel"];
    NSArray * needPicArray = needModel.attachment;
    rowHeight += 11;
    if (needPicArray && needPicArray.count > 0) {
        rowHeight += 100;
    }
    rowHeight += 10;
    NSDictionary *Tdic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f],NSFontAttributeName, nil];
    CGRect  rect  = [needModel.content boundingRectWithSize:CGSizeMake(kScreenWidth-24, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:Tdic context:nil];
    rowHeight += rect.size.height;
    if (needModel.goodsSn && needModel.goodsSn.length > 0) {
        rowHeight += 20;
    }
    rowHeight += 10;
    rowHeight += 10;
    rowHeight += 10;
    return rowHeight;
}


+ (NSMutableDictionary*)buildCellDict:(NeedModel *)needModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[MineSeekCell class]];
    
    if (needModel) {
        [dict setObject:needModel forKey:@"needModel"];
    }
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.collectionView];
        [self.collectionView registerClass:[NeedsCollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.timeLbl];
        [self.contentView addSubview:self.finishLbl];
        [self.contentView addSubview:self.checkGoodsDeatil];
        
        
        WEAKSELF;
        GoodsDetailViewControllerContainer * viewController  = [[GoodsDetailViewControllerContainer alloc] init];
        self.checkGoodsDeatil.handleSingleTapDetected =^(TapDetectingLabel *view, UIGestureRecognizer *recognizer){
            if (weakSelf.goodsSn && weakSelf.goodsSn.length > 0) {
                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                viewController.goodsId = weakSelf.goodsSn;
            }
        };
        
    }
    return self;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    NeedModel *needModel = [dict objectForKey:@"needModel"];
    self.goodsSn = needModel.goodsSn;
    self.checkGoodsDeatil.hidden = needModel.goodsSn.length > 0 ? NO : YES;
    self.titleLbl.text = needModel.content;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:needModel.createtime/1000];
    self.timeLbl.text = [date XMformattedDateDescription];
    self.finishLbl.text = needModel.statusDesc;
    self.needPicArr = [[NSMutableArray alloc] initWithArray:needModel.attachment];
    [self layoutSubviews:needModel];
    [self.collectionView reloadData];
}

-(void)layoutSubviews:(NeedModel *)needModel{
    
    NSArray * needPicArray = needModel.attachment;
     CGFloat marginTop = 11;
    if (needPicArray && needPicArray.count > 0) {
        self.collectionView.frame = CGRectMake(12, 11, kScreenWidth-12, 100);
        marginTop += 100;
    }else{
        self.collectionView.frame = CGRectMake(12, 11, kScreenWidth-12, 0);
        marginTop = 0;
    }
    marginTop += 11;
    
    self.titleLbl.frame = CGRectMake(12, marginTop, kScreenWidth-24, 0);
    [self.titleLbl sizeToFit];
    self.titleLbl.frame = CGRectMake(12, marginTop, kScreenWidth-24, self.titleLbl.height);
    marginTop += self.titleLbl.height+10;
    
    if (needModel && needModel.goodsSn.length > 0) {
        self.checkGoodsDeatil.frame = CGRectMake(12, marginTop, kScreenWidth-24, 0);
        [self.checkGoodsDeatil sizeToFit];
        self.checkGoodsDeatil.frame = CGRectMake(12, marginTop, self.checkGoodsDeatil.width, 15);
        marginTop += 20;
    }else{
        self.checkGoodsDeatil.frame = CGRectMake(12, marginTop, kScreenWidth-24, 0);
        marginTop += 0;
    }
    
    self.timeLbl.frame = CGRectMake(12, marginTop, kScreenWidth-24, 0);
    [self.timeLbl sizeToFit];
    self.timeLbl.frame = CGRectMake(12, marginTop, self.timeLbl.width, self.timeLbl.height);
    
    self.finishLbl.frame = CGRectMake(kScreenWidth/2, marginTop, kScreenWidth, 0);
    [self.finishLbl sizeToFit];
    self.finishLbl.frame = CGRectMake(kScreenWidth-12-self.finishLbl.width, marginTop, self.finishLbl.width, self.finishLbl.height);

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.needPicArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    NeedsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    
    NeedsAttachmentVo *needsAttVo = self.needPicArr[indexPath.item];
    cell.imageView.tag = indexPath.item;
    [cell getNeedsAttrmendVo:needsAttVo];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WEAKSELF;
    [weakSelf.imageArr removeAllObjects];
    [weakSelf.itemUrlArr removeAllObjects];
    
    for (int i = 0; i < weakSelf.needPicArr.count; i++) {
        NeedsAttachmentVo *item = weakSelf.needPicArr [i];
        XMWebImageView *imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(i*((kScreenWidth/3+10)+10), 0, kScreenWidth/3+10, self.height)];
        [imageView setImageWithURL:item.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        [weakSelf.imageArr addObject:imageView];
        [weakSelf.itemUrlArr addObject:item.pic_url];
    }
    
    SDPhotoBrowser *photoBrowser = [SDPhotoBrowser new];
    photoBrowser.delegate = self;
    photoBrowser.currentImageIndex = indexPath.item;
    photoBrowser.imageCount = weakSelf.imageArr.count;
    photoBrowser.sourceImagesContainerView = self.collectionView;
    //    photoBrowser.goodsId = self.goodsInfo.goodsId;
    [photoBrowser show];
}

// 返回临时占位图片（即原来的小图）
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    // 不建议用此种方式获取小图，这里只是为了简单实现展示而已
    NeedsCollectionViewCell *cell = (NeedsCollectionViewCell *)[self collectionView:self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.imageView.image;
    
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    NSString *urlStr = self.itemUrlArr[index];
    return [NSURL URLWithString:urlStr];
}

@end
