//
//  NoGoodsCell.m
//  XianMao
//
//  Created by apple on 16/10/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "NoGoodsCell.h"

@interface NoGoodsCell ()

@property (nonatomic, strong) UILabel *loadLbl;

@end

@implementation NoGoodsCell

-(UILabel *)loadLbl{
    if (!_loadLbl) {
        _loadLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadLbl.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _loadLbl.font = [UIFont systemFontOfSize:15.f];
        _loadLbl.text = @"暂无商品";
    }
    return _loadLbl;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([NoGoodsCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 300;
    
    NSMutableArray *arr = dict[@"nickArrCount"];
    if (arr.count > 0 && arr) {
        height = 300*arr.count;
    }
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSMutableArray *)nickArrCount
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[NoGoodsCell class]];
    if (nickArrCount.count > 0) {
        [dict setObject:nickArrCount forKey:@"nickArrCount"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        
    }
    return self;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    [self.contentView addSubview:self.loadLbl];
    
    [self.loadLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
}

@end
