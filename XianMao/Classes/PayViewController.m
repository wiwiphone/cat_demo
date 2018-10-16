//
//  PayViewController.m
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "PayViewController.h"
#import "PayTableViewCell.h"

#import "DataSources.h"

#import "PlaceHolderTextView.h"

#import "UserAddressViewController.h"

#import "ShoppingCartItem.h"
#import "AddressInfo.h"
#import "Session.h"
#import "NetworkAPI.h"

#import <CoreText/CoreText.h>
#import <CoreText/CTFont.h>

#import "PayManager.h"

#import "BonusTableViewCell.h"
#import "BonusInfo.h"
#import "UPPayPlugin.h"

#import "GoodsInfo.h"
#import "UserService.h"
#import "TradeService.h"

#import "FenQiLePayViewController.h"
#import "WCAlertView.h"
#import "TTTAttributedLabel.h"

#import "Wallet.h"
#import "BonusListViewController.h"

#import "BoughtViewController.h"
#import "AuthService.h"
#import "URLScheme.h"
#import "UIActionSheet+Blocks.h"

#import "SepTableViewCell.h"
#import "WristwatchRecoveryDetailCell.h"
#import "WristWhiteRecovertCell.h"
#import "BlackView.h"
#import "WristView.h"
#import "Masonry.h"
#import "OrderSmallLineCell.h"
#import "BuyBackCell.h"
#import "Masonry.h"
#import "PartialView.h"
#import "PartialPayWayView.h"

#import "ForumPostDetailViewController.h"
#import "DigitalKeyboardView.h"
#import "WebViewController.h"

#import "WalletTwoViewController.h"
#import "ShoppingCartTableViewCell.h"
#import "EvaluateView.h"

#import "SuccessfulPayViewController.h"
#import "BonusNewNewTableViewCell.h"

#import "PayXiHuCardViewController.h"
#import "AccountCard.h"
#import "WashGoodsChooseCell.h"
#import "PayDetermineView.h"
#import "PayGoodsBasicInformation.h"
#import "OrderServiceCell.h"
#import "PayMiaozuanDeductCell.h"
#import "PayPromptCell.h"

#import "MeowReduceVo.h"
#import "JDServiceVo.h"
#define kPayBottomBarHeight 59.f
#define kMode_Development             @"01"

@interface PayViewController () <UITableViewDataSource,UITableViewDelegate,UserAddressChangedReceiver,PayResultReceiver,
EditAddressViewControllerDelegate,UPPayPluginDelegate, WristwatchRecoveryCellDelegate, WristViewDelegate,PayTableFooterViewDelegate>

@property(nonatomic,weak) UITableView *tableView;
@property(nonatomic,weak) PayTableHeaderView* headerView;
@property(nonatomic,weak) PayTableFooterView *footerView;
@property(nonatomic,strong) UIImageView *bottomView;

@property(nonatomic,strong) NSMutableArray *dataSources;

@property(nonatomic,strong) HTTPRequest *request;
@property(nonatomic,strong) NSMutableArray *addressList;
@property(nonatomic,assign) NSInteger selectedAddressId;
@property (nonatomic, assign) NSInteger chooseBtnIndex;
@property (nonatomic, assign) NSInteger agreeBtnIndex;

@property(nonatomic,strong) HTTPRequest *requestListBonus;

@property(nonatomic,strong) NSArray *payWays;

@property(nonatomic,strong) NSArray *quanItemsArray;
@property (nonatomic, strong) NSArray *xiHuCardArray;

@property(nonatomic,strong) BonusInfo *seletedBonusInfo;
@property (nonatomic, strong) AccountCard *selectedAccountCard;

@property(nonatomic,assign) NSInteger reward_money_cent;
@property(nonatomic,assign) NSInteger available_money_cent;

@property(nonatomic,assign) BOOL is_used_reward_money;
@property(nonatomic,assign) BOOL is_used_adm_money;

@property (nonatomic,assign) PayWayType payway;

@property (nonatomic, assign) NSInteger is_need_appraisal;

@property (nonatomic, strong) BlackView *blackView;
@property (nonatomic, strong) WristView *wristView;
@property (nonatomic, copy) NSString *wristContentText;

@property (nonatomic, strong) PartialView *partialView;
@property (nonatomic, strong) BlackView *partialBgView;
@property (nonatomic, strong) ParyialDo *partialDo;
@property (nonatomic, strong) PartialPayWayView *partialPayWayView;
@property (nonatomic, assign) CGFloat payPrice;
@property (nonatomic, strong) AddressInfo * addressInfo;
@property (nonatomic, assign) NSInteger isUserWash;
@property (nonatomic, assign) NSInteger deterSelected;

@property (nonatomic, strong) NSDictionary *goodsDict;

@property (nonatomic, assign) NSInteger isFirst;
@end

@implementation PayViewController

-(NSDictionary *)goodsDict{
    if (!_goodsDict) {
        _goodsDict = [[NSDictionary alloc] init];
    }
    return _goodsDict;
}

-(NSArray *)xiHuCardArray{
    if (!_xiHuCardArray) {
        _xiHuCardArray = [[NSArray alloc] init];
    }
    return _xiHuCardArray;
}

-(PartialPayWayView *)partialPayWayView{
    if (!_partialPayWayView) {
        _partialPayWayView = [[PartialPayWayView alloc] initWithFrame:CGRectZero];
        _partialPayWayView.backgroundColor = [UIColor whiteColor];
    }
    return _partialPayWayView;
}

-(ParyialDo *)partialDo{
    if (!_partialDo) {
        _partialDo = [[ParyialDo alloc] init];
    }
    return _partialDo;
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

-(WristView *)wristView{
    if (!_wristView) {
        _wristView = [[WristView alloc] initWithFrame:CGRectZero];
        _wristView.backgroundColor = [UIColor whiteColor];
        _wristView.wristDissDelegate = self;
    }
    return _wristView;
}

-(BlackView *)blackView{
    if (!_blackView) {
        _blackView = [[BlackView alloc] initWithFrame:self.view.bounds];
    }
    return _blackView;
}

- (void)dealloc
{
    _handlePayDidFnishBlock = nil;
    _request = nil;
    _requestListBonus = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showXihuIcon" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"judgeChooseBtn" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"judge" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"messageEndEdit" object:nil];
}

- (id)init {
    self = [super init];
    if (self) {
        _reward_money_cent = 0;
        _available_money_cent = 0;
        _is_used_reward_money = YES;
        _is_used_adm_money = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
//    [super setupTopBarTitle:@"付款"];
    [super setupTopBarTitle:@"确认订单"];
    [super setupTopBarBackButton];
    
    self.wristContentText = @"1.原价回收商品支持48小时无理由退货，在不影响第二次销售的情况下，原附件齐全，并无任何损坏，方可退货。\n\n"
    "2.至确认收货起90天后至1年内，可申请原价回购，爱丁猫收取售价5% 的服务费。\n\n\n\n\n\n\n";
    
    self.is_need_appraisal = 1;
    self.agreeBtnIndex = 1;
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight-kPayBottomBarHeight+2.f)];
    self.tableView = tableView;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.tableView];
    
    PayTableHeaderView *headerView = [[PayTableHeaderView alloc] init];
    self.tableView.tableHeaderView = headerView;
    self.headerView = headerView;
    

    
    self.bottomView.frame = CGRectMake(0, self.view.bounds.size.height-kPayBottomBarHeight, self.view.bounds.size.width, kPayBottomBarHeight);
    [self.view addSubview:self.bottomView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.tableView.bounds.size.height, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
    bgView.backgroundColor = [UIColor colorWithHexString:@"626879"];
    [self.headerView addSubview:bgView];
    
    WEAKSELF;
    self.headerView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
       // if ([Session sharedInstance].defaultUserAddress && [[Session sharedInstance].defaultUserAddress.phoneNumber length] > 0) {
            UserAddressViewController *viewController = [[UserAddressViewController alloc] init];
            //        viewController.addressList = [[NSMutableArray alloc] initWithArray:weakSelf.addressList];
            viewController.isForSelectAddress = YES;
            viewController.seletedAddressId = weakSelf.selectedAddressId;
            viewController.handleAddressSelected = ^(UserAddressViewController *viewController, AddressInfo *addressInfo) {
                weakSelf.selectedAddressId = addressInfo.addressId;
                [weakSelf.headerView updateByAddressInfo:addressInfo];
                [weakSelf.footerView setAddressInfo:addressInfo];
                self.addressInfo = addressInfo;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                });
            };
            [weakSelf.navigationController pushViewController:viewController animated:YES];
//        } else {
//            EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
//            //        viewController.addressList = [[NSMutableArray alloc] initWithArray:weakSelf.addressList];
//            viewController.delegate = weakSelf;
//            [weakSelf.navigationController pushViewController:viewController animated:YES];
//        }
        
    };
    
    self.deterSelected = 1;
    
    NSMutableArray *goodsIdList = [[NSMutableArray alloc] init];
    if (weakSelf.formShopCar == 1) {
        for (int i = 0; i < self.items.count; i++) {
            ShoppingCartItem *item = self.items[i];
            [goodsIdList addObject:item.goodsId];
        }
    } else {
        [goodsIdList addObject:self.goodsInfo.goodsId];
    }
    [weakSelf showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"get_value_added_service" parameters:@{@"goods_sn_list":goodsIdList} completionBlock:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
        
        weakSelf.goodsDict = data;
        [weakSelf loadCell:data];
        [weakSelf loadData];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
    } queue:nil]];
    
//    for (int i = 0; i < weakSelf.items.count; i++) {
//        ShoppingCartItem *item = weakSelf.items[i];
//        item.is_use_meow = 1;
//    }
    
    weakSelf.selectedAddressId = -1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judgeChooseBtn:) name:@"judgeChooseBtn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judge:) name:@"judge" object:nil];
    
    self.blackView.dissMissBlackView = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.wristView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.wristView removeFromSuperview];
        }];
    };

}

-(void)loadCell:(NSDictionary *)data{
    WEAKSELF;
    NSMutableArray *dataSources = [[NSMutableArray alloc] init];
    if (weakSelf.formShopCar == 1) {
        for (int i = 0; i < weakSelf.items.count; i++) {
            ShoppingCartItem *item = weakSelf.items[i];
            [dataSources addObject:[SepTableViewCell buildCellDict]];
            
            if (item.supportType == GOODSDETAILRETURN) {
                [dataSources addObject:[WristWhiteRecovertCell buildCellDict:item.sellerInfo.userName isReturnGoods:1]];
            } else {
                [dataSources addObject:[WristWhiteRecovertCell buildCellDict:item.sellerInfo.userName isReturnGoods:0]];
            }
            
            [dataSources addObject:[OrderTabViewCellSmallTwo buildCellDict]];
            [dataSources addObject:[PayTableViewCell buildCellDict:item]];
            
            if (item.supportType == GOODSDETAILRETURN) {
                for (int i = 0; i < item.goodsFittings.count; i++) {
                    GoodsFittings *fitting = item.goodsFittings[i];
                    if (fitting.type == 2) {
                        [dataSources addObject:[OrderSmallLineCell buildCellDict]];
                        [dataSources addObject:[WristwatchRecoveryDetailCell buildCellDict:item.goodsFittings[i]]];
                    }
                }
            }
            if (item.guarantee.iconUrl) {
                [dataSources addObject:[OrderSmallLineCell buildCellDict]];
                [dataSources addObject:[WashGoodsChooseCell buildCellDict:item.guarantee]];
                self.isUserWash = 1;
            } else {
                self.isUserWash = 0;
            }
            if (i == weakSelf.items.count-1) {
                if (item.buyBackInfo.length > 0) {
                    [dataSources addObject:[SepTableViewCell buildCellDict]];
                    [dataSources addObject:[BuyBackCell buildCellTitle:item.buyBackInfo]];
                } else {
                    //                    [dataSources addObject:[SepTableViewCell buildCellDict]];
                }
            }
            
            NSDictionary *dict = [data dictionaryValueForKey:item.goodsId];
            MeowReduceVo *meowReduceVo;
            JDServiceVo *jdServiceVo;
            if (dict[@"meowReduceVo"] == nil || [dict[@"meowReduceVo"] isKindOfClass:[NSNull class]]) {
//                self.isOn = 0;
            } else {
                NSLog(@"0");
                MeowReduceVo *meowReduceVo1 = [[MeowReduceVo alloc] initWithJSONDictionary:dict[@"meowReduceVo"]];
                meowReduceVo = meowReduceVo1;
                item.meowReduceVo = meowReduceVo1;
//                self.isOn = 1;
            }
            
            if (dict[@"JDServiceVo"] == nil || [dict[@"JDServiceVo"] isKindOfClass:[NSNull class]]) {
                
            } else {
                NSLog(@"1");
                JDServiceVo *jdServiceVo1 = [[JDServiceVo alloc] initWithJSONDictionary:dict[@"JDServiceVo"]];
                jdServiceVo = jdServiceVo1;
                item.serviceVo = jdServiceVo1;
            }
            
            [dataSources addObject:[PayGoodsBasicInformation buildCellItem:item]];
            if (jdServiceVo) {
                [dataSources addObject:[SepTableViewCell buildCellDict]];
                [dataSources addObject:[OrderServiceCell buildCellDictisNeedSelect:YES andShoppingCar:item jdServiceVo:jdServiceVo]];
            }
            if ((weakSelf.deterSelected == 0 && item.isChooseJianD == 1) || item.isOnJianD) {
                [dataSources addObject:[PayPromptCell buildCellDict]];
            }
            if (meowReduceVo) {
                [dataSources addObject:[SepTableViewCell buildCellDict]];
                [dataSources addObject:[PayMiaozuanDeductCell buildCellDict:item meowReduceVo:meowReduceVo]];
            }
        }
//        self.meowReduceMoney = meoMoney;
    } else {
        for (ShoppingCartItem *item in weakSelf.items) {
            [dataSources addObject:[SepTableViewCell buildCellDict]];
            
            if (weakSelf.goodsInfo.supportType == GOODSDETAILRETURN) {
                [dataSources addObject:[WristWhiteRecovertCell buildCellDict:weakSelf.goodsInfo.seller.userName isReturnGoods:1]];
            } else {
                [dataSources addObject:[WristWhiteRecovertCell buildCellDict:weakSelf.goodsInfo.seller.userName isReturnGoods:0]];
            }
            
            [dataSources addObject:[OrderSmallLineCell buildCellDict]];
            [dataSources addObject:[PayTableViewCell buildCellDict:item]];
            
            
            if (weakSelf.goodsInfo.supportType == GOODSDETAILRETURN) {
                for (int i = 0; i < weakSelf.goodsInfo.goodsFittings.count; i++) {
                    GoodsFittings *fitting = weakSelf.goodsInfo.goodsFittings[i];
                    if (fitting.type == 2) {
                        [dataSources addObject:[OrderSmallLineCell buildCellDict]];
                        [dataSources addObject:[WristwatchRecoveryDetailCell buildCellDict:weakSelf.goodsInfo.goodsFittings[i]]];
                    }
                }
            }
            if (weakSelf.goodsInfo.guarantee.iconUrl) {
                [dataSources addObject:[OrderSmallLineCell buildCellDict]];
                [dataSources addObject:[WashGoodsChooseCell buildCellDict:weakSelf.goodsInfo.guarantee]];
                self.isUserWash = 1;
            } else {
                self.isUserWash = 0;
            }
            
            if (weakSelf.goodsInfo.buyBackInfo.length > 0) {
                [dataSources addObject:[SepTableViewCell buildCellDict]];
                [dataSources addObject:[BuyBackCell buildCellTitle:weakSelf.goodsInfo.buyBackInfo]];
            } else {
                //            [dataSources addObject:[SepTableViewCell buildCellDict]];
            }
            
            NSDictionary *dict = [data dictionaryValueForKey:weakSelf.goodsInfo.goodsId];
            MeowReduceVo *meowReduceVo;
            JDServiceVo *jdServiceVo;
            if (dict[@"meowReduceVo"] == nil || [dict[@"meowReduceVo"] isKindOfClass:[NSNull class]]) {
                //            self.isOn = 0;
            } else {
                NSLog(@"0");
                MeowReduceVo *meowReduceVo1 = [[MeowReduceVo alloc] initWithJSONDictionary:dict[@"meowReduceVo"]];
                meowReduceVo = meowReduceVo1;
                item.meowReduceVo = meowReduceVo1;
            }
            
            if (dict[@"JDServiceVo"] == nil || [dict[@"JDServiceVo"] isKindOfClass:[NSNull class]]) {
                
            } else {
                NSLog(@"1");
                JDServiceVo *jdServiceVo1 = [[JDServiceVo alloc] initWithJSONDictionary:dict[@"JDServiceVo"]];
                jdServiceVo = jdServiceVo1;
                item.serviceVo = jdServiceVo1;
            }
            for (ShoppingCartItem *item in weakSelf.items) {
                [dataSources addObject:[PayGoodsBasicInformation buildCellItem:item]];
            }
            if (jdServiceVo) {
                [dataSources addObject:[SepTableViewCell buildCellDict]];
                [dataSources addObject:[OrderServiceCell buildCellDictisNeedSelect:YES andShoppingCar:item jdServiceVo:jdServiceVo]];
            }
            if (weakSelf.deterSelected == 0) {
                [dataSources addObject:[PayPromptCell buildCellDict]];
            }
            if (meowReduceVo) {
                [dataSources addObject:[SepTableViewCell buildCellDict]];
                [dataSources addObject:[PayMiaozuanDeductCell buildCellDict:item meowReduceVo:meowReduceVo]];
            }

        }
//        self.meowReduceMoney = meoMoney;
    }
    
    
    //    [[NSNotificationCenter defaultCenter] postNotificationName:@"showXihuIcon" object:@(self.isUserWash)];

    self.dataSources = dataSources;
    [self.tableView reloadData];
}

