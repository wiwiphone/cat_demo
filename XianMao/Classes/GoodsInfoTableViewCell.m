//
//  GoodsInfoTableViewCell.m
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "GoodsInfoTableViewCell.h"
#import "GoodsInfo.h"
#import "GoodsTableViewCell.h"

@interface GoodsInfoTableViewCell ()

@property(nonatomic,strong) UILabel *nameLbl;
@property(nonatomic,strong) UILabel *limitedPriceLbl;
@property(nonatomic,strong) GoodsPricesView *pricesView;
@property(nonatomic,strong) UILabel *summaryLbl;

@end

@implementation GoodsInfoTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsInfoTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    return 50;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)goodsInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsInfoTableViewCell class]];
    if (goodsInfo)[dict setObject:goodsInfo forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"goodsInfo";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    _likedUsersView.frame = self.contentView.bounds;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
//    if ([dict isKindOfClass:[NSDictionary class]]) {
//        NSString *goodsId = [dict stringValueForKey:[[self class] cellDictKeyForGoodsId]];
//        NSInteger totalNum = [dict integerValueForKey:[[self class] cellDictKeyForTotalNum]];
//        NSArray *likedUsers = [dict arrayValueForKey:[[self class] cellDictKeyForLikedUsers]];
//        [_likedUsersView updateWithLikedUsers:goodsId totalNum:totalNum likedUsers:likedUsers];
//        [self setNeedsLayout];
//    }
}


@end


