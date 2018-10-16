//
//  OfferedViewController.m
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OfferedViewController.h"
#import "PullRefreshTableView.h"
#import "PromptView.h"
#import "Masonry.h"
#import "NSDate+Category.h"
#import "BaseTableViewCell.h"

#import "OfferedTitleCell.h"
#import "OfferedSegCell.h"
#import "OfferedGoodsCell.h"
#import "OfferedDisplayCell.h"
#import "OfferedMoneyCell.h"
#import "OfferedRankCell.h"
#import "ForumPostTableViewCell.h"
#import "OfferedPromptCell.h"

#import "DigitalKeyboardView.h"
#import "ForumPostDetailViewController.h"
#import "PayViewController.h"
#import "LoginViewController.h"
#import "ShoppingCartItem.h"
#import "BoughtViewController.h"
#import "BoughtCollectionViewController.h"

#import "GoodsInfo.h"
#import "Session.h"
#import "DataListLogic.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "JSONKit.h"
#import "NSString+URLEncoding.h"

#import "GoodsMemCache.h"
#import "RecoveryGoodsDetail.h"
#import "NetworkManager.h"
#import "offeredTopImageCell.h"
#import "offeredUserInfoCell.h"
#import "offeredGoodsDetailCell.h"
#import "offeredGoodsInfoCell.h"
#import "InsureViewController.h"
#import "GuideView.h"


@interface OfferedViewController () <UITableViewDataSource, UITableViewDelegate> {
    dispatch_source_t timer;
}

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) PromptView *promrtView;
@property (nonatomic, strong) RecoveryGoodsVo *recoverGoodsVO;
@property (nonatomic, strong) HighestBidVo *bidVO;
@property (nonatomic, strong) HighestBidVo *authBidVO;
@property (nonatomic, strong) HighestBidVo *heightBidVO;
@property (nonatomic, strong) RecoveryGoodsDetail *goodsDetailVO;

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;

@property(nonatomic,strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) UIButton *rankBtn;

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *buyBtn;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) PayViewController *payViewController;
@property (nonatomic, assign) NSInteger goodsLockRemainTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) long long time;


//add code
@property (nonatomic, strong) UIView *topDateView;
@property (nonatomic, strong) UILabel *topLabelOne;
@property (nonatomic, strong) UILabel *toplabelTwo;
@property (nonatomic, strong) UILabel *topLabelThree;

@property (nonatomic, assign) long long date;

@property (nonatomic, strong) UIButton *lookPriceBtn;

@property (nonatomic, strong) NSDictionary *dict;
@end

@implementation OfferedViewController

//add code
- (UILabel *)topLabelOne {
    if (!_topLabelOne) {
        _topLabelOne = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLabelOne.backgroundColor = [UIColor colorWithHexString:@"c30d23"];
        _topLabelOne.textColor = [UIColor colorWithHexString:@"ffffff"];
        _topLabelOne.text = @"正在进行";
        _topLabelOne.font = [UIFont systemFontOfSize:13];
        _topLabelOne.textAlignment = NSTextAlignmentCenter;
    }
    return _topLabelOne;
}

- (UILabel *)toplabelTwo {
    if (!_toplabelTwo) {
        _toplabelTwo = [[UILabel alloc] initWithFrame:CGRectZero];
        _toplabelTwo.text = @"出价时间仅剩";
        _toplabelTwo.font = [UIFont systemFontOfSize:13];
        _toplabelTwo.textColor = [UIColor colorWithHexString:@"727171"];
        [_toplabelTwo sizeToFit];
    }
    return _toplabelTwo;
}

- (UILabel *)topLabelThree {
    if (!_topLabelThree) {
        _topLabelThree = [[UILabel alloc] initWithFrame:CGRectZero];
        _topLabelThree.textColor = [UIColor colorWithHexString:@"c30d23"];
        _topLabelThree.text = @"10小时5分59秒";
        _topLabelThree.font = [UIFont systemFontOfSize:13];
        [_topLabelThree sizeToFit];
    }
    return _topLabelThree;
}

- (UIView *)topDateView {
    if (!_topDateView) {
        _topDateView = [[UIView alloc] initWithFrame:CGRectZero];
        
        _topDateView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        _topDateView.alpha = 0.9;
//        _topDateView.backgroundColor = [UIColor blackColor];
    }
    return _topDateView;
}



//============================

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}

