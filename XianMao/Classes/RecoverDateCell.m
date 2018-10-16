//
//  RecoverDateCell.m
//  XianMao
//
//  Created by 阿杜 on 16/3/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverDateCell.h"
#import "Masonry.h"
#import "NSDate+Category.h"

@implementation RecoverDateCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoverDateCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoverDateCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 40;
    return height;
}

- (UIView *)HXView {
    if (!_HXView) {
        _HXView = [[UIView alloc] initWithFrame:CGRectZero];
        _HXView.backgroundColor = [UIColor colorWithWhite:0.541 alpha:1.000];
        [_HXView sizeToFit];
    }
    return _HXView;
}

-(UIButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_timeBtn setImage:[UIImage imageNamed:@"recover_time_MF"] forState:UIControlStateNormal];
        //        [_timeBtn setTitle:@"10分钟" forState:UIControlStateNormal];
        [_timeBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_timeBtn sizeToFit];
    }
    return _timeBtn;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor colorWithRed:1.000 green:0.642 blue:0.199 alpha:1.000];
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.timeBtn];
        
        [self.contentView addSubview:self.HXView];
        
        [self.contentView addSubview:self.timeLabel];
        
        self.contentView.backgroundColor = [UIColor orangeColor];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView.mas_centerY);
//        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.height.equalTo(@20);
        //这里显示的是固定内容, 所以宽度固定, 数值还需测试
        make.width.equalTo(@100);
    }];
    [self.HXView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-2);
        make.height.equalTo(@1.2);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.timeBtn.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(self.timeBtn);
        make.bottom.equalTo(self.timeBtn.mas_bottom);
    }];
//    [self setNeedsLayout];
}


-(void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO{
    
    SellerBasicInfo *basicInfo = goodsVO.sellerBasicInfo;
    
    
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:goodsVO.updatetime/1000];
    [self.timeBtn setTitle:[NSString stringWithFormat:@" %@", [date formattedDateDescription]] forState:UIControlStateNormal];
    [self.timeBtn setTitle:@"出价时间仅剩 " forState:UIControlStateNormal];
    [self.timeBtn setBackgroundColor:[UIColor grayColor]];
}

+ (NSString*)cellKeyForRecommendUser {
    return @"recoveryGoodsVo";
}

@end
