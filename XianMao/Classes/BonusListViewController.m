//
//  BonusListViewController.m
//  XianMao
//
//  Created by simon on 2/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BonusListViewController.h"
#import "PullRefreshTableView.h"

#import "BonusTableViewCell.h"
#import "BonusNewTableViewCell.h"
#import "SepTableViewCell.h"

#import "DataListLogic.h"
#import "Error.h"
#import "BonusInfo.h"

#import "NetworkAPI.h"

#import "Command.h"

#import "CoordinatingController.h"

#import "DiscountView.h"

@implementation SepTableViewCellBonus
+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 15;
    return rowHeight;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SepTableViewCellBonus class]);
    });
    return __reuseIdentifier;
}


+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SepTableViewCellBonus class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return self;
}
@end


@interface BonusListViewController () <BonusCodeConvertControllerDelegate>

@property(nonatomic,strong) BonusListTabBar *tabBar;
@property(nonatomic,assign) NSInteger currentSelectedIndex;

@property(nonatomic,strong) BonusListView *listView;
@property(nonatomic,strong) BonusListView *historyListView;

@end


@implementation BonusListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNewView];
    
}

-(void)setNewView{
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"卡券"];
    [super setupTopBarBackButton];
    
    DiscountView *discount = [[DiscountView alloc] initWithFrame:CGRectMake(0, topBarHeight, kScreenWidth, kScreenHeight-topBarHeight)];
    [self.view addSubview:discount];
    
}

-(void)setOldView{
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"优惠券"];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    [super.topBarRightButton setTitle:@"添加优惠券" forState:UIControlStateNormal];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    super.topBarRightButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [super.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"f4433e"] forState:UIControlStateNormal];
    
    CGFloat hegight = self.topBarRightButton.height;
    [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.topBarRightButton sizeToFit];
    self.topBarRightButton.frame = CGRectMake(self.topBar.width-15-self.topBarRightButton.width, self.topBarRightButton.top, self.topBarRightButton.width, hegight);
    
    CGFloat marginTop= topBarHeight;
    
    _tabBar = [[BonusListTabBar alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, 45) tabBtnTitles:[NSArray arrayWithObjects:@"未使用",@"已失效", nil]];
    _tabBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tabBar];
    
    marginTop += _tabBar.height;
    marginTop += 0.f;
    
    _listView = [[BonusListView alloc] initWithFrame:CGRectMake(0, marginTop, self.view.width, self.view.height-marginTop) type:0];
    _historyListView = [[BonusListView alloc] initWithFrame:CGRectMake(0, marginTop, self.view.width, self.view.height-marginTop) type:1];
    
    [self.view addSubview:_listView];
    [self.view addSubview:_historyListView];
    
    [super bringTopBarToTop];
    
    WEAKSELF;
    weakSelf.currentSelectedIndex = -1;
    _tabBar.didSelectAtIndex = ^(NSInteger index) {
        if (weakSelf.currentSelectedIndex != index) {
            weakSelf.currentSelectedIndex = index;
        }
        if (index==0) {
            weakSelf.listView.hidden = NO;
            weakSelf.historyListView.hidden = YES;
        } else {
            weakSelf.listView.hidden = YES;
            weakSelf.historyListView.hidden = NO;
        }
    };
    [_tabBar setTabAtIndex:0 animated:NO];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    [ClientReportObject clientReportObjectWithViewCode:MineDiscountCouponViewCode regionCode:MineAddDiscountCouponViewCode referPageCode:MineAddDiscountCouponViewCode andData:nil];
    BonusCodeConvertController *viewController = [[BonusCodeConvertController alloc] init];
    viewController.delegate = self;
    [self pushViewController:viewController animated:YES];
}

- (void)bonusCodeConvertDidFinish:(BonusCodeConvertController*)viewController bonusInfo:(BonusInfo*)bonusInfo
{
//    bonusInfo = [[BonusInfo alloc] init];
//    bonusInfo.amount = 4999.99;
//    bonusInfo.bonusId = @"bonus_031";
//    bonusInfo.bonusDesc = @"U6ee15000U51cf4999.99";
//    bonusInfo.minPayAmount = 5000;
//    bonusInfo.sendEndTime = 1427241600000;
//    bonusInfo.sendStartTime = 1426809600000;
//    bonusInfo.useStartTime = 1426809600000;
//    bonusInfo.useEndTime = 1435190400000;
//    bonusInfo.type = 1;
//    bonusInfo.status = 0;
//    
    [viewController dismiss];
//    if (_listView) {
//        [_listView addBonusViaCodeConvert:bonusInfo];
//    }
    
    if (_listView) {
        [_listView reloadData];
    }
}

