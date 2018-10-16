//
//  BoughtCollectionViewController.m
//  XianMao
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BoughtCollectionViewController.h"
#import "BoughtViewController.h"
#import "OnSaleViewController.h"
#import "ForumPostDetailViewController.h"
#import "DigitalKeyboardView.h"

#import "Masonry.h"

#import "BlackView.h"
#import "PartialView.h"
#import "ParyialDo.h"
#import "PartialPayWayView.h"
#import "WCAlertView.h"
#import "UserService.h"
#import "WalletTwoViewController.h"

static CGFloat topViewHeight = 44;

@interface BoughtCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) BoughtViewController *boughtController;
@property (nonatomic, strong) BoughtCollectionViewCell *cell;
@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIButton *btn5;
@property (nonatomic, strong) UIButton *btn6;
@property (nonatomic, strong) UIScrollView *topView;
@property (nonatomic, strong) UIView *bottonView;

@property (nonatomic, strong) BlackView *partialBgView;
@property (nonatomic, strong) PartialPayWayView *partialPayWayView;
@property (nonatomic, assign) NSInteger is_partial_pay;
@property (nonatomic, strong) PartialView *partialView;
@property (nonatomic, assign) BOOL isLuxuryGoods;

@property (nonatomic, strong) ParyialDo *partialDo;
@property (nonatomic, assign) CGFloat payPrice;
@property (nonatomic, assign) CGFloat available_money_cent;
@end

static NSString *ID = @"collectionViewCellID";
@implementation BoughtCollectionViewController

-(PartialPayWayView *)partialPayWayView{
    if (!_partialPayWayView) {
        _partialPayWayView = [[PartialPayWayView alloc] initWithFrame:CGRectZero];
        _partialPayWayView.backgroundColor = [UIColor whiteColor];
    }
    return _partialPayWayView;
}

-(BlackView *)partialBgView{
    if (!_partialBgView) {
        _partialBgView = [[BlackView alloc] initWithFrame:CGRectZero];
        _partialBgView.alpha = 0;
    }
    return _partialBgView;
}

-(PartialView *)partialView{
    if (!_partialView) {
        _partialView = [[PartialView alloc] initWithFrame:CGRectZero];
        _partialView.backgroundColor = [UIColor whiteColor];
    }
    return _partialView;
}

