//
//  AuthenticateFlowCell.m
//  XianMao
//
//  Created by WJH on 16/12/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "AuthenticateFlowCell.h"
#import "UIInsetCtrls.h"

@interface AuthenticateFlowCell()

@property (nonatomic, strong) UIInsetLabel * titleLabel;
@property (nonatomic, strong) UIInsetLabel * flowLabel;

@end

@implementation AuthenticateFlowCell

- (UIInsetLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UIInsetLabel alloc] initWithFrame:CGRectZero andInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithHexString:@"434342"];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.text = @"爱丁猫交易鉴定流程";
    }
    return _titleLabel;
}

-(UIInsetLabel *)flowLabel{
    if (!_flowLabel) {
        _flowLabel = [[UIInsetLabel alloc] initWithFrame:CGRectZero andInsets:UIEdgeInsetsMake(0, 14, 0, 14)];
        _flowLabel.backgroundColor = [UIColor colorWithHexString:@"f9a09e"];
        _flowLabel.font = [UIFont systemFontOfSize:12];
        _flowLabel.textColor = [UIColor whiteColor];
        _flowLabel.numberOfLines = 2;
        _flowLabel.text = @"买家若选择鉴定下单，您需要把商品寄给爱丁猫鉴定，\n鉴定通过后再寄给买家。鉴定费买家承担。";
        _flowLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _flowLabel;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.flowLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.height.mas_equalTo(@44);
    }];
    
    [self.flowLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([AuthenticateFlowCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait {
    
    CGFloat rowHeight = 85.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[AuthenticateFlowCell class]];
    return dict;
}

- (void)updateCellWithDict:(NSDictionary*)dict{
    
}

@end
