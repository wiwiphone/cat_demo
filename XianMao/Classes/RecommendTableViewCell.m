//
//  RecommendTableViewCell.m
//  XianMao
//
//  Created by simon on 2/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "RecommendTableViewCell.h"
//修改为MFPageView
#import "XMPageView.h"
#import "MFPageView.h"
/**************************/
#import "CoordinatingController.h"
#import "URLScheme.h"
#import "GoodsStatusMaskView.h"
#import "DataSources.h"
#import "NSString+Addtions.h"
#import "WeakTimerTarget.h"
#import "Session.h"
#import "NetworkManager.h"
#import "GoodsEditableInfo.h"
#import "ForumTopicVO.h"
#import "ForumService.h"
#import "JSONKit.h"
#import "NetworkAPI.h"
/******************************/
#import "ASScroll.h"
#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import "MCFireworksButton.h"
#import "GoodsMemCache.h"
#import "SDCycleScrollView.h"
#import "NetworkManager.h"
#import "MFCollectionViewFlowLayout.h"
#import "SideSlipRedirectInfoCell.h"
#import "AnimatedGIFImageSerialization.h"
#import "TMCache.h"
#import "StyledPageControl.h"
#import "FindGoodGoodsView.h"
#import "GoodsCellTopView.h"

#define JBLACKCOLOR [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1]
#define BASECOLOR [UIColor colorWithHexString:@"c2a79d"]

@implementation RecommendTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(RecommendInfo*)recommendInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[recommendInfo recommendCellCls]];
    if (recommendInfo)[dict setObject:recommendInfo forKey:[self cellKeyForRecommendInfo]];
    return dict;
}

+ (NSString*)cellKeyForRecommendInfo {
    return @"recommendInfo";
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    
}

@end

@implementation RecommendSeperatorCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendSeperatorCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 6.f;
    RecommendInfo *recommendInfo = [dict objectForKey:[self cellKeyForRecommendInfo]];
    if ([recommendInfo isKindOfClass:[RecommendInfo class]]) {
    }
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //修改颜色  2016.9.22 Feng
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"f1f1ed"];
    }
    return self;
}

@end

@implementation RecommendActivityLimitPriceCell {
    
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendActivityLimitPriceCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = [RecommendActivityLimitedView rowHeightForPortrait]+[RecommendTitleView rowHeightForPortrait];
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    for (RecommendActivityLimitedView *view in [self.itemsView subviews]) {
        view.hidden = YES;
        [view prepareForReuse];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat sepWidth = (kScreenWidth*10)/320;
    
    CGFloat width = (kScreenWidth-4*sepWidth)/3;
    CGFloat X = 0.f;
    for (NSInteger i=0;i<3;i++) {
        UIView *view = [[super.itemsView subviews] objectAtIndex:i];
        view.frame = CGRectMake(X+sepWidth, 0, width, super.itemsView.height);
        X += width;
        X += sepWidth;
    }
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        
        CGFloat sepWidth = (kScreenWidth*10)/320;
        
        NSInteger goodsNum = 3;//[recommendInfo.list count]>3?3:[recommendInfo.list count];
        NSInteger count = [super.itemsView subviews].count;
        for (NSInteger i=count;i<goodsNum;i++) {
            RecommendActivityLimitedView *view = [[RecommendActivityLimitedView alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-4*sepWidth)/3, 0)];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
            view.backgroundColor = [UIColor clearColor];
            [super.itemsView addSubview:view];
        }
        
        for (UIView *view in super.itemsView.subviews) {
            view.hidden = YES;
        }
        
        [self setNeedsLayout];
        
        for (NSInteger i=0;i<[recommendInfo.list count];i++) {
            RecommendActivityLimitedView *view = (RecommendActivityLimitedView*)[[self.itemsView subviews] objectAtIndex:i];
            ActivityGoodsInfo *activityInfo = [recommendInfo.list objectAtIndex:i];
            if ([activityInfo isKindOfClass:[ActivityGoodsInfo class]]) {
                [view updateWithRedirectInfo:activityInfo];
                view.hidden = NO;
            }
        }
    }
}

@end


@implementation RecommendCategoryCell {
    RecommendTitleView *_titleView;
    CALayer *_lineMiddle;
    CALayer *_line1;
    CALayer *_line2;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendCategoryCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    //CGFloat height = 614/2+[RecommendTitleView rowHeightForPortrait];
    CGFloat height = (kScreenWidth * 307)/320+[RecommendTitleView rowHeightForPortrait];
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lineMiddle = [CALayer layer];
        _lineMiddle.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_lineMiddle];
        
        _line1 = [CALayer layer];
        _line1.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_line1];
        
        _line2 = [CALayer layer];
        _line2.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_line2];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    NSArray *subviews = [super.itemsView subviews];
    for (UIView *view in subviews) {
        view.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *subviews = [super.itemsView subviews];
    
    CGFloat marginTop = 12.f;
    
    UIView *view1 = [subviews objectAtIndex:0];
    //view1.frame = CGRectMake(15, marginTop, (super.itemsView.width-30)/2, 80);
    view1.frame = CGRectMake(15, marginTop, (super.itemsView.width-30)/2, (kScreenWidth * 80)/320);
    
    
    UIView *view2 = [subviews objectAtIndex:1];
    //view2.frame = CGRectMake(super.itemsView.width-(super.itemsView.width-30)/2-15, marginTop, (super.itemsView.width-30)/2, 80);
    view2.frame = CGRectMake(super.itemsView.width-(super.itemsView.width-30)/2-15, marginTop, (super.itemsView.width-30)/2, (kScreenWidth * 80)/320);
    
    //marginTop += 80.f;
    marginTop += view2.height;
    
    UIView *view3 = [subviews objectAtIndex:2];
    //view3.frame = CGRectMake(15, marginTop, (super.itemsView.width-30)/2, 200);
    view3.frame = CGRectMake(15, marginTop, (super.itemsView.width-30)/2, (kScreenWidth * 200)/320);
    
    UIView *view4 = [subviews objectAtIndex:3];
    //view4.frame = CGRectMake(super.itemsView.width-(super.itemsView.width-30)/2-15, marginTop, (super.itemsView.width-30)/2, 100);
    view4.frame = CGRectMake(super.itemsView.width-(super.itemsView.width-30)/2-15, marginTop, (super.itemsView.width-30)/2, (kScreenWidth * 100)/320);
    
    //marginTop += 100;
    marginTop += view4.height;
    
    UIView *view5 = [subviews objectAtIndex:4];
    view5.frame = CGRectMake(super.itemsView.width-(super.itemsView.width-30)/2-15, marginTop, (super.itemsView.width-30)/2, 100);
    view5.frame = CGRectMake(super.itemsView.width-(super.itemsView.width-30)/2-15, marginTop, (super.itemsView.width-30)/2, (kScreenWidth * 100)/320);
    
    //marginTop += 100;
    marginTop += view5.height;
    
    //    _lineMiddle.frame = CGRectMake(self.width/2-0.5f,self.itemsView.top+12,0.5f, marginTop-12.f);
    //    _line1.frame = CGRectMake(15,self.itemsView.top+80+12,self.itemsView.width-30, 0.5f);
    //
    //    _line2.frame = CGRectMake(self.itemsView.width/2,self.itemsView.top+80+12+100,self.itemsView.width/2-15.f, 0.5f);
    
    
    
    _lineMiddle.frame = CGRectMake(self.width/2-0.5f,self.itemsView.top+12,0.5f, marginTop-12.f);
    _line1.frame = CGRectMake(15,self.itemsView.top+(kScreenWidth*80)/320+12,self.itemsView.width-30, 0.5f);
    
    _line2.frame = CGRectMake(self.itemsView.width/2,self.itemsView.top+(kScreenWidth*80)/320+12+(kScreenWidth*100)/320,self.itemsView.width/2-15.f, 0.5f);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        
        NSInteger count = [super.itemsView subviews].count;
        for (NSInteger i=count;i<5;i++) {
            RedirectInfoView *view = [[RedirectInfoViewCatetory alloc] initWithFrame:CGRectZero];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
            view.backgroundColor = [UIColor clearColor];
            view.hidden = NO;
            [super.itemsView addSubview:view];
        }
        
        [self setNeedsLayout];
        
        NSArray *subviews = [super.itemsView subviews];
        if ([recommendInfo.list count]>0) {
            RedirectInfoView *view = [subviews objectAtIndex:0];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:0];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeTopLeft;
                
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/2*2, kScreenWidth*80/320*2)];
            }
        }
        
        if ([recommendInfo.list count]>1) {
            RedirectInfoView *view = [subviews objectAtIndex:1];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:1];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeTopRight;
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/2*2, kScreenWidth*80/320*2)];
                
            }
        }
        
        if ([recommendInfo.list count]>2) {
            RedirectInfoView *view = [subviews objectAtIndex:2];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:2];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeTopLeft;
                view.infoViewTileMarginTop = 15.f;
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/2*2, kScreenWidth*200/320*2)];
            }
        }
        
        if ([recommendInfo.list count]>3) {
            RedirectInfoView *view = [subviews objectAtIndex:3];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:3];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeTopRight;
                view.infoViewTileMarginTop = 10.f;
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/2*2, kScreenWidth*100/320*2)];
            }
        }
        
        if ([recommendInfo.list count]>4) {
            RedirectInfoView *view = [subviews objectAtIndex:4];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:4];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeTopRight;
                view.infoViewTileMarginTop = 10.f;
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/2*2, kScreenWidth*100/320*2)];
            }
        }
        
        [self setNeedsDisplay];
    }
}

@end


@implementation RecommendHotRankCell {
    CALayer *_line1;
    CALayer *_line2;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendHotRankCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = kScreenWidth*151/320+[RecommendTitleView rowHeightForPortrait];
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _line1 = [CALayer layer];
        _line1.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_line1];
        
        _line2 = [CALayer layer];
        _line2.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_line2];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    NSArray *subviews = [super.itemsView subviews];
    for (UIView *view in subviews) {
        view.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginTop = 12.f;
    
    CGFloat width = (self.itemsView.width-30)/3;
    CGFloat X = 15.f;
    for (UIView *view in [super.itemsView subviews]) {
        view.frame = CGRectMake(X, marginTop, width, 120.f);
        X += width;
    }
    
    _line1.frame = CGRectMake(15+width, self.itemsView.top+12, 0.5, 120.f);
    _line2.frame = CGRectMake(15+width+width, self.itemsView.top+12, 0.5, 120.f);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        NSInteger count = [super.itemsView subviews].count;
        for (NSInteger i=count;i<3;i++) {
            RedirectInfoView *view = [[RedirectInfoView alloc] initWithFrame:CGRectZero];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
            view.backgroundColor = [UIColor clearColor];
            view.hidden = NO;
            [super.itemsView addSubview:view];
        }
        
        for (NSInteger i=0;i<[recommendInfo.list count];i++) {
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:i];
            RedirectInfoView *view = [[super.itemsView subviews] objectAtIndex:i];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeTop;
                view.hidden = NO;
                
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((self.itemsView.width-30)/3*2, kScreenWidth*80/320*2)];
            }
        }
    }
}

@end

@implementation RecommendBrandCell {
    RecommendTitleView *_titleView;
    CALayer *_lineHorMiddle1;
    CALayer *_lineHorMiddle2;
    CALayer *_line1;
    CALayer *_line2;
    CALayer *_line3;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendBrandCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    //CGFloat height = 602/2+[RecommendTitleView rowHeightForPortrait];
    CGFloat height = (kScreenWidth * 301)/320+[RecommendTitleView rowHeightForPortrait];
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _lineHorMiddle1 = [CALayer layer];
        _lineHorMiddle1.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_lineHorMiddle1];
        
        _lineHorMiddle2 = [CALayer layer];
        _lineHorMiddle2.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_lineHorMiddle2];
        
        _line1 = [CALayer layer];
        _line1.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_line1];
        
        _line2 = [CALayer layer];
        _line2.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_line2];
        
        _line3 = [CALayer layer];
        _line3.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_line3];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    NSArray *subviews = [super.itemsView subviews];
    for (UIView *view in subviews) {
        view.hidden = YES;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *subviews = [super.itemsView subviews];
    
    CGFloat marginTop = 12.f;
    
    UIView *view1 = [subviews objectAtIndex:0];
    
    //view1.frame = CGRectMake(15, marginTop, (super.itemsView.width-30)/2, 80);
    view1.frame = CGRectMake(15, marginTop, (super.itemsView.width-30)/2, (kScreenWidth * 80)/320);
    
    UIView *view2 = [subviews objectAtIndex:1];
    //view2.frame = CGRectMake(super.itemsView.width-(super.itemsView.width-30)/2-15, marginTop, (super.itemsView.width-30)/2, 80);
    view2.frame = CGRectMake(super.itemsView.width-(super.itemsView.width-30)/2-15, marginTop, (super.itemsView.width-30)/2, (kScreenWidth * 80)/320);
    
    //marginTop += 80.f;
    marginTop += (kScreenWidth * 80)/320;
    _lineHorMiddle1.frame = CGRectMake(15, super.itemsView.top+marginTop-0.5f, super.itemsView.width-30, 0.5);
    
    
    UIView *view3 = [subviews objectAtIndex:2];
    //view3.frame = CGRectMake(15, marginTop, (super.itemsView.width-30)/2, 90);
    view3.frame = CGRectMake(15, marginTop, (super.itemsView.width-30)/2, (kScreenWidth * 90)/320);
    
    
    UIView *view4 = [subviews objectAtIndex:3];
    //view4.frame = CGRectMake(super.itemsView.width-(super.itemsView.width-30)/2-15, marginTop, (super.itemsView.width-30)/2, 90);
    view4.frame = CGRectMake(super.itemsView.width-(super.itemsView.width-30)/2-15, marginTop, (super.itemsView.width-30)/2, (kScreenWidth * 90)/320);
    
    //marginTop += 90;
    marginTop += (kScreenWidth * 90)/320;
    _lineHorMiddle2.frame = CGRectMake(15, super.itemsView.top+marginTop-0.5f, super.itemsView.width-30, 0.5f);
    _line1.frame = CGRectMake(super.itemsView.width/2-0.5f, super.itemsView.top+12, 0.5f, marginTop-12);
    
    UIView *view5 = [subviews objectAtIndex:4];
    //view5.frame = CGRectMake(15, marginTop, (super.itemsView.width-30)/3, 104);
    view5.frame = CGRectMake(15, marginTop, (super.itemsView.width-30)/3, (kScreenWidth * 104)/320);
    
    UIView *view6 = [subviews objectAtIndex:5];
    //view6.frame = CGRectMake(15+(super.itemsView.width-30)/3, marginTop, (super.itemsView.width-30)/3, 104);
    view6.frame = CGRectMake(15+(super.itemsView.width-30)/3, marginTop, (super.itemsView.width-30)/3, (kScreenWidth * 104)/320);
    
    UIView *view7 = [subviews objectAtIndex:6];
    //view7.frame = CGRectMake(super.itemsView.width-15-(super.itemsView.width-30)/3, marginTop, (super.itemsView.width-30)/3, 104);
    view7.frame = CGRectMake(super.itemsView.width-15-(super.itemsView.width-30)/3, marginTop, (super.itemsView.width-30)/3, (kScreenWidth * 104)/320);
    
    //_line2.frame = CGRectMake(15+(super.itemsView.width-30)/3, super.itemsView.top+marginTop, 0.5f, 104);
    //_line3.frame = CGRectMake(15+(super.itemsView.width-30)*2/3, super.itemsView.top+marginTop, 0.5f, 104);
    
    _line2.frame = CGRectMake(15+(super.itemsView.width-30)/3, super.itemsView.top+marginTop, 0.5f, (kScreenWidth * 104)/320);
    _line3.frame = CGRectMake(15+(super.itemsView.width-30)*2/3, super.itemsView.top+marginTop, 0.5f, (kScreenWidth * 104)/320);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        
        NSInteger count = [super.itemsView subviews].count;
        for (NSInteger i=count;i<7;i++) {
            RedirectInfoView *view = [[RedirectInfoViewBrand alloc] initWithFrame:CGRectZero];
            view.contentMode = UIViewContentModeScaleAspectFill;
            view.clipsToBounds = YES;
            view.backgroundColor = [UIColor clearColor];
            view.hidden = NO;
            [super.itemsView addSubview:view];
        }
        
        [self setNeedsLayout];
        
        NSArray *subviews = [super.itemsView subviews];
        if ([recommendInfo.list count]>0) {
            RedirectInfoView *view = [subviews objectAtIndex:0];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:0];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeMiddleRight;
                view.infoViewTileMarginLeft = -6.f;
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/2*2,(kScreenWidth * 80)/320*2)];
            }
        }
        
        if ([recommendInfo.list count]>1) {
            RedirectInfoView *view = view = [subviews objectAtIndex:1];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:1];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeMiddleLeft;
                view.infoViewTileMarginLeft = 6.f;
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/2*2,(kScreenWidth * 80)/320*2)];
            }
        }
        
        if ([recommendInfo.list count]>2) {
            RedirectInfoView *view = view = [subviews objectAtIndex:2];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:2];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeMiddleRight;
                view.infoViewTileMarginTop = 0.f;
                view.infoViewTileMarginLeft = -6.f;
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/2*2,(kScreenWidth * 80)/320*2)];
            }
        }
        
        if ([recommendInfo.list count]>3) {
            RedirectInfoView *view = [subviews objectAtIndex:3];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:3];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeMiddleLeft;
                view.infoViewTileMarginTop = 0.f;
                view.infoViewTileMarginLeft = 6.f;
                //[view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake(290*2, 90*2)];
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/2*2,(kScreenWidth * 80)/320*2)];
            }
        }
        
        if ([recommendInfo.list count]>4) {
            RedirectInfoView *view = [subviews objectAtIndex:4];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:4];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeTopLeft;
                view.infoViewTileMarginTop = 10.f;
                view.infoViewTileMarginLeft = 10.f;
                //[view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake(190*2, 104*2)];
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/3*2, (kScreenWidth * 104)/320*2)];
            }
        }
        
        if ([recommendInfo.list count]>5) {
            RedirectInfoView *view = [subviews objectAtIndex:5];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:5];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeTopLeft;
                view.infoViewTileMarginTop = 10.f;
                view.infoViewTileMarginLeft = 10.f;
                //[view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake(190*2, 104*2)];
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/3*2, (kScreenWidth * 104)/320*2)];
            }
        }
        
        if ([recommendInfo.list count]>6) {
            RedirectInfoView *view = [subviews objectAtIndex:6];
            view.hidden = NO;
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:6];
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                view.infoViewContentMode = RedirectInfoViewContentModeTopLeft;
                view.infoViewTileMarginTop = 10.f;
                view.infoViewTileMarginLeft = 10.f;
                //[view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake(190*2, 104*2)];
                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake((super.itemsView.width-30)/3*2, (kScreenWidth * 104)/320*2)];
            }
        }
        
        [self setNeedsLayout];
    }
    
}

@end


@implementation RecommendWaterFollowView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _visibleSubviewRects = [[NSMutableArray alloc] initWithCapacity:0];
        _visibleSubviews = [[NSMutableArray alloc] initWithCapacity:0];
        _resolvedSubviewRects = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)prepareForReuse {
    
    for (RedirectInfoView *view in [self subviews]) {
        if ([view isKindOfClass:[RedirectInfoView class]]) {
            [view prepareForReuse];
            view.hidden = YES;
        }
    }
}

- (void)updateWithRecommendInfo:(RecommendInfo*)recommendInfo {
    
    NSInteger count = [self subviews].count;
    for (NSInteger i=count;i<[recommendInfo.list count];i++) {
        RedirectInfoView *view = [[RedirectInfoView alloc] initWithFrame:CGRectNull];
        
        view.infoViewContentMode = RedirectInfoViewContentModeTopRight;
        [self addSubview:view];
    }
    
    for (RedirectInfoView *view in [self subviews]) {
        if ([view isKindOfClass:[RedirectInfoView class]]) {
            [view prepareForReuse];
            view.hidden = YES;
        }
    }
    
    for (NSInteger i=0;i<[recommendInfo.list count];i++) {
        RedirectInfoView *view = [[self subviews] objectAtIndex:i];
        RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:i];
        
        CGFloat width = [redirectInfo scaledWidth];
        CGFloat height = [redirectInfo scaledHeight];
        
        [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake(width*2, height*2)];
        view.frame = CGRectMake(0, 0, width, height);
        view.hidden = NO;
    }
    [self setNeedsLayout];
}

+ (CGFloat)rowHeightForPortrait:(RecommendInfo*)recommendInfo {
    CGFloat height = 0.f;
    
    if ([recommendInfo.list count]>0) {
        
        NSMutableArray *resolvedSubviewRects = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *sortedPointsArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        CGFloat precision = kScreenWidth * 0.005f;
        
        CGFloat X = .0f;
        CGFloat Y = .0f;
        
        [sortedPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(X, Y)] ];
        
        for (NSInteger i = 0; i<[recommendInfo.list count]; i ++) {
            
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:i];
            
            for (id pointObj in sortedPointsArray ) {
                
                CGPoint point = [pointObj CGPointValue];
                
                CGRect rectF = CGRectMake(point.x, point.y, redirectInfo.scaledWidth, redirectInfo.scaledHeight);
                
                // 有0.5的容错
                if(point.x+redirectInfo.scaledWidth > kScreenWidth + precision){
                    continue;
                }
                
                if (![[self class] isRectIntersect:rectF inArray:resolvedSubviewRects]) {
                    
                    [sortedPointsArray removeObject:[NSValue valueWithCGPoint:point]];
                    
                    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
                    [sortedPointsArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        CGPoint tmpPoint = [obj CGPointValue];
                        if (tmpPoint.y <= point.y ) {
                            [tempArray addObject:[NSValue valueWithCGPoint:tmpPoint]];
                        }
                    }];
                    
                    [sortedPointsArray removeObjectsInArray:tempArray];
                    
                    // 右上角
                    if (point.x + redirectInfo.scaledWidth <= kScreenWidth) {
                        [sortedPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x+redirectInfo.scaledWidth, point.y)]];
                    }
                    
                    BOOL flag = NO;
                    for (int t = 0 ; t < [sortedPointsArray count]; t ++) {
                        CGPoint maxPoint = [[sortedPointsArray objectAtIndex:t] CGPointValue];
                        if (maxPoint.y >= point.y + redirectInfo.scaledHeight) {
                            flag = YES;
                        }
                    }
                    
                    if (!flag) {
                        [sortedPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, point.y + redirectInfo.scaledHeight)]];
                    }
                    
                    //加入左下角的点
                    [sortedPointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(point.x, point.y + redirectInfo.scaledHeight)]];
                    
                    [sortedPointsArray sortUsingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
                        CGPoint p1 = [obj1 CGPointValue];
                        CGPoint p2 = [obj2 CGPointValue];
                        if (p1.y == p2.y) return p1.x > p2.x;
                        return p1.y > p2.y;
                    }];
                    [resolvedSubviewRects addObject:[NSValue valueWithCGRect:rectF]];
                    
                    break;
                }
            }
        }
        if ([sortedPointsArray count] > 0) {
            height = [[sortedPointsArray objectAtIndex:([sortedPointsArray count]-1)] CGPointValue].y;
        }
        
    }
    return height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [_visibleSubviews removeAllObjects];
    for (RedirectInfoView *view in [self subviews]) {
        if (![view isHidden]) {
            [_visibleSubviews addObject:view];
        }
    }
    
    [_visibleSubviewRects removeAllObjects];
    NSMutableArray *mPointArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    CGFloat precision = kScreenWidth * 0.005f;
    
    CGFloat X = 0.f;
    CGFloat Y = 0.f;
    
    [mPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(X, Y)] ];
    
    for (NSInteger i = 0; i<[_visibleSubviews count]; i ++) {
        RedirectInfoView *view = [_visibleSubviews objectAtIndex:i];
        
        for (NSInteger j = 0 ;j < [mPointArray count]; j ++) {
            CGPoint point = [[mPointArray objectAtIndex:j] CGPointValue];
            CGRect rectF = CGRectMake(point.x, point.y, view.width, view.height);
            
            if(point.x+view.frameWidth > kScreenWidth + precision){
                continue;
            }
            
            if (![self isRectIntersect:rectF]) {
                [mPointArray removeObject:[NSValue valueWithCGPoint:point]];
                NSMutableArray *tempArray = [[NSMutableArray alloc] initWithCapacity:0];
                [mPointArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    CGPoint tmpPoint = [obj CGPointValue];
                    if (tmpPoint.y <= point.y ) {
                        [tempArray addObject:[NSValue valueWithCGPoint:tmpPoint]];
                        //                        [tempArray addObject:[NSValue valueWithCGPoint:tmpPoint]];
                    }
                }];
                
                [mPointArray removeObjectsInArray:tempArray];
                
                if (point.x + view.width <= kScreenWidth) {
                    
                    
                    CGFloat X = point.x+view.width;
                    NSInteger nX = (NSInteger)(floor(X*10 + 0.5));
                    CGFloat rX = nX/10;
                    [mPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(rX, point.y)]];
                }
                
                BOOL flag = NO;
                for (int t = 0 ; t < [mPointArray count]; t ++) {
                    CGPoint maxPoint = [[mPointArray objectAtIndex:t] CGPointValue];
                    if (maxPoint.y >= point.y + view.height) {
                        flag = YES;
                    }
                }
                
                if (!flag) {
                    [mPointArray addObject:[NSValue valueWithCGPoint:CGPointMake(0, point.y + view.height)]];
                }
                
                CGPoint point2 = CGPointMake(point.x, point.y+view.height); //加入左下角的点
                [mPointArray addObject:[NSValue valueWithCGPoint:point2]];
                
                [mPointArray sortUsingComparator:^NSComparisonResult(NSValue *obj1, NSValue *obj2) {
                    CGPoint p1 = [obj1 CGPointValue];
                    CGPoint p2 = [obj2 CGPointValue];
                    if (p1.y == p2.y) return p1.x > p2.x;
                    return p1.y > p2.y;
                }];
                [_visibleSubviewRects addObject:[NSValue valueWithCGRect:rectF]];
                
                [view setFrame:CGRectMake(point.x, point.y, view.width, view.height)];
                break;
            }
        }
        
    }
}

