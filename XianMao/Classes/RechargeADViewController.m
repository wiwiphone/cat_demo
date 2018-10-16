//
//  RechargeADViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/4/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RechargeADViewController.h"

#import "RechargeViewController.h"
#import "Command.h"

#import "DigitalKeyboardView.h"
#import "NetworkAPI.h"
#import "Session.h"

#import "PayManager.h"

#import "masonry.h"
#import "PayWayDO.h"

#define kBaseTag 10000

@interface RechargeADViewController ()<UITextFieldDelegate> {
    UIView *firstBgView;
    UIImageView *imageF;
    UILabel *titleLBF;
    UILabel *subtitleLBF;
    UIButton *goBtn;
    UILabel *oneLB;
    UIView *secondBgView;
    UILabel *titleLBS;
    UILabel *moneyLBS;
    UITextField *moneyFD;
    UIButton *nextBtn;
    CGFloat topBarHeight;
    //pop
    UIButton *closeBtn;
    UILabel *titLB;
    UIView *bgLineF;
    
    
    SelectView *view1;
    SelectView *view2;
    SelectView *view3;
    
    PayWayType payway;
    
    BOOL isGetWay;
    
}

@property(nonatomic, strong) UIView *popSelectView;
@property(nonatomic, strong) UIView *popBgGrayView;
@end

@implementation RechargeADViewController

- (UIView *)popBgGrayView {
    if (!_popBgGrayView) {
        _popBgGrayView = [[UIView alloc] initWithFrame:self.view.bounds];
        _popBgGrayView.backgroundColor = [UIColor blackColor];
        _popBgGrayView.alpha = 0.4;
        UITapGestureRecognizer *tapBg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopView:)];
        [_popBgGrayView addGestureRecognizer:tapBg];
    }
    return _popBgGrayView;
}

- (UIView *)popSelectView {
    if (!_popSelectView) {
        _popSelectView = [[UIView alloc] initWithFrame:CGRectZero];
        _popSelectView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        
    }
    return _popSelectView;
}