-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:15.f];
        _timeLabel.textColor = [UIColor colorWithHexString:@"e73828"];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        [_timeLabel sizeToFit];
    }
    return _timeLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"d9d9da"];
    }
    return _lineView;
}

-(UIButton *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
        _buyBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_buyBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _buyBtn.backgroundColor = [UIColor colorWithHexString:@"c30d23"];
        [_buyBtn sizeToFit];
    }
    return _buyBtn;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(UIButton *)rankBtn{
    if (!_rankBtn) {
        _rankBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _rankBtn.backgroundColor = [UIColor colorWithHexString:@"c30d23"];
        [_rankBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rankBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _rankBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _rankBtn.userInteractionEnabled = YES;
        [_rankBtn setTitle:@"出价" forState:UIControlStateNormal];
    }
    return _rankBtn;
}

- (UIButton *)lookPriceBtn {
    if (!_lookPriceBtn) {
        _lookPriceBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _lookPriceBtn.backgroundColor = [UIColor colorWithHexString:@"c30d23"];//e83828
        [_lookPriceBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _lookPriceBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _lookPriceBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_lookPriceBtn setTitle:@"查看报价" forState:UIControlStateNormal];
    }
    return _lookPriceBtn;
}


-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self showLoadingView];
    [self firstLoad];

}

