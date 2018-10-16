//
//  ReturnGoodsInformationCell.m
//  XianMao
//
//  Created by apple on 16/7/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ReturnGoodsInformationCell.h"
#import "Masonry.h"

@interface ReturnGoodsInformationCell ()

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation ReturnGoodsInformationCell

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"121212"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ReturnGoodsInformationCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSString *)title{
    CGFloat height = 45.f;
    return height;
}

+ (NSMutableDictionary*)buildCellTitle:(NSString *)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ReturnGoodsInformationCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    NSString *title = dict[@"title"];
    self.titleLbl.text = title;
}

@end
