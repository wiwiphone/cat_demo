//
//  offeredGoodsDetailCell.m
//  XianMao
//
//  Created by 阿杜 on 16/3/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "offeredGoodsDetailCell.h"
#import "Masonry.h"

@interface offeredGoodsDetailCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation offeredGoodsDetailCell

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLabel.font = [UIFont systemFontOfSize:13.f];
        _titleLabel.textColor = [UIColor colorWithHexString:@"595757"];
        _titleLabel.numberOfLines = 0;
        [_titleLabel sizeToFit];
    }
    return _titleLabel;
}

-(UILabel *)contentLabel{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLabel.font = [UIFont systemFontOfSize:13.f];
        _contentLabel.textColor = [UIColor colorWithHexString:@"898989"];
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}


+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([offeredGoodsDetailCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[offeredGoodsDetailCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    
    RecoveryGoodsVo *goodsVO = dict[@"recoveryGoodsVo"];
    NSString *str1 = goodsVO.goodsName;
    NSString *str2 = goodsVO.goodsBrief;
//
    UILabel *label1 = [[UILabel alloc] init];
    UILabel *label2 = [[UILabel alloc] init];
    
    label1.numberOfLines = 0;
    label2.numberOfLines = 0;
    
    label1.frame = CGRectMake(0, 0, kScreenWidth - 30, 0);
    label2.frame = CGRectMake(0, 0, kScreenWidth - 30, 0);
    
    label1.font = [UIFont systemFontOfSize:13.f];
    label2.font = [UIFont systemFontOfSize:13.f];
    
    label1.text = str1;
    label2.text = str2;
    
    [label1 sizeToFit];
    [label2 sizeToFit];
    
//    CGRect rect = [str1 boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 0) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} context:nil];
//    CGRect rect1 = [str2 boundingRectWithSize:CGSizeMake(kScreenWidth - 30, 0) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f]} context:nil];
//    
//    height = rect.size.height + rect1.size.height + 8 + 16;
//    height += lbl.height;
    height = label1.height + label2.height + 16 + 8;
    
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
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
//        make.height.equalTo(@30);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(8);
        make.left.equalTo(self.titleLabel.mas_left);
        make.right.equalTo(self.titleLabel.mas_right);
//        make.height.equalTo(@45);
    }];
}

-(void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO{
//    MainPic *mainPic = goodsVO.mainPic;
    self.titleLabel.text = goodsVO.goodsName;
    self.contentLabel.text = goodsVO.goodsBrief;
}


@end
