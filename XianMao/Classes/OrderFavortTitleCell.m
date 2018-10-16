//
//  OrderFavortTitleCell.m
//  XianMao
//
//  Created by apple on 16/9/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderFavortTitleCell.h"

@interface OrderFavortTitleCell ()

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation OrderFavortTitleCell

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderFavortTitleCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 44;
    
    return height;
}

+ (NSMutableDictionary *)buildCellTitle:(NSString *)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderFavortTitleCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    NSString *title = dict[@"title"];
    self.titleLbl.text = title;
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.centerX.equalTo(self.contentView.mas_centerX);
    }];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        
    }
    return self;
}

@end
