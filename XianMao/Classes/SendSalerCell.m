//
//  SendSalerCell.m
//  XianMao
//
//  Created by WJH on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SendSalerCell.h"
#import "SendSaleVo.h"

@interface SendSalerCell()

@property (nonatomic, strong) UIImageView * containerView;
@property (nonatomic, strong) XMWebImageView * saler;
@property (nonatomic, strong) UILabel * saleName;

@end

@implementation SendSalerCell

- (XMWebImageView *)saler{
    if (!_saler) {
        _saler = [[XMWebImageView alloc] init];
        _saler.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _saler.layer.masksToBounds = YES;
        _saler.layer.cornerRadius = 10;
    }
    return _saler;
}

- (UILabel *)saleName{
    if (!_saleName) {
        _saleName = [[UILabel alloc] init];
        _saleName.font = [UIFont systemFontOfSize:12];
        _saleName.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_saleName sizeToFit];
    }
    return _saleName;
}

- (UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.image = [UIImage imageNamed:@"bg_mid"];
    }
    return _containerView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SendSalerCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat rowHeight = 40;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(SendSaleVo *)sendVo{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SendSalerCell class]];
    if (sendVo) {
        [dict setObject:sendVo forKey:@"sendVo"];
    }
    return dict;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.saler];
        [self.containerView addSubview:self.saleName];

    }
    return self;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    SendSaleVo * sendVo = [dict objectForKey:@"sendVo"];
    
    if (sendVo) {
        self.saleName.text = sendVo.themeName;
        [self.saler setImageWithURL:sendVo.themeAvatar XMWebImageScaleType:XMWebImageScale40x40];
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.saler mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.left.equalTo(self.containerView.mas_left).offset(18);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    [self.saleName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.left.equalTo(self.saler.mas_right).offset(8);
    }];
}
@end