+ (BOOL) isRectIntersect:(CGRect)origin inArray:(NSMutableArray *)rectArray
{
    for (NSInteger i = 0 ;i < [rectArray count]; i ++) {
        CGRect target = [[rectArray objectAtIndex:i] CGRectValue];
        if ([[self class] isRectOverlap:target andRect: origin ]) {
            return YES;
        }
        if ([self isRectOverlap:origin andRect: target ]) {
            return YES;
        }
    }
    return NO;
}

- (BOOL) isRectIntersect:(CGRect)origin
{
    for (NSInteger i = 0 ;i < [_visibleSubviewRects count]; i ++) {
        CGRect target = [[_visibleSubviewRects objectAtIndex:i] CGRectValue];
        if ([[self class] isRectOverlap:target andRect: origin ]) {
            return YES;
        }
        if ([[self class] isRectOverlap:origin andRect: target ]) {
            return YES;
        }
    }
    return NO;
}

+ (BOOL) isRectOverlap:(CGRect) r1 andRect:(CGRect) r2 {
    
    return !(r1.origin.x >= r2.origin.x+r2.size.width - kScreenWidth * 0.005f
             || r1.origin.y >= r2.origin.y+r2.size.height - kScreenWidth * 0.005f
             || r2.origin.x >= r1.origin.x +r1.size.width - kScreenWidth * 0.005f
             || r2.origin.y >= r1.origin.y + r1.size.height - kScreenWidth * 0.005f);
}

+ (BOOL)hasIntersectsWithVisibleSubviewRects:(CGRect)rect visibleSubviewRects:(NSArray*)visibleSubviewRects {
    BOOL hasIntersects = NO;
    for (NSInteger r1=visibleSubviewRects.count-1;r1>=0;r1--) {
        if (CGRectIntersectsRect(rect, [[visibleSubviewRects objectAtIndex:r1] CGRectValue])) {
            hasIntersects = YES;
            break;
        }
    }
    return hasIntersects;
}

- (BOOL)hasIntersectsWithVisibleSubviewRects:(CGRect)rect {
    return [[self class] hasIntersectsWithVisibleSubviewRects:rect visibleSubviewRects:_visibleSubviewRects];
}

@end

@interface RecommendWaterFollowCell ()

@property(nonatomic,strong) RecommendWaterFollowView *waterFollowView;

@end

@implementation RecommendWaterFollowCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendWaterFollowCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if ([recommendInfo isKindOfClass:[RecommendInfo class]]) {
        height = [RecommendWaterFollowView rowHeightForPortrait:recommendInfo];
    }
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _waterFollowView = [[RecommendWaterFollowView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        [self.contentView addSubview:_waterFollowView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_waterFollowView prepareForReuse];
    _waterFollowView.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _waterFollowView.frame = self.contentView.bounds;
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        [_waterFollowView updateWithRecommendInfo:recommendInfo];
        [self setNeedsLayout];
    }
}

@end


@interface RecommendTitleCell () {
    RecommendTitleView *_titleView;
}
@end

@implementation RecommendTitleCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendTitleCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = [RecommendTitleView rowHeightForPortrait]+8.f;
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleView = [[RecommendTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _titleView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _titleView.frame = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleView.frame = CGRectMake(0, 0, self.contentView.width, [RecommendTitleView rowHeightForPortrait]);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        [_titleView updateWithRecommendInfo:recommendInfo];
    }
}

@end

@interface RecommendTableCellWithTitle ()

@end

@implementation RecommendTableCellWithTitle {
    RecommendTitleView *_titleView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendTableCellWithTitle class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _titleView = [[RecommendTitleView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _titleView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleView];
        
        _itemsView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _itemsView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_itemsView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _titleView.frame = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _titleView.frame = CGRectMake(0, 0, self.contentView.width, [RecommendTitleView rowHeightForPortrait]);
    _itemsView.frame = CGRectMake(0, [RecommendTitleView rowHeightForPortrait], self.contentView.width, self.contentView.height-[RecommendTitleView rowHeightForPortrait]);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        [_titleView updateWithRecommendInfo:recommendInfo];
    }
}
@end


@interface RecommendBannerCell () <XMPageViewDatasource,XMPageViewDelegate,SDCycleScrollViewDelegate>
@property(nonatomic,strong) NSArray *redirectInfoList;
//@property (nonatomic, strong) MFPageView *pageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subTitleLbl;
@property (nonatomic, strong) UILabel *currPage;
@property (nonatomic, strong) UILabel *totlePage;

@end

@implementation RecommendBannerCell {
    //修改为pageView
    //    XMPageView *_pageView;
    SDCycleScrollView *cycleScrollView;
    
}

-(UILabel *)totlePage{
    if (!_totlePage) {
        _totlePage = [[UILabel alloc] initWithFrame:CGRectZero];
        _totlePage.font = [UIFont systemFontOfSize:11.f];
        _totlePage.textColor = [UIColor colorWithHexString:@"888888"];
        [_totlePage sizeToFit];
    }
    return _totlePage;
}

-(UILabel *)currPage{
    if (!_currPage) {
        _currPage = [[UILabel alloc] initWithFrame:CGRectZero];
        _currPage.font = [UIFont boldSystemFontOfSize:22.f];
        _currPage.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_currPage sizeToFit];
        _currPage.text = @"1";
    }
    return _currPage;
}

-(UILabel *)subTitleLbl{
    if (!_subTitleLbl) {
        _subTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitleLbl.font = [UIFont systemFontOfSize:11.f];
        _subTitleLbl.textColor = [UIColor colorWithHexString:@"888888"];
        [_subTitleLbl sizeToFit];
    }
    return _subTitleLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont boldSystemFontOfSize:24.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendBannerCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat height = (kScreenWidth * 100) / 320;
    
    return height;
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    self.titleLbl.text = recommendInfo.moreInfo.title;
    self.subTitleLbl.text = recommendInfo.moreInfo.subTitle;
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        _redirectInfoList = recommendInfo.list;
        NSMutableArray * imagesURLStrings = [[NSMutableArray alloc] init];
        NSMutableArray * titleAndSubtitles = [[NSMutableArray alloc] init];
        for ( int i = 0; i < _redirectInfoList.count; i++) {
            RedirectInfo * redirect = _redirectInfoList[i];
            [imagesURLStrings addObject:redirect.imageUrl];
            NSDictionary *dict = @{@"title":redirect.title, @"subTitle":redirect.subTitle};
            [titleAndSubtitles addObject:dict];
        }
        cycleScrollView.titleAndSubtitles = titleAndSubtitles;
        cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        self.totlePage.text = [NSString stringWithFormat:@"/%ld", imagesURLStrings.count];
        //        [_pageView reloadData];
    }
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        /*
         首页图片轮播器原scrollView修改为CollectionView实现
         这里创建CollectionView
         **/
        //        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //        layout.itemSize = CGSizeMake(375, 200);
        //        layout.minimumInteritemSpacing = 0;
        //        layout.minimumLineSpacing = 0;
        //
        //        self.pageView = [[MFPageView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        
        /*
         原scrollView首页图片轮播代码
         */
        //        _pageView = [[XMPageView alloc] initWithFrame:CGRectZero autoSwitch:YES];
        //        _pageView.backgroundColor = [UIColor clearColor];
        //        _pageView.delegate = self;
        //        _pageView.datasource = self;
        //        [self.contentView addSubview:_pageView];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlWithe"];
        cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlAlpha"];
        cycleScrollView.autoScrollTimeInterval = 4;
        cycleScrollView.infiniteLoop = NO;
        cycleScrollView.autoScroll = NO;
        cycleScrollView.showPageControl = NO;
        [cycleScrollView getIsMain:YES];
        [self.contentView addSubview:cycleScrollView];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.subTitleLbl];
        [self.contentView addSubview:self.totlePage];
        [self.contentView addSubview:self.currPage];
        
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    //    _pageView.frame = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //    _pageView.frame = self.contentView.bounds;
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(28);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    
    [self.subTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(7);
        make.left.equalTo(self.titleLbl.mas_left);
    }];
    
    [self.totlePage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-20);
        make.bottom.equalTo(self.titleLbl.mas_bottom);
    }];
    
    [self.currPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.totlePage.mas_bottom).offset(3);
        make.right.equalTo(self.totlePage.mas_left).offset(-2);
    }];
    
    cycleScrollView.frame = CGRectMake(0, 100, self.contentView.width, self.contentView.height-100);// self.contentView.bounds;
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index >=0 && index <[_redirectInfoList count]) {
        [MobClick event:@"click_banner_from_home"];
        RedirectInfo *redirectInfo = [_redirectInfoList objectAtIndex:index];
        
        //埋点
        if (redirectInfo) {
            [[Session sharedInstance] clientReport:redirectInfo data:nil];
        }
        
        [URLScheme locateWithRedirectUri:redirectInfo.redirectUri andIsShare:NO];
    }
}

-(void)cycGetCurrPage:(NSInteger)currPage TotoaPage:(NSInteger)totoaPage{
    self.currPage.text = [NSString stringWithFormat:@"%ld", currPage];
}

//原来XMPageView的拖点击代理方法
//- (void)didClickViewPage:(XMPageView *)csView atPageIndex:(NSInteger)index {
//    if (index >=0 && index <[_redirectInfoList count]) {
//        [MobClick event:@"click_banner_from_home"];
//        RedirectInfo *redirectInfo = [_redirectInfoList objectAtIndex:index];
//
//        //埋点
//        if (redirectInfo) {
//            [[Session sharedInstance] clientReport:redirectInfo data:nil];
//        }
//
//        [URLScheme locateWithRedirectUri:redirectInfo.redirectUri andIsShare:NO];
//    }
//}

- (NSInteger)numberOfViewPages {
    return _redirectInfoList?[_redirectInfoList count]:0;
}

- (UIView *)viewAtPageIndex:(NSInteger)index {
    XMWebImageView *view = [[XMWebImageView alloc] initWithFrame:CGRectZero];
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    view.clipsToBounds = YES;
    if (index >=0 && index <[_redirectInfoList count]) {
        RedirectInfo *redirectInfo = [_redirectInfoList objectAtIndex:index];
        
        [view setImageWithURL:redirectInfo.imageUrl placeholderImage:nil size:CGSizeMake(kScreenWidth*2, [[self class] rowHeightForPortrait:nil]*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
        
    }
    return view;
}

@end

@implementation RecommendDiscoverCell{
    BOOL _isYes;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendDiscoverCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = kScreenWidth*36.f/320.f;
    return height;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    //    self.contentView.backgroundColor = [UIColor redColor];
    CGFloat wid = 16;
    for (NSInteger i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btn setTitleColor:[UIColor colorWithHexString:@"b3b3b3"] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor colorWithHexString:@"4c4c4c"] forState:UIControlStateSelected];
        [btn setTitle:@"111" forState:UIControlStateNormal];
        [btn setTitle:@"111" forState:UIControlStateSelected];
        btn.tag = 10000 + i;
        if (i - 1 >= 0) {
            wid = CGRectGetMaxX([self.scrollView viewWithTag:10000 + i - 1].frame) + 21;
        }
        btn.frame = CGRectMake(wid, 16, 0, 0);
        [btn sizeToFit];
        [btn layoutIfNeeded];
        _scrollView.contentSize = CGSizeMake(CGRectGetMaxX([self.scrollView viewWithTag:10000 + i].frame) + 21, 44.f);
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

- (void)btnAction:(UIButton *)btn {
    NSLog(@"touch");
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.f)];
        //        _scrollView.backgroundColor = [UIColor blueColor];
        //        [self.contentView addSubview:_scrollView];
        
    }
    return self;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (_isYes) {
        _isYes = NO;
    } else {
        _isYes = YES;
    }
    if (self.clickCell) {
        self.clickCell(_isYes);
    }
}

@end


@implementation RecommendBannerCellVolHeight

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendBannerCellVolHeight class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat height = (kScreenWidth * 100) / 320;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:0];
        if (redirectInfo && [redirectInfo isKindOfClass:[RedirectInfo class]]) {
            height = redirectInfo.height;
        }
    }
    height = (kScreenWidth-40)*height/320;
    height += 100;
    height += 50;//banner 下面文字的高度
    return height;
}

- (UIView *)viewAtPageIndex:(NSInteger)index {
    XMWebImageView *view = [[XMWebImageView alloc] initWithFrame:CGRectZero];
    view.contentMode = UIViewContentModeScaleAspectFill;
    view.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    view.clipsToBounds = YES;
    if (index >=0 && index <[self.redirectInfoList count]) {
        RedirectInfo *redirectInfo = [self.redirectInfoList objectAtIndex:index];
        
        CGFloat height = kScreenWidth*redirectInfo.height/320;
        
        [view setImageWithURL:redirectInfo.imageUrl placeholderImage:nil size:CGSizeMake(kScreenWidth*2, height*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
        
    }
    return view;
}

@end

@interface RecommendAdsCell ()

@property (nonatomic, strong) RecommendInfo *recommendInfo;

@end

@implementation RecommendAdsCell {
    XMWebImageView *_adsImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendAdsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 44.f;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:0];
        if (redirectInfo && [redirectInfo isKindOfClass:[RedirectInfo class]]) {
            height = redirectInfo.height;
        }
    }
    height = kScreenWidth*height/320;
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _adsImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _adsImageView.backgroundColor = [UIColor clearColor];
        _adsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _adsImageView.clipsToBounds = YES;
        [self.contentView addSubview:_adsImageView];
        
        WEAKSELF;
        _adsImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            if (weakSelf.redirectInfo) {
                [[Session sharedInstance] clientReport:weakSelf.redirectInfo data:nil];
            }
            [URLScheme locateWithRedirectUri:weakSelf.redirectUri andIsShare:NO];
            
        };
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _redirectUri = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _adsImageView.frame = self.bounds;
}

-(void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    self.recommendInfo = recommendInfo;
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        if (recommendInfo
            && [recommendInfo isKindOfClass:[RecommendInfo class]]
            && [recommendInfo.list count]>0) {
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:0];
            if (redirectInfo && [redirectInfo isKindOfClass:[RedirectInfo class]]) {
                
                //CGFloat height = [[self class] rowHeightForPortrait:dict];
                /*
                 适配显示gif图片
                 UIImage * memoryImage = (UIImage *)[[TMCache sharedCache] objectForKey:redirectInfo.redirectUri];
                 if (memoryImage) {
                 _adsImageView.image = memoryImage;
                 }else{
                 dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                 
                 UIImage * image = UIImageWithAnimatedGIFData([NSData dataWithContentsOfURL:[NSURL URLWithString:redirectInfo.imageUrl]], 1, 0, nil);
                 if (redirectInfo.redirectUri.length > 0 && redirectInfo.redirectUri) {
                 [[TMCache sharedCache] setObject:image forKey:redirectInfo.redirectUri];
                 }
                 dispatch_async(dispatch_get_main_queue(), ^{
                 _adsImageView.image = image;
                 });
                 });
                 }
                 
                 */
                [_adsImageView setImageWithURL:redirectInfo.imageUrl XMWebImageScaleType:XMWebImageScaleNone];
                _redirectUri = redirectInfo.redirectUri;
                self.redirectInfo = redirectInfo;
            }
        }
    }
    
    [self setNeedsLayout];
}

@end

@implementation RecommendTopicCell {
    XMWebImageView *_adsImageView;
    TapDetectingView *_maskView;
    UILabel *_titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendTopicCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:0];
        if (redirectInfo && [redirectInfo isKindOfClass:[RedirectInfo class]]) {
            height = redirectInfo.height;
        }
    }
    height = kScreenWidth*height/320;
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _adsImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _adsImageView.backgroundColor = [UIColor clearColor];
        _adsImageView.contentMode = UIViewContentModeScaleAspectFill;
        _adsImageView.clipsToBounds = YES;
        [self.contentView addSubview:_adsImageView];
        
        _maskView = [[TapDetectingView alloc] initWithFrame:CGRectZero];
        _maskView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
        _maskView.userInteractionEnabled = YES;
        [self.contentView addSubview:_maskView];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _titleLbl.numberOfLines = 0;
        _titleLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_titleLbl];
        
        WEAKSELF;
        _adsImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            if (weakSelf.redirectInfo) {
                [[Session sharedInstance] clientReport:weakSelf.redirectInfo data:nil];
            }
            [URLScheme locateWithRedirectUri:weakSelf.redirectUri andIsShare:NO];
        };
        
        _maskView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            if (weakSelf.redirectInfo) {
                [[Session sharedInstance] clientReport:weakSelf.redirectInfo data:nil];
            }
            [URLScheme locateWithRedirectUri:weakSelf.redirectUri andIsShare:NO];
        };
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _redirectUri = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _adsImageView.frame = self.bounds;
    _titleLbl.frame = CGRectMake(15, 0, self.contentView.width-105-30, 0);
    [_titleLbl sizeToFit];
    CGFloat height = _titleLbl.height+30;
    if (height<70) {
        height = 70;
    }
    _maskView.frame = CGRectMake(0, self.contentView.height-height-20, self.contentView.width-105, height);
    
    _titleLbl.frame = CGRectMake(15, _maskView.top+(_maskView.height-_titleLbl.height)/2, _titleLbl.width, _titleLbl.height);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        if (recommendInfo
            && [recommendInfo isKindOfClass:[RecommendInfo class]]
            && [recommendInfo.list count]>0) {
            RedirectInfo *redirectInfo = [recommendInfo.list objectAtIndex:0];
            if (redirectInfo && [redirectInfo isKindOfClass:[RedirectInfo class]]) {
                
                CGFloat height = [[self class] rowHeightForPortrait:dict];
                WEAKSELF;
                [_adsImageView setImageWithURL:redirectInfo.imageUrl placeholderImage:nil size:CGSizeMake(kScreenWidth*2, height*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
                
                _redirectUri = redirectInfo.redirectUri;
                weakSelf.redirectInfo = redirectInfo;
                
                if ([redirectInfo.title length]>0) {
                    _titleLbl.text = redirectInfo.title;
                    _titleLbl.hidden = NO;
                    _maskView.hidden = NO;
                } else {
                    _titleLbl.hidden = YES;
                    _maskView.hidden = YES;
                }
            }
        }
    }
    
    [self setNeedsLayout];
}

@end


@implementation RecommendGoodsCellSearch

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendGoodsCellSearch class]);
    });
    return __reuseIdentifier;
}

+ (NSMutableDictionary*)buildCellDict:(NSArray*)goodsInfoArray
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecommendGoodsCellSearch class]];
    if (goodsInfoArray)[dict setObject:goodsInfoArray forKey:[self cellKeyForGoodsInfoArray]];
    return dict;
}

- (RecommendGoodsView*)createRecommendGoodsView {
    WEAKSELF;
    RecommendGoodsViewSearch *view = [[RecommendGoodsViewSearch alloc] initWithFrame:CGRectZero];
    view.handleRecommendGoodsClickBlock = ^(RecommendGoodsInfo *recommendGoodsInfo) {
        if (weakSelf.handleRecommendGoodsClickBlock) {
            weakSelf.handleRecommendGoodsClickBlock(recommendGoodsInfo);
        }
    };
    return view;
}

@end

@interface RecommendGoodsCell ()

@property (nonatomic, strong) GoodsCellTopView *topView;
@property (nonatomic, strong) RecommendInfo *recommendInfo;

@end

@implementation RecommendGoodsCell {
    UIView *_goodsItemViews;
}

-(GoodsCellTopView *)topView{
    if (!_topView) {
        _topView = [[GoodsCellTopView alloc] initWithFrame:CGRectZero];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendGoodsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    RecommendInfo *info = [dict objectForKey:@"recommendInfo"];
    CGFloat height = [RecommendGoodsView rowHeightForPortrait:info];
    if (info.moreInfo && info.moreInfo.title && info.moreInfo.title.length > 0) {
        height += kScreenWidth*66.f/320.f;
    }
    return height;
}


+ (CGFloat)rowHeightForPortrait {
    CGFloat height = [RecommendGoodsView rowHeightForPortrait:nil];
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSArray*)goodsInfoArray
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecommendGoodsCell class]];
    if (goodsInfoArray)[dict setObject:goodsInfoArray forKey:[self cellKeyForGoodsInfoArray]];
    return dict;
}

+ (NSString*)cellKeyForGoodsInfoArray {
    return @"goodsInfoArray";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //修改cell背景颜色  f1f1ed修改为white  2016.9.11 Feng
        self.contentView.backgroundColor = [UIColor whiteColor];
        _goodsItemViews = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _goodsItemViews.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_goodsItemViews];
        [self.contentView addSubview:self.topView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*66.f/320.f);//86.f
    _goodsItemViews.frame = self.contentView.bounds;
    CGFloat width = (_goodsItemViews.width-55)/2;
    CGFloat X = 20.f;
    CGFloat Y = 0;
    if (self.recommendInfo.moreInfo && self.recommendInfo.moreInfo.title && self.recommendInfo.moreInfo.title.length > 0) {
        Y = kScreenWidth*66.f/320.f;
    } else {
        Y = 0;
    }
    int i = 0;
    for (UIView *view in [_goodsItemViews subviews]) {
        if (i > 0 && i % 2 == 0) {
            Y += ((kScreenWidth-55)/2+85);
            X = 20;
        } else {
            
        }
        view.frame = CGRectMake(X, Y, width, ((kScreenWidth-55)/2+85));
        X += width;
        X += 15.f;
        i++;
    }
}

- (RecommendGoodsView*)createRecommendGoodsView {
    return [[RecommendGoodsView alloc] initWithFrame:CGRectZero];
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    self.recommendInfo = recommendInfo;
    if (recommendInfo.moreInfo && recommendInfo.moreInfo.title && recommendInfo.moreInfo.title.length > 0) {
        [self.topView getRecommendInfo:recommendInfo];
        self.topView.hidden = NO;
    } else {
        self.topView.hidden = YES;
    }
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]) {
        [self updateCellWithGoodsInfos:recommendInfo.list];
    }
    else {
        NSArray *goodsInfoArray = (NSArray*)[dict objectForKey:[[self class] cellKeyForGoodsInfoArray]];
        if ([goodsInfoArray isKindOfClass:[NSArray class]]) {
            [self updateCellWithGoodsInfos:goodsInfoArray];
        }
    }
}

- (void)updateCellWithGoodsInfos:(NSArray*)recommendGoodsList
{
    NSInteger goodsNum = [recommendGoodsList count]>3?3:[recommendGoodsList count];
    NSInteger count = [_goodsItemViews subviews].count;
    for (NSInteger i=count;i<recommendGoodsList.count;i++) {
        RecommendGoodsView *view = [self createRecommendGoodsView];
        view.contentMode = UIViewContentModeScaleAspectFill;
        view.clipsToBounds = YES;
        view.backgroundColor = [UIColor whiteColor];
        [_goodsItemViews addSubview:view];
    }
    
    CGFloat width = (kScreenWidth-16)/2;
    CGFloat X = 5.f;
    CGFloat Y = 0;
    int i = 0;
    for (UIView *view in _goodsItemViews.subviews) {
        if (i % 2 == 0) {
            Y += _goodsItemViews.height;
            Y += 10;
        } else {
            
        }
        view.hidden = YES;
        view.frame = CGRectMake(X, Y, width, ((kScreenWidth-55)/2+85));
        X += width;
        X += 10.f;
        i++;
    }
    
    [self setNeedsLayout];
    
    for (NSInteger i=0;i<[recommendGoodsList count];i++) {
        RecommendGoodsView *view = (RecommendGoodsView*)[[_goodsItemViews subviews] objectAtIndex:i];
        RecommendGoodsInfo *recommendGoodsInfo = [recommendGoodsList objectAtIndex:i];
        if ([recommendGoodsInfo isKindOfClass:[RecommendGoodsInfo class]]) {
            [view updateWithRedirectInfo:recommendGoodsInfo];
            view.hidden = NO;
        }
    }
}

@end


@implementation RecommendTitleView {
    XMWebImageView *_iconView;
    UILabel *_titleLbl;
    UILabel *_moreLbl;
}

+ (CGFloat)rowHeightForPortrait
{
    return 44.f;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _iconView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconView.backgroundColor = [UIColor whiteColor];
        _iconView.contentMode = UIViewContentModeScaleAspectFill;
        _iconView.clipsToBounds = YES;
        [self addSubview:_iconView];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.numberOfLines = 1;
        [self addSubview:_titleLbl];
        
        _moreLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _moreLbl.backgroundColor = [UIColor clearColor];
        _moreLbl.textColor = [DataSources globalThemeTextColor];
        _moreLbl.font = [UIFont systemFontOfSize:14.f];
        _moreLbl.numberOfLines = 1;
        [self addSubview:_moreLbl];
        
        self.frame = CGRectMake(0, 0, kScreenWidth, [[self class] rowHeightForPortrait]);
        
        WEAKSELF;
        self.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            if (weakSelf.redirectInfo) {
                [[Session sharedInstance] clientReport:weakSelf.redirectInfo data:nil];
            }
            [URLScheme locateWithRedirectUri:weakSelf.redirectUri andIsShare:NO];
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _iconView.frame = CGRectMake(15, 16, 20, 20);
    
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake(45, 16+1, _titleLbl.width, 20);
    
    [_moreLbl sizeToFit];
    _moreLbl.frame = CGRectMake(self.width-_moreLbl.width-15, 16+1, _moreLbl.width, 20);
}

- (void)updateWithRecommendInfo:(RecommendInfo*)recommendInfo
{
    [_iconView setImageWithURL:recommendInfo.iconUrl placeholderImage:[recommendInfo localTitleIcon] size:CGSizeMake(40, 40) progressBlock:nil succeedBlock:^(UIImage *image, SDImageCacheType cacheType) {
    } failedBlock:nil];
    
    _titleLbl.text = recommendInfo.title;
    
    _moreLbl.hidden = recommendInfo.moreInfo&&[recommendInfo.moreInfo.redirectUri length]>0?NO:YES;
    
    NSString *moreText = recommendInfo.moreInfo.title&&[recommendInfo.moreInfo.title length]>0?recommendInfo.moreInfo.title:@"更多";
    _moreLbl.text = [NSString stringWithFormat:@"%@ >",moreText];
    
    _redirectUri = recommendInfo.moreInfo.redirectUri;
    self.redirectInfo = recommendInfo.moreInfo;
}

