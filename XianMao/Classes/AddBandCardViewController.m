//
//  AddBandCardViewController.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "AddBandCardViewController.h"
#import "NetworkAPI.h"
#import "BankModel.h"
#import "Error.h"
#import "WCAlertView.h"
#import "NSString+Validation.h"
#import "Error.h"
#import "XMWebImageView.h"
#import "WonderingView.h"
#import "Session.h"
#import "NSString+Addtions.h"
#import "BankAffiliationView.h"
#import "HXProvincialCitiesCountiesPickerview.h"
#import "HXAddressManager.h"
#import "UserDetailInfo.h"
#import "WCAlertView.h"
#import "NSString+Validation.h"

@interface AddBandCardViewController ()<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,strong) UIView * container1;
@property (nonatomic,strong) UIView * container2;
@property (nonatomic,strong) UIView * container3;
@property (nonatomic,strong) BankAffiliationView * areaView;
@property (nonatomic,strong) UIScrollView * scrollView;
@property (nonatomic,strong) XMWebImageView * question;
@property (nonatomic,strong) UILabel * alertLbl;
@property (nonatomic,strong) UILabel * alertLbl2;
@property (nonatomic,strong) UILabel * bank;
@property (nonatomic,strong) liebetweenTextField * bankTf;
@property (nonatomic,strong) UILabel * bankCardNum;
@property (nonatomic,strong) liebetweenTextField * bankCardNumTf;
@property (nonatomic,strong) UILabel * name;
@property (nonatomic,strong) liebetweenTextField * nameTf;
@property (nonatomic,strong) UILabel * idCard;
@property (nonatomic,strong) liebetweenTextField * idCardTf;
@property (nonatomic,strong) UILabel * phone;
@property (nonatomic,strong) liebetweenTextField * phoneTf;
@property (nonatomic,strong) UILabel * code;
@property (nonatomic,strong) liebetweenTextField * codeTf;
@property (nonatomic,strong) UILabel * openingBank;
@property (nonatomic,strong) UIButton * openingBankTf;
@property (nonatomic,strong) UILabel * subBranchLbl;
@property (nonatomic,strong) liebetweenTextField * subBranchTf;
@property (nonatomic,strong) UIButton * finishBtn;
@property (nonatomic,strong) UIButton * codeBtn;
@property (nonatomic,strong) NSMutableArray * bankArray;
@property (nonatomic,strong) NSMutableArray * dataSources;
@property (nonatomic,strong) HTTPRequest * request;
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic,assign) NSInteger timerPeriod;
@property (nonatomic,copy) NSString * user_id;
@property (nonatomic,copy) NSString * user_name;
@property (nonatomic,copy) NSString * bank_id;
@property (nonatomic,copy) NSString * bank_card;
@property (nonatomic,copy) NSString * identity_card;
@property (nonatomic,copy) NSString * auth_code;
@property (nonatomic,copy) NSString * kaihuhang;
@property (nonatomic,copy) NSString * region;
@property (nonatomic,assign) NSInteger idd;
@property (nonatomic,strong) WonderingView * wonderView;
@property (nonatomic,strong) HXProvincialCitiesCountiesPickerview *regionPickerView;
@property (nonatomic,strong) UserDetailInfo * userDetailInfo;
@property (nonatomic,strong) HTTPRequest * userDetailrequest;





@end

@implementation AddBandCardViewController

-(NSMutableArray *)bankArray
{
    if (!_bankArray) {
        _bankArray = [[NSMutableArray alloc] init];
    }
    return _bankArray;
}

-(XMWebImageView *)question
{
    if (!_question) {
        _question = [[XMWebImageView alloc] init];
        _question.image = [UIImage imageNamed:@"question"];
    }
    return _question;
}

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65, kScreenWidth, kScreenHeight-65)];
    }
    return _scrollView;
}

-(UIView *)areaView
{
    if (!_areaView) {
        _areaView = [[BankAffiliationView alloc] init];
        _areaView.backgroundColor = [UIColor colorWithHexString:@"333333"];
    }
    return _areaView;
}