- (void)setupPopView {
    closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    closeBtn.frame = CGRectMake(0, 0, 17, 17);
    [closeBtn setImage:[UIImage imageNamed:@"back_Log_MF"] forState:UIControlStateNormal];
    closeBtn.tintColor = [UIColor grayColor];
    [closeBtn addTarget:self action:@selector(closePopView:) forControlEvents:UIControlEventTouchUpInside];
    
    
    titLB = [[UILabel alloc] initWithFrame:CGRectZero];
    titLB.font = [UIFont systemFontOfSize:15.f];
    titLB.textColor = [UIColor colorWithHexString:@"595757"];
    titLB.text = @"选择充值方式";
    
    bgLineF = [[UIView alloc] initWithFrame:CGRectZero];
    bgLineF.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    WEAKSELF;
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"recharge" path:@"pay_ways" parameters:nil completionBlock:^(NSDictionary *data) {
        
        NSMutableArray *payWayDOArray = [[NSMutableArray alloc] init];
        NSArray *payWayDicts = [data arrayValueForKey:@"pay_ways"];
        if ([payWayDicts isKindOfClass:[NSArray class]]) {
            CGFloat margin = 40;
            for (NSDictionary *dict in payWayDicts) {
                PayWayDO *payWay =[[PayWayDO alloc] initWithJSONDictionary:dict];
                if (payWay) {
                    [payWayDOArray addObject:payWay];
                }
                SelectView *selectView = [[SelectView alloc] initWithFrame:CGRectMake(0, margin, kScreenWidth, 52) andImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:payWay.icon_url]]] andTitle:payWay.pay_name];
                selectView.payWayDO = payWay;
                margin += 52;
                selectView.tag = kBaseTag;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
                [selectView addGestureRecognizer:tap];
                selectView.flgBtn.tag = selectView.tag + 10;
                selectView.flgBtn.payWay = payWay;
                [selectView.flgBtn addTarget:self action:@selector(flgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
                
                [self.popSelectView addSubview:closeBtn];
                [self.popSelectView addSubview:titLB];
                [self.popSelectView addSubview:bgLineF];
                
                [self.popSelectView addSubview:selectView];
                [self setPopViewUI];
            }
        }
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
    
    //pay_icon_cup  //wxpay  payicon_ali
//    view1 = [[SelectView alloc] initWithFrame:CGRectZero andImage:[UIImage imageNamed:@"pay_icon_cup"] andTitle:@"银联"];
//    view1.tag = kBaseTag;
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [view1 addGestureRecognizer:tap1];
//    view1.flgBtn.tag = view1.tag + 10;
//    [view1.flgBtn addTarget:self action:@selector(flgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    view2 = [[SelectView alloc] initWithFrame:CGRectZero andImage:[UIImage imageNamed:@"payicon_ali"] andTitle:@"支付宝"];
//    view2.tag = kBaseTag + 1;
//    
//    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [view2 addGestureRecognizer:tap2];
//    view2.flgBtn.tag = view2.tag + 10;
//    [view2.flgBtn addTarget:self action:@selector(flgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    view3 = [[SelectView alloc] initWithFrame:CGRectZero andImage:[UIImage imageNamed:@"wxpay"] andTitle:@"微信"];
//    view3.tag = kBaseTag + 2;
//    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
//    [view3 addGestureRecognizer:tap3];
//    view3.flgBtn.tag = view3.tag + 10;
//    [view3.flgBtn addTarget:self action:@selector(flgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.popSelectView addSubview:closeBtn];
//    [self.popSelectView addSubview:titLB];
//    [self.popSelectView addSubview:bgLineF];
//    
//    [self.popSelectView addSubview:view1];
//    [self.popSelectView addSubview:view2];
//    [self.popSelectView addSubview:view3];
//    
//    [self setPopViewUI];
}

- (void)setPopViewUI {
    [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.popSelectView.mas_top).offset(12);
        make.left.equalTo(self.popSelectView.mas_left).offset(15);
        make.width.equalTo(@17);
        make.height.equalTo(@17);
    }];
    [titLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.popSelectView.mas_top).offset(14);
        make.centerX.equalTo(self.popSelectView.mas_centerX);
    }];
    [bgLineF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.popSelectView.mas_top).offset(40);
        make.left.equalTo(self.popSelectView.mas_left);
        make.right.equalTo(self.popSelectView.mas_right);
        make.height.equalTo(@1);
    }];
//    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.popSelectView.mas_left);
//        make.top.equalTo(bgLineF.mas_bottom);
//        make.right.equalTo(self.popSelectView.mas_right);
//        make.height.equalTo(@52);
//    }];
//    [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view1.mas_bottom);
//        make.left.equalTo(self.popSelectView.mas_left);
//        make.right.equalTo(self.popSelectView.mas_right);
//        make.height.equalTo(view1.mas_height);
//    }];
//    [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(view2.mas_bottom);
//        make.left.equalTo(self.popSelectView.mas_left);
//        make.right.equalTo(self.popSelectView.mas_right);
//        make.height.equalTo(view1.mas_height);
//    }];
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    CommandButton *btn = (CommandButton *)[tap.view viewWithTag:tap.view.tag + 10];
    [btn setSelected:YES];
//    [self didSelect:(tap.view.tag - kBaseTag)];
    [self didSelect:btn.payWay];
}

- (void)didSelect:(PayWayDO *)payWay {
//    NSLog(@"tag:%ld", tag);
    [self closePopView:nil];
////    payway = tag;
//    if (tag == 0) {
//        payway = 2;
//    }
//    if (tag == 1) {
//        payway = 0;
//    }
//    if (tag == 2) {
//        payway = 1;
//    }
    payway = payWay.pay_way;
    isGetWay = YES;
    if (!oneLB.isHidden) {
        oneLB.hidden = YES;
        titleLBF.hidden = NO;
        subtitleLBF.hidden = NO;
        imageF.hidden = NO;
    }
    titleLBF.text = payWay.pay_name;
//    subtitleLBF.text = @"每日交易限额 ¥ 10000";
    imageF.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:payWay.icon_url]]];