-(ParyialDo *)partialDo{
    if (!_partialDo) {
        _partialDo = [[ParyialDo alloc] init];
    }
    return _partialDo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF;
    CGFloat topBarHeight = [super setupTopBar];
    //    [super setupTopBarTitle:@"我买的商品"];
    //缺少搜索图片
//    [super setupTopBarRightButton:[UIImage imageNamed:@" "] imgPressed:nil];
    self.type = 3;
//    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"商品",@"奢服务",nil];
//    UISegmentedControl *segmentedController = [[UISegmentedControl alloc] initWithItems:segmentedArray];
//    segmentedController.frame = CGRectMake(kScreenWidth / 2 - 71, topBarHeight - 33, 142, 25);
//    segmentedController.selectedSegmentIndex = self.selectSegmentIndex;
//    segmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
//    segmentedController.tintColor = [UIColor colorWithHexString:@"3e3a39"];
//    [segmentedController addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
//    
//    [self.topBar addSubview:segmentedController];
    [super setupTopBarTitle:@"我的订单"];
    [super setupTopBarBackButton];
    
    UIScrollView *topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, kScreenWidth, 44)];
    
    topView.showsHorizontalScrollIndicator = NO;
    topView.showsVerticalScrollIndicator = NO;
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"全部" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn1 sizeToFit];
    btn1.tag = 1000;
    [btn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn6 = [[UIButton alloc] init];
    [btn6 setTitle:@"待付款" forState:UIControlStateNormal];
    btn6.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn6 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn6 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn6 sizeToFit];
    btn6.tag = 2000;
    [btn6 addTarget:self action:@selector(clickBtn6:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setTitle:@"待发货" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn2 sizeToFit];
    btn2.tag = 3000;
    [btn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn3 = [[UIButton alloc] init];
    [btn3 setTitle:@"待收货" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn3 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn3 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn3 sizeToFit];
    btn3.tag = 4000;
    [btn3 addTarget:self action:@selector(clickBtn3:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn4 = [[UIButton alloc] init];
    [btn4 setTitle:@"已成交" forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn4 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn4 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn4 sizeToFit];
    btn4.tag = 5000;
    [btn4 addTarget:self action:@selector(clickBtn4:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn5 = [[UIButton alloc] init];
    [btn5 setTitle:@"已关闭" forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn5 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn5 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn5 sizeToFit];
    btn5.tag = 6000;
    [btn5 addTarget:self action:@selector(clickBtn5:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectZero];
    bottonView.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    
    UIView *bottonLine = [[UIView alloc] initWithFrame:CGRectMake(0, topView.height-1, kScreenWidth, 1)];
    bottonLine.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    
    btn1.selected = YES;
    [self.view addSubview:topView];
    [topView addSubview:btn1];
    [topView addSubview:btn2];
    [topView addSubview:btn3];
    [topView addSubview:btn4];
    [topView addSubview:btn5];
    [topView addSubview:btn6];
    [topView addSubview:bottonView];
    [topView addSubview:bottonLine];
    
    self.bottonView = bottonView;
    self.topView = topView;
    self.btn1 = btn1;
    self.btn2 = btn2;
    self.btn3 = btn3;
    self.btn4 = btn4;
    self.btn5 = btn5;
    self.btn6 = btn6;
    [self setUpUI];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - topBarHeight - 44);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topBarHeight + 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight - 44) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[BoughtCollectionViewCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    if (self.collectionViewIP) {
        [collectionView scrollToItemAtIndexPath:self.collectionViewIP atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        if (self.collectionViewIP.item == 1) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width + 20 * 1, topViewHeight-2, self.btn2.width, 2);
        } else if (self.collectionViewIP.item == 2) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn6.width + 20 * 2, topViewHeight-2, self.btn3.width, 2);
        } else if (self.collectionViewIP.item == 3) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn6.width + 20 * 3, topViewHeight-2, self.btn4.width, 2);
        } else if (self.collectionViewIP.item == 4) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width+self.btn6.width + 20 * 4, topViewHeight-2, self.btn5.width, 2);
        }
        
    }
    
    [UserService get_account:^(NSInteger reward_money_cent, NSInteger available_money_cent) {
        weakSelf.available_money_cent = available_money_cent;
    } failure:^(XMError *error) {
        
    }];
    
    _isLuxuryGoods = NO;
    
    BoughtViewController *boughtController = [[BoughtViewController alloc] init];
    self.boughtController = boughtController;
    
//    [self segmentSelected:self.type];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addPartialView:) name:@"addPartialView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(successPayOrder:) name:@"successPayOrder" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationSurpPay:) name:@"notificationSurpPay" object:nil];
}

-(void)successPayOrder:(NSNotification *)notify{
    OrderInfo *orderInfo = notify.object;
    NSLog(@"%@", orderInfo);
}

-(void)addPartialView:(NSNotification *)notify{
    self.partialDo = notify.object;
    [self showPartialView];
}

-(void)showPartialView{
    
    WEAKSELF;
    //    NSDictionary *dict = @{@"partialBgView":self.partialBgView, @"paryialView":self.partialView, @"partialDo":self.partialDo};
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"addPartialView" object:dict];
    [self.view addSubview:self.partialBgView];
    self.partialBgView.frame = self.view.bounds;
    [self.view addSubview:self.partialView];
    self.partialView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 250);
    [self.partialView getPartialDo:self.partialDo];
    
    self.partialBgView.dissMissBlackView = ^(){
        [weakSelf dismissPartialView];
        [weakSelf dismissPartialPayWayView];
    };
    self.partialView.clickProtialCloseBtn = ^(){
        [weakSelf dismissPartialView];
    };
    
    self.partialView.inputPrice = ^(NSString *priceNum, ParyialDo *partialDo){
        if (partialDo.payType == 20) {
            [weakSelf showHUD:@"请选择支付方式" hideAfterDelay:0.8f];
            return ;
        }
        weakSelf.payPrice = priceNum.doubleValue;
        if (partialDo.orderId && [partialDo.orderId length]>0) {
            NSMutableArray *orderIds = [[NSMutableArray alloc] init];
            [orderIds addObject:partialDo.orderId];
            //            [weakSelf payOrderList:orderIds payWay:partialDo.payType orderInfo:partialDo.orderInfo];
            weakSelf.is_partial_pay = 1;
            
            if (partialDo.payType == PayWayAdmMoney) {
                if (weakSelf.payPrice > weakSelf.available_money_cent/100) {
                    [weakSelf showChongZhiView];
                    return ;
                }
            }
            
            [weakSelf dismissPartialView];
//            [weakSelf dismissPartialPayWayView];
            NSDictionary *dict = @{@"orderIds":orderIds, @"partialDo":partialDo, @"priceNum":priceNum};
            [[NSNotificationCenter defaultCenter] postNotificationName:@"payOrder" object:dict];
        }
    };
    
    self.partialView.showPayWayView = ^(){
        [weakSelf showPayWayView];
    };
    self.partialPayWayView.dismissPartialPayWayView = ^(){
        [weakSelf dismissPartialPayWayView];
    };
    
    self.partialPayWayView.changePayWay = ^(PayWayDO *payWay){
        [weakSelf dismissPartialPayWayView];
        weakSelf.partialDo.payWayIconUrl = payWay.icon_url;
        weakSelf.partialDo.payType = payWay.pay_way;
        weakSelf.partialDo.payWayTitle = payWay.pay_name;
        weakSelf.partialDo.payWayContent = payWay.desc;
        [weakSelf.partialView getPartialDo:weakSelf.partialDo];
    };
    
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.partialBgView.alpha = 0.7;
        weakSelf.partialView.frame = CGRectMake(0, kScreenHeight-260, kScreenWidth, 260);
    }];
