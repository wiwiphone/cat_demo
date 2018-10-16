//
//  ExpectedDeliveryCell.m
//  XianMao
//
//  Created by 阿杜 on 16/9/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ExpectedDeliveryCell.h"

@interface ExpectedDeliveryCell()

@property (nonatomic ,strong) UILabel * expectedDeliveryLbl;

@end

@implementation ExpectedDeliveryCell

-(UILabel *)expectedDeliveryLbl
{
    if (!_expectedDeliveryLbl) {
        _expectedDeliveryLbl = [[UILabel alloc] init];
        _expectedDeliveryLbl.textColor = [UIColor colorWithHexString:@"888888"];
        _expectedDeliveryLbl.font = [UIFont systemFontOfSize:13];
        _expectedDeliveryLbl.textAlignment = NSTextAlignmentLeft;
        [_expectedDeliveryLbl sizeToFit];
    }
    return _expectedDeliveryLbl;
}


+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ExpectedDeliveryCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 78/2;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ExpectedDeliveryCell class]];
    return dict;
}

+(NSMutableDictionary *)buildCellDict:(GoodsInfo *)GoodsInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ExpectedDeliveryCell class]];
    if (GoodsInfo) {
        [dict setObject:GoodsInfo forKey:[self cellDictForkey]];
    }
    return dict;
}

+(NSString *)cellDictForkey
{
    return @"GoodsInfo";
}

+(NSString *)goodsGuaranteeCellDictForkey
{
    return @"goodsGuarantee";
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    GoodsInfo * goodsInfo = [dict objectForKey:[ExpectedDeliveryCell cellDictForkey]];
    
    if ([GoodsInfo expected_delivery_desc_for_detail:goodsInfo.expected_delivery_type]) {
        _expectedDeliveryLbl.text = [NSString stringWithFormat:@"● %@",[GoodsInfo expected_delivery_desc_for_detail:goodsInfo.expected_delivery_type]];
    }
    
}

+ (NSMutableDictionary*)buildGoodsGuaranteeCellDict:(GoodsGuarantee *)goodsGuarantee
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ExpectedDeliveryCell class]];
    if (goodsGuarantee) {
        [dict setObject:goodsGuarantee forKey:[self goodsGuaranteeCellDictForkey]];
    }
    return dict;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.expectedDeliveryLbl];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.expectedDeliveryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
}

@end
