//
//  ADMShoppingCentreViewController.m
//  XianMao
//
//  Created by apple on 16/9/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ADMShoppingCentreViewController.h"
#import "Session.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "AboutViewController.h"
#import "PullRefreshTableView.h"
#import "ADMShoppingHeaderView.h"
#import "DataListLogic.h"
#import "BaseTableViewCell.h"
#import "BlankTableViewCell.h"
#import "SepTableViewCell.h"
#import "RecommendGoodsInfo.h"
#import "RecommendTableViewCell.h"
#import "ADMShoppingSiftView.h"
#import "AFNetworkReachabilityManager.h"
#import "NetworkAPI.h"
#import "SearchFilterInfo.h"
#import "JSONKit.h"
#import "NSString+URLEncoding.h"
#import "Command.h"
#import "SearchSiftView.h"
#import "BlackView.h"
#import "ShoppingCartViewController.h"
#import "TagsExplanView.h"
#import "FilterModel.h"
#import "URLScheme.h"

@interface ADMShoppingCentreViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate,UIScrollViewDelegate>


@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) ADMShoppingHeaderView *headerView;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) NSMutableArray *goodsArrayList;
@property (nonatomic, strong) HTTPRequest *request;
@property (nonatomic, strong) NSMutableArray *filterInfoArray;
@property (nonatomic, strong) TapDetectingImageView * adviserImg;
@property (nonatomic, assign) CGFloat topBarHeight;

@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, strong) UIPanGestureRecognizer *pgr;

@property (nonatomic, strong) ADMShoppingSiftView *siftView;
@property (nonatomic, strong) SearchSiftView *searchSiftView;
@property (nonatomic, strong) BlackView *siftBgView;
@property (nonatomic, strong) NSString *params;
@property (nonatomic, strong) UserDetailInfo * userDetailInfo;
@property (nonatomic, strong) BlackView *bgView;
@property (nonatomic, strong) TagsExplanView *tagsExplainView;
@property (nonatomic, assign) CGFloat offsize;
@property (nonatomic, assign) CGFloat offsize1;
@property (nonatomic, strong) FilterModel * filterModel;
@property (nonatomic, strong) NSMutableArray * siftParamArr;
@property (nonatomic, copy) NSString * tempQv;
@property (nonatomic, strong) NSMutableArray * paramArr;
@property (nonatomic, strong) TapDetectingImageView * scrollTopBtn;
@end

@implementation ADMShoppingCentreViewController

-(NSMutableArray *)paramArr
{
    if (!_paramArr) {
        _paramArr = [[NSMutableArray alloc] init];
    }
    return _paramArr;
}

-(NSMutableArray *)siftParamArr
{
    if (!_siftParamArr) {
        _siftParamArr = [[NSMutableArray alloc] init];
    }
    return _siftParamArr;
}
-(BlackView *)bgView{
    if (!_bgView) {
        _bgView = [[BlackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _bgView;
}

-(TagsExplanView *)tagsExplainView{
    if (!_tagsExplainView) {
        _tagsExplainView = [[TagsExplanView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 310)];
        _tagsExplainView.backgroundColor = [UIColor whiteColor];
    }
    return _tagsExplainView;
}

-(BlackView *)siftBgView{
    if (!_siftBgView) {
        _siftBgView = [[BlackView alloc] initWithFrame:CGRectZero];
    }
    return _siftBgView;
}

-(SearchSiftView *)searchSiftView{
    if (!_searchSiftView) {
        _searchSiftView = [[SearchSiftView alloc] initWithFrame:CGRectZero];
        _searchSiftView.backgroundColor = [UIColor whiteColor];
    }
    return _searchSiftView;
}

-(ADMShoppingSiftView *)siftView{
    if (!_siftView) {
        _siftView = [[ADMShoppingSiftView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
        _siftView.backgroundColor = [UIColor whiteColor];
    }
    return _siftView;
}

-(TapDetectingImageView *)adviserImg
{
    if (!_adviserImg) {
        UIImage * image = [UIImage imageNamed:@"home_adm_adviser"];
        _adviserImg = [[TapDetectingImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, kScreenHeight-60-40-60, image.size.width, image.size.height)];
        _adviserImg.image = image;
        _adviserImg.handleSingleTapDetected = ^(TapDetectingImageView * view,UIGestureRecognizer * tgr){
           
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
                
                AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
                [UserSingletonCommand chatWithUserHasWXNum:adviserPage.userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings] adviser:adviserPage nadGoodsId:nil];
                
            } failure:^(XMError *error) {
                
            } queue:nil]];
            
        };
    }
    return _adviserImg;
}

-(NSMutableArray *)filterInfoArray{
    if (!_filterInfoArray) {
        _filterInfoArray = [[NSMutableArray alloc] init];
    }
    return _filterInfoArray;
}

-(NSMutableArray *)goodsArrayList{
    if (!_goodsArrayList) {
        _goodsArrayList = [[NSMutableArray alloc] init];
    }
    return _goodsArrayList;
}

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(ADMShoppingHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ADMShoppingHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 178+50)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
    }
    return _tableView;
}