-(UIButton *)codeBtn
{
    if (!_codeBtn) {
        _codeBtn = [[UIButton alloc] init];
        _codeBtn.layer.borderWidth = 1;
        _codeBtn.layer.borderColor = [UIColor colorWithHexString:@"434342"].CGColor;
        [_codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeBtn setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _codeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_codeBtn addTarget:self action:@selector(codeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _codeBtn;
}

-(UIButton *)finishBtn
{
    if (!_finishBtn) {
        _finishBtn = [[UIButton alloc] init];
        [_finishBtn setTitle:@"完成" forState:UIControlStateNormal];
        _finishBtn.enabled = YES;
        [_finishBtn setBackgroundColor:[UIColor colorWithHexString:@"bbbbbb"]];
        _finishBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_finishBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        _finishBtn.selected = NO;
    }
    return _finishBtn;
}


-(liebetweenTextField *)codeTf
{
    if (!_codeTf) {
        _codeTf = [[liebetweenTextField alloc] init];
        _codeTf.delegate = self;
        [_codeTf setPlaceholder:@"请输入你收到的短信验证码"];
        
    }
    return _codeTf;
}

-(UILabel *)code
{
    if (!_code) {
        _code = [[UILabel alloc] init];
        _code.textColor = [UIColor colorWithHexString:@"434342"];
        _code.textAlignment = NSTextAlignmentLeft;
        _code.text = @"验证码";
        _code.font = [UIFont systemFontOfSize:14];
        [_code sizeToFit];
    }
    return _code;
}

-(UILabel *)openingBank
{
    if (!_openingBank) {
        _openingBank = [[UILabel alloc] init];
        _openingBank.textColor = [UIColor colorWithHexString:@"434342"];
        _openingBank.textAlignment = NSTextAlignmentLeft;
        _openingBank.text = @"开户行地区";
        _openingBank.font = [UIFont systemFontOfSize:14];
        [_openingBank sizeToFit];
    }
    return _openingBank;
}

-(UILabel *)subBranchLbl
{
    if (!_subBranchLbl) {
        _subBranchLbl = [[UILabel alloc] init];
        _subBranchLbl.textColor = [UIColor colorWithHexString:@"434342"];
        _subBranchLbl.textAlignment = NSTextAlignmentLeft;
        _subBranchLbl.text = @"支行名称";
        _subBranchLbl.font = [UIFont systemFontOfSize:14];
        [_subBranchLbl sizeToFit];
    }
    return _subBranchLbl;
}

-(liebetweenTextField *)subBranchTf
{
    if (!_subBranchTf) {
        _subBranchTf = [[liebetweenTextField alloc] init];
        [_subBranchTf setPlaceholder:@"例:杭州分行余杭支行"];
        _subBranchTf.textColor = [UIColor colorWithHexString:@"434342"];
        _subBranchTf.delegate = self;
    }
    return _subBranchTf;
}
- (HXProvincialCitiesCountiesPickerview *)regionPickerView {
    if (!_regionPickerView) {
        _regionPickerView = [[HXProvincialCitiesCountiesPickerview alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) wself = self;
        _regionPickerView.completion = ^(NSString *provinceName,NSString *cityName,NSString *countyName) {
            __strong typeof(wself) self = wself;
            NSString * subBranch = [[NSString stringWithFormat:@"%@%@%@",provinceName,cityName,countyName] trim];
            [self.openingBankTf setTitle:subBranch forState:UIControlStateNormal];
            [self.openingBankTf setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
            wself.region = subBranch;
            
            if (self.region.length > 0 && self.kaihuhang.length > 0) {
                self.areaView.hidden = NO;
                [self setupUI:NO];
                self.areaView.areaString = [NSString stringWithFormat:@"%@%@%@",self.bankTf.text,self.region,self.kaihuhang];
                [self.view setNeedsLayout];
            }else{
                self.areaView.hidden = YES;
                [self setupUI:YES];
                [self.view setNeedsLayout];
            }
            
        };
        [self.navigationController.view addSubview:_regionPickerView];
    }
    return _regionPickerView;
}

-(UIButton *)openingBankTf
{
    if (!_openingBankTf) {
        _openingBankTf = [[UIButton alloc] init];
        [_openingBankTf setTitleColor:[UIColor colorWithHexString:@"434342"] forState:UIControlStateNormal];
        _openingBankTf.titleLabel.font = [UIFont systemFontOfSize:14];
        _openingBankTf.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_openingBankTf addTarget:self action:@selector(showCityPickView) forControlEvents:UIControlEventTouchUpInside];
        [self.openingBankTf setTitleColor:[UIColor colorWithHexString:@"b2b2b2"] forState:UIControlStateNormal];
        [_openingBankTf setTitle:@"请选择" forState:UIControlStateNormal];
    }
    return _openingBankTf;
}

-(liebetweenTextField *)phoneTf
{
    if (!_phoneTf) {
        _phoneTf = [[liebetweenTextField alloc] init];
        [_phoneTf setPlaceholder:@"请输入手机号"];
        _phoneTf.text = [Session sharedInstance].currentUser.phoneNumber;
        _phoneTf.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _phoneTf.delegate = self;
        
    }
    return _phoneTf;
}

-(UILabel *)phone
{
    if (!_phone) {
        _phone = [[UILabel alloc] init];
        _phone.textColor = [UIColor colorWithHexString:@"434342"];
        _phone.textAlignment = NSTextAlignmentLeft;
        _phone.text = @"手机号";
        _phone.font = [UIFont systemFontOfSize:14];
        [_phone sizeToFit];
    }
    return _phone;
}

-(liebetweenTextField *)idCardTf
{
    if (!_idCardTf) {
        _idCardTf = [[liebetweenTextField alloc] init];
        _idCardTf.delegate = self;
        [_idCardTf setPlaceholder:@"提交后不可修改"];
        _idCardTf.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        
    }
    return _idCardTf;
}

-(UILabel *)idCard
{
    if (!_idCard) {
        _idCard = [[UILabel alloc] init];
        _idCard.textColor = [UIColor colorWithHexString:@"434342"];
        _idCard.textAlignment = NSTextAlignmentLeft;
        _idCard.text = @"身份证号";
        _idCard.font = [UIFont systemFontOfSize:14];
        [_idCard sizeToFit];
    }
    return _idCard;
}

-(liebetweenTextField *)nameTf
{
    if (!_nameTf) {
        _nameTf = [[liebetweenTextField alloc] init];
        _nameTf.delegate = self;
        [_nameTf setPlaceholder:@"提交后不可修改"];
        _nameTf.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        
    }
    return _nameTf;
}

-(UILabel *)name
{
    if (!_name) {
        _name = [[UILabel alloc] init];
        _name.textColor = [UIColor colorWithHexString:@"434342"];
        _name.textAlignment = NSTextAlignmentLeft;
        _name.text = @"姓名";
        _name.font = [UIFont systemFontOfSize:14];
        [_name sizeToFit];
    }
    return _name;
}

-(liebetweenTextField *)bankCardNumTf
{
    if (!_bankCardNumTf) {
        _bankCardNumTf = [[liebetweenTextField alloc] init];
        _bankCardNumTf.delegate = self;
        _bankCardNumTf.clearButtonMode = UITextFieldViewModeWhileEditing;
        _bankCardNumTf.keyboardType = UIKeyboardTypeDecimalPad;
        [_bankCardNumTf setPlaceholder:@"提现免手续费,仅支持储蓄卡"];
    }
    return _bankCardNumTf;
}

-(UILabel *)bankCardNum
{
    if (!_bankCardNum) {
        _bankCardNum = [[UILabel alloc] init];
        _bankCardNum.textColor = [UIColor colorWithHexString:@"434342"];
        _bankCardNum.textAlignment = NSTextAlignmentLeft;
        _bankCardNum.text = @"银行卡号";
        _bankCardNum.font = [UIFont systemFontOfSize:14];
        [_bankCardNum sizeToFit];
    }
    return _bankCardNum;
}

-(liebetweenTextField *)bankTf
{
    if (!_bankTf) {
        _bankTf = [[liebetweenTextField alloc] init];
        _bankTf.delegate = self;
        [_bankTf setPlaceholder:@"选择银行"];
        
    }
    return _bankTf;
}

-(UILabel *)bank
{
    if (!_bank) {
        _bank = [[UILabel alloc] init];
        _bank.textColor = [UIColor colorWithHexString:@"434342"];
        _bank.textAlignment = NSTextAlignmentLeft;
        _bank.text = @"银行";
        _bank.font = [UIFont systemFontOfSize:14];
        [_bank sizeToFit];
    }
    return _bank;
}

-(UIView *)container1
{
    if (!_container1) {
        _container1 = [[UIView alloc] init];
        _container1.backgroundColor = [UIColor whiteColor];
    }
    return _container1;
}

-(UIView *)container2
{
    if (!_container2) {
        _container2 = [[UIView alloc] init];
        _container2.backgroundColor = [UIColor whiteColor];
    }
    return _container2;
}

-(UIView *)container3
{
    if (!_container3) {
        _container3 = [[UIView alloc] init];
        _container3.backgroundColor = [UIColor whiteColor];
    }
    return _container3;
}

-(UILabel *)alertLbl
{
    if (!_alertLbl) {
        _alertLbl = [[UILabel alloc] init];
        _alertLbl.font = [UIFont systemFontOfSize:12];
        _alertLbl.textAlignment = NSTextAlignmentCenter;
        _alertLbl.text = @"提醒: 后续只能绑定该持卡人的银行卡,且修改银行卡需要联系客服";
        _alertLbl.adjustsFontSizeToFitWidth = YES;
        _alertLbl.textColor = [UIColor colorWithHexString:@"bbbbbb"];
    }
    return _alertLbl;
}

-(UILabel *)alertLbl2
{
    if (!_alertLbl2) {
        _alertLbl2 = [[UILabel alloc] init];
        _alertLbl2.font = [UIFont systemFontOfSize:12];
        _alertLbl2.textAlignment = NSTextAlignmentLeft;
        _alertLbl2.text = @"提醒:开户行名称填写错误会导致提现失败，请仔细核对";
        _alertLbl2.adjustsFontSizeToFitWidth = YES;
        _alertLbl2.textColor = [UIColor colorWithHexString:@"bbbbbb"];
    }
    return _alertLbl2;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [super setupTopBar];
    [super setupTopBarTitle:@"添加银行卡"];
    [super setupTopBarBackButton];
    
    
    
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.container1];
    [self.scrollView addSubview:self.container2];
    [self.scrollView addSubview:self.container3];
    [self.scrollView addSubview:self.areaView];
    [self.scrollView addSubview:self.alertLbl];
    [self.scrollView addSubview:self.alertLbl2];
    [self.container1 addSubview:self.question];
    [self.container1 addSubview:self.bank];
    [self.container1 addSubview:self.bankTf];
    [self.container1 addSubview:self.bankCardNum];
    [self.container1 addSubview:self.bankCardNumTf];
    [self.container1 addSubview:self.openingBank];
    [self.container1 addSubview:self.openingBankTf];
    [self.container1 addSubview:self.subBranchLbl];
    [self.container1 addSubview:self.subBranchTf];
    [self.container2 addSubview:self.name];
    [self.container2 addSubview:self.nameTf];
    [self.container2 addSubview:self.idCard];
    [self.container2 addSubview:self.idCardTf];
    [self.container3 addSubview:self.phone];
    [self.container3 addSubview:self.phoneTf];
    [self.container3 addSubview:self.code];
    [self.container3 addSubview:self.codeTf];
    [self.container3 addSubview:self.codeBtn];
    [self.scrollView addSubview:self.finishBtn];
    self.areaView.hidden = YES;
    
    [self setupUI:YES];
    
    [self netWorkingRequest];
    
    
    
    WEAKSELF;
    _question.handleSingleTapDetected = ^(XMWebImageView * view, UITouch * touch){
        _wonderView = [[WonderingView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [weakSelf.wonderView show];
    };
    
}

-(void)supplementaryInformation
{
    //补充银行卡信息
    if (self.withdrawalsVo.bankName.length > 0) {
        
        for (BankModel * bank in self.bankArray) {
            if ([self.withdrawalsVo.bankName isEqualToString:bank.bankName]) {
                self.bankTf.text = self.withdrawalsVo.bankName;
                self.bankTf.enabled = NO;
                self.bank_id = bank.id;
                self.idd = self.withdrawalsVo.idd;
                break;
            }
        }
    }
    
    if (self.withdrawalsVo.account.length > 0) {
        self.bankCardNumTf.text = self.withdrawalsVo.account;
        self.bankCardNumTf.enabled = NO;
        self.bank_card = self.withdrawalsVo.account;
    }
    
    if (self.withdrawalsVo.belong.length > 0) {
        self.nameTf.text = self.withdrawalsVo.belong;
        self.nameTf.enabled = NO;
        self.user_name = self.withdrawalsVo.belong;
    }
    
    if (self.withdrawalsVo.identityCard.length > 0) {
        self.idCardTf.text = self.withdrawalsVo.identityCard;
        self.idCardTf.enabled = NO;
        self.identity_card = self.withdrawalsVo.identityCard;
    }
    
    if (self.withdrawalsVo.bankDeposit) {
        self.subBranchTf.text = self.withdrawalsVo.bankDeposit;
        self.subBranchTf.enabled = NO;
        self.kaihuhang = self.withdrawalsVo.bankDeposit;
    }
    
    if (self.withdrawalsVo.region.length > 0) {
        [self.openingBankTf setTitle:[NSString stringWithFormat:@"%@",self.withdrawalsVo.region] forState:UIControlStateNormal];
        self.openingBankTf.enabled = NO;
        self.region = self.withdrawalsVo.region;
    }
    
}

-(void)showCityPickView
{
    NSString *address = _openingBankTf.titleLabel.text;
    NSArray *array = [address componentsSeparatedByString:@" "];
    NSString *province = @"";//省
    NSString *city = @"";//市
    NSString *county = @"";//县
    if (array.count > 2) {
        province = array[0];
        city = array[1];
        county = array[2];
    } else if (array.count > 1) {
        province = array[0];
        city = array[1];
    } else if (array.count > 0) {
        province = array[0];
    }
    
    [self.regionPickerView showPickerWithProvinceName:province cityName:city countyName:county];
}


-(void)netWorkingRequest
{
    [self showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"bank" path:@"names" parameters:nil completionBlock:^(NSDictionary *data) {
        [self hideLoadingView];
        NSArray * arr = data[@"list"];
        for (NSDictionary * dict in arr) {
            BankModel * bank = [[BankModel alloc] initWithJSONDictionary:dict];
            [self.bankArray addObject:bank];
        }
        [self createPickView];
        
        if (self.withdrawalsVo) {
            [self supplementaryInformation];
        }
    } failure:^(XMError *error) {
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
    
    NSInteger userId = [Session sharedInstance].currentUserId;
    
    [self showLoadingView];
    _userDetailrequest = [[NetworkAPI sharedInstance] getUserDetail:userId completion:^(UserDetailInfo *userDetailInfo) {
        [self hideLoadingView];
        self.userDetailInfo = userDetailInfo;
        if (userDetailInfo.userInfo.realName.length > 0) {
            self.nameTf.text = userDetailInfo.userInfo.realName;
            self.user_name = userDetailInfo.userInfo.realName;
        }
        
    } failure:^(XMError *error) {
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    }];
    
}

-(void)codeBtnClick
{
    WEAKSELF;
    
    BOOL isValid = [self chectOutisValid];
    
    if (isValid) {
        if (_phoneTf.text.length > 0 && [_phoneTf.text isValidMobilePhoneNumber]) {
            NSString *message = [NSString stringWithFormat:@"\n我们将发送验证码短信到这个号码:\n+86 %@\n",_phoneTf.text];
            [WCAlertView showAlertWithTitle:@"确认手机号码" message:message customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
                if (buttonIndex == 0) {
                    
                }else{
                    [weakSelf showProcessingHUD:nil forView:weakSelf.view];
                    
                    NSInteger type;
                    if (self.withdrawalsVo) {
                        type = CaptchaTypeModifyBank;
                    }else{
                        type = CaptchaTypeAddBank;
                    }
                    
                    weakSelf.request = [[NetworkAPI sharedInstance] getCaptchaCodeEncrypt:_phoneTf.text type:type sms_type:0 completion:^{
                        [weakSelf hideHUD];
                        
                        self.timerPeriod = 60;
                        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(run:) userInfo:nil repeats:YES];
                        [_timer setFireDate:[NSDate distantPast]];
                        
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8 forView:weakSelf.view];
                    }];
                }
                
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
            
            
        }else{
            [self showHUD:@"请输入正确的电话号码" hideAfterDelay:0.8 forView:self.view];
        }
    }
    
}

-(BOOL)chectOutisValid
{
    BOOL isValid = YES;
    if (isValid) {
        if ([_bankTf.text trim].length == 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择银行"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if ([_bankCardNumTf.text trim].length == 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先填写银行卡"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if ([_region trim].length == 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先选择地区"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if ([_subBranchTf.text trim].length == 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先填写支行名称"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if ([_nameTf.text trim].length == 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先填写姓名"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    if (isValid) {
        if ([_idCardTf.text trim].length == 0) {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请先填写身份证"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             
                         } cancelButtonTitle:@"确定" otherButtonTitles:nil];
            isValid = NO;
        }
    }
    
    
    return isValid;
}

- (void)run:(NSTimer *)timer
{
    
    if (self.timerPeriod > 0) {
        [self.codeBtn setTitle:[NSString stringWithFormat:@"(%ld)",self.timerPeriod-= 1] forState:UIControlStateNormal];
        self.codeBtn.enabled = NO;
    }else{
        [self.codeBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        [timer setFireDate:[NSDate distantFuture]];
        self.codeBtn.enabled = YES;;
    }
    
}

-(void)createPickView
{
    UIPickerView * pickview = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 0, 225)];
    pickview.delegate = self;
    pickview.dataSource = self;
    _bankTf.inputView = pickview;
}



-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == _nameTf) {
        self.user_name = [_nameTf.text trim];
    }
    
    if (textField == _bankCardNumTf) {
        self.bank_card = [_bankCardNumTf.text trim];
    }
    
    if (textField == _idCardTf) {
        if ([[_idCardTf.text trim] isValidIdCardNumber]) {
            self.identity_card = [_idCardTf.text trim];
        }else{
            self.idCardTf.text = nil;
            self.identity_card = nil;
            [self showHUD:@"请填写有效身份证号码" hideAfterDelay:1.2];
        }
    }
    
    if (textField == _codeTf) {
        self.auth_code = [_codeTf.text trim];
    }
    
    if (textField == _subBranchTf) {
        self.kaihuhang = [_subBranchTf.text trim];
    }
    
    
    if (self.region.length > 0 && self.kaihuhang.length > 0) {
        self.areaView.hidden = NO;
        [self setupUI:NO];
        self.areaView.areaString = [NSString stringWithFormat:@"%@%@%@",self.bankTf.text,self.region,self.kaihuhang];
        [self.view setNeedsLayout];
    }else{
        self.areaView.hidden = YES;
        [self setupUI:YES];
        [self.view setNeedsLayout];
    }
    
    
    if ([self.bank_card length] != 0 &&
        [self.identity_card length] != 0 &&
        [self.auth_code length] != 0 &&
        [self.bank_id length] != 0 &&
        [self.kaihuhang length]!= 0 &&
        [self.user_name length] != 0 &&
        [self.region length] != 0) {
        _finishBtn.backgroundColor = [UIColor colorWithHexString:@"434342"];
        _finishBtn.selected = YES;
    }else{
        _finishBtn.backgroundColor = [UIColor colorWithHexString:@"bbbbbb"];
        _finishBtn.selected = NO;
    }
    
}

-(void)buttonClick:(UIButton *)button
{
    
    if (button.selected) {
        
        if ([self.bank_card length] != 0 && [self.user_name length] != 0 && [self.identity_card length] != 0 && [self.auth_code length] != 0 && [self.bank_id length] != 0 && [self.kaihuhang length] != 0 && [self.region length] != 0) {
            NSInteger user_id = [Session sharedInstance].currentUser.userId;
            NSArray *array = [self.bank_card componentsSeparatedByString:@" "];
            NSString * bankCard = [array componentsJoinedByString:@""];
            
            NSDictionary * parm;
            if (self.idd) {
                parm = @{@"user_id":[NSNumber numberWithInteger:user_id],
                         @"name":self.user_name?self.user_name: @"",
                         @"bank_id":@(self.bank_id.integerValue)?@(self.bank_id.integerValue):@"",
                         @"bank_card":bankCard?bankCard:@"",
                         @"identity_card":self.identity_card?self.identity_card:@"",
                         @"auth_code":self.auth_code?self.auth_code:@"",
                         @"bank_deposit":self.kaihuhang?self.kaihuhang:@"",
                         @"region":self.region?self.region:@"",
                         @"id":@(self.idd)?@(self.idd):@"",};
            }else{
                parm = @{@"user_id":[NSNumber numberWithInteger:user_id],
                         @"name":self.user_name?self.user_name: @"",
                         @"bank_id":@(self.bank_id.integerValue)?@(self.bank_id.integerValue):@"",
                         @"bank_card":bankCard?bankCard:@"",
                         @"identity_card":self.identity_card?self.identity_card:@"",
                         @"auth_code":self.auth_code?self.auth_code:@"",
                         @"bank_deposit":self.kaihuhang?self.kaihuhang:@"",
                         @"region":self.region?self.region:@""};
            }
            _request = [[NetworkAPI sharedInstance] addAndupdateBank:parm completion:^{
                [self.navigationController popViewControllerAnimated:YES];
            } failure:^(XMError *error) {
                [self showHUD:[error errorMsg] hideAfterDelay:0.8];
            }];
            
        }else{
            [self showHUD:@"请把信息填完整" hideAfterDelay:0.8];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    
    if (textField == _bankCardNumTf) {
        // 四位加一个空格
        if ([string isEqualToString:@""]) { // 删除字符
            if ((textField.text.length - 2) % 5 == 0) {
                textField.text = [textField.text substringToIndex:textField.text.length - 1];
            }
            return YES;
        } else {
            if (textField.text.length % 5 == 0) {
                textField.text = [NSString stringWithFormat:@"%@ ", textField.text];
            }
        }
        return YES;
    }
    return YES;
    
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (textField == _phoneTf) {
        return NO;
    }
    
    if (textField == _nameTf) {
        if (self.userDetailInfo.userInfo.realName.length > 0) {
            return NO;
        }else{
            return YES;
        }
    }
    
    return YES;
}

- (void)setupUI:(BOOL)isHide {
    
    CGFloat marginTop = 0;
    
    [self.container1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scrollView.mas_top);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(175);
    }];
    
    marginTop += 175;
    
    if (!isHide) {
        
        self.areaView.frame = CGRectMake(0, marginTop, kScreenWidth, 50);
        marginTop += 50;
        
        self.alertLbl2.frame = CGRectMake(14, marginTop, kScreenWidth, 40);
        
        marginTop += 40;
    } else {
        self.alertLbl2.frame = CGRectMake(14, marginTop, kScreenWidth, 40);
        marginTop += 40;
    }
    
    [self.container2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertLbl2.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(90);
    }];
    
    marginTop += 90;
    
    [self.alertLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container2.mas_bottom);
        make.right.equalTo(self.view.mas_right).offset(-14);
        make.left.equalTo(self.view.mas_left).offset(14);
        make.height.mas_equalTo(@40);
    }];
    
    marginTop += 40;
    
    [self.container3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.alertLbl.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.height.mas_equalTo(90);
    }];
    
    marginTop += 90;
    
    [self.bank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container1.mas_top).offset(15);
        make.left.equalTo(self.container1.mas_left).offset(14);
    }];
    
    [self.bankTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container1.mas_top).offset(15);
        make.left.equalTo(self.container1.mas_left).offset(90);
        make.right.equalTo(self.container1.mas_right).offset(-14);
        make.bottom.equalTo(self.bank.mas_bottom);
    }];
    
    [self.bankCardNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bank.mas_bottom).offset(20);
        make.left.equalTo(self.container1.mas_left).offset(14);
    }];
    
    [self.bankCardNumTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankCardNum.mas_top);
        make.left.equalTo(self.container1.mas_left).offset(90);
        make.right.equalTo(self.container1.mas_right).offset(-14);
        make.bottom.equalTo(self.bankCardNum.mas_bottom);
    }];
    
    [self.openingBank mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankCardNum.mas_bottom).offset(20);
        make.left.equalTo(self.container1.mas_left).offset(14);
    }];
    
    [self.openingBankTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openingBank.mas_top);
        make.left.equalTo(self.container1.mas_left).offset(90);
        make.right.equalTo(self.container1.mas_right).offset(-44);
        make.bottom.equalTo(self.openingBank.mas_bottom);
    }];
    
    [self.subBranchLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.openingBank.mas_bottom).offset(20);
        make.left.equalTo(self.container1.mas_left).offset(14);
    }];
    
    [self.subBranchTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subBranchLbl.mas_top);
        make.left.equalTo(self.container1.mas_left).offset(90);
        make.right.equalTo(self.container1.mas_right).offset(-44);
        make.bottom.equalTo(self.subBranchLbl.mas_bottom);
    }];
    
    [self.name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container2.mas_top).offset(15);
        make.left.equalTo(self.container2.mas_left).offset(14);
    }];
    
    [self.nameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container2.mas_top).offset(15);
        make.left.equalTo(self.container2.mas_left).offset(90);
        make.right.equalTo(self.container2.mas_right).offset(-14);
        make.bottom.equalTo(self.name.mas_bottom);
    }];
    
    [self.idCard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.name.mas_bottom).offset(28);
        make.left.equalTo(self.container2.mas_left).offset(14);
    }];
    
    [self.idCardTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idCard.mas_top);
        make.left.equalTo(self.container2.mas_left).offset(90);
        make.right.equalTo(self.container2.mas_right).offset(-14);
        make.bottom.equalTo(self.idCard.mas_bottom);
    }];
    
    [self.phone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container3.mas_top).offset(15);
        make.left.equalTo(self.container3.mas_left).offset(14);
    }];
    
    [self.phoneTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container3.mas_top).offset(15);
        make.left.equalTo(self.container3.mas_left).offset(90);
        make.right.equalTo(self.container3.mas_right).offset(-100);
        make.bottom.equalTo(self.phone.mas_bottom);
    }];
    
    [self.code mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phone.mas_bottom).offset(28);
        make.left.equalTo(self.container3.mas_left).offset(14);
    }];
    
    [self.codeTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.code.mas_top);
        make.left.equalTo(self.container3.mas_left).offset(90);
        make.right.equalTo(self.container3.mas_right).offset(-14);
        make.bottom.equalTo(self.code.mas_bottom);
    }];
    
    
    [self.finishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.container3.mas_bottom).offset(14);
        make.left.equalTo(self.view.mas_left).offset(34);
        make.right.equalTo(self.view.mas_right).offset(-34);
        make.height.mas_equalTo(40);
    }];
    
    marginTop += 40+14+14;
    
    [self.codeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phone.mas_top);
        make.right.equalTo(self.container3.mas_right).offset(-18);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*100, 28));
    }];
    
    [self.question mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.subBranchTf.mas_centerY);
        make.left.equalTo(self.subBranchTf.mas_right).offset(5);
    }];
    
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, marginTop);
    
    [self.view setNeedsLayout];
}

-(void)dealloc
{
    _timer = nil;
    [_timer invalidate];
}

#pragma mark - pickviewdelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    return [self.bankArray[row] bankName];
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.bankArray.count;
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    _bankTf.text = [self.bankArray[row] bankName];
    self.bank_id = [self.bankArray[row] id];
}
@end


@implementation liebetweenTextField

-(instancetype)init
{
    if (self = [super init]) {
        [self setValue:[UIFont systemFontOfSize:14] forKeyPath:@"_placeholderLabel.font"];
    }
    return self;
    
}


-(void)setPlaceholder:(NSString *)placeholderString
{
    NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
    self.textColor = [UIColor colorWithHexString:@"434342"];
    style.minimumLineHeight = self.font.lineHeight - (self.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
    
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderString?placeholderString:@""
                                  
                                                                 attributes:@{                                                                              NSForegroundColorAttributeName: [UIColor lightGrayColor],
                                                                                                                                                            
                                                                                                                                                            NSFontAttributeName : [UIFont systemFontOfSize:13.5],
                                                                                                                                                            
                                                                                                                                                            NSParagraphStyleAttributeName : style
                                                                                                                                                            
                                                                                                                                                            }
                                  
                                  ];
    
}

@end




