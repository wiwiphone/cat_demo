//
//  WeixinCopyCell.m
//  XianMao
//
//  Created by apple on 16/11/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WeixinCopyCell.h"

@interface WeixinCopyCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *contentLbl;

@end

@implementation WeixinCopyCell

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:13.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"888888"];
        _contentLbl.numberOfLines = 0;
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor clearColor];
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([WeixinCopyCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 72;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(AdviserPage *)adviser
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[WeixinCopyCell class]];
    if (adviser)[dict setObject:adviser forKey:@"adviser"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.contentLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-50);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    AdviserPage *adviserPage = dict[@"adviser"];
    
    self.iconImageView.image = [UIImage imageNamed:@"goods_detail_weixin"];
    self.contentLbl.text = [NSString stringWithFormat:@"您专属的%@的个人微信号:%@(点击复制),朋友圈还常常有福利喔~", adviserPage.username, adviserPage.weixinId];
}

@end
