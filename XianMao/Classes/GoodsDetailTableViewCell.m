//
//  GoodsDetailTableViewCell.m
//  XianMao
//
//  Created by simon cai on 27/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "GoodsDetailTableViewCell.h"
#import "GoodsInfo.h"
#import "GoodsDetailInfo.h"

#import "Command.h"
#import "Session.h"
#import "ActivityInfo.h"
#import "WeakTimerTarget.h"
#import "URLScheme.h"
#import "DataSources.h"
#import "TagVo.h"
#import "Masonry.h"
#import "QuartzCore/QuartzCore.h"
#import "ServerTag.h"
#import "PromiseVo.h"


@interface GoodsDetailLikeButton : VerticalCommandButton

@end

@implementation GoodsDetailLikeButton

-(void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected {
    [self setSelected:selected anim:NO];
}
- (void)setSelected:(BOOL)selected anim:(BOOL)anim
{
    [super setSelected:selected];
    if (anim) {
        if (selected) {
            [self zoomInOutAnimation:self.imageView duration:0.2f option:UIViewAnimationOptionCurveLinear];
        } else {
            [self zoomInOutAnimation:self.imageView duration:0.2f option:UIViewAnimationOptionCurveLinear];
        }
    }
}

- (void) zoomInOutAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option {
    view.transform = CGAffineTransformIdentity;
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    
    view.transform = trans; // do it instantly, no animation
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         view.transform = CGAffineTransformScale(view.transform, 200.0, 200.0);
                     }
                     completion:^(BOOL finished) {
                         //NSLog(@"done");
                     } ];
}


@end


@interface SegTabViewTitleCell ()

@property (nonatomic, weak) CommandButton *shareBtn;
@property (nonatomic, weak) CommandButton *shoppingBrn;
@property (nonatomic, weak) CommandButton *supportBtn;

@property (nonatomic, weak) UILabel *shopNumLbl;
@property (nonatomic, strong) GoodsInfo *goodsInfo;

@end

@implementation SegTabViewTitleCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsDetailBaseInfoCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 45.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SegTabViewTitleCell class]];
    if (item)[dict setObject:item forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"item";
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
            
            if (goodsInfo.isLiked) {
                self.supportBtn.selected = YES;
            } else {
                self.supportBtn.selected = NO;
            }
            
            
            self.goodsInfo = goodsInfo;
            [self setNeedsLayout];
        }
    }
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
        //        _likeBtn = [[GoodsDetailLikeButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
        //        _likeBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
        //        _likeBtn.layer.cornerRadius = 55.f/2.f;
        //        _likeBtn.layer.masksToBounds = YES;
        //        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
        //        [_likeBtn setImage:[UIImage imageNamed:@"goods_detail_like"] forState:UIControlStateNormal];
        //        [_likeBtn setImage:[UIImage imageNamed:@"goods_detail_liked"] forState:UIControlStateSelected];
        //        [_likeBtn setTitle:@"0" forState:UIControlStateNormal];
        //        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        //        _likeBtn.contentAlignmentCenter = YES;
        //        _likeBtn.imageTextSepHeight = 4.f;
        //        _likeBtn.contentMarginTop = 2.f;
        //        [self.contentView addSubview:_likeBtn];
        
        //        WEAKSELF;
        //        _likeBtn.handleClickBlock = ^(CommandButton *sender){
        //            [MobClick event:@"click_want_from_detail"];
        //            if ([weakSelf.likeBtn isSelected]) {
        //                [GoodsSingletonCommand unlikeGoods:weakSelf.goodsInfo.goodsId];
        //            } else {
        //                [GoodsSingletonCommand likeGoods:weakSelf.goodsInfo.goodsId];
        //            }
        //        };
        
        CommandButton *shareBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        CommandButton *supportBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        CommandButton *shoppingBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        UILabel *shopNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        
        shopNumLbl.backgroundColor = [UIColor colorWithHexString:@"fb0006"];
        shopNumLbl.text = @"0";
        shopNumLbl.font = [UIFont systemFontOfSize:10];
        shopNumLbl.textAlignment = NSTextAlignmentCenter;
        [shopNumLbl setTextColor:[UIColor whiteColor]];
        shopNumLbl.layer.masksToBounds = YES;
        shopNumLbl.layer.cornerRadius = 7;
        [shoppingBtn setImage:[UIImage imageNamed:@"ShopBag_New_MF"] forState:UIControlStateNormal];
        [supportBtn setImage:[UIImage imageNamed:@"mine_likes"] forState:UIControlStateNormal];
        [supportBtn setImage:[UIImage imageNamed:@"goods_detail_liked"] forState:UIControlStateSelected];
        [shareBtn setImage:[UIImage imageNamed:@"Share_New_MF_T"] forState:UIControlStateNormal];
        
        [self.contentView addSubview:shareBtn];
        [self.contentView addSubview:supportBtn];
        [self.contentView addSubview:shoppingBtn];
        [self.contentView addSubview:shopNumLbl];
        
        self.shareBtn = shareBtn;
        self.supportBtn = supportBtn;
        self.shoppingBrn = shoppingBtn;
        self.shopNumLbl = shopNumLbl;
        
//        [MobClick event:@"click_want_from_detail"];
//        if (self.goodsInfo.isLiked) {
//            self.supportBtn.selected = YES;
//        } else {
//            self.supportBtn.selected = NO;
//        }
        
        if (![Session sharedInstance].shoppingCartNum) {
            self.shopNumLbl.hidden = YES;
        } else {
            self.shopNumLbl.hidden = NO;
            self.shopNumLbl.text = [NSString stringWithFormat:@"%ld", (long)[Session sharedInstance].shoppingCartNum];
        }
        
        
        
        WEAKSELF;
        self.supportBtn.handleClickBlock = ^(CommandButton *sender){
            BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
                
            }];
            if (!isLoggedIn) {
                return;
            }
            [MobClick event:@"click_want_from_detail"];
            if (weakSelf.goodsInfo.isLiked) {
                self.supportBtn.selected = NO;
                [GoodsSingletonCommand unlikeGoods:weakSelf.goodsInfo.goodsId];
            } else {
                self.supportBtn.selected = YES;
                [GoodsSingletonCommand likeGoods:weakSelf.goodsInfo.goodsId];
            }
            if (weakSelf.handleSupportCommentsBlock) {
                weakSelf.handleSupportCommentsBlock(weakSelf.goodsInfo);
            }
        };
        
        self.shareBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleShareCommentsBlock) {
                weakSelf.handleShareCommentsBlock();
            }
        };
        
        self.shoppingBrn.handleClickBlock = ^(CommandButton *sender){
            if (weakSelf.handleShopCommentsBlock) {
                weakSelf.handleShopCommentsBlock(sender );
            }
        };
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncRenewData:) name:@"syncRenewData" object:nil];
        
    }
    return self;
}

-(void)syncRenewData:(NSNotification *)notify{
    NSNumber *goodsNum = notify.object;
    self.shopNumLbl.text = [NSString stringWithFormat:@"%@", goodsNum];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.shoppingBrn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-25);
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
    
    [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shoppingBrn.mas_left).offset(-25);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shareBtn.mas_left).offset(-25);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.equalTo(@25);
        make.height.equalTo(@25);
    }];
    
    [self.shopNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.shoppingBrn.mas_right).offset(8);
        make.top.equalTo(self.shoppingBrn.mas_top).offset(-5);
        make.width.equalTo(@14);
        make.height.equalTo(@14);
    }];
}

@end


@interface GoodsDetailBaseInfoCell () <ActivityInfoManagerObserver>

@property(nonatomic,strong) CommandButton *gradeLbl;
@property(nonatomic,strong) UILabel *goodsNameLbl;
@property(nonatomic,strong) UILabel *admCommentLbl;
@property(nonatomic,strong) UILabel *summaryLbl;
@property(nonatomic,strong) UILabel *shopPriceLbl;
@property(nonatomic,strong) UILabel *marketPriceLbl;
@property(nonatomic,strong) UILabel *visitNumLbl;
@property(nonatomic,strong) UIButton *discountTagLbl;
@property(nonatomic,strong) UILabel *expectedDeliveryLbl;
@property(nonatomic,strong) VerticalCommandButton *likeBtn;
@property(nonatomic,strong) UIButton *limitedLbl;
@property(nonatomic,strong) GoodsInfo *goodsInfo;
@property(nonatomic,strong) UILabel * storeIcon;
@property (nonatomic, strong) UILabel *seeNumLbl;
@property (nonatomic, strong) UIView *LimittimeView;
@property (nonatomic, strong) UIImageView *limittimeLockImageView;
//@property (nonatomic, strong) UIImageView *disCountImageView;