-(void)attributedLabelSelect:(NSURL *)url
{
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.url = [url absoluteString];
    viewController.title = @"爱丁猫原价回购协议";
    [self pushViewController:viewController animated:YES];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.footerView.textField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"messageEndEdit" object:nil];
}

-(void)showExplain{
    WEAKSELF;
    [self.view addSubview:self.blackView];
    [self.view addSubview:self.wristView];
    self.wristView.alpha = 0;
    self.blackView.alpha = 0;
    
    CGSize size = [self.wristContentText sizeWithFont:[UIFont systemFontOfSize:15.f]
                                    constrainedToSize:CGSizeMake(kScreenWidth-58*2-16*2,MAXFLOAT)
                                        lineBreakMode:NSLineBreakByWordWrapping];
    
    [self.wristView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.width.equalTo(@(kScreenWidth-58*2));
        make.height.equalTo(@(size.height + 50));
    }];
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.blackView.alpha = 0.7;
        weakSelf.wristView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)wristDissBtn{
    WEAKSELF;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.wristView.alpha = 0;
        weakSelf.blackView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.wristView removeFromSuperview];
        [weakSelf.blackView removeFromSuperview];
    }];
}

-(void)judgeChooseBtn:(NSNotification *)notify{
    NSNumber *num = notify.object;
    if ([num isEqualToNumber:@2]) {
        self.chooseBtnIndex = 0;
    } else {
        self.chooseBtnIndex = 1;
        
        if ([num isEqualToNumber:@0]) {
            self.is_need_appraisal = 0;
        } else if ([num isEqualToNumber:@1]) {
            self.is_need_appraisal = 1;
        }
        
    }
}

-(void)judge:(NSNotification *)notify{
    UIButton *btn = notify.object;
    if (btn.selected == NO) {
        self.agreeBtnIndex = 1;
    } else {
        self.agreeBtnIndex = 0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buildFootView {
    
    NSInteger totalPriceCent = 0;
    for (NSInteger i=0;i<[self.items count];i++) {
        ShoppingCartItem *item = [self.items objectAtIndex:i];
        totalPriceCent += item.shopPriceCent;
        if (item.meowReduceVo) {
            if (item.is_use_meow == 1) {
                totalPriceCent -= item.meowReduceVo.meowReducePrice*100;
                if (totalPriceCent < 0) totalPriceCent = 0;
            }
        }
        
        if (item.serviceVo) {
            if (item.is_use_jdvo == 1) {
                totalPriceCent += item.serviceVo.fee*100;
            }
        }
    }
    WEAKSELF;
    void(^updateBottomBlock)() = ^(){
        NSInteger realTotalPriceCent = totalPriceCent;
        //1. 先判断优惠券
        if (weakSelf.seletedBonusInfo) {
            if ([weakSelf.seletedBonusInfo.bonusId isEqualToString:@"-1000"]) {
                weakSelf.seletedBonusInfo = nil;
            } else {
                realTotalPriceCent = realTotalPriceCent-weakSelf.seletedBonusInfo.amountCent;
                if (realTotalPriceCent<0)realTotalPriceCent=0;
            }
        }
        //判断卡
        if (weakSelf.selectedAccountCard) {
            if (weakSelf.selectedAccountCard.cardType == -1000) {
                weakSelf.selectedAccountCard = nil;
            } else {
                realTotalPriceCent = realTotalPriceCent-weakSelf.selectedAccountCard.cardCanPayMoney*100;
                if (realTotalPriceCent<0)realTotalPriceCent=0;
            }
        }
        //2. 奖金抵用
        if (weakSelf.is_used_reward_money && realTotalPriceCent>0) {
            realTotalPriceCent = realTotalPriceCent-weakSelf.reward_money_cent;
            if (realTotalPriceCent<0)realTotalPriceCent=0;
        }
        //3. 余额
        if (weakSelf.payway == PayWayAdmMoney && realTotalPriceCent>0) {//weakSelf.is_used_adm_money
            realTotalPriceCent = realTotalPriceCent-weakSelf.available_money_cent;
            if (realTotalPriceCent<0)realTotalPriceCent=0;
        }
        //4、喵钻抵扣
//        if (weakSelf.meowReduceMoney > 0 && realTotalPriceCent>0) {
//            realTotalPriceCent = realTotalPriceCent-weakSelf.meowReduceMoney*100;
//            if (realTotalPriceCent<0)realTotalPriceCent=0;
//        }
        if (weakSelf.payway == PayWayAdmMoney && weakSelf.payPrice > weakSelf.available_money_cent/100) {
            [weakSelf showChongZhiView];
            return;
        }
        
//        if (weakSelf.payway == PayWayPartial) {
//            [weakSelf showPartialView];
//        }
        
//        for (NSInteger i=0;i<[self.items count];i++) {
//            ShoppingCartItem *item = [self.items objectAtIndex:i];
//            if (item.meowReduceVo) {
//                if (item.is_use_meow == 1) {
//                    realTotalPriceCent -= item.meowReduceVo.meowReducePrice*100;
//                    if (realTotalPriceCent < 0) realTotalPriceCent = 0;
//                }
//            }
//            
//            if (item.serviceVo) {
//                if (item.is_use_jdvo == 1) {
//                    realTotalPriceCent += item.serviceVo.fee*100;
//                }
//            }
//        }
        
        [weakSelf updateBottomTotalPrice:((double)realTotalPriceCent)/100.f];
        
    };
    
    PayTableFooterView *footerView = [[PayTableFooterView alloc] init:totalPriceCent reward_money_cent:self.reward_money_cent available_money_cent:self.available_money_cent payWays:self.payWays quanItemArray:self.quanItemsArray index:self.index xiHuCardArray:self.xiHuCardArray itemArr:self.items];
    self.is_used_adm_money = NO;    //需要再研究研究
    footerView.delegate = self;
//    if (self.index == 100) {
//        self.footerView.index = 100;
//        [self.tableView reloadData];
//    }
    footerView.viewController = self;
    self.tableView.tableFooterView = footerView;
    self.footerView = footerView;
    self.footerView.addressInfo = self.addressInfo;
    self.footerView.goodsInfo = self.goodsInfo;
    
    weakSelf.footerView.changeXihuCardArr = ^(NSArray *xihuCardArr){
        weakSelf.xiHuCardArray = xihuCardArr;
    };
    
    self.footerView.handlePayWayChangedBlock1 = ^(NSInteger payWay){
        weakSelf.payway = payWay;
        weakSelf.partialDo.payType = payWay;
        updateBottomBlock();
    };
    
    self.footerView.handleUsingReward = ^(BOOL usingReward) {
        weakSelf.is_used_reward_money = usingReward;
        updateBottomBlock();
    };
    self.footerView.handleUsingQuan = ^(BonusInfo *bonusInfo) {
        weakSelf.seletedBonusInfo = bonusInfo;
        updateBottomBlock();
    };
    self.footerView.handleUsingAdmMoney = ^(NSInteger payway) {
        weakSelf.payway = payway;
        weakSelf.partialDo.payType = payway;
        updateBottomBlock();
    };
    self.footerView.handleUsingXihuCard = ^(AccountCard *accountCard){
        weakSelf.selectedAccountCard = accountCard;
        updateBottomBlock();
    };
    
    if (self.quanItemsArray.count == 0 || self.xiHuCardArray.count == 0) {
        updateBottomBlock();
    }
    
    //自动勾选最佳优惠券
    for (int i = 0 ; i < self.quanItemsArray.count; i++) {
        BonusInfo *info = self.quanItemsArray[i];
        if (!self.seletedBonusInfo) {
            self.seletedBonusInfo = info;
        } else {
            if (self.seletedBonusInfo.amountCent > info.amountCent) {
                
            } else {
                self.seletedBonusInfo = info;
            }
        }
        
        if (i == self.quanItemsArray.count - 1) {
            if (self.seletedBonusInfo && [self.seletedBonusInfo isKindOfClass:[BonusInfo class]]) {
                //                        PayTableFooterItemView *itemViewQuanTmp = (PayTableFooterItemView*)[weakSelf viewWithTag:600];
                //itemViewQuanTmp.subTitle = bonusInfo.bonusDesc;
                //                        itemViewQuanTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元",((double)self.seletedBonusInfo.amountCent)/100.f];
                //                        if (weakSelf.handleUsingQuan) {
                //                            weakSelf.handleUsingQuan(self.seletedBonusInfo);
                //                        }
                updateBottomBlock();
            }
        }
    }
    
    for (int i = 0 ; i < self.xiHuCardArray.count; i++) {
        AccountCard *card = self.xiHuCardArray[i];
        if (!self.selectedAccountCard) {
            self.selectedAccountCard = card;
        } else {
            if (self.selectedAccountCard.cardCanPayMoney > card.cardCanPayMoney) {
                
            } else {
                self.selectedAccountCard = card;
            }
        }
        
        if (i == self.xiHuCardArray.count - 1) {
            if (self.selectedAccountCard && [self.selectedAccountCard isKindOfClass:[AccountCard class]]) {
                //                        PayTableFooterItemView *itemViewQuanTmp = (PayTableFooterItemView*)[weakSelf viewWithTag:600];
                //itemViewQuanTmp.subTitle = bonusInfo.bonusDesc;
                //                        itemViewQuanTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元",((double)self.seletedBonusInfo.amountCent)/100.f];
                //                        if (weakSelf.handleUsingQuan) {
                //                            weakSelf.handleUsingQuan(self.seletedBonusInfo);
                //                        }
                updateBottomBlock();
            }
        }
    }
}

-(void)dismissPartialView{
    WEAKSELF;
    
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.partialView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 260);
        weakSelf.partialBgView.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf.partialView.textField resignFirstResponder];
        [weakSelf.partialBgView removeFromSuperview];
        [weakSelf.partialView removeFromSuperview];
        weakSelf.partialBgView = nil;
        weakSelf.partialView = nil;
    }];
    [UIView animateWithDuration:0.25 animations:^{
        
    }];
}

-(void)showPartialView{
    WEAKSELF;
    self.partialDo.payWayIconUrl = self.footerView.payWayDOSelected.icon_url;
    self.partialDo.payWayTitle = self.footerView.payWayDOSelected.pay_name;
    self.partialDo.payWays = self.footerView.payWays;
    self.partialDo.avaMoneyCent = self.available_money_cent;
    
    [self.view addSubview:self.partialBgView];
    self.partialBgView.alpha = 0.7;
    self.partialBgView.frame = self.view.bounds;
    [self.view addSubview:self.partialView];
    self.partialView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 260);
    [self.partialView getPartialDo:self.partialDo];
    
    self.partialBgView.dissMissBlackView = ^(){
        [weakSelf beingOrder];
        [weakSelf dismissPartialView];
        [weakSelf dismissPartialPayWayView];
    };
    self.partialView.clickProtialCloseBtn = ^(){
        [weakSelf beingOrder];
        [weakSelf dismissPartialView];
    };
    self.partialView.inputPrice = ^(NSString *priceNum, ParyialDo *partialDo){
        if (partialDo.payType == 20) {
            [weakSelf showHUD:@"请选择支付方式" hideAfterDelay:0.8];
            return ;
        }
        
        CGFloat inputPrice = priceNum.doubleValue;
        weakSelf.payPrice = inputPrice;
        weakSelf.surePartialDo = partialDo;
        if (weakSelf.selectedAddressId <= 0) {
            //                [weakSelf showHUD:@"请在页面顶部添加收货地址" hideAfterDelay:0.8f];
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请添加收货地址"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             if (buttonIndex == 0) {
                                 
                             } else {
                                 EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
                                 viewController.delegate = weakSelf;
                                 [weakSelf.navigationController pushViewController:viewController animated:YES];
                             }
                         } cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
            return;
        }
        
        NSMutableArray *goodsList = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[weakSelf.items count];i++) {
            ShoppingCartItem *item = [weakSelf.items objectAtIndex:i];
            [goodsList addObject:[NetworkAPI addOrderGoodsListItem:item.goodsId price:item.shopPrice priceCent:item.shopPriceCent receive_service_gift:weakSelf.isUserWash shoppingCartItem:item]];
        }
        
        PayWayType payway = partialDo.payType;
        if (PayWayWxpay == payway && ![WXApi isWXAppInstalled]) {
            [weakSelf showHUD:@"请安装微信后重试\n或选择其他支付方式" hideAfterDelay:1.5f];
            return;
        }
        
        [weakSelf dismissPartialPayWayView];
        [weakSelf dismissPartialView];
        
        if (payway == PayWayOffline) {
            [weakSelf showProcessingHUD:nil forView:weakSelf.view];
            NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
            for (ShoppingCartItem *item in weakSelf.items) {
                [goodsIds addObject:item.goodsId];
            }
            [weakSelf payGoodsList:goodsList boundsId:nil partialDo:partialDo accountCard:nil];
        } else {
            NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
            for (ShoppingCartItem *item in weakSelf.items) {
                [goodsIds addObject:item.goodsId];
            }
            [weakSelf payGoodsList:goodsList boundsId:weakSelf.seletedBonusInfo?weakSelf.seletedBonusInfo.bonusId:nil partialDo:partialDo accountCard:weakSelf.selectedAccountCard?weakSelf.selectedAccountCard:nil];
        }
        
//        [weakSelf.partialView getPayingPrice:inputPrice];
        
//        ForumQuoteInputView *inputView = [[ForumQuoteInputView alloc] initWithFrame:CGRectZero];
//        [DigitalKeyboardView showInViewMF:weakSelf.view inputContainerView:inputView textFieldArray:[NSArray arrayWithObjects:inputView.textFiled, nil] completion:^(DigitalInputContainerView *inputContainerView) {
//            inputView.index = 3;
//            CGFloat priceCent = [((ForumQuoteInputView*)inputContainerView) priceCent];
//            CGFloat nextPriceCent = priceCent / 100;
//            NSLog(@"%f, %f", priceCent, nextPriceCent);
//            if (nextPriceCent >0) {
//                
//                if (nextPriceCent > weakSelf.partialDo.surplusPriceNum) {
//                    nextPriceCent = weakSelf.partialDo.surplusPriceNum;
//                }
//                weakSelf.payPrice = nextPriceCent;
//                [weakSelf.partialView getPayingPrice:nextPriceCent];
//                
//            }
//        }];
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

-(void)beingOrder{
    WEAKSELF;
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    NSMutableArray *goodsList = [[NSMutableArray alloc] init];
    for (NSInteger i=0;i<[weakSelf.items count];i++) {
        ShoppingCartItem *item = [weakSelf.items objectAtIndex:i];
        [goodsList addObject:[NetworkAPI addOrderGoodsListItemTwo:item.goodsId price:item.shopPrice priceCent:item.shopPriceCent]];
    }
    
    [param setObject:@([Session sharedInstance].currentUserId) forKey:@"user_id"];
    [param setObject:@(self.footerView.payWay) forKey:@"pay_way"];
    [param setObject:@(self.selectedAddressId) forKey:@"address_id"];
    [param setObject:self.footerView.message?self.footerView.message:@"" forKey:@"message"];
    [param setObject:goodsList forKey:@"goods_list"];
    
    [weakSelf showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"trade" path:@"generate_order" parameters:param completionBlock:^(NSDictionary *data) {
        [weakSelf hideHUD];
        //        if ([weakSelf.navigationController.viewControllers count]>1) {
        //            UIViewController *viewController = [weakSelf.navigationController.viewControllers objectAtIndex:[weakSelf.navigationController.viewControllers count]-2];
        //            if ([viewController isKindOfClass:[BoughtCollectionViewController class]]) {
        //                [weakSelf dismiss];
        //                return;
        //            }
        //        }
        //        BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
        //        viewController.goonWithPayController = 1;
        //        [self pushViewController:viewController animated:YES];
        [weakSelf handlePayDidFnishBlockImpl:0];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
    } queue:nil]];
}