-(NSArray *)images{
    if (!_images) {
        _images = [[NSArray alloc] init];
    }
    return _images;
}

-(NSArray *)titles{
    if (!_titles) {
        _titles = [[NSArray alloc] init];
    }
    return _titles;
}

-(TapDetectingImageView *)scrollTopBtn{
    if (!_scrollTopBtn) {
        _scrollTopBtn = [[TapDetectingImageView alloc] initWithFrame:CGRectZero];
        _scrollTopBtn.image = [UIImage imageNamed:@"Back_Top_MF"];
        _scrollTopBtn.frame = CGRectMake(kScreenWidth-50, kScreenHeight-60-50, self.scrollTopBtn.image.size.width, self.scrollTopBtn.image.size.height);;
    }
    return _scrollTopBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setViews];
    
    WEAKSELF;
    self.scrollTopBtn.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer){
        [weakSelf clickScrollTopBtn];
    };

    [self.view bringSubviewToFront:self.scrollTopBtn];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterSearch:) name:@"filterSearch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSearchFilter:) name:@"resetSearchFilter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overridePriceFilterSearch:) name:@"overridePriceFilterSearch" object:nil];
}


-(void)clickScrollTopBtn{
    [self.tableView scrollViewToTop:YES];
}


-(void)filterSearch:(NSNotification *)n
{
    
    NSDictionary * dict = n.userInfo;
    NSDictionary * buttonDict = n.object;
    
    if (self.siftParamArr.count > 0) {
        
        if ([buttonDict[@"multisSelected"] integerValue] == 1) {//多选
            if ([buttonDict[@"buttonIsSeclected"] boolValue] == NO) {
                for (int i = 0; i < self.siftParamArr.count; i++) {
                    NSDictionary * dic = self.siftParamArr[i];
                    if ([dic[@"qk"] isEqualToString:dict[@"qk"]] && [dic[@"qv"] isEqualToString:dict[@"qv"]]) {
                        [self.siftParamArr removeObject:dic];
                    }
                }
            }else{
                [self.siftParamArr addObject:dict];
            }
        }else{//单选
            
            if (![_tempQv isEqualToString:dict[@"qv"]]) {
                for (int i = 0; i <self.siftParamArr.count; i++) {
                    NSDictionary * dic = [self.siftParamArr objectAtIndex:i];
                    
                    if ([_tempQv isEqualToString:dic[@"qv"]]) {
                        [self.siftParamArr removeObject:dic];
                    }
                }
                [self.siftParamArr addObject:dict];
            } else{
                if ([buttonDict[@"buttonIsSeclected"] boolValue] == NO) {
                    [self.siftParamArr removeObject:dict];
                }else{
                    [self.siftParamArr addObject:dict];
                }
            }
            _tempQv = dict[@"qv"];
        }
        
    }else{
        [self.siftParamArr addObject:dict];
        if ([buttonDict[@"multisSelected"] integerValue] != 1) {//传过来的按钮是否选中状态
            _tempQv = dict[@"qv"];
        }
    }
    
    
    

    for (int i = 0; i < self.paramArr.count; i++) {
        NSDictionary *paraDict = self.paramArr[i];
        if ([paraDict[@"qk"] isEqualToString:dict[@"qk"]]) {
            [self.paramArr removeObject:paraDict];
        }
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.siftParamArr];
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dictSift = arr[i];
        for (int j = 0; j < self.paramArr.count; j++) {
            NSDictionary *dictParam = self.paramArr[j];
            if ([dictSift[@"qk"] isEqualToString:dictParam[@"qk"]]) {
                [self.siftParamArr removeObject:dictSift];
            }
        }
    }
    

    [self.siftParamArr addObjectsFromArray:self.paramArr];
    
    NSLog(@"%@", self.siftParamArr);
    self.params = [[self.siftParamArr JSONString] URLEncodedString];
    [self doSearch];
    [self loadSearchFilterData:self.params];
  
}
- (void)overridePriceFilterSearch:(NSNotification *)n
{
    NSDictionary * dict = n.userInfo;
    NSDictionary * status = n.object;
    _tempQv = dict[@"qv"];
    if (self.siftParamArr.count > 0) {
        if ([status[@"multisSelected"] integerValue] == 1) {//多选
            
            for (int i = 0; i < self.siftParamArr.count; i++) {
                NSDictionary * dic = self.siftParamArr[i];
                if ([dic[@"qk"] isEqualToString:dict[@"qk"]] && [dic[@"qv"] isEqualToString:dict[@"qv"]]) {
                    [self.siftParamArr removeObject:dic];
                    [self.siftParamArr addObject:dict];
                }
            }
        }else{
            for (int i = 0; i < self.siftParamArr.count; i++) {
                NSDictionary * dic = self.siftParamArr[i];
                if ([dic[@"qk"] isEqualToString:dict[@"qk"]]) {
                    [self.siftParamArr removeObject:dic];
                    [self.siftParamArr addObject:dict];
                }
            }
        }
    }else{
        [self.siftParamArr addObject:dict];
    }

    NSLog(@"self.siftParamArr === %@",self.siftParamArr);
    
    [self.siftParamArr addObjectsFromArray:self.paramArr];
    
    NSLog(@"%@", self.siftParamArr);
    self.params = [[self.siftParamArr JSONString] URLEncodedString];
    [self doSearch];
    [self loadSearchFilterData:self.params];

}

