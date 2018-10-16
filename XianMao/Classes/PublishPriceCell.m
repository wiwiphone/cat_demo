//
//  PublishPriceCell.m
//  yuncangcat
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "PublishPriceCell.h"
#import "Command.h"
#import "ExplainView.h"
#import "WCAlertView.h"

@interface PublishPriceCell () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * yuanPriceLbl;
@property (nonatomic, strong) UILabel * jianyiPriceLbl;
@property (nonatomic, strong) UILabel * desLbl;
@property (nonatomic, strong) UIImageView * rightImageView;
@end

@implementation PublishPriceCell

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];
        _rightImageView.image = [UIImage imageNamed:@"Right_Allow_Gary"];
    }
    return _rightImageView;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _title.text = @"价格";
    }
    return _title;
}

- (UILabel *)desLbl{
    if (!_desLbl) {
        _desLbl = [[UILabel alloc] init];
        _desLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _desLbl.font = [UIFont systemFontOfSize:15];
        _desLbl.text = @"¥0";
    }
    return _desLbl;
}

- (UILabel *)yuanPriceLbl{
    if (!_yuanPriceLbl) {
        _yuanPriceLbl = [[UILabel alloc] init];
        _yuanPriceLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _yuanPriceLbl.font = [UIFont systemFontOfSize:15];
    }
    return _yuanPriceLbl;
}

- (UILabel *)jianyiPriceLbl{
    if (!_jianyiPriceLbl) {
        _jianyiPriceLbl = [[UILabel alloc] init];
        _jianyiPriceLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _jianyiPriceLbl.font = [UIFont systemFontOfSize:15];
    }
    return _jianyiPriceLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PublishPriceCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 43.f;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSString *)yuanPrice diaohuoPrice:(NSString *)diaohuoPrice jianyiPrice:(NSString *)jianyiPrice
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PublishPriceCell class]];
    if (yuanPrice) {
        [dict setObject:yuanPrice forKey:@"yuanPrice"];
    }
    if (diaohuoPrice) {
        [dict setObject:diaohuoPrice forKey:@"diaohuoPrice"];
    }
    if (jianyiPrice) {
        [dict setObject:jianyiPrice forKey:@"jianyiPrice"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.yuanPriceLbl];
        [self.contentView addSubview:self.jianyiPriceLbl];
        
        [self.contentView addSubview:self.rightImageView];
        [self.contentView addSubview:self.desLbl];

    }
    return self;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
    }];
    
    [self.desLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.rightImageView.mas_right).offset(-15);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(15);
    }];
    
    [self.yuanPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.rightImageView.mas_right).offset(-15);
    }];
    
    [self.jianyiPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX);
        make.centerY.equalTo(self.contentView.mas_centerY);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    NSString *yuanPrice = dict[@"yuanPrice"];
    NSString *jianyiPrice = dict[@"jianyiPrice"];
    self.jianyiPriceLbl.text = jianyiPrice;
    self.yuanPriceLbl.text = [NSString stringWithFormat:@"买入价 ¥%@",yuanPrice];
    if (yuanPrice.integerValue>0 || jianyiPrice.integerValue>0) {
        self.desLbl.hidden = YES;
        self.jianyiPriceLbl.hidden = NO;
        self.yuanPriceLbl.hidden = NO;
        
        if (yuanPrice.integerValue > 0) {
            self.yuanPriceLbl.hidden = NO;
        }else{
            self.yuanPriceLbl.hidden = YES;
        }
        
        
    }else{
        self.desLbl.hidden = NO;
        self.jianyiPriceLbl.hidden = YES;
        self.yuanPriceLbl.hidden = YES;
    }
}

@end