-(void)showPayWayView{
    WEAKSELF;
    [self.view addSubview:self.partialPayWayView];
    self.partialPayWayView.frame = CGRectMake(kScreenWidth, kScreenHeight-359, kScreenWidth, 359);
    [self.partialPayWayView getPartialDo:self.partialDo];
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.partialPayWayView.frame = CGRectMake(0, kScreenHeight-359, kScreenWidth, 359);
    } completion:^(BOOL finished) {
        [weakSelf.partialView.textField endEditing:YES];
    }];
}

-(void)dismissPartialPayWayView{
    WEAKSELF;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.partialPayWayView.frame = CGRectMake(kScreenWidth, kScreenHeight-359, kScreenWidth, 359);
    } completion:^(BOOL finished) {
        [weakSelf.partialPayWayView removeFromSuperview];
        [weakSelf.partialView.textField becomeFirstResponder];
    }];
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

- (void)updateBottomTotalPrice:(double)totalPrice {
    WEAKSELF;
    
    NSString *totalPriceString = [NSString stringWithFormat:@"¥ %.2f",totalPrice];
    UILabel *totalPriceLbl = (UILabel*)[weakSelf.bottomView viewWithTag:100];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"实付：%@",totalPriceString]];
    
    NSRange stringRange = NSMakeRange(attrString.length-totalPriceString.length,totalPriceString.length);
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[DataSources colorf9384c]
                       range:stringRange];
    [attrString addAttribute:NSFontAttributeName
                       value:[UIFont systemFontOfSize:14.5f]
                       range:stringRange];
    totalPriceLbl.attributedText = attrString;
    
    self.partialDo.surplusPriceNum = totalPrice;
}

- (void)loadData {
    WEAKSELF;
    
    [self showProcessingHUD:@""];
    
    void(^errorOccured)(XMError *error) = ^(XMError *error){
        [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
            [weakSelf loadData];
        };
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
    };
    
    [weakSelf loadUserAddress:^(NSArray *addressList) {
        [TradeService pay_ways:[NSNumber numberWithDouble:self.goodsInfo.shopPrice] completion:^(NSArray *payWays) {
            weakSelf.payWays = payWays;
            
            [UserService get_account:^(NSInteger reward_money_cent, NSInteger available_money_cent) {
                weakSelf.reward_money_cent = reward_money_cent;
                weakSelf.available_money_cent = available_money_cent;
                
                
                [weakSelf loadAvailableBonus:^(NSArray *quanItemsArray) {
                    weakSelf.quanItemsArray = quanItemsArray;
                    
                    BonusInfo *bonusInfo = [[BonusInfo alloc] init];
                    for (int i = 0 ; i < quanItemsArray.count; i++) {
                        BonusInfo *info = quanItemsArray[i];
                        if (bonusInfo.amountCent > info.amountCent) {
                            
                        } else {
                            bonusInfo = info;
                        }
                        
                        weakSelf.seletedBonusInfo = bonusInfo;
                    }
                    
                    NSInteger isUseReward = 0;
                    if (reward_money_cent > 0) {
                        isUseReward = 1;
                    } else {
                        isUseReward = 0;
                    }
                    [weakSelf loadXiHuCard:bonusInfo.bonusId isUseRewardMoney:isUseReward completion:^(NSArray *xiHuCardArray) {
                        weakSelf.selectedAccountCard = nil;
                        weakSelf.xiHuCardArray = xiHuCardArray;
                        
                        [weakSelf buildFootView];
                        [weakSelf hideHUD];
                        
                    } failure:^(XMError *error) {
                        errorOccured(error);
                    }];
                } failure:^(XMError *error) {
                    errorOccured(error);
                }];
                
            } failure:^(XMError *error) {
                errorOccured(error);
            }];
            
        } failure:^(XMError *error) {
            errorOccured(error);
        }];

    } failure:^(XMError *error) {
        errorOccured(error);
    }];
}

//可以使用的卡
-(void)loadXiHuCard:(NSString *)bonusId isUseRewardMoney:(NSInteger)isUseRewardMoney completion:(void (^)(NSArray *xiHuCardArray))completion failure:(void (^)(XMError *error))failure {
    WEAKSELF;
    NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
    for (ShoppingCartItem *item in weakSelf.items) {
        if (item.meowReduceVo == nil) {
            item.is_use_meow = 0;
        }
        if (item.serviceVo == nil) {
            item.is_use_jdvo = 0;
        }
        [goodsIds addObject:@{@"goods_id":item.goodsId,@"is_use_meow":@(item.is_use_meow)}];
    }
    HTTPRequest *request = [[NetworkAPI sharedInstance] listXiHuCardByGoodsList:goodsIds brandId:bonusId isUseRewardMoney:isUseRewardMoney completion:^(NSArray *itemList) {
        NSMutableArray *xiHuCardArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in itemList) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [xiHuCardArray addObject:[[AccountCard alloc] initWithJSONDictionary:dict]];
            }
        }
        if (completion) {
            completion(xiHuCardArray);
        }
    } failure:^(XMError *error) {
        if (failure)failure(error);
    }];
    [[NetworkManager sharedInstance] addRequest:request];
}

//可以使用的优惠券
- (void)loadAvailableBonus:(void (^)(NSArray *quanItemsArray))completion failure:(void (^)(XMError *error))failure {
    WEAKSELF;
    NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
    for (ShoppingCartItem *item in weakSelf.items) {
        [goodsIds addObject:item.goodsId];
    }
    HTTPRequest *request = [[NetworkAPI sharedInstance] listAvailableBonusByGoodsList:goodsIds completion:^(NSArray *itemList) {
        NSMutableArray *quanItemsArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in itemList) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [quanItemsArray addObject:[BonusInfo createWithDict:dict]];
            }
        }
        if (completion) {
            completion(quanItemsArray);
        }
    } failure:^(XMError *error) {
        if (failure)failure(error);
    }];
    [[NetworkManager sharedInstance] addRequest:request];
}

- (void)loadUserAddress:(void (^)(NSArray *addressList))completion failure:(void (^)(XMError *error))failure
{
    WEAKSELF;
    HTTPRequest *request = [[NetworkAPI sharedInstance] getUserAddressList:[Session sharedInstance].currentUserId completion:^(NSArray *addressDictList) {
        if ([addressDictList count] == 0) {
            weakSelf.headerView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
                EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
                viewController.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            };
        }
        
        NSMutableArray *addressList = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[addressDictList count];i++) {
            AddressInfo *addressInfo = [AddressInfo createWithDict:[addressDictList objectAtIndex:i]];
            [addressList addObject:addressInfo];
        }
        
        MBGlobalSendFetchAddressListDidFinishNotification(addressList);
        if (completion)completion(addressList);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    }];
    [[NetworkManager sharedInstance] addRequest:request];
}

#pragma mark - AddressDelegate
- (void)editAddressSaved:(EditAddressViewController*)viewController addressInfo:(AddressInfo*)addressInfo
{
    [self loadUserAddress:nil failure:nil];
}

- (UIView*)bottomView
{
    if (!_bottomView) {
        UIImage *bgImage = [UIImage imageNamed:@"bottombar_bg_white"];
        _bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kPayBottomBarHeight)];
        _bottomView.userInteractionEnabled = YES;
        [_bottomView setImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2]];
        
//        CGFloat marginRight = 8.5f;
        CommandButton *payBtn = [[CommandButton alloc] initWithFrame:CGRectMake(_bottomView.bounds.size.width-104-10, 10, 104, _bottomView.bounds.size.height-20)];
        
//        if (self.index == 100) {
//            payBtn.frame = CGRectMake(_bottomView.bounds.size.width-137, 0.5, 137, _bottomView.bounds.size.height-0.5);
//            payBtn.backgroundColor = [UIColor colorWithHexString:@"ac7e33"];
//            //                payBtn.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
//            //        payBtn.layer.masksToBounds = YES;
//            //        payBtn.layer.cornerRadius = 5.f;
//            payBtn.titleLabel.font = [UIFont systemFontOfSize:14.5f];
//            [payBtn setTitle:@"确认并付款" forState:UIControlStateNormal];
//            [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            [payBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
//            [_bottomView addSubview:payBtn];
//        } else {
            payBtn.backgroundColor = [DataSources colorf9384c];
            //                payBtn.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
            //        payBtn.layer.masksToBounds = YES;
            //        payBtn.layer.cornerRadius = 5.f;
            payBtn.titleLabel.font = [UIFont systemFontOfSize:14.5f];
            [payBtn setTitle:@"提交订单" forState:UIControlStateNormal];
        payBtn.layer.masksToBounds = YES;
        payBtn.layer.cornerRadius = 3;
            [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [payBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
            [_bottomView addSubview:payBtn];
//        }
        
        UILabel *totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 1, payBtn.frame.origin.x-15-15, _bottomView.bounds.size.height-1)];
        totalPriceLbl.textColor = [UIColor colorWithHexString:@"181818"];
        totalPriceLbl.font = [UIFont systemFontOfSize:15.5f];
        totalPriceLbl.tag = 100;
        [_bottomView addSubview:totalPriceLbl];
        
        WEAKSELF;
        payBtn.handleClickBlock = ^(CommandButton *sender){
            [MobClick event:@"click_payment"];
            
            if (weakSelf.footerView.selectedIndex == 0) {
                [weakSelf showHUD:@"请先阅读爱丁猫服务协议" hideAfterDelay:0.8];
                return ;
            }
            
            if (weakSelf.selectedAddressId <= 0) {
//                [weakSelf showHUD:@"请在页面顶部添加收货地址" hideAfterDelay:0.8f];
                [WCAlertView showAlertWithTitle:@""
                                        message:@"请添加收货地址"
                             customizationBlock:^(WCAlertView *alertView) {
                                 alertView.style = WCAlertViewStyleWhite;
                             } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                 if (buttonIndex == 0) {
                                     
                                 } else {
                                     EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
                                     viewController.delegate = weakSelf;
                                     [weakSelf.navigationController pushViewController:viewController animated:YES];
                                 }
                             } cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
                return;
            }
            
            if (self.index == 100) {
                
                if (weakSelf.chooseBtnIndex == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请选择鉴定方式" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
                
                if (weakSelf.agreeBtnIndex == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先阅读爱丁猫平台交易免责协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    return;
                }
            }
            
            NSMutableArray *goodsList = [[NSMutableArray alloc] init];
            for (NSInteger i=0;i<[weakSelf.items count];i++) {
                ShoppingCartItem *item = [weakSelf.items objectAtIndex:i];
                [goodsList addObject:[NetworkAPI addOrderGoodsListItem:item.goodsId price:item.shopPrice priceCent:item.shopPriceCent receive_service_gift:self.isUserWash shoppingCartItem:item]];
            }
//            NSMutableArray *removedGoodsIds = [[NSMutableArray alloc] init];
//            for (NSInteger i=0;i<[weakSelf.items count];i++) {
//                ShoppingCartItem *item = [weakSelf.items objectAtIndex:i];
//                [removedGoodsIds addObject:item.goodsId];
//            }
            
            
            {
                PayWayType payway = weakSelf.footerView.payWay;
                if (PayWayWxpay == payway && ![WXApi isWXAppInstalled]) {
                    [weakSelf showHUD:@"请安装微信后重试\n或选择其他支付方式" hideAfterDelay:1.5f];
                    return;
                }
                
                if (payway == PayWayOffline) {
                    [weakSelf showProcessingHUD:nil forView:weakSelf.view];
                    NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
                    for (ShoppingCartItem *item in weakSelf.items) {
                        [goodsIds addObject:item.goodsId];
                    }
                    [weakSelf payGoodsList:goodsList boundsId:nil partialDo:nil accountCard:nil];
                } else if (payway == PayWayPartial) {
                    [weakSelf showPartialView];
                } else {
                    NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
                    for (ShoppingCartItem *item in weakSelf.items) {
                        [goodsIds addObject:item.goodsId];
                    }
                    [weakSelf payGoodsList:goodsList boundsId:weakSelf.seletedBonusInfo?weakSelf.seletedBonusInfo.bonusId:nil partialDo:nil accountCard:weakSelf.selectedAccountCard?weakSelf.selectedAccountCard:nil];
                }
            }
        };
    }
    return _bottomView;
}

