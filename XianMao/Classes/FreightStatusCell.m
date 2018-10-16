//
//  FreightStatusCell.m
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FreightStatusCell.h"

@interface FreightStatusCell()

@property (nonatomic, strong) XMWebImageView * icon;
@property (nonatomic, strong) UILabel * statusLbl;

@end

@implementation FreightStatusCell

-(XMWebImageView *)icon
{
    if (!_icon) {
        _icon = [[XMWebImageView alloc] init];
    }
    return _icon;
}


-(UILabel *)statusLbl
{
    if (!_statusLbl) {
        _statusLbl = [[UILabel alloc] init];
        _statusLbl.textColor = [UIColor whiteColor];
        _statusLbl.font = [UIFont systemFontOfSize:13];
        _statusLbl.textAlignment = NSTextAlignmentLeft;
        _statusLbl.numberOfLines = 2;
    }
    return _statusLbl;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor blackColor];
        [self.contentView addSubview:self.icon];
        [self.contentView addSubview:self.statusLbl];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    
    [self.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.icon.mas_right).offset(30);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}


+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([FreightStatusCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 80;
    
    return height;
}

+ (NSMutableDictionary *)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[FreightStatusCell class]];
    return dict;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    self.icon.image = [UIImage imageNamed:@"putongyuyin"];
    self.statusLbl.text = @"卖家已付款\n您的包裹整在待发";
}

@end
