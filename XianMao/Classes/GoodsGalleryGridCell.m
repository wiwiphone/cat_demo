//
//  GoodsGalleryGridCell.m
//  XianMao
//
//  Created by simon on 1/17/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "GoodsGalleryGridCell.h"
#import "GoodsInfo.h"
#import "DataSources.h"
#import "CoordinatingController.h"
#import "Command.h"

@interface GoodsGalleryGridCell ()

@property(nonatomic,strong) GoodsSellerInfoView *sellerInfoView;
@property(nonatomic,strong) GoodsGalleryGridView *gridView;
@property(nonatomic,strong) UILabel *nameLbl;
@property(nonatomic,strong) UIButton *timestampLbl;
@property(nonatomic,strong) GoodsApproveTagsView *tagView;
@property(nonatomic,strong) UILabel *summaryLbl;
@property(nonatomic,strong) GoodsPricesView *pricesView;
@property(nonatomic,strong) GoodsLikedUsersView *likedUsersView;
@property(nonatomic,strong) GoodsActionButtonsView *actionButtonsView;

@property(nonatomic,copy) NSString *goodsId;

@end

@implementation GoodsGalleryGridCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsGalleryGridCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    NSObject *obj = [dict objectForKey:[self cellDictKeyForGoodsInfo]];
    if ([obj isKindOfClass:[GoodsInfo class]]) {
        GoodsInfo *item = (GoodsInfo*)obj;
        height = [GoodsGalleryGridCell calculateHeightAndLayoutSubviews:nil item:item];
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsGalleryGridCell class]];
    if (item)[dict setObject:item forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"item";
}

- (void)dealloc
{
    self.sellerInfoView = nil;
    self.nameLbl = nil;
    self.tagView = nil;
    self.summaryLbl = nil;
    self.pricesView = nil;
    self.likedUsersView = nil;
    self.actionButtonsView = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        self.sellerInfoView = [[GoodsSellerInfoView alloc] initWithFrame:CGRectNull];
//        self.sellerInfoView.backgroundColor = [UIColor whiteColor];
//        [self.contentView addSubview:self.sellerInfoView];
        
        self.gridView = [[GoodsGalleryGridView alloc] initWithFrame:CGRectNull];
        self.gridView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.gridView];
        
        self.nameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
//        self.nameLbl.backgroundColor = [UIColor redColor];
        [self.nameLbl setLineBreakMode:NSLineBreakByWordWrapping];
        self.nameLbl.textColor = [DataSources goodsNameTextColor];
        self.nameLbl.font = [DataSources goodsNameTextFont];
        self.nameLbl.numberOfLines = 0;
        [self.contentView addSubview:self.nameLbl];
        
        self.timestampLbl = [[UIButton alloc] initWithFrame:CGRectNull];
        self.timestampLbl.backgroundColor = [UIColor clearColor];
        [self.timestampLbl setTitleColor:[DataSources goodsOnSaleTimeTextColor] forState:UIControlStateDisabled];
        self.timestampLbl.titleLabel.font = [DataSources goodsOnSaleTimeTextFont];
        [self.timestampLbl setImage:[DataSources goodsOnSaleTimeImg] forState:UIControlStateDisabled];
        [self.timestampLbl setTitleEdgeInsets: UIEdgeInsetsMake(0, 5, 0, 0)];
        self.timestampLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.timestampLbl.enabled = NO;
        [self addSubview:self.timestampLbl];
        
        
        self.tagView = [[GoodsApproveTagsView alloc] initWithFrame:CGRectNull];
        self.tagView.hidden = YES;
        self.tagView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.tagView];
        
        self.summaryLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.summaryLbl.textColor = [DataSources goodsSummaryTextColor];
        self.summaryLbl.font = [DataSources goodsSummaryTextFont];
        self.summaryLbl.numberOfLines = 0;
        [self.contentView addSubview:self.summaryLbl];
        
        self.pricesView = [[GoodsPricesView alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:self.pricesView];
        
        self.likedUsersView = [[GoodsLikedUsersView alloc] initWithFrame:CGRectNull];
        self.likedUsersView.hidden = YES;
        self.likedUsersView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.likedUsersView];
        
        self.actionButtonsView = [[GoodsActionButtonsView alloc] initWithFrame:CGRectNull];
        [self.contentView addSubview:self.actionButtonsView];
    }
    return self;
}

- (void)prepareForReuse {
    self.sellerInfoView.frame = CGRectNull;
    self.gridView.frame = CGRectNull;
    self.nameLbl.text = nil;
    self.nameLbl.frame = CGRectNull;
    self.tagView.frame = CGRectNull;
    self.tagView.hidden = YES;
    self.summaryLbl.text = nil;
    self.summaryLbl.frame = CGRectNull;
    self.pricesView.frame = CGRectNull;
    self.likedUsersView.frame = CGRectNull;
    self.likedUsersView.hidden = YES;
    self.actionButtonsView.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [[self class] calculateHeightAndLayoutSubviews:self item:nil];
}

