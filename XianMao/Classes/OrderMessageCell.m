//
//  OrderMessageCell.m
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderMessageCell.h"
#import "Masonry.h"

@interface OrderMessageCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UILabel *message;

@end

@implementation OrderMessageCell

-(UILabel *)message{
    if (!_message) {
        _message = [[UILabel alloc] initWithFrame:CGRectZero];
        _message.font = [UIFont systemFontOfSize:14.f];
        _message.textColor = [UIColor colorWithHexString:@"444444"];
        _message.text = @"买家留言";
        [_message sizeToFit];
    }
    return _message;
}

-(UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] initWithFrame:CGRectZero];
        _title.font = [UIFont systemFontOfSize:14.f];
        _title.textColor = [UIColor colorWithHexString:@"444444"];
        _title.text = @"买家留言";
        [_title sizeToFit];
    }
    return _title;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"Order_Message_MF"];
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderMessageCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(OrderInfo*)orderInfo {
    CGFloat height = 60.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(OrderInfo *)orderInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderMessageCell class]];
    if (dict) {
        [dict setObject:orderInfo forKey:@"orderInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.message];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.left.equalTo(self.iconImageView.mas_right).offset(14);
    }];
    
    [self.message mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(5);
        make.left.equalTo(self.iconImageView.mas_right).offset(14);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    OrderInfo *orderInfo = dict[@"orderInfo"];
    self.message.text = orderInfo.message;
    
}

@end