@end

@implementation GoodsDetailBaseInfoCell


-(UILabel *)seeNumLbl{
    if (!_seeNumLbl) {
        _seeNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _seeNumLbl.textColor = [UIColor colorWithHexString:@"b3b3b3"];
        _seeNumLbl.font = [UIFont systemFontOfSize:13.f];
        [_seeNumLbl sizeToFit];
    }
    return _seeNumLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsDetailBaseInfoCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    NSObject *obj = [dict objectForKey:[self cellDictKeyForGoodsInfo]];
    if ([obj isKindOfClass:[GoodsInfo class]]) {
        GoodsInfo *item = (GoodsInfo*)obj;
        height = [GoodsDetailBaseInfoCell calculateHeightAndLayoutSubviews:nil item:item] - 15;
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsDetailBaseInfoCell class]];
    if (item)[dict setObject:item forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"item";
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)dealloc
{
    _goodsInfo = nil;
    
    [[ActivityInfoManager sharedInstance] removeObserver:self];
}

- (UIView*)likeBtnView {
    return _likeBtn;
}

//-(UIImageView *)disCountImageView{
//    if (_disCountImageView) {
//        _disCountImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
//        _disCountImageView.image = [UIImage imageNamed:@"DisCount-MF"];
//    }
//    return _disCountImageView;
//}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        WEAKSELF;
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"282828"];
        
        _gradeLbl = [[CommandButton alloc] initWithFrame:CGRectZero];
        _gradeLbl.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_gradeLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];        _gradeLbl.titleLabel.font = [UIFont systemFontOfSize:10.f];
        _gradeLbl.layer.masksToBounds = YES;
        _gradeLbl.layer.cornerRadius = 15/2;
        [_gradeLbl sizeToFit];
        [self.contentView addSubview:_gradeLbl];
        
        _gradeLbl.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handlegradeTagBlock) {
                weakSelf.handlegradeTagBlock(weakSelf.goodsInfo.gradeTag);
            }
        };
        
        _storeIcon = [[UILabel alloc] init];
        _storeIcon.textColor = [UIColor whiteColor];
        _storeIcon.backgroundColor = [DataSources colorf9384c];
        _storeIcon.layer.masksToBounds = YES;
        _storeIcon.layer.cornerRadius = 15/2;
        _storeIcon.textAlignment = NSTextAlignmentCenter;
        _storeIcon.font = [UIFont systemFontOfSize:10];
        [_storeIcon sizeToFit];
        [self.contentView addSubview:self.storeIcon];
//
        _goodsNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsNameLbl.textColor = [UIColor blackColor];
        _goodsNameLbl.font = [UIFont boldSystemFontOfSize:15.f];
        _goodsNameLbl.numberOfLines = 0;
        [_goodsNameLbl sizeToFit];
        [self.contentView addSubview:_goodsNameLbl];
        
        _admCommentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _admCommentLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _admCommentLbl.font = [UIFont boldSystemFontOfSize:14.f];
        _admCommentLbl.numberOfLines = 0;
        [self.contentView addSubview:_admCommentLbl];
//        _admCommentLbl.hidden = YES;
        
        _summaryLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _summaryLbl.textColor = [UIColor blackColor];//[UIColor colorWithHexString:@"999999"];
        _summaryLbl.font = [UIFont systemFontOfSize:14.f];
        _summaryLbl.numberOfLines = 0;
        [self.contentView addSubview:_summaryLbl];
        
        _LimittimeView = [[UIView alloc] initWithFrame:CGRectZero];
        _LimittimeView.backgroundColor = [UIColor colorWithHexString:@"f0ebeb"];
        [self.contentView addSubview:_LimittimeView];
        
        _limittimeLockImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _limittimeLockImageView.image = [UIImage imageNamed:@"GoodsDetail_LimittimeLock_MF"];
        [self.LimittimeView addSubview:_limittimeLockImageView];
        
        _limitedLbl = [[UIButton alloc] initWithFrame:CGRectZero];
        _limitedLbl.enabled = NO;
        [_limitedLbl setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
        _limitedLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 1, 0);
        _limitedLbl.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _limitedLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        
        _limitedLbl.titleLabel.numberOfLines = 0;
        [_limitedLbl sizeToFit];
//        UIImage *img = [UIImage imageNamed:@"goods_tag_limited_red_bg"];
//        [_limitedLbl setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
        [self.LimittimeView addSubview:_limitedLbl];
        
        
        _shopPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPriceLbl.textColor = [UIColor colorWithHexString:@"f9384c"];//[UIColor colorWithHexString:@"FFE8B0"];
        _shopPriceLbl.font = [UIFont systemFontOfSize:20.f];
        [self.contentView addSubview:_shopPriceLbl];
        
//        [self.contentView addSubview:self.disCountImageView];
        
        _marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _marketPriceLbl.textColor = [UIColor colorWithHexString:@"bfbfbf"];
        _marketPriceLbl.font = [UIFont systemFontOfSize:13.f];
        [self.contentView addSubview:_marketPriceLbl];
        
        _visitNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _visitNumLbl.backgroundColor = [UIColor clearColor];
        _visitNumLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _visitNumLbl.numberOfLines = 1;
        _visitNumLbl.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:_visitNumLbl];

        
        _discountTagLbl = [[UIButton alloc] initWithFrame:CGRectZero];
        [_discountTagLbl setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateDisabled];//colorWithHexString:@"181818"
        _discountTagLbl.titleLabel.font = [UIFont systemFontOfSize:9.5f];
        _discountTagLbl.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _discountTagLbl.layer.masksToBounds = YES;
        _discountTagLbl.layer.borderColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
        _discountTagLbl.layer.borderWidth = 0.5;
        _discountTagLbl.enabled = NO;
        _discountTagLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        [self.contentView addSubview:_discountTagLbl];
        UIImage *discountBg = [UIImage imageNamed:@"goods_tag_discount_bg"];
//        [_discountTagLbl setBackgroundImage:[discountBg stretchableImageWithLeftCapWidth:discountBg.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
//        _discountTagLbl.backgroundColor = [UIColor colorWithHexString:@"150c0f"];
        
//        _expectedDeliveryLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        _expectedDeliveryLbl.font = [UIFont systemFontOfSize:12];
//        _expectedDeliveryLbl.textColor = [UIColor colorWithHexString:@"999999"];
//        [self.contentView addSubview:_expectedDeliveryLbl];
//        _expectedDeliveryLbl.hidden = YES;
        
//        _likeBtn = [[GoodsDetailLikeButton alloc] initWithFrame:CGRectMake(0, 0, 55, 55)];
//        _likeBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
//        _likeBtn.layer.cornerRadius = 55.f/2.f;
//        _likeBtn.layer.masksToBounds = YES;
//        [_likeBtn setTitleColor:[UIColor colorWithHexString:@"AAAAAA"] forState:UIControlStateNormal];
//        [_likeBtn setImage:[UIImage imageNamed:@"goods_detail_like"] forState:UIControlStateNormal];
//        [_likeBtn setImage:[UIImage imageNamed:@"goods_detail_liked"] forState:UIControlStateSelected];
//        [_likeBtn setTitle:@"0" forState:UIControlStateNormal];
//        _likeBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
//        _likeBtn.contentAlignmentCenter = YES;
//        _likeBtn.imageTextSepHeight = 4.f;
//        _likeBtn.contentMarginTop = 2.f;
//        [self.contentView addSubview:_likeBtn];
        
//        WEAKSELF;
//        _likeBtn.handleClickBlock = ^(CommandButton *sender){
//            [MobClick event:@"click_want_from_detail"];
//            if ([weakSelf.likeBtn isSelected]) {
//                [GoodsSingletonCommand unlikeGoods:weakSelf.goodsInfo.goodsId];
//            } else {
//                [GoodsSingletonCommand likeGoods:weakSelf.goodsInfo.goodsId];
//            }
//        };
        
        [self.contentView addSubview:self.seeNumLbl];
        
        [self.seeNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView.mas_right).offset(-14);
            make.top.equalTo(self.goodsNameLbl.mas_top);
        }];
        
        [[ActivityInfoManager sharedInstance] addObserver:self];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];

    _gradeLbl.frame = CGRectZero;
    _goodsNameLbl.frame = CGRectZero;
//    _summaryLbl.frame = CGRectZero;
    _shopPriceLbl.frame = CGRectZero;
    _marketPriceLbl.frame = CGRectZero;
    _discountTagLbl.frame = CGRectZero;
//    _likeBtn.frame = CGRectMake(0, 0, 55, 55);
    _admCommentLbl.hidden = YES;
    _admCommentLbl.text = nil;
    
