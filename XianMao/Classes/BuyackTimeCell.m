//
//  BuyackTimeCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BuyackTimeCell.h"

@implementation BuyackTimeCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BuyackTimeCell class]);
    });
    return __reuseIdentifier;
}

+(CGFloat)rowHeightForPortrait
{
    CGFloat height = 30;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BuyackTimeCell class]];
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict[@"title"]) {
        self.timeLbl.text = dict[@"title"];
    }
    if (dict[@"dateStr"]) {
        self.time.text = dict[@"dateStr"];
    }

}

-(UILabel *)timeLbl
{
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.font = [UIFont systemFontOfSize:12];
        _timeLbl.textColor = [UIColor colorWithHexString:@"000000"];
    }
    return _timeLbl;
}

-(UILabel *)time
{
    if (!_time) {
        _time = [[UILabel alloc] initWithFrame:CGRectZero];
        _time.font = [UIFont systemFontOfSize:12];
        _time.textColor = [UIColor colorWithHexString:@"000000"];

    }
    return _time;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.timeLbl];
        [self.contentView addSubview:self.time];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.width.mas_equalTo(@65);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.timeLbl.mas_right);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)title andDateString:(NSString *)dateStr
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BuyackTimeCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    if (dateStr) {
        [dict setObject:dateStr forKey:@"dateStr"];
    }

    return dict;
}
@end
