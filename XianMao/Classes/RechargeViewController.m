//
//  RechargeViewController.m
//  XianMao
//
//  Created by simon cai on 6/11/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "RechargeViewController.h"
#import "Command.h"

#import "DigitalKeyboardView.h"
#import "NetworkAPI.h"
#import "Session.h"

#import "PayManager.h"

@interface RechargeInputView : DigitalInputContainerView

@property(nonatomic,strong) UITextField *textFiled;
@property(nonatomic,assign) NSInteger priceCent;

@end

@implementation RechargeInputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 44+20);
        self.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        
        CALayer *topLine = [CALayer layer];
        topLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        topLine.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
        [self.layer addSublayer:topLine];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.text = @"充值金额";
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textColor = [UIColor colorWithHexString:@"999999"];
        [self addSubview:lbl];
        
        _textFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(10, 20+4, kScreenWidth-10-10, 36) rectInsetDX:8 rectInsetDY:0];
        _textFiled.layer.masksToBounds = YES;
        _textFiled.layer.cornerRadius = 3;
        _textFiled.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        _textFiled.layer.borderWidth = 0.5f;
        _textFiled.backgroundColor = [UIColor whiteColor];
        [self addSubview:_textFiled];
        
    }
    return self;
}

- (NSInteger)priceCent {
    return [self.textFiled.text length]>0?[self.textFiled.text doubleValue]*100:0;
}

@end

@interface CommandButtonPayWay : CommandButton

@end

@implementation CommandButtonPayWay

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    UIImageView *flagIcon = (UIImageView*)[self viewWithTag:100];
    if (selected) {
        flagIcon.image = [UIImage imageNamed:@"pay_checkbox_checked"];
    } else {
        flagIcon.image = [UIImage imageNamed:@"pay_checkbox_uncheck"];
    }
}

@end

@interface RechargeViewController ()
@property(nonatomic,assign) NSInteger rechargeCent;
@end