//    _expectedDeliveryLbl.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [[self class] calculateHeightAndLayoutSubviews:self item:nil];
}

+ (CGFloat)calculateHeightAndLayoutSubviews:(GoodsDetailBaseInfoCell*)cell item:(GoodsInfo*)goodsInfo
{
    CGFloat marginTop = 0.f;
    
    CGSize gradeTextSize = CGSizeZero;
    NSString *gradeText = goodsInfo?goodsInfo.gradeTag.value:[cell.gradeLbl titleForState:UIControlStateNormal];
    if ([gradeText length]>0) {
        gradeTextSize = [gradeText sizeWithFont:[UIFont systemFontOfSize:14.f]
                              constrainedToSize:CGSizeMake(kScreenWidth-15.f-15.f,MAXFLOAT)
                                  lineBreakMode:NSLineBreakByWordWrapping];
        gradeTextSize.height = 15.f;
        gradeTextSize.width += 8;
    }
    
    
    CGSize goodsNameSize = CGSizeZero;
    NSString *goodsName = goodsInfo?goodsInfo.goodsName:cell.goodsNameLbl.text;
    if ([goodsName length]>0) {
        if (gradeTextSize.width>0) {
            goodsNameSize = [goodsName sizeWithFont:[UIFont boldSystemFontOfSize:15.f]
                                  constrainedToSize:CGSizeMake(kScreenWidth-20.f-15.f-35-70,MAXFLOAT)
                                      lineBreakMode:NSLineBreakByWordWrapping];
//            goodsNameSize = [goodsName sizeWithFont:[UIFont systemFontOfSize:14.f]];
        } else {
            goodsNameSize = [goodsName sizeWithFont:[UIFont boldSystemFontOfSize:15.f]
                                  constrainedToSize:CGSizeMake(kScreenWidth-15.f-15.f,MAXFLOAT)
                                      lineBreakMode:NSLineBreakByWordWrapping];
//            goodsNameSize = [goodsName sizeWithFont:[UIFont systemFontOfSize:14.f]];
        }
    }
    
    if (!CGSizeEqualToSize(gradeTextSize,CGSizeZero) || !CGSizeEqualToSize(goodsNameSize,CGSizeZero)) {
        marginTop += 15.f;
        marginTop += gradeTextSize.height>goodsNameSize.height?gradeTextSize.height:goodsNameSize.height;
        
        cell.storeIcon.frame = CGRectMake(20, 23, 30, 15);
        
        
        if (cell && [cell.goodsNameLbl.text length]>0) {
            if (gradeTextSize.width>0) {
                cell.goodsNameLbl.frame = CGRectMake(30+5+20, 20, kScreenWidth-20.f-15.f-35-70, goodsNameSize.height);
//                cell.goodsNameLbl.numberOfLines = 0;
            }
            else {
                cell.goodsNameLbl.frame = CGRectMake(30+5+20, 20, kScreenWidth-20.f-15.f-35-70, goodsNameSize.height);
//                cell.goodsNameLbl.numberOfLines = 0;
            }
        }
        
        if (cell && cell.storeIcon.text.length >0 ) {
            cell.gradeLbl.frame = CGRectMake(30+5+20, 23, 30, 15);
            cell.goodsNameLbl.frame = CGRectMake(30+5+20+35, 20, kScreenWidth-20.f-15.f-35-70-30, goodsNameSize.height);
        }else{
            cell.gradeLbl.frame = CGRectMake(20, 23, 30, 15);
            cell.goodsNameLbl.frame = CGRectMake(20+30+5, 20, kScreenWidth-20.f-15.f-70-30, goodsNameSize.height);
        }
    
        marginTop += 5.f;
    }
    
    NSString *comment = goodsInfo?goodsInfo.admComment:cell.admCommentLbl.text;
    if ([comment length]>0) {
        CGSize size = [comment sizeWithFont:[UIFont boldSystemFontOfSize:14.f]
              constrainedToSize:CGSizeMake(kScreenWidth-15.f-15.f,MAXFLOAT)
                  lineBreakMode:NSLineBreakByWordWrapping];
        
        if (cell) {
            cell.admCommentLbl.frame = CGRectMake(15, marginTop, size.width, size.height);
        }
        
//        marginTop += size.height;
    }
    
//    CGSize summarySize = CGSizeZero;
//    NSString *summary = goodsInfo?goodsInfo.summary:cell.summaryLbl.text;
//    if ([summary length]>0) {
//        marginTop += 10;
//        summarySize = [summary sizeWithFont:[UIFont systemFontOfSize:12.f]
//                          constrainedToSize:CGSizeMake(kScreenWidth-15.f-15.f,MAXFLOAT)
//                              lineBreakMode:NSLineBreakByWordWrapping];
//        
//        if (cell) {
//            cell.summaryLbl.frame = CGRectMake(15, marginTop, kScreenWidth-15.f-15.f, summarySize.height);
//        }
//        
//        marginTop += summarySize.height;
//        marginTop += 10.f;
//    }
    
    //限时抢购
    if ((goodsInfo && goodsInfo.isLimitActivity) || (cell && !cell.limitedLbl.hidden)) {
        marginTop += 5.f;
        marginTop+=42;
    }
    marginTop += 55; //likeBtn
    marginTop += 9;
//    marginTop += 10;
    
    if (cell) {
//        cell.likeBtn.frame = CGRectMake(cell.contentView.width-10-cell.likeBtn.width, cell.height-10-cell.likeBtn.height, cell.likeBtn.width, cell.likeBtn.height);
        
        [cell.marketPriceLbl sizeToFit];
        cell.marketPriceLbl.frame = CGRectMake(15, marginTop-13-cell.marketPriceLbl.height, cell.marketPriceLbl.width, cell.marketPriceLbl.height);
        
        [cell.visitNumLbl sizeToFit];
        if (cell.marketPriceLbl.width>0) {
            cell.visitNumLbl.frame = CGRectMake(cell.marketPriceLbl.left+cell.marketPriceLbl.width+10, marginTop-13-cell.visitNumLbl.height, cell.visitNumLbl.width, cell.visitNumLbl.height);
        } else {
            cell.visitNumLbl.frame = CGRectMake(15, marginTop-13-cell.visitNumLbl.height, cell.visitNumLbl.width, cell.visitNumLbl.height);
        }
        
        [cell.shopPriceLbl sizeToFit];
        if ([cell.goodsNameLbl.text length]>0) {
            cell.shopPriceLbl.frame = CGRectMake(20, cell.goodsNameLbl.bottom+10, cell.shopPriceLbl.width, cell.shopPriceLbl.height);
        } else {
            cell.shopPriceLbl.frame = CGRectMake(20, cell.gradeLbl.bottom+10, cell.shopPriceLbl.width, cell.shopPriceLbl.height);
        }
        
        if (!cell.discountTagLbl.hidden) {
            [cell.discountTagLbl sizeToFit];
            cell.discountTagLbl.frame = CGRectMake(cell.shopPriceLbl.right+5, cell.shopPriceLbl.top+3, cell.discountTagLbl.width+10, cell.discountTagLbl.height - 10);
        } else {
            
        }
//        cell.discountTagLbl.layer.masksToBounds = YES;
//        cell.discountTagLbl.layer.cornerRadius = 2;//cell.discountTagLbl.height/2;
        cell.discountTagLbl.titleLabel.textAlignment = NSTextAlignmentCenter;
        cell.LimittimeView.frame = CGRectMake(20, cell.shopPriceLbl.bottom+5, kScreenWidth-30, 42);
        cell.limitedLbl.frame = CGRectMake(30, 10, kScreenWidth-45, 16);
        cell.limittimeLockImageView.frame = CGRectMake(13, 21-7, 14, 14);
         CGSize size = [cell.limitedLbl.titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.f],NSFontAttributeName, nil]];
        cell.LimittimeView.frame = CGRectMake(20, cell.shopPriceLbl.bottom+5, kScreenWidth-30, 20+size.height);
        cell.limittimeLockImageView.frame = CGRectMake(13, cell.LimittimeView.height/2-7, 14, 14);
        
        cell.marketPriceLbl.frame = CGRectMake(cell.shopPriceLbl.right + 5, cell.shopPriceLbl.top + 5, cell.marketPriceLbl.width, cell.marketPriceLbl.height);
//        cell.expectedDeliveryLbl.frame = CGRectMake(cell.shopPriceLbl.left, cell.shopPriceLbl.bottom + 6, cell.expectedDeliveryLbl.width, cell.expectedDeliveryLbl.height);
        cell.discountTagLbl.frame = CGRectMake(cell.marketPriceLbl.right+5, cell.shopPriceLbl.top+6, cell.discountTagLbl.width+5, cell.discountTagLbl.height);
        cell.discountTagLbl.layer.cornerRadius = (cell.discountTagLbl.height)/2;
