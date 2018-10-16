//
//  OrderStatusCell.m
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderStatusCell.h"
#import "Masonry.h"

@interface OrderStatusCell ()

@property (nonatomic, strong) UIButton *statusBtn;
@property (nonatomic, strong) UILabel * remainingLbl;

@end

@implementation OrderStatusCell


-(UILabel *)remainingLbl{
    if (!_remainingLbl) {
        _remainingLbl = [[UILabel alloc] init];
        _remainingLbl.textColor = [UIColor colorWithHexString:@"2d2d2d"];
        _remainingLbl.font = [UIFont systemFontOfSize:12.f];
        [_remainingLbl sizeToFit];
    }
    return _remainingLbl;
}

-(UIButton *)statusBtn{
    if (!_statusBtn) {
        _statusBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _statusBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_statusBtn setTitleColor:[UIColor colorWithHexString:@"2d2d2d"] forState:UIControlStateNormal];
        [_statusBtn sizeToFit];
        [_statusBtn setTitle:@"" forState:UIControlStateNormal];
    }
    return _statusBtn;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderStatusCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(OrderInfo*)orderInfo {
    CGFloat height = 70.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(OrderInfo *)orderInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderStatusCell class]];
    if (dict) {
        [dict setObject:orderInfo forKey:@"orderInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.statusBtn];
        [self.contentView addSubview:self.remainingLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.statusBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
    [self.statusBtn.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.statusBtn.titleLabel.mas_centerY);
        make.right.equalTo(self.statusBtn.titleLabel.mas_left).offset(-2);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [self.remainingLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.top.equalTo(self.statusBtn.imageView.mas_bottom).offset(5);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    OrderInfo *orderInfo = dict[@"orderInfo"];
    [self.statusBtn setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:orderInfo.statusDescIcon]]] forState:UIControlStateNormal];
    [self.statusBtn setTitle:[NSString stringWithFormat:@" %@", orderInfo.statusDesc] forState:UIControlStateNormal];
    if (orderInfo.receive_remaining > 0) {
        NSInteger hours = orderInfo.receive_remaining/3600;
        if (hours>24) {
            NSInteger days = hours/24;
            NSInteger hours = (orderInfo.receive_remaining-3600*24*days)/3600;
            self.remainingLbl.text = [NSString stringWithFormat:@"还剩%ld天%ld小时自动确认收货",(long)days,(long)hours];
        } else {
            NSInteger hours = orderInfo.receive_remaining/3600;
            self.remainingLbl.text = [NSString stringWithFormat:@"还剩%ld小时自动确认收货",(long)hours];
        }
    }
    
}

@end
