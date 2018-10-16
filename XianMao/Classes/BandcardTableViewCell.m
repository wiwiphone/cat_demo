//
//  BandcardTableViewCell.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BandcardTableViewCell.h"
#import "URLScheme.h"

@interface BandcardTableViewCell()

@property (nonatomic,strong) UILabel * bank;
@property (nonatomic,strong) UILabel * bankName;
@property (nonatomic,strong) UILabel * bankCarNum;
@property (nonatomic,strong) UILabel * number;
@property (nonatomic,strong) UIView * line;

@property (nonatomic,strong) UILabel * name;
@property (nonatomic,strong) UILabel * userName;
@property (nonatomic,strong) UILabel * IDcard;
@property (nonatomic,strong) UILabel * IDcardNum;

@end



@implementation BandcardTableViewCell

-(UILabel *)IDcardNum
{
    if (!_IDcardNum) {
        _IDcardNum = [[UILabel alloc] init];
        _IDcardNum.textColor = [UIColor colorWithHexString:@"434342"];
        _IDcardNum.font = [UIFont systemFontOfSize:14];
        _IDcardNum.textAlignment = NSTextAlignmentLeft;
        [_IDcardNum sizeToFit];
    }
    return _IDcardNum;
}

-(UILabel *)IDcard
{
    if (!_IDcard) {
        _IDcard = [[UILabel alloc] init];
        _IDcard.textColor = [UIColor colorWithHexString:@"434342"];
        _IDcard.font = [UIFont systemFontOfSize:14];
        _IDcard.textAlignment = NSTextAlignmentLeft;
        _IDcard.text = @"身份证号";
        [_IDcard sizeToFit];
    }
    return _IDcard;
}

-(UILabel *)userName
{
    if (!_userName) {
        _userName = [[UILabel alloc] init];
        _userName.textColor = [UIColor colorWithHexString:@"434342"];
        _userName.font = [UIFont systemFontOfSize:14];
        _userName.textAlignment = NSTextAlignmentLeft;
        [_userName sizeToFit];
    }
    return _userName;
}

-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = [UIColor colorWithHexString:@"434342"];
        _name.font = [UIFont systemFontOfSize:14];
        _name.textAlignment = NSTextAlignmentLeft;
        _name.text = @"姓名";
        [_name sizeToFit];
    }
    return _name;
}


-(UIView *)line
{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _line;
}


-(UILabel *)bank
{
    if (!_bank) {
        _bank = [[UILabel alloc] init];
        _bank.textColor = [UIColor colorWithHexString:@"434342"];
        _bank.font = [UIFont systemFontOfSize:14];
        _bank.textAlignment = NSTextAlignmentLeft;
        _bank.text = @"银行";
        [_bank sizeToFit];
    }
    return _bank;
}

-(UILabel *)bankName
{
    if (!_bankName) {
        _bankName = [[UILabel alloc] init];
        _bankName.textColor = [UIColor colorWithHexString:@"434342"];
        _bankName.textAlignment = NSTextAlignmentRight;
        _bankName.font = [UIFont systemFontOfSize:14];
        [_bankName sizeToFit];
    }
    return _bankName;
}


-(UILabel *)bankCarNum
{
    if (!_bankCarNum) {
        _bankCarNum = [[UILabel alloc] init];
        _bankCarNum.textColor = [UIColor colorWithHexString:@"434342"];
        _bankCarNum.font = [UIFont systemFontOfSize:14];
        _bankCarNum.textAlignment = NSTextAlignmentLeft;
        _bankCarNum.text = @"银行卡号";
        [_bankCarNum sizeToFit];
    }
    return _bankCarNum;
}


-(UILabel *)number
{
    if (!_number) {
        _number = [[UILabel alloc] init];
        _number.textColor = [UIColor colorWithHexString:@"434342"];
        _number.textAlignment = NSTextAlignmentRight;
        _number.font = [UIFont systemFontOfSize:14];
        [_number sizeToFit];
    }
    return _number;
}



+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([BandcardTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    
    return  88*2+12;
}

+ (NSMutableDictionary*)buildCellDict:(WithdrawalsAccountVo *)withdrawaAccount
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[BandcardTableViewCell class]];
    if (withdrawaAccount) {
        [dict setObject:withdrawaAccount forKey:@"withdrawaAccount"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    WithdrawalsAccountVo * withdrawalsVo = dict[@"withdrawaAccount"];
    
    if(withdrawalsVo.bankName){
        self.bankName.text = withdrawalsVo.bankName;
    }
    
    if(withdrawalsVo.account){
        self.number.text = withdrawalsVo.account;
    }

    if(withdrawalsVo.belong){
        self.userName.text = withdrawalsVo.belong;
    }

    if(withdrawalsVo.identityCard){
        self.IDcardNum.text = withdrawalsVo.identityCard;
    }
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.number];
        [self.contentView addSubview:self.bankCarNum];
        [self.contentView addSubview:self.bankName];
        [self.contentView addSubview:self.bank];
        [self.contentView addSubview:self.line];
        [self.contentView addSubview:self.name];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.IDcard];
        [self.contentView addSubview:self.IDcardNum];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.top.equalTo(self.contentView.mas_top).offset(18);
    }];
    
    [self.bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bank.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
    [self.bankCarNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.top.equalTo(self.bank.mas_bottom).offset(25);
    }];
    
    [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.top.equalTo(self.bankCarNum.mas_top);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right);
        make.left.equalTo(self.contentView.mas_left);
        make.height.mas_equalTo(@12);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(18);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
    [self.IDcard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(25);
        make.left.equalTo(self.contentView.mas_left).offset(14);

    }];
    
    [self.IDcardNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.IDcard.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}