//        if (!cell.discountTagLbl.hidden) {
//            [cell.expectedDeliveryLbl sizeToFit];
//            cell.expectedDeliveryLbl.frame = CGRectMake(cell.discountTagLbl.right+10, cell.discountTagLbl.top, cell.expectedDeliveryLbl.width, cell.discountTagLbl.height);
//        } else {
//            [cell.expectedDeliveryLbl sizeToFit];
//            cell.expectedDeliveryLbl.frame = CGRectMake(cell.marketPriceLbl.right+10, cell.shopPriceLbl.top, cell.expectedDeliveryLbl.width, cell.shopPriceLbl.height);
//        }
//        if (cell.expectedDeliveryLbl.hidden == YES) {
//            cell.visitNumLbl.frame = CGRectMake(cell.shopPriceLbl.left, cell.shopPriceLbl.bottom + 6, cell.visitNumLbl.width, cell.visitNumLbl.height);
//        } else {
//            cell.visitNumLbl.frame = CGRectMake(cell.expectedDeliveryLbl.right + 5, cell.shopPriceLbl.bottom + 6, cell.visitNumLbl.width, cell.visitNumLbl.height);
//        }
        if ([comment length]>0) {
            CGSize size = [comment sizeWithFont:[UIFont boldSystemFontOfSize:14.f]
                              constrainedToSize:CGSizeMake(kScreenWidth-15.f-15.f,MAXFLOAT)
                                  lineBreakMode:NSLineBreakByWordWrapping];
            
            if (cell) {
                if (cell.LimittimeView.hidden == NO) {
                    cell.admCommentLbl.frame = CGRectMake(20, cell.LimittimeView.bottom+5, size.width, size.height);
                } else {
                    cell.admCommentLbl.frame = CGRectMake(20, cell.shopPriceLbl.bottom+5, size.width, size.height);
                }
                cell.admCommentLbl.hidden = YES;
            }
        }
    }
    
    return marginTop;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
            
            self.goodsInfo = goodsInfo;
            
            if (goodsInfo.marketDesc && goodsInfo.marketDesc.length > 0) {
                self.storeIcon.hidden = NO;
                self.storeIcon.text = goodsInfo.marketDesc;
            }else{
                self.storeIcon.hidden = YES;
            }

            [_gradeLbl setTitle:[NSString stringWithFormat:@"%@ >",goodsInfo.gradeTag.name] forState:UIControlStateNormal];
            _goodsNameLbl.text = goodsInfo.goodsName;
//            _summaryLbl.text = goodsInfo.summary;
            
            if ([goodsInfo.admComment length]>0) {
                _admCommentLbl.hidden = NO;
                _admCommentLbl.text = goodsInfo.admComment;
            } else {
                _admCommentLbl.text = nil;
                _admCommentLbl.hidden = YES;
            }
            
            if (goodsInfo.meowReduceTitle.length > 0) {
                _shopPriceLbl.text = goodsInfo.meowReduceTitle;
            }else{
                _shopPriceLbl.text = [NSString stringWithFormat:@"¥ %@",[GoodsInfo formatPriceString:goodsInfo.shopPrice]];
            }
            
            if (goodsInfo.marketPrice>0) {
                NSString *marketPriceString =  [NSString stringWithFormat:@"¥ %@",[GoodsInfo formatPriceString:goodsInfo.marketPrice]];
                NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:marketPriceString];
                [attrString addAttribute:NSStrikethroughStyleAttributeName
                                   value:[NSNumber numberWithInteger:NSUnderlinePatternSolid|NSUnderlineStyleSingle]
                                   range:NSMakeRange(0, attrString.length)];
                _marketPriceLbl.attributedText = attrString;
                _marketPriceLbl.hidden = NO;
            } else {
                _marketPriceLbl.hidden = YES;
            }
            
//            _visitNumLbl.text = [NSString stringWithFormat:@"%@次浏览",[GoodsInfo formatVisitNumString:goodsInfo.stat.visitNum]];
            
            if (goodsInfo.marketPrice>0 && goodsInfo.shopPrice>0
                && goodsInfo.shopPrice<goodsInfo.marketPrice) {
                _discountTagLbl.hidden = NO;
//                [_discountTagLbl setTitle:[NSString stringWithFormat:@"%.f%%OFF",(1-goodsInfo.shopPrice/goodsInfo.marketPrice)*100.f] forState:UIControlStateDisabled];
                [_discountTagLbl setTitle:[NSString stringWithFormat:@"%.2f折", (goodsInfo.shopPrice/goodsInfo.marketPrice)*10] forState:UIControlStateDisabled];
            } else {
                _discountTagLbl.hidden = YES;
            }
            
            if (goodsInfo.expected_delivery_type>0) {
                _expectedDeliveryLbl.hidden = NO;
                _expectedDeliveryLbl.text = [GoodsInfo expected_delivery_desc_for_detail:goodsInfo.expected_delivery_type];
            } else {
                _expectedDeliveryLbl.hidden = YES;
            }
            
//            [_likeBtn setTitle:[GoodsInfo formatLikeNumString:goodsInfo.stat.likeNum] forState:UIControlStateNormal];
//            _likeBtn.selected = goodsInfo.isLiked;
            
            if (goodsInfo.isLimitActivity && goodsInfo.activityBaseInfo && !goodsInfo.activityBaseInfo.isFinished && (goodsInfo.status == GOODS_STATUS_ON_SALE|| goodsInfo.status == GOODS_STATUS_LOCKED)) {
                [[ActivityInfoManager sharedInstance] storeData:goodsInfo.activityBaseInfo];
                _limitedLbl.hidden = NO;
                _LimittimeView.hidden = NO;
                _limittimeLockImageView.hidden = NO;
                self.shopPriceLbl.textColor = [UIColor colorWithHexString:@"f9384c"];
            } else {
                _limitedLbl.hidden = YES;
                _LimittimeView.hidden = YES;
                _limittimeLockImageView.hidden = YES;
                self.shopPriceLbl.textColor = [UIColor colorWithHexString:@"f9384c"];
            }
            
            self.seeNumLbl.text = [NSString stringWithFormat:@"%ld人浏览", goodsInfo.stat.visitNum];
            
//            CGFloat margin = 15;
//            for (int i = 0; i < goodsInfo.serviceIcon.count; i++) {
//                NSString *titile = goodsInfo.serviceIcon[i];
//                UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
//                lbl.tag = i+1000;
//                lbl.font = [UIFont systemFontOfSize:9.f];
//                lbl.textColor = [UIColor colorWithHexString:@"333333"];
//                lbl.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
//                lbl.layer.borderWidth = 0.5;
//                lbl.text = titile;
//                [lbl sizeToFit];
//                [self.contentView addSubview:lbl];
//                lbl.frame = CGRectMake(margin, self.goodsNameLbl.bottom+5, lbl.width+4, lbl.height+4);
//                margin += lbl.width;
//            }
            
            [self updateLimitLbl];

            [self setNeedsLayout];
        }
    }
}

- (void)activityInfoManagerTickNotification
{
    [self updateLimitLbl];
}

