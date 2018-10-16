//
//  RecoveryCell1.m
//  XianMao
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoveryCell1.h"
#import "Masonry.h"

@interface RecoveryCell1 ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UILabel *subLbl;

@end

@implementation RecoveryCell1

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.font = [UIFont systemFontOfSize:15.f];
        _subLbl.textColor = [UIColor colorWithHexString:@"dcdddd"];
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIImageView *)rightImage{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        [_rightImage sizeToFit];
    }
    return _rightImage;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([RecoveryCell1 class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 42;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoveryCell1 class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.rightImage];
        [self.contentView addSubview:self.subLbl];
        
    }
    return self;
}

-(void)setSubStr:(NSString *)subStr{
    _subStr = subStr;
    self.subLbl.text = subStr;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
    }];
    
    [self.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.top.equalTo(self.contentView.mas_top).offset(15);
    }];
    
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.right.equalTo(self.rightImage.mas_left).offset(-16);
    }];
}

-(void)setTitleText1:(NSString *)titleStr andImageName:(NSString *)imageName{
    self.titleLbl.text = titleStr;
    self.rightImage.image = [UIImage imageNamed:imageName];
    if (self.subStr.length > 0) {
        self.subLbl.text = self.subStr;
    } else {
        self.subLbl.text = @"选填";
    }
}

- (void)updateCellWithDict{
    
    
    [self setNeedsDisplay];
}

@end