@end


@interface BonusListTabBar ()

@property(nonatomic,strong) UIView *indicatorView;
@property (nonatomic, strong) NSMutableArray *btnArr;
@end

@implementation BonusListTabBar {
    
}

-(NSMutableArray *)btnArr{
    if (!_btnArr) {
        _btnArr = [[NSMutableArray alloc] init];
    }
    return _btnArr;
}

- (id)initWithFrame:(CGRect)frame tabBtnTitles:(NSArray*)tabBtnTitles {
    self = [super initWithFrame:frame];
    if (self) {
        UIFont *btnFont = [UIFont systemFontOfSize:15.f];
        UIColor*btnTextColor = [UIColor colorWithHexString:@"b2b2b2"];//[UIColor colorWithHexString:@"C7AF7A"];
        UIColor *btnSeletedTextColor = [UIColor colorWithHexString:@"1a1a1a"];
        CGFloat btnHeight = self.height;
        CGFloat btnWidth = (self.width)/[tabBtnTitles count];
        CGFloat btnX = 0.f;
        for (NSInteger i=0;i<[tabBtnTitles count];i++) {
            CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake(btnX, 0, btnWidth, btnHeight)];
            btn.tag = i;
            btn.titleLabel.font = btnFont;
            [btn setTitleColor:btnTextColor forState:UIControlStateNormal];
            [btn setTitleColor:btnSeletedTextColor forState:UIControlStateSelected];
            [btn setTitle:[tabBtnTitles objectAtIndex:i] forState:UIControlStateNormal];
            [self addSubview:btn];
            if (i == 0) {
                btn.selected = YES;
            } else {
                btn.selected = NO;
            }
            [self.btnArr addObject:btn];
            WEAKSELF;
            btn.handleClickBlock = ^(CommandButton *sender) {
                [weakSelf setTabAtIndex:sender.tag animated:YES];
            };
            btnX += btnWidth;
        }
        
        CALayer *bottomLine = [CALayer layer];
        bottomLine.backgroundColor = [UIColor clearColor].CGColor;//[UIColor colorWithHexString:@"E3E3E3"].CGColor;
        bottomLine.frame = CGRectMake(0, self.height-1, self.width, 1);
        [self.layer addSublayer:bottomLine];
        
        CGFloat indicatorWidth = self.width/[tabBtnTitles count];
        CGFloat indicatorX = 25.f;
        indicatorWidth = indicatorWidth-50.f;
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(indicatorX, self.height-2, indicatorWidth, 2)];
        _indicatorView.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
        [self addSubview:_indicatorView];
    }
    return self;
}

- (void)setTabAtIndex:(NSInteger)index animated:(BOOL)animated{
    NSArray *subViews = [self subviews];
    WEAKSELF;
    for (int i = 0; i < self.btnArr.count; i++) {
        CommandButton *btn = self.btnArr[i];
        if (index == btn.tag) {
            btn.selected = YES;
        } else {
            btn.selected = NO;
        }
    }
    if (index < [subViews count]-1 && [subViews count]-1>0) {
        CGFloat indicatorWidth = weakSelf.width/([subViews count]-1);
        CGFloat indicatorX = index*indicatorWidth+25.f;
        CGRect endFrame = CGRectMake(indicatorX, weakSelf.indicatorView.top, weakSelf.indicatorView.width, weakSelf.indicatorView.height);
        
        if (animated) {
            [UIView animateWithDuration:0.25f animations:^{
                weakSelf.indicatorView.frame = endFrame;
            } completion:^(BOOL finished) {
                if (weakSelf.didSelectAtIndex) {
                    weakSelf.didSelectAtIndex(index);
                }
            }];
        } else {
            weakSelf.indicatorView.frame = endFrame;
            if (weakSelf.didSelectAtIndex) {
                weakSelf.didSelectAtIndex(index);
            }
        }
    }
}

@end

@interface BonusListView () <UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,PullRefreshTableViewDelegate>

