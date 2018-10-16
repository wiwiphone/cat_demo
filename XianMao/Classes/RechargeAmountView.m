//
//  RechargeAmountView.m
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RechargeAmountView.h"
#import "RechargeRule.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "PayWayDO.h"
#import "PayWayButton.h"
#import "TTTAttributedLabel.h"
#import "WebViewController.h"
#import "URLScheme.h"
#import "WCAlertView.h"
#import "PayManager.h"
#import "RechargeSucViewController.h"

@interface RechargeAmountView()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) UILabel * chooseMoney;
@property (nonatomic, strong) UIView * line1;
@property (nonatomic, strong) UIView * line2;
@property (nonatomic, strong) UILabel * rechageDesc;
@property (nonatomic, strong) UIButton * rechageButton;
@property (nonatomic, strong) TTTAttributedLabel * rechageDeal;

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, assign) NSInteger pay_way;
@property (nonatomic, copy) NSString * pay_amount;
@property (nonatomic, assign) NSInteger pay_card_type;
@end

@implementation RechargeAmountView

-(TTTAttributedLabel *)rechageDeal
{
    if (!_rechageDeal) {
        _rechageDeal = [[TTTAttributedLabel alloc] init];
        _rechageDeal.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _rechageDeal.font = [UIFont systemFontOfSize:12];
        _rechageDeal.delegate = self;
        [_rechageDeal sizeToFit];
    }
    return _rechageDeal;
}

-(UILabel *)rechageDesc
{
    if (!_rechageDesc) {
        _rechageDesc = [[UILabel alloc] init];
        _rechageDesc.textColor = [UIColor colorWithHexString:@"999999"];
        _rechageDesc.font = [UIFont systemFontOfSize:10];
        _rechageDesc.adjustsFontSizeToFitWidth = YES;
        _rechageDesc.textAlignment = NSTextAlignmentCenter;
        [_rechageDesc sizeToFit];
    }
    return _rechageDesc;
}

-(UIView *)line1
{
    if (!_line1) {
        _line1 = [[UIView alloc] init];
        _line1.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }
    return _line1;
}


-(UIView *)line2
{
    if (!_line2) {
        _line2 = [[UIView alloc] init];
        _line2.backgroundColor = [UIColor colorWithHexString:@"999999"];
    }
    return _line2;
}

-(UIButton *)rechageButton
{
    if (!_rechageButton) {
        _rechageButton = [[UIButton alloc] init];
        _rechageButton.backgroundColor = [UIColor colorWithHexString:@"000000"];
        [_rechageButton setTitle:@"立即充值" forState:UIControlStateNormal];
        _rechageButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _rechageButton;
}


-(UILabel *)chooseMoney
{
    if (!_chooseMoney) {
        _chooseMoney = [[UILabel alloc] init];
        _chooseMoney.textColor = [UIColor colorWithString:@"999999"];
        _chooseMoney.text = @"选择充值金额";
        _chooseMoney.font = [UIFont systemFontOfSize:12];
        [_chooseMoney sizeToFit];
     }
    return _chooseMoney;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.chooseMoney];
        [self addSubview:self.line1];
        [self addSubview:self.line2];
        [self addSubview:self.rechageDesc];
        [self addSubview:self.rechageButton];
        
        [self.rechageButton addTarget:self action:@selector(rechageButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self.rechageDeal setText:@"点击立即充值,即表示已阅读并同意《充值协议》" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange stringRange = NSMakeRange(mutableAttributedString.length-6,6);
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"f4433e"] CGColor] range:stringRange];
            return mutableAttributedString;
        }];
        self.rechageDeal.linkAttributes = nil;
        [self.rechageDeal addLinkToURL:[NSURL URLWithString:kURLRecharge] withRange:NSMakeRange([self.rechageDeal.text length]-6,6)];
        self.pay_way = -1;
        [self addSubview:self.rechageDeal];
    }
    return self;
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.title = @"充值协议";
    viewController.url = [url absoluteString];
    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
}