- (void)firstLoad {
    NetworkAPI *net = [NetworkAPI sharedInstance];
//    WEAKSELF;
    WEAKSELF;
    [[NetworkManager sharedInstance] addRequest:[net getRecoverGoodsDetail:self.goodID completion:^(NSDictionary *dict) {
        //        NSLog(@"first dict+++goodsDetailVO+++:%@", dict);
        
        
        NSLog(@"dict=========:%@", dict);
        
        RecoveryGoodsDetail *goodsDetailVO = [[RecoveryGoodsDetail alloc] initWithJSONDictionary:dict];
        weakSelf.goodsDetailVO = goodsDetailVO;
        
        HighestBidVo *heightBidVO = [[HighestBidVo alloc] initWithJSONDictionary:dict[@"highestBidVo"]];
        weakSelf.heightBidVO = heightBidVO;
        //        NSLog(@"authBidVo:%@", goodsDetailVO.authBidVo);
        
        self.dict = [NSDictionary dictionaryWithDictionary:dict];
        [self getExprtime:goodsDetailVO.recoveryGoodsVo andAuthBidVO:goodsDetailVO.authBidVo];
        
        
        //add here
        [super setupTopBar];
//        if (!self.authBidVO) {
//            [super setupTopBarTitle:@"确认出价"];
//        } else {
//            [super setupTopBarTitle:@"立即下单"];
//        }
        [super setupTopBarTitle:@"商品详情"];
        
        [super setupTopBarBackButton];
        [super setupTopBarRightButton:[UIImage imageNamed:@"Insure_rigth_btn_MF"] imgPressed:nil];
        
        self.tableView.enableLoadingMore = NO;
        self.tableView.enableRefreshing = NO;
        self.tableView.separatorStyle = NO;
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.topLabelOne];
        [self.view addSubview:self.topDateView];
        
        [self.view addSubview:self.toplabelTwo];
        [self.view addSubview:self.topLabelThree];
        
        //add code
        self.date = self.goodsDetailVO.recoveryGoodsVo.leftMilTime / 1000;
        if (self.goodsDetailVO.recoveryGoodsVo.status == 1) {
            //商品没下架
            NSString *dateStr = [NSString stringWithFormat:@"%lld小时%lld分%lld秒", (self.date / 60 / 60) % 24, (self.date / 60) % 60, self.date % 60];
            self.topLabelThree.text = dateStr;
            
            if (self.date <= 0) {
                self.topLabelOne.text = @"已结束";
                self.topLabelOne.backgroundColor = [UIColor grayColor];
            } else {
                [self clock];
            }
        } else {
            self.date = 0;
            self.topLabelOne.text = @"已结束";
            self.topLabelOne.backgroundColor = [UIColor grayColor];
            self.topLabelThree.text = @"0小时0分0秒";
        }
        
        
        [self loadData];
        
        
//        [weakSelf showLoadingView];
//        [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getRecoverGoodsDetail:self.goodID completion:^(NSDictionary *dict) {
            [weakSelf hideLoadingView];
            if (dict) {
                
                //                NSLog(@"second dict===goodsVO, authBidVO:%@", dict);
                
                RecoveryGoodsVo *goodsVO = [[RecoveryGoodsVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"recoveryGoodsVo"]];
                HighestBidVo *authBidVO = [[HighestBidVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"authBidVo"]];
                weakSelf.recoverGoodsVO = goodsVO;
                weakSelf.authBidVO = authBidVO;
                
                if (weakSelf.goodsDetailVO.recoveryGoodsVo.sellerBasicInfo.user_id == [Session sharedInstance].currentUserId) {
                    [weakSelf.view addSubview:weakSelf.lookPriceBtn];
                    [weakSelf.lookPriceBtn addTarget:weakSelf action:@selector(clickLookPriceBtn) forControlEvents:UIControlEventTouchUpInside];
                    
//                    [weakSelf setUpUI];
//                    [weakSelf loadCell];
                    
                } else {
                    if (weakSelf.authBidVO.userId == [Session sharedInstance].currentUserId) {
                        
                        if (authBidVO.orderId && authBidVO.isAuth) {
                            [weakSelf.buyBtn setTitle:@"去付款" forState:UIControlStateNormal];
                        } else {
                            [weakSelf.buyBtn setTitle:@"立即下单" forState:UIControlStateNormal];
                        }
                        
                        [weakSelf.view addSubview:weakSelf.bottomView];
                        [weakSelf.bottomView addSubview:weakSelf.lineView];
                        [weakSelf.bottomView addSubview:weakSelf.buyBtn];
                        [weakSelf.bottomView addSubview:weakSelf.timeLabel];
                        [weakSelf.buyBtn addTarget:weakSelf action:@selector(clickBuyBtn) forControlEvents:UIControlEventTouchUpInside];
                        weakSelf.rankBtn.hidden = YES;
                        weakSelf.bottomView.hidden = NO;
                        if (authBidVO.payId) {
                            weakSelf.bottomView.hidden = YES;
//                            weakSelf.tableView.frame = CGRectMake(0, weakSelf.topBarHeight, kScreenWidth, kScreenHeight - weakSelf.topBarHeight);
                            
                            
                            
                        } else {
                            weakSelf.bottomView.hidden = NO;
//                            weakSelf.tableView.frame = CGRectMake(0, weakSelf.topBarHeight, kScreenWidth, kScreenHeight - weakSelf.topBarHeight - weakSelf.bottomView.height);
                        }
                    } else {
                        [weakSelf.view addSubview:weakSelf.rankBtn];
                        weakSelf.rankBtn.hidden = NO;
                        weakSelf.bottomView.hidden = YES;
                    }
                    [weakSelf setUpUI];
                    [weakSelf loadCell];
                    [weakSelf.rankBtn addTarget:weakSelf action:@selector(clickRankBtn) forControlEvents:UIControlEventTouchUpInside];
                    
//                    if (weakSelf.bidVO.price > 0) {
//                        [weakSelf.rankBtn setTitle:@"继续出价" forState:UIControlStateNormal];
//                    } else {
//                        [weakSelf.rankBtn setTitle:@"出价" forState:UIControlStateNormal];
//                    }
                    
                    
                    if (weakSelf.date <= 0 || self.goodsDetailVO.recoveryGoodsVo.status != 1) {
                        weakSelf.rankBtn.backgroundColor = [UIColor grayColor];
                    }
                    
                }
                
                
            }
        
            
            
            [[NetworkManager sharedInstance] addRequest:[net getBidDetail:self.goodID completion:^(NSDictionary *data) {
//                NSLog(@"dict:%@", data);
                
                HighestBidVo *bidVO = [[HighestBidVo alloc] initWithJSONDictionary:data[@"get_bid_detail"]];

                weakSelf.bidVO = bidVO;
                if (weakSelf.bidVO.price > 0) {
                    [weakSelf.rankBtn setTitle:@"继续出价" forState:UIControlStateNormal];
                } else {
                    [weakSelf.rankBtn setTitle:@"出价" forState:UIControlStateNormal];
                }
                
                weakSelf.goodsDetailVO.highestBidVo = bidVO;
                [weakSelf setUpUI];
                [weakSelf loadCell];
                
                [weakSelf.tableView reloadData];
            } failure:^(XMError *error) {
                
            }]];
            
            
//            [weakSelf.tableView reloadData];
            //
//        } failure:^(XMError *error) {
//            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//        }]];
        
        weakSelf.timer;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMissBackView) name:@"dissMissBackView" object:nil];
        
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:error.errorMsg hideAfterDelay:0.8];
    }]];

}