-(void)resetSearchFilter:(NSNotification *)n
{
    [self.siftParamArr removeAllObjects];
    [self loadSearchFilterData:nil];
}


-(void)setViews{
    self.topBarHeight = [super setupTopBar];
    //    [super setupTopBarLogo:[UIImage imageNamed:@"ADMShopping"]];
    
    [super setupTopBarBackButton];
    [super setupTopBarRightButton:[UIImage imageNamed:@"more_wjh"] imgPressed:nil];
    [super setupTopBarRightTwoButton:[UIImage imageNamed:@"Goods_TopRight_ShopBag"] imgPressed:nil];
    UIButton *goodsNumLbl = [self buildGoodsNumLbl];
    _goodsNumLbl = goodsNumLbl;
    [self.topBarRightTwoButton addSubview:goodsNumLbl];
    _titles = @[@"消息",@"首页",@"我要反馈",@"分享"];
    _images=@[@"pop_messgae",@"pop_home",@"pop_feedback",@"pop_share"];
    
    WEAKSELF;
    [self showLoadingView];
    _request = [[NetworkAPI sharedInstance] getUserDetail:self.userId completion:^(UserDetailInfo *userDetailInfo) {
        [weakSelf hideLoadingView];
        weakSelf.userDetailInfo = userDetailInfo;
        [super setupTopBarLogo:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userDetailInfo.userInfo.autotrophyGoodsVo.title]]]];
        weakSelf.topBarLogo.frame = CGRectMake(kScreenWidth/2-weakSelf.topBarLogo.width/3/2, weakSelf.topBar.height/2-weakSelf.topBarLogo.height/3/2+8, weakSelf.topBarLogo.width/3, weakSelf.topBarLogo.height/3);
        
        [weakSelf.view addSubview:weakSelf.tableView];
        //        if (userDetailInfo.userInfo.autotrophyGoodsVo.promiseList.count > 0) {
        //            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 178+50);
        //        } else {
        //            self.headerView.frame = CGRectMake(0, 0, kScreenWidth, 178+50);
        //        }
        
        
        weakSelf.headerView.userId = weakSelf.userId;
        [weakSelf.headerView getUserDetailInfo:userDetailInfo];
        [weakSelf.view addSubview:weakSelf.adviserImg];
        
        if (userDetailInfo.contactType == 1) {
            weakSelf.adviserImg.hidden = NO;
        } else {
            weakSelf.adviserImg.hidden = YES;
        }
        
        if (userDetailInfo.userInfo.sellerBanners && userDetailInfo.userInfo.sellerBanners.count > 0) {
            CGFloat height = [ADMShoppingCentreViewController sellerBannerHeightForPortrait:userDetailInfo.userInfo.sellerBanners];
            weakSelf.headerView.frame = CGRectMake(0, 0, kScreenWidth, height+50);
        }
        
        weakSelf.tableView.tableHeaderView = self.headerView;
        
        //        [weakSelf loadGoodsFilter];
//        [weakSelf initDataListLogic];
        [weakSelf.tableView reloadData];
        [weakSelf doSearch];
        [weakSelf setUpUI];
        [weakSelf.dataListLogic reloadDataListByForce];
        
        [weakSelf.view addSubview:weakSelf.siftBgView];
        [weakSelf.view addSubview:weakSelf.searchSiftView];
        [weakSelf.view addSubview:weakSelf.scrollTopBtn];
        weakSelf.scrollTopBtn.hidden = YES;
        weakSelf.siftBgView.frame = [UIScreen mainScreen].bounds;
        weakSelf.siftBgView.alpha = 0;
        weakSelf.searchSiftView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth-70, kScreenHeight);
        
        weakSelf.siftView.showSiftView = ^(){
            [weakSelf loadSearchFilterData:nil];
        };
        
        weakSelf.siftBgView.dissMissBlackView = ^(){
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.siftBgView.alpha = 0;
                weakSelf.searchSiftView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth-70, kScreenHeight);
            }];
        };
        weakSelf.searchSiftView.handleFinishButtonClick = ^(){
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.siftBgView.alpha = 0;
                weakSelf.searchSiftView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth-70, kScreenHeight);
            }];
        };
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSearchView:) name:@"loadSearchViews" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTagsExplainView:) name:@"showTagsExplainView" object:nil];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
    }];
}

