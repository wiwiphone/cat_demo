//
//  UserHomeTableViewCell.m
//  XianMao
//
//  Created by simon cai on 29/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "UserHomeTableViewCell.h"
#import "User.h"
#import "UserDetailInfo.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

#import "UIImage+Resize.h"

@implementation UserTagsTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([UserTagsTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 105.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(User*)userInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[UserTagsTableViewCell class]];
    if (userInfo)[dict setObject:userInfo forKey:[self cellKeyForUserInfo]];
    return dict;
}

+ (NSString*)cellKeyForUserInfo {
    return @"userInfo";
}

- (void)dealloc
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    
}

@end


@interface UserSummaryTableViewCell ()

@property(nonatomic,strong) UILabel *titleLbl;
@property(nonatomic,strong) UILabel *summaryLbl;

@end

@implementation UserSummaryTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([UserSummaryTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        UserDetailInfo *userDetailInfo = [dict objectForKey:[[self class] cellKeyForUserDetailInfo]];
        if ([userDetailInfo isKindOfClass:[UserDetailInfo class]]) {
            height = [[self class] caculateAndLayoutSubviews:nil userDetailInfo:userDetailInfo];
        }
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(UserDetailInfo*)userDetailInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[UserSummaryTableViewCell class]];
    if (userDetailInfo)[dict setObject:userDetailInfo forKey:[self cellKeyForUserDetailInfo]];
    return dict;
}

+ (NSString*)cellKeyForUserDetailInfo {
    return @"userDetailInfo";
}

- (void)dealloc
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
     
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:_titleLbl];
        
        _summaryLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _summaryLbl.textColor = [UIColor colorWithHexString:@"666666"];
        _summaryLbl.font = [UIFont systemFontOfSize:12.f];
        _summaryLbl.numberOfLines = 0;
        [self.contentView addSubview:_summaryLbl];
    }
    return self;
}

+ (CGFloat)caculateAndLayoutSubviews:(UserSummaryTableViewCell*)cell userDetailInfo:(UserDetailInfo*)userDetailInfo {
    CGFloat marginTop = 0;
    marginTop += 10;
    
    NSString *summaryText = userDetailInfo?userDetailInfo.userInfo.summary:cell.summaryLbl.text;
    CGSize summarySize = [summaryText sizeWithFont:[UIFont systemFontOfSize:12.f]
                                 constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
                                     lineBreakMode:NSLineBreakByWordWrapping];
    marginTop += summarySize.height;
//    marginTop += 15;
    
    if (cell) {
        cell.titleLbl.frame = CGRectMake(15, 0, kScreenWidth-30, 44);
        cell.summaryLbl.frame = CGRectMake(15, 10, kScreenWidth-30, summarySize.height);
    }
    
    return marginTop;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleLbl.frame = CGRectZero;
    self.summaryLbl.frame = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [[self class] caculateAndLayoutSubviews:self userDetailInfo:nil];
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        UserDetailInfo *userDetailInfo = [dict objectForKey:[[self class] cellKeyForUserDetailInfo]];
        if ([userDetailInfo isKindOfClass:[UserDetailInfo class]]) {
            
            _titleLbl.text = @"介绍";
            _summaryLbl.text = [userDetailInfo.userInfo.summary length]>0?userDetailInfo.userInfo.summary:@"暂无内容";
            
            _titleLbl.hidden = YES;
            
            [self setNeedsLayout];
        }
    }
}

@end


#import "MJPhoto.h"
#import "MJPhotoBrowser.h"

@interface UserIntroGalleryTableViewCell ()

@property(nonatomic,strong) UILabel *titleLbl;
@property(nonatomic,strong) UILabel *galleryView;
@property(nonatomic,strong) UILabel *phoneLbl;
@property(nonatomic,strong) UILabel *addressLbl;

@property(nonatomic,strong) UserDetailInfo *userDetailInfo;

@end

@implementation UserIntroGalleryTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([UserIntroGalleryTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        UserDetailInfo *userDetailInfo = [dict objectForKey:[[self class] cellKeyForUserDetailInfo]];
        if ([userDetailInfo isKindOfClass:[UserDetailInfo class]]) {
            height = [[self class] caculateAndLayoutSubviews:nil userDetailInfo:userDetailInfo];
        }
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(UserDetailInfo*)userDetailInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[UserIntroGalleryTableViewCell class]];
    if (userDetailInfo)[dict setObject:userDetailInfo forKey:[self cellKeyForUserDetailInfo]];
    return dict;
}

