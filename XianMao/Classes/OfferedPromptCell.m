//
//  OfferedPromptCell.m
//  XianMao
//
//  Created by apple on 16/2/3.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OfferedPromptCell.h"
#import "Masonry.h"

@interface OfferedPromptCell ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) UIButton *congLbl;
@property (nonatomic, strong) UILabel *contentLbl;

@end

@implementation OfferedPromptCell

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _contentLbl.font = [UIFont systemFontOfSize:13.f];
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UIButton *)congLbl{
    if (!_congLbl) {
        _congLbl = [[UIButton alloc] initWithFrame:CGRectZero];
        _congLbl.titleLabel.font = [UIFont systemFontOfSize:19.f];
        [_congLbl setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        [_congLbl setTitle:@" 恭喜！" forState:UIControlStateNormal];
        [_congLbl setImage:[UIImage imageNamed:@"Recover_Smale_MF"] forState:UIControlStateNormal];
        [_congLbl sizeToFit];
    }
    return _congLbl;
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _backView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OfferedPromptCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo *)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OfferedPromptCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 138;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"goodsVO";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.backView];
        [self.backView addSubview:self.congLbl];
        [self.backView addSubview:self.contentLbl];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@223);
        make.height.equalTo(@50);
    }];
    
    [self.congLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView.mas_centerX);
        make.top.equalTo(self.backView.mas_top);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView.mas_centerX);
        make.top.equalTo(self.congLbl.mas_bottom).offset(18);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    RecoveryGoodsVo *goodsVO = dict[@"goodsVO"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:goodsVO.exprTime/1000];
    NSString *time = [NSString stringWithFormat:@"%ld", [date minute]];
    self.contentLbl.text = [NSString stringWithFormat:@"卖家已授权您购买，请在%@分钟内拍下", time];
    
}

@end