- (void)payGoodsList:(NSArray*)goodsList boundsId:(NSString*)boundsId partialDo:(ParyialDo *)partialDo accountCard:(AccountCard *)card{
    
    WEAKSELF;
    
    //[weakSelf showProcessingHUD:nil forView:weakSelf.tableView];
    
    NSMutableArray *removedGoodsIds = [[NSMutableArray alloc] init];
    for (NSInteger i=0;i<[weakSelf.items count];i++) {
        ShoppingCartItem *item = [weakSelf.items objectAtIndex:i];
        [removedGoodsIds addObject:item.goodsId];
    }
    
    void(^payGoodsBlock)() = ^(){
        PayWayType payway;// = weakSelf.footerView.payWay;
        if (partialDo != nil) {
            payway = partialDo.payType;
        } else {
            payway = weakSelf.footerView.payWay;
        }
        
        [ClientReportObject clientReportObjectWithViewCode:MineSureOrderViewCode regionCode:MineBoughtViewCode referPageCode:MineBoughtViewCode andData:@{@"payway":@(payway)}];
        
        NSInteger isPartialPay = weakSelf.footerView.isPartialPay;
        weakSelf.request = [[NetworkAPI sharedInstance] payGoods:goodsList address:weakSelf.selectedAddressId message:weakSelf.footerView.message payWay:payway bonus:payway==PayWayOffline?nil:boundsId accountCard:card is_need_appraisal:weakSelf.chooseBtnIndex is_used_adm_money:weakSelf.is_used_adm_money is_used_reward_money:_is_used_reward_money is_partial_pay:isPartialPay partial_pay_amount:self.payPrice completion:^(NSString *payUrl,PayReq *payReq,NSString *upPayTn,PayZhaoHangReg*payZHReq) {
            [weakSelf hideHUD];
            
            NSInteger totalNum = [Session sharedInstance].shoppingCartNum-[goodsList count];
            [[Session sharedInstance] setShoppingCartGoods:totalNum removedGoodsIds:removedGoodsIds];
            
            BOOL handled = NO;
            if (payway == PayWayOffline) {
                
            } else if(payway == PayWayAlipay && payUrl && [payUrl length]>0) {
                handled = YES;
                [PayManager pay:payUrl];
            } else if (payway == PayWayWxpay && payReq) {
                handled = YES;
               BOOL isSuc = [PayManager weixinPay:payReq];
                if (isSuc) {
//                    [self showPaySuccess];
//                    SuccessfulPayViewController *viewController = [[SuccessfulPayViewController alloc] init];
//                    viewController.goodsId = weakSelf.goodsInfo.goodsId;
//                    [weakSelf pushViewController:viewController animated:YES]；
                }
            } else if (payway == PayWayUpay && upPayTn && [upPayTn length] > 0) {
                handled = YES;
                //[UPPayPlugin startPay:upPayTn mode:kMode_Development viewController:self delegate:self];
                [PayManager uppay:upPayTn];
            } else if (payway == PayWayFenQiLe && payUrl && [payUrl length]>0) {
                handled = YES;
                [FenQiLePayViewController presentFenQiLePay:payUrl orderIds:nil];
            } else if (payway == PayWayZhaoH && payZHReq) {
                handled = YES;
                NSString *payZHUrl = [NSString stringWithFormat:@"%@%@?BranchID=%@&CoNo=%@&BillNo=%@&Amount=%@&Date=%@&ExpireTimeSpan=%@&MerchantUrl=%@&MerchantPara=%@&MerchantCode=%@&MerchantRetUrl=%@&MerchantRetPara=%@", payZHReq.pay_url, payZHReq.MfcISAPICommand, payZHReq.BranchID, payZHReq.CoNo, payZHReq.BillNo, payZHReq.Amount, payZHReq.Date, payZHReq.ExpireTimeSpan, payZHReq.MerchantUrl, payZHReq.MerchantPara, payZHReq.MerchantCode, payZHReq.MerchantRetUrl, payZHReq.MerchantRetPara];
                NSString * newUrl = [payZHUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSLog(@"%@", newUrl);
//                WebViewController *webViewC = [[WebViewController alloc] init];
//                webViewC.url = payZHUrl;
//                [[CoordinatingController sharedInstance] presentViewController:webViewC animated:YES completion:nil];
                [FenQiLePayViewController presentFenQiLePay:newUrl orderIds:nil];
            }
            
            if (!handled) {
                [weakSelf handlePayDidFnishBlockImpl:0];
//                if (!handled) {
//                    [weakSelf $$handlePayResultCompletionNotification:nil orderIds:orderIds];
//                }
            }
            
        } failure:^(XMError *error) {
            //2016.8.27修改支付异常也跳到订单列表页面
            [weakSelf hideHUD];
            if ([weakSelf.navigationController.viewControllers count]>1) {
                UIViewController *viewController = [weakSelf.navigationController.viewControllers objectAtIndex:[weakSelf.navigationController.viewControllers count]-2];
                if ([viewController isKindOfClass:[BoughtCollectionViewController class]]) {
                    [weakSelf dismiss];
                    return;
                }
            }
            BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
            viewController.goonWithPayController = 1;
            [weakSelf pushViewController:viewController animated:YES];
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:viewController.view];

        }];
        
    };
    
    
    NSInteger totalPriceCent = 0;
    for (NSInteger i=0;i<[self.items count];i++) {
        ShoppingCartItem *item = [self.items objectAtIndex:i];
        totalPriceCent += item.shopPriceCent;
    }
    NSInteger realTotalPriceCent = totalPriceCent;
    //1. 先判断优惠券
//    if (weakSelf.seletedBonusInfo) {
//        realTotalPriceCent = realTotalPriceCent-weakSelf.seletedBonusInfo.amountCent;
//        if (realTotalPriceCent<0)realTotalPriceCent=0;
////        partialDo.surplusPriceNum = realTotalPriceCent;
//    }
    //1. 先判断优惠券
    if (weakSelf.seletedBonusInfo) {
        if ([weakSelf.seletedBonusInfo.bonusId isEqualToString:@"-1000"]) {
            
        } else {
            realTotalPriceCent = realTotalPriceCent-weakSelf.seletedBonusInfo.amountCent;
            if (realTotalPriceCent<0)realTotalPriceCent=0;
        }
    }
    //优惠卡
    if (weakSelf.selectedAccountCard) {
        if (weakSelf.selectedAccountCard.cardType == -1000) {
            
        } else {
            realTotalPriceCent = realTotalPriceCent-weakSelf.selectedAccountCard.cardCanPayMoney*100;
            if (realTotalPriceCent<0)realTotalPriceCent=0;
        }
    }
    //2. 奖金抵用
    if (weakSelf.is_used_reward_money && realTotalPriceCent>0) {
        realTotalPriceCent = realTotalPriceCent-weakSelf.reward_money_cent;
        if (realTotalPriceCent<0)realTotalPriceCent=0;
//        partialDo.surplusPriceNum = realTotalPriceCent;
    }
    
    [self.partialView getPartialDo:partialDo];
    
    PayWayType payway;
    if (partialDo != nil) {
        payway = partialDo.payType;
    } else {
        payway = weakSelf.footerView.payWay;
    }
    
    //3. 余额
    if (payway == PayWayAdmMoney && realTotalPriceCent>0) {//weakSelf.is_used_adm_money
        realTotalPriceCent = realTotalPriceCent-weakSelf.available_money_cent;
        if (realTotalPriceCent<0)realTotalPriceCent=0;
    }
    
    if (partialDo != nil) {
        if (payway == PayWayAdmMoney && self.payPrice > weakSelf.available_money_cent/100) {
            [weakSelf showChongZhiView];
            return;
        }
    }
    
    if (payway == PayWayPartial) {
        [weakSelf showPartialView];
        return;
    }
    
//    if (payway==PayWayAdmMoney) {//(realTotalPriceCent==0 && payway!=PayWayOffline) || (
//        WEAKSELF;
//        if ([[Session sharedInstance] isBindingPhoneNumber]) {
//            [VerifyPasswordView showInViewMF:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
//                [weakSelf showProcessingHUD:nil];
//                [AuthService validatePassword:password completion:^{
//                    payGoodsBlock();
//                } failure:^(XMError *error) {
//                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//                }];
//            }];
//        } else {
//            [WCAlertView showAlertWithTitle:@""
//                                    message:@"确认使用余额付款？"
//                         customizationBlock:^(WCAlertView *alertView) {
//                             alertView.style = WCAlertViewStyleWhite;
//                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
//                             if (buttonIndex == 0) {
//                                 
//                             } else {
//                                 payGoodsBlock();
//                             }
//                         } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
//        }
//    } else {
//        [weakSelf showProcessingHUD:nil];
//        payGoodsBlock();
//    }
    
    if (realTotalPriceCent==0 && payway!=PayWayOffline) {//(realTotalPriceCent==0 && payway!=PayWayOffline) || (
        WEAKSELF;
        if ([[Session sharedInstance] isBindingPhoneNumber]) {
            [VerifyPasswordView showInViewMF:weakSelf.view.superview.superview completionBlock:^(NSString *password) {
                [weakSelf showProcessingHUD:nil];
                [AuthService validatePassword:password completion:^{
                    payGoodsBlock();
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            }];
        } else {
            [WCAlertView showAlertWithTitle:@""
                                    message:@"确认使用余额付款？"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             if (buttonIndex == 0) {
                                 
                             } else {
                                 payGoodsBlock();
                             }
                         } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
        }
    } else {
        [weakSelf showProcessingHUD:nil];
        payGoodsBlock();
    }

    
}

- (void)showPaySuccess
{
    //支付成功提示框
    NSInteger userId = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] integerValue];
    if (userId != [Session sharedInstance].currentUser.userId) {
        EvaluateView * view = [[EvaluateView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [view show];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([tableViewCell isKindOfClass:[WristWhiteRecovertCell class]]) {
        WristWhiteRecovertCell *wristWhiteCell = (WristWhiteRecovertCell *)tableViewCell;
        wristWhiteCell.wristDelegate = weakSelf;
    }
    
    if ([tableViewCell isKindOfClass:[BuyBackCell class]]) {
        BuyBackCell * buyBackCell = (BuyBackCell *)tableViewCell;
        buyBackCell.rtLabelSelect = ^(NSURL * url){
            WebViewController *viewController = [[WebViewController alloc] init];
            viewController.url = [url absoluteString];
            viewController.title = @"原价回购标准";
            [weakSelf pushViewController:viewController animated:YES];
        };
    }
    
    if ([tableViewCell isKindOfClass:[WashGoodsChooseCell class]]) {
        WashGoodsChooseCell *chooseCell = (WashGoodsChooseCell *)tableViewCell;
        chooseCell.clickXihuChooseBtn = ^(UIButton *sender){
            if (sender.selected == YES) {
                weakSelf.isUserWash = 1;
            } else {
                weakSelf.isUserWash = 0;
            }
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"showXihuIcon" object:@(self.isUserWash)];
        };
    }
    
    if ([tableViewCell isKindOfClass:[OrderServiceCell class]]) {
        OrderServiceCell *otableViewCell = (OrderServiceCell *)tableViewCell;
        otableViewCell.deterSelected = ^(NSInteger isSelected, ShoppingCartItem *item){
//            NSLog(@"%ld", (long)isSelected);
            weakSelf.deterSelected = isSelected;
            [UIView animateWithDuration:0.25 animations:^{
                [weakSelf loadCell:weakSelf.goodsDict];
                [weakSelf.tableView reloadData];
            }];
            [weakSelf loadData];
//            [weakSelf buildFootView];
        };
    }
    
    if ([tableViewCell isKindOfClass:[PayMiaozuanDeductCell class]]) {
        PayMiaozuanDeductCell *miaoCell = (PayMiaozuanDeductCell *)tableViewCell;
        miaoCell.miaozuandikouSelected = ^(ShoppingCartItem *item){
//            weakSelf.isOn = isSelected;
            [weakSelf loadData];
//            [weakSelf buildFootView];
        };
    }
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self isEditing]) {
        NSMutableDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
        BOOL isSelected = [dict boolValueForKey:[ShoppingCartTableViewCell cellDictKeyForSeletedInEditMode] defaultValue:NO];
        [dict setObject:[NSNumber numberWithBool:!isSelected] forKey:[ShoppingCartTableViewCell cellDictKeyForSeletedInEditMode]];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[indexPath row] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    } else {
        
        NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        if (ClsTableViewCell == [PayTableViewCell class]) {
            ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
            [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:item.goodsId animated:YES];
        }
    }
}

- (void)$$handleFetchAddressListDidFinishNotification:(id<MBNotification>)notifi addressList:(NSArray*)addressList
{
    self.addressList = [[NSMutableArray alloc] initWithArray:addressList];
    
    if (self.selectedAddressId == -1) {
        for (NSInteger i=0;i<[addressList count];i++) {
            AddressInfo *addressInfo = (AddressInfo*)[addressList objectAtIndex:i];
            if (addressInfo && [addressInfo isDefault]) {
                [self.headerView updateByAddressInfo:addressInfo];
                self.addressInfo = addressInfo;
                [self.tableView reloadData];
                self.selectedAddressId = addressInfo.addressId;
                break;
            }
        }
    }
    WEAKSELF
    if (self.selectedAddressId==-1) {
        AddressInfo *addressInfo = nil;
        if ([addressList count]>0) {
            addressInfo = (AddressInfo*)[addressList objectAtIndex:0];
            self.headerView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
                EditAddressViewController *viewController = [[EditAddressViewController alloc] init];
                viewController.delegate = weakSelf;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
                
            };
        }
        [self.headerView updateByAddressInfo:addressInfo];
        self.addressInfo = addressInfo;
        [self.footerView setAddressInfo:addressInfo];
        [self.tableView reloadData];
    }
}

- (void)$$handleUserDefaultAddressChangedNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    if (self.selectedAddressId == -1) {
        self.selectedAddressId = addressInfo.addressId;
        [self.headerView updateByAddressInfo:addressInfo];
        self.addressInfo = addressInfo;
        [self.footerView setAddressInfo:addressInfo];
    }
}

- (void)$$handleAddAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    if (self.selectedAddressId == -1) {
        self.selectedAddressId = addressInfo.addressId;
        [self.headerView updateByAddressInfo:addressInfo];
        self.addressInfo = addressInfo;
        [self.footerView setAddressInfo:addressInfo];
        [self.tableView reloadData];
    }
    
    WEAKSELF
    self.headerView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        UserAddressViewController *viewController = [[UserAddressViewController alloc] init];
        //        viewController.addressList = [[NSMutableArray alloc] initWithArray:weakSelf.addressList];
        viewController.isForSelectAddress = YES;
        viewController.seletedAddressId = weakSelf.selectedAddressId;
        viewController.handleAddressSelected = ^(UserAddressViewController *viewController, AddressInfo *addressInfo) {
            weakSelf.selectedAddressId = addressInfo.addressId;
            [weakSelf.headerView updateByAddressInfo:addressInfo];
            self.addressInfo = addressInfo;
            [weakSelf.footerView setAddressInfo:addressInfo];
            [self.tableView reloadData];
        };
        [weakSelf.navigationController pushViewController:viewController animated:YES];
        
    };
}

- (void)$$handleRemoveAddressDidFinishNotification:(id<MBNotification>)notifi addressId:(NSNumber*)addressId
{
    if (self.selectedAddressId == [addressId integerValue]) {
        self.selectedAddressId = -1;
        [self.headerView updateByAddressInfo:nil];
    }
}

- (void)$$handleModifyAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    if (self.selectedAddressId == addressInfo.addressId) {
        [self.headerView updateByAddressInfo:addressInfo];
        self.addressInfo = addressInfo;
        [self.footerView setAddressInfo:addressInfo];
        [self.tableView reloadData];
    }
}

- (void)$$handlePayResultCompletionNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    [self handlePayDidFnishBlockImpl:1];
}

- (void)$$handlePayResultCancelNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    [self handlePayDidFnishBlockImpl:0];
}

- (void)$$handlePayResultFailureNotification:(id<MBNotification>)notifi orderIds:(NSArray*)orderIds
{
    [self handlePayDidFnishBlockImpl:0];
}

- (void)handlePayDidFnishBlockImpl:(NSInteger)index {
    [super showProcessingHUD:nil];
//    [self showPaySuccess];
    NSMutableArray *goodsIds = [[NSMutableArray alloc] initWithCapacity:[self.items count]];
    for (ShoppingCartItem *item in self.items) {
        if (item.goodsId) {
            [goodsIds addObject:item.goodsId];
        }
    }
    
    
    
    WEAKSELF;
    _request = [[NetworkAPI sharedInstance] queryGoodsStatus:goodsIds completion:^(NSArray *goodsStatusDictArray) {
        [weakSelf hideHUD];
        NSMutableArray *goodsStatusArray = [[NSMutableArray alloc] initWithCapacity:[goodsStatusDictArray count]];
        for (NSDictionary *dict in goodsStatusDictArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [goodsStatusArray addObject:[GoodsStatusDO createWithDict:dict]];
            }
        }
        
        MBGlobalSendGoodsStatusUpdatedNotification(goodsStatusArray);
        if (weakSelf.handlePayDidFnishBlock) {
            weakSelf.handlePayDidFnishBlock(weakSelf, index);
        }
    } failure:^(XMError *error) {
        
        if (weakSelf.handlePayDidFnishBlock) {
            weakSelf.handlePayDidFnishBlock(weakSelf, index);
        }
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}

@end


@interface PayTableHeaderView ()
@property(nonatomic,strong) UILabel *receiverLbl;
@property(nonatomic,strong) UILabel *phoneNumberLbl;
@property(nonatomic,strong) UILabel *citiesLbl;
@property(nonatomic,strong) UILabel *areaDetailLbl;
@property(nonatomic,strong) UILabel *addressLbl;
@property(nonatomic,strong) UILabel *addAddressLbl;
@property (nonatomic, strong) UIImageView *carView;
@property (nonatomic, strong) UIImageView *rightImage;
@end

@implementation PayTableHeaderView

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, [PayTableHeaderView heightForOrientationPortrait:nil])];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"626879"];
        UIImage * image = [UIImage imageNamed:@"Order_Detail_Address_MF"];
        UIImageView *carView = [[UIImageView alloc] initWithImage:image];
        carView.frame = CGRectMake(15, (self.bounds.size.height-image.size.height)/2, image.size.width, image.size.height);
        [self addSubview:carView];
        self.carView = carView;
        
        _receiverLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _receiverLbl.font = [UIFont boldSystemFontOfSize:15.f];
        _receiverLbl.textColor = [UIColor whiteColor];
        _receiverLbl.text = @"";
        [_receiverLbl sizeToFit];
        [self addSubview:_receiverLbl];
        
        _phoneNumberLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _phoneNumberLbl.font = [UIFont boldSystemFontOfSize:13.f];
        _phoneNumberLbl.textColor = [UIColor whiteColor];
        _phoneNumberLbl.text = @"";
        [_phoneNumberLbl sizeToFit];
        [self addSubview:_phoneNumberLbl];
        
        _citiesLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _citiesLbl.font = [UIFont systemFontOfSize:12.5f];
        _citiesLbl.textColor = [UIColor whiteColor];
        _citiesLbl.text = @"";
        _citiesLbl.numberOfLines = 0;
        [_citiesLbl sizeToFit];
        [self addSubview:_citiesLbl];
        
        _areaDetailLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _areaDetailLbl.font = [UIFont systemFontOfSize:12.5f];
        _areaDetailLbl.textColor = [UIColor whiteColor];
        _areaDetailLbl.text = @"";
        _areaDetailLbl.numberOfLines = 0;
        [_areaDetailLbl sizeToFit];
        [self addSubview:_areaDetailLbl];
        
        _addressLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _addressLbl.font = [UIFont systemFontOfSize:12.5f];
        _addressLbl.textColor = [UIColor whiteColor];
        _addressLbl.text = @"";
        _addressLbl.numberOfLines = 0;
        [_addressLbl sizeToFit];
        [self addSubview:_addressLbl];
        
        _addAddressLbl = [[UILabel alloc] initWithFrame:self.bounds];
        _addAddressLbl.font = [UIFont systemFontOfSize:13.f];
        _addAddressLbl.textColor = [UIColor whiteColor];
        _addAddressLbl.text = @"点击添加收获地址";
        _addAddressLbl.textAlignment = NSTextAlignmentCenter;
        _addAddressLbl.numberOfLines = 0.f;
        [self addSubview:_addAddressLbl];
        
        _rightImage = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImage.image = [UIImage imageNamed:@"Right_Allow_White_MF"];
        [self addSubview:_rightImage];
        
        _phoneNumberLbl.hidden = YES;
        _receiverLbl.hidden = YES;
        _addressLbl.hidden = YES;
        _addAddressLbl.hidden = NO;
    }
    return self;
}