- (void)updateLimitLbl
{
    if (_goodsInfo.isLimitActivity && _goodsInfo.activityBaseInfo && !_goodsInfo.activityBaseInfo.isFinished && (_goodsInfo.status == GOODS_STATUS_ON_SALE|| _goodsInfo.status == GOODS_STATUS_LOCKED)) {
        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970]*1000;
        
        if (_goodsInfo.activityBaseInfo.startTime > a) {
            [_limitedLbl setTitle:[NSString stringWithFormat:@"将于%@ 以特价销售¥%.2f %@", [NSDate stringForTimestampSince1970:_goodsInfo.activityBaseInfo.startTime], _goodsInfo.activityBaseInfo.activityPrice,_goodsInfo.activityBaseInfo.activityDesc] forState:UIControlStateDisabled];//@"限时抢购 %@:%@:%@"
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"将于%@ 以特价销售¥%.2f %@",[NSDate stringForTimestampSince1970:_goodsInfo.activityBaseInfo.startTime], _goodsInfo.activityBaseInfo.activityPrice, _goodsInfo.activityBaseInfo.activityDesc]];
            NSRange range=[[hintString string] rangeOfString:[NSString stringWithFormat:@"¥%.2f",_goodsInfo.activityBaseInfo.activityPrice]];
            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
            [_limitedLbl setAttributedTitle:hintString forState:UIControlStateNormal];
            
            if (_goodsInfo.status == GOODS_STATUS_LOCKED) {
                //            UIImage *img = [UIImage imageNamed:@"goods_tag_limited_red_bg_gray"];
                //            [_limitedLbl setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
            } else {
                //            UIImage *img = [UIImage imageNamed:@"goods_tag_limited_red_bg"];
                //            [_limitedLbl setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
            }
        } else {
            [_limitedLbl setTitle:[NSString stringWithFormat:@"仅剩%@小时%@分%@秒 恢复日常价¥%.2f %@",_goodsInfo.activityBaseInfo.remainHoursString,_goodsInfo.activityBaseInfo.remainMinutesString,_goodsInfo.activityBaseInfo.remainSecondsString, _goodsInfo.activityBaseInfo.originShopPrice,_goodsInfo.activityBaseInfo.activityDesc] forState:UIControlStateDisabled];//@"限时抢购 %@:%@:%@"
            
            NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"仅剩%@小时%@分%@秒 恢复日常价¥%.2f %@",_goodsInfo.activityBaseInfo.remainHoursString,_goodsInfo.activityBaseInfo.remainMinutesString,_goodsInfo.activityBaseInfo.remainSecondsString, _goodsInfo.activityBaseInfo.originShopPrice,_goodsInfo.activityBaseInfo.activityDesc]];
            
            NSRange range=[[hintString string] rangeOfString:[NSString stringWithFormat:@"¥%.2f",_goodsInfo.activityBaseInfo.originShopPrice]];
            [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
             [_limitedLbl setAttributedTitle:hintString forState:UIControlStateNormal];
            
            if (_goodsInfo.status == GOODS_STATUS_LOCKED) {
                //            UIImage *img = [UIImage imageNamed:@"goods_tag_limited_red_bg_gray"];
                //            [_limitedLbl setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
            } else {
                //            UIImage *img = [UIImage imageNamed:@"goods_tag_limited_red_bg"];
                //            [_limitedLbl setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
            }
        }
    } else {
        [_limitedLbl setTitle:[NSString stringWithFormat:@"仅剩0小时0分0秒 %@", _goodsInfo.activityBaseInfo.activityDesc] forState:UIControlStateDisabled];//限时抢购 00:00:00
//        UIImage *img = [UIImage imageNamed:@"goods_tag_limited_red_bg_gray"];
//        [_limitedLbl setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
        [[ActivityInfoManager sharedInstance] addObserver:self];
    }
}

@end

@interface GoodsDetailAppoveTagsCell ()
@property(nonatomic,weak) UIView *tagsView;
@property(nonatomic,weak) CommandButton *moreBtn;
//@property (nonatomic, strong) UIView *segView;
//@property (nonatomic, strong) UIView *segViewBottom;
@end

@implementation GoodsDetailAppoveTagsCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsDetailAppoveTagsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 56.f;
    CGFloat X = 15;
    CGFloat Y = 10;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
            NSArray *array = [goodsInfo approveTags];
            for (NSInteger i=0;i<array.count;i++) {
                CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectZero];
                btn.hidden = YES;
                btn.enabled = NO;
                btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [btn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateDisabled];
                [btn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateDisabled];
                [btn sizeToFit];
                
                btn.frame = CGRectMake(X, Y, btn.width + 20, btn.height);
                X += btn.width+20;
                if (X + btn.width >= kScreenWidth-12-15) {
                    X = 15;
                    Y += 30;
                    if (kScreenWidth == 320) {
                        height += 30;
                    } else {
                        height += 20;
                    }
                }
            }
        }
        
    }

    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsDetailAppoveTagsCell class]];
    if (item)[dict setObject:item forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"item";
}

- (void)dealloc
{
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
//        _segView = [[UIView alloc] initWithFrame:CGRectZero];
//        _segView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//        [self.contentView addSubview:_segView];
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        UIView *tagsView = [[UIView alloc] initWithFrame:CGRectNull];
        _tagsView = tagsView;
        [self.contentView addSubview:_tagsView];
        

//        _segViewBottom = [[UIView alloc] initWithFrame:CGRectZero];
//        _segViewBottom.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//        [self.contentView addSubview:_segViewBottom];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    for (UIView *view in [_tagsView subviews]) {
        view.hidden = YES;
    }
    _tagsView.frame = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //    [[self class] calculateHeightAndLayoutSubviews:self item:nil];
    _tagsView.frame = self.contentView.bounds;
//    _tagsView.backgroundColor =[UIColor redColor];
    
//    _segView.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
//    _segViewBottom.frame = CGRectMake(0, self.contentView.height - 1, kScreenWidth, 0.5);
    NSArray *subviews = [_tagsView subviews];
    if ([subviews count]>0) {
        NSInteger maxCount = [subviews count]>3?3:[subviews count];
        CGFloat X = 15;
        CGFloat Y = 20;
        CGFloat width = (self.contentView.width)/maxCount;
        for (UIView *view in subviews) {
            if (view != _moreBtn) {
                view.frame = CGRectMake(X, Y, view.width + 20, view.height);
                X += view.width;
                if (X + view.width > kScreenWidth-12-15) {
                    Y = 10;
                    X = 15;
                    Y += 30;
                }
            }
        }
        
        _moreBtn.frame = CGRectMake(_tagsView.width-15-60, 0, 60, _tagsView.height);
    }
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
            
            NSArray *array = goodsInfo.certTags;//[goodsInfo approveTags];
            NSInteger tagCount = [array count];//>3?3:[array count];
            
            NSArray *subviews = [_tagsView subviews];
            for (UIView *view in subviews) {
                [view removeFromSuperview];
            }
            for (NSInteger i=0;i<tagCount;i++) {
                CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectZero];
                btn.hidden = YES;
                btn.enabled = NO;
                btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
                btn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [btn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateDisabled];
                [btn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateDisabled];
                [_tagsView addSubview:btn];
            }
            
            for (NSInteger i=0;i<tagCount;i++) {
                ApproveTagInfo *tag = [array objectAtIndex:i];
                if ([tag isKindOfClass:[ApproveTagInfo class]]) {
                    CommandButton *btn = (CommandButton*)[_tagsView.subviews objectAtIndex:i];
                    UIImage *icon = [tag localTagIcon];
                    if (!icon) {
                        icon=[UIImage imageNamed:@"goods_New_appove_tag_common"];
                    }
                    
//                    [btn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:tag.iconUrl]]] forState:UIControlStateDisabled];
//                    [btn sd_setImageWithURL:[NSURL URLWithString:tag.iconUrl] forState:UIControlStateDisabled];//[tag localTagIcon]
                    [btn setImage:[UIImage imageNamed:@"GoodsTagsIcon"] forState:UIControlStateNormal];
//                    btn.imageView.frame = CGRectMake(btn.imageView.frame.origin.x, btn.imageView.frame.origin.y, 14, 14);
                    [btn setTitle:tag.name forState:UIControlStateDisabled];
                    btn.hidden = NO;
                    [btn sizeToFit];
//                    if ([tag.iconUrl length]>0) {
//                        [btn sd_setImageWithURL:[NSURL URLWithString:tag.iconUrl] forState:UIControlStateDisabled placeholderImage:[UIImage imageNamed:@"tag_placeholder"]];
//                    }
                }
            }
            
            CommandButton *moreBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
            [moreBtn setImage:[UIImage imageNamed:@"omit"] forState:UIControlStateNormal];
            [_tagsView addSubview:moreBtn];
            moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            _moreBtn = moreBtn;
            [self setNeedsLayout];
            
            WEAKSELF;
            moreBtn.handleClickBlock = ^(CommandButton *sender) {
                if (weakSelf.handleMoreBtnClicked) {
                    weakSelf.handleMoreBtnClicked();
                }
            };
        }
    }
}

@end


@interface GoodsDetailServeTagsCell ()
@property(nonatomic,weak) UIView *tagsView;
@property(nonatomic,weak) CommandButton *moreBtn;

@end

@implementation GoodsDetailServeTagsCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsDetailServeTagsCell class]);
    });
    return __reuseIdentifier;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo*)detailInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsDetailServeTagsCell class]];
    if (detailInfo)[dict setObject:detailInfo forKey:[self cellDictKeyForGoodsInfo]];
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"detailInfo";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        UIView *tagsView = [[UIView alloc] initWithFrame:CGRectNull];
        _tagsView = tagsView;
        [self.contentView addSubview:_tagsView];
    }
    return self;
}