//    [weakSelf.partialView.textField becomeFirstResponder];
}
-(void)showChongZhiView{
    WEAKSELF;
    [WCAlertView showAlertWithTitle:@"提示" message:@"钱包余额不足，请充值" customizationBlock:^(WCAlertView *alertView) {
        
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        
        if (buttonIndex == 0) {
            WalletTwoViewController *controller = [[WalletTwoViewController alloc] init];
            [weakSelf pushViewController:controller animated:YES];
        } else if (buttonIndex == 1) {
            [weakSelf showPayWayView];
        }
        
    } cancelButtonTitle:@"充值" otherButtonTitles:@"更换其他支付方式", nil];
}

-(void)showPayWayView{
    
    [self.view addSubview:self.partialPayWayView];
    self.partialPayWayView.frame = CGRectMake(kScreenWidth, kScreenHeight-359, kScreenWidth, 359);
    [self.partialPayWayView getPartialDo:self.partialDo];
    [UIView animateWithDuration:0.25 animations:^{
        self.partialPayWayView.frame = CGRectMake(0, kScreenHeight-359, kScreenWidth, 359);
    } completion:^(BOOL finished) {
        [self.partialView.textField resignFirstResponder];
    }];
}

-(void)dismissPartialPayWayView{
    WEAKSELF;
    
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.partialPayWayView.frame = CGRectMake(kScreenWidth, kScreenHeight-359, kScreenWidth, 359);
    } completion:^(BOOL finished) {
        [weakSelf.partialPayWayView removeFromSuperview];
        [self.partialView.textField becomeFirstResponder];
    }];
}