//启动计时
- (void)clock {
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        if (self.date <= 0) {
            dispatch_source_cancel(timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.topLabelOne.text = @"已结束";
                self.topLabelOne.backgroundColor = [UIColor grayColor];
                self.topLabelThree.text = @"0小时0分0秒";
                
                self.rankBtn.backgroundColor = [UIColor grayColor];
                
//                NSLog(@"0");
            });
        } else {
//            NSLog(@"1");
            NSString *dateStr = [NSString stringWithFormat:@"%lld小时%lld分%lld秒", (self.date / 60 / 60) % 24, (self.date / 60) % 60, self.date % 60];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.topLabelThree.text = dateStr;
            });

        }
        self.date = self.date - 1;
    });
//    dispatch_source_cancel(timer);
//    if (timer) {
//        
//    }
    dispatch_resume(timer);
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    
}

-(void)timerFired:(NSTimer *)timer{
    if (self.goodsLockRemainTime == 0) {
//        NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.time/1000];
//        NSInteger time = [date minute] * 60;
        NSInteger time = self.time / 1000;
        self.goodsLockRemainTime = time;
    } else {
        self.goodsLockRemainTime -= 1;
//        self.time = self.goodsLockRemainTime * 1000;
    }
    NSLog(@"---%lld", self.time);
    NSLog(@"%ld", self.goodsLockRemainTime);
    //    NSLog(@"%lld", self.time);
    
    self.timeLabel.text = [self remainTimeString];
    if (self.goodsLockRemainTime == 0) {
        [self.timer invalidate];
        [self loadData];
        [self.tableView reloadData];
////        self.rankBtn.hidden = NO;
        self.timeLabel.text = @"授权超时，请等待再次授权";
        self.buyBtn.userInteractionEnabled = NO;
        self.buyBtn.backgroundColor = [UIColor lightGrayColor];
        [self.view setNeedsDisplay];
        
        
//        self.buyBtn.hidden = YES;
//        self.timeLabel.hidden = YES;
//        
//        [self.view addSubview:self.rankBtn];
//        [self.view setNeedsDisplay];
//
//        self.rankBtn.hidden = NO;
//        self.bottomView.hidden = YES;
//        
//        [self setUpUI];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self.timer fire];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

- (NSString*)remainTimeString {
    long min = (long)_goodsLockRemainTime/60;
    long sec = (long)_goodsLockRemainTime%60;
    //    NSLog(@"%ld-------%ld--------%ld", min, sec, self.goodsLockRemainTime);
    
    NSMutableString *minString = nil;
    if (min<10) {
        minString = [NSMutableString stringWithFormat:@"0%ld分",min];
    } else {
        minString = [NSMutableString stringWithFormat:@"%ld分",min];
    }
    NSMutableString *secString = nil;
    if (sec<10) {
        secString = [NSMutableString stringWithFormat:@"0%ld秒",sec];
    } else {
        secString = [NSMutableString stringWithFormat:@"%ld秒",sec];
    }
    return [NSString stringWithFormat:@"%@%@",minString,secString];
}

-(void)clickBuyBtn{
    
    if (_authBidVO.orderId && _authBidVO.isAuth) {
        
        BoughtCollectionViewController *boughtCollectionView = [[BoughtCollectionViewController alloc] init];
        [self pushViewController:boughtCollectionView animated:YES];
        
    } else {
        
        MainPic *mainPic = self.recoverGoodsVO.mainPic;
        GoodsInfo *goodsInfo = [[GoodsInfo alloc] init];
        goodsInfo.goodsId = self.goodID;
        goodsInfo.goodsName = self.recoverGoodsVO.goodsName;
        goodsInfo.thumbUrl = mainPic.pic_url;
        goodsInfo.shopPriceCent = self.authBidVO.price * 100;
        if ([[Session sharedInstance] isLoggedIn]) {
            PayViewController *payViewController = [[PayViewController alloc] init];
            self.payViewController = payViewController;
            NSMutableArray *items = [[NSMutableArray alloc] init];
            [items addObject:[ShoppingCartItem createWithGoodsInfo:goodsInfo]];
            
            payViewController = [[PayViewController alloc] init];
            payViewController.items = items;
            WEAKSELF;
            payViewController.handlePayDidFnishBlock = ^(BaseViewController *payViewControllerParam, NSInteger index) {
                [weakSelf.payViewController dismiss:NO];
                weakSelf.payViewController.handlePayDidFnishBlock = nil;
                weakSelf.payViewController = nil;
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    UIViewController *currentVC = [CoordinatingController sharedInstance].visibleController;
                    if (![currentVC isKindOfClass:[BoughtCollectionViewController class]]) {
                        BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
                        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                    }
                });
                
            };
            payViewController.index = 100;
            [self pushViewController:payViewController animated:YES];
            
        } else {
            LoginViewController *viewController = [[LoginViewController alloc] init];
            viewController.title = @"登录";
            UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
            [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{
                
            }];
        }
    }
}