- (void)updateCellWithDict:(NSDictionary *)dict
{
    if ([dict isKindOfClass:[NSDictionary class]]) {
        GoodsDetailInfo *detailInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
        if ([detailInfo isKindOfClass:[GoodsDetailInfo class]]) {
            
            NSArray *array = detailInfo.goodsInfo.seller.autotrophyGoodsVo.promiseList;
            NSInteger tagCount = [array count];//>3?3:[array count];
            
            NSArray *subviews = [_tagsView subviews];
            for (UIView *view in subviews) {
                [view removeFromSuperview];
            }
            for (NSInteger i=0;i<tagCount;i++) {
                PromiseVo *tag = [array objectAtIndex:i];
                ServerTag *btn = [[ServerTag alloc] initWithFrame:CGRectZero title:tag.entry imageUrl:tag.url];
                [btn sizeToFit];
                [_tagsView addSubview:btn];
                
            }
            
            CommandButton *moreBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
            [moreBtn setImage:[UIImage imageNamed:@"omit"] forState:UIControlStateNormal];
            [_tagsView addSubview:moreBtn];
            moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
            _moreBtn = moreBtn;
            [self setNeedsLayout];
            
            WEAKSELF;
            moreBtn.handleClickBlock = ^(CommandButton *sender) {
                if (weakSelf.handleMoreBtnClicked) {
                    weakSelf.handleMoreBtnClicked();
                }
            };

        }
    }
}


- (void)layoutSubviews {
    [super layoutSubviews];
    _tagsView.frame = self.contentView.bounds;
    NSArray *subviews = [_tagsView subviews];
    if ([subviews count]>0) {
//        NSInteger maxCount = [subviews count]>3?3:[subviews count];
        CGFloat X = 15;
        CGFloat Y = 10;
//        CGFloat width = (self.contentView.width)/maxCount;
        for (UIView *view in subviews) {
            if (view != _moreBtn) {
                view.frame = CGRectMake(X, Y, view.width + 20+20+20, view.height);
                X += view.width;
                if (X + view.width > kScreenWidth-12-15) {
                    Y = 10;
                    X = 15;
                    Y += 30;
                }
            }
        }
        
        _moreBtn.frame = CGRectMake(_tagsView.width-15-60, 0, 60, _tagsView.height);
    }
}



+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 56.f;
    CGFloat X = 15;
    CGFloat Y = 10;
    if ([dict isKindOfClass:[NSDictionary class]]) {
        GoodsDetailInfo *detailInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
        if ([detailInfo isKindOfClass:[GoodsDetailInfo class]]) {
            NSArray *array = detailInfo.goodsInfo.seller.autotrophyGoodsVo.promiseList;
            for (NSInteger i=0;i<array.count;i++) {
                PromiseVo *tag = [array objectAtIndex:i];
                ServerTag *btn = [[ServerTag alloc] initWithFrame:CGRectZero title:tag.entry imageUrl:tag.url];
                btn.hidden = YES;
                btn.enabled = NO;
                [btn sizeToFit];
                
                btn.frame = CGRectMake(X, Y, btn.width + 20, btn.height);
                X += btn.width+20;
                if (X + btn.width >= kScreenWidth-12-15) {
                    X = 15;
                    Y += 30;
                    if (kScreenWidth == 320) {
                        height += 30;
                    } else {
                        height += 20;
                    }
                }
            }
        }
        
    }
    
    return height;
}


@end

//@interface GoodsDetailAppoveTagsCell ()
//@property(nonatomic,strong) UIView *tagsView;
//@end
//
//@implementation GoodsDetailAppoveTagsCell
//
//+ (NSString *)reuseIdentifier {
//    static NSString *__reuseIdentifier = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        __reuseIdentifier = NSStringFromClass([GoodsDetailAppoveTagsCell class]);
//    });
//    return __reuseIdentifier;
//}
//
//+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
//    CGFloat height = 105.f;
//    return height;
//}
//
//+ (NSMutableDictionary*)buildCellDict:(GoodsInfo*)item
//{
//    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsDetailAppoveTagsCell class]];
//    if (item)[dict setObject:item forKey:[self cellDictKeyForGoodsInfo]];
//    return dict;
//}
//
//+ (NSString*)cellDictKeyForGoodsInfo {
//    return @"item";
//}
//
//- (void)dealloc
//{
//    
//}
//
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
//        _tagsView = [[UIView alloc] initWithFrame:CGRectNull];
//        [self.contentView addSubview:_tagsView];
//    }
//    return self;
//}
//
//- (void)prepareForReuse {
//    [super prepareForReuse];
//    
//    for (UIView *view in [_tagsView subviews]) {
//        view.hidden = YES;
//    }
//    _tagsView.frame = CGRectZero;
//}
//
//- (void)layoutSubviews {
//    [super layoutSubviews];
////    [[self class] calculateHeightAndLayoutSubviews:self item:nil];
//    _tagsView.frame = self.contentView.bounds;
//    
//    
//    NSArray *subviews = [_tagsView subviews];
//    if ([subviews count]>0) {
//        NSInteger maxCount = [subviews count]>4?4:[subviews count];
//        CGFloat X = 0;
//        CGFloat width = (self.contentView.width)/maxCount;
//        for (UIView *view in subviews) {
//            view.frame = CGRectMake(X, 15, width, 72);
//            X += view.width;
//        }
//    }
//}
//
//- (void)updateCellWithDict:(NSDictionary *)dict
//{
//    if ([dict isKindOfClass:[NSDictionary class]]) {
//        GoodsInfo *goodsInfo = [dict objectForKey:[[self class] cellDictKeyForGoodsInfo]];
//        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
//            
//            NSArray *array = [goodsInfo approveTags];
//            
//            NSArray *subviews = [_tagsView subviews];
//            NSInteger count = [subviews count];
//            for (NSInteger i=count;i<[array count];i++) {
//                VerticalCommandButton *btn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
//                btn.hidden = YES;
//                btn.enabled = NO;
//                btn.imageTextSepHeight = 8.f;
//                btn.titleLabel.font = [UIFont systemFontOfSize:11.f];
//                [btn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateDisabled];
//                [btn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateDisabled];
//                [_tagsView addSubview:btn];
//            }
//            
//            NSInteger tagCount = [array count]>4?4:[array count];
//            for (NSInteger i=0;i<tagCount;i++) {
//                ApproveTagInfo *tag = [array objectAtIndex:i];
//                if ([tag isKindOfClass:[ApproveTagInfo class]]) {
//                    VerticalCommandButton *btn = (VerticalCommandButton*)[_tagsView.subviews objectAtIndex:i];
//                    [btn setImage:[tag localTagIcon] forState:UIControlStateDisabled];
//                    [btn setTitle:tag.name forState:UIControlStateDisabled];
//                    btn.hidden = NO;
//                    if ([tag.iconUrl length]>0) {
//                        [btn sd_setImageWithURL:[NSURL URLWithString:tag.iconUrl] forState:UIControlStateDisabled placeholderImage:[UIImage imageNamed:@"tag_placeholder"]];
//                    }
//                }
//            }
//            
//            [self setNeedsLayout];
//        }
//    }
//}
//
//@end


@implementation GoodsRecommendSepCell {
    UILabel *_titleLbl;
    CALayer *_leftLine;
    UIView *_rightLine;
    UILabel *_contentLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsRecommendSepCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 50;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsRecommendSepCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];//colorWithHexString:@"f1f1ed"];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.textColor = [UIColor colorWithHexString:@"595959"];
        _titleLbl.text = @"猜您喜欢";
        [self.contentView addSubview:_titleLbl];
        
//        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        _contentLbl.font = [UIFont systemFontOfSize:14.f];
//        _contentLbl.textAlignment = NSTextAlignmentLeft;
//        _contentLbl.textColor = [UIColor colorWithHexString:@"bebebe"];
//        _contentLbl.text = @"丨Guess you like";
//        [self.contentView addSubview:_contentLbl];
        
        _leftLine = [CALayer layer];
        _leftLine.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"].CGColor;
        [self.contentView.layer addSublayer:_leftLine];
        
        _rightLine = [[UIView alloc] initWithFrame:CGRectZero];;
        _rightLine.backgroundColor = [UIColor colorWithHexString:@"d5d5d5"];
        [self.contentView addSubview:_rightLine];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLbl sizeToFit];
    [_contentLbl sizeToFit];
    _titleLbl.frame = CGRectMake((self.contentView.width-_titleLbl.width)/2, (self.contentView.height-_titleLbl.height)/2+2, _titleLbl.width, _titleLbl.height);
    
    _leftLine.frame = CGRectMake(_titleLbl.left-36-12, _titleLbl.top+(_titleLbl.height-1.f)/2, 36, 1);
    _rightLine.frame = CGRectMake(_titleLbl.right+12, _titleLbl.top+(_titleLbl.height-1.f)/2, 36, 1);
//    _rightLine.frame = CGRectMake(0, self.bottom-0.5, kScreenWidth, 0.5);
    
