//
//  ServiceIconCell.m
//  XianMao
//
//  Created by WJH on 16/10/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ServiceIconCell.h"
#import "WebViewController.h"

@interface ServiceIconCell()

@property (nonatomic, strong) UIImageView * serViceIcon;
@property (nonatomic, strong) UIImageView * bgImg;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) UILabel * decsLbl;

@end

@implementation ServiceIconCell

-(UILabel *)decsLbl
{
    if (!_decsLbl) {
        _decsLbl = [[UILabel alloc] init];
        _decsLbl.textColor = [UIColor colorWithHexString:@"888888"];
        _decsLbl.font = [UIFont systemFontOfSize:10];
        [_decsLbl sizeToFit];
    }
    return _decsLbl;
}

-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor colorWithHexString:@"f4433e"];
        [_title sizeToFit];
    }
    return _title;
}

-(UIImageView *)serViceIcon
{
    if (!_serViceIcon) {
        _serViceIcon = [[UIImageView alloc] init];
        _serViceIcon.image = [UIImage imageNamed:@"xihuIcon_new"];
    }
    return _serViceIcon;
}

-(UIImageView *)bgImg
{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.image = [UIImage imageNamed:@"servebg_new"];
    }
    return _bgImg;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ServiceIconCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 60;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsGuarantee *)goodsGuarantee
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ServiceIconCell class]];
    if (goodsGuarantee) {
        [dict setObject:goodsGuarantee forKey:@"goodsGuarantee"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    GoodsGuarantee * goodsGuarantee = dict[@"goodsGuarantee"];
    self.title.text = goodsGuarantee.title;
    self.url = goodsGuarantee.url;
    self.decsLbl.text = goodsGuarantee.name;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.bgImg];
        [self.bgImg addSubview:self.title];
        [self.bgImg addSubview:self.serViceIcon];
        [self.bgImg addSubview:self.decsLbl];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.serViceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(12);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serViceIcon.mas_right).offset(5);
        make.bottom.equalTo(self.contentView.mas_centerY);
    }];
    
    [self.decsLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.serViceIcon.mas_right).offset(5);
        make.top.equalTo(self.contentView.mas_centerY).offset(5);
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    WebViewController *serviceWeb = [[WebViewController alloc] init];
    serviceWeb.url = self.url;
    [[CoordinatingController sharedInstance] pushViewController:serviceWeb animated:YES];
}
@end