@end


@implementation RedirectInfoViewCatetory
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        self.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [MobClick event:@"click_category"];
            if (weakSelf.redirectInfo) {
                [[Session sharedInstance] clientReport:weakSelf.redirectInfo data:nil];
            }
            [URLScheme locateWithRedirectUri:weakSelf.redirectUri andIsShare:NO];
        };
    }
    return self;
}
@end

@implementation RedirectInfoViewBrand
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        self.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [MobClick event:@"click_brand_from_home"];
            if (weakSelf.redirectInfo) {
                [[Session sharedInstance] clientReport:weakSelf.redirectInfo data:nil];
            }
            [URLScheme locateWithRedirectUri:weakSelf.redirectUri andIsShare:NO];
        };
    }
    return self;
}
@end

@interface RedirectInfoView ()

@end

@implementation RedirectInfoView {
    UILabel *_titleLbl;
    UILabel *_subTtileLbl;
    XMWebImageView *_imageView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.backgroundColor = [UIColor clearColor];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.numberOfLines = 1;
        [self addSubview:_titleLbl];
        
        _subTtileLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTtileLbl.backgroundColor = [UIColor clearColor];
        _subTtileLbl.textColor = [UIColor colorWithHexString:@"B7B7B7"];
        _subTtileLbl.font = [UIFont systemFontOfSize:11.f];
        _subTtileLbl.numberOfLines = 1;
        [self addSubview:_subTtileLbl];
        
        _infoViewTileMarginTop = 0.f;
        _infoViewTileMarginLeft = 0.f;
        
        WEAKSELF;
        self.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            
            if (weakSelf.redirectInfo) {
                [[Session sharedInstance] clientReport:weakSelf.redirectInfo data:nil];
            }
            [URLScheme locateWithRedirectUri:weakSelf.redirectUri andIsShare:NO];
            
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLbl sizeToFit];
    [_subTtileLbl sizeToFit];
    
    CGRect titleFrame = CGRectZero;
    CGRect subTitleFrame = CGRectZero;
    
    if (_infoViewContentMode == RedirectInfoViewContentModeTop) {
        
        CGFloat marginTop = 0;
        
        titleFrame = CGRectMake((self.width-_titleLbl.width)/2, marginTop, _titleLbl.width, _titleLbl.height);
        marginTop += _titleLbl.height;
        marginTop += 4;
        
        subTitleFrame = CGRectMake((self.width-_subTtileLbl.width)/2, marginTop, _subTtileLbl.width, _subTtileLbl.height);
        
    } else if (_infoViewContentMode == RedirectInfoViewContentModeMiddleLeft) {
        
        CGFloat marginTop = (self.height-(_titleLbl.height+_subTtileLbl.height+8))/2;
        
        titleFrame = CGRectMake(0, marginTop, _titleLbl.width, _titleLbl.height);
        marginTop += _titleLbl.height;
        marginTop += 4;
        
        subTitleFrame = CGRectMake(0, marginTop, _subTtileLbl.width, _subTtileLbl.height);
        
    } else if (_infoViewContentMode == RedirectInfoViewContentModeMiddleRight) {
        
        CGFloat marginTop = (self.height-(_titleLbl.height+_subTtileLbl.height+8))/2;
        
        titleFrame = CGRectMake(self.width-_titleLbl.width, marginTop, _titleLbl.width, _titleLbl.height);
        marginTop += _titleLbl.height;
        marginTop += 4;
        
        subTitleFrame = CGRectMake(self.width-_subTtileLbl.width, marginTop, _subTtileLbl.width, _subTtileLbl.height);
        
    } else if (_infoViewContentMode == RedirectInfoViewContentModeTopRight) {
        CGFloat marginTop = 0;
        
        titleFrame = CGRectMake(self.width-_titleLbl.width, marginTop, _titleLbl.width, _titleLbl.height);
        marginTop += _titleLbl.height;
        marginTop += 4;
        
        subTitleFrame = CGRectMake(self.width-_subTtileLbl.width, marginTop, _subTtileLbl.width, _subTtileLbl.height);
    } else {
        CGFloat marginTop = 0;
        
        titleFrame = CGRectMake(0, marginTop, _titleLbl.width, _titleLbl.height);
        marginTop += _titleLbl.height;
        marginTop += 4;
        
        subTitleFrame = CGRectMake(0, marginTop, _subTtileLbl.width, _subTtileLbl.height);
    }
    
    titleFrame.origin.y += _infoViewTileMarginTop;
    subTitleFrame.origin.y += _infoViewTileMarginTop;
    
    titleFrame.origin.x += _infoViewTileMarginLeft;
    subTitleFrame.origin.x += _infoViewTileMarginLeft;
    
    _titleLbl.frame = titleFrame;
    _subTtileLbl.frame = subTitleFrame;
    
    _imageView.frame = self.bounds;
}

- (void)prepareForReuse {
    _imageView.image = nil;
}

- (void)updateWithRedirectInfo:(RedirectInfo*)redirectInfo imageSize:(CGSize)imageSize
{
    _titleLbl.text =  redirectInfo.title&&[redirectInfo.title length]>0?redirectInfo.title:@"";
    _subTtileLbl.text = redirectInfo.subTitle&&[redirectInfo.subTitle length]>0?redirectInfo.subTitle:@"";
    [_imageView setImageWithURL:redirectInfo.imageUrl placeholderImage:nil size:imageSize progressBlock:nil succeedBlock:nil failedBlock:nil];
    
    _redirectUri = redirectInfo.redirectUri;
    self.redirectInfo = redirectInfo;
    //    _subTtileLbl.backgroundColor = [UIColor redColor];
    
    [self setNeedsLayout];
}

@end


@interface RecommendActivityLimitedView () <ActivityInfoManagerObserver>

@end

@implementation RecommendActivityLimitedView {
    UILabel *_timeHourLbl;
    CALayer *_timeSep1;
    UILabel *_timeMinLbl;
    CALayer *_timeSep2;
    UILabel *_timeSecLbl;
    
    XMWebImageView *_thumbView;
    UILabel *_goodsNameLbl;
    UILabel *_activityPriceLbl;
    UILabel *_marketPriceLbl;
    
    UIImage *_clockSepImg;
    UIImage *_clockSepEndImg;
    UIColor *_clockBgColor;
    UIColor *_clockEndBgColor;
    NSTimer *_timer;
    ActivityGoodsInfo *_activityInfo;
    
    GoodsStatusMaskView *_statusView;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat sepWidth = (kScreenWidth*10)/320;
    return (kScreenWidth-4*sepWidth)/3+120;
    //return 200.f;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
    [[ActivityInfoManager sharedInstance] removeObserver:self];
}

- (void)prepareForReuse {
    _thumbView.image = nil;
    [_timer invalidate];
    _timer = nil;
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIFont *timeFont = [UIFont systemFontOfSize:12.f];
        UIColor *timeTextColor = [UIColor whiteColor];
        
        //        _clockBgColor = [UIColor colorWithHexString:@"333333"];
        //        _clockEndBgColor = [UIColor colorWithHexString:@"CCCCCC"];
        
        //        _clockSepImg = [UIImage imageNamed:@"recommend_timerBg.png"];
        //        _clockSepEndImg = [UIImage imageNamed:@"recommend_timerBg_end.png"];
        
        _timeHourLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeHourLbl.backgroundColor = _clockBgColor;
        _timeHourLbl.font = timeFont;
        _timeHourLbl.textColor = timeTextColor;
        _timeHourLbl.layer.masksToBounds = YES;
        _timeHourLbl.layer.cornerRadius = 3.f;
        _timeHourLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeHourLbl];
        
        _timeSep1 = [CALayer layer];
        _timeSep1.contents = (id)_clockSepImg.CGImage;
        _timeSep1.bounds = CGRectMake(0, 0, _clockSepImg.size.width, _clockSepImg.size.height);
        [self.layer addSublayer:_timeSep1];
        
        _timeMinLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeMinLbl.backgroundColor = _clockBgColor;
        _timeMinLbl.font = timeFont;
        _timeMinLbl.textColor = timeTextColor;
        _timeMinLbl.layer.masksToBounds = YES;
        _timeMinLbl.layer.cornerRadius = 3.f;
        _timeMinLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeMinLbl];
        
        _timeSep2 = [CALayer layer];
        _timeSep2.contents = (id)_clockSepImg.CGImage;
        _timeSep2.bounds = CGRectMake(0, 0, _clockSepImg.size.width, _clockSepImg.size.height);
        [self.layer addSublayer:_timeSep2];
        
        _timeSecLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeSecLbl.backgroundColor = _clockBgColor;
        _timeSecLbl.font = timeFont;
        _timeSecLbl.textColor = timeTextColor;
        _timeSecLbl.layer.masksToBounds = YES;
        _timeSecLbl.layer.cornerRadius = 3.f;
        _timeSecLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_timeSecLbl];
        
        _thumbView= [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _thumbView.backgroundColor = [UIColor clearColor];
        _thumbView.clipsToBounds = YES;
        _thumbView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_thumbView];
        
        _goodsNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsNameLbl.backgroundColor = [UIColor clearColor];
        _goodsNameLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _goodsNameLbl.numberOfLines =2;
        _goodsNameLbl.font = [UIFont systemFontOfSize:10.f];
        [self addSubview:_goodsNameLbl];
        
        _activityPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _activityPriceLbl.backgroundColor = [UIColor clearColor];
        _activityPriceLbl.textColor = [UIColor colorWithHexString:@"985F65"];
        _activityPriceLbl.numberOfLines = 1;
        _activityPriceLbl.font = [UIFont systemFontOfSize:11.f];
        _activityPriceLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_activityPriceLbl];
        
        _marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _marketPriceLbl.backgroundColor = [UIColor clearColor];
        _marketPriceLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _marketPriceLbl.numberOfLines = 1;
        _marketPriceLbl.font = [UIFont systemFontOfSize:11.f];
        _marketPriceLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_marketPriceLbl];
        
        WEAKSELF;
        self.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [MobClick event:@"click_flashsale_item"];
            [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:weakSelf.goodsId animated:YES];
        };
        
        [[ActivityInfoManager sharedInstance] addObserver:self];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginTop = 0.f;
    marginTop += 5;
    
    CGFloat timeWidth = 18;
    
    CGFloat timeLblX = (self.width-(timeWidth+_timeSep1.bounds.size.width+timeWidth+_timeSep2.bounds.size.width+timeWidth))/2;
    _timeHourLbl.frame = CGRectMake(timeLblX, marginTop, timeWidth, timeWidth);
    timeLblX += timeWidth;
    _timeSep1.frame = CGRectMake(timeLblX, marginTop, _timeSep1.bounds.size.width, timeWidth);
    timeLblX += _timeSep1.bounds.size.width;
    _timeMinLbl.frame = CGRectMake(timeLblX, marginTop, timeWidth, timeWidth);
    timeLblX += _timeMinLbl.bounds.size.width;
    _timeSep2.frame = CGRectMake(timeLblX, marginTop, _timeSep2.bounds.size.width, timeWidth);
    timeLblX += _timeSep2.bounds.size.width;
    _timeSecLbl.frame = CGRectMake(timeLblX, marginTop, timeWidth, timeWidth);
    marginTop += timeWidth;
    
    
    CGFloat thumbWidth = self.width;
    
    marginTop += 15.f;
    _thumbView.frame = CGRectMake((self.width-thumbWidth)/2, marginTop, thumbWidth, thumbWidth);
    
    marginTop += _thumbView.height;
    
    marginTop += 10.f;
    
    _goodsNameLbl.frame = CGRectMake(0, 0, self.width, 0);
    [_goodsNameLbl sizeToFit];
    _goodsNameLbl.frame = CGRectMake(0, marginTop, _goodsNameLbl.width, _goodsNameLbl.height);
    
    marginTop += _goodsNameLbl.height;
    marginTop += 6;
    
    _activityPriceLbl.frame = CGRectMake(0, 0, self.width, 0);
    [_activityPriceLbl sizeToFit];
    _activityPriceLbl.frame = CGRectMake(0, marginTop, _activityPriceLbl.width, _activityPriceLbl.height);
    
    marginTop += _activityPriceLbl.height;
    marginTop += 3;
    
    _marketPriceLbl.frame = CGRectMake(0, 0, self.width, 0);
    [_marketPriceLbl sizeToFit];
    _marketPriceLbl.frame = CGRectMake(0, marginTop, _marketPriceLbl.width, _marketPriceLbl.height);
    
    _statusView.frame = _thumbView.frame;
    
}

- (void)updateWithRedirectInfo:(ActivityGoodsInfo*)activityInfo
{
    _timeHourLbl.text = [activityInfo remainHoursString];
    _timeMinLbl.text = [activityInfo remainMinutesString];
    _timeSecLbl.text = [activityInfo remainSecondsString];
    
    [_thumbView setImageWithURL:activityInfo.recommendGoodsInfo.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    
    _goodsNameLbl.text = activityInfo.recommendGoodsInfo.goodsName;
    
    _activityPriceLbl.text = activityInfo.recommendGoodsInfo.shopPriceString ;//[NSString stringWithFormat:@"¥ %.2f",activityInfo.recommendGoodsInfo.shopPrice];
    
    if (activityInfo.recommendGoodsInfo.marketPrice>0) {
        NSString *priceString = activityInfo.recommendGoodsInfo.marketPriceString;//[NSString stringWithFormat:@"¥ %.2f",activityInfo.recommendGoodsInfo.marketPrice];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceString];
        [attrString addAttribute:NSStrikethroughStyleAttributeName
                           value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                           range:NSMakeRange(0, attrString.length)];
        _marketPriceLbl.attributedText = attrString;
        _marketPriceLbl.hidden = NO;
    } else {
        _marketPriceLbl.hidden = YES;
    }
    
    _goodsId = activityInfo.recommendGoodsInfo.goodsId;
    
    _activityInfo = activityInfo;
    
    if (![_activityInfo.recommendGoodsInfo isOnSale]) {
        if (!_statusView) {
            _statusView = [[GoodsStatusMaskView alloc] initWithFrame:CGRectZero];
            [self addSubview:_statusView];
        }
        _statusView.statusString = [_activityInfo.recommendGoodsInfo statusDescription];
        _statusView.hidden = NO;
    } else {
        _statusView.hidden = YES;
    }
    
    [_timer invalidate];
    _timer = nil;
    
    //测试
    //    _activityInfo.remainTime = 109999;
    //    _activityInfo.isFinished = NO;
    
    if (_activityInfo.remainTime>0 && !_activityInfo.isFinished && [_activityInfo.recommendGoodsInfo isOnSale]) {
        [[ActivityInfoManager sharedInstance] storeData:_activityInfo];
    }
    [self updateClock];
    [self setNeedsLayout];
}

- (void)updateClock
{
    if (_activityInfo.remainTime>0 && !_activityInfo.isFinished && [_activityInfo.recommendGoodsInfo isOnSale]) {
        _timeHourLbl.text = [_activityInfo remainHoursString];
        _timeMinLbl.text = [_activityInfo remainMinutesString];
        _timeSecLbl.text = [_activityInfo remainSecondsString];
        _timeHourLbl.backgroundColor = _clockBgColor;
        _timeMinLbl.backgroundColor = _clockBgColor;
        _timeSecLbl.backgroundColor = _clockBgColor;
        _timeSep1.contents = (id)_clockSepImg.CGImage;
        _timeSep2.contents = (id)_clockSepImg.CGImage;
    } else {
        _timeHourLbl.text = @"00";
        _timeMinLbl.text = @"00";
        _timeSecLbl.text = @"00";
        _timeHourLbl.backgroundColor = _clockEndBgColor;
        _timeMinLbl.backgroundColor = _clockEndBgColor;
        _timeSecLbl.backgroundColor = _clockEndBgColor;
        _timeSep1.contents = (id)_clockSepEndImg.CGImage;
        _timeSep2.contents = (id)_clockSepEndImg.CGImage;
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)activityInfoManagerTickNotification
{
    [self updateClock];
}

@end


@implementation RecommendGoodsViewSearch

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        self.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [MobClick event:@"click_item_from_seach_list"];
            if (weakSelf.handleRecommendGoodsClickBlock) {
                weakSelf.handleRecommendGoodsClickBlock(weakSelf.recommendGoodsInfo);
            } else {
                [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:weakSelf.goodsId animated:YES];
            }
        };
    }
    return self;
}


@end

@interface RecommendGoodsView ()

@end

@implementation RecommendGoodsView {
    MCFireworksButton *_likeBtn;
    XMWebImageView *_thumbView;
    CALayer *_blackBgLayer;
    UILabel *_goodsNameLbl;
    UILabel *_shopPriceLbl;
    UILabel *_marketPriceLbl;
    UILabel *_likesNumLbl;
    UILabel *_visitNumLbl;
    GoodsStatusMaskView *_statusView;
    UIImageView *_limitedTagView;
    UIImageView *_limitedSelfGoods;
    UIImageView *_returnGoods;
    NSInteger _index;
    NSInteger _xihuIndex;
    UILabel *_contentLbl;
    UILabel *_marketLbl;
    UIView * _containerView;
}

+ (CGFloat)rowHeightForPortrait:(RecommendInfo *)info {
    if (info && info.list.count > 0) {
        if (info.list.count % 2 == 0) {
            return  ((kScreenWidth-55)/2+85) * (info.list.count / 2);
        } else {
            return  ((kScreenWidth-55)/2+85) * (info.list.count / 2 + 1);
        }
    } else {
        return  ((kScreenWidth-55)/2+85);
    }
}

- (void)dealloc
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickLike" object:nil];
}

- (id) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        //是自选商品
        _index = 0x1;
        _xihuIndex = 0x2;
        
        _thumbView= [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _thumbView.backgroundColor = [UIColor clearColor];
        _thumbView.clipsToBounds = YES;
        _thumbView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_thumbView];
        
        _blackBgLayer = [CALayer layer];
        _blackBgLayer.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:_blackBgLayer];
        
        _goodsNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsNameLbl.backgroundColor = [UIColor clearColor];
        _goodsNameLbl.textColor = [UIColor blackColor];
        _goodsNameLbl.numberOfLines =1;
        _goodsNameLbl.font = [UIFont boldSystemFontOfSize:12.f];
        [self addSubview:_goodsNameLbl];
        
        _marketLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _marketLbl.textColor = [UIColor colorWithHexString:@"ffffff"];
        _marketLbl.backgroundColor = [DataSources colorf9384c];
        _marketLbl.font = [UIFont systemFontOfSize:10.f];
        _marketLbl.textAlignment = NSTextAlignmentCenter;
        _marketLbl.layer.masksToBounds = YES;
        _marketLbl.layer.cornerRadius = 15/2;
        [_marketLbl sizeToFit];
        [self addSubview:_marketLbl];
        
        _shopPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPriceLbl.backgroundColor = [UIColor clearColor];
        _shopPriceLbl.textColor = [UIColor colorWithHexString:@"FF0032"];//[DataSources goodsShopPriceTextColor];
        _shopPriceLbl.numberOfLines = 1;
        _shopPriceLbl.font = [UIFont systemFontOfSize:12.f];
        _shopPriceLbl.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_shopPriceLbl];
        
        //        _marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        //        _marketPriceLbl.backgroundColor = [UIColor clearColor];
        //        _marketPriceLbl.textColor = [DataSources goodsMarketPriceTextColor];
        //        _marketPriceLbl.numberOfLines = 1;
        //        _marketPriceLbl.font = [UIFont systemFontOfSize:11.f];
        //        _marketPriceLbl.textAlignment = NSTextAlignmentLeft;
        //        [self addSubview:_marketPriceLbl];
        
        //        _likesNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        //        _likesNumLbl.backgroundColor = [UIColor clearColor];
        //        _likesNumLbl.textColor = [DataSources goodsMarketPriceTextColor];
        //        _likesNumLbl.numberOfLines = 1;
        //        _likesNumLbl.font = [UIFont systemFontOfSize:10.f];
        //        [self addSubview:_likesNumLbl];
        
        //        _visitNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        //        _visitNumLbl.backgroundColor = [UIColor clearColor];
        //        _visitNumLbl.textColor = [DataSources goodsMarketPriceTextColor];
        //        _visitNumLbl.numberOfLines = 1;
        //        _visitNumLbl.font = [UIFont systemFontOfSize:10.f];
        //        [self addSubview:_visitNumLbl];
        
        _likeBtn = [[MCFireworksButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [_likeBtn setImage:[UIImage imageNamed:@"Like_New_Nomal"] forState:UIControlStateNormal];
        [_likeBtn setImage:[UIImage imageNamed:@"Like_New_Select"] forState:UIControlStateSelected];
        //        _likeBtn.particleImage = [UIImage imageNamed:@"Sparkle"];
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"cccccc"] forState:UIControlStateNormal];
        _likeBtn.particleScale = 0.05;
        _likeBtn.particleScaleRange = 0.02;
        [self addSubview:_likeBtn];
        [_likeBtn addTarget:self action:@selector(clickLikeBtn1) forControlEvents:UIControlEventTouchUpInside];
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.textColor = [UIColor colorWithHexString:@"686868"];
        _contentLbl.font = [UIFont systemFontOfSize:12.f];
        _contentLbl.textAlignment = NSTextAlignmentLeft;
        _contentLbl.numberOfLines = 1;
        [self addSubview:_contentLbl];
        
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor clearColor];
        [self addSubview:_containerView];
        
        WEAKSELF;
        self.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [MobClick event:@"click_item_from_feeds"];
            //            RedirectInfo *redirectInfo = [[RedirectInfo alloc] init];
            //            redirectInfo.viewCode = HomeViewCode;
            //            redirectInfo.regionCode = HomeGoodsRegionCode;
            //            redirectInfo.referPageCode = NoReferPageCode;
            //            [[Session sharedInstance] clientReport:redirectInfo data:@{@"goodsId":weakSelf.goodsId}];
            NSDictionary *data = @{@"goodsId":weakSelf.goodsId};
            [ClientReportObject clientReportObjectWithViewCode:HomeViewCode regionCode:GoodsDetailRegionCode referPageCode:GoodsDetailReferPageCode andData:data];
            
            [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:weakSelf.goodsId animated:YES];
        };
    }
    return self;
}

-(void)clickLikeBtn1{
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{
        
    }];
    if (!isLoggedIn) {
        return;
    }
    
    //    GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:self.goodsId];
    //    if (goodsInfo) {
    //        [MobClick event:@"click_want_from_detail"];
    //        if (goodsInfo.isLiked) {
    //            _likeBtn.selected = NO;
    //            [GoodsSingletonCommand unlikeGoods:goodsInfo.goodsId];
    //            [_likeBtn popInsideWithDuration:0.4];
    //        } else {
    //            _likeBtn.selected = YES;
    //            [GoodsSingletonCommand likeGoods:goodsInfo.goodsId];
    //
    //            [_likeBtn popOutsideWithDuration:0.5];
    //            [_likeBtn animate];
    //
    //        }
    //    } else {
    
    
    if (_likeBtn.selected == NO) {
        _likeBtn.selected = YES;
        [GoodsSingletonCommand likeGoods:self.goodsId];
        
        [_likeBtn popOutsideWithDuration:0.5];
        [_likeBtn animate];
    } else {
        _likeBtn.selected = NO;
        [GoodsSingletonCommand unlikeGoods:self.goodsId];
        [_likeBtn popInsideWithDuration:0.4];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginTop = 0.f;
    
    
    _thumbView.frame = CGRectMake(0, 0, self.width, self.width);
    
    marginTop += _thumbView.height;
    
    _blackBgLayer.frame = CGRectMake(0, marginTop, self.width, self.height-marginTop);
    
    marginTop += 8.f;
    
    _marketLbl.frame = CGRectMake(0, marginTop, 30, 15);
    
    if (_marketLbl.hidden == NO) {
        _goodsNameLbl.frame = CGRectMake(_marketLbl.right + 3, marginTop, self.width, 0);
        [_goodsNameLbl sizeToFit];
        _goodsNameLbl.frame = CGRectMake(_marketLbl.right + 3, marginTop, self.width-_marketLbl.width, _goodsNameLbl.height);
    } else {
        _goodsNameLbl.frame = CGRectMake(0, marginTop, self.width, 0);
        [_goodsNameLbl sizeToFit];
        _goodsNameLbl.frame = CGRectMake(0, marginTop, self.width, _goodsNameLbl.height);
    }
    
    marginTop += _goodsNameLbl.height;
    if (_goodsNameLbl.height > 0) {
        marginTop += 5.f;
    }
    
    _contentLbl.frame = CGRectMake(0, marginTop, self.width, 0);
    [_contentLbl sizeToFit];
    _contentLbl.frame = CGRectMake(0, marginTop, self.width, _contentLbl.height);
    
    _containerView.frame = CGRectMake(0, marginTop, self.width, _contentLbl.height);
    marginTop += 25;
    
    _shopPriceLbl.frame = CGRectMake(0, marginTop, self.width, 0);
    [_shopPriceLbl sizeToFit];
    _shopPriceLbl.frame = CGRectMake(0, marginTop, _shopPriceLbl.width, _shopPriceLbl.height);
    
    _marketPriceLbl.frame = CGRectMake(_shopPriceLbl.left+_shopPriceLbl.width+8, marginTop, self.width, 0);
    [_marketPriceLbl sizeToFit];
    _marketPriceLbl.frame = CGRectMake(_shopPriceLbl.left+_shopPriceLbl.width+8, _shopPriceLbl.bottom-_marketPriceLbl.height, _marketPriceLbl.width, _marketPriceLbl.height);
    
    [_likeBtn sizeToFit];
    _likeBtn.frame = CGRectMake(self.width-_likeBtn.width-10, marginTop, _likeBtn.width, _likeBtn.height);
    
    marginTop += _shopPriceLbl.height;
    marginTop += 3.f;
    
    [_likesNumLbl sizeToFit];
    _likesNumLbl.frame = CGRectMake(10, marginTop, _likesNumLbl.width, _likesNumLbl.height);
    
    [_visitNumLbl sizeToFit];
    _visitNumLbl.frame = CGRectMake(self.width-10-_visitNumLbl.width, marginTop, _visitNumLbl.width, _visitNumLbl.height);
    
    _statusView.center = _thumbView.center;
    
    _limitedTagView.frame = CGRectMake(self.width-_limitedTagView.width, 0, _limitedTagView.frame.size.width, _limitedTagView.frame.size.height);
    
    _limitedSelfGoods.frame = CGRectMake(0, 0, _limitedSelfGoods.width, _limitedSelfGoods.height);
    
    _returnGoods.frame = CGRectMake(8, 0, _returnGoods.width, _returnGoods.height);
}

