//
//  HandsetCell.m
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "HandsetCell.h"

@interface HandsetCell()

@property (nonatomic, strong) UILabel * userName;
@property (nonatomic, strong) UILabel * address;

@end

@implementation HandsetCell

-(UILabel *)userName
{
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"333333"];
        _userName.font = [UIFont systemFontOfSize:15];
        _userName.textAlignment = NSTextAlignmentLeft;
    }
    return _userName;
}

-(UILabel *)address
{
    if (!_address) {
        _address = [[UILabel alloc] init];
        _address.textColor = [UIColor colorWithHexString:@"333333"];
        _address.font = [UIFont systemFontOfSize:15];
        _address.textAlignment = NSTextAlignmentLeft;
        _address.numberOfLines = 0;
    }
    return _address;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.address];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(17);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
    
    
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userName.mas_bottom).offset(13);
        make.left.equalTo(self.contentView.mas_left).offset(12);
        make.right.equalTo(self.contentView.mas_right).offset(-12);
    }];
}


+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([HandsetCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    CGFloat height = 45;
    AddressInfo *addressInfo = dict[@"addressInfo"];
    NSString * address = [NSString stringWithFormat:@"收货地址:%@%@", addressInfo.areaDetail, addressInfo.address];
    NSDictionary *Tdic  = [[NSDictionary alloc]initWithObjectsAndKeys:[UIFont systemFontOfSize:15.0f],NSFontAttributeName, nil];
    CGRect  rect  = [address boundingRectWithSize:CGSizeMake(kScreenWidth - 25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:Tdic context:nil];
    height += rect.size.height + 16;
    return height;
}

+ (NSMutableDictionary *)buildCellDict:(AddressInfo *)addressInfo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[HandsetCell class]];
    if (addressInfo) {
        [dict setObject:addressInfo forKey:@"addressInfo"];
    }
    return dict;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    
    AddressInfo *addressInfo = dict[@"addressInfo"];
    
    self.userName.text = [NSString stringWithFormat:@"收件人:%@ %@", addressInfo.receiver, addressInfo.phoneNumber];
    self.address.text = [NSString stringWithFormat:@"收货地址:%@%@", addressInfo.areaDetail, addressInfo.address];
}


@end
