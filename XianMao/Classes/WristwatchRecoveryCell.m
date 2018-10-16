//
//  WristwatchRecoveryCell.m
//  XianMao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WristwatchRecoveryCell.h"
#import "Masonry.h"

@interface WristwatchRecoveryCell ()



@end

@implementation WristwatchRecoveryCell

-(UIButton *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_rightBtn setImage:[UIImage imageNamed:@"WristwatchRecovery_GoodsDetail_Right"] forState:UIControlStateNormal];
        [_rightBtn sizeToFit];
    }
    return _rightBtn;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.text = @"原价回购，购物无忧";
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor whiteColor];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"WristwatchRecovery_GoodsDetail_Icon"];
        [_iconImageView sizeToFit];
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([WristwatchRecoveryCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 42.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[WristwatchRecoveryCell class]];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f4433e"];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.rightBtn];
        
        [self.rightBtn addTarget:self action:@selector(clickRightBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickRightBtn{
    if ([self.wristDelegate respondsToSelector:@selector(showExplain)]) {
        [self.wristDelegate showExplain];
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(5);
    }];
    
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
}

@end
