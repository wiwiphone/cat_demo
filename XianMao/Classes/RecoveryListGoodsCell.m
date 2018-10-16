//
//  RecoveryListGoodsCell.m
//  XianMao
//
//  Created by apple on 16/3/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoveryListGoodsCell.h"
#import "XMWebImageView.h"
#import "Masonry.h"

@interface RecoveryListGoodsCell ()

@property (nonatomic, strong) UIView *goodsViewLeft;
@property (nonatomic, strong) XMWebImageView *mainPicImage;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *NewsUsed;
@property (nonatomic, strong) UILabel *recoverNum;
@property (nonatomic, strong) UIButton *pushLeftBtn;

@property (nonatomic, strong) UIButton *pushRigthBtn;
@property (nonatomic, strong) UIView *goodsViewRigth;
@property (nonatomic, strong) XMWebImageView *mainPicImageRigth;
@property (nonatomic, strong) UILabel *titleLblRigth;
@property (nonatomic, strong) UILabel *NewsUsedRigth;
@property (nonatomic, strong) UILabel *recoverNumRigth;

@property (nonatomic, strong) RecoveryGoodsVo *goodsVO;
@property (nonatomic, strong) RecoveryGoodsVo *goodsVOT;
@end

@implementation RecoveryListGoodsCell

-(UIButton *)pushRigthBtn{
    if (!_pushRigthBtn) {
        _pushRigthBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _pushRigthBtn;
}

-(UIButton *)pushLeftBtn{
    if (!_pushLeftBtn) {
        _pushLeftBtn = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _pushLeftBtn;
}

-(UIView *)goodsViewLeft{
    if (!_goodsViewLeft) {
        _goodsViewLeft = [[UIView alloc] initWithFrame:CGRectZero];
        _goodsViewLeft.backgroundColor = [UIColor whiteColor];
    }
    return _goodsViewLeft;
}

-(UIView *)goodsViewRigth{
    if (!_goodsViewRigth) {
        _goodsViewRigth = [[UIView alloc] initWithFrame:CGRectZero];
        _goodsViewRigth.backgroundColor = [UIColor whiteColor];
    }
    return _goodsViewRigth;
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
        _titleLbl.font = [UIFont systemFontOfSize:12.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UILabel *)NewsUsed{
    if (!_NewsUsed) {
        _NewsUsed = [[UILabel alloc] initWithFrame:CGRectZero];
        _NewsUsed.font = [UIFont systemFontOfSize:12.f];
        _NewsUsed.textColor = [UIColor colorWithHexString:@"b28031"];
        [_NewsUsed sizeToFit];
    }
    return _NewsUsed;
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

- (XMWebImageView *)mainPicImageRigth{
    if (!_mainPicImageRigth) {
        _mainPicImageRigth = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _mainPicImageRigth.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    }
    return _mainPicImageRigth;
}

- (UILabel *)titleLblRigth{
    if (!_titleLblRigth) {
        _titleLblRigth = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLblRigth.font = [UIFont systemFontOfSize:12.f];
        _titleLblRigth.textColor = [UIColor colorWithHexString:@"595757"];
        [_titleLblRigth sizeToFit];
    }
    return _titleLblRigth;
}

- (UILabel *)NewsUsedRigth{
    if (!_NewsUsedRigth) {
        _NewsUsedRigth = [[UILabel alloc] initWithFrame:CGRectZero];
        _NewsUsedRigth.font = [UIFont systemFontOfSize:12.f];
        _NewsUsedRigth.textColor = [UIColor colorWithHexString:@"b28031"];
        [_NewsUsedRigth sizeToFit];
    }
    return _NewsUsedRigth;
}

- (UILabel *)recoverNumRigth{
    if (!_recoverNumRigth) {
        _recoverNumRigth = [[UILabel alloc] initWithFrame:CGRectZero];
        _recoverNumRigth.font = [UIFont systemFontOfSize:11.f];
        _recoverNumRigth.textColor = [UIColor colorWithHexString:@"595757"];
        [_recoverNumRigth sizeToFit];
    }
    return _recoverNumRigth;
}
+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoveryListGoodsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 214;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    return [self rowHeightForPortrait];
}

+ (NSMutableDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO andCellDictTwo:(RecoveryGoodsVo *)goodsVOTwo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoveryListGoodsCell class]];
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
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];
        [self.contentView addSubview:self.goodsViewLeft];
        [self.goodsViewLeft addSubview:self.mainPicImage];
        [self.goodsViewLeft addSubview:self.titleLbl];
        [self.goodsViewLeft addSubview:self.NewsUsed];
        [self.goodsViewLeft addSubview:self.recoverNum];
        
        [self.contentView addSubview:self.goodsViewRigth];
        [self.goodsViewRigth addSubview:self.mainPicImageRigth];
        [self.goodsViewRigth addSubview:self.titleLblRigth];
        [self.goodsViewRigth addSubview:self.NewsUsedRigth];
        [self.goodsViewRigth addSubview:self.recoverNumRigth];
        
        [self.goodsViewLeft addSubview:self.pushLeftBtn];
        [self.goodsViewRigth addSubview:self.pushRigthBtn];
        
        [self.pushLeftBtn addTarget:self action:@selector(clickPushLeftBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.pushRigthBtn addTarget:self action:@selector(clickPushRigthBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void) clickPushLeftBtn{
    WEAKSELF;
    if (self.pushGoodsDetailController) {
        self.pushGoodsDetailController(weakSelf.goodsVO.goodsSn);
    }
}

-(void)clickPushRigthBtn{
    WEAKSELF;
    if (self.pushGoodsDetailController) {
        self.pushGoodsDetailController(weakSelf.goodsVOT.goodsSn);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.goodsViewLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_centerX).offset(-2.5);
    }];
    
    [self.mainPicImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsViewLeft.mas_top);
        make.left.equalTo(self.goodsViewLeft.mas_left);
        make.right.equalTo(self.goodsViewLeft.mas_right);
        make.height.equalTo(@160);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainPicImage.mas_bottom).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.right.equalTo(self.contentView.mas_centerX).offset(-10);
    }];
    
    [self.NewsUsed mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(5);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [self.recoverNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_centerX).offset(-10);
        make.bottom.equalTo(self.NewsUsed.mas_bottom);
    }];
    
    [self.goodsViewRigth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_centerX).offset(2.5);
    }];
    
    [self.mainPicImageRigth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsViewRigth.mas_top);
        make.left.equalTo(self.goodsViewRigth.mas_left);
        make.right.equalTo(self.goodsViewRigth.mas_right);
        make.height.equalTo(@160);
    }];
    
    [self.titleLblRigth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainPicImageRigth.mas_bottom).offset(5);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.left.equalTo(self.contentView.mas_centerX).offset(10);
    }];
    
    [self.NewsUsedRigth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
    }];
    
    [self.recoverNumRigth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-5);
        make.bottom.equalTo(self.NewsUsedRigth.mas_bottom);
    }];
    
    [self.pushLeftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.goodsViewLeft);
    }];
    
    [self.pushRigthBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.goodsViewRigth);
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
    RecoveryGoodsVo *goodsVOT = dict[@"recoveryGoodsVOTwo"];
    
    if (goodsVO) {
        self.goodsVO = goodsVO;
        self.goodsViewLeft.hidden = NO;
        self.pushLeftBtn.hidden = NO;
        [self.mainPicImage setImageWithURL:goodsVO.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        self.titleLbl.text = goodsVO.goodsName;
        self.NewsUsed.text = [self getNewsUsedText:goodsVO.grade];
        self.recoverNum.text = [NSString stringWithFormat:@"%ld次出价", goodsVO.offerCount];
    } else {
        self.pushLeftBtn.hidden = YES;
        self.goodsViewLeft.hidden = YES;
    }
    if (goodsVOT) {
        self.goodsVOT = goodsVOT;
        self.pushRigthBtn.hidden = NO;
        self.goodsViewRigth.hidden = NO;
        [self.mainPicImageRigth setImageWithURL:goodsVOT.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
        self.titleLblRigth.text = goodsVOT.goodsName;
        self.NewsUsedRigth.text = [self getNewsUsedText:goodsVOT.grade];
        self.recoverNumRigth.text = [NSString stringWithFormat:@"%ld次出价", goodsVOT.offerCount];
    } else {
        self.pushRigthBtn.hidden = YES;
        self.goodsViewRigth.hidden = YES;
    }
}

@end
