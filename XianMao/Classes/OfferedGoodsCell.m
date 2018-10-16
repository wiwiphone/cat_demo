//
//  OfferedGoodsCell.m
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OfferedGoodsCell.h"

#import "MainPic.h"
#import "NSDate+Category.h"

#import "Masonry.h"
#import "SDWebImageManager.h"
#import "DataSources.h"

@interface OfferedGoodsCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *timeBtn;

@end

@implementation OfferedGoodsCell

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        _iconImageView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _iconImageView.clipsToBounds = YES;
    }
    return _iconImageView;
}

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
        _contentLabel.textColor = [UIColor colorWithHexString:@"595757"];
        _contentLabel.numberOfLines = 0;
        [_contentLabel sizeToFit];
    }
    return _contentLabel;
}

-(UIButton *)timeBtn{
    if (!_timeBtn) {
        _timeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _timeBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_timeBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        [_timeBtn setImage:[UIImage imageNamed:@"recover_time_MF"] forState:UIControlStateNormal];
        _timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_timeBtn sizeToFit];
    }
    return _timeBtn;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OfferedGoodsCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(RecoveryGoodsVo*)goodsVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OfferedGoodsCell class]];
    if (goodsVO)[dict setObject:goodsVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 144;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"recoveryGoodsVo";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.contentLabel];
        [self.contentView addSubview:self.timeBtn];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@90);
        make.height.equalTo(@90);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(25);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@45);
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.left.equalTo(self.iconImageView.mas_right).offset(25);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@45);
    }];
    
    [self.timeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_bottom).offset(15);
        make.left.equalTo(self.iconImageView.mas_left);
    }];
}

-(void)updateCellWithDict:(RecoveryGoodsVo *)goodsVO{
    MainPic *mainPic = goodsVO.mainPic;
    [self.iconImageView setImageWithURL:mainPic.pic_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.titleLabel.text = goodsVO.goodsName;
    self.contentLabel.text = goodsVO.goodsBrief;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:goodsVO.updatetime/1000];
    [self.timeBtn setTitle:[NSString stringWithFormat:@" %@发布", [date formattedDateDescription]] forState:UIControlStateNormal];
}

@end
