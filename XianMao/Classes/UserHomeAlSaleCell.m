//
//  UserHomeAlSaleCell.m
//  XianMao
//
//  Created by apple on 16/4/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "UserHomeAlSaleCell.h"
#import "Masonry.h"

@interface UserHomeAlSaleCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *rightImageView;

@end

@implementation UserHomeAlSaleCell

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.image = [UIImage imageNamed:@"Right_Allow_New_MF"];
    }
    return _rightImageView;
}


-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.text = @"我卖出的";
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([UserHomeAlSaleCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 44.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[UserHomeAlSaleCell class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.rightImageView];
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-18);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@9);
        make.height.equalTo(@15);
    }];

    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(18);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