@end


@interface alipayAccountCell()

@property (nonatomic,strong) UILabel * bank;
@property (nonatomic,strong) UILabel * bankName;
@property (nonatomic,strong) UILabel * bankCarNum;
@property (nonatomic,strong) UILabel * number;

@end

@implementation alipayAccountCell

-(UILabel *)bank
{
    if (!_bank) {
        _bank = [[UILabel alloc] init];
        _bank.textColor = [UIColor colorWithHexString:@"434342"];
        _bank.font = [UIFont systemFontOfSize:14];
        _bank.textAlignment = NSTextAlignmentLeft;
        _bank.text = @"支付宝实名";
        [_bank sizeToFit];
    }
    return _bank;
}

-(UILabel *)bankName
{
    if (!_bankName) {
        _bankName = [[UILabel alloc] init];
        _bankName.textColor = [UIColor colorWithHexString:@"434342"];
        _bankName.textAlignment = NSTextAlignmentRight;
        _bankName.font = [UIFont systemFontOfSize:14];
        [_bankName sizeToFit];
    }
    return _bankName;
}


-(UILabel *)bankCarNum
{
    if (!_bankCarNum) {
        _bankCarNum = [[UILabel alloc] init];
        _bankCarNum.textColor = [UIColor colorWithHexString:@"434342"];
        _bankCarNum.font = [UIFont systemFontOfSize:14];
        _bankCarNum.textAlignment = NSTextAlignmentLeft;
        _bankCarNum.text = @"支付宝账号";
        [_bankCarNum sizeToFit];
    }
    return _bankCarNum;
}

-(UILabel *)number
{
    if (!_number) {
        _number = [[UILabel alloc] init];
        _number.textColor = [UIColor colorWithHexString:@"434342"];
        _number.textAlignment = NSTextAlignmentRight;
        _number.font = [UIFont systemFontOfSize:14];
        [_number sizeToFit];
    }
    return _number;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.number];
        [self.contentView addSubview:self.bankCarNum];
        [self.contentView addSubview:self.bankName];
        [self.contentView addSubview:self.bank];
    }
    return self;
}

+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([alipayAccountCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    
    return  88;
}

+ (NSMutableDictionary*)buildCellDict:(WithdrawalsAccountVo *)withdrawaAccount
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[alipayAccountCell class]];
    if (withdrawaAccount) {
        [dict setObject:withdrawaAccount forKey:@"alipayWithdrawaAccount"];
    }
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{
    WithdrawalsAccountVo * withdrawalsVo = dict[@"alipayWithdrawaAccount"];
    
    if(withdrawalsVo.bankName){
        self.bankName.text = withdrawalsVo.belong;
    }
    
    if(withdrawalsVo.account){
        self.number.text = withdrawalsVo.account;
    }
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.bank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.top.equalTo(self.contentView.mas_top).offset(18);
    }];
    
    [self.bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bank.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
    
    [self.bankCarNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(14);
        make.top.equalTo(self.bank.mas_bottom).offset(25);
    }];
    
    [self.number mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-14);
        make.top.equalTo(self.bankCarNum.mas_top);
    }];

}


@end



@interface ServerTelCell()

@property (nonatomic,strong) UILabel * title;
@property (nonatomic,strong) UILabel * phoneNumber;

@end

@implementation ServerTelCell


-(UILabel *)title
{
    if (!_title) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize:14];
        _title.textColor = [UIColor colorWithHexString:@"434342"];
        _title.textAlignment = NSTextAlignmentLeft;
        _title.text = @"修改银行卡需要拨打客服电话";
        [_title sizeToFit];
    }
    return _title;
}


-(UILabel *)phoneNumber
{
    if (!_phoneNumber) {
        _phoneNumber = [[UILabel alloc] init];
        _phoneNumber.font = [UIFont systemFontOfSize:14];
        _phoneNumber.textColor = [UIColor colorWithHexString:@"00bbdf"];
        _phoneNumber.textAlignment = NSTextAlignmentRight;
        _phoneNumber.text = kCustomServicePhoneDisplay;
        [_phoneNumber sizeToFit];
    }
    return _phoneNumber;
}


+ (NSString *)reuseIdentifier
{
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ServerTelCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict
{
    
    return  45;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ServerTelCell class]];
    return dict;
}

-(void)updateCellWithDict:(NSDictionary *)dict
{

}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.phoneNumber];
        [self.contentView addSubview:self.title];
    }
    return self;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(14);
    }];
    
    
    [self.phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-14);
    }];
}


@end