- (void)updateWithRedirectInfo:(RecommendGoodsInfo*)recommendGoodsInfo {
    
    //不要了 2017.03.07 Feng
    for (UILabel * lbl in _containerView.subviews) {
        [lbl removeFromSuperview];
    }
    
    CGFloat margin = 0;
    if (recommendGoodsInfo.serviceIcon.count > 0) {
        _contentLbl.hidden = YES;
        for (int i = 0; i < recommendGoodsInfo.serviceIcon.count; i++) {
            NSString *titile = recommendGoodsInfo.serviceIcon[i];
            UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
            lbl.font = [UIFont systemFontOfSize:9.f];
            lbl.textColor = [UIColor whiteColor];
            lbl.backgroundColor = [UIColor colorWithHexString:@"ff8e8e"];
            lbl.textAlignment = NSTextAlignmentCenter;
            lbl.text = titile;
            [lbl sizeToFit];
            [_containerView addSubview:lbl];
            lbl.frame = CGRectMake(margin, 0, lbl.width+10, lbl.height+4);
            lbl.layer.masksToBounds = YES;
            lbl.layer.cornerRadius = (lbl.height)/2;
            margin += lbl.width+5;
        }
    }else{
        _contentLbl.hidden = NO;
    }
    
    
    //============================ -_-! ===========================//
    
    _likeBtn.selected = recommendGoodsInfo.isLiked;
    _goodsNameLbl.text = recommendGoodsInfo.goodsName;
    
    
    
    _shopPriceLbl.text = recommendGoodsInfo.shopPriceString;//[NSString stringWithFormat:@"¥ %.2f",recommendGoodsInfo.shopPrice];
    _contentLbl.text = recommendGoodsInfo.goodsBrief;
    if (recommendGoodsInfo.marketPrice>0) {
        NSString *priceString =  recommendGoodsInfo.marketPriceString;//[NSString stringWithFormat:@"¥ %.2f",recommendGoodsInfo.marketPrice];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:priceString];
        [attrString addAttribute:NSStrikethroughStyleAttributeName
                           value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                           range:NSMakeRange(0, attrString.length)];
        _marketPriceLbl.attributedText = attrString;
        _marketPriceLbl.hidden = NO;
    } else {
        _marketPriceLbl.hidden = YES;
    }
    
    if ([GoodsInfo formatLikeNumString:recommendGoodsInfo.goodsStat.likeNum].integerValue != 0) {
        [_likeBtn setTitle:[NSString stringWithFormat:@" %@",[GoodsInfo formatLikeNumString:recommendGoodsInfo.goodsStat.likeNum]]  forState:UIControlStateNormal];
    } else {
        [_likeBtn setTitle:@"心动"  forState:UIControlStateNormal];
    }
    
    //    _likesNumLbl.text = [NSString stringWithFormat:@"%@人想要",[GoodsInfo formatLikeNumString:recommendGoodsInfo.goodsStat.likeNum]];
    _visitNumLbl.text = [NSString stringWithFormat:@"%@次浏览", [GoodsInfo formatVisitNumString:recommendGoodsInfo.goodsStat.visitNum]];
    
    [_thumbView setImageWithURL:recommendGoodsInfo.thumbUrl placeholderImage:[UIImage imageNamed:@"placeholder_goods_640x640"] XMWebImageScaleType:XMWebImageScale480x480];
    
    _goodsId = recommendGoodsInfo.goodsId;
    _recommendGoodsInfo = recommendGoodsInfo;
    
    if (![recommendGoodsInfo isOnSale]) {
        if (!_statusView) {
            _statusView = [[GoodsStatusMaskView alloc] initForCircle:78.f];
            [self addSubview:_statusView];
        }
        _statusView.hidden = NO;
        _statusView.statusString = recommendGoodsInfo.statusDescription;
    } else {
        _statusView.hidden = YES;
    }
    
    if (recommendGoodsInfo.isLimitActivity) {
        if (!_limitedTagView) {
            _limitedTagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_tag_limited"]];
            [self addSubview:_limitedTagView];
        }
        _limitedTagView.hidden = NO;
    } else {
        _limitedTagView.hidden = YES;
    }
    
    if (recommendGoodsInfo.goods_type == 1) {
        if (!_limitedSelfGoods) {
            _limitedSelfGoods = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_tag_limited_MF"]];
            [self addSubview:_limitedSelfGoods];
        }
        //        _limitedSelfGoods.hidden = NO;
        _limitedSelfGoods.hidden = YES;
    }
    
    if ((recommendGoodsInfo.supportType & _xihuIndex) == _xihuIndex) {
        if (!_limitedSelfGoods) {
            _limitedSelfGoods = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"XihuIcon"]];
            [self addSubview:_limitedSelfGoods];
        } else {
            _limitedSelfGoods.image = [UIImage imageNamed:@"XihuIcon"];
        }
        //        _limitedSelfGoods.hidden = NO;
        _limitedSelfGoods.hidden = YES;
    }
    
    if (recommendGoodsInfo.goods_type != 1 && (recommendGoodsInfo.supportType & _xihuIndex) != _xihuIndex) {
        _limitedSelfGoods.hidden = YES;
        _marketLbl.hidden = YES;
    } else {
        _marketLbl.hidden = NO;
    }
    
    if (recommendGoodsInfo.marketDesc.length > 0) {
        _marketLbl.hidden = NO;
        _marketLbl.text = recommendGoodsInfo.marketDesc;
    }else{
        _marketLbl.hidden = YES;
    }
    
    if ((recommendGoodsInfo.supportType & _index) == _index) {
        if (!_returnGoods) {
            _returnGoods = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Return-Goods_Small_MF"]];
            [self addSubview:_returnGoods];
        }
        //        _returnGoods.hidden = NO;
        _returnGoods.hidden = YES;
    } else {
        _returnGoods.hidden = YES;
    }
    
    
    [self setNeedsLayout];
}

@end


@interface RecommendActivityCoverWithRedirectCell () <ActivityInfoManagerObserver>
@property(nonatomic,strong) ActivityBaseInfo *activityInfo;
@end

@implementation RecommendActivityCoverWithRedirectCell {
    XMWebImageView *_imageView;
    
    UIButton *_timerBg;
    UILabel *_timerTitleLbl;
    UILabel *_timerHourLbl;
    UILabel *_timerSep1;
    UILabel *_timerMinLbl;
    UILabel *_timerSep2;
    UILabel *_timerSecLbl;
    NSTimer *_timer;
    
    RedirectInfoView *_redirectView1;
    RedirectInfoView *_redirectView2;
    
    CALayer *_line;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendActivityCoverWithRedirectCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        ActivityBaseInfo *activityBaseInfo = [recommendInfo.list objectAtIndex:0];
        if (activityBaseInfo && [activityBaseInfo isKindOfClass:[ActivityBaseInfo class]]) {
            
            //            height = kScreenWidth*activityBaseInfo.coverHeight/320;
            height = kScreenWidth/2*activityBaseInfo.coverHeight/activityBaseInfo.coverWidth;
        }
    }
    return height;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
    [[ActivityInfoManager sharedInstance] removeObserver:self];
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _imageView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        [self.contentView addSubview:_imageView];
        
        
        UIImage *bgImg = [UIImage imageNamed:@"limit_time_bg"];
        _timerBg = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, self.width/2-20, 24.f)];
        _timerBg.userInteractionEnabled = NO;
        [_timerBg setBackgroundImage:[bgImg stretchableImageWithLeftCapWidth:1 topCapHeight:bgImg.size.height/2] forState:UIControlStateNormal];
        _timerBg.backgroundColor = [UIColor clearColor];
        _timerBg.contentMode = UIViewContentModeScaleAspectFill;
        _timerBg.clipsToBounds = YES;
        [self.contentView addSubview:_timerBg];
        
        _timerTitleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width/2, 24.f)];
        _timerTitleLbl.text = @"";
        _timerTitleLbl.textColor = [UIColor whiteColor];
        _timerTitleLbl.font = [UIFont systemFontOfSize:11.5f];
        _timerTitleLbl.textAlignment = NSTextAlignmentLeft;
        _timerTitleLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timerTitleLbl];
        
        _timerHourLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width/2, 24.f)];
        _timerHourLbl.text = @"00";
        _timerHourLbl.textColor = [UIColor whiteColor];
        _timerHourLbl.font = [UIFont boldSystemFontOfSize:11.f];
        _timerHourLbl.textAlignment = NSTextAlignmentLeft;
        _timerHourLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timerHourLbl];
        
        _timerMinLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width/2, 24.f)];
        _timerMinLbl.text = @"00";
        _timerMinLbl.textColor = [UIColor whiteColor];
        _timerMinLbl.font = [UIFont boldSystemFontOfSize:11.f];
        _timerMinLbl.textAlignment = NSTextAlignmentLeft;
        _timerMinLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timerMinLbl];
        
        _timerSecLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width/2, 24.f)];
        _timerSecLbl.text = @"00";
        _timerSecLbl.textColor = [UIColor colorWithHexString:@"F43822"];
        _timerSecLbl.font = [UIFont boldSystemFontOfSize:11.f];
        _timerSecLbl.textAlignment = NSTextAlignmentLeft;
        _timerSecLbl.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timerSecLbl];
        
        
        _timerSep1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width/2, 24.f)];
        _timerSep1.text = @":";
        _timerSep1.textColor = [UIColor whiteColor];
        _timerSep1.font = [UIFont boldSystemFontOfSize:11.f];
        _timerSep1.textAlignment = NSTextAlignmentLeft;
        _timerSep1.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timerSep1];
        _timerSep2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.width/2, 24.f)];
        _timerSep2.text = @":";
        _timerSep2.textColor = [UIColor whiteColor];
        _timerSep2.font = [UIFont boldSystemFontOfSize:11.f];
        _timerSep2.textAlignment = NSTextAlignmentLeft;
        _timerSep2.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timerSep2];
        
        _redirectView1 = [[RedirectInfoView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_redirectView1];
        
        _redirectView2 = [[RedirectInfoView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_redirectView2];
        
        _line = [CALayer layer];
        _line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_line];
        
        _redirectView1.hidden = YES;
        _redirectView2.hidden = YES;
        
        [[ActivityInfoManager sharedInstance] addObserver:self];
        
        WEAKSELF;
        _imageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            [URLScheme locateWithRedirectUri:weakSelf.activityInfo.redirectUri andIsShare:YES];
            [MobClick event:@"click_flash_sold_feeds"];
        };
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _redirectView1.hidden = YES;
    _redirectView2.hidden = YES;
    
    UIColor *color = [UIColor whiteColor];
    _timerSecLbl.textColor = color;
    _timerMinLbl.textColor = color;
    _timerSecLbl.textColor = [UIColor colorWithHexString:@"F43822"];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = CGRectMake(0, 0, self.contentView.width/2, self.contentView.height);
    
    [_timerTitleLbl sizeToFit];
    [_timerHourLbl sizeToFit];
    [_timerMinLbl sizeToFit];
    [_timerSecLbl sizeToFit];
    [_timerSep1 sizeToFit];
    [_timerSep2 sizeToFit];
    
    
    CGFloat totalWidth = 0;
    totalWidth += 5;
    totalWidth += _timerTitleLbl.width+4;
    totalWidth += _timerHourLbl.width+4;
    totalWidth += _timerSep1.width+4;
    totalWidth += _timerMinLbl.width+4;
    totalWidth += _timerSep2.width+4;
    totalWidth += _timerSecLbl.width+4;
    totalWidth += 8;
    
    _timerBg.frame = CGRectMake(0, 10, totalWidth, 24.f);
    
    CGFloat marginLeft = 5.f;
    _timerTitleLbl.frame = CGRectMake(marginLeft, 10, _timerTitleLbl.width, 24.f);
    marginLeft += _timerTitleLbl.width;
    marginLeft += 4;
    _timerHourLbl.frame = CGRectMake(marginLeft, 10, _timerHourLbl.width, 24.f);
    marginLeft += _timerHourLbl.width;
    marginLeft += 4;
    _timerSep1.frame = CGRectMake(marginLeft, 9, _timerSep1.width, 24.f);
    marginLeft += _timerSep1.width;
    marginLeft += 4;
    _timerMinLbl.frame = CGRectMake(marginLeft, 10, _timerMinLbl.width, 24.f);
    marginLeft += _timerMinLbl.width;
    marginLeft += 4;
    _timerSep2.frame = CGRectMake(marginLeft, 9, _timerSep2.width, 24.f);
    marginLeft += _timerSep2.width;
    marginLeft += 4;
    _timerSecLbl.frame = CGRectMake(marginLeft, 10, _timerSecLbl.width, 24.f);
    
    _redirectView1.frame = CGRectMake(self.contentView.width/2, 0, self.contentView.width/2, self.contentView.height/2);
    _redirectView2.frame = CGRectMake(self.contentView.width/2, self.contentView.height/2, self.contentView.width/2, self.contentView.height/2);
    
    _line.frame = CGRectMake(self.contentView.width/2, 0, 0.5f, self.contentView.height);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        ActivityBaseInfo *activityBaseInfo = [recommendInfo.list objectAtIndex:0];
        if (activityBaseInfo && [activityBaseInfo isKindOfClass:[ActivityBaseInfo class]]) {
            
            _activityInfo = activityBaseInfo;
            
            _timerTitleLbl.text = _activityInfo.activityName;
            _timerHourLbl.text = [NSString stringWithFormat:@"00"];
            _timerMinLbl.text = [NSString stringWithFormat:@"00"];
            _timerSecLbl.text = [NSString stringWithFormat:@"00"];
            
            CGFloat height = kScreenWidth/2*activityBaseInfo.coverHeight/activityBaseInfo.coverWidth;
            [_imageView setImageWithURL:activityBaseInfo.coverUrl placeholderImage:nil size:CGSizeMake(kScreenWidth, height*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
            
            _redirectView1.hidden = YES;
            _redirectView2.hidden = YES;
            
            if ([recommendInfo.list count]>1) {
                _redirectView1.hidden = NO;
                [_redirectView1 updateWithRedirectInfo:[recommendInfo.list objectAtIndex:1] imageSize:CGSizeMake(kScreenWidth, height)];
            }
            
            if ([recommendInfo.list count]>2) {
                _redirectView2.hidden = NO;
                [_redirectView2 updateWithRedirectInfo:[recommendInfo.list objectAtIndex:2] imageSize:CGSizeMake(kScreenWidth, height)];
            }
            
            [_timer invalidate];
            _timer = nil;
            
            if (_activityInfo.remainTime>0 && !_activityInfo.isFinished) {
                [[ActivityInfoManager sharedInstance] storeData:_activityInfo];
            }
            [self updateLbls];
            
            [self setNeedsLayout];
        }
    }
}

- (void)activityInfoManagerTickNotification
{
    [self updateLbls];
}

- (void)updateLbls
{
    if (_activityInfo.remainTime>0 && !_activityInfo.isFinished) {
        
        _timerHourLbl.text = [_activityInfo remainHoursString];
        _timerMinLbl.text = [_activityInfo remainMinutesString];
        _timerSecLbl.text = [_activityInfo remainSecondsString];
        
    } else {
        _timerHourLbl.text = [NSString stringWithFormat:@"00"];
        _timerMinLbl.text = [NSString stringWithFormat:@"00"];
        _timerSecLbl.text = [NSString stringWithFormat:@"00"];
        
        UIColor *color = [UIColor colorWithHexString:@"CCCCCC"];
        _timerSecLbl.textColor = color;
        _timerMinLbl.textColor = color;
        _timerSecLbl.textColor = color;
        
        [_timer invalidate];
        _timer = nil;
    }
}

@end

@interface RecommendLimitActivityCoverCell() <ActivityInfoManagerObserver>
@property(nonatomic,strong) ActivityBaseInfo *activityInfo;
@end

@implementation RecommendLimitActivityCoverCell {
    XMWebImageView *_imageView;
    UIButton *_timeLbl;
    NSTimer *_timer;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendLimitActivityCoverCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        ActivityBaseInfo *activityBaseInfo = [recommendInfo.list objectAtIndex:0];
        if (activityBaseInfo && [activityBaseInfo isKindOfClass:[ActivityBaseInfo class]]) {
            
            //            height = kScreenWidth*activityBaseInfo.coverHeight/320;
            height = kScreenWidth*activityBaseInfo.coverHeight/activityBaseInfo.coverWidth;
        }
    }
    return height;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
    [[ActivityInfoManager sharedInstance] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        [self.contentView addSubview:_imageView];
        
        UIImage *bgImage = [UIImage imageNamed:@"limit_time_bg2"];
        _timeLbl = [[UIButton alloc] initWithFrame:CGRectZero];
        [_timeLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        _timeLbl.titleLabel.font = [UIFont systemFontOfSize:11.f];
        _timeLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        [_timeLbl setBackgroundImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width-1 topCapHeight:0] forState:UIControlStateDisabled];
        _timeLbl.enabled = NO;
        [self.contentView addSubview:_timeLbl];
        
        [[ActivityInfoManager sharedInstance] addObserver:self];
        
        WEAKSELF;
        _imageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            [URLScheme locateWithRedirectUri:weakSelf.activityInfo.redirectUri andIsShare:YES];
            [MobClick event:@"click_flash_sold_feeds"];
        };
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
    
    [_timeLbl sizeToFit];
    _timeLbl.frame = CGRectMake(self.contentView.width-(_timeLbl.width+20), 12, _timeLbl.width+20, 24);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        ActivityBaseInfo *activityBaseInfo = [recommendInfo.list objectAtIndex:0];
        if (activityBaseInfo && [activityBaseInfo isKindOfClass:[ActivityBaseInfo class]]) {
            
            _activityInfo = activityBaseInfo;
            
            //            CGFloat height = kScreenWidth*activityBaseInfo.coverHeight/320;
            CGFloat height = kScreenWidth*activityBaseInfo.coverHeight/activityBaseInfo.coverWidth;
            [_imageView setImageWithURL:activityBaseInfo.coverUrl placeholderImage:nil size:CGSizeMake(kScreenWidth*2, height*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
            
            [_timer invalidate];
            _timer = nil;
            
            if (_activityInfo.remainTime>0 && !_activityInfo.isFinished) {
                [[ActivityInfoManager sharedInstance] storeData:_activityInfo];
            }
            [self updateLbls];
            
            [self setNeedsLayout];
        }
    }
}

- (void)activityInfoManagerTickNotification
{
    [self updateLbls];
}

- (void)updateLbls
{
    if (_activityInfo.remainTime>0 && !_activityInfo.isFinished) {
        NSInteger hours = _activityInfo.remainTime/3600;
        if (hours>24) {
            NSInteger days = hours/24;
            [_timeLbl setTitle:[NSString stringWithFormat:@"仅剩%ld天",(long)days] forState:UIControlStateDisabled];
        } else {
            [_timeLbl setTitle:[NSString stringWithFormat:@"仅剩 %@ : %@ : %@",[_activityInfo remainHoursString],[_activityInfo remainMinutesString],[_activityInfo remainSecondsString]] forState:UIControlStateDisabled];
        }
    } else {
        [_timeLbl setTitle:@"已结束 00 : 00 : 00" forState:UIControlStateDisabled];
        [_timer invalidate];
        _timer = nil;
    }
}

@end


@interface RecommendActivityCoverCell () <ActivityInfoManagerObserver>
@property(nonatomic,strong) ActivityBaseInfo *activityInfo;
@end

@implementation RecommendActivityCoverCell {
    XMWebImageView *_imageView;
    TapDetectingView *_hourLbl;
    TapDetectingView *_minLbl;
    TapDetectingView *_secLbl;
    NSTimer *_timer;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendActivityCoverCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        ActivityBaseInfo *activityBaseInfo = [recommendInfo.list objectAtIndex:0];
        if (activityBaseInfo && [activityBaseInfo isKindOfClass:[ActivityBaseInfo class]]) {
            
            //            height = kScreenWidth*activityBaseInfo.coverHeight/320;
            height = kScreenWidth*activityBaseInfo.coverHeight/activityBaseInfo.coverWidth;
        }
    }
    return height;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
    
    [[ActivityInfoManager sharedInstance] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _imageView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        [self.contentView addSubview:_imageView];
        
        _hourLbl = [self createTimeLbl:@"特卖"];
        [self.contentView addSubview:_hourLbl];
        
        _minLbl = [self createTimeLbl:@"限时"];
        [self.contentView addSubview:_minLbl];
        
        _secLbl = [self createTimeLbl:@"截止"];
        [self.contentView addSubview:_secLbl];
        
        [[ActivityInfoManager sharedInstance] addObserver:self];
        
        WEAKSELF;
        _imageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            [URLScheme locateWithRedirectUri:weakSelf.activityInfo.redirectUri andIsShare:YES];
            [MobClick event:@"click_flash_sold_feeds"];
        };
        _hourLbl.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [URLScheme locateWithRedirectUri:weakSelf.activityInfo.redirectUri andIsShare:YES];
            [MobClick event:@"click_flash_sold_feeds"];
        };
        _minLbl.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [URLScheme locateWithRedirectUri:weakSelf.activityInfo.redirectUri andIsShare:YES];
            [MobClick event:@"click_flash_sold_feeds"];
        };
        _secLbl.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [URLScheme locateWithRedirectUri:weakSelf.activityInfo.redirectUri andIsShare:YES];
            [MobClick event:@"click_flash_sold_feeds"];
        };
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _imageView.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.contentView.bounds;
    
    CGFloat sepWidth = 10*kScreenWidth/320;
    
    CGFloat X = (self.contentView.width-_hourLbl.width*3-2*sepWidth)/2;
    CGFloat Y = (self.contentView.height-_hourLbl.height)/2;
    
    _hourLbl.frame = CGRectMake(X, Y, _hourLbl.width, _hourLbl.height);
    X += _hourLbl.width;
    X += sepWidth;
    _minLbl.frame = CGRectMake(X, Y, _minLbl.width, _minLbl.height);
    X += _minLbl.width;
    X += sepWidth;
    _secLbl.frame = CGRectMake(X, Y, _secLbl.width, _secLbl.height);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        ActivityBaseInfo *activityBaseInfo = [recommendInfo.list objectAtIndex:0];
        if (activityBaseInfo && [activityBaseInfo isKindOfClass:[ActivityBaseInfo class]]) {
            
            _activityInfo = activityBaseInfo;
            
            //            CGFloat height = kScreenWidth*activityBaseInfo.coverHeight/320;
            CGFloat height = kScreenWidth*activityBaseInfo.coverHeight/activityBaseInfo.coverWidth;
            [_imageView setImageWithURL:activityBaseInfo.coverUrl placeholderImage:nil size:CGSizeMake(kScreenWidth*2, height*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
            
            [_timer invalidate];
            _timer = nil;
            
            if (_activityInfo.remainTime>0 && !_activityInfo.isFinished) {
                [[ActivityInfoManager sharedInstance] storeData:_activityInfo];
            }
            [self updateLbls];
            
            [self setNeedsLayout];
        }
    }
}

- (TapDetectingView*)createTimeLbl:(NSString*)title
{
    TapDetectingView *bgView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*52/320, kScreenWidth*52/320)];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.3];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 5;
    
    UIView *bgView2 = [[UIView alloc] initWithFrame:CGRectMake(4.5, 4.5, bgView.width-9, bgView.height-9)];
    bgView2.userInteractionEnabled = YES;
    bgView2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    bgView2.layer.masksToBounds = YES;
    bgView2.layer.cornerRadius = 3;
    [bgView addSubview:bgView2];
    
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(4.5, 0, bgView2.width, 0)];
    //    lbl1.text = title;
    lbl1.textColor = [UIColor whiteColor];
    lbl1.textAlignment = NSTextAlignmentCenter;
    lbl1.font = [UIFont systemFontOfSize:10.f];
    [bgView addSubview:lbl1];
    
    UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectMake(4.5, 0, bgView2.width, 0)];
    lbl2.text = @"00";
    lbl2.textColor = [UIColor whiteColor];
    lbl2.textAlignment = NSTextAlignmentCenter;
    lbl2.font = [UIFont boldSystemFontOfSize:24.f];
    [bgView addSubview:lbl2];
    lbl2.tag = 100;
    
    [lbl1 sizeToFit];
    [lbl2 sizeToFit];
    
    CGFloat Y = (bgView2.height-(lbl1.height+2+lbl2.height))/2+bgView2.top;
    lbl1.frame = CGRectMake(4.5, Y, bgView2.width, lbl1.height);
    lbl2.frame = CGRectMake(4.5, lbl1.top+lbl1.height+2, bgView2.width, lbl2.height);
    
    return bgView;
}

- (void)activityInfoManagerTickNotification
{
    [self updateLbls];
}