+ (CGFloat)sellerBannerHeightForPortrait:(NSArray*)array
{
    CGFloat height = 0;
    CGFloat width = 0;
    RedirectInfo *redirectInfo = [array objectAtIndex:0];
    if (redirectInfo && [redirectInfo isKindOfClass:[RedirectInfo class]]) {
        height = redirectInfo.height;
        width = redirectInfo.width;
    }
    height = kScreenWidth*height/width;
    return height;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadSearchViews" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"filterSearch" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetSearchFilter" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showTagsExplainView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"overridePriceFilterSearch" object:nil];
}

-(void)loadSearchFilterData:(NSString *)paramsArr
{
    WEAKSELF;
    NSInteger user_id = [Session sharedInstance].currentUserId?[Session sharedInstance].currentUserId:0;
    NSString * keywords = @"";
    NSDictionary * params = @{@"keywords":keywords,@"user_id":[NSNumber numberWithInteger:user_id],@"params":paramsArr?paramsArr:@""};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"filter" parameters:params completionBlock:^(NSDictionary *data) {
        
        NSArray * array = data[@"list"];
        if ([array count] > 0) {
            NSDictionary * dict = array[0];
            FilterModel * filterModel = [FilterModel createWithDict:dict];
            weakSelf.filterModel = filterModel;
            [weakSelf.searchSiftView getFilterModel:weakSelf.filterModel keyworlds:keywords array:self.siftParamArr];
        }
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.siftBgView.alpha = 0.7;
            weakSelf.searchSiftView.frame = CGRectMake(70, 0, kScreenWidth-70, kScreenHeight);
        }];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
}

-(void)showTagsExplainView:(NSNotification *)notify{
    WEAKSELF;
    AutotrophyVo *autotrophyVo = notify.object;
    [self.view addSubview:self.bgView];
    [self.view addSubview:self.tagsExplainView];
    [self.tagsExplainView getTagsArr:autotrophyVo.promiseList];
    self.bgView.alpha = 0;
    self.bgView.dissMissBlackView = ^(){
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.tagsExplainView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 310);
            weakSelf.bgView.alpha = 0;
        } completion:^(BOOL finished) {
            [weakSelf.tagsExplainView removeFromSuperview];
            [weakSelf.bgView removeFromSuperview];
        }];
    };
    
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.bgView.alpha = 0.7;
        weakSelf.tagsExplainView.frame = CGRectMake(0, kScreenHeight-310, kScreenWidth, 310);
    }];
    
}

-(void)handleTopBarBackButtonClicked:(UIButton *)sender{
    [self dismiss:YES];
}

-(void)handleTopBarRightTwoButtonClicked:(UIButton *)sender{
    ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

-(void)loadSearchView:(NSNotification *)notify{
    
    NSDictionary *dict = notify.object;
    SearchFilterInfo *filterInfo = [dict objectForKey:@"filterInfo"];
    NSInteger itemNum = ((NSNumber *)[dict objectForKey:@"itemNum"]).integerValue;
    
    NSMutableArray *paramArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:filterInfo.queryKey forKey:@"qk"];
    [paramDict setObject:((SearchFilterItem *)(filterInfo.items[itemNum])).queryValue forKey:@"qv"];
    [paramArr addObject:paramDict];
    self.paramArr = paramArr;
    
    for (int i = 0; i < self.siftParamArr.count; i++) {
        NSDictionary *dict = self.siftParamArr[i];
        if ([dict[@"qk"] isEqualToString:filterInfo.queryKey]) {
            [self.siftParamArr removeObject:dict];
        }
    }
    [paramArr addObjectsFromArray:self.siftParamArr];
    NSLog(@"%@", paramArr);
    self.params = [[paramArr JSONString] URLEncodedString];
    [self doSearch];
}