@property(nonatomic,strong) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,assign) NSInteger type;

@end

@implementation BonusListView


- (id)initWithFrame:(CGRect)frame type:(NSInteger)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.type = type;
        self.backgroundColor = [UIColor whiteColor];
        
        PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:self.bounds];
        tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
        tableView.pullDelegate = self;
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.alwaysBounceVertical = YES;
        tableView.showsVerticalScrollIndicator = NO;
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self addSubview:tableView];
        self.tableView = tableView;
        
        _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"bonus" path:@"list" pageSize:15 fetchSize:30];
        _dataListLogic.parameters = @{@"type":[NSNumber numberWithInteger:self.type]};
        _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
        _dataSources = [[NSMutableArray alloc] init];
        
        [self reloadData];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)dealloc
{
    _request = nil;
}

- (void)addBonusViaCodeConvert:(BonusInfo*)bonusInfo
{
    if (bonusInfo) {
        [LoadingView hideLoadingView:self];
        if (!_dataSources) {
            _dataSources = [[NSMutableArray alloc] init];
        }
        if ([_dataSources count]>0) {
            [_dataSources insertObject:[BonusNewTableViewCell buildCellDict:bonusInfo] atIndex:1];
        } else {
            [_dataSources addObject:[SepTableViewCellBonus buildCellDict]];
            [_dataSources addObject:[BonusNewTableViewCell buildCellDict:bonusInfo]];
        }
        
        [_tableView reloadData];
    }
}

- (void)reloadData {
    
    WEAKSELF;
    
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
                if ([weakSelf.dataSources count]>0) {
                    weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
                }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [LoadingView hideLoadingView:weakSelf];
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]+1];
        [newList addObject:[SepTableViewCellBonus buildCellDict]];
        
        for (int i=0;i<[addedItems count];i++) {
            [newList addObject:[BonusNewTableViewCell buildCellDict:[BonusInfo createWithDict:[addedItems objectAtIndex:i]]]];
            [newList addObject:[SepTableViewCellBonus buildCellDict]];
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [LoadingView hideLoadingView:weakSelf];
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            [newList addObject:[BonusNewTableViewCell buildCellDict:[BonusInfo createWithDict:[addedItems objectAtIndex:i]]]];
        }
        if ([newList count]>0) {
            //NSInteger count = [weakSelf.dataSources count];
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            [dataSources addObjectsFromArray:newList];
            
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [LoadingView hideLoadingView:weakSelf];
        if ([weakSelf.dataSources count]==0) {
            [LoadingView loadEndWithError:weakSelf title:@"数据加载失败"].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        } else {
            [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        
//        [LoadingView loadEndWithNoContent:weakSelf title:@"暂无优惠券"];
        [LoadingView loadEndWithNoContent:weakSelf title:@"暂无优惠券" image:[UIImage imageNamed:@"quanHistory_MF"]];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic reloadDataListByForce];
    
    if ([_dataSources count]==0) {
        [LoadingView showLoadingView:weakSelf];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [_dataListLogic reloadDataListByForce];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [_dataListLogic nextPage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources?[_dataSources count]:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict index:[indexPath row]];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end


//获取优惠券列表
//bonus/list[GET]  user_id  type(0当前，1历史)  分页逻辑（没有下一页）
//
//
//合并付款前检查红包(bonus/list_by_orders,
//          user_id order_ids, [{},{}]
//          
//          
//          我的订单 合并付款（trade/pay_order_list）[POST] user_id,pay_way, order_ids[], bonus_id(可选)
//          
//          购物车进去直接前付款检查红包bonus/list_by_goods [{},{}]
//          user_id goods_ids
//          

//          购物车进去直接付款（trade/pay_goods_list）[POST]  message,address_id,user_id，pay_way，goods_list，bonus_id(可选)
//根据版本号码：



//
//


#import "TradeService.h"
#import "NSString+Addtions.h"
#import "QrCodeScanViewController.h"
#import "URLScheme.h"

@interface BonusCodeConvertController ()<QrCodeScanViewControllerDelegate>
@property(nonatomic,weak) CommandButton *submmitBtn;
@end

@implementation BonusCodeConvertController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:[self.title length]>0?self.title:@"添加优惠券"];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    }
    [super setupTopBarRightButton:[UIImage imageNamed:@"qrcode_scan"] imgPressed:nil];
    
    CGFloat marginTop = topBarHeight+15.f;
    
    UIInsetTextField *textField = [[UIInsetTextField alloc] initWithFrame:CGRectMake(0, marginTop, self.view.width, 40) rectInsetDX:15 rectInsetDY:0];
    textField.placeholder = @"请输入激活码";
//    [textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
    textField.font = [UIFont systemFontOfSize:15.f];
    textField.textColor = [UIColor colorWithHexString:@"282828"];
    textField.textAlignment = NSTextAlignmentLeft;
    textField.keyboardType = UIKeyboardTypeEmailAddress;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.tag = 100;
    textField.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    [self.view addSubview:textField];
    
    marginTop += textField.height;
    marginTop += 20;
    
    if ([_code length]>0) {
        textField.text = _code;
    }

    CommandButton *btn  = [[CommandButton alloc] initWithFrame:CGRectMake((self.view.width-180)/2, marginTop, 180, 45)];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 45.f/2;
    btn.layer.borderWidth  = 1.f;
    btn.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
    btn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"激活" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    self.submmitBtn = btn;
    [self.view addSubview:btn];

    WEAKSELF;
    btn.handleClickBlock = ^(CommandButton *sender) {
        NSString *codekey = [[((UITextField*)[sender.superview viewWithTag:100]).text trim] lowercaseString];
        if ([codekey length]>0) {
            [weakSelf.view endEditing:YES];
            [weakSelf showProcessingHUD:nil];
            [BonusService convertBonus:codekey completion:^(BonusInfo *bonusInfo) {
                [weakSelf hideHUD];
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(bonusCodeConvertDidFinish:bonusInfo:)] && bonusInfo) {
                    [weakSelf showHUD:@"添加成功" hideAfterDelay:0.8f];
                    [weakSelf.delegate bonusCodeConvertDidFinish:weakSelf bonusInfo:bonusInfo];
                } else {
                    [weakSelf showHUD:@"添加成功" hideAfterDelay:0.8f];
                    double delayInSeconds = 0.8;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        [weakSelf dismiss];
                    });
                }
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        } else {
            [weakSelf showHUD:@"请输入激活码" hideAfterDelay:0.8f];
        }
    };
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    QrCodeScanViewController *viewController = [[QrCodeScanViewController alloc] init];
    viewController.delegate = self;
    [self pushViewController:viewController animated:YES];
}

