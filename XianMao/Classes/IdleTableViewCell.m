//
//  IdleTableViewCell.m
//  XianMao
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "IdleTableViewCell.h"
#import "Masonry.h"
#import "User.h"
#import "NSDate+Category.h"
#import "TTTAttributedLabel.h"
#import "IdleScrollView.h"
#import "IdleCollectionView.h"

@interface IdleTableViewCell ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UILabel *priceLbl;
@property (nonatomic, strong) UILabel *frontPriceLbl;
//@property (nonatomic, strong) IdleScrollView *picScrollView;
@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property (nonatomic, strong) UILabel *goodsName;
//@property (nonatomic, strong) UILabel *voucherLbl;

@property (nonatomic, strong) IdleCollectionView *picCollectionView;
@end

@implementation IdleTableViewCell

-(IdleCollectionView *)picCollectionView{
    if (!_picCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(kScreenWidth/3+10, kScreenWidth/3+10);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 10;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _picCollectionView = [[IdleCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _picCollectionView.backgroundColor = [UIColor whiteColor];
        _picCollectionView.showsHorizontalScrollIndicator = NO;
    }
    return _picCollectionView;
}

//-(UILabel *)voucherLbl{
//    if (!_voucherLbl) {
//        _voucherLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        _voucherLbl.backgroundColor = [UIColor colorWithHexString:@"000000"];
//        _voucherLbl.textColor = [UIColor whiteColor];
//        _voucherLbl.font = [UIFont systemFontOfSize:12.f];
//        _voucherLbl.text = @"凭证";
//        _voucherLbl.layer.masksToBounds = YES;
//        _voucherLbl.layer.cornerRadius = 3;
//        _voucherLbl.textAlignment = NSTextAlignmentCenter;
//    }
//    return _voucherLbl;
//}

//-(IdleScrollView *)picScrollView{
//    if (!_picScrollView) {
//        _picScrollView = [[IdleScrollView alloc] initWithFrame:CGRectZero];
//        _picScrollView.showsHorizontalScrollIndicator = NO;
//        _picScrollView.bounces = NO;
//    }
//    return _picScrollView;
//}

-(UILabel *)goodsName{
    if (!_goodsName) {
        _goodsName = [[UILabel alloc] init];
        _goodsName.textColor = [UIColor colorWithHexString:@"333333"];
        _goodsName.font = [UIFont systemFontOfSize:12.f];
        [_goodsName sizeToFit];
        _goodsName.numberOfLines = 0;
    }
    return _goodsName;
}



-(UILabel *)frontPriceLbl{
    if (!_frontPriceLbl) {
        _frontPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _frontPriceLbl.font = [UIFont systemFontOfSize:10];
        _frontPriceLbl.textColor = [UIColor colorWithHexString:@"999999"];
    }
    return _frontPriceLbl;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:13];
        _priceLbl.textColor = [UIColor colorWithHexString:@"f9384c"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.font = [UIFont systemFontOfSize:12];
        _timeLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_timeLbl sizeToFit];
    }
    return _timeLbl;
}

-(UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.font = [UIFont systemFontOfSize:15];
        _userName.textColor = [UIColor colorWithHexString:@"333333"];
        [_userName sizeToFit];
    }
    return _userName;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 18.5f;
    }
    return _iconImageView;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([IdleTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 37;
    height += 30;
    GoodsInfo *goodsInfo = dict[@"goodsInfo"];
    if (goodsInfo.gallaryItems.count > 0) {
        height += kScreenWidth/3+10;
    } else {
        height -= 10;
    }
    UILabel *lbl = [[UILabel alloc] init];
    lbl.text = goodsInfo.goodsName;
    lbl.font = [UIFont systemFontOfSize:12.f];
    lbl.numberOfLines = 0;
    [lbl sizeToFit];
    height += 20;//lbl.height;
    height += 10;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo *)goodsInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[IdleTableViewCell class]];
    if (goodsInfo)[dict setObject:goodsInfo forKey:@"goodsInfo"];
    
    return dict;
}

+ (NSString *)cellDictKeyForGoodsInfo
{
    return @"goodsInfo";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
        [self.contentView addSubview:self.bgView];
        [self.bgView addSubview:self.iconImageView];
        [self.bgView addSubview:self.userName];
        [self.bgView addSubview:self.timeLbl];
        [self.bgView addSubview:self.priceLbl];
        [self.bgView addSubview:self.frontPriceLbl];
//        [self.bgView addSubview:self.picScrollView];
        [self.bgView addSubview:self.picCollectionView];
        [self.bgView addSubview:self.goodsName];
//        [self.goodsName addSubview:self.voucherLbl];
        
        
    }
    return self;
}

-(void)setUpUI{
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.top.equalTo(self.contentView.mas_top);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_top).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.width.equalTo(@37);
        make.height.equalTo(@37);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.userName.mas_left);
    }];
    
