//
//  SearchResultSellerTableViewCell.m
//  XianMao
//
//  Created by simon cai on 8/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "SearchResultSellerTableViewCell.h"
#import "GoodsTableViewCell.h"
#include "RecommendTableViewCell.h"

@implementation SearchResultSellerTableViewCell {
    GoodsSellerInfoView *_sellerInfoView;
    RedirectInfoView *_infoView0;
    RedirectInfoView *_infoView1;
    RedirectInfoView *_infoView2;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SearchResultSellerTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    SearchResultSellerItem* item = [dict objectForKey:[[self class] cellDictKeyForItem]];
    if ([item.redirectList count]>0) {
        CGFloat width = (kScreenWidth-30-20)/3;
        return 13+[GoodsSellerInfoView heightForOrientationPortrait]+23+width+13;
    } else {
        return 13+[GoodsSellerInfoView heightForOrientationPortrait]+13;
    }
}

+ (NSMutableDictionary*)buildCellDict:(SearchResultSellerItem*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SearchResultSellerTableViewCell class]];
    if (item)[dict setObject:item forKey:[self cellDictKeyForItem]];
    return dict;
}

+ (NSString*)cellDictKeyForItem {
    return @"item";
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
    if ([dict isKindOfClass:[NSDictionary class]]) {
        SearchResultSellerItem* item = [dict objectForKey:[[self class] cellDictKeyForItem]];
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

@end