//    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.left.equalTo(self.contentView.mas_left).offset(14);
//    }];
//    
//    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.left.equalTo(_titleLbl.mas_right).offset(5);
//    }];
//    
//    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.equalTo(self.contentView.mas_bottom);
//        make.left.equalTo(self.contentView.mas_left);
//        make.right.equalTo(self.contentView.mas_right);
//        make.height.equalTo(@0.5);
//    }];
}

@end

@implementation GoodsAttributesButtonCell {
    UILabel *_titleLbl;
    UIImageView *_rightArrowView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsAttributesButtonCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 44;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsAttributesButtonCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.textColor = [UIColor colorWithHexString:@"282828"];
        _titleLbl.text = @"商品参数";
        [self.contentView addSubview:_titleLbl];
        
        _rightArrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow_gray"]];
        [self.contentView addSubview:_rightArrowView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLbl sizeToFit];
    _titleLbl.frame = CGRectMake(15, 0, _titleLbl.width, self.contentView.height);
    
    _rightArrowView.frame = CGRectMake(self.contentView.width-15-_rightArrowView.width, (self.contentView.height-_rightArrowView.height)/2, _rightArrowView.width, _rightArrowView.height);
}

@end


@interface GoodsTagsCell ()
@property(nonatomic,strong) GoodsTagsView *tagsView;
@property (nonatomic, strong) UIView *segView;
@property (nonatomic, strong) UIView *segBottomView;
@property (nonatomic, strong) NSString *gradeName;
@end

@implementation GoodsTagsCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsTagsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat height = 0.f;
    NSArray *tagList = [dict objectForKey:[self cellDictKeyForTagList]];
    GoodsInfo *goodsInfo = dict[@"goodsInfo"];
    
    //全新更改位置  在这个标签显示的位置添加一个元素 实现效果
    TagVo *tagVo = [[TagVo alloc] init];
    tagVo.tagName = goodsInfo.gradeTag.name;
    NSMutableArray *arr = [NSMutableArray arrayWithObject:tagVo];
    [arr addObjectsFromArray:tagList];
    
    if ([tagList isKindOfClass:[NSArray class]]
        && [tagList count]>0) {
        height = [GoodsTagsView heightForOrientationPortrait:arr];
        height += 15;
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSArray*)tagList goodsInfo:(GoodsInfo *)goodsInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsTagsCell class]];
    if (tagList)[dict setObject:tagList forKey:[self cellDictKeyForTagList]];
    if (goodsInfo) {
        [dict setObject:goodsInfo forKey:@"goodsInfo"];
    }
    return dict;
}

+ (NSString*)cellDictKeyForTagList {
    return @"tagList";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"282828"];
        
        _tagsView = [[GoodsTagsView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_tagsView];
        _segView = [[UIView alloc] initWithFrame:CGRectZero];
        _segView.backgroundColor = [UIColor colorWithHexString:@"cdcdcd"];
        [self.contentView addSubview:_segView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _tagsView.frame = CGRectMake(0, 0, self.contentView.width, self.contentView.height-10);
    _segView.frame = CGRectMake(0, 0, kScreenWidth, 1);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    GoodsInfo *goodsInfo = dict[@"goodsInfo"];
    
    NSArray *tagList = [dict objectForKey:[[self class] cellDictKeyForTagList]];
    if ([tagList isKindOfClass:[NSArray class]]
        && [tagList count]>0) {
        [_tagsView updateWithTagList:tagList grade:goodsInfo.gradeTag.name];
        [self setNeedsLayout];
    }
}

@end

@interface GoodsTagsView ()



@end

@implementation GoodsTagsView



- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

+ (CGFloat)heightForOrientationPortrait:(NSArray*)tagList {
    
    CGFloat height = 0;
    
    NSInteger itemHeight = [[self class] itemHeight];
    CGFloat X = 15.f;
    CGFloat Y = 0.f;
    
    if ([tagList count]>0) {
        for (NSInteger i=0;i<[tagList count];i++) {
            TagVo *tagVo = (TagVo*)tagList[i];
            if (tagVo.tagName.length>0) {
                CGSize size = [tagVo.tagName sizeWithFont:[UIFont systemFontOfSize:12.f]];
                size.width += 20;
                if (X+size.width+15>kScreenWidth) {
                    X = 15;
                    Y += itemHeight;
                    Y += 5;
                }
                X += size.width;
                X += 10;
            }
        }
        height = Y+itemHeight;
    }
    
    return height;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    NSInteger itemHeight = [[self class] itemHeight];
    CGFloat X = 15.f;
    CGFloat Y = 0.f;
    for (CommandButton *btn in self.subviews) {
        CGSize size = [[btn titleForState:UIControlStateNormal] sizeWithFont:btn.titleLabel.font];
        size.width += 20;
        if (X+size.width+15>kScreenWidth) {
            X = 15;
            Y += itemHeight;
            Y += 5;
        }
        btn.frame = CGRectMake(X, Y + 7, size.width, itemHeight);
        X += btn.width;
        X += 10;
    }
}
+ (NSInteger)itemHeight {
    return 25.f*kScreenWidth/320.f+0.5;;
}

- (void)updateWithTagList:(NSArray*)tagList grade:(NSString *)gradeName
{
    
    for (UIView *view in [self subviews]) {
        view.hidden = YES;
    }
    if ([tagList count]>0) {
        //全新更改位置  在这个标签显示的位置添加一个元素 实现效果
        TagVo *tagVo = [[TagVo alloc] init];
        tagVo.tagName = gradeName;
        NSMutableArray *arr = [NSMutableArray arrayWithObject:tagVo];
        [arr addObjectsFromArray:tagList];
        
        NSInteger count = [self subviews].count;
        for (NSInteger i=count;i<[arr count];i++) {
            NSInteger itemHeight = [[self class] itemHeight];
            CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 0, itemHeight)];
            btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
            btn.backgroundColor = [UIColor whiteColor];//[UIColor colorWithHexString:@"181818"];
            if (i == 0) {
                [btn setTitleColor:[UIColor colorWithHexString:@"150c0f"] forState:UIControlStateNormal]; //colorWithHexString:@"666666"
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;//itemHeight/5.f;
                btn.layer.borderWidth = 0.5;
                //添加边框
                [btn.layer setBorderColor:[UIColor colorWithHexString:@"150c0f"].CGColor];
                [btn.layer setBorderWidth:1];
                [btn.layer setMasksToBounds:YES];
            } else {
                [btn setTitleColor:[UIColor colorWithHexString:@"b7b7b7"] forState:UIControlStateNormal]; //colorWithHexString:@"666666"
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 5;//itemHeight/5.f;
                btn.layer.borderWidth = 0.5;
                //添加边框
                [btn.layer setBorderColor:[UIColor colorWithHexString:@"b3b3b3"].CGColor];
                [btn.layer setBorderWidth:1];
                [btn.layer setMasksToBounds:YES];
            }
            btn.tag = i;
            btn.hidden = YES;
            [self addSubview:btn];
            
            btn.handleClickBlock = ^(CommandButton *sender) {
                if ([sender.userData isKindOfClass:[TagVo class]]) {
                    TagVo *tagVo = (TagVo*)(sender.userData);
                    if (btn.tag == 0) {
                        //成色解释页面
                        [URLScheme locateWithHtml5Url:@"http://activity.aidingmao.com/share/page/66" andIsShare:YES];
                    } else {
                        if ([tagVo.redirectUri length]>0) {
                            [URLScheme locateWithRedirectUri:tagVo.redirectUri andIsShare:YES];
                        }
                    }
                }
            };
        }
        
        for (NSInteger i=0;i<[arr count];i++) {
            TagVo *tagVo = (TagVo*)arr[i];
            if ([tagVo.tagName length]>0) {
                TagVo *tagVo = (TagVo*)arr[i];
                CommandButton *btn = (CommandButton*)[[self subviews] objectAtIndex:i];
                btn.userData = tagVo;
                [btn setTitle:tagVo.tagName forState:UIControlStateNormal];
                btn.hidden = NO;
            }
        }
        
        [self setNeedsLayout];
    }
}

@end

@interface GoodsCommentTitleCell () <UITextFieldDelegate>

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, weak) UIButton *momentBtn;

@end


@implementation GoodsCommentTitleCell {
    UILabel *_titleLbl;
    CommandButton *_addCommentBtn;
    CALayer *_bottomLine;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsCommentTitleCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 44;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo*)item
{
    
    
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsCommentTitleCell class]];
    if (item){
        [dict setObject:item forKey:[self cellDictKeyForGoodsInfo]];
    }
    return dict;
}

