//
//  SendSaleOrderTimeCell.m
//  XianMao
//
//  Created by WJH on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SendSaleOrderTimeCell.h"

@interface SendSaleOrderTimeCell()

@property (nonatomic, strong) UILabel * titleLbl;
@property (nonatomic, strong) UILabel * priceLbl;
@property (nonatomic, strong) UIButton * btn;
@property (nonatomic, strong) UIButton * btnWai;
@property (nonatomic, strong) UIImageView * containerView;
@property (nonatomic, copy) NSString *str;

@end

@implementation SendSaleOrderTimeCell
- (UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.userInteractionEnabled = YES;
        _containerView.image = [UIImage imageNamed:@"bg_mid"];
    }
    return _containerView;
}

-(UIButton *)btnWai{
    if (!_btnWai) {
        _btnWai = [[UIButton alloc] initWithFrame:CGRectZero];
        _btnWai.backgroundColor = [UIColor clearColor];
    }
    return _btnWai;
}

-(UIButton *)btn{
    if (!_btn) {
        _btn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_btn setTitle:@"复制" forState:UIControlStateNormal];
        _btn.userInteractionEnabled = YES;
        [_btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _btn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        _btn.layer.borderWidth = 0.5;
        _btn.layer.masksToBounds = YES;
        _btn.layer.cornerRadius = 8;
    }
    return _btn;
}

-(UILabel *)priceLbl{
    if (!_priceLbl) {
        _priceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _priceLbl.font = [UIFont systemFontOfSize:14.f];
        _priceLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_priceLbl sizeToFit];
    }
    return _priceLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:14.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SendSaleOrderTimeCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 30.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSNumber *)price title:(NSString *)title isCopy:(BOOL)isCopy orderId:(NSString *)orderId
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SendSaleOrderTimeCell class]];
    if (price) {
        [dict setObject:price forKey:@"price"];
    }
    if (title) {
        [dict setObject:title forKey:@"title"];
    }
    if (isCopy) {
        [dict setObject:[NSNumber numberWithBool:isCopy] forKey:@"isCopy"];
    }
    if (orderId) {
        [dict setObject:orderId forKey:@"orderId"];
    }
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.titleLbl];
        [self.containerView addSubview:self.priceLbl];
        [self.containerView addSubview:self.btn];
        [self.containerView addSubview:self.btnWai];
        
        [self.btnWai addTarget:self action:@selector(clickCopyBtnWai) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickCopyBtnWai{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.str;
    [[CoordinatingController sharedInstance] showHUD:@"复制成功" hideAfterDelay:0.8];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    
    NSString *orderId = [dict stringValueForKey:@"orderId"];
    self.str = orderId;
    self.titleLbl.text = dict[@"title"];
    if (orderId.length > 0) {
        self.priceLbl.text = orderId;
    } else {
        self.priceLbl.text = [NSString stringWithFormat:@"¥%@", dict[@"price"]];
    }
    
    NSNumber *num = dict[@"isCopy"];
    if ([num isEqualToNumber:@1]) {
        self.btn.hidden = NO;
        self.btnWai.hidden = NO;
    } else {
        self.btn.hidden = YES;
        self.btnWai.hidden = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.bottom.equalTo(self.contentView.mas_bottom);
    }];
    
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.left.equalTo(self.containerView.mas_left).offset(18);
    }];
    
    [self.priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.right.equalTo(self.containerView.mas_right).offset(-18);
    }];
    
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.right.equalTo(self.priceLbl.mas_left).offset(-5);
        make.height.equalTo(@16);
        make.width.equalTo(@38);
    }];
    
    [self.btnWai mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.containerView.mas_centerY);
        make.right.equalTo(self.priceLbl.mas_left).offset(-5);
        make.height.equalTo(@50);
        make.width.equalTo(@70);
    }];
}




@end