- (void)updateByAddressInfo:(AddressInfo*)addressInfo
{
    if (addressInfo) {
        _phoneNumberLbl.hidden = NO;
        _receiverLbl.hidden = NO;
        _addressLbl.hidden = NO;
        _areaDetailLbl.hidden = NO;
        _citiesLbl.hidden = NO;
        _phoneNumberLbl.text = addressInfo.phoneNumber;
        _receiverLbl.text = addressInfo.receiver;
        _areaDetailLbl.text = [NSString stringWithFormat:@"%@%@",addressInfo.areaDetail,addressInfo.address];
        _citiesLbl.text = addressInfo.areaDetail;
        _addAddressLbl.hidden = YES;
        
    } else {
        _phoneNumberLbl.hidden = YES;
        _receiverLbl.hidden = YES;
        _addressLbl.hidden = YES;
        _addAddressLbl.hidden = NO;
        _areaDetailLbl.hidden = YES;
        _citiesLbl.hidden = YES;
        
    }
    
    CGFloat height = [[self class] calculateAndLayoutSubviews:self addressInfo:addressInfo];
    self.frame = CGRectMake(0, 0, kScreenWidth, height);
}

+ (CGFloat)calculateAndLayoutSubviews:(PayTableHeaderView*)headerView  addressInfo:(AddressInfo*)addressInfo
{
    CGFloat marginLeft = 50;
    CGFloat marginRight = 50.f;
    CGFloat marginTop = 20.f;
    
    NSString *areaDetailString = headerView.areaDetailLbl?headerView.areaDetailLbl.text:addressInfo.areaDetail;
    marginTop += 25;
    
    CGSize areaDetailSize = [areaDetailString sizeWithFont:[UIFont systemFontOfSize:13.f]
                                         constrainedToSize:CGSizeMake(kScreenWidth-marginLeft-marginRight,MAXFLOAT)
                                             lineBreakMode:NSLineBreakByWordWrapping];
    if (headerView) {
        headerView.areaDetailLbl.frame = CGRectMake(marginLeft, marginTop,  kScreenWidth-marginRight-marginLeft, areaDetailSize.height);
    }
    marginTop += areaDetailSize.height;
    
    if (headerView) {
        
        [headerView.receiverLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.mas_top).offset(20);
            make.left.equalTo(headerView.mas_left).offset(50);
        }];
        
        [headerView.phoneNumberLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.receiverLbl.mas_top).offset(1);
            make.left.equalTo(headerView.receiverLbl.mas_right).offset(5);
        }];
        
        [headerView.areaDetailLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(headerView.receiverLbl.mas_bottom).offset(7);
            make.left.equalTo(headerView.mas_left).offset(50);
            make.right.equalTo(headerView.mas_right).offset(-50);
        }];
        
        
        [headerView.rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView.mas_centerY);
            make.right.equalTo(headerView.mas_right).offset(-15);
        }];
        
        [headerView.carView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView.mas_centerY);
            make.left.equalTo(headerView.mas_left).offset(15);
        }];
        
        [headerView.addAddressLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView.mas_centerY);
            make.left.equalTo(headerView.carView.mas_right).offset(15);
        }];
    }
    
    marginTop += 15.f;
    return marginTop;
}

+ (CGFloat)heightForOrientationPortrait:(AddressInfo*)addressInfo
{
    return [self calculateAndLayoutSubviews:nil addressInfo:addressInfo];
}

@end


@interface PayTableFooterView ()
@property(nonatomic,assign) NSInteger totalPrice;
@property(nonatomic,assign) NSInteger reward_money_cent;
@property(nonatomic,assign) NSInteger available_money_cent;

@property(nonatomic,strong) NSArray *quanItemArray;
@property (nonatomic, strong) NSArray *xiHuCardArray;

@property(nonatomic,weak) UIView *payItemsContainerview;

@property(nonatomic,strong) BonusInfo *seletedBonusInfo;
@property (nonatomic, strong) AccountCard *selectAccountCard;

@property(nonatomic,assign) BOOL is_used_reward_money;
@property(nonatomic,assign) BOOL is_used_adm_money;

@property(nonatomic,weak) UIView *bgMaskView;
@property(nonatomic,weak) PayWayListView *listView;
@property(nonatomic,weak) PayTableFooterItemView *itemViewSelected;

@property (nonatomic,weak) PayTableFooterItemView * weakItemView1;
@property (nonatomic,weak) PayTableFooterItemView * weakItemView;
@property (nonatomic,weak) PayTableFooterItemView * weakitemView2;

@property (nonatomic, strong) UIButton *chooseBtn;
@property (nonatomic, strong) UIButton *imageBtn;

@property (nonatomic, assign) NSInteger chooseIndex;
//                    typeof(itemView1) __weak weakItemView1 = itemView1;
//                    typeof(itemView) __weak weakItemView = itemView;

@property (nonatomic, strong) PayWayDO *PWDo;
@property (nonatomic, strong) PayWayDO *PWDo1;
@property (nonatomic, assign) NSInteger chooseTag;


@property (nonatomic, assign) CGFloat itemMarginTop;
@property (nonatomic, assign) CGFloat totalWidth;
@property (nonatomic, assign) CGFloat marginTop;

@property (nonatomic, strong) TTTAttributedLabel *agreementLbl;
@property (nonatomic, strong) PayTableFooterItemView *itemViewPayWay ;
@property (nonatomic, strong) NSArray *items;
@end

@implementation PayTableFooterView {
    
}

- (id)init:(NSInteger)totalPrice reward_money_cent:(NSInteger)reward_money_cent available_money_cent:(NSInteger)available_money_cent
   payWays:(NSArray*)payWays
quanItemArray:(NSArray*)quanItemArray index:(NSInteger)index xiHuCardArray:(NSArray *)xiHuCardArray itemArr:(NSArray *)items{
    self.totalPrice = totalPrice;
    self.reward_money_cent = reward_money_cent;
    self.available_money_cent = available_money_cent;
    self.payWays = payWays;
    self.quanItemArray = quanItemArray;
    self.xiHuCardArray = xiHuCardArray;
    self.items = items;

    if (index == 100) {
        self.index = 100;
    }
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        CGFloat marginTop = 0.f;
        
        CGFloat totalWidth = kScreenWidth;
        
        CALayer *textBg = [CALayer layer];
        textBg.backgroundColor = [UIColor whiteColor].CGColor;
        [self.layer addSublayer:textBg];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithHexString:@"dddddd"].CGColor;
        line.frame = CGRectMake(15, marginTop, totalWidth-30, 0);
        [self.layer addSublayer:line];
        marginTop += line.bounds.size.height;
//        marginTop += 10;
        
        if (self.index == 100) {
            UIButton *chooseBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, marginTop, totalWidth - 30, 28)];
            [chooseBtn setTitle:@"请选择鉴定方式" forState:UIControlStateNormal];
            chooseBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
            [chooseBtn setTitleColor:[UIColor colorWithHexString:@"9e9e9f"] forState:UIControlStateNormal];
//            chooseBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            chooseBtn.layer.borderWidth = 1;
            chooseBtn.layer.borderColor = [UIColor colorWithHexString:@"b4b4b5"].CGColor;
            chooseBtn.layer.masksToBounds = YES;
            chooseBtn.layer.cornerRadius = 10;
            [self addSubview:chooseBtn];
            self.chooseBtn = chooseBtn;
            
            UIButton *imageBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 17, 17)];
            [imageBtn setImage:[UIImage imageNamed:@"Raisal_G_MF"] forState:UIControlStateNormal];
            [imageBtn setImage:[UIImage imageNamed:@"Raisal_S_MF"] forState:UIControlStateSelected];
            [chooseBtn addSubview:imageBtn];
            self.imageBtn = imageBtn;
            marginTop += chooseBtn.bounds.size.height;
            
            marginTop += 15.f;
            
            TTTAttributedLabel *agreementLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(15, marginTop, 0, 0)];
            agreementLbl.delegate = self;
            agreementLbl.font = [UIFont systemFontOfSize:11.f];
            agreementLbl.textColor = [UIColor colorWithHexString:@"282828"];
            agreementLbl.lineBreakMode = NSLineBreakByWordWrapping;
            agreementLbl.userInteractionEnabled = YES;
            agreementLbl.highlightedTextColor = [UIColor colorWithHexString:@"c2a79d"];
            agreementLbl.numberOfLines = 0;
            agreementLbl.linkAttributes = nil;
            [agreementLbl setText:@"已阅读并同意爱丁猫平台交易免责协议" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
                NSRange stringRange = NSMakeRange(mutableAttributedString.length-11,11);
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"c2a79d"] CGColor] range:stringRange];
                return mutableAttributedString;
            }];
            
            [agreementLbl addLinkToURL:[NSURL URLWithString:kURLAgreement] withRange:NSMakeRange([agreementLbl.text length]-4,4)];
            [agreementLbl sizeToFit];
            agreementLbl.frame = CGRectMake((self.bounds.size.width-agreementLbl.bounds.size.width)/2+16, marginTop, agreementLbl.bounds.size.width, agreementLbl.bounds.size.height);
            [self addSubview:agreementLbl];
            
            UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake((self.bounds.size.width-agreementLbl.bounds.size.width)/2, marginTop - 5, agreementLbl.bounds.size.width, agreementLbl.bounds.size.height)];
            [agreeBtn setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateNormal];
            [agreeBtn setImage:[UIImage imageNamed:@"login_check"] forState:UIControlStateSelected];
            [agreeBtn sizeToFit];
            [self addSubview:agreeBtn];
            self.agreeBtn = agreeBtn;
            marginTop += agreementLbl.bounds.size.height;
            
            marginTop += 15;
            
            [agreeBtn addTarget:self action:@selector(clickAgreeBtn) forControlEvents:UIControlEventTouchUpInside];
            [chooseBtn addTarget:self action:@selector(clickChooseBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        
//        UILabel *mailTitleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
//        mailTitleLbl.text = @"邮费（元）：";
//        mailTitleLbl.textColor = [UIColor colorWithHexString:@"181818"];
//        mailTitleLbl.font = [UIFont systemFontOfSize:13.f];
//        [mailTitleLbl sizeToFit];
//        mailTitleLbl.frame = CGRectMake(15, marginTop, mailTitleLbl.width, mailTitleLbl.height);
//        [self addSubview:mailTitleLbl];
//        
//        UILabel *mailPriceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
//        mailPriceLbl.text = @"0";
//        mailPriceLbl.textColor = [UIColor colorWithHexString:@"f44a45"];
//        mailPriceLbl.font = [UIFont systemFontOfSize:13.f];
//        mailPriceLbl.textAlignment = NSTextAlignmentRight;
//        [mailPriceLbl sizeToFit];
//        mailPriceLbl.frame = CGRectMake(15, marginTop, totalWidth-30, mailPriceLbl.height);
//        [self addSubview:mailPriceLbl];
//        
//        marginTop += mailTitleLbl.height;
//        marginTop += 10.f;
//        
//        UILabel *totalPriceTitleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
//        totalPriceTitleLbl.text = @"商品金额小计（元）：";
//        totalPriceTitleLbl.textColor = [UIColor colorWithHexString:@"181818"];
//        totalPriceTitleLbl.font = [UIFont systemFontOfSize:13.f];
//        [totalPriceTitleLbl sizeToFit];
//        totalPriceTitleLbl.frame = CGRectMake(15, marginTop, totalPriceTitleLbl.width, totalPriceTitleLbl.height);
//        [self addSubview:totalPriceTitleLbl];
//        
//        UILabel *totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
//        totalPriceLbl.tag = 200;
//        totalPriceLbl.text = @"0.00";
//        totalPriceLbl.textColor = [UIColor colorWithHexString:@"f44a45"];
//        totalPriceLbl.font = [UIFont systemFontOfSize:13.f];
//        totalPriceLbl.textAlignment = NSTextAlignmentRight;
//        totalPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",((double)_totalPrice)/100.f];
//        [totalPriceLbl sizeToFit];
//        totalPriceLbl.frame = CGRectMake(15, marginTop, totalWidth-30, totalPriceLbl.height);
//        [self addSubview:totalPriceLbl];
//        
//        marginTop += totalPriceTitleLbl.height;
//        
//        marginTop += 15.f;
//        
//        UITextField *textField = [[UIInsetTextField alloc] initWithFrame:CGRectMake(15, marginTop, totalWidth-30, 44)];
//        textField.placeholder = @"给卖家留言";
//        textField.font = [UIFont systemFontOfSize:13.f];
//        textField.textColor = [UIColor colorWithHexString:@"181818"];
//        textField.tag = 100;
//        textField.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
//        [self addSubview:textField];
//        self.textField = textField;
//        marginTop += textField.height;
//        marginTop += 15.f;
        
        double fTotalPrice = (double)_totalPrice/100.f;
        
        if (self.reward_money_cent>0) {
            double reward_money = (double)_reward_money_cent/100.f;
            
            if (fTotalPrice<reward_money) {
                reward_money = fTotalPrice;
            }
            
            line = [CALayer layer];
            line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
            line.frame = CGRectMake(15, marginTop, totalWidth-30, 1);
            [self.layer addSublayer:line];
            marginTop += line.bounds.size.height;
            
            CommandButton *rewardBtn = [[CommandButton alloc] initWithFrame:CGRectMake(15, marginTop, kScreenWidth-30, 44)];
            rewardBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [rewardBtn setTitle:@"奖励现金抵用" forState:UIControlStateNormal];
            [rewardBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
            rewardBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
            [rewardBtn setImage:[UIImage imageNamed:@"reward_checkbox_0"] forState:UIControlStateNormal];
            [rewardBtn setImage:[UIImage imageNamed:@"reward_checkbox_1"] forState:UIControlStateSelected];
            [rewardBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
            rewardBtn.tag = 1200;
            [self addSubview:rewardBtn];
            marginTop += rewardBtn.height;
            
            UILabel *rewardLbl = [[UILabel alloc] initWithFrame:CGRectZero];
            rewardLbl.text = [NSString stringWithFormat:@"- %.2f",reward_money];
            rewardLbl.font = [UIFont systemFontOfSize:13.f];
            rewardLbl.textColor = [UIColor colorWithHexString:@"181818"];
            rewardLbl.textAlignment = NSTextAlignmentRight;
            rewardLbl.frame = rewardBtn.bounds;
            [rewardBtn addSubview:rewardLbl];
            rewardLbl.tag = 100;
            rewardBtn.selected = YES;
            
            self.is_used_reward_money = YES;
            
            WEAKSELF;
            rewardBtn.handleClickBlock = ^(CommandButton *sender){
                sender.selected = !sender.isSelected;
                if (sender.isSelected){
                    [sender setImage:[UIImage imageNamed:@"reward_checkbox_1"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"reward_checkbox_1"] forState:UIControlStateSelected];
                } else {
                    [sender setImage:[UIImage imageNamed:@"reward_checkbox_0"] forState:UIControlStateNormal];
                    [sender setImage:[UIImage imageNamed:@"reward_checkbox_0"] forState:UIControlStateSelected];
                }
                if (weakSelf.handleUsingReward) {
                    weakSelf.handleUsingReward(sender.isSelected);
                }
                
                weakSelf.is_used_reward_money = sender.isSelected;
                
                [weakSelf loadXiHuCard:weakSelf.seletedBonusInfo.bonusId isUseRewardMoney:sender.isSelected completion:^(NSArray *xiHuCardArray) {
                    [weakSelf uploadXihuCell:xiHuCardArray];
                } failure:^(XMError *error) {
                    [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
                }];
                
                [weakSelf updateFooterItemView];
            };
        }
        
        line = [self createLine];
        line.frame = CGRectMake(0, marginTop, totalWidth, 1);
        [self.layer addSublayer:line];
        marginTop += line.bounds.size.height;
        
        textBg.frame = CGRectMake(0, 0, kScreenWidth, marginTop);
        
        marginTop += 12.f;
        
        WEAKSELF;
//        PayDetermineView *determineView = [[PayDetermineView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 60)];
//        determineView.backgroundColor = [UIColor whiteColor];
//        [self addSubview:determineView];
//        marginTop += determineView.height;
//        marginTop += 15.f;
//        determineView.chooseDetermine = ^(BOOL isSelected){
//            NSLog(@"%d", isSelected);
//            weakSelf.isDetermine = isSelected;
//        };
//        weakSelf.isDetermine = 1;
        
        BOOL needAddSepLine = NO;
        if (self.quanItemArray && self.quanItemArray.count>0) {
            line = [self createLine];
            line.frame = CGRectMake(0, marginTop, totalWidth, 1);
            [self.layer addSublayer:line];
            marginTop += line.bounds.size.height;
            
            PayTableFooterItemView *itemViewQuan = [[PayTableFooterItemView alloc] init:@"pay_icon_quan" title:@"优惠券" subTitle:@"未使用" isCanSelected:NO indicatorTitle:[NSString stringWithFormat:@"%lu张可用",(unsigned long)self.quanItemArray.count]];
            itemViewQuan.frame = CGRectMake(0, marginTop, totalWidth, 44);
            itemViewQuan.tag = 600;
            [self addSubview:itemViewQuan];
            marginTop += itemViewQuan.height;
            
            if (self.xiHuCardArray && self.xiHuCardArray.count>0) {
                UIView *aidingmaoSmallLineView = [[UIView alloc] initWithFrame:CGRectMake(12, marginTop, kScreenWidth-12, 1)];
                aidingmaoSmallLineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
                [self addSubview:aidingmaoSmallLineView];
                marginTop += aidingmaoSmallLineView.height;
            } else {
                UIView *aidingmaoLineView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 12)];
                aidingmaoLineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
                [self addSubview:aidingmaoLineView];
                marginTop += aidingmaoLineView.height;
            }
            
            for (int i = 0 ; i < self.quanItemArray.count; i++) {
                BonusInfo *info = self.quanItemArray[i];
                if (!self.seletedBonusInfo) {
                    self.seletedBonusInfo = info;
                } else {
                    if (self.seletedBonusInfo.amountCent > info.amountCent) {
                        
                    } else {
                        self.seletedBonusInfo = info;
                    }
                }
                
                if (i == self.quanItemArray.count - 1) {
                    if (self.seletedBonusInfo && [self.seletedBonusInfo isKindOfClass:[BonusInfo class]]) {
                        PayTableFooterItemView *itemViewQuanTmp = (PayTableFooterItemView*)[weakSelf viewWithTag:600];
                        //                            itemViewQuanTmp.subTitle = bonusInfo.bonusDesc;
                        itemViewQuanTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元",((double)self.seletedBonusInfo.amountCent)/100.f];
                        if (weakSelf.handleUsingQuan) {
                            weakSelf.handleUsingQuan(weakSelf.seletedBonusInfo);
                        }
                        [weakSelf updateFooterItemView];
                    }
                }
            }
            
            //优惠券点击方法
            itemViewQuan.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
                PayQuanViewController *viewController = [[PayQuanViewController alloc] init];
                viewController.quanItemList = [NSMutableArray arrayWithArray:weakSelf.quanItemArray];
                viewController.seletedBonusInfo = weakSelf.seletedBonusInfo;
                viewController.isHaveUnableLbl = NO;
                viewController.handleDidSelectBonusInfo = ^(PayQuanViewController *viewController, BonusInfo *bonusInfo) {
                    PayTableFooterItemView *itemViewQuanTmp = (PayTableFooterItemView*)[weakSelf viewWithTag:600];
                    //itemViewQuanTmp.subTitle = bonusInfo.bonusDesc;
                    
                    [weakSelf loadXiHuCard:bonusInfo.bonusId isUseRewardMoney:weakSelf.is_used_reward_money completion:^(NSArray *xiHuCardArray) {
//                        if (weakSelf.changeXihuCardArr) {
//                            weakSelf.changeXihuCardArr(xiHuCardArray);
//                        }
                        [weakSelf uploadXihuCell:xiHuCardArray];
                    } failure:^(XMError *error) {
                        [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
                    }];
                    
                    if ([bonusInfo.bonusId isEqualToString:@"-1000"]) {
                        itemViewQuanTmp.subTitle = @"未使用";
                    } else {
                        itemViewQuanTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元",((double)bonusInfo.amountCent)/100.f];
                    }
                    
                    if (weakSelf.handleUsingQuan) {
                        weakSelf.handleUsingQuan(bonusInfo);
                    }
                    weakSelf.seletedBonusInfo = bonusInfo;
                    [weakSelf updateFooterItemView];
                    [viewController dismiss];
                };
                [weakSelf.viewController pushViewController:viewController animated:YES];
            };
            needAddSepLine = YES;
        }
        
        if (self.xiHuCardArray && self.xiHuCardArray.count>0) {
            PayTableFooterItemView *itemViewXiHuCard = [[PayTableFooterItemView alloc] init:@"xihuCard" title:@"消费卡" subTitle:@"未使用" isCanSelected:NO indicatorTitle:[NSString stringWithFormat:@"%lu张可用",(unsigned long)self.xiHuCardArray.count]];
            itemViewXiHuCard.frame = CGRectMake(0, marginTop, totalWidth, 60);
            itemViewXiHuCard.tag = 700;
            [self addSubview:itemViewXiHuCard];
            marginTop += itemViewXiHuCard.height;
            
            UIView *aidingmaoLineView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 12)];
            aidingmaoLineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
            [self addSubview:aidingmaoLineView];
            marginTop += aidingmaoLineView.height;
            
            for (int i = 0 ; i < self.xiHuCardArray.count; i++) {
                AccountCard *card = self.xiHuCardArray[i];
                if (!self.selectAccountCard) {
                    self.selectAccountCard = card;
                } else {
                    if (self.selectAccountCard.cardCanPayMoney > card.cardCanPayMoney) {
                        
                    } else {
                        self.selectAccountCard = card;
                    }
                }
                
                if (i == self.xiHuCardArray.count - 1) {
                    if (self.selectAccountCard && [self.selectAccountCard isKindOfClass:[AccountCard class]]) {
                        PayTableFooterItemView *itemViewQuanTmp = (PayTableFooterItemView*)[weakSelf viewWithTag:700];
                        //                            itemViewQuanTmp.subTitle = bonusInfo.bonusDesc;
                        itemViewQuanTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元", self.selectAccountCard.cardCanPayMoney];
                        if (weakSelf.handleUsingXihuCard) {
                            weakSelf.handleUsingXihuCard(weakSelf.selectAccountCard);
                        }
                        [weakSelf updateFooterItemView];
                    }
                }
            }
            
            itemViewXiHuCard.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer){
                PayXiHuCardViewController *cardViewController = [[PayXiHuCardViewController alloc] init];
                cardViewController.xiHuCardArray = [[NSMutableArray alloc] initWithArray:weakSelf.xiHuCardArray];
                if (weakSelf.selectAccountCard) {
                    
                } else {
                    weakSelf.selectAccountCard = [[AccountCard alloc] init];
                    weakSelf.selectAccountCard.cardType = -1000;
                }
                cardViewController.selectAccountCard = weakSelf.selectAccountCard;
                
                cardViewController.selectedAccountCard = ^(PayXiHuCardViewController *controller, AccountCard *accountCard){
                     PayTableFooterItemView *itemViewXihuTmp = (PayTableFooterItemView*)[weakSelf viewWithTag:700];
                    if (accountCard.cardType == -1000) {
                        itemViewXihuTmp.subTitle = @"未使用";
                    } else {
                        itemViewXihuTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元", accountCard.cardCanPayMoney];
                    }
                    
                    if (weakSelf.handleUsingXihuCard) {
                        weakSelf.handleUsingXihuCard(accountCard);
                    }
                    
                    weakSelf.selectAccountCard = accountCard;
                    [weakSelf updateFooterItemView];
                    [controller dismiss];
                };
                
                [weakSelf.viewController pushViewController:cardViewController animated:YES];
            };
        }
        
        if (self.available_money_cent>0) {
            
//            double availableMoney = ((double)_available_money_cent)/100.f;
//            
//            line = [self createLine];
//            line.frame = CGRectMake(0, marginTop, totalWidth, 1);
//            [self.layer addSublayer:line];
//            marginTop += line.bounds.size.height;
//            
//            PayTableFooterItemView *itemViewAidingmao = [[PayTableFooterItemView alloc] init:@"pay_icon_aidingmiao" title:@"爱丁猫钱包（无限额）" subTitle:[NSString stringWithFormat:@"- %.2f (%.2f元可用)",availableMoney,availableMoney] isCanSelected:YES indicatorTitle:nil];
//            itemViewAidingmao.frame = CGRectMake(0, marginTop, totalWidth, 44);
//            itemViewAidingmao.tag = 1300;
//            [self addSubview:itemViewAidingmao];
//            itemViewAidingmao.selected = YES;
//            marginTop += itemViewAidingmao.height;
            
            self.is_used_adm_money = YES;
            
//            itemViewAidingmao.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//                PayTableFooterItemView *tmp = ((PayTableFooterItemView*)view);
//                [tmp setSelected:![tmp selected]];
//                if (weakSelf.handleUsingAdmMoney) {
//                    weakSelf.handleUsingAdmMoney([tmp selected]);
//                }
//                weakSelf.is_used_adm_money = [tmp selected];
//                [weakSelf updateFooterItemView];
//            };
//            needAddSepLine = YES;
        }
        
        if (needAddSepLine) {
            line = [self createLine];
            line.frame = CGRectMake(12, marginTop, totalWidth-24, 0.5);
            [self.layer addSublayer:line];
            marginTop += line.bounds.size.height;
        }
        
