//
//  EMChatAutoReplyCell.m
//  XianMao
//
//  Created by WJH on 16/9/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "EMChatAutoReplyCell.h"

@interface EMChatAutoReplyCell()
@property (nonatomic, strong) UILabel * autoReplyLabel;
@end

@implementation EMChatAutoReplyCell

-(UILabel *)autoReplyLabel
{
    if (!_autoReplyLabel) {
        _autoReplyLabel = [[UILabel alloc] init];
        _autoReplyLabel.textColor = [UIColor blackColor];
        _autoReplyLabel.font = [UIFont systemFontOfSize:13];
    }
    return _autoReplyLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.autoReplyLabel];
        self.contentView.backgroundColor = [UIColor redColor];
    }
    return self;
}

-(void)setAutoReplyString:(NSString *)autoReplyString
{
    _autoReplyString = autoReplyString;
    self.autoReplyLabel.text = [NSString stringWithFormat:@"%@",autoReplyString];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.autoReplyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(10);
    }];
}
@end