+ (NSString*)cellKeyForUserDetailInfo {
    return @"userDetailInfo";
}

- (void)dealloc
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _titleLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:_titleLbl];
        
        _galleryView = [[UILabel alloc] initWithFrame:CGRectNull];
        _galleryView.backgroundColor = [UIColor clearColor];
        _galleryView.textColor = [UIColor colorWithHexString:@"666666"];
        _galleryView.font = [UIFont systemFontOfSize:12.f];
        _galleryView.numberOfLines = 0;
        _galleryView.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_galleryView];
        
        _phoneLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _phoneLbl.textColor = [UIColor colorWithHexString:@"666666"];
        _phoneLbl.font = [UIFont systemFontOfSize:12.f];
        _phoneLbl.numberOfLines = 0;
        [self.contentView addSubview:_phoneLbl];
        
        _addressLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _addressLbl.textColor = [UIColor colorWithHexString:@"666666"];
        _addressLbl.font = [UIFont systemFontOfSize:12.f];
        _addressLbl.numberOfLines = 0;
        [self.contentView addSubview:_addressLbl];
    }
    return self;
}

+ (CGFloat)galleryItemWidth {
    CGFloat width = (kScreenWidth-30-5)/3;
    return width;
}
+ (CGSize)gallerySize:(NSArray*)storeGallary {
    CGFloat height = [self galleryItemWidth];
    CGFloat galleryHeight = height;
    CGFloat galleryWidth = height;
    if ([storeGallary count]>0) {
        NSInteger row = [storeGallary count]/3+([storeGallary count]%3>0?1:0);
        if (row>1)
            galleryHeight = (row*height+(row-1)*2.5f);
        else
            galleryHeight = row*height;
        galleryWidth = kScreenWidth-30;
    } else {
        galleryHeight = height;
        galleryWidth = height;
    }
    return CGSizeMake(galleryWidth, galleryHeight);
}

+ (CGFloat)caculateAndLayoutSubviews:(UserIntroGalleryTableViewCell*)cell userDetailInfo:(UserDetailInfo*)userDetailInfo {
    CGFloat marginTop = 0;
    //marginTop += 44;
    marginTop += 10;
    
    if (cell) {
        cell.titleLbl.frame = CGRectMake(15, 0, kScreenWidth-30, 44);
    }
    
    if (userDetailInfo) {
        CGSize gallerySize = [self gallerySize:userDetailInfo.gallary];
        marginTop += gallerySize.height;
    }
    else if (cell) {
        cell.galleryView.frame = CGRectMake(15, marginTop, cell.galleryView.width, cell.galleryView.height);
        marginTop += cell.galleryView.height;
    }
//    
//    marginTop += 15;
//    
//    NSString *addressText = userDetailInfo?userDetailInfo.storeInfo.addressFullString:cell.addressLbl.text;
//    CGSize addressSize = [addressText sizeWithFont:[UIFont systemFontOfSize:12.f]
//                                 constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
//                                     lineBreakMode:NSLineBreakByWordWrapping];
//    
//    if (cell) {
//        cell.addressLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, addressSize.height);
//    }
//    marginTop += addressSize.height;
//    marginTop += 6;
//    NSString *phoneText = userDetailInfo?userDetailInfo.storeInfo.phoneFullString:cell.phoneLbl.text;
//    CGSize phoneSize = [phoneText sizeWithFont:[UIFont systemFontOfSize:12.f]
//                                 constrainedToSize:CGSizeMake(kScreenWidth-30,MAXFLOAT)
//                                     lineBreakMode:NSLineBreakByWordWrapping];
//    if (cell) {
//        cell.phoneLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, phoneSize.height);
//    }
//    marginTop += phoneSize.height;
    marginTop += 15;
    
    return marginTop;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.titleLbl.frame = CGRectZero;
    self.galleryView.frame = CGRectZero;
    self.phoneLbl.frame = CGRectZero;
    self.addressLbl.frame = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [[self class] caculateAndLayoutSubviews:self userDetailInfo:nil];
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        UserDetailInfo *userDetailInfo = [dict objectForKey:[[self class] cellKeyForUserDetailInfo]];
        if ([userDetailInfo isKindOfClass:[UserDetailInfo class]]) {
            
            _userDetailInfo = userDetailInfo;
            _titleLbl.text = @"照片";
            _titleLbl.hidden = YES;
//            _addressLbl.text = userDetailInfo.storeInfo.addressFullString;
//            _phoneLbl.text = userDetailInfo.storeInfo.phoneFullString;
            
            CGSize gallerySize = [[self class] gallerySize:userDetailInfo.gallary];
            _galleryView.frame = CGRectMake(15, 44, gallerySize.width, gallerySize.height);
            
            for (UIView *view in [_galleryView subviews]) {
                [view removeFromSuperview];
            }
            
            if ([userDetailInfo.gallary count]>0) {
                _galleryView.backgroundColor = [UIColor clearColor];
                _galleryView.text = nil;
                _galleryView.userInteractionEnabled = YES;
                
                CGFloat width = [[self class] galleryItemWidth];
                CGFloat X = 0.f;
                CGFloat Y = 0.f;
                for (NSInteger i=0;i< userDetailInfo.gallary.count;i++) {
                    PictureItem *item = [userDetailInfo.gallary objectAtIndex:i];
                    if ([item isKindOfClass:[PictureItem class]]) {
                        XMWebImageView *imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(X, Y, width, width)];
                        imageView.tag = i;
                        imageView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
                        [imageView setImageWithURL:item.picUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale160x160];
                        [_galleryView addSubview:imageView];
                        X += width;
                        X += 2.5f;
                        if (X >= _galleryView.width) {
                            X = 0;
                            Y += (width+2.5);
                        }
                        
                        WEAKSELF;
                        imageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
                            [weakSelf handleImageViewClicked:view];
                        };
                    }
                }
                
            } else {
                _galleryView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
                _galleryView.text = @"暂无图片";
            }
            
            [self setNeedsLayout];
        }
    }
}