- (void)updateLbls
{
    if (_activityInfo.remainTime>0 && !_activityInfo.isFinished) {
        ((UILabel*)[_hourLbl viewWithTag:100]).text = [_activityInfo remainHoursString];
        ((UILabel*)[_minLbl viewWithTag:100]).text = [_activityInfo remainMinutesString];
        ((UILabel*)[_secLbl viewWithTag:100]).text = [_activityInfo remainSecondsString];
        
        ((UILabel*)[_hourLbl viewWithTag:100]).textColor = [UIColor whiteColor];
        ((UILabel*)[_minLbl viewWithTag:100]).textColor = [UIColor whiteColor];
        ((UILabel*)[_secLbl viewWithTag:100]).textColor = [UIColor whiteColor];
    } else {
        
        ((UILabel*)[_hourLbl viewWithTag:100]).text = @"00";
        ((UILabel*)[_minLbl viewWithTag:100]).text = @"00";
        ((UILabel*)[_secLbl viewWithTag:100]).text = @"00";
        
        ((UILabel*)[_hourLbl viewWithTag:100]).textColor = [UIColor colorWithHexString:@"CCCCCC"];
        ((UILabel*)[_minLbl viewWithTag:100]).textColor = [UIColor colorWithHexString:@"CCCCCC"];
        ((UILabel*)[_secLbl viewWithTag:100]).textColor = [UIColor colorWithHexString:@"CCCCCC"];
        
        [_timer invalidate];
        _timer = nil;
    }
}

@end


#import "GoodsTableViewCell.h"

@interface RecommendGoodsWithCoverCell ()
@property(nonatomic,strong) GoodsInfo *goodsInfo;
@property(nonatomic,assign) NSInteger pageIndex;
@end

@implementation RecommendGoodsWithCoverCell {
    XMWebImageView *_coverView;
    CommandButton *_likeBtn;
    TapDetectingView *_bgView;
    UILabel *_shopPrice;
    UILabel *_marketPrice;
    UILabel *_visitNumLbl;
    CommandButton *_gradeLbl;
    UILabel *_admCommentLbl;
    XMWebImageView *_avatarView;
    CommandButton *_nickNameLbl;
    CommandButton *_followBtn;
    GoodsStatusMaskView *_statusView;
    
    SellerTagsView *_tagsView;
    UIImageView *_limitedTagView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendGoodsWithCoverCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        GoodsInfo *goodsInfo = [recommendInfo.list objectAtIndex:0];
        if (goodsInfo && [goodsInfo isKindOfClass:[GoodsInfo class]]) {
            height = kScreenWidth;//kScreenWidth*180/320;
        }
    }
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _coverView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _coverView.backgroundColor = [UIColor whiteColor];
        _coverView.contentMode = UIViewContentModeScaleAspectFill;
        _coverView.clipsToBounds = YES;
        [self.contentView addSubview:_coverView];
        
        _bgView = [[TapDetectingView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
        [self.contentView addSubview:_bgView];
        
        _likeBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 65, 30)];
        _likeBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        _likeBtn.layer.masksToBounds = YES;
        _likeBtn.layer.cornerRadius = 15.f;
        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
        [_likeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 4)];
        [_likeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
        [self.contentView addSubview:_likeBtn];
        
        _shopPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPrice.textColor = [DataSources globalThemeTextColor];
        _shopPrice.font = [UIFont boldSystemFontOfSize:14.f];
        [self.contentView addSubview:_shopPrice];
        
        _marketPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _marketPrice.textColor = [UIColor colorWithHexString:@"999999"];//[DataSources globalThemeTextColor];
        _marketPrice.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:_marketPrice];
        _marketPrice.hidden = YES;
        
        _visitNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _visitNumLbl.backgroundColor = [UIColor clearColor];
        _visitNumLbl.textColor = [UIColor colorWithHexString:@"999999"];//[DataSources goodsMarketPriceTextColor];
        _visitNumLbl.numberOfLines = 1;
        _visitNumLbl.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:_visitNumLbl];
        
        _gradeLbl = [[CommandButton alloc] initWithFrame:CGRectZero];
        _gradeLbl.backgroundColor = [UIColor blackColor];
        [_gradeLbl setTitleColor:[UIColor colorWithHexString:@"DBC085"] forState:UIControlStateNormal];
        _gradeLbl.titleLabel.font = [UIFont systemFontOfSize:10.f];
        _gradeLbl.layer.borderColor = [DataSources globalThemeTextColor].CGColor;
        _gradeLbl.layer.cornerRadius = 3.f;
        _gradeLbl.layer.borderWidth = 0.8f;
        _gradeLbl.layer.masksToBounds = YES;
        _gradeLbl.hidden = YES;
        [self.contentView addSubview:_gradeLbl];
        _gradeLbl.hidden = YES;
        
        _gradeLbl.handleClickBlock = ^(CommandButton *sender) {
            [URLScheme locateWithHtml5Url:kURLGradeIntro andIsShare:YES];
        };
        
        _admCommentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _admCommentLbl.textColor = [UIColor whiteColor];
        _admCommentLbl.font = [UIFont boldSystemFontOfSize:12.f];
        _admCommentLbl.numberOfLines = 2;
        [self.contentView addSubview:_admCommentLbl];
        
        _avatarView = [[XMWebImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        _avatarView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        _avatarView.layer.masksToBounds = YES;
        _avatarView.layer.cornerRadius = 12.f;
        [self.contentView addSubview:_avatarView];
        
        _nickNameLbl = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_nickNameLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _nickNameLbl.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _nickNameLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:_nickNameLbl];
        
        _followBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 78, 24)];
        _followBtn.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
        _followBtn.layer.masksToBounds = YES;
        _followBtn.layer.cornerRadius = 12.f;
        [_followBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        _followBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:_followBtn];
        
        WEAKSELF;
        _coverView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:weakSelf.goodsInfo.goodsId animated:YES];
            if (weakSelf.pageIndex == 0) {
                [MobClick event:@"click_item_from_recommand_feeds"];
            } else if (weakSelf.pageIndex == 1) {
                [MobClick event:@"click_item_from_favor_feeds"];
            } else if (weakSelf.pageIndex == 2) {
                [MobClick event:@"click_item_from_just_in_feeds"];
            }
        };
        
        //click_item_from_recommand_feeds,精选商品feeds流点击单品,0
        //click_want_from_recommand_feeds,精选商品feeds流点击想要,0
        //click_item_from_favor_feeds,关注商品feeds流点击单品,0
        //click_want_from_favor_feeds,关注商品feeds流点击想要,0
        //click_item_from_just_in_feeds,最新商品feeds流点击单品,0
        //click_want_from_just_in_feeds,最新商品feeds流点击想要,0
        
        _bgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:weakSelf.goodsInfo.goodsId animated:YES];
            
            if (weakSelf.pageIndex == 0) {
                [MobClick event:@"click_item_from_recommand_feeds"];
            } else if (weakSelf.pageIndex == 1) {
                [MobClick event:@"click_item_from_favor_feeds"];
            } else if (weakSelf.pageIndex == 2) {
                [MobClick event:@"click_item_from_just_in_feeds"];
            }
        };
        
        _likeBtn.handleClickBlock = ^(CommandButton *sender) {
            
            if (weakSelf.goodsInfo.isLiked) {
                [GoodsSingletonCommand unlikeGoods:weakSelf.goodsInfo.goodsId];
            } else {
                [GoodsSingletonCommand likeGoods:weakSelf.goodsInfo.goodsId];
            }
            
            if (weakSelf.pageIndex == 0) {
                [MobClick event:@"click_want_from_recommand_feeds"];
            } else if (weakSelf.pageIndex == 1) {
                [MobClick event:@"click_want_from_favor_feeds"];
            } else if (weakSelf.pageIndex == 2) {
                [MobClick event:@"click_want_from_just_in_feeds"];
            }
        };
        
        _avatarView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            [[CoordinatingController sharedInstance] gotoUserHomeViewController:weakSelf.goodsInfo.seller.userId animated:YES];
        };
        
        _nickNameLbl.handleClickBlock = ^(CommandButton *sender) {
            [[CoordinatingController sharedInstance] gotoUserHomeViewController:weakSelf.goodsInfo.seller.userId animated:YES];
        };
        
        _followBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.goodsInfo.seller.isfollowing) {
                [UserSingletonCommand unfollowUser:weakSelf.goodsInfo.seller.userId];
            } else {
                [UserSingletonCommand followUser:weakSelf.goodsInfo.seller.userId];
            }
        };
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _gradeLbl.hidden = YES;
    _avatarView.image = nil;
    _admCommentLbl.text = nil;
    _limitedTagView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _coverView.frame = self.contentView.bounds;
    _likeBtn.frame = CGRectMake(self.contentView.width-10-_likeBtn.width, 10, _likeBtn.width, _likeBtn.height);
    _followBtn.frame = CGRectMake(self.contentView.width-10-_followBtn.width, self.contentView.height-10-_followBtn.height, _followBtn.width, _followBtn.height);
    
    _avatarView.frame = CGRectMake(10, self.contentView.height-10-_avatarView.height, _avatarView.width, _avatarView.height);
    [_nickNameLbl sizeToFit];
    _nickNameLbl.frame = CGRectMake(_avatarView.right+10, _avatarView.top, _nickNameLbl.width, _avatarView.height);
    
    
    _tagsView.frame = CGRectMake(_nickNameLbl.right+6, _avatarView.top+(_avatarView.height-_tagsView.height)/2, _tagsView.width, _tagsView.height);
    
    //    if (_tagsView.right+15>kScreenWidth) {
    //        _tagsView.frame = CGRectMake(kScreenWidth-15-_tagsView.width, _nickNameLbl.top+(nickNameLblSize.height-_tagsView.height)/2, _tagsView.width, _tagsView.height);
    //        _nickNameLbl.frame = CGRectMake(marginLeft, _avatarView.top, _tagsView.left-8-marginLeft, nickNameLblSize.height);
    //    }
    
    
    CGSize gradeTextSize = CGSizeZero;
    NSString *gradeText = [_gradeLbl titleForState:UIControlStateNormal];
    if ([gradeText length]>0) {
        gradeTextSize = [gradeText sizeWithFont:[UIFont systemFontOfSize:10.f]
                              constrainedToSize:CGSizeMake(kScreenWidth-15.f-15.f,MAXFLOAT)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        gradeTextSize.height = 15.f;
        gradeTextSize.width += 8;
    }
    
    //_gradeLbl.frame = CGRectMake(10, 15+1, gradeTextSize.width, gradeTextSize.height);
    
    if (gradeTextSize.width >0) {
        _admCommentLbl.frame = CGRectMake(10+gradeTextSize.width+8, 0, self.contentView.width-10-(10+gradeTextSize.width+8), 0);
        [_admCommentLbl sizeToFit];
        _admCommentLbl.frame = CGRectMake(10+gradeTextSize.width+8, _avatarView.top-10-_admCommentLbl.height, self.self.contentView.width-10-(10+gradeTextSize.width+8), _admCommentLbl.height);
        
        _gradeLbl.frame = CGRectMake(10, _admCommentLbl.top, gradeTextSize.width, gradeTextSize.height);
    } else {
        _admCommentLbl.frame = CGRectMake(10, 0, self.contentView.width-20, 0);
        [_admCommentLbl sizeToFit];
        _admCommentLbl.frame = CGRectMake(10, _avatarView.top-10-_admCommentLbl.height, self.contentView.width-20, _admCommentLbl.height);
    }
    
    _shopPrice.frame = CGRectMake(10, 0, self.contentView.width-20, 0);
    [_shopPrice sizeToFit];
    if (![_admCommentLbl isHidden]) {
        _shopPrice.frame = CGRectMake(10, _admCommentLbl.top-10-_shopPrice.height, _shopPrice.width, _shopPrice.height);
    } else {
        _shopPrice.frame = CGRectMake(10, _avatarView.top-10-_shopPrice.height, _shopPrice.width, _shopPrice.height);
    }
    
    [_marketPrice sizeToFit];
    _marketPrice.frame = CGRectMake(_shopPrice.right+8, _shopPrice.top, _marketPrice.width, _shopPrice.height);
    
    [_visitNumLbl sizeToFit];
    _visitNumLbl.frame = CGRectMake(self.width-10-_visitNumLbl.width, _shopPrice.top, _visitNumLbl.width, _visitNumLbl.height);
    
    _bgView.frame = CGRectMake(0, _shopPrice.top-10, self.contentView.width, self.contentView.height-(_shopPrice.top-10));
    
    _statusView.center = self.contentView.center;
    
    _limitedTagView.frame = CGRectMake(0, 0, _limitedTagView.frame.size.width, _limitedTagView.frame.size.height);
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    [super updateCellWithDict:dict];
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo
        && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        BOOL isShowGoodsCover = [dict boolValueForKey:[[self class] cellKeyForIsShowGoodsCover] defaultValue:NO];
        BOOL isShowFollowBtn = [dict boolValueForKey:[[self class] cellKeyForIsShowFollowBtn] defaultValue:NO];
        GoodsInfo *goodsInfo = [recommendInfo.list objectAtIndex:0];
        if (goodsInfo && [goodsInfo isKindOfClass:[GoodsInfo class]]) {
            
            _pageIndex = [dict integerValueForKey:@"pageIndex"];
            
            _goodsInfo = goodsInfo;
            
            [_avatarView setImageWithURL:goodsInfo.seller.avatarUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale80x80];
            [_nickNameLbl setTitle:goodsInfo.seller.userName forState:UIControlStateNormal];
            
            if ([goodsInfo.seller.authTags count]>0) {
                if (!_tagsView) {
                    _tagsView = [[SellerTagsView alloc] initWithFrame:CGRectMake(0, 0, [SellerTagsView widthForOrientationPortrait:goodsInfo.seller.authTags showTitle:NO], [SellerTagsView heightForOrientationPortrait:goodsInfo.seller.authTags showTitle:NO])];
                    [self addSubview:_tagsView];
                } else {
                    _tagsView.frame = CGRectMake(0, 0, [SellerTagsView widthForOrientationPortrait:goodsInfo.seller.authTags showTitle:NO], [SellerTagsView heightForOrientationPortrait:goodsInfo.seller.authTags showTitle:NO]);
                }
                [_tagsView updateWithUserInfo:goodsInfo.seller.authTags showTitle:NO];
                _tagsView.hidden = NO;
            } else {
                _tagsView.hidden = YES;
            }
            
            _shopPrice.text = [NSString stringWithFormat:@"¥ %@",[GoodsInfo formatPriceString:_goodsInfo.shopPrice]];
            
            if (_goodsInfo.marketPrice>0) {
                _marketPrice.text = [GoodsInfo formatPriceString:_goodsInfo.marketPrice];
                _marketPrice.hidden = NO;
                
                NSString *marketPrice = [NSString stringWithFormat:@"¥ %@",[GoodsInfo formatPriceString:_goodsInfo.marketPrice]];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:marketPrice];
                [attrString addAttribute:NSStrikethroughStyleAttributeName
                                   value:[NSNumber numberWithInteger:NSUnderlinePatternSolid|NSUnderlineStyleSingle]
                                   range:NSMakeRange(0, marketPrice.length)];
                _marketPrice.attributedText = attrString;
            } else {
                _marketPrice.text = nil;
                _marketPrice.hidden = YES;
                _marketPrice.attributedText = nil;
            }
            
            _visitNumLbl.text = [NSString stringWithFormat:@"%@次浏览",[GoodsInfo formatVisitNumString:_goodsInfo.stat.visitNum]];
            
            if (isShowFollowBtn) {
                if (_goodsInfo.seller.isfollowing) {
                    //                    _followBtn.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
                    //                    [_followBtn setTitle:@"已关注" forState:UIControlStateNormal];
                    //                    [_followBtn setImage:nil forState:UIControlStateNormal];
                    //        [_followBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                    //        [_followBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
                    _followBtn.selected = YES;
                    _followBtn.hidden = YES;
                } else {
                    _followBtn.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
                    [_followBtn setTitle:@"推荐关注" forState:UIControlStateNormal];
                    [_followBtn setImage:[UIImage imageNamed:@"user_follow_icon_small"] forState:UIControlStateNormal];
                    [_followBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 2)];
                    [_followBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 2, 0, 0)];
                    _followBtn.selected = NO;
                    _followBtn.hidden = NO;
                }
            } else {
                _followBtn.hidden = YES;
            }
            
            [_likeBtn setTitle:[GoodsInfo formatLikeNumString:_goodsInfo.stat.likeNum] forState:UIControlStateNormal];
            if (goodsInfo.isLiked) {
                [_likeBtn setImage:[UIImage imageNamed:@"goods_liked"] forState:UIControlStateNormal];
            } else {
                [_likeBtn setImage:[UIImage imageNamed:@"goods_like_icon"] forState:UIControlStateNormal];
            }
            
            if (![goodsInfo isOnSale]) {
                if (!_statusView) {
                    _statusView = [[GoodsStatusMaskView alloc] initForCircle:90.f];
                    [self addSubview:_statusView];
                }
                _statusView.hidden = NO;
                _statusView.statusString = goodsInfo.statusDescription;
            } else {
                _statusView.hidden = YES;
            }
            
            if (isShowGoodsCover && [goodsInfo.coverItem.picUrl length]>0) {
                [_coverView setImageWithURL:goodsInfo.coverItem.picUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
            } else {
                [_coverView setImageWithURL:goodsInfo.mainPicUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
            }
            
            if (isShowGoodsCover && goodsInfo.admComment && [goodsInfo.admComment length]>0) {
                _admCommentLbl.text = goodsInfo.admComment;
                _gradeLbl.hidden = YES;
                [_gradeLbl setTitle:nil forState:UIControlStateNormal];
            } else {
                _admCommentLbl.text = goodsInfo.goodsName;
                
                if (goodsInfo.gradeTag && [goodsInfo.gradeTag.value length]>0) {
                    _gradeLbl.hidden = NO;
                    [_gradeLbl setTitle:goodsInfo.gradeTag.value forState:UIControlStateNormal];
                } else {
                    _gradeLbl.hidden = YES;
                    [_gradeLbl setTitle:nil forState:UIControlStateNormal];
                }
            }
            
            if (goodsInfo.isLimitActivity) {
                if (!_limitedTagView) {
                    _limitedTagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"goods_tag_limited"]];
                    [self.contentView addSubview:_limitedTagView];
                }
                _limitedTagView.hidden = NO;
            } else {
                _limitedTagView.hidden = YES;
            }
        }
        [self setNeedsLayout];
    }
}

+ (NSMutableDictionary*)buildCellDict:(RecommendInfo*)recommendInfo isShowGoodsCover:(BOOL)isShowGoodsCover isShowFollowBtn:(BOOL)isShowFollowBtn
{
    return [self buildCellDict:recommendInfo isShowGoodsCover:isShowGoodsCover isShowFollowBtn:isShowFollowBtn pageIndex:0];
}

+ (NSMutableDictionary*)buildCellDict:(RecommendInfo*)recommendInfo isShowGoodsCover:(BOOL)isShowGoodsCover isShowFollowBtn:(BOOL)isShowFollowBtn pageIndex:(NSInteger)pageIndex {
    
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecommendGoodsWithCoverCell class]];
    
    if (recommendInfo)[dict setObject:recommendInfo forKey:[self cellKeyForRecommendInfo]];
    [dict setObject:[NSNumber numberWithBool:isShowGoodsCover] forKey:[self cellKeyForIsShowGoodsCover]];
    [dict setObject:[NSNumber numberWithBool:isShowFollowBtn] forKey:[self cellKeyForIsShowFollowBtn]];
    [dict setObject:[NSNumber numberWithInteger:pageIndex] forKey:@"pageIndex"];
    return dict;
    
}

+ (NSString*)cellKeyForIsShowGoodsCover {
    return @"isShowGoodsCover";
}

+ (NSString*)cellKeyForIsShowFollowBtn {
    return @"isShowFollowBtn";
}

@end

#import "GoodsTableViewCell.h"
#import "SearchResultSellerItem.h"

@implementation RecommendSellerCell {
    GoodsSellerInfoView *_sellerInfoView;
    RedirectInfoView *_infoView0;
    RedirectInfoView *_infoView1;
    RedirectInfoView *_infoView2;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendSellerCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        RecommendSellerInfo *item = [recommendInfo.list objectAtIndex:0];
        if ([item isKindOfClass:[RecommendSellerInfo class]]) {
            if ([item.redirectList count]>0) {
                CGFloat width = (kScreenWidth-30-20)/3;
                height = 13+[GoodsSellerInfoView heightForOrientationPortrait]+23+width+13;
            } else {
                height = 13+[GoodsSellerInfoView heightForOrientationPortrait]+13;
            }
        }
    }
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _sellerInfoView = [[GoodsSellerInfoView alloc] initWithFrame:CGRectZero];
        _sellerInfoView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_sellerInfoView];
        
        UIImageView *rightArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow"]];
        rightArrow.tag = 1003;
        [_sellerInfoView addSubview:rightArrow];
        
        _infoView0 = [[RedirectInfoView alloc] initWithFrame:CGRectZero];
        _infoView0.hidden = YES;
        _infoView0.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        [self.contentView addSubview:_infoView0];
        
        _infoView1 = [[RedirectInfoView alloc] initWithFrame:CGRectZero];
        _infoView1.hidden = YES;
        _infoView1.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        [self.contentView addSubview:_infoView1];
        
        _infoView2 = [[RedirectInfoView alloc] initWithFrame:CGRectZero];
        _infoView2.hidden = YES;
        _infoView2.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        [self.contentView addSubview:_infoView2];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_sellerInfoView prepareForReuse];
    _sellerInfoView.frame = CGRectZero;
    _infoView0.hidden = YES;
    _infoView1.hidden = YES;
    _infoView2.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat marginTop = 13.f;
    _sellerInfoView.frame = CGRectMake(0, marginTop, self.contentView.width, [GoodsSellerInfoView heightForOrientationPortrait]);
    
    UIView *rightArrow = [_sellerInfoView viewWithTag:1003];
    rightArrow.frame = CGRectMake(_sellerInfoView.width-15-rightArrow.width, (_sellerInfoView.height-rightArrow.height)/2, rightArrow.width, rightArrow.height);
    
    marginTop += _sellerInfoView.height;
    marginTop += 23;
    
    CGFloat width = (kScreenWidth-30-20)/3;
    
    CGFloat marginLeft = 15;
    _infoView0.frame = CGRectMake(marginLeft, marginTop, width, width);
    marginLeft += _infoView0.width;
    marginLeft += 10;
    _infoView1.frame = CGRectMake(marginLeft, marginTop, width, width);
    marginLeft += _infoView1.width;
    marginLeft += 10;
    _infoView2.frame = CGRectMake(marginLeft, marginTop, width, width);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        RecommendSellerInfo *item = [recommendInfo.list objectAtIndex:0];
        if ([item isKindOfClass:[RecommendSellerInfo class]]) {
            if ([item isKindOfClass:[SearchResultSellerItem class]]) {
                [_sellerInfoView updateWithSellerInfo:item.sellerInfo];
                
                if ([item.redirectList count]>0) {
                    _infoView0.hidden = NO;
                    [_infoView0 updateWithRedirectInfo:[item.redirectList objectAtIndex:0] imageSize:CGSizeMake(300, 300)];
                }
                if ([item.redirectList count]>1) {
                    _infoView1.hidden = NO;
                    [_infoView1 updateWithRedirectInfo:[item.redirectList objectAtIndex:1] imageSize:CGSizeMake(300, 300)];
                }
                if ([item.redirectList count]>2) {
                    _infoView2.hidden = NO;
                    [_infoView2 updateWithRedirectInfo:[item.redirectList objectAtIndex:2] imageSize:CGSizeMake(300, 300)];
                }
                [self setNeedsLayout];
            }
        }
    }
}

@end



@interface RecommendTouTiaoCell ()
@property(nonatomic,strong) NSArray *redirectInfoList;
@end

@implementation RecommendTouTiaoCell {
    UIImageView *_headLineView;
    UIImageView *_speakerView;
    TapDetectingLabel *_label1;
    TapDetectingLabel *_label2;
    CALayer *_topLine;
    CALayer *_bottomLine;
    CALayer *_sepLine;
    NSTimer *_timer;
    
    CGFloat labelsMarginLeft;
    NSInteger _curDisplayIndex;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendTouTiaoCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = kScreenWidth*36.f/320.f;
    return height;
}

- (void)dealloc
{
    [_timer invalidate];
    _timer = nil;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.contentView.clipsToBounds = YES;
        self.clipsToBounds = YES;
        
        _headLineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recommend_toutiao_headlines_new"]];
        [self.contentView addSubview:_headLineView];
        
        //        _speakerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"recommend_toutiao_speaker"]];
        //        [self.contentView addSubview:_speakerView];
        
        
        _label2 = [[TapDetectingLabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
        _label2.backgroundColor = [UIColor clearColor];
        _label2.numberOfLines = 1;
        _label2.textColor = [UIColor colorWithHexString:@"666666"];
        _label2.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:_label2];
        
        _label1 = [[TapDetectingLabel alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.height)];
        _label1.backgroundColor = [UIColor clearColor];
        _label1.numberOfLines = 1;
        _label1.textColor = [UIColor colorWithHexString:@"666666"];
        _label1.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:_label1];
        
        _topLine = [CALayer layer];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.contentView.layer addSublayer:_topLine];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
        
        _sepLine = [CALayer layer];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.contentView.layer addSublayer:_sepLine];
        
        _curDisplayIndex = 0;
        
        WEAKSELF;
        _label1.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
            if (view.tag<[weakSelf.redirectInfoList count]) {
                RedirectInfo *redirectInfo = (RedirectInfo*)[weakSelf.redirectInfoList objectAtIndex:view.tag];
                if (redirectInfo) {
                    [[Session sharedInstance] clientReport:redirectInfo data:nil];
                }
                [URLScheme locateWithRedirectUri:redirectInfo.redirectUri andIsShare:YES];
            }
        };
        _label2.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
            if (view.tag<[weakSelf.redirectInfoList count]) {
                RedirectInfo *redirectInfo = (RedirectInfo*)[weakSelf.redirectInfoList objectAtIndex:view.tag];
                if (redirectInfo) {
                    [[Session sharedInstance] clientReport:redirectInfo data:nil];
                }
                [URLScheme locateWithRedirectUri:redirectInfo.redirectUri andIsShare:YES];
            }
        };
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _topLine.frame = CGRectMake(0, 0, self.contentView.width, 0.5f);
    _bottomLine.frame = CGRectMake(0, self.contentView.height-0.5, self.contentView.width, 0.5f);
    
    CGFloat marginLeft = 15;
    _headLineView.frame = CGRectMake(0, (self.contentView.height-_headLineView.height)/2, _headLineView.width, _headLineView.height);
    marginLeft += _headLineView.width;
    marginLeft += 10;
    
    _sepLine.frame = CGRectMake(CGRectGetMaxX(_headLineView.frame), (self.contentView.height-25)/2, 0.5, 25);
    marginLeft += _sepLine.bounds.size.width;
    marginLeft += 7;
    
    //    _speakerView.frame = CGRectMake(marginLeft, (self.contentView.height-_speakerView.height)/2, _speakerView.width, _speakerView.height);
    //    marginLeft += _speakerView.width;
    //    marginLeft += 7;
    
    labelsMarginLeft = marginLeft;
    
    _label1.frame = CGRectMake(CGRectGetMaxX(_sepLine.frame)+10, 0, self.contentView.width-marginLeft-10, self.contentView.height);
    _label2.frame = CGRectMake(CGRectGetMaxX(_sepLine.frame)+10, self.contentView.height, self.contentView.width-marginLeft-10, self.contentView.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        NSMutableArray *redirectInfoList = [[NSMutableArray alloc] init];
        for (RedirectInfo *redirectInfo in recommendInfo.list) {
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                [redirectInfoList addObject:redirectInfo];
            }
        }
        _redirectInfoList = redirectInfoList;
        [self setNeedsLayout];
        
        [_timer invalidate];
        _timer = nil;
        
        
        
        if ([_redirectInfoList count]>1) {
            
            RedirectInfo *redirectInfo = (RedirectInfo*)[_redirectInfoList objectAtIndex:0];
            _label1.text = redirectInfo.title;
            _label1.tag = 0;
            
            redirectInfo = (RedirectInfo*)[_redirectInfoList objectAtIndex:1];
            _label2.text = redirectInfo.title;
            _label2.tag = 1;
            
            WeakTimerTarget *target = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(onTimer:)];
            _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:target selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
            
            _curDisplayIndex = 1;
            
        } else {
            if ([_redirectInfoList count]>0) {
                RedirectInfo *redirectInfo = (RedirectInfo*)[_redirectInfoList objectAtIndex:0];
                _label1.text = redirectInfo.title;
                _label1.tag = 0;
                _curDisplayIndex = 0;
            }
        }
    }
}