//        marginTop += 15.f;
        
        UIView *payItemsContainerview = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, totalWidth, 0)];
        [self addSubview:payItemsContainerview];
        _payItemsContainerview = payItemsContainerview;
        
        CGFloat itemMarginTop = 0.f;
        
        
        self.itemMarginTop = itemMarginTop;
        self.totalWidth = totalWidth;
        self.marginTop = marginTop;
        if ([self.payWays count]>0) {
            line = [self createLine];
            line.frame = CGRectMake(0, itemMarginTop, totalWidth, 1);
            [_payItemsContainerview.layer addSublayer:line];
            itemMarginTop += line.bounds.size.height;
            
            PayWayDO *payWayDOAlipay = nil;
            for (PayWayDO *payWayDO in self.payWays) {
                if (payWayDO.pay_way==PayWayAlipay) {
                    payWayDOAlipay = payWayDO;
                }
            }
            PayWayDO *PWDo = nil;
            PayWayDO *PWDo1 = nil;
            if (self.payWays.count > 0) {
                PWDo = self.payWays[0];
                self.PWDo = PWDo;
            }
            if (self.payWays.count > 0) {
                PWDo1 = self.payWays[1];
                self.PWDo1 = PWDo1;
            }
            
            //支付调整为平铺
            if (self.payWays && self.payWays.count > 0) {
                _payWayDOSelected = self.payWays[0];
                int i = 0;
                for (PayWayDO *payWayDO in self.payWays) {
                    PayTableFooterItemView *itemView = [[PayTableFooterItemView alloc] init:payWayDO.icon_url placeHolder:[payWayDO localIconName] title:payWayDO.pay_name payDo:payWayDO];;
                    itemView.frame = CGRectMake(0, itemMarginTop, totalWidth, 60);
                    itemView.tag = payWayDO.pay_way;//payWayDOAlipay.pay_way;
                    itemView.available_money_cent = self.available_money_cent;
                    [itemView getTitlePriceCent:self.totalPrice available_money_cent:self.available_money_cent];
                    [_payItemsContainerview addSubview:itemView];
                    itemMarginTop += itemView.height;
//                    weakSelf.chooseTag = 1;
                    itemView.tag = i;
                    if (i == 0) {
                        _itemViewSelected = itemView;
                        [itemView setSelected:YES];
                    }
                    
                    line = [self createLine];
                    line.frame = CGRectMake(12, itemMarginTop, totalWidth-24, 0.5);
                    [_payItemsContainerview.layer addSublayer:line];
                    itemMarginTop += line.bounds.size.height;
                    
                    self.weakItemView = itemView;
                    //                [[itemView viewWithTag:300] removeFromSuperview];
                    itemView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
                        PayTableFooterItemView *footerItemView = (PayTableFooterItemView *)view;
                        [footerItemView setSelected:YES];
                        for (PayTableFooterItemView *footerView in _payItemsContainerview.subviews) {
                            if (footerItemView.tag != footerView.tag) {
                                [footerView setSelected:NO];
                            }
                        }
//                        [self.weakItemView1 setSelected:NO];
//                        [self.weakitemView2 setSelected:NO];
//                        weakSelf.chooseTag = 1;
                        _itemViewSelected = footerItemView;
                        _payWayDOSelected = payWayDO;
                        if (weakSelf.handlePayWayChangedBlock1) {
                            weakSelf.handlePayWayChangedBlock1(_payWayDOSelected.pay_way);
                        }
                    };
                    i++;
                }
            }
            