+ (CGFloat)calculateHeightAndLayoutSubviews:(GoodsGalleryGridCell*)cell item:(GoodsInfo*)item
{
    CGFloat marginTop = 0.f;
    
    marginTop += 20.f;
    
    ///
//    if (cell) {
//        cell.sellerInfoView.frame = CGRectMake(0.f, marginTop, cell.contentView.width, [GoodsSellerInfoView heightForOrientationPortrait]);
//    }
//    marginTop += [GoodsSellerInfoView heightForOrientationPortrait];
    
    ///
    if (item && [item.goodsName length]>0) {
        CGSize goodsNameSize = [item.goodsName sizeWithFont:[DataSources goodsNameTextFont]
                                          constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                              lineBreakMode:NSLineBreakByWordWrapping];
        
        //marginTop += 18.f;
        marginTop += goodsNameSize.height;
    }
    else if (cell && [cell.nameLbl.text length]>0) {
        
        CGSize goodsNameSize = [cell.nameLbl.text sizeWithFont:[DataSources goodsNameTextFont]
                                             constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                                 lineBreakMode:NSLineBreakByWordWrapping];
        //marginTop += 18.f;
        cell.nameLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, goodsNameSize.height);
        marginTop += cell.nameLbl.height;
    }
    
    marginTop += 5;
    if (cell) {
        cell.timestampLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, 0);
        [cell.timestampLbl sizeToFit];
        cell.timestampLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, cell.timestampLbl.height);
    }
    marginTop += 14;
//    cell.nameLbl.backgroundColor = [UIColor orangeColor];
    
    ///
    if (item) {
        marginTop += 16.f;
        marginTop += [GoodsGalleryGridView heightForOrientationPortrait:item];
    } else if (cell) {
        marginTop += 16.f;
        cell.gridView.frame = CGRectMake(0.f, marginTop, CGRectGetWidth(cell.contentView.bounds), cell.gridView.height);
        marginTop += cell.gridView.height;
    }
    
    ///
    if (item && [item approveTagsCount]>0) {
        marginTop += 18;
        marginTop += [GoodsApproveTagsView heightForOrientationPortrait:item showTitle:NO];
    }
    else if (cell && !cell.tagView.hidden) {
        marginTop += 18;
        cell.tagView.frame = CGRectMake(0.f, marginTop, CGRectGetWidth(cell.contentView.bounds), cell.tagView.height);
        marginTop += cell.tagView.height;
    }
    
//    ///
//    if (item && [item.summary length]>0) {
//        marginTop += 15;
//        CGSize goodsSummarySize = [item.summary sizeWithFont:[DataSources goodsSummaryTextFont]
//                                           constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
//                                               lineBreakMode:NSLineBreakByWordWrapping];
//        marginTop += goodsSummarySize.height;
//    }
//    else if (cell && [cell.summaryLbl.text length]>0) {
//        marginTop += 15;
//        
//        CGSize goodsSummarySize = [cell.summaryLbl.text sizeWithFont:[DataSources goodsSummaryTextFont]
//                                                   constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
//                                                       lineBreakMode:NSLineBreakByWordWrapping];
//        
//        cell.summaryLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, goodsSummarySize.height);
//        marginTop += goodsSummarySize.height;
//    }
    
    ///
    marginTop += 15;
    if (cell) {
        cell.pricesView.frame = CGRectMake(0, marginTop, CGRectGetWidth(cell.contentView.bounds), [GoodsPricesView heightForOrientationPortrait]);
    }
    marginTop += [GoodsPricesView heightForOrientationPortrait];
    marginTop += 13;
    
    ///
    if (cell) {
        cell.actionButtonsView.frame = CGRectMake(0, marginTop, CGRectGetWidth(cell.contentView.bounds), [GoodsActionButtonsView heightForOrientationPortrait]);
    }
    marginTop += [GoodsActionButtonsView heightForOrientationPortrait];
    
    marginTop+= 7.f;
    
    return marginTop;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    NSObject *obj = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
    if ([obj isKindOfClass:[GoodsInfo class]]) {
        GoodsInfo *goodsInfo = (GoodsInfo*)obj;
        
        self.goodsId = goodsInfo.goodsId;
        
        ///
//        [self.sellerInfoView updateWithGoodsInfo:goodsInfo];
        
        [self.gridView updateWithGoodsInfo:goodsInfo];

        ///
        self.nameLbl.text = goodsInfo.goodsName;
        self.summaryLbl.text = goodsInfo.summary;
        
        [self.timestampLbl setTitle:[GoodsInfo formattedDateDescription:goodsInfo.modifyTime] forState:UIControlStateDisabled];
        
        //
        [self.pricesView updateWithGoodsInfo:goodsInfo];
        
        //
        self.tagView.hidden =[goodsInfo approveTagsCount]>0?NO:YES;
        [self.tagView updateWithGoodsInfo:goodsInfo showTitle:NO];
        
        //        self.likedUsersView.hidden = [goodsInfo likes].totalNum>0&&[[goodsInfo likes].users count]>0?NO:YES;
        //        [self.likedUsersView updateWithGoodsInfo:goodsInfo];
        
        [self.actionButtonsView updateWithGoodsInfo:goodsInfo withTitleAndNum:YES];
        
        [self setNeedsDisplay];
    }
}

