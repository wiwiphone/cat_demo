//
//  BusineTitle.m
//  XianMao
//
//  Created by 阿杜 on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BusineTitleCell.h"

@implementation BusineTitleCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BusineTitleCell class]);
    });
    return __reuseIdentifier;
}

+(CGFloat)rowHeightForPortrait
{
    CGFloat height = 53;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BusineTitleCell class]];
    return dict;
}

+(NSMutableDictionary *)buildCellTime:(NSString *)time title:(BOOL)isShow;
{
    NSMutableDictionary * dict = [[super class] buildBaseCellDict:[BusineTitleCell class]];
    if (time) {
        [dict setObject:time forKey:@"time"];
    }
    if (isShow) {
        [dict setObject:[NSNumber numberWithBool:isShow] forKey:@"isShow"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    
    NSNumber * num = dict[@"isShow"];
    if ([num isEqualToNumber:@1]) {
        self.busineTitleLbl.text = @"爱丁猫";
    }
    
    if (dict[@"time"]) {
        NSString * timeStr = dict[@"time"];
        NSRange range = [timeStr rangeOfString:@"."];
        timeStr = [timeStr substringToIndex:range.location];
        self.timeLal.text = timeStr;
    }
}


-(UILabel *)busineTitleLbl
{
    if (!_busineTitleLbl) {
        _busineTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _busineTitleLbl.textColor = [UIColor colorWithHexString:@"bdbdbd"];
        _busineTitleLbl.font = [UIFont systemFontOfSize:12];
    }
    return _busineTitleLbl;
}


-(UILabel *)timeLal
{
    if (!_timeLal) {
        _timeLal = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLal.textColor = [UIColor colorWithHexString:@"bdbdbd"];
        _timeLal.font = [UIFont systemFontOfSize:10];
    }
    return _timeLal;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.timeLal];
        [self.contentView addSubview:self.busineTitleLbl];
        
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.busineTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(30);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.size.mas_equalTo(CGSizeMake(40, 12));
    }];
    
    [self.timeLal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(30);
        make.left.equalTo(self.contentView.mas_left).offset(157);
        make.height.mas_equalTo(@15);
        make.right.equalTo(self.contentView.mas_right).offset(-30);
    }];
}
@end
