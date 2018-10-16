//
//  ProtocolTitleCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ProtocolTitleCell.h"

@implementation ProtocolTitleCell


+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ProtocolTitleCell class]);
    });
    return __reuseIdentifier;
}

+(CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 70;
    return height;
}


+(NSMutableDictionary *)buildCellTitle:(NSString *)title
{
    NSMutableDictionary * dict = [[super class] buildBaseCellDict:[ProtocolTitleCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict[@"title"]) {
        self.title.text = dict[@"title"];
    }
    
}


-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:17];
        _title.textAlignment = NSTextAlignmentCenter;
    }
    return _title;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.title];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
}

@end