- (void)detail:(UIButton*)sender
{
    [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:self.goodsId animated:YES];
}

@end


@interface GoodsGalleryGridView ()

@property(nonatomic,copy) NSString *goodsId;

@end

@implementation GoodsGalleryGridView

+ (CGFloat)heightForOrientationPortrait:(GoodsInfo*)goodsInfo {
    CGFloat height = 0.f;
    if ([goodsInfo.gallaryItems count]>1) {
        height = (kScreenWidth-30.f+2.5f)/3 -2.5;
    } else {
        height = (kScreenWidth-30.f+2.5f)*2/3 -2.5;
    }
    return height;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSArray *subViews = [self subviews];
    CGFloat X = 15.f;
    CGFloat width = self.bounds.size.height;
    CGFloat height = width;
    
    for (int i=0;i<[subViews count];i++) {
        UIView *view = [subViews objectAtIndex:i];
        view.frame = CGRectMake(X, 0, width, height);
        X += width;
        X += 2.5f;
    }
}

- (void)dealloc
{
    NSArray *subViews = [self subviews];
    for (int i=0;i<[subViews count];i++) {
        UIView *view = [subViews objectAtIndex:i];
        [view removeFromSuperview];
    }
}

- (void)updateWithGoodsInfo:(GoodsInfo*)goodsInfo
{
    self.goodsId = goodsInfo.goodsId;
    
    NSMutableArray *gallaryItems = [[NSMutableArray alloc] initWithCapacity:[[goodsInfo gallaryItems] count]+1];
    [gallaryItems addObjectsFromArray:[goodsInfo gallaryItems]];
    GoodsGallaryItem *mainPicItem = [[GoodsGallaryItem alloc] init];
    if (mainPicItem) {
        mainPicItem.picUrl = goodsInfo.mainPicUrl;
        [gallaryItems insertObject:mainPicItem atIndex:0];
    }
    
    NSInteger picsCount = [gallaryItems count];
    if (picsCount == 0) {
        picsCount = 1; //显示主图
    }
    
    NSArray *subViews = [self subviews];
    NSInteger count = [subViews count];
    for (NSInteger i=count;i<picsCount;i++) {
        XMWebImageView *view = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        view.userInteractionEnabled = YES;
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        view.hidden = YES;
        [self addSubview:view];
    }
    
    for (UIView *view in [self subviews]) {
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.hidden = YES;
    }
    
    //if ([[goodsInfo gallaryItems] count]>0)
    if ([gallaryItems count]>0)
    {
        if ([gallaryItems count]>1) {
            NSInteger count = [gallaryItems count]>3?3:[gallaryItems count];
            
            for (int i=0;i<count;i++) {
                GoodsGallaryItem *galleryItem = (GoodsGallaryItem*)[gallaryItems objectAtIndex:i];
                XMWebImageView *view = (XMWebImageView*)[[self subviews] objectAtIndex:i];
                view.hidden = NO;
                [view setImageWithURL:galleryItem.picUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
            }
            
            CGFloat height = (kScreenWidth-30.f+2.5f)/3-2.5;;
            self.frame = CGRectMake(0, 0, kScreenWidth, height);
        } else {
            GoodsGallaryItem *galleryItem = (GoodsGallaryItem*)[gallaryItems objectAtIndex:0];
            XMWebImageView *imgView = (XMWebImageView*)[[self subviews] objectAtIndex:0];
            imgView.hidden = NO;
            
            [imgView setImageWithURL:galleryItem.picUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
            
            CGFloat height = (kScreenWidth-30.f+2.5f)*2/3-2.5;;
            self.frame = CGRectMake(0, 0, kScreenWidth, height);
        }
    } else {
        XMWebImageView *imgView = (XMWebImageView*)[[self subviews] objectAtIndex:0];
        imgView.hidden = NO;

//
        [imgView setImageWithURL:goodsInfo.mainPicUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        
        CGFloat height = (kScreenWidth-30.f+2.5f)*2/3-2.5;;
        self.frame = CGRectMake(0, 0, kScreenWidth, height);
    }
    
    [self setNeedsLayout];
}

@end