-(void)clickRankBtn{
    if (self.date <= 0 || self.goodsDetailVO.recoveryGoodsVo.status != 1) {
//        self.rankBtn.backgroundColor = [UIColor grayColor];
        return;
    }
    
//    dispatch_source_cancel(timer);
    WEAKSELF;
    ForumQuoteInputView *inputView = [[ForumQuoteInputView alloc] initWithFrame:CGRectZero];
    [DigitalKeyboardView showInViewMF:self.view inputContainerView:inputView textFieldArray:[NSArray arrayWithObjects:inputView.textFiled, nil] completion:^(DigitalInputContainerView *inputContainerView) {
        inputView.index = 1;
        CGFloat priceCent = [((ForumQuoteInputView*)inputContainerView) priceCent];
        CGFloat nextPriceCent = priceCent / 100;
        if (nextPriceCent >0) {
            
            [weakSelf showProcessingHUD:nil];
            [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getBid:self.goodID andbid_price:nextPriceCent completion:^(NSDictionary *data) {
                
//                NSDictionary *dict = data[@"bid"];
//                
//                NSLog(@"bid dict:%@", dict);
//                
//                [weakSelf showHUD:@"报价成功" hideAfterDelay:1.f];
//                weakSelf.goodsDetailVO.highestBidVo.price = nextPriceCent;
//                weakSelf.goodsDetailVO.highestBidVo.level = [[dict objectForKey:@"level"] integerValue];
                
                
                [weakSelf loadData];
//                [weakSelf.tableView reloadData];
                
                if ([weakSelf.rankBtn.titleLabel.text isEqualToString:@"出价"]) {
                    [self.rankBtn setTitle:@"继续出价" forState:UIControlStateNormal];
//                    weakSelf.goodsDetailVO.total_bid_num ++;
                }
//                [weakSelf.tableView reloadData];
                [weakSelf firstLoad];
                
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }]];
        }
    }];
}

- (void)clickLookPriceBtn {
    NSLog(@"查看报价");
    InsureViewController *insureViewController = [[InsureViewController alloc] init];
    insureViewController.goodsID = self.goodsDetailVO.recoveryGoodsVo.goodsSn;
    insureViewController.index = 1;
    [self pushViewController:insureViewController animated:YES];
    
}