//    switch (tag) {
//        case 0:
//            titleLBF.text = @"银联支付";
//            subtitleLBF.text = @"每日交易限额 ¥ 10000";
//            imageF.image = [UIImage imageNamed:@"pay_icon_cup"];
//            break;
//        case 1:
//            titleLBF.text = @"支付宝";
//            subtitleLBF.text = @"每日交易限额 ¥ 10000";
//            imageF.image = [UIImage imageNamed:@"payicon_ali"];
//            break;
//        case 2:
//            titleLBF.text = @"微信";
//            subtitleLBF.text = @"每日交易限额 ¥ 10000";
//            imageF.image = [UIImage imageNamed:@"wxpay"];
//            break;
//        default:
//            break;
//    }
    if (moneyFD.text.length > 0 && [moneyFD.text doubleValue] > 0) {
        [nextBtn setUserInteractionEnabled:YES];
        //150b0e
        nextBtn.backgroundColor = [UIColor colorWithHexString:@"150b0e"];
    }
}

- (void)closePopView:(UIButton *)btn {
    CGRect frame = CGRectMake(0, kScreenHeight, self.popSelectView.frame.size.width, self.popSelectView.frame.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        self.popSelectView.frame = frame;
        self.popBgGrayView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.popSelectView removeFromSuperview];
        self.popBgGrayView.alpha = 0.4;
        [self.popBgGrayView removeFromSuperview];
    }];
}

- (void)flgBtnAction:(CommandButton *)btn {
    [btn setSelected:!btn.isSelected];
    [self didSelect:btn.payWay];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"钱包充值"];
    [super setupTopBarBackButton];
    
    [super setupTopBarRightButton:[UIImage imageNamed:@"infor"] imgPressed:nil];
    
    firstBgView = [[UIView alloc] initWithFrame:CGRectZero];
    firstBgView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    imageF = [[UIImageView alloc] initWithFrame:CGRectZero];
    titleLBF = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLBF.font = [UIFont systemFontOfSize:15.f];
    titleLBF.textColor = [UIColor colorWithHexString:@"4d4d4d"];
    [titleLBF sizeToFit];
    
    subtitleLBF = [[UILabel alloc] initWithFrame:CGRectZero];
    subtitleLBF.font = [UIFont systemFontOfSize:15.f];
    subtitleLBF.textColor = [UIColor colorWithHexString:@"b8b8b8"];
    [subtitleLBF sizeToFit];
    
    goBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [goBtn setBackgroundImage:[UIImage imageNamed:@"goSelect"] forState:UIControlStateNormal];
    goBtn.tintColor = [UIColor grayColor];
    [goBtn sizeToFit];
    
    oneLB = [[UILabel alloc] initWithFrame:CGRectZero];
    oneLB.textColor = [UIColor colorWithHexString:@"b8b8b8"];
    oneLB.font = [UIFont systemFontOfSize:15.f];
    oneLB.text = @"请选择充值方式";
    [oneLB sizeToFit];
    
    UITapGestureRecognizer *tapF = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFAction:)];
    [firstBgView addGestureRecognizer:tapF];
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    
    secondBgView = [[UIView alloc] initWithFrame:CGRectZero];
    secondBgView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    titleLBS = [[UILabel alloc] initWithFrame:CGRectZero];
    titleLBS.font = [UIFont systemFontOfSize:15.f];
    titleLBS.textColor = [UIColor colorWithHexString:@"4d4d4d"];
    [titleLBS sizeToFit];
    
    moneyLBS = [[UILabel alloc] initWithFrame:CGRectZero];
    moneyLBS.font = [UIFont systemFontOfSize:15.f];
    moneyLBS.textColor = [UIColor colorWithHexString:@"c2a79d"];
    moneyLBS.text = @"¥";
    [moneyLBS sizeToFit];
    
    moneyFD = [[UITextField alloc] initWithFrame:CGRectZero];
    moneyFD.textColor = [UIColor colorWithHexString:@"c2a79d"];
    moneyFD.font = [UIFont systemFontOfSize:23.f];
    moneyFD.keyboardType = UIKeyboardTypeDecimalPad;
    moneyFD.delegate = self;
    
    nextBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//    nextBtn.backgroundColor = [UIColor colorWithHexString:@"150b0e"];
    nextBtn.backgroundColor = [UIColor grayColor];
    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [nextBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.userInteractionEnabled = NO;
    
    [self.view addSubview:firstBgView];
    [self.view addSubview:secondBgView];
    [self.view addSubview:nextBtn];
    
    
    [firstBgView addSubview:titleLBF];
    [firstBgView addSubview:subtitleLBF];
    [firstBgView addSubview:imageF];
    [firstBgView addSubview:goBtn];
    [firstBgView addSubview:oneLB];
    titleLBF.hidden = YES;
    subtitleLBF.hidden = YES;
    imageF.hidden = YES;
    
    [secondBgView addSubview:titleLBS];
    [secondBgView addSubview:moneyLBS];
    [secondBgView addSubview:moneyFD];
    
    titleLBS.text = @"充值金额";
    
    
    [self setupUI];
    
    [super bringTopBarToTop];
}

