//
//  DetailParamCell.m
//  yuncangcat
//
//  Created by apple on 16/8/1.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "DetailParamCell.h"

@interface DetailParamCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *contentLbl;

@end

@implementation DetailParamCell

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:15.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"d1d1d1"];
        [_contentLbl sizeToFit];
        _contentLbl.text = @"越详细越好卖";
    }
    return _contentLbl;
}

-(UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.image = [UIImage imageNamed:@"Right_Allow_Gary"];
    }
    return _rightImageView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_titleLbl sizeToFit];
        _titleLbl.text = @"详细参数";
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([DetailParamCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 44.f;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)data
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[DetailParamCell class]];
    if (data) {
        [dict setObject:data forKey:@"data"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.contentLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.rightImageView.mas_left).offset(-10);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    NSString *content = dict[@"data"];
    if (content.length>0) {
        self.contentLbl.text = content;
    }
}

@end
