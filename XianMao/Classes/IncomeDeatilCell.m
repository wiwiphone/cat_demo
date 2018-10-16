//
//  IncomeDeatilCell.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "IncomeDeatilCell.h"
#import "NSDate+Category.h"
#import "NSDate+Additions.h"


@interface IncomeDeatilCell()

@property (nonatomic,strong) UILabel * time;
@property (nonatomic,strong) UILabel * money;
@property (nonatomic,strong) UILabel * title;

@end

@implementation IncomeDeatilCell


-(UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc] init];
        _time.textColor = [UIColor colorWithHexString:@"6a6868"];
        _time.font = [UIFont systemFontOfSize:10];
        [_time sizeToFit];
    }
    return _time;
}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.textColor = [UIColor colorWithHexString:@"6a6868"];
        _title.font = [UIFont systemFontOfSize:14];
        [_title sizeToFit];
    }
    return _title;
}

-(UILabel *)money
{
    if (!_money) {
        _money = [[UILabel alloc] init];
        _money.textColor = [UIColor colorWithHexString:@"434342"];
        _money.font = [UIFont systemFontOfSize:14];
        [_money sizeToFit];
    }
    return _money;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([IncomeDeatilCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    
    return  60;
}

+ (NSMutableDictionary*)buildCellDict:(AccountLogVo *)account
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[IncomeDeatilCell class]];
    if (account) {
        [dict setObject:account forKey:@"account"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{

    AccountLogVo * accountLogVo = dict[@"account"];

    if (accountLogVo.createtime) {
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:accountLogVo.createtime/1000 ];//[NSDate date];
        self.time.text = [NSDate stringFromDate:date withFormat:@"yyyy-MM-dd"];
    }
    
    if (accountLogVo.title) {
        self.title.text = accountLogVo.title;
    }
    
    if (accountLogVo.amount_text) {
        self.money.text = accountLogVo.amount_text;
        if ([accountLogVo.amount_text hasPrefix:@"+"]) {
            self.money.textColor = [UIColor redColor];
        }
    }
    
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.time];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.money];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_centerY).offset(5);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
    [self.money mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}

@end