@implementation RechargeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"充值"];
    [super setupTopBarBackButton];
    
    CGFloat marginTop = topBarHeight;
    marginTop += 10;
    
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    line.frame = CGRectMake(0, marginTop, kScreenWidth, 0.5);
    [self.view.layer addSublayer:line];
    marginTop += 0.5;
    
    CommandButton *amountBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 45)];
    amountBtn.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:amountBtn];
    
    [amountBtn setTitle:@"充值金额" forState:UIControlStateNormal];
    [amountBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    amountBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    amountBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    amountBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    marginTop += amountBtn.height;
    amountBtn.tag = 2000;
    
    UILabel *amountLbl = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth-15-30, amountBtn.height)];
    amountLbl.textColor  =[UIColor colorWithHexString:@"c2a79d"];
    amountLbl.text  =@"￥0";
    amountLbl.font  =[UIFont boldSystemFontOfSize:15];
    amountLbl.textAlignment = NSTextAlignmentRight;
    amountLbl.tag = 3000;
    [amountBtn addSubview:amountLbl];
    
    
    line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    line.frame = CGRectMake(0, marginTop, kScreenWidth, 0.5);
    [self.view.layer addSublayer:line];
    marginTop += 0.5;
    
    marginTop += 10;
    
    
    line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    line.frame = CGRectMake(0, marginTop, kScreenWidth, 0.5);
    [self.view.layer addSublayer:line];
    marginTop += 0.5;
    
    UILabel *titleLbl = [[UIInsetLabel alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 36) andInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
    titleLbl.font = [UIFont systemFontOfSize:13];
    titleLbl.text = @"选择付款方式";
    titleLbl.textColor = [UIColor colorWithHexString:@"999999"];
    titleLbl.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:titleLbl];
    
    marginTop += titleLbl.height;
    
    line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    line.frame = CGRectMake(0, titleLbl.bottom-0.5, kScreenWidth, 0.5);
    [self.view.layer addSublayer:line];
    
    CommandButton *alipayBtn = [self createButton:[UIImage imageNamed:@"payicon_ali"] title:@"支付宝"];
    alipayBtn.frame = CGRectMake(0, marginTop, kScreenWidth, 46);
    alipayBtn.backgroundColor = [UIColor whiteColor];
    alipayBtn.tag = 800+PayWayAlipay;
    [self.view addSubview:alipayBtn];
    
    marginTop += alipayBtn.height;
    line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    line.frame = CGRectMake(15, alipayBtn.bottom-0.5, kScreenWidth, 0.5);
    [self.view.layer addSublayer:line];
    
    CommandButton *wxBtn = [self createButton:[UIImage imageNamed:@"wxpay"] title:@"微信"];
    wxBtn.frame = CGRectMake(0, marginTop, kScreenWidth, 46);
    wxBtn.backgroundColor = [UIColor whiteColor];
    wxBtn.tag = 800+PayWayWxpay;
    [self.view addSubview:wxBtn];
    
    marginTop += wxBtn.height;
    line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    line.frame = CGRectMake(15, wxBtn.bottom-0.5, kScreenWidth, 0.5);
    [self.view.layer addSublayer:line];
    
    CommandButton *ylBtn = [self createButton:[UIImage imageNamed:@"pay_icon_cup"] title:@"银联"];
    ylBtn.frame = CGRectMake(0, marginTop, kScreenWidth, 46);
    ylBtn.backgroundColor = [UIColor whiteColor];
    ylBtn.tag = 800+PayWayUpay;
    [self.view addSubview:ylBtn];
    
    marginTop += ylBtn.height;
    line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
    line.frame = CGRectMake(0, marginTop, kScreenWidth, 0.5);
    [self.view.layer addSublayer:line];
    marginTop += 0.5;
    
    marginTop += 10;
    
    CommandButton *chongzhiBtn = [[CommandButton alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 36)];
    chongzhiBtn.backgroundColor  =[UIColor colorWithHexString:@"c2a79d"];
    [chongzhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [chongzhiBtn setTitle:@"马上充值" forState:UIControlStateNormal];
    chongzhiBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:chongzhiBtn];
    
    [alipayBtn setSelected:YES];
    
    alipayBtn.handleClickBlock = ^(CommandButton *sender) {
        [sender setSelected:YES];
        [wxBtn setSelected:NO];
        [ylBtn setSelected:NO];
    };
    wxBtn.handleClickBlock = ^(CommandButton *sender) {
        [sender setSelected:YES];
        [alipayBtn setSelected:NO];
        [ylBtn setSelected:NO];
    };
    ylBtn.handleClickBlock = ^(CommandButton *sender) {
        [sender setSelected:YES];
        [wxBtn setSelected:NO];
        [alipayBtn setSelected:NO];
    };
    
    WEAKSELF;
    amountBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf showRechargeInputView];
    };
    
    chongzhiBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf doRecharge];
    };
    
    _rechargeCent = 0;
    
    [self bringTopBarToTop];
}

- (NSInteger)payWay {
    
    NSInteger payWay = PayWayAlipay;
    if (((CommandButton*)[self.view viewWithTag:800+PayWayAlipay]).isSelected) {
        payWay = PayWayAlipay;
    } else if (((CommandButton*)[self.view viewWithTag:800+PayWayWxpay]).isSelected) {
        payWay = PayWayWxpay;
    } else if (((CommandButton*)[self.view viewWithTag:800+PayWayUpay]).isSelected) {
        payWay = PayWayUpay;
    }
    return payWay;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CommandButton*)createButton:(UIImage*)icon title:(NSString*)title {
    CommandButton *btn = [[CommandButtonPayWay alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 46)];
    btn.backgroundColor = [UIColor whiteColor];
    [btn setImage:icon forState:UIControlStateNormal];
    [btn setImage:icon forState:UIControlStateHighlighted];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 15);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 15);
    UIImageView *flagIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_checkbox_uncheck"]];
    flagIcon.tag = 100;
    [btn addSubview:flagIcon];
    flagIcon.frame = CGRectMake(kScreenWidth-flagIcon.width-15, (btn.height-flagIcon.height)/2, flagIcon.width, flagIcon.height);
    return btn;
}