-(void)dismissPartialView{
    
    [UIView animateWithDuration:0.25 animations:^{
        self.partialView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 250);
        self.partialBgView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.partialBgView removeFromSuperview];
        [self.partialView.textField resignFirstResponder];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

//-(void)addPartialView:(NSNotification *)notify{
//    NSDictionary *dict = notify.object;
//    
//    BlackView *partialBgView = dict[@"partialBgView"];
//    PartialView *partialView = dict[@"paryialView"];
//    ParyialDo *partialDo = dict[@"partialDo"];
//    
//    [self.view addSubview:partialBgView];
//    partialBgView.frame = self.view.bounds;
//    [self.view addSubview:partialView];
//    partialView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 250);
//    [partialView getPartialDo:partialDo];
//    
//}

//-(void)showKeyBorad{
//    ForumQuoteInputView *inputView = [[ForumQuoteInputView alloc] initWithFrame:CGRectZero];
//    [DigitalKeyboardView showInViewBought:self.view inputContainerView:inputView textFieldArray:[NSArray arrayWithObjects:inputView.textFiled, nil] completion:^(DigitalInputContainerView *inputContainerView) {
//        inputView.index = 1;
//        CGFloat priceCent = [((ForumQuoteInputView*)inputContainerView) priceCent];
//        CGFloat nextPriceCent = priceCent / 100;
//        NSLog(@"%f, %f", priceCent, nextPriceCent);
//        if (nextPriceCent >0) {
//            
//            //            if (nextPriceCent > weakSelf.partialDo.surplusPriceNum) {
//            //                nextPriceCent = weakSelf.partialDo.surplusPriceNum;
//            //            }
//            //            weakSelf.payPrice = nextPriceCent;
//            //            [weakSelf.partialView getPayingPrice:nextPriceCent];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeInputPrice" object:@(nextPriceCent)];
//            
//        }
//    }];
//}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"successPayOrder" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addPartialView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"payOrder" object:nil];
    
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    SearchMyGoodsViewController *viewController = [[SearchMyGoodsViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

-(void)clickBtn1:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn2:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn3:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn4:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn5:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn6:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(void)setUpUI{
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.topView.mas_left).offset(15);
    }];
    [self.btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn1.mas_right).offset(20);
    }];
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn6.mas_right).offset(20);
    }];
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn2.mas_right).offset(20);
    }];
    [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn3.mas_right).offset(20);
    }];
    [self.btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn4.mas_right).offset(20);
    }];
    NSLog(@"%f", self.btn1.left);
    self.bottonView.frame = CGRectMake(15, topViewHeight-2, self.btn1.width, 2);
    self.topView.contentSize = CGSizeMake(15+self.btn1.width+self.btn2.width+self.btn3.width+self.btn4.width+self.btn5.width+self.btn6.width+20*5, topViewHeight);
    [self.view setNeedsDisplay];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    BoughtCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    self.cell = cell;
    
    
    cell.boughtController.boughtCollectionVC = self;
    if (indexPath.item >= 2) {
        cell.boughtController.status = indexPath.item + 2;
    } else {
        cell.boughtController.status = indexPath.item + 1;
    }
    if (indexPath.item == 0) {
        cell.boughtController.status = 1;
        cell.boughtController.goonWithPayController = self.goonWithPayController;
        self.goonWithPayController = 0;
    } else if (indexPath.item == 1) {
        cell.boughtController.status = 7;
    } else if (indexPath.item == 2) {
        cell.boughtController.status = 2;
    } else if (indexPath.item == 3) {
        cell.boughtController.status = 4;
    } else if (indexPath.item == 4) {
        cell.boughtController.status = 6;
    } else if (indexPath.item == 5) {
        cell.boughtController.status = 5;
    }
    
    NSLog(@"%ld", cell.boughtController.status);
//    [cell.boughtController initDataListLogic];
    
    NSInteger Code;
    switch (indexPath.item) {
        case 0:
            if (self.type == 1) {
                [self client:BoughtAllViewCode];
                Code = BoughtAllViewCode;
            } else if (self.type == 2) {
                [self client:BoughtServeAllViewCode];
                Code = BoughtServeAllViewCode;
            }
            break;
        case 1:
            if (self.type == 1) {
                [self client:BoughtWaitOutGoodsViewCode];
                Code = BoughtWaitOutGoodsViewCode;
            } else if (self.type == 2) {
                [self client:BoughtServeWaitOutGoodsViewCode];
                Code = BoughtServeWaitOutGoodsViewCode;
            }
            break;
        case 2:
            if (self.type == 1) {
                [self client:BoughtWaitDetermineViewCode];
                Code = BoughtWaitDetermineViewCode;
            } else if (self.type == 2) {
                [self client:BoughtServeWaitServeViewCode];
                Code = BoughtServeWaitServeViewCode;
            }
            break;
        case 3:
            if (self.type == 1) {
                [self client:BoughtWaitPutGoodsViewCode];
                Code = BoughtWaitPutGoodsViewCode;
            } else if (self.type == 2) {
                [self client:BoughtServeWaitPutGoodsViewCode];
                Code = BoughtServeWaitPutGoodsViewCode;
            }
            break;
        case 4:
            if (self.type == 1) {
                [self client:BoughtCloseViewCode];
                Code = BoughtCloseViewCode;
            } else if (self.type == 2) {
                [self client:BoughtServeCloseViewCode];
                Code = BoughtServeCloseViewCode;
            }
            break;
        default:
            break;
    }
    cell.boughtController.viewCode = Code;
//    if (_isLuxuryGoods) {
//        cell.boughtController.type = 2;
//    } else {
//        cell.boughtController.type = 1;
//    }
    cell.boughtController.type = 3;
    
    [cell.boughtController initDataListLogic];
    return cell;
}

