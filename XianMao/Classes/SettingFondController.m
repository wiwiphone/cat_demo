//
//  SettingFondController.m
//  XianMao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SettingFondController.h"
#import "GoodsService.h"
#import "RecoveryPreference.h"
#import "PushView.h"
#import "GoodsService.h"
#import "PreferenceInJson.h"

#import "SetCellView.h"
#import "SetCellView1.h"
#import "SetCellView2.h"

#import "RecoveryItem.h"
#import "RecoverUserInfo.h"
#import "RecoverCateView.h"

#import "ASScroll.h"
#import "Error.h"
#import "Masonry.h"

@interface SettingFondController () <UIPickerViewDataSource, UIPickerViewDelegate, SetCellView1Delegate>

@property (nonatomic, assign) CGFloat topBarHeight;
@property (nonatomic, strong) NSMutableArray *preData;
@property (nonatomic, strong) ASScroll *topChooseView;
@property (nonatomic, strong) PushView *pushView;

@property (nonatomic, assign) BOOL isDown;

@property (nonatomic, strong) NSMutableArray *subBtnArr;
@property (nonatomic, strong) NSMutableArray *preInJsonArr;

@property (nonatomic, assign) BOOL IsAlrSet;

@property (nonatomic, strong) SetCellView *setCellView;
@property (nonatomic, strong) SetCellView1 *setCellView1;
@property (nonatomic, strong) SetCellView2 *setCellView2;
@property (nonatomic, strong) UILabel *cellViewLbl;
@property (nonatomic, strong) UIView *cellLineView;
@property (nonatomic, strong) UILabel *cellViewLbl1;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, strong) NSMutableArray *paramArr;

@property (nonatomic, assign) NSInteger isReceive;
@property (nonatomic, assign) NSInteger isdDisturb;
@property (nonatomic, strong) NSNumber *receiveNum;
@property (nonatomic, copy) NSString *receiveStr;

@property (nonatomic, strong) UIView *pickerBackView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *certainBtn;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) NSMutableArray *receiveNumArr;
@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, assign) NSInteger indexPrefer;

@property (nonatomic, assign) NSInteger isAleChooseB;
@property (nonatomic, assign) NSInteger isAleChooseC;
@end

@implementation SettingFondController

-(UIView *)pickerBackView{
    if (!_pickerBackView) {
        _pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 215, kScreenWidth, 215)];
        _pickerBackView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerBackView;
}

-(UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_cancleBtn sizeToFit];
    }
    return _cancleBtn;
}

-(UIButton *)certainBtn{
    if (!_certainBtn) {
        _certainBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_certainBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_certainBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        _certainBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_certainBtn sizeToFit];
    }
    return _certainBtn;
}

-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 200, kScreenWidth, 200)];
        _pickerView.backgroundColor = [UIColor whiteColor];
//        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

-(NSMutableArray *)paramArr{
    if (!_paramArr) {
        _paramArr = [[NSMutableArray alloc] init];
    }
    return _paramArr;
}

-(UILabel *)cellViewLbl1{
    if (!_cellViewLbl1) {
        _cellViewLbl1 = [[UILabel alloc] initWithFrame:CGRectZero];
        _cellViewLbl1.textColor = [UIColor colorWithHexString:@"b5b5b6"];
        _cellViewLbl1.font = [UIFont systemFontOfSize:14.f];
        _cellViewLbl1.text = @"开启夜间免打扰，23:00-07:00将不会通知您";
        [_cellViewLbl1 sizeToFit];
    }
    return _cellViewLbl1;
}

-(UILabel *)cellViewLbl{
    if (!_cellViewLbl) {
        _cellViewLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _cellViewLbl.textColor = [UIColor colorWithHexString:@"b5b5b6"];
        _cellViewLbl.font = [UIFont systemFontOfSize:14.f];
        _cellViewLbl.text = @"有符合您偏好的新品，会在APP里推送消息给您";
        [_cellViewLbl sizeToFit];
    }
    return _cellViewLbl;
}

-(NSMutableArray *)preInJsonArr{
    if (!_preInJsonArr) {
        _preInJsonArr = [[NSMutableArray alloc] init];
    }
    return _preInJsonArr;
}

-(PushView *)pushView{
    if (!_pushView) {
        _pushView = [[PushView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - self.topBarHeight - self.topChooseView.height)];
        _pushView.backgroundColor = [UIColor whiteColor];
    }
    return _pushView;
}

