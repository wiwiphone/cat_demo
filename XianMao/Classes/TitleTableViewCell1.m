//
//  TitleTableViewCell1.m
//  XianMao
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "TitleTableViewCell1.h"
#import "Masonry.h"

@interface TitleTableViewCell1 ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation TitleTableViewCell1

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:15.f];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor colorWithHexString:@"595757"];
        _titleLabel.text = @"购买渠道";
        
    }
    return _titleLabel;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([TitleTableViewCell1 class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 35;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[TitleTableViewCell1 class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.titleLabel];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

- (void)updateCellWithDict{
    
    
    [self setNeedsDisplay];
}

@end
