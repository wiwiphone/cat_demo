//
//  offeredGoodsInfoCell.m
//  XianMao
//
//  Created by 阿杜 on 16/3/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "offeredGoodsInfoCell.h"
#import "Masonry.h"
#import "RecoveryGoodsDetail.h"
#import "Session.h"

//
//#import "MJPhotoBrowser.h"
//#import "MJPhoto.h"
//#import "ASScroll.h"

@interface offeredGoodsInfoCell ()
@property (nonatomic, strong) UILabel *myPriceLB;
@property (nonatomic, strong) UILabel *didPriceCountLB;
@property (nonatomic, strong) UILabel *myPriceOrderLB;
@property (nonatomic, strong) UILabel *heightPriceLbl;

@end

@implementation offeredGoodsInfoCell

-(UILabel *)heightPriceLbl{
    if (!_heightPriceLbl) {
        _heightPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _heightPriceLbl.font = [UIFont systemFontOfSize:13.f];
        _heightPriceLbl.textColor = [UIColor colorWithHexString:@"727171"];
        [_heightPriceLbl sizeToFit];
    }
    return _heightPriceLbl;
}

- (UILabel *)myPriceLB {
    if (!_myPriceLB) {
        _myPriceLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _myPriceLB.font = [UIFont systemFontOfSize:13.f];
        _myPriceLB.textColor = [UIColor colorWithHexString:@"727171"];
        [_myPriceLB sizeToFit];
    }
    return _myPriceLB;
}

- (UILabel *)didPriceCountLB {
    if (!_didPriceCountLB) {
        _didPriceCountLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _didPriceCountLB.font = [UIFont systemFontOfSize:13.f];
        _didPriceCountLB.textColor = [UIColor colorWithHexString:@"727171"];
        [_didPriceCountLB sizeToFit];
    }
    return _didPriceCountLB;
}

- (UILabel *)myPriceOrderLB {
    if (!_myPriceOrderLB) {
        _myPriceOrderLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _myPriceOrderLB.font = [UIFont systemFontOfSize:13.f];
        _myPriceOrderLB.textColor = [UIColor colorWithHexString:@"727171"];
        [_myPriceOrderLB sizeToFit];
    }
    return _myPriceOrderLB;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([offeredGoodsInfoCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsDetail*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[offeredGoodsInfoCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 65;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"recoveryGoodsDetailVO";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.myPriceLB];
        [self.contentView addSubview:self.myPriceOrderLB];
        [self.contentView addSubview:self.didPriceCountLB];
        [self.contentView addSubview:self.heightPriceLbl];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.myPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.didPriceCountLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(13);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.myPriceOrderLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myPriceLB.mas_bottom).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.heightPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.didPriceCountLB.mas_bottom).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
}


- (void)updateCellWithDict:(RecoveryGoodsDetail *)recoveryGoodsDetailVO andDict:(NSDictionary *)dict{
    HighestBidVo *bid = [[HighestBidVo alloc] initWithJSONDictionary:dict[@"highestBidVo"]];
    NSLog(@"%.2f", bid.price);
    if (bid.price > 0) {
        self.heightPriceLbl.text = [NSString stringWithFormat:@"当前最高报价 %.2f元", bid.price];
    } else {
        self.heightPriceLbl.text = @"暂无报价";
    }
    self.didPriceCountLB.text = [NSString stringWithFormat:@"当前共有 %ld 次出价", recoveryGoodsDetailVO.total_bid_num];
    if (recoveryGoodsDetailVO.recoveryGoodsVo.sellerBasicInfo.user_id == [Session sharedInstance].currentUserId) {
        //如果是自己的商品则价格排位和出价数字不显示(显示空白)
    } else {
        self.myPriceOrderLB.text = [NSString stringWithFormat:@"您的出价排 %ld 位", recoveryGoodsDetailVO.highestBidVo.level];
        self.myPriceLB.text = [NSString stringWithFormat:@"您出的价格 %.2f元", recoveryGoodsDetailVO.highestBidVo.price];
        
    }
}


@end