-(void)loadData{
    if (self.goodID) {
        WEAKSELF;
//        [weakSelf showLoadingView];
        [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getBidDetail:self.goodID completion:^(NSDictionary *data) {
//            [weakSelf hideLoadingView];
            if (data) {
                
//                NSLog(@"getBidDetail=====bidVO:%@", [data dictionaryValueForKey:@"get_bid_detail"]);
                
                HighestBidVo *bidVO = [[HighestBidVo alloc] initWithJSONDictionary:[data dictionaryValueForKey:@"get_bid_detail"]];
                self.bidVO = bidVO;
                self.time = bidVO.authExpTime;
                [self.tableView reloadData];
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    if (weakSelf.dataListLogic) {
//                        [weakSelf.dataListLogic reloadDataListByForce];
//                    } else {
//                        [weakSelf initDataListLogic];
//                    }
//                });
            }
        } failure:^(XMError *error) {
            weakSelf.tableView.pullTableIsRefreshing = NO;
            [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
                [weakSelf loadData];
            };
        }]];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
//    NSLog(@"reuseIdentifier:%@", reuseIdentifier);
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([tableViewCell isKindOfClass:[offeredTopImageCell class]]) {
        offeredTopImageCell *topImageCell = (offeredTopImageCell *)tableViewCell;
        [topImageCell updateCellWithDict:self.recoverGoodsVO];
    }
    
    if ([tableViewCell isKindOfClass:[offeredUserInfoCell class]]) {
        offeredUserInfoCell *userInfoCell = (offeredUserInfoCell *)tableViewCell;
        [userInfoCell updateCellWithDict:self.recoverGoodsVO];
    }
    
    if ([tableViewCell isKindOfClass:[offeredGoodsDetailCell class]]) {
        offeredGoodsDetailCell *goodsDetailCell = (offeredGoodsDetailCell *)tableViewCell;
        [goodsDetailCell updateCellWithDict:self.recoverGoodsVO];
    }
    
    if ([tableViewCell isKindOfClass:[offeredGoodsInfoCell class]]) {
        offeredGoodsInfoCell *goodsInfoCell = (offeredGoodsInfoCell *)tableViewCell;
        [goodsInfoCell updateCellWithDict:self.goodsDetailVO andDict:self.dict];
    }
    
    if ([tableViewCell isKindOfClass:[OfferedTitleCell class]]) {
        OfferedTitleCell *titleTableViewCell = (OfferedTitleCell *)tableViewCell;
        [titleTableViewCell updateCellWithDict:self.recoverGoodsVO];
        SellerBasicInfo *basicInfo = self.recoverGoodsVO.sellerBasicInfo;
        WEAKSELF;
        titleTableViewCell.handleIcon = ^(){
            [UserSingletonCommand chatRecoverWithUser:basicInfo.user_id andIsYes:2 andGoodsVO:weakSelf.recoverGoodsVO andBidVO:nil];
        };
        
    }
    
    else if ([tableViewCell isKindOfClass:[OfferedGoodsCell class]]) {
        OfferedGoodsCell *goodsCell = (OfferedGoodsCell *)tableViewCell;
        [goodsCell updateCellWithDict:self.recoverGoodsVO];
    }
    
    else if ([tableViewCell isKindOfClass:[OfferedDisplayCell class]]) {
        OfferedDisplayCell *displayCell = (OfferedDisplayCell *)tableViewCell;
        [displayCell updateCellWithDict:self.bidVO];
    }
    
    else if ([tableViewCell isKindOfClass:[OfferedMoneyCell class]]) {
        OfferedMoneyCell *moneyCell = (OfferedMoneyCell *)tableViewCell;
        [moneyCell updateCellWithDict:self.bidVO];
    }
    
    else if ([tableViewCell isKindOfClass:[OfferedRankCell class]]) {
        OfferedRankCell *rankCell = (OfferedRankCell *)tableViewCell;
        [rankCell updateCellWithDict:self.bidVO];
    }
    
    else if ([tableViewCell isKindOfClass:[OfferedPromptCell class]]) {
        OfferedPromptCell *proCell = (OfferedPromptCell *)tableViewCell;
        [proCell updateCellWithDict:dict];
    }
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [self loadData];
}
//刷新的问题
-(void)initDataListLogic{
    WEAKSELF;
    NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
    if (self.bidVO) {
        [paramsArray addObject:self.bidVO];
    }
    NSString *paramsJsonData = [[[paramsArray toJSONArray] JSONString] URLEncodedString];
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"recovery" path:@"get_bid_detail" pageSize:20];
    _dataListLogic.parameters = @{@"params":paramsJsonData,@"goods_sn":self.goodID};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            NSDictionary *dict = [weakSelf.dataSources objectAtIndex:5];
            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
//            if (ClsTableViewCell!=[ForumPostListNoContentTableCell class]) {
                weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
//            }
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        [weakSelf.tableView reloadData];
    };
    
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };

    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    if ([weakSelf.dataSources count]==0) {
        [weakSelf showLoadingView].backgroundColor = [UIColor clearColor];
    }
    [_dataListLogic firstLoadFromCache];
}

