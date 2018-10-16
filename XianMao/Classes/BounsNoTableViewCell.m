//
//  BounsNoTableViewCell.m
//  XianMao
//
//  Created by apple on 16/11/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BounsNoTableViewCell.h"

@interface BounsNoTableViewCell ()

@property (nonatomic, strong) XMWebImageView *noImageView;
@property (nonatomic, strong) UILabel *contentLbl;

@end

@implementation BounsNoTableViewCell

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:15.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_contentLbl sizeToFit];
        _contentLbl.text = @"暂时没有可用优惠券哦";
    }
    return _contentLbl;
}

-(XMWebImageView *)noImageView{
    if (!_noImageView) {
        _noImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _noImageView.image = [UIImage imageNamed:@"No_Card_MF"];
        [_noImageView sizeToFit];
    }
    return _noImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BounsNoTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 150;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BounsNoTableViewCell class]];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.noImageView];
        [self.contentView addSubview:self.contentLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.noImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(24);
        make.centerX.equalTo(self.contentView.mas_centerX);
        make.width.equalTo(@99);
        make.height.equalTo(@73);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.noImageView.mas_bottom).offset(20);
        make.centerX.equalTo(self.noImageView.mas_centerX);
    }];
    
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    
    
}

@end
