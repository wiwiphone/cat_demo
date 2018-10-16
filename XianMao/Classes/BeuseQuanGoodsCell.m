//
//  BeuseQuanGoodsCell.m
//  XianMao
//
//  Created by apple on 16/11/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BeuseQuanGoodsCell.h"
#import "BounsGoodsInfo.h"

@interface BeuseQuanGoodsCell ()

@property (nonatomic, strong) UILabel *quanTitleLbl;
@property (nonatomic, strong) UILabel *quanSubLbl;

@end

@implementation BeuseQuanGoodsCell

-(UILabel *)quanSubLbl{
    if (!_quanSubLbl) {
        _quanSubLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _quanSubLbl.font = [UIFont systemFontOfSize:12.f];
        _quanSubLbl.textColor = [UIColor colorWithHexString:@"f9384c"];
        _quanSubLbl.layer.borderColor = [UIColor colorWithHexString:@"f9384c"].CGColor;
        _quanSubLbl.layer.borderWidth = 0.5f;
        [_quanSubLbl sizeToFit];
    }
    return _quanSubLbl;
}

-(UILabel *)quanTitleLbl{
    if (!_quanTitleLbl) {
        _quanTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _quanTitleLbl.font = [UIFont systemFontOfSize:12.f];
        _quanTitleLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_quanTitleLbl sizeToFit];
    }
    return _quanTitleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BeuseQuanGoodsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 28;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSMutableArray *)array
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BeuseQuanGoodsCell class]];
    [dict setObject:array forKey:@"array"];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.quanTitleLbl];
        [self.contentView addSubview:self.quanSubLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.quanTitleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.top.equalTo(self.contentView.mas_top);
    }];
    
    [self.quanSubLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.quanTitleLbl.mas_right).offset(5);
        make.top.equalTo(self.contentView.mas_top);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    NSMutableArray *quanList = dict[@"array"];
    BounsGoodsInfo *bonusInfo = [[BounsGoodsInfo alloc] initWithJSONDictionary:quanList[0]];
    self.quanTitleLbl.text = @"可用券";
    self.quanSubLbl.text = [NSString stringWithFormat:@"满%ld减%ld", bonusInfo.min_pay_amount, bonusInfo.amount];
    
}

@end
