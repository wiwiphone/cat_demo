//
//  GradeItemTitleCell.m
//  XianMao
//
//  Created by Marvin on 17/3/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "GradeItemTitleCell.h"

@interface GradeItemTitleCell()

@property (nonatomic, strong) UILabel * title;

@end

@implementation GradeItemTitleCell

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont boldSystemFontOfSize:15];
        _title.textColor = [DataSources colorf9384c];
        [_title sizeToFit];
    }
    return _title;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([GradeItemTitleCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat rowHeight = 40;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)title{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[GradeItemTitleCell class]];
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    return dict;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.title];
    }
    return self;
}


- (void)updateCellWithDict:(NSDictionary*)dict{
    
    NSString * str = [dict stringValueForKey:@"title"];
    _title.text = str;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
}

@end