- (void)handleImageViewClicked:(XMWebImageView*)view
{
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_userDetailInfo.gallary.count];
    for (NSInteger i=0;i< _userDetailInfo.gallary.count;i++) {
        PictureItem *item = [_userDetailInfo.gallary objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:item.picUrl];
        if (i<[_galleryView subviews].count) {
            photo.srcImageView = [[_galleryView subviews] objectAtIndex:i];
        } else {
            photo.srcImageView = view; // 来源于哪个UIImageView
        }
        [photos addObject:photo];
    }
    
    // 2.显示相册
    if ([photos count]>0) {
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.photos = photos; // 设置所有的图片
        browser.currentPhotoIndex = view.tag>0&&view.tag<_userDetailInfo.gallary.count?view.tag:0;
        [browser show];
    }
}

@end


#import "SearchFilterInfo.h"
#import "Command.h"

@interface UserHomeSearchFilterButton : CommandButton
@property(nonatomic,strong) SearchFilterInfo *filterInfo;
@end

@implementation UserHomeSearchFilterButton
@end

@interface UserHomeSearchFilterCell ()

@property(nonatomic,weak) UIView *btnsView;

@end

@implementation UserHomeSearchFilterCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([UserHomeSearchFilterCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 37.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSArray*)filterInfoArray
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[UserHomeSearchFilterCell class]];
    if (filterInfoArray)[dict setObject:filterInfoArray forKey:[self cellKeyForFilterInfoArray]];
    return dict;
}