- (void)handleTopBarRightButtonClicked:(UIButton*)sender {
    NSLog(@"点击右上角按钮");
}

- (void)tapFAction:(UITapGestureRecognizer *)tap {
    
    [self.view addSubview:self.popBgGrayView];
    [self.view insertSubview:self.popSelectView aboveSubview:self.popBgGrayView];
    CGRect frame = CGRectMake(0, 178 + topBarHeight, kScreenWidth, kScreenHeight - 178 - topBarHeight);
    self.popSelectView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - 178 - topBarHeight);
    [self setupPopView];
    [UIView animateWithDuration:0.5 animations:^{
        self.popSelectView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)nextBtnAction:(UIButton *)btn {
    WEAKSELF;
    if (PayWayWxpay == payway && ![WXApi isWXAppInstalled]) {
        [self showHUD:@"请安装微信后重试\n或选择其他支付方式" hideAfterDelay:1.5f];
        return;
    }
    
    [weakSelf showProcessingHUD:nil];
    NSInteger userId = [Session sharedInstance].isLoggedIn?[Session sharedInstance].currentUserId:0;
//    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"pay_amount":[NSNumber numberWithDouble:(double)weakSelf.rechargeCent/100.f],@"pay_way":[NSNumber numberWithInteger:[weakSelf payWay]]};
    NSDictionary *parameters = @{@"user_id":[NSNumber numberWithInteger:userId], @"pay_amount":[NSNumber numberWithDouble:[moneyFD.text doubleValue]],@"pay_way":[NSNumber numberWithInteger:payway]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"recharge" path:@"pay" parameters:parameters completionBlock:^(NSDictionary *data) {
        [weakSelf hideHUD];
        //            if (completion)completion([data integerValueForKey:@"quote_num"]);
        
//        NSInteger payway = [data integerValueForKey:@"pay_way"];
        
        
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



- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

- (void)setupUI {
    [firstBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(16 + topBarHeight);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@69);
    }];
    
    [imageF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBgView.mas_top).offset(16);
        make.left.equalTo(firstBgView.mas_left).offset(18);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [titleLBF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageF.mas_right).offset(15);
        make.top.equalTo(firstBgView.mas_top).offset(16);
    }];
    
    [subtitleLBF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageF.mas_right).offset(15);
        make.top.equalTo(firstBgView.mas_top).offset(39);
    }];
    
    [goBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBgView.mas_top).offset(27);
        make.right.equalTo(firstBgView.mas_right).offset(-15);
    }];
    
    [oneLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(firstBgView.mas_top).offset(26);
        make.left.equalTo(firstBgView.mas_left).offset(16);
    }];
    
    [secondBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(topBarHeight + 100);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@90);
    }];
    
    [titleLBS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondBgView.mas_top).offset(17);
        make.left.equalTo(secondBgView.mas_left).offset(18);
    }];
    
    [moneyLBS mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondBgView.mas_top).offset(47);
        make.left.equalTo(secondBgView.mas_left).offset(18);
    }];
    
    [moneyFD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(secondBgView.mas_top).offset(47);
        make.left.equalTo(moneyLBS.mas_right).offset(13);
        make.width.equalTo(@(kScreenWidth - 36));
        make.height.equalTo(@25);
    }];
    
    
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(257 + topBarHeight);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.height.equalTo(@40);
    }];
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@", NSStringFromRange(range));
    if (range.length <= 0) {
        if (isGetWay) {
            nextBtn.userInteractionEnabled = YES;
            nextBtn.backgroundColor = [UIColor colorWithHexString:@"150b0e"];
        }
    } else if (range.location == 0 && range.length != 0) {
        nextBtn.userInteractionEnabled = NO;
        nextBtn.backgroundColor = [UIColor grayColor];
    }
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSInteger flag=0;
    const NSInteger limited = 2;
    for (NSInteger i = (NSInteger)futureString.length - 1; i >= 0; i--) {
        
        if ([futureString characterAtIndex:i] == '.') {
            
            if (flag > limited) {
                return NO;
            }
            
            break;
        }
        flag++;
    }
    
    return YES;
}









- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [moneyFD resignFirstResponder];
}

@end

//pop
@interface SelectView ()


@property(nonatomic, strong) UIView *bgLine;

@end

@implementation SelectView
- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        //pay_icon_cup  //wxpay  payicon_ali
    }
    return _photoImageView;
}

- (UILabel *)titleLB {
    if (!_titleLB) {
        _titleLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLB.textColor = [UIColor colorWithHexString:@"595757"];
        _titleLB.font = [UIFont systemFontOfSize:14.f];
        [_titleLB sizeToFit];
    }
    return _titleLB;
}

- (CommandButton *)flgBtn {
    if (!_flgBtn) {
        _flgBtn = [CommandButton buttonWithType:UIButtonTypeCustom];
        //pay_checkbox_checked@2x   pay_checkbox_uncheck@2x
        [_flgBtn setImage:[UIImage imageNamed:@"pay_checkbox_uncheck"] forState:UIControlStateNormal];
        [_flgBtn setImage:[UIImage imageNamed:@"pay_checkbox_checked"] forState:UIControlStateSelected];
//        [_flgBtn addTarget:self action:@selector(flgBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _flgBtn;
}

- (UIView *)bgLine {
    if (!_bgLine) {
        _bgLine = [[UIView alloc] initWithFrame:CGRectZero];
        _bgLine.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _bgLine;
}

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image andTitle:(NSString *)title {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.photoImageView];
        [self addSubview:self.titleLB];
        [self addSubview:self.flgBtn];
        [self addSubview:self.bgLine];
        
        self.photoImageView.image = image;
        self.titleLB.text = title;
        
        [self setUI];
    }
    return self;
}

- (void)setUI {
    [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(19);
        make.left.equalTo(self.mas_left).offset(18);
        make.width.equalTo(@22);
        make.height.equalTo(@22);
    }];
    [self.titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(22);
        make.left.equalTo(self.photoImageView.mas_right).offset(10);
    }];
    [self.flgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(20);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [self.bgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self.mas_left).offset(18);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@1);
    }];
}



- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