-(void)loadCell{
    if (self.dataSources.count > 0) {
        [self.dataSources removeAllObjects];
    }
    [self.dataSources addObject:[offeredTopImageCell buildCellDict:self.recoverGoodsVO]];
//    [self.dataSources addObject:[offeredUserInfoCell buildCellDict:self.recoverGoodsVO]];
    [self.dataSources addObject:[OfferedTitleCell buildCellDict:self.recoverGoodsVO]];
    [self.dataSources addObject:[offeredGoodsDetailCell buildCellDict:self.recoverGoodsVO]];
    [self.dataSources addObject:[OfferedSegCell buildCellDict]];
    [self.dataSources addObject:[offeredGoodsInfoCell buildCellDict:self.goodsDetailVO]];
    
    
//    [self.dataSources addObject:[OfferedTitleCell buildCellDict:self.recoverGoodsVO]];
//    [self.dataSources addObject:[OfferedSegCell buildCellDict]];
//    [self.dataSources addObject:[OfferedGoodsCell buildCellDict:self.recoverGoodsVO]];
//    [self.dataSources addObject:[OfferedSegCell buildCellDict]];
    //
//    [self.dataSources addObject:[OfferedDisplayCell buildCellDict:self.bidVO]];
//    [self.dataSources addObject:[OfferedMoneyCell buildCellDict:self.bidVO]];
//    [self.dataSources addObject:[OfferedRankCell buildCellDict:self.bidVO]];
    //
    if (self.authBidVO.userId == [Session sharedInstance].currentUserId) {
        if (self.authBidVO.payId) {
            
        } else {
            
            [self.dataSources addObject:[OfferedPromptCell buildCellDict:self.recoverGoodsVO]];
        }
        
        
    }
}

-(void)setUpUI{
    
    
    //
    [self.topLabelOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tableView.mas_left);
        make.top.equalTo(self.tableView.mas_top);
        make.height.equalTo(@38);
        make.width.equalTo(@(kScreenWidth / 3.));
    }];
    
    [self.topDateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topLabelOne.mas_right);
        //这里以tableview设置宽度为0
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.tableView.mas_top);
        make.height.equalTo(self.topLabelOne.mas_height);
    }];
    
    [self.topLabelThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topDateView.mas_right).offset(-18);
        make.bottom.equalTo(self.topDateView.mas_bottom).offset(-12);
    }];
    
    [self.toplabelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topLabelThree.mas_left).offset(-13);
        make.bottom.equalTo(self.topLabelThree.mas_bottom);
    }];

    if (self.goodsDetailVO.recoveryGoodsVo.sellerBasicInfo.user_id == [Session sharedInstance].currentUserId) {
        [self.lookPriceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
            make.left.equalTo(self.view.mas_left).offset(15);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.height.equalTo(@38);
        }];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topBar.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-58);
        }];
    } else {
        if (self.authBidVO.userId == [Session sharedInstance].currentUserId) {
            
            if (self.authBidVO.payId) {
                [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.topBar.mas_bottom);
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.bottom.equalTo(self.view.mas_bottom);
                }];
            } else {
                [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.topBar.mas_bottom);
                    make.left.equalTo(self.view.mas_left);
                    make.right.equalTo(self.view.mas_right);
                    make.bottom.equalTo(self.view.mas_bottom).offset(-58);
                }];
            }
            
            [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom);
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.height.equalTo(@58);
            }];
            
            [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.bottomView.mas_top);
                make.left.equalTo(self.bottomView.mas_left);
                make.right.equalTo(self.bottomView.mas_right);
                make.height.equalTo(@1);
            }];
            
            [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lineView.mas_bottom);
                make.right.equalTo(self.bottomView.mas_right);
                make.bottom.equalTo(self.bottomView.mas_bottom);
                make.width.equalTo(@137);
            }];
            
            [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.lineView.mas_bottom);
                make.left.equalTo(self.bottomView.mas_left);
                make.bottom.equalTo(self.bottomView.mas_bottom);
                make.right.equalTo(self.buyBtn.mas_left);
            }];
            
        } else {
            
            [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.topBar.mas_bottom);
                make.left.equalTo(self.view.mas_left);
                make.right.equalTo(self.view.mas_right);
                make.bottom.equalTo(self.view.mas_bottom).offset(-58);
            }];
            
            [self.rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(self.view.mas_bottom).offset(-20);
                make.left.equalTo(self.view.mas_left).offset(15);
                make.right.equalTo(self.view.mas_right).offset(-15);
                make.height.equalTo(@38);
            }];
        }
    }
    