- (void)showRechargeInputView {
    WEAKSELF;
    RechargeInputView *inputView = [[RechargeInputView alloc] initWithFrame:CGRectZero];
    if (_rechargeCent>0) {
        inputView.textFiled.text = [[NSNumber numberWithDouble:(double)_rechargeCent/100.f] stringValue];
    }
    [DigitalKeyboardView showInView:self.view inputContainerView:inputView textFieldArray:[NSArray arrayWithObjects:inputView.textFiled, nil] completion:^(DigitalInputContainerView *inputContainerView) {
        RechargeInputView *rechargeInputView = (RechargeInputView*)inputContainerView;
        NSInteger priceCent = [rechargeInputView priceCent];
        NSString *text = rechargeInputView.textFiled.text;
        if (priceCent >0) {
            UIView *vew = [weakSelf.view viewWithTag:2000];
            UILabel *amountLbl = (UILabel*)[vew viewWithTag:3000];
            amountLbl.text = [NSString stringWithFormat:@"￥%@",text];
            weakSelf.rechargeCent = priceCent;
        } else {
            UILabel *amountLbl = (UILabel*)[[weakSelf.view viewWithTag:200] viewWithTag:200];
            amountLbl.text = @"￥0";
        }
    }];
}


- (void)doRecharge {
    WEAKSELF;
    if (weakSelf.rechargeCent==0) {
        [weakSelf showRechargeInputView];
    } else {
        
        PayWayType payway = [weakSelf payWay];
        if (PayWayWxpay == payway && ![WXApi isWXAppInstalled]) {
            [self showHUD:@"请安装微信后重试\n或选择其他支付方式" hideAfterDelay:1.5f];
            return;
        }
        
        [weakSelf showProcessingHUD:nil];
        NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
        NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"pay_amount":[NSNumber numberWithDouble:(double)weakSelf.rechargeCent/100.f],@"pay_way":[NSNumber numberWithInteger:[weakSelf payWay]]};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"recharge" path:@"pay" parameters:parameters completionBlock:^(NSDictionary *data) {
            [weakSelf hideHUD];
//            if (completion)completion([data integerValueForKey:@"quote_num"]);
            
            NSInteger payway = [data integerValueForKey:@"pay_way"];
            
            
            BOOL handled = NO;
            if(payway == PayWayAlipay) {
                NSString *payUrl = [data stringValueForKey:@"alipay_url"];
                if (payUrl && [payUrl length]>0) {
                    handled = YES;
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
                    
                    handled = YES;
                    [PayManager weixinPay:request];
                }
            } else if (payway == PayWayUpay) {
                
                NSString *upPayTn = [data stringValueForKey:@"uppay_trade_id"];
                if (upPayTn && [upPayTn length] > 0) {
                    handled = YES;
                    //[UPPayPlugin startPay:upPayTn mode:kMode_Development viewController:self delegate:self];
                    [PayManager uppay:upPayTn];
                }
            }
            
            if (!handled) {
                [weakSelf handlePayDidFnishBlockImpl];
            }
            
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f];
        } queue:nil]];
        
    }
//    请求类型
//    POST
//    路径
//    /recharge/pay
//    参数
//    {"user_id": 00,"pay_way":0, "pay_amount":00}
}

- (void)$$handlePayResultCompletionNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    [self handlePayDidFnishBlockImpl];
}

- (void)$$handlePayResultCancelNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    [self handlePayDidFnishBlockImpl];
}

- (void)$$handlePayResultFailureNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    [self handlePayDidFnishBlockImpl];
}

- (void)handlePayDidFnishBlockImpl {
    [self dismiss];
}

@end






//
//请求类型
//POST
//路径
///recharge/pay
//参数
//{"user_id": 00,"pay_way":0, "pay_amount":00}