+ (NSString*)cellDictKeyForGoodsInfo {
    return @"item";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.delegate = self;
        [_textField setBorderStyle:UITextBorderStyleRoundedRect];
        _textField.font = [UIFont systemFontOfSize:14.f];
        _textField.placeholder = @"可以写下你对商品的疑问...";
        _textField.layer.borderColor = [UIColor grayColor].CGColor;
        _textField.layer.borderWidth =1.0;
        _textField.layer.cornerRadius =15.0;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 0, 25, 25)];
        imageView.image = [UIImage imageNamed:@"White-MF"];
        _textField.leftView = imageView;
        _textField.leftViewMode = UITextFieldViewModeAlways;
        
//        _textField.leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
//        _textField.leftViewMode = UITextFieldViewModeAlways;
        [self.contentView addSubview:_textField];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.textColor = [UIColor colorWithHexString:@"babbbb"];
        _titleLbl.text = [NSString stringWithFormat:@"0 人留言"];// 这里需要调用接口
        [self.contentView addSubview:_titleLbl];
        
//        _addCommentBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
//        [_addCommentBtn setTitleColor:[UIColor colorWithHexString:@"282828"] forState:UIControlStateNormal];
//        _addCommentBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//        _addCommentBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//        [_addCommentBtn setImage:[UIImage imageNamed:@" "] forState:UIControlStateNormal];
//        [self.contentView addSubview:_addCommentBtn];
        
        _bottomLine= [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
        
        UIButton *momentBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [momentBtn addTarget: self action:@selector(clickMomentBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:momentBtn];
        self.momentBtn = momentBtn;
        
        
    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict) {
        NSObject *obj = [dict objectForKey:@"item"];
        if ([obj isKindOfClass:[GoodsDetailInfo class]]) {
            GoodsDetailInfo *goodsDetailInfo = (GoodsDetailInfo*)obj;
            
            _titleLbl.text = [NSString stringWithFormat:@"%ld 人留言", goodsDetailInfo.comment_num];
        }
    }
    [self setNeedsLayout];
}

-(void)clickMomentBtn{
    if ([self.delegateTextField respondsToSelector:@selector(replyTitleCell:)]) {
        [self.delegateTextField replyTitleCell:nil];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
//    if ([self.delegateTextField respondsToSelector:@selector(replyTitleCell:)]) {
//        [self.delegateTextField replyTitleCell:textField];
//    }
//    textField.returnKeyType = UIReturnKeySend;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
//    [textField endEditing:YES];
//    if ([self.delegateTextField respondsToSelector:@selector(replyTitleCell:)]) {
//        [self.delegateTextField replyTitleCell:textField];
//    }
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField resignFirstResponder];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    _momentBtn.frame = CGRectMake(15, 7, self.contentView.width-124, 30);
    
    _textField.frame = CGRectMake(15, 7, self.contentView.width-124, 30);
    _titleLbl.frame = CGRectMake(self.contentView.width - 85, 0, self.contentView.width-75, self.contentView.height);

    
    _bottomLine.frame= CGRectMake(0, self.contentView.height-0.5, self.contentView.width, 0.5);
    
}

@end

@implementation GoodsNoCommentsCell {
    UILabel *_titleLbl;
    UIImageView *_noContentsView;
    CommandButton *_addCommentBtn;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsNoCommentsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 145;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsNoCommentsCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
//        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
//        _titleLbl.font = [UIFont systemFontOfSize:14.f];
//        _titleLbl.textAlignment = NSTextAlignmentCenter;
//        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
//        _titleLbl.text = @"暂无评论";
//        [self.contentView addSubview:_titleLbl];
        
        UIImage *noContentImg = [UIImage imageNamed:@"no_content_icon"];
        
        _noContentsView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, noContentImg.size.width*2/3, noContentImg.size.height*2/3)];
        _noContentsView.image = noContentImg;
        [self.contentView addSubview:_noContentsView];
        
        _addCommentBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_addCommentBtn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        _addCommentBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_addCommentBtn setTitle:@"立即评论" forState:UIControlStateNormal];
        _addCommentBtn.layer.masksToBounds = YES;
        _addCommentBtn.layer.borderColor = [UIColor colorWithHexString:@"bfbfbf"].CGColor;
        _addCommentBtn.layer.borderWidth = 0.5f;
        [self.contentView addSubview:_addCommentBtn];
        
        WEAKSELF;
        _addCommentBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleAddCommentsBlock) {
                weakSelf.handleAddCommentsBlock();
            }
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

//    _titleLbl.frame = self.contentView.bounds;
    
    _noContentsView.frame = CGRectMake((self.contentView.width-_noContentsView.width)/2, 5, _noContentsView.width, _noContentsView.height);
    
    _addCommentBtn.frame = CGRectMake((self.contentView.width-100)/2, self.contentView.height-30-10, 100, 30);
}


@end

@implementation GoodsMoreCommentsCell {
    CALayer *_topLine;
    CommandButton *_moreCommentsBtn;
    
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsMoreCommentsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 47;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsMoreCommentsCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        _moreCommentsBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_moreCommentsBtn setTitle:@"更多留言" forState:UIControlStateNormal];
        [_moreCommentsBtn setTitleColor:[UIColor colorWithHexString:@"676767"] forState:UIControlStateNormal];
        _moreCommentsBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _moreCommentsBtn.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
        _moreCommentsBtn.layer.borderWidth = 0.5f;
        _moreCommentsBtn.layer.masksToBounds = YES;
        
        [self.contentView addSubview:_moreCommentsBtn];
        
        _topLine= [CALayer layer];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.contentView.layer addSublayer:_topLine];
        
        WEAKSELF;
        _moreCommentsBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleMoreCommentsBlock) {
                weakSelf.handleMoreCommentsBlock();
            }
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _topLine.frame= CGRectMake(0, 0, self.contentView.width, 0.5);
    _moreCommentsBtn.frame = CGRectMake((self.width-120)/2, (self.height-27)/2, 120, 27);
}


@end



@implementation GoodsDescribeSepCell
{
    UILabel *_titleLbl;
    CALayer *_leftLine;
    UIView *_rightLine;
    UILabel *_contentLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsDescribeSepCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 50;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsDescribeSepCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];//colorWithHexString:@"f1f1ed"];
        
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textAlignment = NSTextAlignmentLeft;
        _titleLbl.textColor = [UIColor colorWithHexString:@"595959"];
        _titleLbl.text = @"商品描述";
        [self.contentView addSubview:_titleLbl];
        
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:14.f];
        _contentLbl.textAlignment = NSTextAlignmentLeft;
        _contentLbl.textColor = [UIColor colorWithHexString:@"bebebe"];
        _contentLbl.text = @"丨Description";
        [self.contentView addSubview:_contentLbl];
        _rightLine = [[UIView alloc] initWithFrame:CGRectZero];;
        _rightLine.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:_rightLine];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_titleLbl sizeToFit];
    [_contentLbl sizeToFit];
    
    [_titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
    [_contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(_titleLbl.mas_right).offset(5);
    }];
    
    [_rightLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.equalTo(@0.5);
    }];
}


@end


@implementation DealguaranteCell
{
    UILabel *_titleLbl;
    CALayer *_leftLine;
    UIView *_rightLine;
    UILabel *_contentLbl;
    XMWebImageView * _imageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([DealguaranteCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict {
    CGFloat rowHeight = 0;
    NSArray * imageDescGroupItems = [dict arrayValueForKey:@"imageDescGroupItems"];
    if (imageDescGroupItems.count > 0) {
        ImageDescGroup * model = [imageDescGroupItems objectAtIndex:0];
        for (ImageDescDO * imageDescDO in model.items) {
            PictureItem * picItem = imageDescDO.picItem;
            rowHeight = kScreenWidth*picItem.height/picItem.width;
        }
    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(NSArray *)imageDescGroupItems
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[DealguaranteCell class]];
    if (imageDescGroupItems) {
        [dict setObject:imageDescGroupItems forKey:@"imageDescGroupItems"];
    }
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];//colorWithHexString:@"f1f1ed"];
        
        _imageView = [[XMWebImageView alloc] init];
        [self.contentView addSubview:_imageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right);
        make.left.equalTo(self.contentView.mas_left);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

- (void)updateCellWithDict:(NSDictionary *)dict{
    NSArray * imageDescGroupItems = [dict arrayValueForKey:@"imageDescGroupItems"];
    if (imageDescGroupItems.count > 0) {
        ImageDescGroup * model = [imageDescGroupItems objectAtIndex:0];
        for (ImageDescDO * imageDescDO in model.items) {
            PictureItem * picItem = imageDescDO.picItem;
            [_imageView setImageWithURL:picItem.picUrl XMWebImageScaleType:XMWebImageScaleNone];
        }
    }
}

@end




