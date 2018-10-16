//
//  GoodsExplainCell.m
//  XianMao
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "GoodsExplainCell.h"

@interface GoodsExplainCell ()

@property (nonatomic, strong) UILabel *explainLbl;

@end

@implementation GoodsExplainCell

-(UILabel *)explainLbl{
    if (!_explainLbl) {
        _explainLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _explainLbl.font = [UIFont systemFontOfSize:13.f];
        _explainLbl.textColor = [UIColor colorWithHexString:@"999999"];
        [_explainLbl sizeToFit];
        _explainLbl.text = @"·阿斯兰的空间按声卡";
    }
    return _explainLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GoodsExplainCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 76;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsDetailInfo *)detailInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GoodsExplainCell class]];
    if (detailInfo) {
        [dict setObject:detailInfo forKey:@"detailInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.explainLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.explainLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(20);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    GoodsDetailInfo *detailInfo = dict[@"detailInfo"];
    
    
    
}

@end
