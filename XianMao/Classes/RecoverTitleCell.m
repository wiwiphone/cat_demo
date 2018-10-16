//
//  RecoverTitleCell.m
//  XianMao
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverTitleCell.h"
#import "Masonry.h"

@interface RecoverTitleCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation RecoverTitleCell

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.textColor = [UIColor colorWithHexString:@"595757"];
        _titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_titleLabel sizeToFit];
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.textColor = [UIColor colorWithHexString:@"595757"];
        _contentLabel.font = [UIFont systemFontOfSize:14.f];
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoverTitleCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoverTitleCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    if (dict) {
        RecoveryGoodsVo *goodsVO = dict[@"recoveryGoodsVo"];
//        NSLog(@"%ld", goodsVO.goodsName.length);
//        if (goodsVO.goodsName) {
//            if (goodsVO.goodsName.length >= 30) {
//                height += 60;
//            } else {
//                height += 35;
//            }
//        }
//        if (goodsVO.goodsBrief.length > 0) {
//            if (goodsVO.goodsBrief.length >= 36) {
//                height += goodsVO.goodsBrief.length / 36 * 30;
//            } else {
//                height += 35;
//            }
//        } else {
//            height += 0;
//        }
        
        height += 15;
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 0)];
        lbl.numberOfLines = 0;
        lbl.font = [UIFont systemFontOfSize:14.f];
        lbl.text = goodsVO.goodsName;
        [lbl sizeToFit];
        height += lbl.height;
        NSLog(@"%.2f", lbl.height);
        
        height += 10;
        
        UILabel *lbl1 = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth - 30, 0)];
        lbl1.numberOfLines = 0;
        lbl1.font = [UIFont systemFontOfSize:14.f];
        lbl1.text = goodsVO.goodsBrief;
        [lbl1 sizeToFit];
        height += lbl1.height;
        NSLog(@"%.2f", lbl1.height);
    }
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"recoveryGoodsVo";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        
//        self.contentView.backgroundColor = [UIColor orangeColor];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(10);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
    }];
}

-(void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO{
    self.titleLabel.text = goodsVO.goodsName;
    self.contentLabel.text = goodsVO.goodsBrief;
}

@end
