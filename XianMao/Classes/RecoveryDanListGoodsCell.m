//
//  RecoveryDanListGoodsCell.m
//  XianMao
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoveryDanListGoodsCell.h"
#import "RecoveryGoodsVo.h"
#import "XMWebImageView.h"
#import "Masonry.h"

@interface RecoveryDanListGoodsCell ()

@property (nonatomic, strong) XMWebImageView *mainPicImage;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *recoverNum;
@property (nonatomic, strong) UILabel *subLbl;
@property (nonatomic, strong) UILabel *heigthBidLbl;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIImageView *topLeftImageView;
@property (nonatomic, strong) UILabel *lbl;

@property (nonatomic, strong) RecoveryGoodsVo *goodsVO;

@end

@implementation RecoveryDanListGoodsCell

-(UILabel *)lbl{
    if (!_lbl) {
        _lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _lbl.textColor = [UIColor whiteColor];
        _lbl.font = [UIFont systemFontOfSize:12.f];
        _lbl.text = @"推荐";
        [_lbl sizeToFit];
    }
    return _lbl;
}

-(UIImageView *)topLeftImageView{
    if (!_topLeftImageView) {
        _topLeftImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _topLeftImageView.image = [UIImage imageNamed:@"Recommend_Recover"];
        [_topLeftImageView sizeToFit];
    }
    return _topLeftImageView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    }
    return _lineView;
}

-(UILabel *)heigthBidLbl{
    if (!_heigthBidLbl) {
        _heigthBidLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _heigthBidLbl.font = [UIFont systemFontOfSize:13.f];
        _heigthBidLbl.textColor = [UIColor colorWithHexString:@"c30d23"];
        [_heigthBidLbl sizeToFit];
    }
    return _heigthBidLbl;
}

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.font = [UIFont systemFontOfSize:13.f];
        _subLbl.textColor = [UIColor colorWithHexString:@"898989"];
        _subLbl.numberOfLines = 0;
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(XMWebImageView *)mainPicImage{
    if (!_mainPicImage) {
        _mainPicImage = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _mainPicImage.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    }
    return _mainPicImage;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"595757"];
        _titleLbl.numberOfLines = 0;
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UILabel *)recoverNum{
    if (!_recoverNum) {
        _recoverNum = [[UILabel alloc] initWithFrame:CGRectZero];
        _recoverNum.font = [UIFont systemFontOfSize:11.f];
        _recoverNum.textColor = [UIColor colorWithHexString:@"595757"];
        [_recoverNum sizeToFit];
    }
    return _recoverNum;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoveryDanListGoodsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 130;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    return [self rowHeightForPortrait];
}

+ (NSMutableDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO andCellDictTwo:(RecoveryGoodsVo *)goodsVOTwo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoveryDanListGoodsCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:@"recoveryGoodsVO"];
    if (goodsVOTwo) {
        [dict setObject:goodsVOTwo forKey:@"recoveryGoodsVOTwo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        [self.contentView addSubview:self.mainPicImage];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.recoverNum];
        [self.contentView addSubview:self.subLbl];
        [self.contentView addSubview:self.heigthBidLbl];
        [self.contentView addSubview:self.lineView];
        
        [self.contentView addSubview:self.topLeftImageView];
        [self.topLeftImageView addSubview:self.lbl];

    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.mainPicImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.width.equalTo(@(self.contentView.height));
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
//    if (self.titleLbl.height <= (self.contentView.height - 32) / 2) {
//        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.mainPicImage.mas_top).offset(17);
//            make.left.equalTo(self.mainPicImage.mas_right).offset(10);
//            make.right.equalTo(self.contentView.mas_right).offset(-21);
//        }];
//    } else {
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mainPicImage.mas_top).offset(5);
            make.left.equalTo(self.mainPicImage.mas_right).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-21);
            make.height.equalTo(@((self.contentView.height - 32) / 2));
        }];
//    }
    
//    if (self.subLbl.height <= (self.contentView.height - 32) / 2) {
//        [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_centerY).offset(-32);
//            make.left.equalTo(self.titleLbl.mas_left);
//            make.right.equalTo(self.titleLbl.mas_right);
//        }];
//    } else {
        [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY).offset(-15);
            make.left.equalTo(self.titleLbl.mas_left);
            make.right.equalTo(self.titleLbl.mas_right);
            make.height.equalTo(@((self.contentView.height - 32) / 2));
        }];
//    }
    
    [self.recoverNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainPicImage.mas_right).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-12);
    }];
    
    [self.heigthBidLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.titleLbl.mas_right);
        make.centerY.equalTo(self.recoverNum.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-32);
        make.left.equalTo(self.mainPicImage.mas_right).offset(10);
        make.right.equalTo(self.titleLbl.mas_right);
        make.height.equalTo(@1);
    }];
    
    [self.topLeftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainPicImage.mas_top);
        make.left.equalTo(self.mainPicImage.mas_left).offset(5);
    }];
    
    [self.lbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topLeftImageView.mas_centerX);
        make.centerY.equalTo(self.topLeftImageView.mas_centerY);
    }];
}

-(NSString *)getNewsUsedText:(NSInteger )grand{
    switch (grand) {
        case 1:
            return @"N1";
            break;
        case 5:
            return @"N2";
            break;
        case 2:
            return @"N3";
            break;
        case 7:
            return @"S1";
            break;
        case 3:
            return @"S2";
            break;
        case 6:
            return @"B1";
            break;
        case 4:
            return @"B2";
            break;
        default:
            return @"";
            break;
    }
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    RecoveryGoodsVo *goodsVO = dict[@"recoveryGoodsVO"];
    
    if (goodsVO) {
        self.goodsVO = goodsVO;
        [self.mainPicImage setImageWithURL:goodsVO.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        self.titleLbl.text = goodsVO.goodsName;
        self.recoverNum.text = [NSString stringWithFormat:@"%ld次出价", goodsVO.offerCount];
        self.subLbl.text = goodsVO.goodsBrief;
        
        if (goodsVO.maxOfferPrice > 0) {
            self.heigthBidLbl.text = [NSString stringWithFormat:@"最高¥%ld", goodsVO.maxOfferPrice];
        } else {
            self.heigthBidLbl.text = @"立即出价";
        }
        
        if (goodsVO.isRecommend == 1) {
            self.topLeftImageView.hidden = NO;
        } else {
            self.topLeftImageView.hidden = YES;
        }
    }
}

@end
