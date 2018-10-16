//
//  GoodsLikeCell.m
//  XianMao
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsLikeCell.h"

@interface GoodsLikeCell ()


@property (nonatomic, strong) UILabel *liulanLbl;

@end

@implementation GoodsLikeCell

-(UILabel *)liulanLbl{
    if (!_liulanLbl) {
        _liulanLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _liulanLbl.font = [UIFont systemFontOfSize:13.f];
        _liulanLbl.textColor = [UIColor colorWithHexString:@"333333"];
    }
    return _liulanLbl;
}

-(UIButton *)likeLbl{
    if (!_likeLbl) {
        _likeLbl = [[UIButton alloc] initWithFrame:CGRectZero];
        _likeLbl.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_likeLbl setTitleColor:[UIColor colorWithHexString:@"457fb9"] forState:UIControlStateNormal];
        [_likeLbl sizeToFit];
    }
    return _likeLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsLikeCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 48;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo *)detailInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsLikeCell class]];
    if (detailInfo) {
        [dict setObject:detailInfo forKey:@"detailInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.likeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(70);
    }];
    
    [self.liulanLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    WEAKSELF;
    for (UIView *v in self.contentView.subviews) {
        if ([v isKindOfClass:[UIView class]]) {
            [v removeFromSuperview];
        }
    }
    
    GoodsDetailInfo *detailInfo = dict[@"detailInfo"];
    NSMutableArray *likeUserArr = detailInfo.goodsInfo.likedUsers;
    if (likeUserArr.count > 3) {
        for (int i = 0; i < 3; i++) {
            User *user = likeUserArr[i];
            
            XMWebImageView *iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
            iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
            iconImageView.layer.masksToBounds = YES;
            iconImageView.layer.cornerRadius = 10;
            [iconImageView setImageWithURL:user.avatarUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
            [self.contentView addSubview:iconImageView];
            iconImageView.frame = CGRectMake(12+i*(20-6), (48-20)/2, 20, 20);
            
            iconImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
                if (weakSelf.clickLikeBtn) {
                    weakSelf.clickLikeBtn();
                }
            };
        }
    } else {
        for (int i = 0; i < likeUserArr.count; i++) {
            User *user = likeUserArr[i];
            
            XMWebImageView *iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
            iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
            iconImageView.layer.masksToBounds = YES;
            iconImageView.layer.cornerRadius = 10;
            [iconImageView setImageWithURL:user.avatarUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
            [self.contentView addSubview:iconImageView];
            iconImageView.frame = CGRectMake(12+i*(20-6), (48-20)/2, 20, 20);
            
            iconImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
                if (weakSelf.clickLikeBtn) {
                    weakSelf.clickLikeBtn();
                }
            };
        }
    }
    [self.contentView addSubview:self.likeLbl];
    [self.contentView addSubview:self.liulanLbl];
    
    if (likeUserArr.count > 0) {
        [self.likeLbl setTitle:[NSString stringWithFormat:@"%ld人心动", likeUserArr.count] forState:UIControlStateNormal];
        self.likeLbl.hidden = NO;
    } else {
        self.likeLbl.hidden = YES;
    }
    [self.likeLbl addTarget:self action:@selector(clickLikeLbl) forControlEvents:UIControlEventTouchUpInside];
    
    self.liulanLbl.text = [NSString stringWithFormat:@"%ld人浏览", detailInfo.goodsInfo.stat.visitNum];
    
}

-(void)clickLikeLbl{
    
    if (self.clickLikeBtn) {
        self.clickLikeBtn();
    }
    
}

@end