+ (NSString*)cellKeyForFilterInfoArray
{
    return @"filterInfoArray";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *btnsView = [[UIView alloc] initWithFrame:CGRectZero];
        btnsView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:btnsView];
        _btnsView = btnsView;
        
        for (NSInteger i=0;i<4;i++) {
            UserHomeSearchFilterButton *btn = [[UserHomeSearchFilterButton alloc] initWithFrame:CGRectZero];
            btn.backgroundColor = [UIColor clearColor];
            btn.hidden = YES;
            btn.layer.borderColor = [UIColor colorWithHexString:@"E8E8E8"].CGColor;
            btn.layer.borderWidth = 0.5f;
            btn.layer.masksToBounds = YES;
            [_btnsView addSubview:btn];
        }
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    for (UIView *view in [_btnsView subviews]) {
        view.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _btnsView.frame = self.contentView.bounds;
    
    NSInteger count = 0;
    for (UIView *view in _btnsView.subviews) {
        if (![view isHidden]) {
            count+=1;
        }
    }
    if (count > 0) {
        CGFloat width = (self.contentView.width+0.5*2)/count+(count-0.5);
        CGFloat X = -0.5f;
        CGFloat Y = 0.f;
        for (UIView *view in _btnsView.subviews) {
            if (view.isHidden) {
                break;
            }
            view.frame = CGRectMake(X, Y, width, self.contentView.height);
            X += view.width;
            X -= 0.5;
        }
    }
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        
        WEAKSELF;
        UserHomeSearchFilterButton *searchBtn = (UserHomeSearchFilterButton*)[_btnsView.subviews objectAtIndex:0];
        [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
        [searchBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:12.5f];
        [searchBtn setImage:[UIImage imageNamed:@"UserHome_New_Search"] forState:UIControlStateNormal];
        searchBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -4, 0, 0);
        searchBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 0);
        searchBtn.hidden = NO;
        searchBtn.filterInfo = nil;
        searchBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleSearchFilterButtonActionBlock) {
                weakSelf.handleSearchFilterButtonActionBlock(((UserHomeSearchFilterButton*)sender).filterInfo);
            }
        };
        
        NSArray *filterInfoArray = [dict objectForKey:[[self class] cellKeyForFilterInfoArray]];
        if ([filterInfoArray isKindOfClass:[NSArray class]]) {
            for (NSInteger i=0;i<[filterInfoArray count];i++) {
                SearchFilterInfo *filterInfo = [filterInfoArray objectAtIndex:i];
                if ([filterInfo.items count]>=2 && i+1<[_btnsView.subviews count]) {
                    SearchFilterItem *filterItem = nil;
                    for (SearchFilterItem *filterItemTmp in filterInfo.items) {
                        if (filterItemTmp.isYesSelected) {
                            filterItem = filterItemTmp;
                            break;
                        }
                    }
                    
                    UserHomeSearchFilterButton *btn = (UserHomeSearchFilterButton*)[_btnsView.subviews objectAtIndex:i+1];
                    [btn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:12.5f];
                    btn.hidden = NO;
                    btn.filterInfo = filterInfo;
                    if (filterItem) {
                        [btn setTitle:filterItem.title forState:UIControlStateNormal];
                    } else {
                        [btn setTitle:filterInfo.name forState:UIControlStateNormal];
                    }
                    
                    
                    btn.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.handleSearchFilterButtonActionBlock) {
                            BOOL hanldLed = NO;
                            SearchFilterInfo *filterInfoTmp = ((UserHomeSearchFilterButton*)sender).filterInfo;
                            for (NSInteger j=0;j<filterInfoTmp.items.count;j++) {
                                SearchFilterItem *itemTmp1 = (SearchFilterItem*)[filterInfoTmp.items objectAtIndex:j];
                                if (itemTmp1.isYesSelected) {
                                    itemTmp1.isYesSelected = NO;
                                    if (j+1<filterInfoTmp.items.count) {
                                        SearchFilterItem *itemTmp2 = (SearchFilterItem*)[filterInfoTmp.items objectAtIndex:j+1];
                                        itemTmp2.isYesSelected = YES;
                                        hanldLed = YES;
                                        [sender setTitle:itemTmp2.title forState:UIControlStateNormal];
                                        break;
                                    }
                                }
                            }
                            if (!hanldLed && [filterInfoTmp.items count]>0) {
                                SearchFilterItem *itemTmp3 = (SearchFilterItem*)[filterInfoTmp.items objectAtIndex:0];
                                itemTmp3.isYesSelected = YES;
                                [sender setTitle:itemTmp3.title forState:UIControlStateNormal];
                            }
                            weakSelf.handleSearchFilterButtonActionBlock(filterInfoTmp);
                        }
                    };
                }
            }
        }
        [self setNeedsLayout];
    }
}

@end


@implementation UserHomeGoodsTotalNumCell {
    UILabel *_totalNumLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([UserHomeGoodsTotalNumCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 35;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSInteger)totalNum
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[UserHomeGoodsTotalNumCell class]];
    [dict setObject:[NSNumber numberWithInteger:totalNum] forKey:@"totalNum"];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        _totalNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalNumLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _totalNumLbl.font = [UIFont systemFontOfSize:12];
        _totalNumLbl.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_totalNumLbl];
    }
    return self;
}


- (void)prepareForReuse
{
    [super prepareForReuse];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _totalNumLbl.frame = self.contentView.bounds;
}


- (void)updateCellWithDict:(NSDictionary*)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        NSInteger totalNum = [dict integerValueForKey:@"totalNum"];
        _totalNumLbl.text = [NSString stringWithFormat:@"共有%ld件在售商品",(long)totalNum];
    }
    [self setNeedsLayout];
}

@end





