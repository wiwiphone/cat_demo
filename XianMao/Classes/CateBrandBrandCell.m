//
//  CateBrandBrandCell.m
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CateBrandBrandCell.h"

@interface CateBrandBrandCell ()

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation CateBrandBrandCell

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:12.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([CateBrandBrandCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 60.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(BrandInfo *)brandInfo{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[CateBrandBrandCell class]];
    if (brandInfo) {
        [dict setObject:brandInfo forKey:@"brandInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    BrandInfo *brandInfo = dict[@"brandInfo"];
    self.titleLbl.text = [NSString stringWithFormat:@"%@/%@", brandInfo.brandEnName, brandInfo.brandName];
}

@end