//    if (self.authBidVO.userId == [Session sharedInstance].currentUserId) {
//        
//        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topBar.mas_bottom);
//            make.left.equalTo(self.view.mas_left);
//            make.right.equalTo(self.view.mas_right);
//            make.bottom.equalTo(self.view.mas_bottom).offset(-58);
//        }];
//        
//        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view.mas_bottom);
//            make.left.equalTo(self.view.mas_left);
//            make.right.equalTo(self.view.mas_right);
//            make.height.equalTo(@58);
//        }];
//        
//        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.bottomView.mas_top);
//            make.left.equalTo(self.bottomView.mas_left);
//            make.right.equalTo(self.bottomView.mas_right);
//            make.height.equalTo(@1);
//        }];
//        
//        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView.mas_bottom);
//            make.right.equalTo(self.bottomView.mas_right);
//            make.bottom.equalTo(self.bottomView.mas_bottom);
//            make.width.equalTo(@137);
//        }];
//        
//        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.lineView.mas_bottom);
//            make.left.equalTo(self.bottomView.mas_left);
//            make.bottom.equalTo(self.bottomView.mas_bottom);
//            make.right.equalTo(self.buyBtn.mas_left);
//        }];
//        
//    } else {
//        
//        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topBar.mas_bottom);
//            make.left.equalTo(self.view.mas_left);
//            make.right.equalTo(self.view.mas_right);
//            make.bottom.equalTo(self.view.mas_bottom).offset(-38);
//        }];
//        
//        [self.rankBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.view.mas_bottom).offset(-20);
//            make.left.equalTo(self.view.mas_left).offset(15);
//            make.right.equalTo(self.view.mas_right).offset(-15);
//            make.height.equalTo(@38);
//        }];
//        
//        
//        
//    }
}

-(void)getExprtime:(RecoveryGoodsVo *)recoverGoodsVO andAuthBidVO:(HighestBidVo *)authBidVO{
    self.recoverGoodsVO = recoverGoodsVO;
    self.authBidVO = authBidVO;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.timer invalidate];
}

-(void)dissMissBackView{
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.25 animations:^{
        self.promrtView.alpha = 0;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.promrtView removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0;
    [self.view addSubview:self.backView];
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0.7;
    } completion:^(BOOL finished) {
        nil;
    }];
    
    if (!self.promrtView) {
        self.promrtView = [[PromptView alloc] init];
    }
    self.promrtView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.promrtView];
    
    UIImageView *promrtImageView = [[UIImageView alloc] init];
    promrtImageView.image = [UIImage imageNamed:@"promrt_MF"];
    [self.promrtView addSubview:promrtImageView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor colorWithHexString:@"595757"];
    [textLabel sizeToFit];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.recoverGoodsVO.exprTime/1000];
    NSString *time = [NSString stringWithFormat:@"%ld", [date minute]];
    textLabel.text = [NSString stringWithFormat:@"每次出价即可刷新您的出价排位，\n"
                      "也可以实时下拉页面刷新。\n\n"
                      "排行前五的出价会直接呈现给卖家，\n"
                      "排行第六及以后的出价需要卖家点击更多后可见。\n"
                      "排行第一的价格会着重展示。\n\n"
                      "如果卖家相中您，会授权您购买，\n"
                      "您被授权购买后，有%@分钟的独家拍下的权限，超时未拍下，便会取消您的下单权限。\n", time];
    
    [promrtImageView addSubview:textLabel];
    
    UIButton *dissBtn = [[UIButton alloc] init];
    [dissBtn setImage:[UIImage imageNamed:@"dissMiss_Recocer_MF"] forState:UIControlStateNormal];
    [promrtImageView addSubview:dissBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"出价小知识";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:17.f];
    [titleLabel sizeToFit];
    [promrtImageView addSubview:titleLabel];
    
    [self.promrtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.centerY.equalTo(self.view.mas_centerY);
//        make.height.equalTo(textLabel.mas_height).offset(115);
    }];
    
    [promrtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.promrtView);
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promrtImageView.mas_top).offset(75);
        make.left.equalTo(promrtImageView.mas_left).offset(15);
        make.right.equalTo(promrtImageView.mas_right).offset(-15);
        make.bottom.equalTo(promrtImageView.mas_bottom).offset(-35);
    }];
    
    [dissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promrtImageView.mas_top).offset(5);
        make.right.equalTo(promrtImageView.mas_right).offset(-15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(promrtImageView.mas_centerX);
        make.top.equalTo(promrtImageView.mas_top).offset(11);
    }];
    
    self.promrtView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.promrtView.alpha = 1;
    }];
}

@end