//            if (PWDo) {
//                _payWayDOSelected = PWDo;//payWayDOAlipay;
//                
//                PayTableFooterItemView *itemView = [[PayTableFooterItemView alloc] init:PWDo.icon_url placeHolder:[PWDo localIconName] title:PWDo.pay_name payDo:PWDo];;
//                itemView.frame = CGRectMake(0, itemMarginTop, totalWidth, 44);
//                itemView.tag = PWDo.pay_way;//payWayDOAlipay.pay_way;
//                itemView.available_money_cent = self.available_money_cent;
//                [itemView getTitlePriceCent:self.totalPrice available_money_cent:self.available_money_cent];
//                [_payItemsContainerview addSubview:itemView];
//                itemMarginTop += itemView.height;
//                weakSelf.chooseTag = 1;
//                _itemViewSelected = itemView;
//                
//                line = [self createLine];
//                line.frame = CGRectMake(12, itemMarginTop, totalWidth-24, 0.5);
//                [_payItemsContainerview.layer addSublayer:line];
//                itemMarginTop += line.bounds.size.height;
//                
//                [itemView setSelected:YES];
//                self.weakItemView = itemView;
//                //                [[itemView viewWithTag:300] removeFromSuperview];
//                itemView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//                    [self.weakItemView setSelected:YES];
//                    [self.weakItemView1 setSelected:NO];
//                    [self.weakitemView2 setSelected:NO];
//                    weakSelf.chooseTag = 1;
//                    _itemViewSelected = itemView;
//                    _payWayDOSelected = PWDo;
//                    if (weakSelf.handlePayWayChangedBlock1) {
//                        weakSelf.handlePayWayChangedBlock1(PWDo1.pay_way);
//                    }
//                };
//                
//                //                [[itemView viewWithTag:300] removeFromSuperview];
//            }
//            
//            
//            
//            if (PWDo1) {
//                PayTableFooterItemView *itemView1 = [[PayTableFooterItemView alloc] init:PWDo1.icon_url placeHolder:[PWDo1 localIconName] title:PWDo1.pay_name payDo:PWDo1];;
//                itemView1.frame = CGRectMake(0, itemMarginTop, totalWidth, 44);
//                itemView1.tag = PWDo1.pay_way;//payWayDOAlipay.pay_way;
//                itemView1.available_money_cent = self.available_money_cent;
//                [itemView1 getTitlePriceCent:self.totalPrice available_money_cent:self.available_money_cent];
//                [_payItemsContainerview addSubview:itemView1];
//                itemMarginTop += itemView1.height;
//                
//                line = [self createLine];
//                line.frame = CGRectMake(12, itemMarginTop, totalWidth-24, 0.5);
//                [_payItemsContainerview.layer addSublayer:line];
//                itemMarginTop += line.bounds.size.height;
//                
//                [itemView1 setSelected:NO];
//                
//                self.weakItemView1 = itemView1;
//                //                    typeof(itemView1) __weak weakItemView1 = itemView1;
//                //                    typeof(itemView) __weak weakItemView = itemView;
//                itemView1.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//                    [self.weakItemView setSelected:NO];
//                    [self.weakItemView1 setSelected:YES];
//                    [self.weakitemView2 setSelected:NO];
//                    weakSelf.chooseTag = 2;
//                    _itemViewSelected = itemView1;
//                    _payWayDOSelected = PWDo1;
//                    if (weakSelf.handlePayWayChangedBlock1) {
//                        weakSelf.handlePayWayChangedBlock1(PWDo.pay_way);
//                    }
//                };
//                
//                PayTableFooterItemView *itemViewPayWay = [[PayTableFooterItemView alloc] init:nil title:@"更多付款方式" subTitle:@"" isCanSelected:NO indicatorTitle:nil];
//                self.itemViewPayWay = itemViewPayWay;
//                itemViewPayWay.frame = CGRectMake(0, itemMarginTop, totalWidth, 44);
//                //                itemViewPayWay.tag = 800;
//                [_payItemsContainerview addSubview:itemViewPayWay];
//                itemMarginTop += itemViewPayWay.height;
//                itemViewPayWay.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//                    [weakSelf toggleListView:NO];
//                };
//                
//                line = [self createLine];
//                line.frame = CGRectMake(0, itemMarginTop, totalWidth, 1);
//                [_payItemsContainerview.layer addSublayer:line];
//                itemMarginTop += line.bounds.size.height;
//                
//                
//                
//            } else {
//                for (PayWayDO *payWayDO in self.payWays) {
//                    PayTableFooterItemView *itemView = [[PayTableFooterItemView alloc] init:payWayDO.icon_url placeHolder:[payWayDO localIconName] title:payWayDO.pay_name payDo:payWayDO];;
//                    itemView.frame = CGRectMake(0, itemMarginTop, totalWidth, 44);
//                    itemView.tag = payWayDO.pay_way;
//                    itemView.available_money_cent = self.available_money_cent;
//                    itemView.titlePriceCent = self.totalPrice;
//                    [itemView getTitlePriceCent:self.totalPrice available_money_cent:self.available_money_cent];
//                    [_payItemsContainerview addSubview:itemView];
//                    itemMarginTop += itemView.height;
//                    
//                    line = [self createLine];
//                    line.frame = CGRectMake(0, itemMarginTop, totalWidth, 1);
//                    [_payItemsContainerview.layer addSublayer:line];
//                    itemMarginTop += line.bounds.size.height;
//                    
//                    if (payWayDO.pay_way==PayWayWxpay) {
//                        [itemView setSelected:YES];
//                    }
//                    itemView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//                        NSArray *subiews = [weakSelf.payItemsContainerview subviews];
//                        for (PayTableFooterItemView *subview in subiews) {
//                            if (subview==view) {
//                                [subview setSelected:YES];
//                            } else {
//                                [subview setSelected:NO];
//                            }
//                        }
//                    };
//                }
//            }
        }
        
        _payItemsContainerview.frame = CGRectMake(0, marginTop, totalWidth, itemMarginTop);
        
        marginTop += _payItemsContainerview.height;
        marginTop += 15;
        
        TTTAttributedLabel *agreementLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 10)];
        agreementLbl.delegate = self;
        agreementLbl.font = [UIFont systemFontOfSize:12.f];
        agreementLbl.textColor = [UIColor colorWithHexString:@"c6c6c6"];
        agreementLbl.lineBreakMode = NSLineBreakByWordWrapping;
        agreementLbl.userInteractionEnabled = YES;
        agreementLbl.highlightedTextColor = [UIColor colorWithHexString:@"4d4d4d"];
        agreementLbl.numberOfLines = 0;
        agreementLbl.linkAttributes = nil;
        [agreementLbl setText:@" 已阅读并同意《爱丁猫原价回购协议》" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange stringRange = NSMakeRange(mutableAttributedString.length-11,11);
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"4d4d4d"] CGColor] range:stringRange];
            return mutableAttributedString;
        }];
        
        [agreementLbl addLinkToURL:[NSURL URLWithString:kUrlAgreeDingDan] withRange:NSMakeRange([agreementLbl.text length]-11,11)];
        [agreementLbl sizeToFit];
        agreementLbl.frame = CGRectMake((kScreenWidth-agreementLbl.width)/2, marginTop, agreementLbl.width, agreementLbl.height);
        [self addSubview:agreementLbl];
        
        UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 10)];
        [agreeBtn setImage:[UIImage imageNamed:@"UnAgree_PayView_MF"] forState:UIControlStateNormal];
        [agreeBtn setImage:[UIImage imageNamed:@"Agree_PayView_MF"] forState:UIControlStateSelected];
        [agreeBtn sizeToFit];
        agreeBtn.frame = CGRectMake(agreementLbl.left - agreeBtn.width - 2, marginTop-5, agreeBtn.width, agreeBtn.height);
        [self addSubview:agreeBtn];
        agreeBtn.selected = YES;
        self.selectedIndex = 1;
        [agreeBtn addTarget:self action:@selector(clickAgreeBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        self.agreementLbl = agreementLbl;
        self.agreeBtn = agreeBtn;
        
        if ((self.goodsInfo.supportType & GOODSINDEX) == GOODSINDEX) {
            agreementLbl.hidden = NO;
            agreeBtn.hidden = NO;
        } else {
            agreementLbl.hidden = YES;
            agreeBtn.hidden = YES;
        }
        
        marginTop += agreementLbl.height;

        UILabel * addressInfo = [[UILabel alloc] initWithFrame:CGRectMake(0, marginTop, kScreenWidth, 36)];
        addressInfo.font = [UIFont systemFontOfSize:15];
        addressInfo.textColor = [UIColor colorWithHexString:@"ffffff"];
        addressInfo.tag = 20170327;
        addressInfo.backgroundColor = [UIColor colorWithHexString:@"626879"];
        [self addSubview:addressInfo];
        
        [self updateFooterItemView];
        
        
        marginTop += 36;
        self.frame = CGRectMake(0, 0, kScreenWidth, marginTop);
        
        
    }
    return self;
}

- (void)setAddressInfo:(AddressInfo *)addressInfo{
    if (addressInfo) {
        _addressInfo = addressInfo;
        UILabel * lbl = [self viewWithTag:20170327];
        lbl.text = [NSString stringWithFormat:@"   寄到: %@%@",addressInfo.areaDetail,addressInfo.address];
    }
}

-(void)uploadXihuCell:(NSArray *)xiHuCardArray{
    
    self.xiHuCardArray = xiHuCardArray;
    
    for (int i = 0 ; i < xiHuCardArray.count; i++) {
        AccountCard *card = xiHuCardArray[i];
        if (!self.selectAccountCard) {
            self.selectAccountCard = card;
        } else {
            if (self.selectAccountCard.cardCanPayMoney > card.cardCanPayMoney) {
                
            } else {
                self.selectAccountCard = card;
            }
        }
        
        if (i == xiHuCardArray.count - 1) {
            if (self.selectAccountCard && [self.selectAccountCard isKindOfClass:[AccountCard class]]) {
                PayTableFooterItemView *itemViewQuanTmp = (PayTableFooterItemView*)[self viewWithTag:700];
                //                            itemViewQuanTmp.subTitle = bonusInfo.bonusDesc;
                itemViewQuanTmp.subTitle = [NSString stringWithFormat:@"已抵用%.2f元", card.cardCanPayMoney];
                if (self.handleUsingXihuCard) {
                    self.handleUsingXihuCard(card);
                }
                [self updateFooterItemView];
            }
        }
    }
    
}

-(void)loadXiHuCard:(NSString *)bonusId isUseRewardMoney:(NSInteger)isUseRewardMoney completion:(void (^)(NSArray *xiHuCardArray))completion failure:(void (^)(XMError *error))failure {
    WEAKSELF;
    NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
    for (ShoppingCartItem *item in weakSelf.items) {
        if (item.meowReduceVo == nil) {
            item.is_use_meow = 0;
        }
        if (item.serviceVo == nil) {
            item.is_use_jdvo = 0;
        }
        [goodsIds addObject:@{@"goods_id":item.goodsId,@"is_use_meow":@(item.is_use_meow)}];
    }
    NSString *bonusId1 = [[NSString alloc] init];
    if ([bonusId isEqualToString:@"-1000"]) {
        bonusId1 = nil;
    } else {
        bonusId1 = bonusId;
    }
    HTTPRequest *request = [[NetworkAPI sharedInstance] listXiHuCardByGoodsList:goodsIds brandId:bonusId1 isUseRewardMoney:isUseRewardMoney completion:^(NSArray *itemList) {
        NSMutableArray *xiHuCardArray = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in itemList) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [xiHuCardArray addObject:[[AccountCard alloc] initWithJSONDictionary:dict]];
            }
        }
        if (completion) {
            completion(xiHuCardArray);
        }
    } failure:^(XMError *error) {
        if (failure)failure(error);
    }];
    [[NetworkManager sharedInstance] addRequest:request];
}


-(void)loadChooseView{
    
//    if (self.chooseTag == 1) {
//        self.itemViewPayWay.frame = CGRectMake(0, self.weakItemView.bottom+1, kScreenWidth, 44);
//    } else {
//        self.weakItemView1.frame = CGRectMake(-100, 0, kScreenWidth, 44);
//        self.itemViewPayWay.frame = CGRectMake(0, self.itemMarginTop, kScreenWidth, 44);
//    }
    
    
//    self.agreementLbl.frame = CGRectMake((kScreenWidth-self.agreementLbl.width)/2, self.itemViewPayWay.bottom+5, self.agreementLbl.width, self.agreementLbl.height);
//    self.agreeBtn.frame = CGRectMake(self.agreementLbl.left - self.agreeBtn.width - 2, self.agreementLbl.bottom-50, self.agreeBtn.width, self.agreeBtn.height);
//    if (self.PWDo) {
//        self.weakItemView.frame = CGRectMake(0, 0, self.totalWidth, 44);
//        self.itemMarginTop +=  self.weakItemView.height;
//    }
//    if (self.PWDo1) {
//        self.weakItemView1.frame = CGRectMake(0, 0, self.totalWidth, 44);
//        self.itemMarginTop +=  self.weakItemView1.height;
//    }

}

//爱丁猫回购协议H5
- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    if ([self.delegate respondsToSelector:@selector(attributedLabelSelect:)]) {
        [self.delegate attributedLabelSelect:url];
    }
}

-(void)clickAgreeBtn:(UIButton *)sender{
    if (sender.selected == YES) {
        self.selectedIndex = 0;
        sender.selected = NO;
    } else {
        self.selectedIndex = 1;
        sender.selected = YES;
    }
}

-(void)clickAgreeBtn{
    if (self.agreeBtn.selected == YES) {
        self.agreeBtn.selected = NO;
    } else {
        self.agreeBtn.selected = YES;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"judge" object:self.agreeBtn];
}

-(void)clickChooseBtn{
    WEAKSELF;
    NSArray *arr = [NSArray arrayWithObjects:@"无需爱丁猫鉴定，卖家直接寄给我", @"爱丁猫鉴定后再发货给我", nil];
    [UIActionSheet showInView:self
                    withTitle:nil
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:arr
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         
                         if (buttonIndex == 0) {
                             [weakSelf.chooseBtn setTitle:arr[0] forState:UIControlStateNormal];
                             [weakSelf.chooseBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
                             weakSelf.imageBtn.selected = NO;
                             
                             weakSelf.chooseIndex = 1;
                         } else if (buttonIndex == 1) {
                             [weakSelf.chooseBtn setTitle:arr[1] forState:UIControlStateNormal];
                             [weakSelf.chooseBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
                             weakSelf.imageBtn.selected = YES;
                             weakSelf.chooseIndex = 1;
                         }  else if (buttonIndex == 2) {
                             
                         };
                         
                         [[NSNotificationCenter defaultCenter] postNotificationName:@"judgeChooseBtn" object:[NSNumber numberWithInteger:buttonIndex]];
                     }];
}

- (void)updateFooterItemView {
    
    PayTableFooterItemView *itemViewAidingmao = (PayTableFooterItemView*)[self viewWithTag:1300];
    
    WEAKSELF;
    NSInteger totalPriceCent = _totalPrice;
    
    NSInteger realTotalPriceCent = totalPriceCent;
    //1. 先判断优惠券
    if (weakSelf.seletedBonusInfo) {
        if ([weakSelf.seletedBonusInfo.bonusId isEqualToString:@"-1000"]) {
            
        } else {
            realTotalPriceCent = realTotalPriceCent-weakSelf.seletedBonusInfo.amountCent;
            if (realTotalPriceCent<0)realTotalPriceCent=0;
        }
    }
    //优惠卡
    if (weakSelf.selectAccountCard) {
        if (weakSelf.selectAccountCard.cardType == -1000) {
            
        } else {
            realTotalPriceCent = realTotalPriceCent-weakSelf.selectAccountCard.cardCanPayMoney*100;
            if (realTotalPriceCent<0)realTotalPriceCent=0;
        }
    }
    //2. 奖金抵用
    if (weakSelf.is_used_reward_money && realTotalPriceCent>0) {
        realTotalPriceCent = realTotalPriceCent-weakSelf.reward_money_cent;
        if (realTotalPriceCent<0)realTotalPriceCent=0;
    }
    
    //3. 余额
    double availableMoney = ((double)_available_money_cent)/100.f;
    if (weakSelf.payWay == PayWayAdmMoney && realTotalPriceCent>0) {//weakSelf.is_used_adm_money
        if (realTotalPriceCent>weakSelf.available_money_cent) {
            itemViewAidingmao.subTitle = [NSString stringWithFormat:@"- %.2f (%.2f元可用)",availableMoney,availableMoney];
        } else {
            itemViewAidingmao.subTitle = [NSString stringWithFormat:@"- %.2f (%.2f元可用)",(double)(realTotalPriceCent)/100.f,availableMoney];
        }
    } else {
        itemViewAidingmao.subTitle = [NSString stringWithFormat:@"- 0.0 (%.2f元可用)",availableMoney];
    }
}

- (CALayer*)createLine {
    CALayer *line = [CALayer layer];
    line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    line.frame = CGRectMake(0, 0, kScreenWidth, 1);
    return line;
}

- (NSString*)message {
    UITextField *textField = (UITextField*)[self viewWithTag:100];
    return textField.text;
}

-(NSInteger)isPartialPay{
    
    if (self.payWayDOSelected.pay_way == PayWayPartial) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)payWay {
    WEAKSELF;
//    if ([((PayTableFooterItemView*)[weakSelf viewWithTag:300]) selected]) {
//        return PayWayUpay;
//    } else if ([((PayTableFooterItemView*)[weakSelf viewWithTag:700]) selected]) {
//        return PayWayWxpay;
//    }
//    return PayWayAlipay;
    if (weakSelf.payWayDOSelected) {
        return weakSelf.payWayDOSelected.pay_way;
    }
    
    for (PayTableFooterItemView *itemView in [_payItemsContainerview subviews]) {
        if ([itemView selected]) {
            return itemView.tag;
        }
    }
    //默认返回阿里pay
    return PayWayAlipay;
}


- (void)toggleListView:(BOOL)hidden {
    WEAKSELF;
    if (hidden) {
        if (_listView) {
            WEAKSELF;
            CGRect endFrame = CGRectMake(0, kScreenHeight, weakSelf.listView.width, weakSelf.listView.height);
            [UIView animateWithDuration:0.3f animations:^{
                weakSelf.listView.frame = endFrame;
                weakSelf.bgMaskView.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
            } completion:^(BOOL finished) {
                weakSelf.listView.frame = endFrame;
                weakSelf.listView.hidden = YES;
                [weakSelf.listView removeFromSuperview];
                [weakSelf.bgMaskView removeFromSuperview];
            }];
        }
    } else {
        
        TapDetectingView *bgMaskView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        bgMaskView.backgroundColor  =[UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        [self.viewController.view addSubview:bgMaskView];
        _bgMaskView = bgMaskView;
        
        bgMaskView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [weakSelf toggleListView:YES];
        };
        
        PayWayListView *listView = [[PayWayListView alloc] initWithFrame:CGRectMake(0, kScreenHeight-314, kScreenWidth, 314) payWayArray:self.payWays defaultPayWay:_payWayDOSelected.pay_way];
        listView.backgroundColor = [UIColor whiteColor];
        listView.hidden = YES;
        [[listView layer] setShadowOffset:CGSizeMake(1, 1)];
        [[listView layer] setShadowRadius:5];
        [[listView layer] setShadowOpacity:1];
        [[listView layer] setShadowColor:[UIColor blackColor].CGColor];
        [self.viewController.view addSubview:listView];
        _listView = listView;
        
        listView.handleBackClickedBlock = ^(PayWayListView *listView) {
            [weakSelf toggleListView:YES];
        };
        listView.handlePayWayChangedBlock = ^(PayWayListView *listView, NSInteger payWay) {
            
            for (PayWayDO *payWayDO in weakSelf.payWays) {
                if (payWayDO.pay_way==payWay) {
                    weakSelf.payWayDOSelected = payWayDO;
                    break;
                }
            }
            if (weakSelf.payWayDOSelected) {
                PayTableFooterItemView *itemView = [[PayTableFooterItemView alloc] init:weakSelf.payWayDOSelected.icon_url placeHolder:[weakSelf.payWayDOSelected localIconName] title:weakSelf.payWayDOSelected.pay_name payDo:weakSelf.payWayDOSelected];;
                itemView.frame = weakSelf.itemViewSelected.frame;
                itemView.tag = weakSelf.payWayDOSelected.pay_way;
                itemView.available_money_cent = weakSelf.available_money_cent;
                [itemView getTitlePriceCent:self.totalPrice available_money_cent:self.available_money_cent];
                [weakSelf.payItemsContainerview addSubview:itemView];
                
                [weakSelf.itemViewSelected setSelected:NO];
                [weakSelf.itemViewSelected removeFromSuperview];
//                if (weakSelf.chooseTag == 1) {
//                    [weakSelf.weakItemView1 removeFromSuperview];
//                    weakSelf.PWDo1 = nil;
//                    [weakSelf loadChooseView];
//                } else {
//                    [weakSelf.weakItemView removeFromSuperview];
//                    weakSelf.PWDo = nil;
//                    [weakSelf loadChooseView];
//                }
                weakSelf.itemViewSelected = itemView;
                [itemView setSelected:YES];
                
                
//                [[itemView viewWithTag:300] removeFromSuperview];
                
//                PayWayDO *PWDo = nil;
//                PayWayDO *PWDo1 = nil;
                
                
                typeof(itemView) __weak weakItemView = itemView;
                weakSelf.weakitemView2 = weakItemView;
                itemView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
                    [weakSelf.weakItemView setSelected:NO];
                    [weakSelf.weakItemView1 setSelected:NO];
                    [weakSelf.weakitemView2 setSelected:NO];
                    _itemViewSelected = itemView;
                    _payWayDOSelected = weakSelf.payWayDOSelected;
                    [weakItemView setSelected:YES];
                    if (weakSelf.handlePayWayChangedBlock1) {
                        weakSelf.handlePayWayChangedBlock1(self.payWayDOSelected.pay_way);
                    }
                };
            }
            
            if (weakSelf.handleUsingAdmMoney) {
                weakSelf.handleUsingAdmMoney(payWay);
            }
//            weakSelf.is_used_adm_money = [tmp selected];
            [weakSelf updateFooterItemView];
            
            [weakSelf toggleListView:YES];
        };
        
        CGRect beginFrame = CGRectMake(0, kScreenHeight, weakSelf.listView.width, weakSelf.listView.height);
        CGRect endFrame = CGRectMake(0, weakSelf.listView.top, weakSelf.listView.width, weakSelf.listView.height);
        weakSelf.listView.frame = beginFrame;
        weakSelf.listView.hidden = NO;
        [UIView animateWithDuration:0.3f animations:^{
            weakSelf.listView.frame = endFrame;
            weakSelf.bgMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        } completion:^(BOOL finished) {
            weakSelf.listView.frame = endFrame;
            weakSelf.bgMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        }];
    }
}