-(NSMutableArray *)subBtnArr{
    if (!_subBtnArr) {
        _subBtnArr = [[NSMutableArray alloc] init];
    }
    return _subBtnArr;
}

-(ASScroll *)topChooseView{
    if (!_topChooseView) {
        _topChooseView = [[ASScroll alloc] initWithFrame:CGRectZero];
        _topChooseView.backgroundColor = [UIColor whiteColor];
    }
    return _topChooseView;
}

-(NSMutableArray *)preData{
    if (!_preData) {
        _preData = [[NSMutableArray alloc] init];
    }
    return _preData;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.pushView layoutSubviews];
    [self.setCellView layoutSubviews];
    [self.setCellView1 layoutSubviews];
    [self.setCellView2 layoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.indexPrefer = 1;
    self.isDown = NO;
    self.topBarHeight = [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"偏好设置"];
    self.view.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];
    [self.view addSubview:self.topChooseView];
    
    [self.view addSubview:self.pushView];
    self.pushView.hidden = YES;
    WEAKSELF;
    [GoodsService getRecoverPreferenceCompletion:^(NSDictionary *dict) {
        NSArray *arr = dict[@"get_recovery_preference_in_json"];
        
        
//        if (weakSelf.preInJsonArr.count == 0) {
//            weakSelf.IsAlrSet = NO;
//            self.setCellView.hidden = NO;
//            self.cellViewLbl.hidden = NO;
//            self.setCellView.alpha = 0.7;
//            self.setCellView.userInteractionEnabled = NO;
//            self.setCellView1.hidden = YES;
//            self.setCellView2.hidden = YES;
//            self.cellLineView.hidden = YES;
//            self.cellViewLbl1.hidden = YES;
//        } else {
//            weakSelf.IsAlrSet = YES;
//            self.setCellView.hidden = NO;
//            self.cellViewLbl.hidden = NO;
//            self.setCellView.alpha = 1;
//            self.setCellView.userInteractionEnabled = YES;
//            self.setCellView1.hidden = NO;
//            self.setCellView2.hidden = NO;
//            self.cellLineView.hidden = NO;
//            self.cellViewLbl1.hidden = NO;
//        }
        for (int i = 0; i < arr.count; i++) {
            PreferenceInJson *preInJson = [[PreferenceInJson alloc] initWithJSONDictionary:arr[i]];
//            for (int i = 0; i < weakSelf.subBtnArr.count; i++) {
//                if (preInJson.qk) {
//                    UIButton *btn = weakSelf.subBtnArr[0];
//                    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//                }
//                if (preInJson.qv) {
//                    UIButton *btn = weakSelf.subBtnArr[1];
//                    [btn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
//                }
//            }
            [weakSelf.preInJsonArr addObject:preInJson];
        }
        [weakSelf.pushView getInJsonArr:arr];
        
        if (weakSelf.preInJsonArr.count == 0) {
            weakSelf.IsAlrSet = NO;
        } else {
            weakSelf.IsAlrSet = YES;
        }
        
        self.setCellView = [[SetCellView alloc] initWithFrame:CGRectZero];
        [self.setCellView.switchBtn addTarget:self action:@selector(switchWillChange:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:self.setCellView];
        [self.view addSubview:self.cellViewLbl];
        
        self.setCellView1 = [[SetCellView1 alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.setCellView1];
        self.setCellView1.setCellView1Delegate = self;
        
        UIView *cellLineView = [[UIView alloc] initWithFrame:CGRectZero];
        cellLineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
        cellLineView.hidden = YES;
        [self.view addSubview:cellLineView];
        self.cellLineView = cellLineView;
        
        self.setCellView2 = [[SetCellView2 alloc] initWithFrame:CGRectZero];
        [self.view addSubview:self.setCellView2];
        [self.setCellView2.switchBtn addTarget:self action:@selector(evenNotPush:) forControlEvents:UIControlEventValueChanged];
        
        [self.view addSubview:self.cellViewLbl1];
        self.cellViewLbl1.hidden = YES;
        
        [self.view addSubview:self.pickerBackView];
        self.receiveNumArr = [[NSMutableArray alloc] initWithObjects:@50, @100, @150, @250, @400, @0, nil];
        self.pickerView.dataSource = self;
        self.pickerView.delegate = self;
        [self.pickerBackView addSubview:self.pickerView];
        
        [self.pickerBackView addSubview:self.certainBtn];
        [self.pickerBackView addSubview:self.cancleBtn];
        [self.certainBtn addTarget:self action:@selector(clickCertainBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.cancleBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
        
        if (arr.count == 0) {
            weakSelf.IsAlrSet = NO;
            self.setCellView.hidden = NO;
            self.cellViewLbl.hidden = NO;
            self.setCellView.alpha = 0.7;
            self.setCellView.userInteractionEnabled = NO;
            self.setCellView1.hidden = YES;
            self.setCellView2.hidden = YES;
            self.cellLineView.hidden = YES;
            self.cellViewLbl1.hidden = YES;
        } else {
            weakSelf.IsAlrSet = YES;
            self.setCellView.hidden = NO;
            self.cellViewLbl.hidden = NO;
            self.setCellView.alpha = 1;
            self.setCellView.userInteractionEnabled = YES;
            self.setCellView1.hidden = NO;
            self.setCellView2.hidden = NO;
            self.cellLineView.hidden = NO;
            self.cellViewLbl1.hidden = NO;
        }
        
        [self setUpUI];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
    
    [self loadData];
    
    
    self.pushView.resetMenu = ^(){
        
    };
    
    
    self.pushView.sureMenu = ^(NSMutableArray *arr){
        [weakSelf.paramArr removeAllObjects];
        
        for (int i = 0; i < arr.count; i++) {
            
            CateButton *btn = arr[i];
            if (btn.item.is_selected == 1) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:btn.parenceQueryKey forKey:@"qk"];
                [dict setValue:btn.item.query_value forKey:@"qv"];
                [weakSelf.paramArr addObject:dict];
            }
        }
        
        for (int i = 0; i < weakSelf.preData.count; i++) {
            RecoveryPreference *preference = weakSelf.preData[i];
            if (preference.type == 0) {
                for (int i = 0; i < preference.items.count; i++) {
                    RecoveryItem *item = preference.items[i];
                    if (item.is_selected == 1) {
//                        NSLog(@"%@", item.query_value);
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setValue:preference.query_key forKey:@"qk"];
                        [dict setValue:item.query_value forKey:@"qv"];
                        [weakSelf.paramArr addObject:dict];
                    }
                }
            } else {
                for (int i = 0; i < preference.items.count; i++) {
                    RecoveryPreference *preferenceItem = preference.items[i];
                    if (preferenceItem.type == 0) {
                        for (int i = 0; i < preferenceItem.items.count; i++) {
                            RecoveryItem *item = preferenceItem.items[i];
                            if (item.is_selected == 1) {
//                                NSLog(@"%@", item.query_value);
                                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                                [dict setValue:preference.query_key forKey:@"qk"];
                                [dict setValue:item.query_value forKey:@"qv"];
                                [weakSelf.paramArr addObject:dict];
                            }
                        }
                    }
                }
            }
        }
//        NSLog(@"%@", arr);
//        for (int i = 0; i < arr.count; i++) {
//            CateButton *btn = arr[i];
//            if (btn.item.is_selected == 1) {
//                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
//                [dict setValue:btn.parenceQueryKey forKey:@"qk"];
//                [dict setValue:btn.item.query_value forKey:@"qv"];
//                [weakSelf.paramArr addObject:dict];
//            }
//        }
        [weakSelf showLoadingView];
        
        [GoodsService setPreference:weakSelf.paramArr Completion:^(NSDictionary *dict) {
            [weakSelf hideLoadingView];
            for (int i = 0; i < weakSelf.subBtnArr.count; i++) {
                UIButton *btn = weakSelf.subBtnArr[i];
                if (btn.tag == weakSelf.tag) {
                    [weakSelf clickChooseBtn:btn];
                }
            }
            [weakSelf showHUD:@"设置成功" hideAfterDelay:0.8];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
        
    };
    
    [GoodsService getRecoverUserInfo:^(NSDictionary *dict) {
        if (dict) {
            RecoverUserInfo *userInfo = [[RecoverUserInfo alloc] initWithJSONDictionary:dict[@"get_recovery_user_info"]];
            self.isReceive = userInfo.isCanPush;
            self.isdDisturb = userInfo.isCanEvenPush;
            self.receiveNum = [NSNumber numberWithInteger:userInfo.pushMaxNum];
            if (userInfo.isCanPush == 1) {
                self.setCellView.switchBtn.on = YES;
//                self.setCellView1.hidden = NO;
//                self.setCellView2.hidden = NO;
//                self.cellLineView.hidden = NO;
//                self.cellViewLbl1.hidden = NO;
            } else {
//                self.setCellView1.hidden = YES;
//                self.setCellView2.hidden = YES;
//                self.cellLineView.hidden = YES;
//                self.cellViewLbl1.hidden = YES;
            }
            if (userInfo.isCanEvenPush == 1) {
                self.setCellView2.switchBtn.on = YES;
            }
            if (userInfo.pushMaxNum == 0) {
                self.setCellView1.rigthLbl.text = @"不限";
            } else {
                self.setCellView1.rigthLbl.text = [NSString stringWithFormat:@"%ld条", userInfo.pushMaxNum];
            }
        }
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
    
}

-(void)switchWillChange:(UISwitch *)sender{
    if (sender.isOn) {
        self.isReceive = 1;
        self.setCellView1.hidden = NO;
        self.setCellView2.hidden = NO;
        self.cellViewLbl1.hidden = NO;
    } else {
        self.isReceive = 0;
        self.setCellView1.hidden = YES;
        self.setCellView2.hidden = YES;
        self.cellViewLbl1.hidden = YES;
    }
    NSLog(@"%ld", self.isReceive);
    [self setPushNews];
}

-(void)evenNotPush:(UISwitch *)sender{
    if (sender.isOn) {
        self.isdDisturb = 1;
    } else {
        self.isdDisturb = 0;
    }
    NSLog(@"%ld", self.isdDisturb);
    [self setPushNews];
}

-(void)touchBegin{
    [self appearPickerBackView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissPickerBackView];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.receiveNumArr.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSNumber *num = [self.receiveNumArr objectAtIndex:row];
    if ([num isEqualToNumber:@0]) {
        return @"不限";
    } else {
        return [NSString stringWithFormat:@"%@", [self.receiveNumArr objectAtIndex:row]];
    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.receiveNum = [self.receiveNumArr objectAtIndex:row];
}

-(void)clickCertainBtn{
    if ([self.receiveNum isEqual:@0]) {
        self.setCellView1.rigthLbl.text = @"不限";
    } else {
        self.setCellView1.rigthLbl.text = [NSString stringWithFormat:@"%@条", self.receiveNum];
    }
    [self setPushNews];
    [self dismissPickerBackView];
}

-(void)clickCancelBtn{
    [self dismissPickerBackView];
}

-(void)appearPickerBackView{
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBackView.frame = CGRectMake(0, kScreenHeight - 215, kScreenWidth, 215);
    }];
}

-(void)dismissPickerBackView{
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBackView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 215);
    }];
}

-(void)setPushNews{
    if (!self.receiveNum) {
        self.receiveNum = 0;
    }
    WEAKSELF;
    NSDictionary *param = @{@"is_can_push" : [NSNumber numberWithInteger:self.isReceive], @"is_can_even_push" : [NSNumber numberWithInteger:self.isdDisturb], @"push_max_num" : self.receiveNum};
    
    [GoodsService setPushPreference:param Completion:^(NSDictionary *dict) {
        
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}

-(void)setUpUI{
    [self.topChooseView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@41);
    }];
    
    self.pushView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - self.topBarHeight - self.topChooseView.height);
    
    [self.setCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topChooseView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
    }];
    
    [self.cellViewLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setCellView.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
    }];
    
    [self.setCellView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellViewLbl.mas_bottom).offset(25);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
    }];
    
    [self.cellLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setCellView1.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    [self.setCellView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cellLineView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
    }];
    
    [self.cellViewLbl1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.setCellView2.mas_bottom).offset(10);
        make.left.equalTo(self.view.mas_left).offset(15);
    }];
    
    self.pickerBackView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 215);
    self.pickerView.frame = CGRectMake(0, self.pickerBackView.height - 200, kScreenWidth, 200);
    
    [self.certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerBackView.mas_top).offset(18);
        make.right.equalTo(self.pickerBackView.mas_right).offset(-31);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certainBtn.mas_top);
        make.left.equalTo(self.pickerBackView.mas_left).offset(31);
    }];
}

