//
//  OfferedRankCell.m
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OfferedRankCell.h"

#import "Masonry.h"
#import "SDWebImageManager.h"

@interface OfferedRankCell ()

@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UILabel *priceLabel;
@property (nonatomic, strong) UIView *segView;

@end

@implementation OfferedRankCell

-(UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLabel.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _priceLabel.font = [UIFont systemFontOfSize:12.f];
        [_priceLabel sizeToFit];
    }
    return _priceLabel;
}

-(UIImageView *)frontImageView{
    if (!_frontImageView) {
        _frontImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _frontImageView;
}

-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _desLabel.textColor = [UIColor colorWithHexString:@"b4b4b5"];
        _desLabel.font = [UIFont systemFontOfSize:12.f];
        [_desLabel sizeToFit];
    }
    return _desLabel;
}

-(UIView *)segView{
    if (!_segView) {
        _segView = [[UIView alloc] initWithFrame:CGRectZero];
        _segView.backgroundColor = [UIColor colorWithHexString:@"b4b4b5"];
    }
    return _segView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OfferedRankCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(HighestBidVo*)bidVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OfferedRankCell class]];
    if (bidVO)[dict setObject:bidVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 55;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"get_bid_detail";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.frontImageView];
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.segView];
        [self.contentView addSubview:self.priceLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.frontImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@19);
        make.height.equalTo(@19);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
}

-(void)updateCellWithDict:(HighestBidVo *)bidVO{
    if (!bidVO) {
        self.frontImageView.image = [UIImage imageNamed:@"Recover_Rank_MF"];
        self.desLabel.text = @"您的出价排行";
    } else {
        self.frontImageView.image = [UIImage imageNamed:@"Recover_Rank_MF"];
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"您的出价排 第%ld位", bidVO.level]];
        NSRange range1=NSMakeRange(7, 1);
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c2a79d"] range:range1];
        //        self.desLabel.text = [NSString stringWithFormat:@"您出价 %ld元", bidVO.price];
        self.desLabel.attributedText=hintString;
        
    }
}
@end
