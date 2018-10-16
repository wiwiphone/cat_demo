//
//  WashGoodsChooseCell.m
//  XianMao
//
//  Created by apple on 16/10/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WashGoodsChooseCell.h"

@interface WashGoodsChooseCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subLbl;

@property (nonatomic, strong) UIButton *chooseBtn;
@end

@implementation WashGoodsChooseCell

-(UIButton *)chooseBtn{
    if (!_chooseBtn) {
        _chooseBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_chooseBtn setImage:[UIImage imageNamed:@"UnChoose"] forState:UIControlStateNormal];
        [_chooseBtn setImage:[UIImage imageNamed:@"JiangxinWashChoose"] forState:UIControlStateSelected];
    }
    return _chooseBtn;
}

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.font = [UIFont systemFontOfSize:13.f];
        _subLbl.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont boldSystemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"000000"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 15.f;
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([WashGoodsChooseCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 48;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(GoodsGuarantee *)guarantee
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[WashGoodsChooseCell class]];
    if (guarantee) {
        [dict setObject:guarantee forKey:@"guarantee"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    GoodsGuarantee *guarantee = dict[@"guarantee"];
    [self.iconImageView setImageWithURL:guarantee.iconUrl XMWebImageScaleType:XMWebImageScale480x480];
    self.titleLbl.text = guarantee.title;
    self.subLbl.text = guarantee.name;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.subLbl];
        [self.contentView addSubview:self.chooseBtn];
        self.chooseBtn.selected = YES;
        [self.chooseBtn addTarget:self action:@selector(clickChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickChooseBtn:(UIButton *)sender{
    if (sender.selected == NO) {
        sender.selected = YES;
    } else {
        sender.selected = NO;
    }
    
    if (self.clickXihuChooseBtn) {
        self.clickXihuChooseBtn(sender);
    }
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-1);
    }];
    
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.self.iconImageView.mas_right).offset(12);
        make.top.equalTo(self.contentView.mas_centerY).offset(1);
    }];
    
    [self.chooseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-12);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
}

@end