//    [self.picScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
//        make.left.equalTo(self.bgView.mas_left).offset(12);
//        make.right.equalTo(self.bgView.mas_right);
//        make.height.equalTo(@(kScreenWidth/3+10));
//    }];
    
    [self.picCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
        make.left.equalTo(self.bgView.mas_left).offset(12);
        make.right.equalTo(self.bgView.mas_right);
        make.height.equalTo(@(kScreenWidth/3+10));
    }];
    
    [self.goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.picCollectionView.mas_bottom).offset(13);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.right.equalTo(self.bgView.mas_right).offset(-10);
    }];
    
//    [self.voucherLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.picScrollView.mas_bottom).offset(10);
//        make.left.equalTo(self.bgView.mas_left).offset(10);
//        make.width.equalTo(@50);
//        make.height.equalTo(@20);
//    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    GoodsInfo *goodsInfo = dict[@"goodsInfo"];
    self.goodsInfo = goodsInfo;
    
    User *user = goodsInfo.seller;
    [self.iconImageView setImageWithURL:user.avatarUrl placeholderImage:[UIImage imageNamed:@"placeholder_mine_new"] XMWebImageScaleType:XMWebImageScale480x480];
    self.userName.text = user.userName;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:goodsInfo.modifyTime/1000];
    self.timeLbl.text = [NSString stringWithFormat:@"%@ 更新",[date XMformattedDateDescription]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (goodsInfo.gallaryItems.count == 0) {
            self.picCollectionView.hidden = YES;
        } else {
            self.picCollectionView.hidden = NO;
        }
        
        self.priceLbl.text = [NSString stringWithFormat:@"¥ %.2f", goodsInfo.shopPrice];
        if (goodsInfo.marketPrice>0) {
            NSString *marketPriceString =  [NSString stringWithFormat:@"¥ %@",[GoodsInfo formatPriceString:goodsInfo.marketPrice]];
            NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:marketPriceString];
            [attrString addAttribute:NSStrikethroughStyleAttributeName
                               value:[NSNumber numberWithInteger:NSUnderlinePatternSolid|NSUnderlineStyleSingle]
                               range:NSMakeRange(0, attrString.length)];
            self.frontPriceLbl.attributedText = attrString;
            
            [self.frontPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.userName.mas_bottom);
                make.right.equalTo(self.bgView.mas_right).offset(-10);
            }];
            
            [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.userName.mas_bottom);
                make.right.equalTo(self.frontPriceLbl.mas_left).offset(-3);
            }];
            //        self.frontPriceLbl.hidden = NO;
        } else {
            //        self.frontPriceLbl.hidden = YES;
            self.frontPriceLbl.text = @"";
            [self.frontPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.userName.mas_bottom);
                make.right.equalTo(self.bgView.mas_right).offset(-10);
            }];
            
            [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.userName.mas_bottom);
                make.right.equalTo(self.frontPriceLbl.mas_left).offset(-3);
            }];
        }
        
        //    if (goodsInfo.marketPrice>0) {
        //
        //    } else {
        //
        //
        //    }
        
        
        [self.picCollectionView getPicData:goodsInfo.gallaryItems andGoodsInfo:goodsInfo];
//        self.picScrollView.contentSize = CGSizeMake((goodsInfo.gallaryItems.count*(kScreenWidth/3+10))+(10*(goodsInfo.gallaryItems.count-1)), self.picScrollView.height);
        
        
        if (self.goodsInfo.gallaryItems.count == 0) {
            //
            self.picCollectionView.hidden = YES;
            self.goodsName.frame = CGRectMake(10, 57, self.goodsName.width, self.goodsName.height);
            //        [self.voucherLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.iconImageView.mas_bottom).offset(10);
            //            make.left.equalTo(self.bgView.mas_left).offset(10);
            //            make.width.equalTo(@50);
            //            make.height.equalTo(@20);
            //        }];
            if (self.goodsInfo.hasVoucher == 1) {
//                self.voucherLbl.hidden = NO;
                self.goodsName.text = [NSString stringWithFormat:@"%@", self.goodsInfo.goodsName];
            } else {
//                self.voucherLbl.hidden = YES;
                self.goodsName.text = self.goodsInfo.goodsName;
            }
        } else {
            self.picCollectionView.hidden = NO;
            self.goodsName.frame = CGRectMake(10, 57+kScreenWidth/3+10+10, self.goodsName.width, self.goodsName.height);
            //        [self.voucherLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            //            make.top.equalTo(self.picScrollView.mas_bottom).offset(10);
            //            make.left.equalTo(self.bgView.mas_left).offset(10);
            //            make.width.equalTo(@50);
            //            make.height.equalTo(@20);
            //        }];
            if (self.goodsInfo.hasVoucher == 1) {
//                self.voucherLbl.hidden = NO;
                self.goodsName.text = [NSString stringWithFormat:@"%@", self.goodsInfo.goodsName];
            } else {
//                self.voucherLbl.hidden = YES;
                self.goodsName.text = self.goodsInfo.goodsName;
            }
        }
    });
}

@end
