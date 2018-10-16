//
//  SellerInfoTableViewCell.m
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "SellerInfoTableViewCell.h"
#import "User.h"
#import "GoodsTableViewCell.h"

@implementation SellerInfoTableViewCell {
    GoodsSellerInfoView *_sellerInfoView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SellerInfoTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    return [GoodsSellerInfoView heightForOrientationPortrait]+30;
}

+ (NSMutableDictionary*)buildCellDict:(User*)sellerInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SellerInfoTableViewCell class]];
    if (sellerInfo)[dict setObject:sellerInfo forKey:[self cellDictKeyForSellerInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForSellerInfo {
    return @"sellerInfo";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _sellerInfoView = [[GoodsSellerInfoViewForGoodsDetail alloc] initWithFrame:CGRectNull];
        _sellerInfoView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_sellerInfoView];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    [_sellerInfoView prepareForReuse];
    _sellerInfoView.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _sellerInfoView.frame = CGRectMake(0, (self.contentView.height-[GoodsSellerInfoView heightForOrientationPortrait])/2, self.contentView.width, [GoodsSellerInfoView heightForOrientationPortrait]);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    if ([dict isKindOfClass:[NSDictionary class]]) {
        User* user = [dict objectForKey:[[self class] cellDictKeyForSellerInfo]];
        if ([user isKindOfClass:[User class]]) {
            [_sellerInfoView updateWithSellerInfo:user];
            [self setNeedsLayout];
        }
    }
}

@end