- (void)pgr:(UIPanGestureRecognizer *)pgr
{
    CGPoint point = [pgr translationInView:self.view];
    
    static CGPoint originPoint;
    if (pgr.state == UIGestureRecognizerStateBegan)
    {
        originPoint = pgr.view.center;
    }
    
    pgr.view.center = CGPointMake(originPoint.x+point.x, originPoint.y+point.y);
    _originPoint = originPoint;
    _pgr = pgr;
    
    if (pgr.state == UIGestureRecognizerStateEnded) {
        originPoint = pgr.view.center;
        CGFloat x = originPoint.x;
        CGFloat y = originPoint.y;
        
        if (y < 100) {
            [UIView animateWithDuration:0.2 animations:^{
                pgr.view.center = CGPointMake(originPoint.x, 65/2);
            }];
            return;
        } else if (y > kScreenHeight-50) {
            [UIView animateWithDuration:0.2 animations:^{
                pgr.view.center = CGPointMake(originPoint.x, kScreenHeight-65/2);
            }];
            return;
        }
        
        if (x < kScreenWidth/2) {
            [UIView animateWithDuration:0.2 animations:^{
                 pgr.view.center = CGPointMake(65/2, originPoint.y);
            }];
        } else if (x > kScreenWidth/2) {
            [UIView animateWithDuration:0.2 animations:^{
                pgr.view.center = CGPointMake(kScreenWidth-65/2, originPoint.y);
            }];
        }
    }
    pgr.view.alpha = 1;

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.y > 600) {
        self.scrollTopBtn.hidden = NO;
    } else {
        self.scrollTopBtn.hidden = YES;
    }

}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
}
// 添加到另一个控制器的时候  appear方法不会调用  会调用didappear
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)loadGoodsFilter
{
    WEAKSELF;
    NSDictionary *parameters = @{@"seller_id":[NSNumber numberWithInteger:self.userId]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"paixu_item_list" parameters:nil completionBlock:^(NSDictionary *data) {
        
        NSArray *list = [data arrayValueForKey:@"list"];
        NSMutableArray *filterInfoArray = [NSMutableArray arrayWithCapacity:list.count];
        if ([list isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in list) {
                SearchFilterInfo *filerInfo = [SearchFilterInfo createWithDict:dict];
                if ([filerInfo isCompatible]) {
                    [filterInfoArray addObject:filerInfo];
                }
            }
        }
        
        weakSelf.filterInfoArray = filterInfoArray;
        
        [weakSelf setupReachabilityChangedObserver];
//        [weakSelf initDataListLogic];
        [weakSelf doSearch];
        [weakSelf setUpUI];
        [weakSelf.dataListLogic reloadDataListByForce];
        
    } failure:^(XMError *error) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        
    } queue:nil]];
}