-(void)client:(NSInteger)regionCode{
        [ClientReportObject clientReportObjectWithViewCode:MineBoughtViewCode regionCode:regionCode referPageCode:regionCode andData:nil];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = (NSInteger)((scrollView.contentOffset.x / kScreenWidth + 1)*1000);
    UIButton *btn = [self.topView viewWithTag:index];
    
    if (self.topView.contentSize.width > kScreenWidth) {
        CGFloat offsetX = btn.center.x - kScreenWidth * 0.5;
        
        if (offsetX < 0) offsetX = 0;
        CGFloat maxOffsetX = self.topView.contentSize.width - kScreenWidth;
        
        if (offsetX > maxOffsetX) offsetX = maxOffsetX;
        [self.topView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < -100) {
        [self dismiss];
    }
    
    NSInteger index = (NSInteger)(scrollView.contentOffset.x / kScreenWidth + 1);
    NSString *className = [NSString stringWithFormat:@"btn%.ld", index];
    if ([className isEqualToString:@"btn1"]) {
        self.btn1.selected = YES;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.btn4.selected = NO;
        self.btn5.selected = NO;
        self.btn6.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            
            self.bottonView.frame = CGRectMake(15, topViewHeight-2, self.btn1.width, 2);
        }];
    } else if ([className isEqualToString:@"btn2"]) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.btn4.selected = NO;
        self.btn5.selected = NO;
        self.btn6.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width + 20 * 1, topViewHeight-2, self.btn2.width, 2);
        }];
    } else if ([className isEqualToString:@"btn3"]) {
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        self.btn3.selected = NO;
        self.btn4.selected = NO;
        self.btn5.selected = NO;
        self.btn6.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width + 20 * 2, topViewHeight-2, self.btn3.width, 2);
        }];
    } else if ([className isEqualToString:@"btn4"]) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = YES;
        self.btn4.selected = NO;
        self.btn5.selected = NO;
        self.btn6.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width + 20 * 3, topViewHeight-2, self.btn4.width, 2);
        }];
    } else if ([className isEqualToString:@"btn5"]) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.btn4.selected = YES;
        self.btn5.selected = NO;
        self.btn6.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width+self.btn4.width + 20 * 4, topViewHeight-2, self.btn5.width, 2);
        }];
    } else if ([className isEqualToString:@"btn6"]) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.btn4.selected = NO;
        self.btn5.selected = YES;
        self.btn6.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width+self.btn4.width+self.btn6.width + 20 * 5, topViewHeight-2, self.btn5.width, 2);
        }];
    }
}

-(void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld", indexPath.item);
    
}

//-(void)segmentSelected:(NSInteger)type{
//    switch (type) {
//        case 0:
//            self.type = 1;
//            //            [self initDataListLogic];
//            //            self.cell.boughtController.type = 1;
//            //            [self.cell.boughtController initDataListLogic];
//            [_btn3 setTitle:@"待收货" forState:UIControlStateNormal];
//            self.isLuxuryGoods = NO;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"setType" object:nil];
//            [self.collectionView reloadData];
//            break;
//        case 1:
//            self.type = 2;
//            //            [self initDataListLogic];
//            //            self.cell.boughtController.type = 2;
//            //            [self.cell.boughtController initDataListLogic];
//            [_btn3 setTitle:@"待服务" forState:UIControlStateNormal];
//            self.isLuxuryGoods = YES;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"setTypeTwo" object:nil];
//            [self.collectionView reloadData];
//            break;
//        default:
//            break;
//    }
//}
//
//-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
//    NSInteger Index = Seg.selectedSegmentIndex;
//    NSLog(@"Index %ld", Index);
//    switch (Index) {
//        case 0:
//            self.type = 1;
////            [self initDataListLogic];
////            self.cell.boughtController.type = 1;
////            [self.cell.boughtController initDataListLogic];
//            [_btn3 setTitle:@"待收货" forState:UIControlStateNormal];
//            self.isLuxuryGoods = NO;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"setType" object:nil];
//            [self.collectionView reloadData];
//            break;
//        case 1:
//            self.type = 2;
////            [self initDataListLogic];
////            self.cell.boughtController.type = 2;
////            [self.cell.boughtController initDataListLogic];
//            [_btn3 setTitle:@"待服务" forState:UIControlStateNormal];
//            self.isLuxuryGoods = YES;
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"setTypeTwo" object:nil];
//            [self.collectionView reloadData];
//            break;
//        default:
//            break;
//    }
//}

@end

@interface BoughtCollectionViewCell ()



@end

@implementation BoughtCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.boughtController = [[BoughtViewController alloc] init];
        [self.contentView addSubview:self.boughtController.view];
        
    }
    return self;
}

@end
