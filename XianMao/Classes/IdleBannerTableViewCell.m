//
//  IdleBannerTableViewCell.m
//  XianMao
//
//  Created by WJH on 16/11/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "IdleBannerTableViewCell.h"
#import "SDCycleScrollView.h"
#import "RedirectInfo.h"
#import "URLScheme.h"

@interface IdleBannerTableViewCell()<SDCycleScrollViewDelegate>

@property (nonatomic, strong) SDCycleScrollView * cycleScrollView;
@property (nonatomic, strong) NSMutableArray * redirectInfoList;
@property (nonatomic, strong) RedirectInfo *redInfo;
@end

@implementation IdleBannerTableViewCell

-(NSMutableArray *)redirectInfoList{
    if (!_redirectInfoList) {
        _redirectInfoList = [[NSMutableArray alloc] init];
    }
    return _redirectInfoList;
}

-(SDCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, kScreenWidth, 180) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"pageControlWithe"];
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"pageControlAlpha"];
        _cycleScrollView.autoScrollTimeInterval = 4;
        [_cycleScrollView getIsMain:NO];
    }
    return _cycleScrollView;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.cycleScrollView];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([IdleBannerTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    RecommendVo * recommendInfo = [dict objectForKey:[IdleBannerTableViewCell cellKeyForIdleBanner]];
    
    CGFloat height = 0;
    CGFloat width = 0;
    CGFloat cellHeight = 0;
    if (recommendInfo && recommendInfo.list.count > 0) {
        RedirectInfo *redirectInfo = [RedirectInfo createWithDict:[recommendInfo.list objectAtIndex:0]];
        if (redirectInfo && [redirectInfo isKindOfClass:[RedirectInfo class]]) {
            height = redirectInfo.height;
            width = redirectInfo.width;
        }
    }
    if (height > 0 && width > 0) {
        cellHeight = kScreenWidth*height/width;
    } else {
        cellHeight = 0;
    }
    return cellHeight;
}

+ (NSString *)cellKeyForIdleBanner
{
    NSString * string = @"IdleBanner";
    return string;
}

+ (NSMutableDictionary*)buildCellDict:(RecommendVo *)recommendInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[IdleBannerTableViewCell class]];
    if (recommendInfo) {
        [dict setObject:recommendInfo forKey:[IdleBannerTableViewCell cellKeyForIdleBanner]];
    }
    return dict;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    RecommendVo * recommendInfo = [dict objectForKey:[IdleBannerTableViewCell cellKeyForIdleBanner]];
    
    NSMutableArray * imageUrl = [[NSMutableArray alloc] init];
    NSMutableArray *redUrl = [[NSMutableArray alloc] init];
    if (recommendInfo && recommendInfo.list.count > 0) {
        for (int i = 0; i < recommendInfo.list.count; i++) {
            [self.redirectInfoList addObject:[RedirectInfo createWithDict:[recommendInfo.list objectAtIndex:i]]];
        }
        for (int i = 0; i < recommendInfo.list.count; i++) {
            RedirectInfo * redirect = [RedirectInfo createWithDict:[recommendInfo.list objectAtIndex:i]];
            [imageUrl addObject:redirect.imageUrl];
            [redUrl addObject:redirect.redirectUri];
        }
        self.cycleScrollView.imageURLStringsGroup = imageUrl;
        self.cycleScrollView.redUrl = redUrl;
    }
    
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtUrl:(NSString *)imageUrl{
    [URLScheme locateWithRedirectUri:imageUrl andIsShare:YES];
}

//- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
//{
//    if (index >=0 && index <[_redirectInfoList count]) {
//        RedirectInfo *redirectInfo = [_redirectInfoList objectAtIndex:index];
//        [URLScheme locateWithRedirectUri:redirectInfo.redirectUri andIsShare:NO];
//    }
//}

@end