- (void)onTimer:(NSTimer*)theTimer {
    
    CGFloat marginLeft = _label1.left;
    CGRect label1BeginFrame = CGRectMake(marginLeft, 0, self.contentView.width-marginLeft-10, self.contentView.height);
    CGRect label1EndFrame = CGRectMake(marginLeft, -self.contentView.height, self.contentView.width-marginLeft-10, self.contentView.height);
    
    CGRect label2BeginFrame = CGRectMake(marginLeft, self.contentView.height, self.contentView.width-marginLeft-10, self.contentView.height);
    CGRect label2EndFrame = CGRectMake(marginLeft, 0,self.contentView.width-marginLeft-10,self.contentView.height);
    
    _label1.frame = label1BeginFrame;
    _label2.frame = label2BeginFrame;
    
    [UIView animateWithDuration:0.4 animations:^{
        _label1.frame = label1EndFrame;
        _label2.frame = label2EndFrame;
    } completion:^(BOOL finished) {
        TapDetectingLabel *tmpLbl = _label1;
        _label1 = _label2;
        _label2 = tmpLbl;
        
        if (_curDisplayIndex+1<[_redirectInfoList count]) {
            RedirectInfo *redirectInfo = (RedirectInfo*)[_redirectInfoList objectAtIndex:_curDisplayIndex+1];
            _label2.text = redirectInfo.title;
            _curDisplayIndex = _curDisplayIndex+1;
        } else if ([_redirectInfoList count]>0) {
            _curDisplayIndex = 0;
            RedirectInfo *redirectInfo = (RedirectInfo*)[_redirectInfoList objectAtIndex:0];
            _label2.text = redirectInfo.title;
        }
    }];
}

@end


//@interface RecommendSideSlipCell ()
//@property(nonatomic,weak) UIScrollView *scrollView;
//@end

@interface RecommendSideSlipCell () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) MFCollectionViewFlowLayout *layout;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) NSInteger maxCount;
@property (nonatomic, assign) CGFloat offer;
@property (nonatomic, strong) RedirectInfo *info;

@property (nonatomic, strong) StyledPageControl *pageControl;
@end

@implementation RecommendSideSlipCell

-(StyledPageControl *)pageControl{
    if (!_pageControl) {
        _pageControl = [[StyledPageControl alloc] initWithFrame:CGRectZero];
        [_pageControl setPageControlStyle:PageControlStyleThumb];
        [_pageControl setThumbImage:[UIImage imageNamed:@"compose_keyboard_dot_normal"]];
        [_pageControl setSelectedThumbImage:[UIImage imageNamed:@"compose_keyboard_dot_selected"]];
        [_pageControl setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    }
    return _pageControl;
}

-(NSMutableArray *)list{
    if (!_list) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}

-(MFCollectionViewFlowLayout *)layout{
    if (!_layout) {
        _layout = [[MFCollectionViewFlowLayout alloc] init];
    }
    return _layout;
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        //        _collectionView.pagingEnabled = YES;
        _collectionView.showsHorizontalScrollIndicator = NO;
    }
    return _collectionView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendSideSlipCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    //修改cell的高度   2016.1.7  Feng
    //修改cell的高度   2016.5.5  Feng
    //修改cell的高度   2016.5.5  Feng
    //修改cell的高度   2016.6.7  Feng
    
    CGFloat height = 0;
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    for (int i = 0; i < recommendInfo.list.count; i++) {
        RedirectInfo *redirectInfo = recommendInfo.list[0];
        
        if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
            if (redirectInfo.height> 0) {
                height += kScreenWidth/320*redirectInfo.height;
                if ([redirectInfo isNewComposition]) {
                    height += kisNewCompositionHeight;
                    height += 30;
                }
                //                height += 10;
                return height;
            } else {
                height = 90;
            }
        }
    }
    
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.clipsToBounds = YES;
        self.clipsToBounds = YES;
        //        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
        //        [self.contentView addSubview:scrollView];
        //        scrollView.alwaysBounceHorizontal = YES;
        //        scrollView.showsHorizontalScrollIndicator = NO;
        //        scrollView.showsVerticalScrollIndicator = NO;
        //        _scrollView = scrollView;
        
        [self.collectionView registerClass:[SideSlipRedirectInfoCell class] forCellWithReuseIdentifier:@"idnetifier"];
        [self.contentView addSubview:self.collectionView];
        [self.contentView addSubview:self.pageControl];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.collectionView.frame = CGRectMake(0, 15, kScreenWidth, self.contentView.height-30);
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.collectionView.mas_bottom);//.offset(14);
        make.centerX.equalTo(self.collectionView.mas_centerX);
        make.width.equalTo(@(self.collectionView.width));
        make.height.equalTo(@10);
    }];
    //    CGFloat marginLeft = 0;
    //    NSArray *subviews = [_scrollView subviews];
    //    for (UIView *view in subviews) {
    //        if ([view isKindOfClass:[SideSlipRedirectInfoView class]]) {
    //            view.frame = CGRectMake(marginLeft, 0, view.width, view.height);
    //            marginLeft += view.width;
    ////            marginLeft += 10;
    //        }
    //    }
    //
    //    _scrollView.contentSize = CGSizeMake(marginLeft, _scrollView.height);
    //    _scrollView.alwaysBounceHorizontal = YES;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.maxCount;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SideSlipRedirectInfoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"idnetifier" forIndexPath:indexPath];
    RedirectInfo *redirectInfo = self.list[(indexPath.row%self.list.count)];
    [cell update:redirectInfo];
    
    return cell;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    self.maxCount = 100*100;
    self.pageControl.hidden = YES;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        
        //        NSArray *subviews = [_scrollView subviews];
        //        for (UIView *view in subviews) {
        //            [view removeFromSuperview];
        //        }
        //        CGFloat marginLeft = 0;
        
        
        self.list = recommendInfo.list;
        for (RedirectInfo *redirectInfo in recommendInfo.list) {
            if ([redirectInfo isKindOfClass:[RedirectInfo class]]) {
                //这里cell大小修改为170*170  2016.1.7 Feng
                //cell大小修改为  67.5*67.5  2016.5.5 Feng
                //cell大小修改为  85*85      2016.5.5 Feng
                //cell大小修改为  75*75      2016.6.7 Feng
                //间距调整为0                2016.9.27 Feng
                
                self.layout.minimumLineSpacing = 0;
                self.layout.minimumInteritemSpacing = 0;
                self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                if (redirectInfo.width > 0 && redirectInfo.height > 0) {
                    self.layout.itemSize = CGSizeMake(kScreenWidth/320*redirectInfo.width, kScreenWidth/320*redirectInfo.height);
                } else {
                    self.layout.itemSize = CGSizeMake(147, 90);
                }
                self.collectionView.collectionViewLayout = self.layout;
                [self.collectionView reloadData];
                
                if (redirectInfo.width <= kScreenWidth/2) {
                    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
                    layout.minimumLineSpacing = 0;
                    layout.minimumInteritemSpacing = 0;
                    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                    if (redirectInfo.width > 0 && redirectInfo.height > 0) {
                        layout.itemSize = CGSizeMake(kScreenWidth/320*redirectInfo.width, kScreenWidth/320*redirectInfo.height);
                    } else {
                        layout.itemSize = CGSizeMake(147, 90);
                    }
                    self.collectionView.collectionViewLayout = layout;
                    [self.collectionView reloadData];
                }
                
                if ([redirectInfo isNewComposition]) {
                    //填写业务代码
                    self.pageControl.hidden = NO;
                    [self.pageControl setNumberOfPages:recommendInfo.list.count];
                    [self.pageControl setCurrentPage:0];
                    self.maxCount = recommendInfo.list.count;
                    MFCollectionViewFlowLayout *layout = [[MFCollectionViewFlowLayout alloc] init];
                    layout.minimumLineSpacing = 10;
                    layout.minimumInteritemSpacing = 0;
                    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
                    if (redirectInfo.height > 0) {
                        layout.itemSize = CGSizeMake(kScreenWidth-40, kScreenWidth/320*redirectInfo.height+kisNewCompositionHeight);
                    } else {
                        layout.itemSize = CGSizeMake(147, 90);
                    }
                    self.collectionView.collectionViewLayout = layout;
                    [self.collectionView reloadData];
                }
                //                SideSlipRedirectInfoView *view = [[SideSlipRedirectInfoView alloc] initWithFrame:CGRectMake(marginLeft, 0, 147, 90)];
                //                if (redirectInfo.width > 0 && redirectInfo.height > 0) {
                //                    view.frame = CGRectMake(marginLeft, 0, kScreenWidth/320*redirectInfo.width, kScreenWidth/320*redirectInfo.height);
                //                } else {
                //                    view.frame = CGRectMake(marginLeft, 0, 147, 90);
                //                }
                //                [view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake(147, 90)];
                //                [_scrollView addSubview:view];
                //                marginLeft += view.width;
                //                marginLeft += 0;
            }
        }
        RedirectInfo *info;
        if (recommendInfo.list.count > 0) {
            info = recommendInfo.list[0];
        }
        self.info = info;
        //        _scrollView.contentSize = CGSizeMake(marginLeft, _scrollView.height);
        
        if (self.index == 0 && (info.width > kScreenWidth/2 && ![info isNewComposition])) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:MAXRECOMMENDSIFTCOUNT/2 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
            });
            if (info.width > 0 && info.height > 0) {
                self.collectionView.contentInset = UIEdgeInsetsMake(0, -(kScreenWidth-(kScreenWidth/320*info.width))/2, 0, (kScreenWidth-(kScreenWidth/320*info.width))/2);
                self.index = 1;
            } else {
                self.collectionView.contentInset = UIEdgeInsetsMake(0, -(kScreenWidth-147)/2, 0, (kScreenWidth-147)/2);
                self.index = 1;
            }
            
        }
        [self setNeedsLayout];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //系统动画停止是刷新当前偏移量_offer是我定义的全局变量
    _offer = scrollView.contentOffset.x;
    
}

//用户拖拽是调用

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    if ([self.info isNewComposition]) {
        if (fabs(scrollView.contentOffset.x -_offer) > 20) {
            if (scrollView.contentOffset.x > _offer) {
                int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
                if (i > self.maxCount-1) {
                    i = (int)self.maxCount-1;
                }
                [self.pageControl setCurrentPage:i];
                NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
                [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }else{
                int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
                if (i < 1) {
                    i = 1;
                }
                [self.pageControl setCurrentPage:i-1];
                NSIndexPath * index =  [NSIndexPath indexPathForRow:i-1 inSection:0];
                [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }
    }
}

//滑动减速是触发的代理，当用户用力滑动或者清扫时触发
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    if ([self.info isNewComposition]) {
        if (fabs(scrollView.contentOffset.x -_offer) > 10) {
            if (scrollView.contentOffset.x > _offer) {
                int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
                if (i > self.maxCount-1) {
                    i = (int)self.maxCount-1;
                }
                [self.pageControl setCurrentPage:i];
                NSIndexPath * index =  [NSIndexPath indexPathForRow:i inSection:0];
                [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }else{
                int i = scrollView.contentOffset.x/([UIScreen mainScreen].bounds.size.width - 30)+1;
                if (i < 1) {
                    i = 1;
                }
                [self.pageControl setCurrentPage:i-1];
                NSIndexPath * index =  [NSIndexPath indexPathForRow:i-1 inSection:0];
                [_collectionView scrollToItemAtIndexPath:index atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
            }
        }
    }
}

@end


@interface RecommendFloatBoxCell ()


@property (nonatomic, weak) CALayer *scrollLayer;
@end

@implementation RecommendFloatBoxCell
{
    
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendFloatBoxCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        height = kScreenWidth*35.f/320.f;
    }
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.clipsToBounds = YES;
        self.clipsToBounds = YES;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        [self.contentView addSubview:view];
        self.container = view;
        view.backgroundColor = [UIColor whiteColor];
        SelectButton *nice = [SelectButton buttonWithType:UIButtonTypeCustom];
        nice.titleLabel.font = [UIFont systemFontOfSize:16];
        nice.isSelect = YES;
        self.niceButton = nice;
        [nice setButtonStyle];
        [nice addTarget:self action:@selector(niceButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.container addSubview:nice];
        
        
        SelectButton *follow = [SelectButton buttonWithType:UIButtonTypeCustom];
        follow.selected = NO;
        follow.titleLabel.font = [UIFont systemFontOfSize:16];
        self.followButton = follow;
        self.followButton.isSelect = NO;
        [follow setButtonStyle];
        [follow addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self.container addSubview:follow];
        
        CALayer *layer = [[CALayer alloc] init];
        _scrollLayer = layer;
        [self.container.layer addSublayer:layer];
        layer.backgroundColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
    }
    return self;
}

- (void)niceButtonAction
{
    if (!_niceButton.isSelect) {
        [UIView animateWithDuration:1 animations:^{
            _scrollLayer.frame = CGRectMake(10, kScreenWidth*35.f/320.f - 1, _niceButton.frame.size.width, 1);
        }];
    }
    _niceButton.isSelect = YES;
    _followButton.isSelect = NO;
    [_niceButton setButtonStyle];
    [_followButton setButtonStyle];
    if (_niceBlock)_niceBlock();
    
}

- (void)followButtonAction
{
    if (!_followButton.isSelect) {
        [UIView animateWithDuration:1 animations:^{
            _scrollLayer.frame = CGRectMake(_niceButton.frame.size.width + 20, kScreenWidth*35.f/320.f - 1, _followButton.frame.size.width, 1);
        }];
    }
    _followButton.isSelect = YES;
    _niceButton.isSelect = NO;
    [_niceButton setButtonStyle];
    [_followButton setButtonStyle];
    if (_followBlock)_followBlock();
    
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        RedirectInfo *niceDic = recommendInfo.list[0];
        NSString *niceStr = niceDic.title;
        [_niceButton setTitle:niceStr forState:UIControlStateNormal];
        _niceButton.selectUrl = niceDic.url;
        _niceButton.isSelect = YES;
        [_niceButton setButtonStyle];
        RedirectInfo *followDic = recommendInfo.list[1];
        NSString *followStr = followDic.title;
        [_followButton setTitle:followStr forState:UIControlStateNormal];
        _followButton.selectUrl = followDic.url;
        CGRect rect1 = [niceStr boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        _niceButton.frame = CGRectMake(10, (kScreenWidth*35.f/320.f - 20) /2.0 + 3, rect1.size.width + 20, 20);
        _scrollLayer.frame = CGRectMake(10, kScreenWidth*35.f/320.f - 2 , rect1.size.width + 20, 2);
        CGRect rect2 = [followStr boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
        _followButton.frame = CGRectMake(10 + rect1.size.width + 20 + 10, (kScreenWidth*35.f/320.f - 20) /2.0 + 3, rect2.size.width + 20, 20);
        [self setNeedsLayout];
    }
}


@end


@implementation SelectButton

- (void)setButtonStyle
{
    if (_isSelect) {
        [self setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
    } else {
        [self setTitleColor:[UIColor colorWithHexString:@"3e3a39"] forState:UIControlStateNormal];
    }
}

@end
//

@interface RecommendForumCell () <MJPhotoBrowserDelegate>

@property (nonatomic, strong) UIImageView *userAvatar;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *goodsInfo;
@property (nonatomic, strong) UILabel *goodsName;
@property (nonatomic, strong) UIImageView *followButton;
@property (nonatomic, strong) UIScrollView *gallary;
@property (nonatomic, strong) UILabel *tag1;
@property (nonatomic, strong) UILabel *tag2;
@property (nonatomic, strong) UILabel *tag3;
@property (nonatomic, strong) UILabel *tag4;
@property (nonatomic, strong) UILabel *tag5;
@property (nonatomic, strong) UILabel *summary;
@property (nonatomic, strong) UIButton *reply1;
@property (nonatomic, strong) UIButton *reply2;
@property (nonatomic, strong) UIButton *reply3;
@property (nonatomic, strong) NSDictionary *dict;
@property (nonatomic, strong) CALayer *lineLayer;
@property (nonatomic, assign) BOOL islike;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, strong) NSNumber *post_id;
@property (nonatomic, strong) NSNumber *user_id;
@property (nonatomic, strong) CommandButton *shareBtn;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) CommandButton *supprotBtn;
@property (nonatomic, strong) CommandButton *replyBtn;
@property (nonatomic, strong) UILabel *supportLabel;
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) CommandButton *moreButton;
@property (nonatomic, strong) NSMutableArray *gallaryData;
@property (nonatomic, strong) NSNumber *topic_id;
@property (nonatomic, strong) NSString *avatarurl;
@property (nonatomic, strong) NSString *shareContent;

@property (nonatomic, strong) XMWebImageView *recoverImageView;
@property (nonatomic, strong) ASScroll *scrollImageView;
@property (nonatomic, strong) NSMutableArray *imageViewArr;

@property (nonatomic, strong) CommandButton *replyBackBtn;
@property (nonatomic, strong) CommandButton *supportBackBtn;
@property (nonatomic, strong) CommandButton *shareBackBtn;

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *shareUrl;
@end
@implementation RecommendForumCell

-(NSMutableArray *)imageViewArr{
    if (!_imageViewArr) {
        _imageViewArr = [[NSMutableArray alloc] init];
    }
    return _imageViewArr;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendForumCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    NSNumber *type = dict[@"type"];
    NSString *summary;
    NSArray *gallary;
    NSArray *goods_commentList;
    if (type.integerValue == 1) {
        NSDictionary *goods_info = [dict dictionaryValueForKey:@"goods_info"];
        
        summary = [goods_info stringValueForKey:@"summary"];
        gallary = [dict arrayValueForKey:@"gallary"];
        goods_commentList = [dict arrayValueForKey:@"goods_commentList"];
    } else {
        ForumPostVO *post = [[ForumPostVO alloc] initWithJSONDictionary:dict];
        summary = post.content;
        gallary = post.attachments;
        goods_commentList = post.topReplies;
    }
    CGFloat topHight = 72;
    
    NSLog(@"%@, %@", type, gallary);
    
    CGFloat gallaryHight = floor(kScreenWidth / 3 - 3);
    if (gallary.count != 0) {
        if(type.integerValue == 1&& gallary.count == 1){
            gallaryHight = floor(kScreenWidth / 3-2) * 1.5;
            
        }  else if(type.integerValue == 2 && gallary.count == 1) {
            NSDictionary *dic = gallary[0];
            ForumAttachmentVO *attach = (ForumAttachmentVO *)dic;
            ForumAttachItemPicsVO *item = (ForumAttachItemPicsVO *)attach.item;
            gallaryHight = item.height / 2 + 30;
            NSLog(@"%ld", item.height);
        } //else if (type.integerValue == 2 && gallary.count == 2) {
        //                NSDictionary *dic = gallary[0];
        //                ForumAttachmentVO *attach = (ForumAttachmentVO *)dic;
        //                ForumAttachItemPicsVO *item = (ForumAttachItemPicsVO *)attach.item;
        //                gallaryHight = item.height / 4;
        //            }
        topHight = topHight + gallaryHight;
        NSLog(@"%f", topHight);
    }
    
    CGFloat blockHight = topHight + 45;
    CGRect summaryRect = CGRectZero;
    if ([summary isNotEmptyCtg]) {
        blockHight = blockHight + 15;
        summaryRect  = [summary boundingRectWithSize:CGSizeMake(kScreenWidth - 100, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    }
    height = blockHight + 23 * goods_commentList.count + 15 + summaryRect.size.height + 15 + 23;
    if (goods_commentList.count > 3) {
        height = height + 23;
    }
    
    return height;
}

- (CommandButton *)moreButton {
    if (!_moreButton) {
        self.moreButton = [[CommandButton alloc] init];
        self.moreButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.moreButton setTitleColor:[UIColor colorWithRed:152 / 255.0 green:152 /255.0 blue:152 /255.0 alpha:1] forState:UIControlStateNormal];
        [self.moreButton setTitle:@"查看更多回复" forState:UIControlStateNormal];
        self.moreButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.moreButton.hidden = YES;
    }
    return _moreButton;
}

-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        //        WEAKSELF;
        [_shareBtn setImage:[UIImage imageNamed:@"share_Button"] forState:UIControlStateNormal];
        //        UIImage *shareImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:
        //                               [SDWebImageManager lw_cacheKeyForURL:[NSURL URLWithString:self.avatarurl ]]];
        
        //        if (shareImage == nil) {
        //            shareImage = [UIImage imageNamed:@"AppIcon_120"];
        //        }
        //        NSNumber *type = [_dict objectForKey:@"type"];
        //        NSString *shareUrl;
        //        if (type.integerValue == 1) {
        //            shareUrl = [NSString stringWithFormat:@"http://activity.aidingmao.com/share/goods/detail/%@.html", self.post_id];
        //        } else {
        //            shareUrl = [NSString stringWithFormat:@"http://activity.aidingmao.com/forum/share/detail/%@", self.post_id];
        //        }
        //        _shareBtn.handleClickBlock = ^(CommandButton *sender) {
        //            [[CoordinatingController sharedInstance] shareWithTitle:@"精品分享" image:shareImage url:shareUrl content:weakSelf.shareContent];
        //        };
    }
    return _shareBtn;
}

-(CommandButton *)shareBackBtn{
    if (!_shareBackBtn) {
        _shareBackBtn = [[CommandButton alloc] init];
        WEAKSELF;
        UIImage *shareImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:
                               [SDWebImageManager lw_cacheKeyForURL:[NSURL URLWithString:self.avatarurl ]]];
        if (shareImage == nil) {
            shareImage = [UIImage imageNamed:@"AppIcon_120"];
        }
        NSNumber *type = [_dict objectForKey:@"type"];
        NSString *shareUrl;
        if (type.integerValue == 1) {
            shareUrl = [NSString stringWithFormat:@"http://activity.aidingmao.com/share/goods/detail/%@.html", self.post_id];
        } else {
            shareUrl = [NSString stringWithFormat:@"http://activity.aidingmao.com/forum/share/detail/%@", self.post_id];
        }
        self.shareUrl = shareUrl;
        _shareBackBtn.handleClickBlock = ^(CommandButton *sender) {
            [[CoordinatingController sharedInstance] shareWithTitle:@"精品分享" image:shareImage url:shareUrl content:weakSelf.shareContent];
        };
    }
    return _shareBackBtn;
}

-(UILabel *)replyLabel{
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        //        _replyLabel.text = @"14";
        _replyLabel.textColor = [UIColor grayColor];
        _replyLabel.font = [UIFont systemFontOfSize:14];
    }
    return _replyLabel;
}

- (UIButton *)replyBtn{
    if (!_replyBtn) {
        _replyBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        //        WEAKSELF;
        [_replyBtn setBackgroundImage:[UIImage imageNamed:@"tab_message"] forState:UIControlStateNormal];
        //        _replyBtn.handleClickBlock = ^(CommandButton *sender) {
        //            if (weakSelf.replyBlock) {
        //                weakSelf.replyBlock(weakSelf.dict[@"type"], weakSelf.post_id);
        //            }
        //        };
        
    }
    return _replyBtn;
}

- (CommandButton *)replyBackBtn{
    if (!_replyBackBtn) {
        _replyBackBtn = [[CommandButton alloc] init];
        WEAKSELF;
        _replyBackBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.replyBlock) {
                weakSelf.replyBlock(weakSelf.dict[@"type"], weakSelf.post_id);
            }
        };
    }
    return _replyBackBtn;
}

- (void)didSelectThisCell
{
    if (self.commentBlock) {
        self.commentBlock(self.dict[@"type"], self.post_id);
    }
}