-(void)setDataSources:(NSMutableArray *)dataSources
{
    _dataSources = dataSources;

    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"recharge" path:@"pay_way_list" parameters:nil completionBlock:^(NSDictionary *data) {
        
        for (int i = 0; i < dataSources.count; i++) {
            RechargeRule * rechargeRule = [dataSources objectAtIndex:i];
            RechargeRuleButton * button = [[RechargeRuleButton alloc] initWithFrame:CGRectMake(kScreenWidth/375*45+(i%3)*(kScreenWidth/375*100), 46+(i/3)*60, kScreenWidth/375*85, 45)];
            button.tag = 100 + i;
            button.rechargeRule = rechargeRule;
            button.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
            button.layer.borderWidth = 1;
            [button setTitle:[NSString stringWithFormat:@"%.2f\n%@",rechargeRule.min,rechargeRule.desc] forState:UIControlStateNormal];
            button.titleLabel.font = [UIFont systemFontOfSize:12];
            button.titleLabel.numberOfLines = 0;
            button.titleLabel.textAlignment = NSTextAlignmentCenter;
            [button setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:button];
        }
        
        
        NSArray * payWayList = data[@"pay_way_list"];
        if (payWayList && payWayList.count > 0) {
            for (int i = 0; i < payWayList.count; i++) {
                NSDictionary * dict = [payWayList objectAtIndex:i];
                PayWayDO * payWayDO = [[PayWayDO alloc] initWithJSONDictionary:dict error:nil];
                PayWayButton * payWay = [[PayWayButton alloc] initWithFrame:CGRectMake(0, self.rechageButton.frameY-110+i*45, kScreenWidth, 45)];
                payWay.payWayDO = payWayDO;
                payWay.tag = 10 + i;
                [payWay addTarget:self action:@selector(payWayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
                [self addSubview:payWay];
            }
        }
        
    } failure:^(XMError *error) {
        [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];

}

-(void)setAccountCard:(AccountCard *)accountCard
{
    _accountCard = accountCard;
    if (accountCard.cardDesc && accountCard.cardDesc.length > 0) {
        self.rechageDesc.text = accountCard.cardDesc;
    }
}

- (void)payWayButtonClick:(PayWayButton *)button
{
    NSInteger tag = button.tag;
    for (int i = 0; i < self.subviews.count; i++) {
        PayWayButton * btn = [self viewWithTag:i+10];
        if (btn.tag == tag && btn.selected == 1) {
            btn.selected = NO;
            btn.selectedButton.selected = NO;
            break ;
        }
        if (btn.tag == tag) {
            btn.selected = YES;
            btn.selectedButton.selected = YES;
        } else {
            btn.selected = NO;
            btn.selectedButton.selected = NO;
        }
    }
    
    if (button.selected) {
        self.pay_way = button.payWayDO.pay_way;
    }else{
        self.pay_way = -1;
    }
}

- (void)buttonClick:(RechargeRuleButton *)button
{
    NSInteger tag = button.tag;
    for (int i = 0; i < self.subviews.count; i++) {
        RechargeRuleButton * btn = [self viewWithTag:i+100];
        if (btn.tag == tag && btn.selected == 1) {
            btn.selected = NO;
            btn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
            break ;
        }
        if (btn.tag == tag) {
            btn.selected = YES;
            btn.backgroundColor = [UIColor colorWithHexString:@"333333"];
        } else {
            btn.selected = NO;
            btn.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        }
    }
    
    if (button.selected) {
        self.pay_amount = [NSString stringWithFormat:@"%.2f",button.rechargeRule.min];
    }else{
        self.pay_amount = @"";
    }

}

- (void)rechageButtonClick
{
    BOOL isValid = [self saveRechageInfo];
    self.user_id = [Session sharedInstance].currentUserId;
    self.pay_card_type = self.accountCard.cardType;//0:消费卡 1:鉴定卡 2:洗护卡
    
    if (isValid) {
        
        PayWayType payway = self.pay_way;
        if (PayWayWxpay == payway && ![WXApi isWXAppInstalled]) {
            [[CoordinatingController sharedInstance] showHUD:@"请安装微信后重试\n或选择其他支付方式" hideAfterDelay:1.5f];
            return;
        }
        
        NSDictionary * paras = @{@"user_id":[NSNumber numberWithInteger:self.user_id?self.user_id:0],
                                 @"pay_way":[NSNumber numberWithInteger:self.pay_way],
                                 @"pay_amount":self.pay_amount?self.pay_amount:@"",
                                 @"pay_card_type":[NSNumber numberWithInteger:self.pay_card_type]};
        
        [[CoordinatingController sharedInstance] showProcessingHUD:nil];
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"recharge" path:@"pay" parameters:paras completionBlock:^(NSDictionary *data) {
            [[CoordinatingController sharedInstance] hideHUD];
            NSInteger payway = [data integerValueForKey:@"pay_way"];

            if(payway == PayWayAlipay) {
                NSString *payUrl = [data stringValueForKey:@"alipay_url"];
                if (payUrl && [payUrl length]>0) {
                    [PayManager pay:payUrl];
                }
            } else if (payway == PayWayWxpay) {
                NSDictionary *payReq = [data objectForKey:@"wxpay_req"];
                PayReq *request = nil;
                if (payReq != nil && [payReq isKindOfClass:[NSDictionary class]]) {
                    request = [[PayReq alloc] init];
                    request.openID = WXAppId;
                    request.partnerId = [payReq stringValueForKey:@"partnerid"];
                    request.prepayId= [payReq stringValueForKey:@"prepayid"];
                    request.package = [payReq stringValueForKey:@"packagestr"];
                    request.nonceStr= [payReq stringValueForKey:@"noncestr"];
                    request.timeStamp = [[payReq stringValueForKey:@"timestamp"] intValue];
                    request.sign= [payReq stringValueForKey:@"sign"];
                    
                    BOOL isSuc = [PayManager weixinPay:request];
                    if (isSuc) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:PAY_RESULT_COMPLETION object:nil];
                    }
                }
            }

            
        } failure:^(XMError *error) {
            
        } queue:nil]];

        
    }
    
}

