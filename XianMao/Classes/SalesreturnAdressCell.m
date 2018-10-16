//
//  SalesreturnAdressCell.m
//  XianMao
//
//  Created by WJH on 17/2/7.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SalesreturnAdressCell.h"

@interface SalesreturnAdressCell()

@property (nonatomic, strong) UIView * containerView;
@property (nonatomic, strong) UILabel * nameLbl;
@property (nonatomic, strong) UILabel * phoneLbl;
@property (nonatomic, strong) UILabel * addressLbl;
@property (nonatomic, strong) UIImageView * arrowIcon;
@property (nonatomic, strong) UIImageView * addressIcon;
@property (nonatomic, strong) UILabel * title;


@end

@implementation SalesreturnAdressCell


+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SalesreturnAdressCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    AddressInfo * addressInfo = [dict objectForKey:@"addressInfo"];
    CGFloat rowHeight = 37;
    if (addressInfo) {
        NSDictionary *Tdic  = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f],NSFontAttributeName, nil];
        CGRect  rect  = [[NSString stringWithFormat:@"%@%@",addressInfo.areaDetail,addressInfo.address] boundingRectWithSize:CGSizeMake(kScreenWidth/375*250, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:Tdic context:nil];
        rowHeight += rect.size.height;
        rowHeight += 15;
    }else{
        rowHeight += 37;
    }
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(AddressInfo *)addressInfo{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SalesreturnAdressCell class]];
    if (addressInfo) {
        [dict setObject:addressInfo forKey:@"addressInfo"];
    }
    return dict;
}

- (UIImageView *)addressIcon{
    if (!_addressIcon) {
        _addressIcon = [[UIImageView alloc] init];
        _addressIcon.image = [UIImage imageNamed:@"addressIcon"];
    }
    return _addressIcon;
}


- (UIView *)containerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.layer.masksToBounds = YES;
        _containerView.layer.cornerRadius = 2;
    }
    return _containerView;
}

- (UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc] init];
        _nameLbl.font = [UIFont systemFontOfSize:14];
        _nameLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_nameLbl sizeToFit];
    }
    return _nameLbl;
}

- (UILabel *)phoneLbl{
    if (!_phoneLbl) {
        _phoneLbl = [[UILabel alloc] init];
        _phoneLbl.font = [UIFont systemFontOfSize:14];
        _phoneLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_phoneLbl sizeToFit];
    }
    return _phoneLbl;
}

- (UILabel *)addressLbl{
    if (!_addressLbl) {
        _addressLbl = [[UILabel alloc] init];
        _addressLbl.font = [UIFont systemFontOfSize:14];
        _addressLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _addressLbl.numberOfLines = 0;
    }
    return _addressLbl;
}

- (UILabel *)title{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = [UIColor colorWithHexString:@"999999"];
        _title.numberOfLines = 0;
        _title.text = @"添加退货地址";
    }
    return _title;
}

- (UIImageView *)arrowIcon{
    if (!_arrowIcon) {
        _arrowIcon = [[UIImageView alloc] init];
        _arrowIcon.image = [UIImage imageNamed:@"Right_Allow_Gary"];
    }
    return _arrowIcon;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.nameLbl];
        [self.containerView addSubview:self.phoneLbl];
        [self.containerView addSubview:self.addressLbl];
        [self.containerView addSubview:self.arrowIcon];
        [self.containerView addSubview:self.title];
        [self.containerView addSubview:self.addressIcon];
    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary *)dict{
    
    AddressInfo * addressInfo  = [dict objectForKey:@"addressInfo"];
    if (addressInfo) {
        self.nameLbl.text =  addressInfo.receiver;
        self.phoneLbl.text = addressInfo.phoneNumber;
        self.addressLbl.text = [NSString stringWithFormat:@"%@%@",addressInfo.areaDetail,addressInfo.address];
        self.title.hidden = YES;
        self.addressIcon.hidden = YES;
    }else{
        self.title.hidden = NO;
        self.addressIcon.hidden = NO;
    }

}


- (void)layoutSubviews{
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    
    [self.addressIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.left.equalTo(self.containerView.mas_left).offset(20);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(13);
        make.left.equalTo(self.containerView.mas_left).offset(22);
    }];
    
    [self.phoneLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(13);
        make.right.equalTo(self.containerView.mas_right).offset(-45);
    }];
    
    [self.addressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_bottom).offset(20);
        make.left.equalTo(self.containerView.mas_left).offset(22);
        make.right.equalTo(self.containerView.mas_right).offset(-45);
    }];
    
    [self.arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-15);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.left.equalTo(self.addressIcon.mas_right).offset(15);
    }];
    
}

@end