//- (void)initDataListLogic
//{
//    WEAKSELF;
//    
//    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"search" path:@"list" pageSize:16 fetchSize:32];
//    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
//    _dataListLogic.parameters = @{@"keywords":@"",
//                                  @"params":self.params?self.params:@"",
//                                  @"seller_id":[NSNumber numberWithInteger:self.userId]};
//    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        
//        if ([weakSelf.dataSources count] == 0) {
//            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:1];
//            [newList addObject:[BlankTableViewCell buildCellDict:weakSelf.tableView title:nil isLoading:YES]];
//            [weakSelf.dataSources removeAllObjects];
//            [weakSelf setDataSources:newList];
//            [weakSelf.tableView reloadData];
//        }
//    };
//
//    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
//        weakSelf.tableView.enableLoadingMore = YES;
//        weakSelf.tableView.enableRefreshing = NO;//YES;
//        
//        if ([weakSelf.dataSources count]>0) {
//            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:[weakSelf.dataSources objectAtIndex:0]];
//            if (ClsTableViewCell == [BlankTableViewCell class]) {
//                [weakSelf.dataSources removeObjectAtIndex:0];
//            }
//        }
//        
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
//        weakSelf.tableView.autoTriggerLoadMore = YES;
//        
//        [weakSelf.goodsArrayList removeAllObjects];
//        [weakSelf.dataSources removeAllObjects];
//        
////        if ([Session sharedInstance].currentUserId == weakSelf.userId) {
////            NSMutableArray *arr = [[NSMutableArray alloc] init];
////            [arr addObject:[MineGoodsShelfCell buildCellDict]];
////            [arr addObject:[UserHomeGoodsShelfCateCell buildCellDict]];
////            [arr addObject:[UserHomeSegCell buildCellDict]];
////            [arr addObject:[UserHomeAlSaleCell buildCellDict]];
////            [arr addObject:[UserHomeAlSelaCataCell buildCellDict]];
////            [arr addObject:[UserHomeSegCell buildCellDict]];
////            weakSelf.dataSources = arr;
////        }
//        
////        if ([weakSelf.filterInfoArray count]>0) {
////            
////            [weakSelf.dataSources addObject:[UserHomeSearchFilterCell buildCellDict:weakSelf.filterInfoArray]];
////            [weakSelf.dataSources addObject:[UserHomeGoodsTotalNumCell buildCellDict:weakSelf.userDetailInfo.userInfo.goodsNum]];
////        }
////        
//        for (NSInteger i=0;i<[addedItems count];i+=2) {
//            NSMutableArray *array = [[NSMutableArray alloc] init];
//            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]]];
//            if (i+1>=[addedItems count]) {
//                [weakSelf.goodsArrayList addObject:array];
//                break;
//            }
//            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
//            [weakSelf.goodsArrayList addObject:array];
//        }
//        
//        for (NSInteger i=0;i<[weakSelf.goodsArrayList count];i++) {
//            NSArray *array = [weakSelf.goodsArrayList objectAtIndex:i];
//            [weakSelf.dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
//            [weakSelf.dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
//        }
//        [weakSelf.tableView reloadData];
//    };
//    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = YES;
//    };
//    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
//        
//        if ([weakSelf.dataSources count]>0) {
//            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:[weakSelf.dataSources objectAtIndex:0]];
//            if (ClsTableViewCell == [BlankTableViewCell class]) {
//                [weakSelf.dataSources removeObjectAtIndex:0];
//            }
//        }
//        
//        weakSelf.tableView.enableLoadingMore = YES;
//        weakSelf.tableView.enableRefreshing = NO;//YES;
//        
//        BOOL ignoreCount = 0;
//        if ([addedItems count]>0) {
//            NSMutableArray *array = nil;
//            if ([weakSelf.goodsArrayList count]>0) {
//                array = [weakSelf.goodsArrayList objectAtIndex:[weakSelf.goodsArrayList count]-1];
//            }
//            if (array && [array count]==1) {
//                [array addObject: [RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:0]]];
//                ignoreCount = 1;
//            }
//        }
//        
//        NSMutableArray *addedGoodsArrayList = [[NSMutableArray alloc] init];
//        for (NSInteger i=0;i<[addedItems count]-ignoreCount;i+=2) {
//            NSMutableArray *array = [[NSMutableArray alloc] init];
//            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]]];
//            if (i+1>=[addedItems count]-ignoreCount) {
//                //                [weakSelf.goodsArrayList addObject:array];
//                [addedGoodsArrayList addObject:array];
//                break;
//            }
//            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
//            //[weakSelf.goodsArrayList addObject:array];
//            [addedGoodsArrayList addObject:array];
//        }
//        
//        [weakSelf.goodsArrayList addObjectsFromArray:addedGoodsArrayList];
//        
//        for (NSInteger i=0;i<[addedGoodsArrayList count];i++) {
//            NSArray *array = [addedGoodsArrayList objectAtIndex:i];
//            if ([weakSelf.dataSources count]>0) {
//                [weakSelf.dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
//            }
//            [weakSelf.dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
//        }
//        if (loadFinished) {
//            [weakSelf.dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
//        }
//        [weakSelf.tableView reloadData];
//        
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
//        weakSelf.tableView.autoTriggerLoadMore = YES;
//    };
//    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
//        
//        if ([weakSelf.dataSources count]>0) {
//            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:[weakSelf.dataSources objectAtIndex:0]];
//            if (ClsTableViewCell == [BlankTableViewCell class]) {
//                [weakSelf.dataSources removeObjectAtIndex:0];
//            }
//        }
//        
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        weakSelf.tableView.autoTriggerLoadMore = NO;
//        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
//    };
//    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
//        
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = YES;
//        
//        weakSelf.tableView.enableRefreshing = NO;//YES;
//        
//        //        [weakSelf.dataSources addObject:[BlankTableViewCell buildCellDict:weakSelf.tableView title:@"暂无商品"]];
//        if ([Session sharedInstance].currentUserId != weakSelf.userId) {
//            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:1];
//            [newList addObject:[BlankTableViewCell buildCellDict:weakSelf.tableView title:@"暂无商品"]];
//            [weakSelf.dataSources removeAllObjects];
//            [weakSelf setDataSources:newList];
//        }
//        [weakSelf.tableView reloadData];
//    };
//    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
//        
//    };
//
//    [_dataListLogic firstLoadFromCache];
//}

+ (NSDictionary*)createQueryParam:(NSString*)queryKey queryValue:(NSString*)queryValue {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (queryKey) [dict setObject:queryKey forKey:@"qk"];
    if (queryValue) [dict setObject:queryValue forKey:@"qv"];
    return dict;
}