-(BOOL)saveRechageInfo
{
    BOOL isValid = YES;
    if (isValid) {
        if (!self.pay_amount || self.pay_amount.length == 0) {
            [WCAlertView showAlertWithTitle:nil message:@"请选择充值金额" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
            } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if (self.pay_way == -1) {
            [WCAlertView showAlertWithTitle:nil message:@"请选择充值方式" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
            } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            isValid = NO;
        }
    }
    return isValid;
}


-(NSInteger)rechageDescHight:(NSArray *)array
{
    
    NSInteger row;
    NSInteger count = array.count;
    if (count > 3*(count/3)) {
        row = count/3+1;
    }else{
        row = count/3;
    }
    return row;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.chooseMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chooseMoney.mas_centerY);
        make.left.equalTo(self.mas_left).offset(50);
        make.right.equalTo(self.chooseMoney.mas_left).offset(-10);
        make.height.mas_offset(@1);
    }];
    
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.chooseMoney.mas_centerY);
        make.left.equalTo(self.chooseMoney.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-50);
        make.height.mas_offset(@1);
    }];
    
    [self.rechageButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.right.equalTo(self.mas_right).offset(-14);
        make.bottom.equalTo(self.mas_bottom).offset(-45);
        make.height.mas_equalTo(50);
    }];
    
    [self.rechageDeal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rechageButton.mas_bottom).offset(12);
        make.left.equalTo(self.mas_left).offset(14);
    }];
    
    CGFloat row = [self rechageDescHight:self.dataSources];
    self.rechageDesc.frame = CGRectMake(0, 46+60*row, kScreenWidth, 15);
}
@end


@implementation RechargeRuleButton



@end
