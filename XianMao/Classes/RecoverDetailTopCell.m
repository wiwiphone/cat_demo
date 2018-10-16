//
//  RecoverDetailTopCell.m
//  XianMao
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverDetailTopCell.h"
#import "XMWebImageView.h"
#import "DataSources.h"

#import "Masonry.h"

@interface RecoverDetailTopCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *priceLblT;
@property (nonatomic, strong) UILabel *whioutLbl;

@end

@implementation RecoverDetailTopCell

-(UILabel *)whioutLbl{
    if (!_whioutLbl) {
        _whioutLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _whioutLbl.font = [UIFont systemFontOfSize:12.f];
        _whioutLbl.textColor = [UIColor colorWithHexString:@"595757"];
        _whioutLbl.text = @"无人报价";
        [_whioutLbl sizeToFit];
    }
    return _whioutLbl;
}

-(UILabel *)priceLblT{
    if (!_priceLblT) {
        _priceLblT = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLblT.font = [UIFont systemFontOfSize:12.f];
        _priceLblT.textColor = [UIColor colorWithHexString:@"c2a79d"];
        [_priceLblT sizeToFit];
    }
    return _priceLblT;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:12.f];
        _priceLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLbl.font = [UIFont systemFontOfSize:14.f];
        _nameLbl.textColor = [UIColor colorWithHexString:@"595757"];
        _nameLbl.numberOfLines = 0;
        [_nameLbl sizeToFit];
    }
    return _nameLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_iconImageView];
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoverDetailTopCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoverDetailTopCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 91;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"recoveryGoodsVo";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.nameLbl];
        [self.contentView addSubview:self.priceLbl];
        [self.contentView addSubview:self.priceLblT];
        [self.contentView addSubview:self.whioutLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@63);
        make.height.equalTo(@63);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-62);
        make.bottom.equalTo(self.iconImageView.mas_centerY).offset(10);
    }];
    
    [self.priceLblT mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLblT.mas_bottom);
        make.right.equalTo(self.priceLblT.mas_left).offset(-7);
    }];
    
    [self.whioutLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.priceLbl.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
}

-(void)updateCellWithDict:(RecoveryGoodsDetail *)goodsDetail{
    RecoveryGoodsVo *goodsVO = goodsDetail.recoveryGoodsVo;
    MainPic *mainPic = goodsVO.mainPic;
    HighestBidVo *bidVO = goodsDetail.highestBidVo;
    [self.iconImageView setImageWithURL:mainPic.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.nameLbl.text = goodsVO.goodsName;
    if (bidVO) {
        self.whioutLbl.hidden = YES;
        self.priceLblT.hidden = NO;
        self.priceLbl.hidden = NO;
        self.priceLbl.text = @"当前最高报价 ";
        self.priceLblT.text = [NSString stringWithFormat:@"¥%.2f", bidVO.price];
        self.priceLblT.textColor = [UIColor colorWithHexString:@"c2a79d"];
    } else {
        self.whioutLbl.hidden = NO;
        self.priceLbl.hidden = YES;
        self.priceLblT.hidden = YES;
    }
    
    
}

@end
