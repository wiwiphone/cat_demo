//
//  RecoveryCell2.m
//  XianMao
//
//  Created by apple on 16/3/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoveryCell2.h"
#import "Masonry.h"

@interface RecoveryCell2 ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *rightImage;
@property (nonatomic, strong) UILabel *subLbl;

@end

@implementation RecoveryCell2

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
        _titleLbl.text = @"1111";
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
        __reuseIdentifier = NSStringFromClass([RecoveryCell2 class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 42;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[RecoveryCell2 class]];
    
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
        make.right.equalTo(self.rightImage.mas_left).offset(-10);
    }];
}

-(void)turnRightImage:(NSInteger)index{
    if (index == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.rightImage.transform = CGAffineTransformMakeRotation(M_PI);
        }];
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            self.rightImage.transform = CGAffineTransformMakeRotation(0);
        }];
    }
}

-(void)setTitleText2:(NSString *)titleStr andImageName:(NSString *)imageName{
    self.titleLbl.text = titleStr;
    self.rightImage.image = [UIImage imageNamed:imageName];
    self.subLbl.text = @"选填";
}

- (void)updateCellWithDict{
    
    
    [self setNeedsDisplay];
}

@end