- (void)doSearch
{
    WEAKSELF;
//    NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
//    //    NSMutableString *params = [[NSMutableString alloc] initWithString:@""];
//    NSArray *filterInfos = weakSelf.filterInfoArray;
//    for (SearchFilterInfo *filterInfo in filterInfos) {
//        if ([filterInfo isKindOfClass:[SearchFilterInfo class]]) {
//            if (filterInfo.type == 2) {
//                if (filterInfo.queryKey && [filterInfo.queryKey length]>0) {
//                    for (SearchFilterItem *filterItem in filterInfo.items) {
//                        if ([filterItem isKindOfClass:[SearchFilterItem class]] && filterItem.isSelected && filterItem.queryValue && [filterItem.queryValue length]>0) {
//                            [paramsArray addObject:[[weakSelf class] createQueryParam:filterInfo.queryKey queryValue:filterItem.queryValue]];
//                        }
//                    }
//                }
//            }
//        }
//    }
//    
//    NSString *params = [[paramsArray JSONString] URLEncodedString];
    
    [weakSelf showProcessingHUD:nil];
    
    if (!_dataListLogic) {
        _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"search" path:@"list" pageSize:16 fetchSize:32];
        _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
        _dataListLogic.parameters = @{@"keywords":@"",
                                      @"params":self.params?self.params:@"",
                                      @"seller_id":[NSNumber numberWithInteger:self.userId]};
    } else {
        _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
        _dataListLogic.parameters = @{@"keywords":@"",
                                      @"params":self.params?self.params:@"",
                                      @"seller_id":[NSNumber numberWithInteger:self.userId]};
        [_dataListLogic reloadDataListByForce];
    }
    
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        //        if (weakSelf.tableView.enableRefreshing) {
        //            weakSelf.tableView.pullTableIsRefreshing = YES;
        //        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        
        [weakSelf hideHUD];
        
        weakSelf.tableView.enableLoadingMore = YES;
        weakSelf.tableView.enableRefreshing = NO;//YES;
        
        if ([weakSelf.dataSources count]>0) {
            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:[weakSelf.dataSources objectAtIndex:0]];
            if (ClsTableViewCell == [BlankTableViewCell class]) {
                [weakSelf.dataSources removeObjectAtIndex:0];
            }
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        [weakSelf.goodsArrayList removeAllObjects];
        [weakSelf.dataSources removeAllObjects];
        
        for (NSInteger i=0;i<[addedItems count];i+=2) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]]];
            if (i+1>=[addedItems count]) {
                [weakSelf.goodsArrayList addObject:array];
                break;
            }
            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
            [weakSelf.goodsArrayList addObject:array];
        }
        
        for (NSInteger i=0;i<[weakSelf.goodsArrayList count];i++) {
            NSArray *array = [weakSelf.goodsArrayList objectAtIndex:i];
            [weakSelf.dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
            [weakSelf.dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
        }
        
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        
        if ([weakSelf.dataSources count]>0) {
            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:[weakSelf.dataSources objectAtIndex:0]];
            if (ClsTableViewCell == [BlankTableViewCell class]) {
                [weakSelf.dataSources removeObjectAtIndex:0];
            }
        }
        
        weakSelf.tableView.enableLoadingMore = YES;
        weakSelf.tableView.enableRefreshing = NO;//YES;
        
        BOOL ignoreCount = 0;
        if ([addedItems count]>0) {
            NSMutableArray *array = nil;
            if ([weakSelf.goodsArrayList count]>0) {
                array = [weakSelf.goodsArrayList objectAtIndex:[weakSelf.goodsArrayList count]-1];
            }
            if (array && [array count]==1) {
                [array addObject: [RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:0]]];
                ignoreCount = 1;
            }
        }
        
        NSMutableArray *addedGoodsArrayList = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[addedItems count]-ignoreCount;i+=2) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]]];
            if (i+1>=[addedItems count]-ignoreCount) {
                //                [weakSelf.goodsArrayList addObject:array];
                [addedGoodsArrayList addObject:array];
                break;
            }
            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
            //[weakSelf.goodsArrayList addObject:array];
            [addedGoodsArrayList addObject:array];
        }
        
        [weakSelf.goodsArrayList addObjectsFromArray:addedGoodsArrayList];
        
        for (NSInteger i=0;i<[addedGoodsArrayList count];i++) {
            NSArray *array = [addedGoodsArrayList objectAtIndex:i];
            if ([weakSelf.dataSources count]>0) {
                [weakSelf.dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
            }
            [weakSelf.dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
        }
        if (loadFinished) {
            [weakSelf.dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
        }
        [weakSelf.tableView reloadData];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        
        [weakSelf hideHUD];
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        
        [weakSelf hideHUD];
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        
        weakSelf.tableView.enableRefreshing = NO;//YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:1];
        //        [newList addObject:[BlankTableViewCell buildCellDict:weakSelf.tableView title:@"暂无商品"]];
        //        [weakSelf.dataSources removeAllObjects];
        //        [weakSelf setDataSources:newList];
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };

//    if (!weakSelf.dataListLogic) {
//        [weakSelf.dataListLogic reloadDataListByForce];
//    }
}


- (void)setupReachabilityChangedObserver {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:AFNetworkingReachabilityDidChangeNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleReachabilityChanged:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    ADMShoppingSiftView *siftView= [[ADMShoppingSiftView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
//    siftView.backgroundColor = [UIColor whiteColor];
//    [siftView getFilterInfoArray:self.filterInfoArray];
//    siftView.handleFilterButtonActionBlock = ^(SearchFilterInfo *filterInfo){
//        
//        if (filterInfo) {
//            [self doSearch];
//        }
//        
//    };
    return self.siftView;
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

- (void)$$handleGoodsLiked:(id<MBNotification>)notifi goodsId:(NSString*)goodsId
{
    [self handleGoodsLikedEvent:notifi goodsId:goodsId liked:YES];
}

- (void)$$handleGoodsUnLiked:(id<MBNotification>)notifi goodsId:(NSString*)goodsId
{
    [self handleGoodsLikedEvent:notifi goodsId:goodsId liked:NO];
}

- (void)handleGoodsLikedEvent:(id<MBNotification>)notifi goodsId:(NSString*)goodsId liked:(BOOL)isLiked
{
    BOOL isNeedReload = NO;

    for (NSArray * array in self.goodsArrayList) {
        for (RecommendGoodsInfo *recommendGoodsInfo in array) {
            if ([recommendGoodsInfo isKindOfClass:[RecommendGoodsInfo class]]
                && [recommendGoodsInfo.goodsId isEqualToString:goodsId]) {
                if (recommendGoodsInfo.isLiked != isLiked) {
                    recommendGoodsInfo.isLiked = isLiked;
                    if (isLiked) {
                        recommendGoodsInfo.goodsStat.likeNum += 1;
                    } else {
                        recommendGoodsInfo.goodsStat.likeNum -= 1;
                    }
                    isNeedReload = YES;
                }
            }
        }
    }
    if (isNeedReload) {
        [self.tableView reloadData];
    }
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    
    [tableViewCell updateCellWithDict:dict];
    return tableViewCell;
}

-(CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 44.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

-(void)setUpUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom).offset(1);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
    
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    
    [self createPopMenuView];
    
}

- (void)createPopMenuView
{
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _titles.count; i++) {
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = _images[i];
        info.title = _titles[i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager] showPopMenuSelecteWithFrame:kScreenWidth/375*150 item:obj action:^(NSInteger index) {
        //@[@"消息",@"首页",@"我要反馈",@"分享"];
        switch (index) {
            case 0:
            {
                [[CoordinatingController sharedInstance] popToRootViewControllerAnimated:YES];
                [[CoordinatingController sharedInstance].mainViewController setSelectedAtIndex:3];
            }
                break;
            case 1:
            {
                [[CoordinatingController sharedInstance] gotoHomeRecommendViewControllerAnimated:YES];
            }
                break;
            case 2:
            {
                FeedbackViewController * about = [[FeedbackViewController alloc] init];
                [[CoordinatingController sharedInstance] pushViewController:about animated:YES];
                break;
            }
            case 3:
                [self shareGoods];
                break;
                
            default:
                break;
        }
    }];
}

- (void)shareGoods
{

    [[CoordinatingController sharedInstance] shareWithTitle:@"全程监控、权威坚定、鉴定证书"
                                                      image:[UIImage imageNamed:@"AppIcon_120"]
                                                        url:kURLAdmUserHome(self.userDetailInfo.userInfo.userId)
                                                    content:[NSString stringWithFormat:@"%@",self.userDetailInfo.userInfo.userName]];
}

- (void)updateGoodsNumLbl:(NSInteger)goodsNum
{
    if (goodsNum > 0) {
        if (goodsNum<100) {
            NSString *title = [NSString stringWithFormat:@"%ld",(long)goodsNum];
            //            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:9.5f]];
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            _goodsNumLbl.hidden = NO;
        } else {
            NSString *title = @"...";
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            _goodsNumLbl.hidden = NO;
        }
        
    } else {
        [_goodsNumLbl setTitle:@"" forState:UIControlStateDisabled];
        _goodsNumLbl.hidden = YES;
    }
}

- (UIButton*)buildGoodsNumLbl
{
    //        UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(27.5, 6, 14, 13)];
    goodsNumLbl.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    goodsNumLbl.layer.cornerRadius = 6.5f;
    goodsNumLbl.layer.masksToBounds = YES;
    [goodsNumLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    goodsNumLbl.enabled = NO;
    goodsNumLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    goodsNumLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    goodsNumLbl.titleLabel.font = [UIFont systemFontOfSize:9.5f];
    return goodsNumLbl;
}

@end
