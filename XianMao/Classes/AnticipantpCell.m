//
//  AnticipantpCell.m
//  XianMao
//
//  Created by WJH on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "AnticipantpCell.h"


@interface AnticipantpCell()

@property (nonatomic, strong) UILabel * price;
@property (nonatomic, strong) UIImageView * containerView;

@end

@implementation AnticipantpCell

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
        __reuseIdentifier = NSStringFromClass([AnticipantpCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat rowHeight = 35;
    return rowHeight;
}

- (UILabel *)price{
    if (!_price) {
        _price = [[UILabel alloc] init];
        _price.font = [UIFont systemFontOfSize:14];
        _price.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_price sizeToFit];
    }
    return _price;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)price{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[AnticipantpCell class]];
    if (price && price.length > 0) {
        [dict setObject:price forKey:@"price"];
    }
    return dict;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.price];
    }
    return self;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    NSString * price = [dict stringValueForKey:@"price"];
    self.price.text = [NSString stringWithFormat:@"期望价  ¥:%@",price];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.left.equalTo(self.containerView.mas_left).offset(18);
    }];
}

@end