-(void)loadData{
    WEAKSELF;
    [self showLoadingView];
    [GoodsService getRecoverFondCompletion:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
        NSArray *arr = data[@"get_recovery_preference"];
        for (int i = 0; i < arr.count; i++) {
            RecoveryPreference *preference = [[RecoveryPreference alloc] initWithJSONDictionary:arr[i]];
            [weakSelf.preData addObject:preference];
        }
        
        for (int i = 0; i < weakSelf.preData.count; i++) {
            RecoveryPreference *prefernce = weakSelf.preData[i];
            UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / self.preData.count * i, 0, kScreenWidth / self.preData.count, self.topChooseView.height)];
            chooseBtn.backgroundColor = [UIColor whiteColor];
            chooseBtn.tag = i;
            [chooseBtn setTitle:prefernce.name forState:UIControlStateNormal];
            chooseBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
            [chooseBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
            if (prefernce.type == 0) {
                for (int i = 0; i < prefernce.items.count; i++) {
                    RecoveryItem *item = prefernce.items[i];
                    if (item.is_selected == 1) {
                        weakSelf.isAleChooseB = 1;
                        [chooseBtn setImage:[UIImage imageNamed:@"choose_recoverGoods_MF"] forState:UIControlStateNormal];
                        break ;
                    } else {
                        [chooseBtn setImage:[UIImage imageNamed:@"chooseArrBlack_Recover_MF"] forState:UIControlStateNormal];
                    }
                }
            } else {
                for (int i = 0; i < prefernce.items.count; i++) {
                    RecoveryPreference *preference = prefernce.items[i];
                    if (preference.type == 0) {
                        RecoveryItem *item = preference.items[i];
                        if (item.is_selected == 1) {
                            weakSelf.isAleChooseC = 1;
                            [chooseBtn setImage:[UIImage imageNamed:@"choose_recoverGoods_MF"] forState:UIControlStateNormal];
                            break ;
                        } else {
                            [chooseBtn setImage:[UIImage imageNamed:@"chooseArrBlack_Recover_MF"] forState:UIControlStateNormal];
                        }
                    }
                }
            }
            
            [chooseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -chooseBtn.imageView.image.size.width - 5, 0, chooseBtn.imageView.image.size.width)];
            [chooseBtn setImageEdgeInsets:UIEdgeInsetsMake(0, chooseBtn.titleLabel.bounds.size.width + 5, 0, -chooseBtn.titleLabel.bounds.size.width)];
            chooseBtn.imageView.transform = CGAffineTransformMakeRotation(0);
            [self.topChooseView addSubview:chooseBtn];
            [self.subBtnArr addObject:chooseBtn];
            [chooseBtn addTarget:self action:@selector(clickChooseBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        NSLog(@"%ld", weakSelf.preData.count);
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}
//self.topBarHeight + self.topChooseView.height
-(void)clickChooseBtn:(UIButton *)sender{
    WEAKSELF;
    self.pushView.viewController = self;
    RecoveryPreference *prefere = self.preData[sender.tag];
    if (prefere.type == 1) {
        [self.pushView getData:self.preData[sender.tag]];
//        self.indexPrefer = 2;
    } else if (prefere.type == 0) {
        [self.pushView getData:self.preData[sender.tag]];
    }
    

    self.tag = sender.tag;
    if (self.isDown) {
        [UIView animateWithDuration:0.25 animations:^{
            sender.imageView.transform = CGAffineTransformMakeRotation(0);
            __block BOOL b;
            __block BOOL c;
            for (int i = 0; i < self.subBtnArr.count; i++) {
                if (self.subBtnArr[i] == sender) {
                    sender.frame = CGRectMake(kScreenWidth / self.preData.count * i, 0, kScreenWidth / self.preData.count, self.topChooseView.height);
                    self.pushView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight - self.topBarHeight - self.topChooseView.height);
                    
                    [GoodsService getRecoverPreferenceCompletion:^(NSDictionary *dict) {
                        NSArray *arr = dict[@"get_recovery_preference_in_json"];
                        for (int i = 0; i < arr.count; i++) {
                            PreferenceInJson *inJson = [[PreferenceInJson alloc] initWithJSONDictionary:arr[i]];
                            if ([inJson.qk isEqualToString:@"brandId"]) {
                                b = YES;
                            }
                            if ([inJson.qk isEqualToString:@"categoryId"]) {
                                c = YES;
                            }
                        }
                        if(b) {
                            for (int i = 0; i < weakSelf.subBtnArr.count; i++) {
                                UIButton *btn = weakSelf.subBtnArr[i];
                                if (btn.tag == 0) {
                                    weakSelf.isAleChooseB = 1;
                                    [btn setImage:[UIImage imageNamed:@"choose_recoverGoods_MF"] forState:UIControlStateNormal];
                                } else {
                                    //                                        weakSelf.isAleChooseB = 0;
                                    //                                        [btn setImage:[UIImage imageNamed:@"chooseArrBlack_Recover_MF"] forState:UIControlStateNormal];
                                }
                            }
                        } else {
                            for (int i = 0; i < weakSelf.subBtnArr.count; i++) {
                                UIButton *btn = weakSelf.subBtnArr[i];
                                if (btn.tag == 0) {
                                    weakSelf.isAleChooseB = 0;
                                    [btn setImage:[UIImage imageNamed:@"chooseArrBlack_Recover_MF"] forState:UIControlStateNormal];
                                } else {
                                    //                                        weakSelf.isAleChooseB = 0;
                                    //                                        [btn setImage:[UIImage imageNamed:@"chooseArrBlack_Recover_MF"] forState:UIControlStateNormal];
                                }
                            }
                        }
                        if (c) {
                            for (int i = 0; i < weakSelf.subBtnArr.count; i++) {
                                UIButton *btn = weakSelf.subBtnArr[i];
                                if (btn.tag == 1) {
                                    weakSelf.isAleChooseC = 1;
                                    [btn setImage:[UIImage imageNamed:@"choose_recoverGoods_MF"] forState:UIControlStateNormal];
                                } else {
                                    //                                        weakSelf.isAleChooseC = 0;
                                    //                                        [btn setImage:[UIImage imageNamed:@"chooseArrBlack_Recover_MF"] forState:UIControlStateNormal];
                                }
                            }
                        } else {
                            for (int i = 0; i < weakSelf.subBtnArr.count; i++) {
                                UIButton *btn = weakSelf.subBtnArr[i];
                                if (btn.tag == 1) {
                                    weakSelf.isAleChooseC = 0;
                                    [btn setImage:[UIImage imageNamed:@"chooseArrBlack_Recover_MF"] forState:UIControlStateNormal];
                                } else {
                                    //                                        weakSelf.isAleChooseC = 0;
                                    //                                        [btn setImage:[UIImage imageNamed:@"chooseArrBlack_Recover_MF"] forState:UIControlStateNormal];
                                }
                            }
                        }
                        if (arr.count == 0) {
                            self.setCellView.hidden = NO;
                            self.cellViewLbl.hidden = NO;
                            self.setCellView.alpha = 0.7;
                            self.setCellView.userInteractionEnabled = NO;
                            self.setCellView1.hidden = YES;
                            self.setCellView2.hidden = YES;
                            self.cellLineView.hidden = YES;
                            self.cellViewLbl1.hidden = YES;
                        } else {
                            self.setCellView.hidden = NO;
                            self.cellViewLbl.hidden = NO;
                            self.setCellView.alpha = 1;
                            self.setCellView.userInteractionEnabled = YES;
                            self.setCellView1.hidden = NO;
                            self.setCellView2.hidden = NO;
                            self.cellLineView.hidden = NO;
                            self.cellViewLbl1.hidden = NO;
                        }
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                }
            }
        } completion:^(BOOL finished) {
            self.pushView.hidden = YES;
        }];
        self.isDown = NO;
    } else {
        [UIView animateWithDuration:0.25 animations:^{
            if (sender.tag == 0 && weakSelf.isAleChooseB == 1) {
                
            } else if (sender.tag == 1 && weakSelf.isAleChooseC == 1) {
                
            } else {
                sender.imageView.transform = CGAffineTransformMakeRotation(M_PI);
            }
            sender.frame = CGRectMake(0, 0, kScreenWidth, self.topChooseView.height);
            self.pushView.hidden = NO;
            self.pushView.frame = CGRectMake(0, self.topBarHeight + self.topChooseView.height, kScreenWidth, kScreenHeight - self.topBarHeight - self.topChooseView.height);
            
            self.setCellView.hidden = YES;
            self.setCellView1.hidden = YES;
            self.setCellView2.hidden = YES;
            self.cellLineView.hidden = YES;
            self.cellViewLbl.hidden = YES;
            self.cellViewLbl1.hidden = YES;
            
        } completion:^(BOOL finished) {
            
        }];
        self.isDown = YES;
    }
    
    for (int i = 0; i < self.subBtnArr.count; i++) {
        UIButton *btn = self.subBtnArr[i];
        if (btn != sender) {
            [UIView animateWithDuration:0.25 animations:^{
                btn.imageView.transform = CGAffineTransformMakeRotation(0);
            }];
            
            if (self.isDown) {
                [UIView animateWithDuration:0.25 animations:^{
                    btn.alpha = 0;
                }];
            } else {
                [UIView animateWithDuration:0.25 animations:^{
                    btn.alpha = 1;
                }];
            }
            
        } else {
            
        }
    }
}

@end