@end

@implementation PayTableFooterQuanView {
    UILabel *_quanPriceLbl;
   
}

- (id)init:(NSString*)icon title:(NSString*)title {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 46) icon:icon title:title];
}

- (id)initWithFrame:(CGRect)frame icon:(NSString*)icon title:(NSString*)title {
    self = [super initWithFrame:frame icon:icon title:title];
    if (self) {
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        line.frame = CGRectMake(0, 0, self.width, 1);
        [self.layer addSublayer:line];
        
        line = [CALayer layer];
        line.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        line.frame = CGRectMake(0, self.height-1, self.width, 1);
        [self.layer addSublayer:line];
        
        UIImageView *arrowIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right_arrow.png"]];
        arrowIcon.frame = CGRectMake(self.width-15-arrowIcon.width, (self.height-arrowIcon.height)/2, arrowIcon.width, arrowIcon.height);
        arrowIcon.tag = 1000;
        [self addSubview:arrowIcon];
        
        _quanPriceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _quanPriceLbl.hidden = YES;
        _quanPriceLbl.textColor = [UIColor colorWithHexString:@"CCCCCC"];
        _quanPriceLbl.font = [UIFont systemFontOfSize:12.f];
        [self addSubview:_quanPriceLbl];
    }
    return self;
}

- (void)setQuanAmount:(double)amount
{
    _quanPriceLbl.text = [NSString stringWithFormat:@"¥ %.2f",amount];
    _quanPriceLbl.numberOfLines = 1;
    [_quanPriceLbl sizeToFit];
    UIView *view = [self viewWithTag:1000];
    _quanPriceLbl.frame = CGRectMake(view.left-10-_quanPriceLbl.width, 0, _quanPriceLbl.width, self.height);
    _quanPriceLbl.hidden = NO;
}

@end

@implementation PayTableFooterItemView {
//    BOOL _isForMultiSelectedBig;
     UILabel *_avaMoneyLbl;
}

- (void)setSubTitle:(NSString *)subTitle {
    UIImageView *flagView = (UIImageView*)[self viewWithTag:300];
    UILabel *subTitleLbl = (UILabel*)[self viewWithTag:400];
    subTitleLbl.text = subTitle;
    [subTitleLbl sizeToFit];
    subTitleLbl.frame = CGRectMake(0, 0, flagView.left-10, 60);
}

- (void)setIndicatorTitle:(NSString *)indicatorTitle {
    UILabel *alipayLbl =(UILabel*)[self viewWithTag:100];
    UILabel *indicatorLbl = (UILabel*)[self viewWithTag:200];
    indicatorLbl.text = indicatorTitle;
    [indicatorLbl sizeToFit];
    indicatorLbl.frame = CGRectMake(alipayLbl.left+alipayLbl.width+4, (self.height-16)/2, indicatorLbl.width+10, 16);
    if ([indicatorTitle length]>0) {
        indicatorLbl.hidden = NO;
    } else {
        indicatorLbl.hidden = YES;
    }
}

- (id)init:(NSString*)icon title:(NSString*)title subTitle:(NSString*)subTitle isCanSelected:(BOOL)isCanSelected indicatorTitle:(NSString*)indicatorTitle {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 60) icon:icon title:title subTitle:subTitle isCanSelected:isCanSelected indicatorTitle:indicatorTitle];
}

- (id)initWithFrame:(CGRect)frame icon:(NSString*)icon title:(NSString*)title subTitle:(NSString*)subTitle isCanSelected:(BOOL)isCanSelected indicatorTitle:(NSString*)indicatorTitle {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *alipayImgView =[[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height-30)/2, 30, 30)];
        alipayImgView.image = [UIImage imageNamed:icon];
        [self addSubview:alipayImgView];
        if (!icon) {
            alipayImgView.frame = CGRectMake(15, 0, 0, self.height);
        }
        
        CGFloat totalWidth = kScreenWidth;
        
        UILabel *alipayLbl =[[UILabel alloc] initWithFrame:CGRectZero];
        alipayLbl.text = title;
        alipayLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        alipayLbl.font = [UIFont systemFontOfSize:15.f];
        alipayLbl.tag = 100;
        [alipayLbl sizeToFit];
        if (icon) {
            alipayLbl.frame = CGRectMake(alipayImgView.origin.x + alipayImgView.size.width+ 10, 0, alipayLbl.width, 60);
        } else {
            alipayLbl.frame = CGRectMake(alipayImgView.origin.x, 0, alipayLbl.width, 60);
        }
        [self addSubview:alipayLbl];
        
        UILabel *indicatorLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        indicatorLbl.text = indicatorTitle;
        indicatorLbl.textColor = [UIColor whiteColor];
        indicatorLbl.font = [UIFont systemFontOfSize:11.f];
        indicatorLbl.textAlignment = NSTextAlignmentCenter;
        [indicatorLbl sizeToFit];
        indicatorLbl.frame = CGRectMake(alipayLbl.left+alipayLbl.width+4, (self.height-16)/2, indicatorLbl.width+10, 16);
        indicatorLbl.tag = 200;
        indicatorLbl.backgroundColor = [UIColor colorWithHexString:@"e1bb66"];
        indicatorLbl.layer.cornerRadius = 2.5;
        indicatorLbl.layer.masksToBounds = YES;
        [self addSubview:indicatorLbl];
        
        if ([indicatorTitle length]>0) {
            indicatorLbl.hidden = NO;
        } else {
            indicatorLbl.hidden = YES;
        }
        
        UIImageView *flagView = [[UIImageView alloc] initWithImage:isCanSelected?[UIImage imageNamed:@"pay_checkbox_uncheck"]:[UIImage imageNamed:@"right_arrow_gray"]];
        flagView.frame = CGRectMake(totalWidth-15-flagView.width, (self.height-flagView.height)/2, flagView.width, flagView.height);
        flagView.tag = 300;
        [self addSubview:flagView];
        
        UILabel *subTitleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        subTitleLbl.text = subTitle;
        subTitleLbl.font = [UIFont systemFontOfSize:12.f];
        subTitleLbl.textColor = [UIColor colorWithHexString:@"999999"];
        subTitleLbl.textAlignment = NSTextAlignmentRight;
        [subTitleLbl sizeToFit];
        subTitleLbl.tag = 400;
        subTitleLbl.frame = CGRectMake(0, 0, flagView.left-10, 60);
        subTitleLbl.backgroundColor = [UIColor clearColor];
        [self addSubview:subTitleLbl];
        
        _selected = NO;
        if (isCanSelected) {
//            _isForMultiSelectedBig = YES;
//            flagView.hidden = YES;
        }
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)init:(NSString*)icon title:(NSString*)title {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 44) icon:icon title:title];
}

- (id)initWithFrame:(CGRect)frame icon:(NSString*)icon title:(NSString*)title {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *alipayImgView =[[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height-20)/2, 20, 20)];
        alipayImgView.image = [UIImage imageNamed:icon];
        [self addSubview:alipayImgView];
        
        CGFloat totalWidth = kScreenWidth;
        
        UILabel *alipayLbl =[[UILabel alloc] initWithFrame:CGRectMake(alipayImgView.origin.x + alipayImgView.size.width+ 10, 0, totalWidth-30 - alipayImgView.size.width, 44)];
        alipayLbl.text = title;
        alipayLbl.textColor = [UIColor colorWithHexString:@"181818"];
        alipayLbl.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:alipayLbl];
        
        UIImageView *flagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_checkbox_uncheck"]];
        flagView.frame = CGRectMake(totalWidth-15-flagView.width, (self.height-flagView.height)/2, flagView.width, flagView.height);
        flagView.tag = 300;
        [self addSubview:flagView];
        
        _selected = NO;
//        flagView.hidden = YES;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (id)init:(NSString*)iconUrl placeHolder:(NSString*)placeHolder title:(NSString*)title payDo:(PayWayDO *)payWayDo{
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 60) icon:iconUrl placeHolder:placeHolder title:title payWayDo:payWayDo];
}

- (id)initWithFrame:(CGRect)frame icon:(NSString*)iconUrl placeHolder:(NSString*)placeHolder title:(NSString*)title payWayDo:(PayWayDO *)payWayDo{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *alipayImgView =[[UIImageView alloc] initWithFrame:CGRectMake(15, (self.height-30)/2, 30, 30)];
        [alipayImgView sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:placeHolder]];
        [self addSubview:alipayImgView];
        
        CGFloat totalWidth = kScreenWidth;
        
        UILabel *alipayLbl =[[UILabel alloc] initWithFrame:CGRectMake(alipayImgView.origin.x + alipayImgView.size.width+ 10, 0, totalWidth-30 - alipayImgView.size.width, 44)];
        alipayLbl.text = title;
        alipayLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        alipayLbl.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:alipayLbl];
        [alipayLbl sizeToFit];
        alipayLbl.frame = CGRectMake(alipayImgView.origin.x + alipayImgView.size.width+ 10, alipayImgView.top-5, alipayLbl.width, alipayLbl.height);
        
        UILabel *contentLbl = [[UILabel alloc] initWithFrame:CGRectMake(alipayImgView.origin.x + alipayImgView.size.width+ 10, 15, totalWidth-30 - alipayImgView.size.width, 44)];
        contentLbl.text = payWayDo.desc;
        contentLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        contentLbl.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:contentLbl];
        [contentLbl sizeToFit];
        contentLbl.frame = CGRectMake(alipayImgView.origin.x + alipayImgView.size.width+ 10, alipayLbl.bottom+5, contentLbl.width, contentLbl.height);
        
        UIImageView *flagView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pay_checkbox_uncheck"]];
        flagView.frame = CGRectMake(totalWidth-15-flagView.width, (self.height-flagView.height)/2, flagView.width, flagView.height);
        flagView.tag = 300;
        [self addSubview:flagView];
        
        UILabel *availableMoneyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        availableMoneyLbl.text = [NSString stringWithFormat:@"(¥%.2f可用)", self.available_money_cent/100];
        availableMoneyLbl.font = [UIFont systemFontOfSize:13.f];
        availableMoneyLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [availableMoneyLbl sizeToFit];
        [self addSubview:availableMoneyLbl];
        _avaMoneyLbl = availableMoneyLbl;
        [availableMoneyLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(flagView.mas_left).offset(-17);
        }];
        availableMoneyLbl.hidden = YES;
        if (payWayDo.pay_way == PayWayAdmMoney) {
            availableMoneyLbl.hidden = NO;
        } else {
            availableMoneyLbl.hidden = YES;
        }
        
        _selected = NO;
//        flagView.hidden = YES;
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)getTitlePriceCent:(NSInteger)titlePriceCent available_money_cent:(CGFloat)available_money_cent{
    if (available_money_cent >= titlePriceCent) {
        _avaMoneyLbl.text = [NSString stringWithFormat:@"-%ld(¥%.2f可用)", titlePriceCent/100, available_money_cent/100];
    } else {
        _avaMoneyLbl.text = [NSString stringWithFormat:@"余额不足(¥%.2f可用)", available_money_cent/100];
    }
    
}

//-(void)setAvailable_money_cent:(CGFloat)available_money_cent{
//    _available_money_cent = available_money_cent;
//    _avaMoneyLbl.text = [NSString stringWithFormat:@"(¥%.2f可用)", self.available_money_cent/100];
//}

- (void)setSelected:(BOOL)selected {
    if (_selected!=selected) {
        _selected = selected;
        
        UIView *flagView = [self viewWithTag:300];
//        if (_isForMultiSelectedBig) {
//            flagView.hidden = _selected?NO:YES;
//        } else {
//            flagView.hidden = NO;
//            
//            if ([flagView isKindOfClass:[UIImageView class]]) {
//                ((UIImageView *)flagView ).image = (_selected ? [UIImage imageNamed:@"pay_checkbox_checked"] : [UIImage imageNamed:@"pay_checkbox_uncheck"]);
//            }
//        }
        
        if ([flagView isKindOfClass:[UIImageView class]]) {
            ((UIImageView *)flagView ).image = (_selected ? [UIImage imageNamed:@"pay_checkbox_checked"] : [UIImage imageNamed:@"pay_checkbox_uncheck"]);
        }
    }
}

@end


@interface PayQuanViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSources;

@end

@implementation PayQuanViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"可用优惠券"];
    [super setupTopBarBackButton];
    
    _dataSources = [[NSMutableArray alloc] init];
    if (_quanItemList && [_quanItemList count]>0) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:_quanItemList];
        BonusInfo *bonusInfo = [[BonusInfo alloc] init];
        bonusInfo.bonusId = @"-1000";
        
        [arr addObject:bonusInfo];
        BOOL selected = NO;
        for (int i = 0; i < arr.count; i++) {
            BonusInfo *info = arr[i];
            if ([info isKindOfClass:[BonusInfo class]]) {
                if ([info.bonusId isEqualToString:self.seletedBonusInfo.bonusId]) {
                    selected = YES;
                }else{
                    selected = NO;
                }
                [_dataSources addObject:[BonusTableViewCell buildCellDict:info BonusSeleted:selected isHaveUnableLbl:self.isHaveUnableLbl]];
            }
            
            NSLog(@"selected == %@",[NSNumber numberWithBool:selected]);
        }
    }
    
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    [self.view addSubview:self.tableView];
    
    [super bringTopBarToTop];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    [tableViewCell updateCellWithDict:dict index:[indexPath row]];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    BonusInfo *bonusInfo = [dict objectForKey:[BonusTableViewCell cellKeyForBonusInfo]];
    if (bonusInfo && [bonusInfo isKindOfClass:[BonusInfo class]]) {
        if (self.isHaveUnableLbl) {
            if (![bonusInfo.bonusId isEqualToString:@"-1000"]) {
                if (bonusInfo.canUse == 1) {
                    if (_handleDidSelectBonusInfo) {
                        _handleDidSelectBonusInfo(self, bonusInfo);
                    }
                }
            } else {
                if (_handleDidSelectBonusInfo) {
                    _handleDidSelectBonusInfo(self, bonusInfo);
                }
            }
        } else {
            if (_handleDidSelectBonusInfo) {
                _handleDidSelectBonusInfo(self, bonusInfo);
            }
        }
    }
}


@end



