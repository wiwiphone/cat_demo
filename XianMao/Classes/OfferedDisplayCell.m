//
//  OfferedDisplayCell.m
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OfferedDisplayCell.h"

#import "Masonry.h"
#import "SDWebImageManager.h"

@interface OfferedDisplayCell ()

@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) UILabel *desLabel;
@property (nonatomic, strong) UIView *segView;

@end

@implementation OfferedDisplayCell

-(UIImageView *)frontImageView{
    if (!_frontImageView) {
        _frontImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _frontImageView;
}

-(UILabel *)desLabel{
    if (!_desLabel) {
        _desLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _desLabel.textColor = [UIColor colorWithHexString:@"b4b4b5"];
        _desLabel.font = [UIFont systemFontOfSize:12.f];
        [_desLabel sizeToFit];
    }
    return _desLabel;
}

-(UIView *)segView{
    if (!_segView) {
        _segView = [[UIView alloc] initWithFrame:CGRectZero];
        _segView.backgroundColor = [UIColor colorWithHexString:@"b4b4b5"];
    }
    return _segView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OfferedDisplayCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(HighestBidVo*)bidVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OfferedDisplayCell class]];
    if (bidVO)[dict setObject:bidVO forKey:[self cellKeyForRecommendUser]];
    return dict;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 55;
    return height;
}

+ (NSString*)cellKeyForRecommendUser {
    return @"get_bid_detail";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.frontImageView];
        [self.contentView addSubview:self.desLabel];
        [self.contentView addSubview:self.segView];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.frontImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@19);
        make.height.equalTo(@19);
    }];
    
    [self.desLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
    
}

-(void)updateCellWithDict:(HighestBidVo *)bidVO{
    if (!bidVO) {
        self.frontImageView.image = [UIImage imageNamed:@"Recover_Price_MF"];
        self.desLabel.text = @"您的出价次序";
    } else {
        self.frontImageView.image = [UIImage imageNamed:@"Recover_Price_MF"];
        self.desLabel.text = [NSString stringWithFormat:@"您是第%ld位出价人", bidVO.order];
    }
}

@end