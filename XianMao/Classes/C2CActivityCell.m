//
//  C2CActivityCell.m
//  XianMao
//
//  Created by apple on 16/12/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "C2CActivityCell.h"
#import "ActivityInfo.h"
#import "RTLabel.h"

@interface C2CActivityCell () <ActivityInfoManagerObserver>

@property (nonatomic, strong) UILabel *limitedLbl;
@property (nonatomic, strong) UIImageView *limitimeImageView;
@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) GoodsInfo *goodsInfo;
@end

@implementation C2CActivityCell

-(UIImageView *)limitimeImageView{
    if (!_limitimeImageView) {
        _limitimeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _limitimeImageView.image = [UIImage imageNamed:@"GoodsDetail_LimittimeLock_MF"];
        [_limitimeImageView sizeToFit];
    }
    return _limitimeImageView;
}

-(UILabel *)limitedLbl{
    if (!_limitedLbl) {
        _limitedLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _limitedLbl.font = [UIFont systemFontOfSize:12.f];
        _limitedLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_limitedLbl sizeToFit];
        _limitedLbl.numberOfLines = 0;
    }
    return _limitedLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([C2CActivityCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait {
    
    CGFloat rowHeight = 44.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo *)goodsInfo{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[C2CActivityCell class]];
    if (goodsInfo) {
        [dict setObject:goodsInfo forKey:@"goodsInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:bgView];
        self.bgView = bgView;
        [self.bgView addSubview:self.limitimeImageView];
        [self.bgView addSubview:self.limitedLbl];
        [[ActivityInfoManager sharedInstance] addObserver:self];
    }
    return self;
}

-(void)dealloc{
    [[ActivityInfoManager sharedInstance] removeObserver:self];
}

-(void)layoutSubviews{
    
    [super layoutSubviews];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.limitimeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.bgView.mas_left).offset(10);
        make.width.equalTo(@14);
        make.height.equalTo(@14);
    }];
    
    [self.limitedLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bgView.mas_centerY);
        make.left.equalTo(self.limitimeImageView.mas_right).offset(5);
        make.right.equalTo(self.bgView.mas_right).offset(-5);
    }];
    
}

- (void)activityInfoManagerTickNotification
{
    [self updateLimitLbl:self.goodsInfo];
}

-(void)updateLimitLbl:(GoodsInfo *)goodsInfo{
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970]*1000;
    
    if (goodsInfo.activityBaseInfo.startTime > a) {
        self.limitedLbl.text = [NSString stringWithFormat:@"将于%@ 以特价销售¥%.2f %@", [NSDate stringForTimestampSince1970:goodsInfo.activityBaseInfo.startTime], goodsInfo.activityBaseInfo.activityPrice, goodsInfo.activityBaseInfo.activityDesc];//@"限时抢购 %@:%@:%@"
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"将于%@ 以特价销售¥%.2f %@",[NSDate stringForTimestampSince1970:goodsInfo.activityBaseInfo.startTime], goodsInfo.activityBaseInfo.activityPrice, goodsInfo.activityBaseInfo.activityDesc]];
        NSRange range=[[hintString string] rangeOfString:[NSString stringWithFormat:@"¥%.2f",goodsInfo.activityBaseInfo.activityPrice]];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        self.limitedLbl.attributedText=hintString;
        
        if (goodsInfo.status == GOODS_STATUS_LOCKED) {
            //            UIImage *img = [UIImage imageNamed:@"goods_tag_limited_red_bg_gray"];
            //            [_limitedLbl setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
        } else {
            //            UIImage *img = [UIImage imageNamed:@"goods_tag_limited_red_bg"];
            //            [_limitedLbl setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
        }
    } else {
        self.limitedLbl.text = [NSString stringWithFormat:@"仅剩%@小时%@分%@秒 恢复日常价¥%.2f %@",goodsInfo.activityBaseInfo.remainHoursString,goodsInfo.activityBaseInfo.remainMinutesString,goodsInfo.activityBaseInfo.remainSecondsString, goodsInfo.activityBaseInfo.originShopPrice,goodsInfo.activityBaseInfo.activityDesc];//@"限时抢购 %@:%@:%@"
        NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"仅剩%@小时%@分%@秒 恢复日常价¥%.2f %@",goodsInfo.activityBaseInfo.remainHoursString,goodsInfo.activityBaseInfo.remainMinutesString,goodsInfo.activityBaseInfo.remainSecondsString, goodsInfo.activityBaseInfo.originShopPrice,goodsInfo.activityBaseInfo.activityDesc]];
        
        NSRange range=[[hintString string] rangeOfString:[NSString stringWithFormat:@"¥%.2f",goodsInfo.activityBaseInfo.originShopPrice]];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
        self.limitedLbl.attributedText=hintString;
        
        if (goodsInfo.status == GOODS_STATUS_LOCKED) {
            //            UIImage *img = [UIImage imageNamed:@"goods_tag_limited_red_bg_gray"];
            //            [_limitedLbl setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
        } else {
            //            UIImage *img = [UIImage imageNamed:@"goods_tag_limited_red_bg"];
            //            [_limitedLbl setBackgroundImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:0] forState:UIControlStateDisabled];
        }
    }
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    GoodsInfo *goodsInfo = [dict objectForKey:@"goodsInfo"];
    self.goodsInfo = goodsInfo;
    [self updateLimitLbl:goodsInfo];
    
}

@end