- (void)processScanResults:(QrCodeScanViewController*)viewController url:(NSString*)urlOrgin
{
    [viewController dismiss];
    
    BOOL bHanled = NO;
    
    NSString *redirectUri = urlOrgin;
    NSRange range = [redirectUri rangeOfString:kURLSchemeHttpURL];
    if (range.length>0) {
        if ([redirectUri rangeOfString:kURLSchemeHttpURL].length>0) {
            NSMutableString *locateUrlString = [[NSMutableString alloc] initWithString:redirectUri];
            [locateUrlString replaceCharactersInRange:range withString:kURLSchemeAidingmao];
            
            NSURL *url = [NSURL URLWithString:locateUrlString];
            NSString *query = url.query;
            NSString *locatorUrl = [NSString stringWithFormat:@"%@://%@%@",url.scheme,url.host,url.path];
            NSString *className = [[URLScheme locatorMap] objectForKey:locatorUrl];
            
            if (className && [className length]>0) {
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                for (NSString *param in [query componentsSeparatedByString:@"&"]) {
                    NSArray *elts = [param componentsSeparatedByString:@"="];
                    if([elts count] < 2) continue;
                    [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
                }
                
                if (NSClassFromString(className) == [BonusCodeConvertController class]) {
                    NSString *code = [params valueForKey:@"code"] ;
                    ((UITextField*)[self.view viewWithTag:100]).text = code;
                    bHanled = YES;
                }
            }
        }
    }
    
    if (!bHanled) {
        [URLScheme locateWithRedirectUri:urlOrgin andIsShare:NO];
    }
}

- (void)processScanResults:(QrCodeScanViewController*)viewController data:(NSString*)data
{
    
}

@end



//bonus/convert_bonus[POST] {user_id, cdkey}  返回bonus结构
//cdkey可兑换有xk0001,fuk001,you007



//auth/check_phone[POST] ｛is_exist是否（1，0）存在｝ @白骁 @卢云




