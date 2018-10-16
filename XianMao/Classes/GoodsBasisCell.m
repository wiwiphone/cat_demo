//
//  GoodsBasisCell.m
//  XianMao
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsBasisCell.h"
#import "NSDate+Category.h"
#import "UserHomeViewController.h"

@interface GoodsBasisCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *userNameLbl;
@property (nonatomic, strong) UILabel *publishTime;
@property (nonatomic, strong) UILabel *marketPriceLbl;
@property (nonatomic, strong) UIView *markerLineView;
@property (nonatomic, strong) UILabel *nowPriceLbl;
@property (nonatomic, strong) UILabel *goodsNameLbl;
@property (nonatomic, strong) UILabel *detailLbl;

@end

@implementation GoodsBasisCell

-(UILabel *)detailLbl{
    if (!_detailLbl) {
        _detailLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _detailLbl.font = [UIFont systemFontOfSize:15.f];
        _detailLbl.textColor = [UIColor colorWithHexString:@"666666"];
        _detailLbl.numberOfLines = 0;
        [_detailLbl sizeToFit];
    }
    return _detailLbl;
}

-(UILabel *)goodsNameLbl{
    if (!_goodsNameLbl) {
        _goodsNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsNameLbl.font = [UIFont boldSystemFontOfSize:15.f];
        _goodsNameLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_goodsNameLbl sizeToFit];
        _goodsNameLbl.numberOfLines = 0;
    }
    return _goodsNameLbl;
}

-(UILabel *)nowPriceLbl{
    if (!_nowPriceLbl) {
        _nowPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _nowPriceLbl.font = [UIFont systemFontOfSize:15.f];
        _nowPriceLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        [_nowPriceLbl sizeToFit];
    }
    return _nowPriceLbl;
}

-(UIView *)markerLineView{
    if (!_markerLineView) {
        _markerLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _markerLineView.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }
    return _markerLineView;
}

-(UILabel *)marketPriceLbl{
    if (!_marketPriceLbl) {
        _marketPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _marketPriceLbl.font = [UIFont systemFontOfSize:11.f];
        _marketPriceLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_marketPriceLbl sizeToFit];
    }
    return _marketPriceLbl;
}

-(UILabel *)publishTime{
    if (!_publishTime) {
        _publishTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _publishTime.font = [UIFont systemFontOfSize:11.f];
        _publishTime.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_publishTime sizeToFit];
    }
    return _publishTime;
}

-(UILabel *)userNameLbl{
    if (!_userNameLbl) {
        _userNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _userNameLbl.font = [UIFont systemFontOfSize:15.f];
        _userNameLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_userNameLbl sizeToFit];
    }
    return _userNameLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _iconImageView.layer.cornerRadius = 36/2;
        _iconImageView.layer.masksToBounds = YES;
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsBasisCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 90;
    
    GoodsInfo *goodsInfo = dict[@"goodsInfo"];
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl.font = [UIFont systemFontOfSize:15.f];
    lbl.numberOfLines = 0;
    lbl.text = goodsInfo.summary;
    [lbl sizeToFit];
    CGSize size = [lbl sizeThatFits:CGSizeMake(kScreenWidth-24, CGFLOAT_MAX)];
    
    UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl1 = [[UILabel alloc] initWithFrame:CGRectZero];
    lbl1.font = [UIFont systemFontOfSize:15.f];
    lbl1.numberOfLines = 0;
    lbl1.text = goodsInfo.goodsName;
    [lbl1 sizeToFit];
    CGSize size1 = [lbl1 sizeThatFits:CGSizeMake(kScreenWidth-24, CGFLOAT_MAX)];
    
    height += size.height;
    height += size1.height;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsInfo *)goodsInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsBasisCell class]];
    if (goodsInfo) {
        [dict setObject:goodsInfo forKey:@"goodsInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.userNameLbl];
        [self.contentView addSubview:self.publishTime];
        [self.contentView addSubview:self.marketPriceLbl];
        [self.marketPriceLbl addSubview:self.markerLineView];
        [self.contentView addSubview:self.nowPriceLbl];
        [self.contentView addSubview:self.goodsNameLbl];
        [self.contentView addSubview:self.detailLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(12);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.width.equalTo(@36);
        make.height.equalTo(@36);
    }];
    
    [self.userNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(21);
    }];
    
    [self.publishTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(21);
    }];
    
    [self.marketPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.top.equalTo(self.iconImageView.mas_top);
    }];
    
    [self.markerLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.marketPriceLbl.mas_centerY).offset(-1);
        make.left.equalTo(self.marketPriceLbl.mas_left).offset(-3);
        make.right.equalTo(self.marketPriceLbl.mas_right).offset(3);
        make.height.equalTo(@1);
    }];
    
    [self.nowPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
    }];
    
    [self.goodsNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.top.equalTo(self.iconImageView.mas_bottom).offset(21);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    
    [self.detailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsNameLbl.mas_bottom).offset(6);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    GoodsInfo *goodsInfo = dict[@"goodsInfo"];
    [self.iconImageView setImageWithURL:goodsInfo.seller.avatarUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.userNameLbl.text = goodsInfo.seller.userName;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:goodsInfo.createTime/1000];
    self.publishTime.text = [NSString stringWithFormat:@"%@发布", [date minuteDescription]];
    self.marketPriceLbl.text = [NSString stringWithFormat:@"¥%.2f", goodsInfo.marketPrice];
    if (goodsInfo.meowReduceTitle.length > 0) {
        self.nowPriceLbl.text = goodsInfo.meowReduceTitle;
    }else{
        self.nowPriceLbl.text = [NSString stringWithFormat:@"¥%.2f", goodsInfo.shopPrice];
    }
    self.goodsNameLbl.text = goodsInfo.goodsName;
    self.detailLbl.text = goodsInfo.summary;
    
    
    
    WEAKSELF;
    self.iconImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
        UserHomeViewController *viewController = [[UserHomeViewController alloc] init];
        viewController.userId = goodsInfo.seller.userId;
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    };
}

@end
