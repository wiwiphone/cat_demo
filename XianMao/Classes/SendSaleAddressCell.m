//
//  SendSaleAddressCell.m
//  XianMao
//
//  Created by WJH on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SendSaleAddressCell.h"
#import "Command.h"
#import "NSDate+Category.h"

@interface SendSaleAddressCell()

@property (nonatomic, strong) UIImageView * containerView;
@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UILabel * name;
@property (nonatomic, strong) UILabel * phone;
@property (nonatomic, strong) UILabel * address;
@property (nonatomic, strong) UILabel * status;
@property (nonatomic, strong) UILabel * time;

@end

@implementation SendSaleAddressCell


- (UILabel *)title{
    if (!_title) {
        _title = [self createBlackLabelWithColor:@"1a1a1a"];
        _title.text = @"退回地址";
    }
    return _title;
}

- (UILabel *)name{
    if (!_name) {
        _name = [self createBlackLabelWithColor:@"1a1a1a"];
    }
    return _name;
}

- (UILabel *)phone{
    if (!_phone) {
        _phone = [self createBlackLabelWithColor:@"1a1a1a"];
    }
    return _phone;
}

- (UILabel *)address{
    if (!_address) {
        _address = [self createBlackLabelWithColor:@"1a1a1a"];
        _address.numberOfLines = 0;
    }
    return _address;
}

- (UILabel *)time{
    if (!_time) {
        _time = [self createBlackLabelWithColor:@"b2b2b2"];
    }
    return _time;
}

- (UILabel *)status{
    if (!_status) {
        _status = [self createBlackLabelWithColor:@"b2b2b2"];
    }
    return _status;
}

- (UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.image = [UIImage imageNamed:@"bg_mid"];
    }
    return _containerView;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SendSaleAddressCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    SendSaleVo * sendVo = [dict objectForKey:@"sendVo"];
    CGFloat rowHeight = 100;
    NSDictionary *Tdic  = [[NSDictionary alloc] initWithObjectsAndKeys:[UIFont systemFontOfSize:14.0f],NSFontAttributeName, nil];
    CGRect  rect  = [sendVo.returnAddress boundingRectWithSize:CGSizeMake(kScreenWidth/375*300, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:Tdic context:nil];
    rowHeight += rect.size.height;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(SendSaleVo *)sendVo{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SendSaleAddressCell class]];
    if (sendVo) {
        [dict setObject:sendVo forKey:@"sendVo"];
    }
    return dict;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView setBackgroundColor:[UIColor colorWithHexString:@"f2f2f2"]];
        [self.contentView addSubview:self.containerView];
        CALayer * line = [[CALayer alloc] init];
        line.frame = CGRectMake(22, 0, kScreenWidth-44-22, 0.5);
        line.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
        [self.containerView.layer addSublayer:line];
        
        
        [self.containerView addSubview:self.title];
        [self.containerView addSubview:self.name];
        [self.containerView addSubview:self.phone];
        [self.containerView addSubview:self.address];
        [self.containerView addSubview:self.time];
        [self.containerView addSubview:self.status];
    }
    return self;
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    
    SendSaleVo * sendVo = [dict objectForKey:@"sendVo"];
    
    self.name.text = sendVo.userName;
    self.phone.text = sendVo.phone;
    if (sendVo.outLineTime > 0) {
        NSDate *onlineDate = [NSDate dateWithTimeIntervalSince1970:sendVo.outLineTime/1000];
        self.time.text = [NSString stringWithFormat:@"%@",[onlineDate XMformattedDateDescription]];
    }
    self.status.text = sendVo.statusDesc;
    self.address.text = sendVo.returnAddress;
}

- (UILabel *)createBlackLabelWithColor:(NSString *)color{
    UILabel * lbl = [[UILabel alloc] init];
    lbl.textColor = [UIColor colorWithHexString:color];
    lbl.font = [UIFont systemFontOfSize:13];
    [lbl sizeToFit];
    return lbl;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView.mas_top).offset(10);
        make.left.equalTo(self.containerView.mas_left).offset(18);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(13);
        make.left.equalTo(self.containerView.mas_left).offset(18);
    }];
    
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.title.mas_bottom).offset(13);
        make.right.equalTo(self.containerView.mas_right).offset(-18);
    }];
    
    [self.address mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.containerView.mas_left).offset(18);
        make.right.equalTo(self.containerView.mas_right).offset(-18);
        make.top.equalTo(self.name.mas_bottom).offset(10);
    }];
    
    [self.time mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.address.mas_bottom).offset(10);
        make.left.equalTo(self.containerView.mas_left).offset(18);
    }];
    
    [self.status mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.time.mas_top);
        make.right.equalTo(self.containerView.mas_right).offset(-18);
    }];
}
@end
