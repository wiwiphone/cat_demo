//
//  OrderOtherExpenseCell.m
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderOtherExpenseCell.h"
#import "Masonry.h"

@interface OrderOtherExpenseCell()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *priceLbl;

@end

@implementation OrderOtherExpenseCell

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:14.f];
        _priceLbl.textColor = [UIColor colorWithHexString:@"000000"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"000000"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderOtherExpenseCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(OrderInfo*)orderInfo {
    CGFloat height = 30.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)price title:(NSString *)title
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderOtherExpenseCell class]];
    if (dict) {
        [dict setObject:price forKey:@"price"];
        [dict setObject:title forKey:@"title"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.priceLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    self.titleLbl.text = dict[@"title"];
    self.priceLbl.text = [NSString stringWithFormat:@"¥%@", dict[@"price"]];
    
}

@end
