//
//  ApplyGoodsDetailCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ApplyGoodsDetailCell.h"
#import "Masonry.h"


@implementation ApplyGoodsDetailCell

-(XMWebImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(12, (100-kScreenWidth/375*60)/2, kScreenWidth/375*60, kScreenWidth/375*60)];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _iconImageView;
}

-(UILabel *)goodsNameLbl
{
    if (!_goodsNameLbl) {
        _goodsNameLbl = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImageView.frame)+14, CGRectGetMinY(self.iconImageView.frame), kScreenWidth/375*200, 15)];
        _goodsNameLbl.textColor = [UIColor colorWithHexString:@"000000"];
        _goodsNameLbl.font = [UIFont systemFontOfSize:12.0f];
    }
    return _goodsNameLbl;
}


-(UILabel *)priceLbl
{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        _priceLbl.font = [UIFont systemFontOfSize:12.0f];
        _priceLbl.textAlignment = NSTextAlignmentRight;
    }
    return _priceLbl;
}

-(UILabel *)goodsCountsLbl
{
    if (!_goodsCountsLbl) {
        _goodsCountsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsCountsLbl.font = [UIFont systemFontOfSize:11.0f];
        _goodsCountsLbl.textAlignment = NSTextAlignmentRight;
        _goodsCountsLbl.textColor = [UIColor colorWithHexString:@"bcbcbc"];
        [_goodsCountsLbl sizeToFit];
    }
    return _goodsCountsLbl;
}

-(UIImageView *)deterMine
{
    if (!_deterMine) {
        _deterMine = [[UIImageView alloc] initWithFrame:CGRectZero];
        _deterMine.image = [UIImage imageNamed:@"Wrist_Determine"];
        [_deterMine sizeToFit];
    }
    return _deterMine;
}

-(UILabel *)netPayLbl
{
    if (!_netPayLbl) {
        _netPayLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _netPayLbl.textColor = [UIColor redColor];
        _netPayLbl.font = [UIFont systemFontOfSize:12.0f];
        _netPayLbl.textAlignment = NSTextAlignmentRight;
        [_netPayLbl sizeToFit];
    }
    return _netPayLbl;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.goodsNameLbl];
        [self.contentView addSubview:self.deterMine];
        [self.contentView addSubview:self.goodsCountsLbl];
        [self.contentView addSubview:self.priceLbl];
        [self.contentView addSubview:self.netPayLbl];
    }
    return self;
}

+ (CGFloat)rowHeightForPortrait
{
    CGFloat height = 100.f;
    return height;
}

+(NSString *)reuseIdentifier
{
    static NSString * __reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ApplyGoodsDetailCell class]);
    });
    return __reuseIdentifier;   
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.left.equalTo(self.goodsNameLbl.mas_right);
        make.height.mas_equalTo(kScreenWidth/375*60/3);
    }];
    
    [self.goodsCountsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];

    [self.deterMine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(14);
        make.width.mas_equalTo(@20);
        make.height.mas_equalTo(@20);
    }];

    [self.netPayLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.bottom.equalTo(self.deterMine.mas_bottom);
    }];
    

    
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ApplyGoodsDetailCell class]];
    return dict;
}

+ (NSMutableDictionary*)buildCellDict:(BuybackOrderModel *)BuybackOrderModel
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ApplyGoodsDetailCell class]];
    if (BuybackOrderModel) {
        [dict setObject:BuybackOrderModel forKey:@"BuybackOrderModel"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{

    
    BuybackOrderModel * model = dict[@"BuybackOrderModel"];
    if (model.pic) {
        [self.iconImageView setImageWithURL:model.pic placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    }
    if (model.goodsName) {
        self.goodsNameLbl.text = model.goodsName;
    }
    if (model.shopPrice) {
        self.priceLbl.text = [NSString stringWithFormat:@"¥%@",model.shopPrice];
    }
    if (model.count) {
        self.goodsCountsLbl.text  = [NSString stringWithFormat:@"x%@",model.count];
    }
    if (model.realPrice) {
        self.netPayLbl.text = [NSString stringWithFormat:@"实付¥%@",model.realPrice];
    }
    
}
@end
