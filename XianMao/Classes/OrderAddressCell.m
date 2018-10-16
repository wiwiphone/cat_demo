//
//  OrderAddressCell.m
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderAddressCell.h"
#import "Masonry.h"

@interface OrderAddressCell ()



@end

@implementation OrderAddressCell

-(UILabel *)phoneNumLbl{
    if (!_phoneNumLbl) {
        _phoneNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _phoneNumLbl.font = [UIFont systemFontOfSize:14.f];
        _phoneNumLbl.textColor = [UIColor colorWithHexString:@"444444"];
        [_phoneNumLbl sizeToFit];
    }
    return _phoneNumLbl;
}

-(UILabel *)addressLbl{
    if (!_addressLbl) {
        _addressLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _addressLbl.font = [UIFont systemFontOfSize:14.f];
        _addressLbl.textColor = [UIColor colorWithHexString:@"444444"];
        _addressLbl.numberOfLines = 0;
        [_addressLbl sizeToFit];
    }
    return _addressLbl;
}

-(UILabel *)areaLbl{
    if (!_areaLbl) {
        _areaLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _areaLbl.font = [UIFont systemFontOfSize:14.f];
        _areaLbl.textColor = [UIColor colorWithHexString:@"444444"];
        [_areaLbl sizeToFit];
    }
    return _areaLbl;
}

-(UILabel *)name{
    if (!_name) {
        _name = [[UILabel alloc] initWithFrame:CGRectZero];
        _name.font = [UIFont systemFontOfSize:14.f];
        _name.textColor = [UIColor colorWithHexString:@"444444"];
        [_name sizeToFit];
    }
    return _name;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.image = [UIImage imageNamed:@"Order_Address_MF"];
        [_iconImageView sizeToFit];
    }
    return _iconImageView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderAddressCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict{
    CGFloat height = 100.0f;
//    AddressInfo *addressInfo = dict[@"addressInfo"];
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
//    lbl.text = addressInfo.address;
    
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(AddressInfo *)addressInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderAddressCell class]];
    if (addressInfo) {
        [dict setObject:addressInfo forKey:@"addressInfo"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.areaLbl];
        [self.contentView addSubview:self.addressLbl];
        [self.contentView addSubview:self.phoneNumLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.width.equalTo(@16);
        make.height.equalTo(@21);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.left.equalTo(self.iconImageView.mas_right).offset(14);
    }];
    
    [self.areaLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(5);
        make.left.equalTo(self.iconImageView.mas_right).offset(14);
    }];
    
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.areaLbl.mas_bottom).offset(1);
        make.left.equalTo(self.iconImageView.mas_right).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-kScreenWidth/375*50);
    }];
    
    [self.phoneNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}



-(void)updateCellWithDict:(NSDictionary *)dict{
    
    AddressInfo *addressInfo = dict[@"addressInfo"];
    self.name.text = addressInfo.receiver;
    self.areaLbl.text = addressInfo.areaDetail;
    self.addressLbl.text = addressInfo.address;
    self.phoneNumLbl.text = addressInfo.phoneNumber;
}

@end
