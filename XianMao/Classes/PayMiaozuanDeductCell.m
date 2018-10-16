//
//  PayMiaozuanDeductCell.m
//  XianMao
//
//  Created by apple on 16/12/17.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PayMiaozuanDeductCell.h"

@interface PayMiaozuanDeductCell ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UISwitch *switchChoose;

@property (nonatomic, strong) ShoppingCartItem *item;
@end

@implementation PayMiaozuanDeductCell

-(UISwitch *)switchChoose{
    if (!_switchChoose) {
        _switchChoose = [[UISwitch alloc] initWithFrame:CGRectZero];
        _switchChoose.tintColor = [UIColor colorWithHexString:@"e5e5e5"];
        _switchChoose.onTintColor = [UIColor colorWithHexString:@"333333"];
    }
    return _switchChoose;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:12.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"PayMiaozuan"];
        [_iconImageView sizeToFit];
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PayMiaozuanDeductCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait {
    
    CGFloat rowHeight = 50.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(ShoppingCartItem *)item meowReduceVo:(MeowReduceVo *)meowReduceVo{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PayMiaozuanDeductCell class]];
    if (item) {
        [dict setObject:item forKey:@"item"];
    }
    if (meowReduceVo) {
        [dict setObject:meowReduceVo forKey:@"meowReduceVo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.iconImageView];
        self.iconImageView.layer.masksToBounds = YES;
        self.iconImageView.layer.cornerRadius = self.iconImageView.width/2;
        
        [self.contentView addSubview:self.titleLbl];
        [self.contentView addSubview:self.switchChoose];
        
        [self.switchChoose addTarget:self action:@selector(changeSelected:) forControlEvents:UIControlEventValueChanged];
        
    }
    return self;
}

-(void)changeSelected:(UISwitch *)sender{
    self.item.isOnDik = !sender.on;
    self.item.is_use_meow = sender.on;
    if (self.miaozuandikouSelected) {
        self.miaozuandikouSelected(self.item);
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
    }];
    
    [self.switchChoose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    ShoppingCartItem *item = [dict objectForKey:@"item"];
    MeowReduceVo *meoReduceVo = dict[@"meowReduceVo"];
    
    self.titleLbl.text = meoReduceVo.title;
    
    self.item = item;
    
//    if (meoReduceVo) {
//        self.item.is_use_meow = 1;
//    } else {
//        self.item.is_use_meow = 0;
//    }
    
    if (item.isOnDik) {
        self.switchChoose.on = NO;
        self.item.is_use_meow = 0;
    } else {
        self.switchChoose.on = YES;
        self.item.is_use_meow = 1;
    }
}

@end
