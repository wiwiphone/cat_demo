//
//  TagsExplainCell.m
//  XianMao
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "TagsExplainCell.h"

@interface TagsExplainCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;

@end

@implementation TagsExplainCell

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:12.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"949494"];
        _contentLbl.numberOfLines = 0;
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 10.f;
    }
    return _iconImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.titleLbl];
        [self addSubview:self.contentLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.iconImageView.mas_top);
        make.left.equalTo(self.iconImageView.mas_right).offset(10);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(10);
        make.left.equalTo(self.titleLbl.mas_left);
        make.right.equalTo(self.mas_right).offset(-12);
    }];
    
}

-(void)getApproveTagInfo:(ApproveTagInfo *)tagInfo{
    
    [self.iconImageView setImageWithURL:tagInfo.iconUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.titleLbl.text = tagInfo.name;
    self.contentLbl.text = tagInfo.value;
    
}

@end
