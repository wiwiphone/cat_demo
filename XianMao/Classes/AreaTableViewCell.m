//
//  AreaTableViewCell.m
//  XianMao
//
//  Created by simon on 12/5/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "AreaTableViewCell.h"

@interface AreaTableViewCell ()

@property(nonatomic,strong) UILabel *nameLbl;
@property(nonatomic,strong) CALayer *bottomLineLayer;
@property(nonatomic,assign) AreaTableType type;

@end

@implementation AreaTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([AreaTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 44;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(NSDictionary*)areaData AreaTableType:(AreaTableType)type {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[AreaTableViewCell class]];
    if (areaData)[dict setObject:areaData forKey:@"areaData"];
    [dict setObject:[NSNumber numberWithInteger:type] forKey:@"type"];
    return dict;
}

- (void)updateCellWithDict:(NSDictionary*)dict {
    AreaTableType type = [dict integerValueForKey:@"type"];
    NSDictionary *areaData = [dict objectForKey:@"areaData"];
    if (areaData) {
        if (type==AreaTableTypeProvince) {
            _nameLbl.text = [areaData provinceName];
        }
        else if (type==AreaTableTypeCity) {
            _nameLbl.text = [areaData cityName];
        }
        else if (type==AreaTableTypeDistrict) {
            _nameLbl.text = [areaData district];
        }
    }
    [self setNeedsDisplay];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _nameLbl.font = [UIFont systemFontOfSize:17.f];
        _nameLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _nameLbl.backgroundColor = [UIColor whiteColor];
        _nameLbl.textAlignment = NSTextAlignmentLeft;
        _nameLbl.font = [UIFont systemFontOfSize:14.f];
        [self.contentView addSubview:_nameLbl];
        
        _bottomLineLayer = [CALayer layer];
        _bottomLineLayer.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_bottomLineLayer];
    }
    return self;
}

- (void)dealloc {
    //    _nameLbl = nil;
    //    _selectedIconView = nil;
}

- (void)prepareForReuse {
    [super prepareForReuse];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _nameLbl.frame = CGRectMake(15, 0, self.contentView.bounds.size.width-30, 44);
    _bottomLineLayer.frame = CGRectMake(0, 43, self.contentView.bounds.size.width, 1);
}

@end