-(CommandButton *)supprotBtn{
    if (!_supprotBtn) {
        //        WEAKSELF;
        _supprotBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_N"] forState:UIControlStateNormal];
        [_supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_H"] forState:UIControlStateSelected];
        
        //        _supprotBtn.handleClickBlock = ^(CommandButton *sender) {
        //
        //            BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
        //
        //            }];
        //            if (!isLoggedIn) {
        //                return;
        //            }
        //
        //            NSNumber *type = weakSelf.dict[@"type"];
        //            if (type.integerValue == 1) {
        //                [MobClick event:@"click_want_from_detail"];
        //                if (weakSelf.islike) {
        //                    [GoodsSingletonCommand unlikeGoods:[NSString stringWithFormat:@"%@", weakSelf.post_id]];
        //                    [weakSelf.supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_N"] forState:UIControlStateNormal];
        //                    weakSelf.islike = !weakSelf.islike;
        //                    NSString *str = weakSelf.supportLabel.text;
        //                    int a = str.intValue;
        //                    weakSelf.supportLabel.text = [NSString stringWithFormat:@"%d", --a];
        //                } else {
        //                    [GoodsSingletonCommand likeGoods:[NSString stringWithFormat:@"%@", weakSelf.post_id]];
        //                    [weakSelf.supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_H"] forState:UIControlStateNormal];
        //                    weakSelf.islike = !weakSelf.islike;
        //                    NSString *str = weakSelf.supportLabel.text;
        //                    int a = str.intValue;
        //                    weakSelf.supportLabel.text = [NSString stringWithFormat:@"%d", ++a];
        //                }
        //                if (weakSelf.likeBlock) {
        //
        ////                    if (![Session sharedInstance].isLoggedIn) {
        ////                        return ;
        ////                    }
        //
        //                    if (!weakSelf.islike) {
        //                        weakSelf.islike = NO;
        //                    }
        //                    weakSelf.likeBlock(weakSelf.supportLabel.text.integerValue, weakSelf.islike, type);
        //                }
        //
        //            } else {
        //            [ForumService post:weakSelf.post_id.integerValue like:!@(weakSelf.islike).integerValue completion:^(ForumTopicIsLike *likeArr) {
        //                if (weakSelf.islike) {
        //                    [weakSelf.supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_N"] forState:UIControlStateNormal];
        //                    weakSelf.islike = !weakSelf.islike;
        //                    NSString *str = weakSelf.supportLabel.text;
        //                    int a = str.intValue;
        //                    weakSelf.supportLabel.text = [NSString stringWithFormat:@"%d", --a];
        //                } else {
        //                    [weakSelf.supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_H"] forState:UIControlStateNormal];
        //                    weakSelf.islike = !weakSelf.islike;
        //                    NSString *str = weakSelf.supportLabel.text;
        //                    int a = str.intValue;
        //                    weakSelf.supportLabel.text = [NSString stringWithFormat:@"%d", ++a];
        //                }
        //                if (weakSelf.likeBlock) {
        //                    if (!weakSelf.islike) {
        //                        weakSelf.islike = NO;
        //                    }
        //                    weakSelf.likeBlock(weakSelf.supportLabel.text.integerValue, weakSelf.islike, type);
        //                }
        ////                weakSelf.supportLabel.text = [NSString stringWithFormat:@"%ld", (long)likeArr.like_num];
        //            } failure:^(XMError *error) {
        //
        //            }];
        //
        //            }
        //
        //        };
    }
    return _supprotBtn;
}

-(CommandButton *)supportBackBtn {
    if (!_supportBackBtn) {
        _supportBackBtn = [[CommandButton alloc] init];
    }
    WEAKSELF;
    _supportBackBtn.handleClickBlock = ^(CommandButton *sender) {
        
        BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
            
        }];
        if (!isLoggedIn) {
            return;
        }
        
        NSNumber *type = weakSelf.dict[@"type"];
        if (type.integerValue == 1) {
            [MobClick event:@"click_want_from_detail"];
            if (weakSelf.islike) {
                [GoodsSingletonCommand unlikeGoods:[NSString stringWithFormat:@"%@", weakSelf.post_id]];
                [weakSelf.supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_N"] forState:UIControlStateNormal];
                weakSelf.islike = !weakSelf.islike;
                NSString *str = weakSelf.supportLabel.text;
                int a = str.intValue;
                weakSelf.supportLabel.text = [NSString stringWithFormat:@"%d", --a];
            } else {
                [GoodsSingletonCommand likeGoods:[NSString stringWithFormat:@"%@", weakSelf.post_id]];
                [weakSelf.supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_H"] forState:UIControlStateNormal];
                weakSelf.islike = !weakSelf.islike;
                NSString *str = weakSelf.supportLabel.text;
                int a = str.intValue;
                weakSelf.supportLabel.text = [NSString stringWithFormat:@"%d", ++a];
            }
            if (weakSelf.likeBlock) {
                
                //                    if (![Session sharedInstance].isLoggedIn) {
                //                        return ;
                //                    }
                
                if (!weakSelf.islike) {
                    weakSelf.islike = NO;
                }
                weakSelf.likeBlock(weakSelf.supportLabel.text.integerValue, weakSelf.islike, type, weakSelf.post_id);
            }
            
        } else {
            [ForumService post:weakSelf.post_id.integerValue like:!@(weakSelf.islike).integerValue completion:^(ForumTopicIsLike *likeArr) {
                if (weakSelf.islike) {
                    [weakSelf.supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_N"] forState:UIControlStateNormal];
                    weakSelf.islike = !weakSelf.islike;
                    NSString *str = weakSelf.supportLabel.text;
                    int a = str.intValue;
                    weakSelf.supportLabel.text = [NSString stringWithFormat:@"%d", --a];
                } else {
                    [weakSelf.supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_H"] forState:UIControlStateNormal];
                    weakSelf.islike = !weakSelf.islike;
                    NSString *str = weakSelf.supportLabel.text;
                    int a = str.intValue;
                    weakSelf.supportLabel.text = [NSString stringWithFormat:@"%d", ++a];
                }
                if (weakSelf.likeBlock) {
                    if (!weakSelf.islike) {
                        weakSelf.islike = NO;
                    }
                    weakSelf.likeBlock(weakSelf.supportLabel.text.integerValue, weakSelf.islike, type, weakSelf.post_id);
                }
                //                weakSelf.supportLabel.text = [NSString stringWithFormat:@"%ld", (long)likeArr.like_num];
            } failure:^(XMError *error) {
                
            }];
            
        }
        
    };
    return _supportBackBtn;
}

-(UILabel *)supportLabel{
    if (!_supportLabel) {
        _supportLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _supportLabel.text = @"800";
        _supportLabel.font = [UIFont systemFontOfSize:14];
        _supportLabel.textColor = [UIColor grayColor];
    }
    return _supportLabel;
}


- (void)followTapAction
{
    
    if (self.isFollow) {
        [UserSingletonCommand unfollowUser:self.user_id.integerValue];
        if (![[Session sharedInstance].token isNotEmptyCtg]) {
            return;
        }
        NSDictionary *data = @{@"goodsId":self.post_id, @"sellerUserId":self.user_id, @"isFollow":@0};
        if (self.isChosen == 1) {
            [ClientReportObject clientReportObjectWithViewCode:HomeChosenMineAttentionViewCode regionCode:HomeChosenAttentionRegionCode referPageCode:NoReferPageCode andData:data];
        } else {
            [ClientReportObject clientReportObjectWithViewCode:HomeChosenViewCode regionCode:HomeChosenAttentionRegionCode referPageCode:NoReferPageCode andData:data];
        }
        self.isFollow = !self.isFollow;
        self.followButton.image = [UIImage imageNamed:@"pay-N"];
    } else {
        [UserSingletonCommand followUser:self.user_id.integerValue];
        if (![[Session sharedInstance].token isNotEmptyCtg]) {
            return;
        }
        NSDictionary *data = @{@"goodsId":self.post_id, @"sellerUserId":self.user_id, @"isFollow":@1};
        if (self.isChosen == 1) {
            [ClientReportObject clientReportObjectWithViewCode:HomeChosenMineAttentionViewCode regionCode:HomeChosenAttentionRegionCode referPageCode:NoReferPageCode andData:data];
        } else {
            [ClientReportObject clientReportObjectWithViewCode:HomeChosenViewCode regionCode:HomeChosenAttentionRegionCode referPageCode:NoReferPageCode andData:data];
        }
        self.isFollow = !self.isFollow;
        self.followButton.image = [UIImage imageNamed:@"pay-S"];
    }
    
    
}

- (void)avatarTapAction
{
    NSNumber *type = [_dict objectForKey:@"type"];
    if (self.avatarBlock) {
        self.avatarBlock(type, _user_id);
    }
}


- (void)TagTapAction
{
    NSNumber *type = [_dict objectForKey:@"type"];
    if (self.tagBlock) {
        self.tagBlock(type, _topic_id);
    }
}

- (void)tagTapTouchAction:(UIGestureRecognizer *)sender
{
    NSNumber *type = [_dict objectForKey:@"type"];
    UILabel *label = (UILabel *)sender.view;
    if (self.strBlock) {
        self.strBlock(type,label.text);
    }
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [CoordinatingController sharedInstance].shareChannel = ^(NSInteger shareData){
            NSDictionary *data = @{@"channel":[NSNumber numberWithInteger:shareData], @"goodsId":self.post_id, @"shareUrl":self.shareUrl};
            if (self.isChosen == 1) {
                [ClientReportObject clientReportObjectWithViewCode:HomeChosenMineAttentionViewCode regionCode:HomeChosenShareRegionCode referPageCode:NoReferPageCode andData:data];
            } else {
                [ClientReportObject clientReportObjectWithViewCode:HomeChosenViewCode regionCode:HomeChosenShareRegionCode referPageCode:NoReferPageCode andData:data];
            }
            
        };
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.userAvatar = [[UIImageView alloc] initWithFrame:CGRectMake(15, 17, 40, 40)];
        [self.contentView addSubview:_userAvatar];
        _userAvatar.layer.cornerRadius = 20;
        _userAvatar.layer.masksToBounds = YES;
        _userAvatar.userInteractionEnabled = YES;
        UITapGestureRecognizer *avatarTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapAction)];
        [_userAvatar addGestureRecognizer:avatarTap];
        self.userName = [[UILabel alloc] initWithFrame:CGRectMake(65, 18, kScreenWidth - 145, 19)];
        [self.contentView addSubview:_userName];
        _userName.font = [UIFont boldSystemFontOfSize:17];
        _userName.textColor = [UIColor colorWithHexString:@"3e3a39"];
        
        self.goodsInfo = [[UILabel alloc] initWithFrame:CGRectMake(65, 40, 40, 18)];
        [self.contentView addSubview:_goodsInfo];
        _goodsInfo.textColor = [UIColor colorWithHexString:@"231815"];
        _goodsInfo.font = [UIFont systemFontOfSize:15];
        
        self.goodsName = [[UILabel alloc] initWithFrame:CGRectMake(107, 40, kScreenWidth - 110 - 60, 18)];
        [self.contentView addSubview:_goodsName];
        _goodsName.textColor = [UIColor colorWithHexString:@"3e3a39"];
        _goodsName.font = [UIFont systemFontOfSize:15];
        
        self.followButton = [[UIImageView alloc] init];
        self.followButton.image = [UIImage imageNamed:@"pay-N"];
        self.followButton.layer.cornerRadius = 7;
        _followButton.userInteractionEnabled = YES;
        UITapGestureRecognizer *followTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followTapAction)];
        [_followButton addGestureRecognizer:followTap];
        [self.contentView addSubview:_followButton];
        
        self.gallary = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 72, kScreenWidth, floor(kScreenWidth / 3-2))];
        [self.contentView addSubview:_gallary];
        
        self.tag1 = [[UILabel alloc] init]; self.tag1.font = [UIFont boldSystemFontOfSize:17];
        self.tag1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tagTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(TagTapAction)];
        [self.tag1 addGestureRecognizer:tagTap];
        [self.contentView addSubview:_tag1]; self.tag1.textColor = [UIColor colorWithHexString:@"c2a79d"];
        self.tag2 = [[UILabel alloc] init]; [self.contentView addSubview:_tag2];
        
        _tag2.textColor = [UIColor colorWithHexString:@"9fa0a0"];
        self.tag2.font = [UIFont systemFontOfSize:14];
        _tag2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tag2Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagTapTouchAction:)];
        [_tag2 addGestureRecognizer:tag2Tap];
        UITapGestureRecognizer *tag3Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagTapTouchAction:)];
        UITapGestureRecognizer *tag4Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagTapTouchAction:)];
        UITapGestureRecognizer *tag5Tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagTapTouchAction:)];
        self.tag3 = [[UILabel alloc] init]; [self.contentView addSubview:_tag3];
        _tag3.userInteractionEnabled = YES; [_tag3 addGestureRecognizer:tag3Tap];
        _tag3.textColor = [UIColor colorWithHexString:@"9fa0a0"];self.tag3.font = [UIFont systemFontOfSize:14];
        self.tag4 = [[UILabel alloc] init]; [self.contentView addSubview:_tag4];
        _tag4.userInteractionEnabled = YES; [_tag4 addGestureRecognizer:tag4Tap];
        _tag4.textColor = [UIColor colorWithHexString:@"9fa0a0"];self.tag4.font = [UIFont systemFontOfSize:14];
        self.tag5 = [[UILabel alloc] init]; [self.contentView addSubview:_tag5];
        _tag5.userInteractionEnabled = YES; [_tag5 addGestureRecognizer:tag5Tap];
        _tag5.textColor = [UIColor colorWithHexString:@"9fa0a0"];self.tag5.font = [UIFont systemFontOfSize:14];
        //        _tag2.tag = 10001;_tag3.tag = 10002;_tag4.tag = 10003;_tag5.tag = 10004;
        self.summary = [[UILabel alloc] initWithFrame:CGRectZero];
        _summary.numberOfLines = 0;
        _summary.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_summary];
        _summary.textColor = [UIColor colorWithHexString:@"3a3a39"];
        
        self.reply1 = [[UIButton alloc] init];
        [_reply1 setTitleColor:[UIColor colorWithHexString:@"3a3a39"] forState:UIControlStateNormal];
        _reply1.titleLabel.font = [UIFont systemFontOfSize:14];
        _reply1.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:self.reply1];
        _reply1.userInteractionEnabled = NO;
        self.reply2 = [[UIButton alloc] init];
        [_reply2 setTitleColor:[UIColor colorWithHexString:@"3a3a39"] forState:UIControlStateNormal];
        _reply2.titleLabel.font = [UIFont systemFontOfSize:14];
        _reply2.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:self.reply2];
        _reply2.userInteractionEnabled = NO;
        self.reply3 = [[UIButton alloc] init];
        _reply3.titleLabel.font = [UIFont systemFontOfSize:14];
        [_reply3 setTitleColor:[UIColor colorWithHexString:@"3a3a39"] forState:UIControlStateNormal];
        _reply3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:_reply3];
        _reply3.userInteractionEnabled = YES;
        self.lineLayer = [[CALayer alloc] init];
        self.lineLayer.backgroundColor = [UIColor colorWithHexString:@"dcdddd"].CGColor;
        [self.contentView.layer addSublayer:_lineLayer];
        
        self.container = [[UIView alloc] init];
        [self.contentView addSubview:_container];
        [self.contentView addSubview:self.moreButton];
        [self.container addSubview:self.shareBtn];
        [self.container addSubview:self.replyLabel];
        [self.container addSubview:self.replyBtn];
        [self.container addSubview:self.supprotBtn];
        [self.container addSubview:self.supportLabel];
        _shareBtn.frame = CGRectMake(kScreenWidth - 30, 0, 15, 15);
        self.shareBackBtn.frame = CGRectMake(kScreenWidth - 40, -10, 35, 35);
        //        self.shareBackBtn.backgroundColor = [UIColor redColor];
        [self.container addSubview:self.shareBackBtn];
        
        _replyLabel.frame = CGRectMake(kScreenWidth - 20 - 35 - 5, 0, 45, 15);
        _replyBtn.frame = CGRectMake(kScreenWidth - 60 - 20, 0, 15, 15);
        self.replyBackBtn.frame = CGRectMake(kScreenWidth - 85, -10, 35, 35);
        //        self.replyBackBtn.backgroundColor = [UIColor redColor];
        [self.container addSubview:self.replyBackBtn];
        
        _supportLabel.frame = CGRectMake(kScreenWidth - 55 - 45 -5, 0, 45, 15);
        _supprotBtn.frame = CGRectMake(kScreenWidth - 105 - 20, 0, 15, 15);
        self.supportBackBtn.frame = CGRectMake(kScreenWidth - 130, -10, 35, 35);
        //        self.supportBackBtn.backgroundColor = [UIColor redColor];
        [self.container addSubview:self.supportBackBtn];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    NSNumber *type = _dict[@"type"];
    if (type == nil) {
        return;
    }
    NSString *tag1;
    NSString *summary;
    NSArray *gallary;
    NSArray *promise_tags;
    NSArray *goods_commentList;
    if (type.integerValue == 1) {
        _goodsInfo.hidden = NO;
        CGRect nameRect = [_goodsInfo.text boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
        _goodsInfo.frame = CGRectMake(65, 40, nameRect.size.width, 18);
        _goodsName.frame = CGRectMake(110 + nameRect.size.width - 40, 40, kScreenWidth - 110 - 60, 18);
        NSDictionary *goods_info = [_dict dictionaryValueForKey:@"goods_info"];
        goods_commentList = [_dict arrayValueForKey:@"goods_commentList"];
        promise_tags = [_dict arrayValueForKey:@"tag_list"];
        tag1 = [NSString stringWithFormat:@"￥%@", goods_info[@"shop_price"]];
        gallary =[_dict arrayValueForKey:@"gallary"];
        summary = [goods_info stringValueForKey:@"summary"];
        
    } else {
        _goodsInfo.hidden = YES;
        _goodsName.frame = CGRectMake(65, 40, kScreenWidth - 110 - 60, 18);
        ForumPostVO *post = [[ForumPostVO alloc] initWithJSONDictionary:_dict];
        tag1 = post.topic_name;
        gallary = post.attachments;
        summary = post.content;
        promise_tags = post.forum_tag;
        goods_commentList = post.topReplies;
    }
    self.followButton.frame = CGRectMake(kScreenWidth - 15 - 43, 25, 45, 18);
    
    CGFloat topHight = 72;
    if (gallary.count != 0) {
        topHight = topHight + _gallary.frame.size.height;
    }
    
    CGRect rect = [tag1 boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18]} context:nil];
    _tag1.frame = CGRectMake(17, topHight + 15, rect.size.width, 20);
    NSArray *tags;
    if ([promise_tags isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)promise_tags;
        NSData *data = [str JSONData];
        tags = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    } else {
        tags = promise_tags;
    }
    for (int i = 0; i < tags.count; i++) {
        NSDictionary *dic = promise_tags[i];
        NSString *str = dic[@"tag_name"];
        CGRect rect = [str boundingRectWithSize:CGSizeMake(1000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:17]} context:nil];
        CGFloat width = rect.size.width;
        if (i == 0) {
            _tag2.frame = CGRectMake(17 +  3+_tag1.frame.size.width, topHight + 15, width, 20);
        } else if(i == 1) {
            _tag3.frame = CGRectMake(17 + 3 * 2 +_tag1.frame.size.width+ _tag2.frame.size.width, topHight + 15, width, 20);
        } else if (i == 2) {
            _tag4.frame =  CGRectMake(17 + 3 * 3+_tag1.frame.size.width+ _tag2.frame.size.width + _tag3.frame.size.width, topHight + 15, width, 20);
        } else if (i == 3) {
            _tag5.frame =  CGRectMake(17 + 3 * 4+_tag1.frame.size.width+ _tag2.frame.size.width + _tag3.frame.size.width + _tag4.frame.size.width, topHight + 15, width, 20);
        }
    }
    
    
    CGFloat blockHight = topHight + 45;
    CGRect summaryRect = CGRectZero;
    if ([summary isNotEmptyCtg]) {
        blockHight = blockHight + 15;
        summaryRect  = [summary boundingRectWithSize:CGSizeMake(kScreenWidth - 100, 100000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
    }
    
    _summary.frame = CGRectMake(17, topHight + 45, kScreenWidth - 65, summaryRect.size.height);
    _reply1.frame = CGRectMake(17, blockHight + summaryRect.size.height, kScreenWidth - 40, 18);
    _reply2.frame = CGRectMake(17, blockHight + 23 +summaryRect.size.height, kScreenWidth - 40, 18);
    _reply3.frame = CGRectMake(17, blockHight + 46 +summaryRect.size.height, kScreenWidth - 40, 18);
    _moreButton.frame = CGRectMake(17, blockHight + 69 +summaryRect.size.height, kScreenWidth - 40, 18);
    CGFloat height = blockHight + 23 * goods_commentList.count + 8 + summaryRect.size.height;
    if (goods_commentList.count > 3) {
        height = height + 23;
    }
    _container.frame = CGRectMake(0, height, kScreenWidth, 15);
    _lineLayer.frame = CGRectMake(0, height + 30, kScreenWidth, 6);
    
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    WEAKSELF;
    self.dict = dict;
    NSNumber *type = dict[@"type"];
    _tag2.hidden = YES;_tag3.hidden = YES;_tag4.hidden = YES;_tag5.hidden = YES;
    _reply1.hidden = YES; _reply2.hidden = YES; _reply3.hidden = YES;
    
    NSDictionary *goods_info;
    NSDictionary *seller_info;
    NSDictionary *grade_tag;
    NSArray *promise_tags;
    NSArray *gallary;
    NSArray *goods_commentList;
    NSNumber *user_id;
    NSString *avatar_url;
    NSNumber *isFans;
    //    NSInteger reply_num;
    if (type.intValue == 1) {
        NSString *goods_SN = goods_info[@"goods_id"];
        self.goodsId = goods_SN;
        goods_info = [dict dictionaryValueForKey:@"goods_info"];
        seller_info = [goods_info dictionaryValueForKey:@"seller_info"];
        grade_tag = [goods_info dictionaryValueForKey:@"grade_tag"];
        promise_tags = [dict arrayValueForKey:@"tag_list"];
        gallary = [dict arrayValueForKey:@"gallary"];
        goods_commentList = [dict arrayValueForKey:@"goods_commentList"];
        user_id = seller_info[@"user_id"];
        avatar_url = seller_info[@"avatar_url"];
        //        reply_num = seller_info[@"reply_num"];
        self.avatarurl = avatar_url;
        isFans = seller_info[@"isfollowing"];
        self.user_id = seller_info[@"user_id"];
        self.post_id = goods_info[@"goods_id"];
        NSNumber *islike = goods_info[@"is_liked"];
        self.islike = islike.boolValue;
        [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:avatar_url] placeholderImage:[UIImage imageNamed:@"placeholder_mine"]];
        self.userName.text = [seller_info stringValueForKey:@"username"];
        self.goodsInfo.text = [grade_tag stringValueForKey:@"value"];
        self.goodsInfo.hidden = NO;
        self.goodsName.text = [goods_info stringValueForKey:@"goods_name"];
        _tag1.text = [NSString stringWithFormat:@"￥%@", [goods_info objectForKey:@"shop_price"]];
        self.summary.text =[goods_info stringValueForKey:@"summary"];
        NSArray *likeUser = [goods_info arrayValueForKey:@"liked_users"];
        _supportLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)likeUser.count];
        _replyLabel.text = [NSString stringWithFormat:@"%@", dict[@"comment_count"]];
        
    } else {
        ForumPostVO *post = [[ForumPostVO alloc] initWithJSONDictionary:dict];
        [self.userAvatar sd_setImageWithURL:[NSURL URLWithString:post.avatar] placeholderImage:[UIImage imageNamed:@"placeholder_mine"]];
        self.avatarurl = post.avatar;
        user_id = @(post.user_id);
        self.user_id = user_id;
        self.islike = post.is_like;
        self.post_id = @(post.post_id);
        self.userName.text = post.username;
        self.goodsInfo.hidden = YES;
        self.goodsName.text = post.content;
        gallary = post.attachments;
        isFans = @(post.is_following);
        promise_tags = post.forum_tag;
        _tag1.text = post.topic_name;
        self.topic_id = @(post.topic_id);
        _summary.text = post.content;
        goods_commentList = post.topReplies;
        _supportLabel.text = [NSString stringWithFormat:@"%ld",(long)post.like_num];
        _replyLabel.text = [NSString stringWithFormat:@"%ld", post.reply_num];
    }
    self.gallaryData = [NSMutableArray array];
    self.shareContent = self.summary.text;
    self.isFollow = isFans.boolValue;
    if ([Session sharedInstance].currentUserId== user_id.integerValue) {
        self.followButton.hidden = YES;
    } else {
        self.followButton.hidden = NO;
        
        if (isFans.integerValue != 0) {
            //                [self.followButton setBackgroundImage:[UIImage imageNamed:@"pay-S"] forState:UIControlStateNormal];
            _followButton.image = [UIImage imageNamed:@"pay-S"];
        } else {
            _followButton.image = [UIImage imageNamed:@"pay-N"];
        }
    }
    if (_gallary.subviews.count != 0) {
        [_gallary.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (gallary.count == 0) {
        _gallary.hidden = YES;
    } else if(type.integerValue == 1&& gallary.count == 1){
        _gallary.frame = CGRectMake(45, 72, floor(kScreenWidth / 3-2) * 1.5, floor(kScreenWidth / 3-2) * 1.5);
        NSDictionary *dic = gallary[0];
        XMWebImageView *image = [[XMWebImageView alloc] initWithFrame:CGRectMake(0 * floor(kScreenWidth / 3-2) + (0) * 3, 0, floor(kScreenWidth / 3-2) * 1.5, floor(kScreenWidth / 3-2) * 1.5)];
        //        image.i  = 0;
        image.userInteractionEnabled = YES;
        image.tag = 0;
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapAction:)];
        //        [image addGestureRecognizer:tap];
        NSString *str;
        if (type.integerValue == 2) {
            ForumAttachmentVO *attach = (ForumAttachmentVO *)dic;
            ForumAttachItemPicsVO *item = (ForumAttachItemPicsVO *)attach.item;
            str = item.pic_url;
        } else {
            str = dic[@"pic_url"];
        }
        //        image.url = str;
        [_gallaryData addObject:str];
        [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder_goods_640x640"]];
        [_gallary addSubview:image];
        [self.imageViewArr addObject:image];
        image.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
            NSString *goodsId = [[NSString alloc] init];
            if (type.intValue == 1) {
                goodsId = goods_info[@"goods_id"];
                NSDictionary *data = @{@"goodsId":goodsId};
                
                if (weakSelf.isChosen == 1) {
                    [ClientReportObject clientReportObjectWithViewCode:HomeChosenMineAttentionViewCode regionCode:HomeChosenPicRegionCode referPageCode:PicDetailReferPageCode andData:data];
                } else {
                    [ClientReportObject clientReportObjectWithViewCode:HomeChosenViewCode regionCode:HomeChosenPicRegionCode referPageCode:PicDetailReferPageCode andData:data];
                }
                
            }
            [weakSelf didClickViewPage:view imageViewImage:weakSelf.imageViewArr];
        };
    }  else if(type.integerValue == 2 && gallary.count == 1) {
        NSDictionary *dic = gallary[0];
        ForumAttachmentVO *attach = (ForumAttachmentVO *)dic;
        ForumAttachItemPicsVO *item = (ForumAttachItemPicsVO *)attach.item;
        if (item.width > floor(kScreenWidth / 3-2) * 2) {
            item.height = floor(kScreenWidth / 3-2) * 2 / item.width *item.height;
            item.width = floor(kScreenWidth / 3-2) * 2;
        }
        _gallary.frame = CGRectMake(45, 72, item.width, item.height);
        XMWebImageView *image = [[XMWebImageView alloc] initWithFrame:CGRectMake(0 * floor(kScreenWidth / 3-2) + (0) * 3, 0,item.width, item.height)];
        //        image.i  = 0;
        image.userInteractionEnabled = YES;
        image.tag = 0;
        //        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapAction:)];
        //        [image addGestureRecognizer:tap];
        NSString *str;
        if (type.integerValue == 2) {
            ForumAttachmentVO *attach = (ForumAttachmentVO *)dic;
            ForumAttachItemPicsVO *item = (ForumAttachItemPicsVO *)attach.item;
            str = item.pic_url;
        } else {
            str = dic[@"pic_url"];
        }
        //        image.url = str;
        [_gallaryData addObject:str];
        [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder_goods_640x640"]];
        [_gallary addSubview:image];
        [self.imageViewArr addObject:image];
        image.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
            NSString *goodsId = [[NSString alloc] init];
            if (type.intValue == 1) {
                goodsId = goods_info[@"goods_id"];
                NSDictionary *data = @{@"goodsId":goodsId};
                
                if (weakSelf.isChosen == 1) {
                    [ClientReportObject clientReportObjectWithViewCode:HomeChosenMineAttentionViewCode regionCode:HomeChosenPicRegionCode referPageCode:PicDetailReferPageCode andData:data];
                } else {
                    [ClientReportObject clientReportObjectWithViewCode:HomeChosenViewCode regionCode:HomeChosenPicRegionCode referPageCode:PicDetailReferPageCode andData:data];
                }
                
            }
            [weakSelf didClickViewPage:view imageViewImage:weakSelf.imageViewArr];
        };
    }else {
        _gallary.frame = CGRectMake(0, 72, kScreenWidth, floor(kScreenWidth / 3-2));
        _gallary.hidden = NO;
        _gallary.contentSize = CGSizeMake(gallary.count * floor(kScreenWidth / 3-2) + (gallary.count-1) * 3, floor(kScreenWidth / 3-2));
        for (int i = 0; i < gallary.count; i++) {
            NSDictionary *dic = gallary[i];
            
            /**********************************修改图片点击模式 2016.2.29 Feng**********************************/
            XMWebImageView *image = [[XMWebImageView alloc] initWithFrame:CGRectMake(i * floor(kScreenWidth / 3-2) + (i) * 3, 0, floor(kScreenWidth / 3-2), floor(kScreenWidth / 3-2))];
            
            //            image.i  = i;
            image.tag = i;
            image.userInteractionEnabled = YES;
            //            image.tag = 10000+i;
            //            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(ImageTapAction:)];
            //            [image addGestureRecognizer:tap];
            NSString *str;
            if (type.integerValue == 2) {
                ForumAttachmentVO *attach = (ForumAttachmentVO *)dic;
                ForumAttachItemPicsVO *item = (ForumAttachItemPicsVO *)attach.item;
                str = item.pic_url;
            } else {
                str = dic[@"pic_url"];
            }
            //            image.url = str;
            [_gallaryData addObject:str];
            [image setImageWithURL:str placeholderImage:[UIImage imageNamed:@"placeholder_goods_640x640"] XMWebImageScaleType:XMWebImageScale480x480];
            //            [image sd_setImageWithURL:[NSURL URLWithString:str] placeholderImage:[UIImage imageNamed:@"placeholder_goods_640x640"]];
            [_gallary addSubview:image];
            [self.imageViewArr addObject:image];
            
            image.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
                NSString *goodsId = [[NSString alloc] init];
                if (type.intValue == 1) {
                    goodsId = goods_info[@"goods_id"];
                    NSDictionary *data = @{@"goodsId":goodsId};
                    
                    if (weakSelf.isChosen == 1) {
                        [ClientReportObject clientReportObjectWithViewCode:HomeChosenMineAttentionViewCode regionCode:HomeChosenPicRegionCode referPageCode:PicDetailReferPageCode andData:data];
                    } else {
                        [ClientReportObject clientReportObjectWithViewCode:HomeChosenViewCode regionCode:HomeChosenPicRegionCode referPageCode:PicDetailReferPageCode andData:data];
                    }
                    
                }
                [weakSelf didClickViewPage:view imageViewImage:weakSelf.imageViewArr];
            };
        }
        /****************************************************************************************/
    }
    
    NSArray *tags;
    if ([promise_tags isKindOfClass:[NSString class]]) {
        NSString *str = (NSString *)promise_tags;
        NSData *data = [str JSONData];
        tags = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    } else {
        tags = promise_tags;
    }
    for (int i = 0; i < tags.count; i++) {
        NSDictionary *dic = promise_tags[i];
        if (i == 0) {
            _tag2.text = dic[@"tag_name"];_tag2.hidden = NO;
        } else if(i == 1) {
            _tag3.text = dic[@"tag_name"];_tag3.hidden = NO;
        } else if (i == 2) {
            _tag4.text = dic[@"tag_name"];_tag4.hidden = NO;
        } else if (i == 3) {
            _tag5.text = dic[@"tag_name"];_tag5.hidden = NO;
        }
    }
    if (goods_commentList.count > 3) {
        _moreButton.hidden = NO;
    } else {
        _moreButton.hidden = YES;
    }
    
    if (goods_commentList.count == 0) {
        
    } else {
        for (int i = 0; i < goods_commentList.count; i++) {
            id dic = goods_commentList[i];
            NSString *username;
            NSString *content;
            if ([dic isKindOfClass:[ForumPostReplyVO class]]) {
                ForumPostReplyVO *dic1 = (ForumPostReplyVO *)dic;
                username = dic1.username;
                content = dic1.content;
            } else {
                username = dic[@"username"];
                content = dic[@"content"];
            }
            NSString *str = [NSString stringWithFormat:@"%@ : %@",username, content];
            if (i == 0) {
                [_reply1 setTitle:str forState:UIControlStateNormal];_reply1.hidden = NO;
            }
            if (i == 1) {
                [_reply2 setTitle:str forState:UIControlStateNormal];_reply2.hidden = NO;
            }
            if (i == 2) {
                [_reply3 setTitle:str forState:UIControlStateNormal];_reply3.hidden = NO;
            }
        }
    }
    
    if (_islike) {
        [_supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_H"] forState:UIControlStateNormal];
    } else {
        [_supprotBtn setBackgroundImage:[UIImage imageNamed:@"supprot_N"] forState:UIControlStateNormal];
    }
    
    
    [self setNeedsLayout];
}

- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    [_scrollImageView setCurrentPage:index];
}

-(void)didClickViewPage:(UIImageView *)imageView imageViewImage:(NSArray *)imageViewArray
{
    // 1.封装图片数据
    //    NSMutableArray *imageViewArray = [NSMutableArray arrayWithObject:XMImageView];
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.gallaryData count]];
    for (NSInteger i=0;i< [self.gallaryData count];i++) {
        
        //        MainPic *item = (MainPic*)[self.gallaryItems objectAtIndex:i];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.photoDescription = self.summary.text;
        NSString *QNDownloadUrl = nil;
        
        //修改图片大小防止出现重叠  2016.5.17 Feng
        QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:self.gallaryData[i] isWebP:NO scaleType:XMWebImageScale480x480];
        
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
        browser.currentPhotoIndex = imageView.tag; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        browser.delegate = self;
        [browser show];
    }
}


//修改图片点击模式  2016.2.29 Feng
//- (void)ImageTapAction:(UIGestureRecognizer *)sender
//{
//    XMWebImageView *view = (XMWebImageView *)sender.view;
//    [self didClickViewPage:view imageViewImage:self.imageViewArr];
//    WEAKSELF;
//    XMWebImageView *view = (XMWebImageView *)sender.view;
//    self.block(view.tag, weakSelf.gallaryData, view);
//}


@end

@implementation TapImageView



@end

@implementation SideSlipRedirectInfoView {
    UIView *_titleBgView;
    UILabel *_titleLbl;
    XMWebImageView *_imageView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _imageView.backgroundColor = [UIColor clearColor];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        _titleBgView = [[UIView alloc] initWithFrame:CGRectZero];
        _titleBgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4f];
        [self addSubview:_titleBgView];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.backgroundColor = [UIColor clearColor];
        //title颜色修改  白色修改为黑色  2016.1.7  Feng
        //title颜色修改  黑色改为白色    2016.4.28 Feng
        _titleLbl.textColor = [UIColor whiteColor];
        _titleLbl.font = [UIFont systemFontOfSize:11.f];
        _titleLbl.numberOfLines = 1;
        _titleLbl.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLbl];
        
        WEAKSELF;
        self.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            if (weakSelf.redirectInfo) {
                [[Session sharedInstance] clientReport:weakSelf.redirectInfo data:nil];
            }
            [URLScheme locateWithRedirectUri:weakSelf.redirectUri andIsShare:NO];
        };
    }
    return self;
}

#warning mark ------------------------------------------------------可能会再次修改位置----------------------------------------------------
- (void)layoutSubviews {
    [super layoutSubviews];
    
    _imageView.frame = self.bounds;
    _titleBgView.frame = CGRectMake(0, self.height-21, self.width, 21);
    _titleLbl.frame = CGRectMake(0, self.height - 21, self.width, 21);
}

- (void)prepareForReuse {
    _imageView.image = nil;
}

- (void)updateWithRedirectInfo:(RedirectInfo*)redirectInfo imageSize:(CGSize)imageSize
{
    NSString *title =  redirectInfo.title&&[redirectInfo.title length]>0?redirectInfo.title:@"";
    if ([title length]>0) {
        _titleBgView.hidden = NO;
        _titleLbl.hidden = NO;
    } else {
        _titleBgView.hidden = YES;
        _titleLbl.hidden = YES;
    }
    if ([redirectInfo isNewComposition]) {
        _titleBgView.hidden = YES;
        _titleLbl.hidden = YES;
    } else {
        if (redirectInfo.width < kScreenWidth/2) {
            _titleBgView.hidden = YES;
            _titleLbl.hidden = YES;
        } else {
            _titleBgView.hidden = NO;
            _titleLbl.hidden = NO;
        }
    }
    _titleLbl.text = title;
    
    [_imageView setImageWithURL:redirectInfo.imageUrl placeholderImage:nil size:imageSize progressBlock:nil succeedBlock:nil failedBlock:nil];
    
    _redirectUri = redirectInfo.redirectUri;
    self.redirectInfo = redirectInfo;
    [self setNeedsLayout];
}

@end


@interface RecommendDayNewCell () <SDCycleScrollViewDelegate>

@property(nonatomic,strong) NSArray *redirectInfoList;
//@property (nonatomic, strong) XMWebImageView *bgImageView;
@property (nonatomic, strong) UILabel *dayLbl;
@property (nonatomic, strong) UILabel *dayNewNumLbl;
@property (nonatomic, strong) UILabel *dayLastLbl;

@end

@implementation RecommendDayNewCell{
    SDCycleScrollView *cycleScrollView;
}

-(UILabel *)dayLastLbl{
    if (!_dayLastLbl) {
        _dayLastLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dayLastLbl.font = [UIFont systemFontOfSize:15.f];
        _dayLastLbl.textColor = [UIColor colorWithHexString:@"3c3a38"];
        [_dayLastLbl sizeToFit];
        //        _dayLastLbl.text = @"/件商品";
    }
    return _dayLastLbl;
}

-(UILabel *)dayNewNumLbl{
    if (!_dayNewNumLbl) {
        _dayNewNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dayNewNumLbl.font = [UIFont boldSystemFontOfSize:34.f];
        _dayNewNumLbl.textColor = [UIColor colorWithHexString:@"3c3a38"];
        [_dayNewNumLbl sizeToFit];
    }
    return _dayNewNumLbl;
}

-(UILabel *)dayLbl{
    if (!_dayLbl) {
        _dayLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _dayLbl.font = [UIFont systemFontOfSize:15.f];
        _dayLbl.textColor = [UIColor colorWithHexString:@"3c3a38"];
        [_dayLbl sizeToFit];
        //        _dayLbl.text = @"今日上新";
    }
    return _dayLbl;
}

//-(XMWebImageView *)bgImageView{
//    if (!_bgImageView) {
//        _bgImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
//        _bgImageView.backgroundColor = [UIColor orangeColor];
//    }
//    return _bgImageView;
//}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendDayNewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = kScreenWidth*75.f/320.f;
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        RedirectInfo *info = recommendInfo.list[0];
        height = info.height;
    }
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlWithe"];
        cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlAlpha"];
        cycleScrollView.autoScrollTimeInterval = 4;
        cycleScrollView.infiniteLoop = NO;
        cycleScrollView.showPageControl = NO;
        cycleScrollView.autoScroll = NO;
        [cycleScrollView getIsMain:NO];
        [self.contentView addSubview:cycleScrollView];
        //        [self.contentView addSubview:self.bgImageView];
        
        [self.contentView addSubview:self.dayLbl];
        [self.contentView addSubview:self.dayNewNumLbl];
        [self.contentView addSubview:self.dayLastLbl];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    cycleScrollView.frame = self.contentView.bounds;
    
    [self.dayLastLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cycleScrollView.mas_centerY).offset(3);
        make.right.equalTo(cycleScrollView.mas_right).offset(-40);
    }];
    
    [self.dayNewNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.dayLastLbl.mas_centerY).offset(-5);
        make.right.equalTo(self.dayLastLbl.mas_left).offset(-3);
    }];
    
    [self.dayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.dayLastLbl.mas_bottom);
        make.right.equalTo(self.dayNewNumLbl.mas_left).offset(-3);
    }];
    
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        _redirectInfoList = recommendInfo.list;
        NSMutableArray *imageUrlList = [[NSMutableArray alloc] init];
        for (int i = 0; i < recommendInfo.list.count; i++) {
            RedirectInfo *info = recommendInfo.list[i];
            [imageUrlList addObject:info.imageUrl];
            NSArray *strArr = [info.title componentsSeparatedByString:@"%s"];
            if (strArr.count == 2) {
                self.dayLbl.text = strArr[0];
                self.dayLastLbl.text = strArr[1];
                _dayNewNumLbl.text = [NSString stringWithFormat:@"%@",info.subTitle];
            }
        }
        cycleScrollView.imageURLStringsGroup = imageUrlList;
        
    }
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    if (index >=0 && index <[_redirectInfoList count]) {
        [MobClick event:@"click_banner_from_home"];
        RedirectInfo *redirectInfo = [_redirectInfoList objectAtIndex:index];
        
        //埋点
        if (redirectInfo) {
            [[Session sharedInstance] clientReport:redirectInfo data:nil];
        }
        
        [URLScheme locateWithRedirectUri:redirectInfo.redirectUri andIsShare:NO];
    }
}

@end

@interface RecommendFindGoodGoodsCell ()

@property (nonatomic, strong) GoodsCellTopView *topView;

@end

@implementation RecommendFindGoodGoodsCell

-(GoodsCellTopView *)topView{
    if (!_topView) {
        _topView = [[GoodsCellTopView alloc] initWithFrame:CGRectZero];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendFindGoodGoodsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    CGFloat height = kScreenWidth*120/320.f;
    if (recommendInfo.list.count > 0) {
        RedirectInfo *info = recommendInfo.list[0];
        height = info.width>0?(info.height*kScreenWidth/320+40)*recommendInfo.list.count:kScreenWidth*120/320.f*recommendInfo.list.count;
    }
    if (recommendInfo.moreInfo && recommendInfo.moreInfo.title && recommendInfo.moreInfo.title.length > 0) {
        height += kScreenWidth*66.f/320.f;
    }
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.topView];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*66.f/320.f);
    
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    for (FindGoodGoodsView *goodsView in self.contentView.subviews) {
        if (goodsView.tag == 2017361209) {
            [goodsView removeFromSuperview];
        }
    }
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    if (recommendInfo && [recommendInfo isKindOfClass:[RecommendInfo class]]
        && [recommendInfo.list count]>0) {
        CGFloat margin = 0;
        if (recommendInfo.moreInfo && recommendInfo.moreInfo.title && recommendInfo.moreInfo.title.length > 0) {
            margin = kScreenWidth*66.f/320.f;//86.f
            self.topView.hidden = NO;
            [self.topView getRecommendInfo:recommendInfo];
        } else {
            margin = 0;
            self.topView.hidden = YES;
        }
        for (int i = 0; i < recommendInfo.list.count; i++) {
            RedirectInfo *info = recommendInfo.list[i];
            FindGoodGoodsView *findGoodsView = [[FindGoodGoodsView alloc] initWithFrame:CGRectMake(0, margin, kScreenWidth, info.width>0?info.height*kScreenWidth/320+40:120)];
            [findGoodsView getRedirectInfo:info];
            findGoodsView.tag = 2017361209;
            [self.contentView addSubview:findGoodsView];
            margin+=info.width>0?info.height*kScreenWidth/320+40:120;
            
            findGoodsView.touchFindGoodsView = ^(RedirectInfo *info){
                [URLScheme locateWithRedirectUri:info.redirectUri andIsShare:YES];
            };
        }
        
    }
}


@end

@interface RecommendTopViewCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subTitlelbl;
@property (nonatomic, strong) CommandButton *moreBtn;

@property (nonatomic, strong) UIView *lineView;
@end

@implementation RecommendTopViewCell

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}

-(CommandButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _moreBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_moreBtn setTitleColor:[DataSources colorf9384c] forState:UIControlStateNormal];
        [_moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [_moreBtn sizeToFit];
    }
    return _moreBtn;
}

-(UILabel *)subTitlelbl{
    if (!_subTitlelbl) {
        _subTitlelbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subTitlelbl.font = [UIFont systemFontOfSize:12.f];
        _subTitlelbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_subTitlelbl sizeToFit];
    }
    return _subTitlelbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont boldSystemFontOfSize:24.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"000000"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendTopViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = kScreenWidth*66.f/320.f;
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.subTitlelbl];
        [self.contentView addSubview:self.moreBtn];
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    
    [self.subTitlelbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(6);
        make.left.equalTo(self.titleLbl.mas_left);
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_top).offset(3);
        make.right.equalTo(self.contentView.mas_right).offset(-20);
    }];
    
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    self.titleLbl.text = recommendInfo.moreInfo.title;
    self.subTitlelbl.text = recommendInfo.moreInfo.subTitle;
    if (recommendInfo.moreInfo.redirectUri && recommendInfo.moreInfo.redirectUri.length>0) {
        self.moreBtn.hidden = NO;
    } else {
        self.moreBtn.hidden = YES;
    }
    
    self.moreBtn.handleClickBlock = ^(CommandButton *sender){
        [URLScheme locateWithRedirectUri:recommendInfo.moreInfo.redirectUri andIsShare:YES];
    };
}


@end


#import "LimitGoodsCollectionViewCell.h"
#import "GoodsDetailViewController.h"

static NSString *ID = @"LimitGoodsCollectionViewCell";
@interface RecommendLimitRushCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIView *leftLine;
@property (nonatomic, strong) UIView *rightLine;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *limitTime;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) NSTimer *mainTimer;
@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property (nonatomic, strong) RecommendInfo *recommendInfo;

@end


@implementation RecommendLimitRushCell

- (UIView *)leftLine{
    if (!_leftLine) {
        _leftLine = [[UIView alloc] init];
        _leftLine.backgroundColor = ([UIColor colorWithHexString:@"f2f2f2"]);
    }
    return _leftLine;
}

- (UIView *)rightLine{
    if (!_rightLine) {
        _rightLine = [[UIView alloc] init];
        _rightLine.backgroundColor = ([UIColor colorWithHexString:@"f2f2f2"]);
    }
    return _rightLine;
}

- (UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] init];
        _titleLbl.font = [UIFont boldSystemFontOfSize:18];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

- (UILabel *)limitTime{
    if (!_limitTime) {
        _limitTime = [[UILabel alloc] initWithFrame:CGRectNull];
        _limitTime.font = [UIFont systemFontOfSize:12];
        _limitTime.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_limitTime sizeToFit];
    }
    return _limitTime;
}


- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout;
        flowLayout = [[MFCollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 14;
        flowLayout.itemSize = CGSizeMake(kScreenWidth/375*287, 230.f*320.f/kScreenWidth-70);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.decelerationRate = 10;
        [_collectionView registerClass:[LimitGoodsCollectionViewCell class] forCellWithReuseIdentifier:ID];
        
    }
    return _collectionView;
}


+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecommendLimitRushCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 230.f*320.f/kScreenWidth;
    return height;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _dataSources = [[NSMutableArray alloc] init];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.rightLine];
        [self.contentView addSubview:self.leftLine];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.limitTime];
        [self.contentView addSubview:self.collectionView];
        
    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    RecommendInfo *recommendInfo = [dict objectForKey:[[self class] cellKeyForRecommendInfo]];
    _recommendInfo = recommendInfo;
    self.titleLbl.text = recommendInfo.title;
    
    GoodsInfo *goodsInfo = [recommendInfo.list firstObject];
    if (goodsInfo) {
        _goodsInfo = goodsInfo;
        
        // 防止刷新UI的时候创建多个定时器，导致多个定时器一起倒计时。
        if (!self.mainTimer) {
            [self startTimer];
        }
    }
    
    [_dataSources removeAllObjects];
    if (recommendInfo.list && recommendInfo.list.count > 0) {
        
        for (GoodsInfo * goodsInfo in recommendInfo.list) {
            [_dataSources addObject:goodsInfo];
        }
        [_collectionView reloadData];
    }
}


//倒计时
- (void)startTimer
{
    self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshLessTime) userInfo:@"" repeats:YES];
    
    //如果不添加下面这条语句，在UITableView拖动的时候，会阻塞定时器的调用
    [[NSRunLoop currentRunLoop] addTimer:self.mainTimer forMode:UITrackingRunLoopMode];
}

//刷新时间
- (void)refreshLessTime{
    
    NSInteger nowTimeTimestamp = [[self getNowTimeTimestamp] integerValue];
    if (_goodsInfo.activityBaseInfo.startTime > nowTimeTimestamp && nowTimeTimestamp < _goodsInfo.activityBaseInfo.endTime) {
        
        NSUInteger time = (_goodsInfo.activityBaseInfo.startTime - nowTimeTimestamp)/1000;
        
        NSInteger oldTime = 0;
        if (time == 0) {
            oldTime = 0;
            if (_recommendInfo.moreInfo.subTitle.length > 0) {
                _limitTime.text = _recommendInfo.moreInfo.subTitle;
            }
            [_mainTimer invalidate];
            _mainTimer = nil;
        }else {
            oldTime = --time;
        }
        NSString *str;
        str = [NSString stringWithFormat:@"%@",[self lessSecondToDay:oldTime]];
        
        self.limitTime.text = [self lessSecondToDay:oldTime];
        
    }
}

//根据秒数计算剩余时间：天，小时，分钟，秒
- (NSString *)lessSecondToDay:(NSUInteger)seconds
{
    NSUInteger day  = (NSUInteger)seconds/(24*3600);
    NSUInteger hour = (NSUInteger)(seconds%(24*3600))/3600;
    NSUInteger min  = (NSUInteger)(seconds%(3600))/60;
    NSUInteger second = (NSUInteger)(seconds%60);
    NSString *timeStr;
    if (seconds == 0) {
        
        if (_recommendInfo.moreInfo.subTitle.length > 0) {
            timeStr = _recommendInfo.moreInfo.subTitle;
        }
        
    }else {
        timeStr = [NSString stringWithFormat:@"还有%02zd天%02zd时%02zd分%02zd秒开抢",(unsigned long)day,(unsigned long)hour,(unsigned long)min,(unsigned long)second];
    }
    return timeStr;
}

//获取当前时间戳 （以毫秒为单位）
-(NSString *)getNowTimeTimestamp{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SSS"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate *datenow = [NSDate date];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]*1000];
    return timeSp;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataSources.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LimitGoodsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    GoodsInfo *goodsInfo = [_dataSources objectAtIndex:indexPath.row];
    if ([cell isKindOfClass:[LimitGoodsCollectionViewCell class]]) {
        ((LimitGoodsCollectionViewCell *)cell).handleBuyBtnBlock = ^(GoodsInfo *goodsInfo) {
            
            GoodsDetailViewControllerContainer *viewController = [[GoodsDetailViewControllerContainer alloc] init];
            viewController.goodsId = goodsInfo.goodsId;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        };
    }
    [cell getGoodsInfo:goodsInfo];
    return cell;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.leftLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(2);
        make.left.equalTo(self.contentView.mas_left).offset(50);
        make.right.equalTo(self.titleLbl.mas_left).offset(-30);
        make.height.equalTo(@1);
    }];
    
    [self.rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(2);
        make.right.equalTo(self.contentView.mas_right).offset(-50);
        make.left.equalTo(self.titleLbl.mas_right).offset(30);
        make.height.equalTo(@1);
    }];
    
    [self.limitTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(4);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.limitTime.mas_bottom).offset(5);
        make.left.and.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
}

- (void)dealloc{
  
    [_mainTimer invalidate];
    _mainTimer = nil;
}

@end
