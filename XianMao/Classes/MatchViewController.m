//
//  MatchViewController.m
//  XianMao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MatchViewController.h"
#import "PullRefreshTableView.h"
#import "MatchTableViewCell.h"

#import "DataListLogic.h"
#import "NetworkAPI.h"
#import "NetworkManager.h"

#import "RecommendUser.h"

#import "JSONKit.h"
#import "NSString+URLEncoding.h"
#import "Masonry.h"
#import "Error.h"

#import "Session.h"
#import "GoodsMemCache.h"
#import "GoodsInfo.h"

#import "ForumPostTableViewCell.h"

@interface MatchViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;

@property (nonatomic, strong) RecommendUser *recommendUser;
@property (nonatomic, strong) RecoveryGoodsVo *goosVO;

@end

@implementation MatchViewController

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTopBar];
    [self setupTopBarBackButton];
    [self setupTopBarTitle:@"自助匹配"];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.pullDelegate = self;
    self.tableView.separatorStyle = NO;
    [self.view addSubview:self.tableView];
    
    [self setUpUI];
    [self showLoadingView];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChatControlelr:) name:@"pushChatBtn" object:nil];
}

-(void)pushChatControlelr:(NSNotification *)notify{
    //聊天更改下，把商品带过去
    RecommendUser *remcommendUser = notify.object;
    MainPic *mainPic = self.goosVO.mainPic;
    GoodsInfo *goodsInfo = [[GoodsInfo alloc] init];
    goodsInfo.goodsId = self.goosVO.goodsSn;
    goodsInfo.goodsName = self.goosVO.goodsName;
    goodsInfo.thumbUrl = mainPic.pic_url;
    BOOL isYes = NO;
    [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:&isYes];
    [UserSingletonCommand chatRecoverWithUser:remcommendUser.userId andIsYes:2 andGoodsVO:self.goosVO andBidVO:nil];
//    [UserSingletonCommand chatBalance:self.goosVO.goodsSn];
}

-(void)getRecoverGoodsVO:(RecoveryGoodsVo *)goosVO{
    self.goosVO = goosVO;
}

-(void)loadData{
    WEAKSELF;
    
    if ([weakSelf.dataSources count]>0) {
        NSDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        if (ClsTableViewCell!=[ForumPostListNoContentTableCell class]) {
        weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
         }
    }
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getRecommenUser:self.goods_id completion:^(NSDictionary *data) {
        [weakSelf hideLoadingView];
        NSMutableArray *listArr = data[@"list"];
//        if (listArr.count == 0) {
//            [weakSelf showHUD:@"您的商品已卖掉" hideAfterDelay:0.8f];
//            return ;
//        }
        if (listArr.count > 0) {
            RecommendUser *recommendUser = (RecommendUser*)[listArr objectAtIndex:0];
            self.recommendUser = recommendUser;
        } else {
            [weakSelf showHUD:@"没有合适的回收商" hideAfterDelay:0.8f];
            return ;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.dataListLogic) {
                [weakSelf.dataListLogic reloadDataListByForce];
            } else {
                [weakSelf initDataListLogic];
            }
        });
    } failure:^(XMError *error) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
            [weakSelf loadData];
        };
    }]];
    
}

-(void)initDataListLogic{
    WEAKSELF;
    NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
    if (self.recommendUser) {
        [paramsArray addObject:self.recommendUser];
    }
    NSString *paramsJsonData = [[[paramsArray toJSONArray] JSONString] URLEncodedString];
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"recovery" path:@"get_recommend_user" pageSize:20];
    _dataListLogic.parameters = @{@"params":paramsJsonData,@"goods_sn":self.goods_id};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    
//    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
//        if ([weakSelf.dataSources count]>0) {
//            NSDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
//            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
//            if (ClsTableViewCell!=[ForumPostListNoContentTableCell class]) {
//                weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
//            }
//        }
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//    };
//    
//    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
//        [weakSelf hideLoadingView];
//        
//        //        weakSelf.postArr = [NSMutableArray arrayWithArray:addedItems];
//        
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
//        weakSelf.tableView.autoTriggerLoadMore = YES;
//        
//        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
//        
//        for (int i=0;i<[addedItems count];i++) {
//            NSDictionary *dict = [addedItems objectAtIndex:i];
//            if ([dict isKindOfClass:[NSDictionary class]]) {
//                RecommendUser *recommendUser = [[RecommendUser alloc] initWithJSONDictionary:dict];
//                weakSelf.recommendUser = recommendUser;
//                if (recommendUser.userId > 0) {
//                    [newList addObject:[MatchTableViewCell buildCellDict:recommendUser]];
//                    [newList addObject:[ForumPostTableSepCell buildCellDict]];
//                }
//            }
//        }
//        weakSelf.dataSources = newList;
//        [weakSelf.tableView reloadData];
//    };
    
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            NSDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
            if (ClsTableViewCell!=[ForumPostListNoContentTableCell class]) {
                weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
            }
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        //        weakSelf.postArr = [NSMutableArray arrayWithArray:addedItems];
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
//        if (weakSelf.recommendUser.userId>0) {
//            [newList addObject:[ForumTopicDescTableViewCell buildCellDict:weakSelf.topicVO.head_text]];
//        }
//        [newList addObject:[ForumPostSearchTableCell buildCellDict]];
        
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                RecommendUser *recommendUser = [[RecommendUser alloc] initWithJSONDictionary:dict];
                if (recommendUser.userId>0) {
                    [newList addObject:[MatchTableViewCell buildCellDict:recommendUser]];
                    [newList addObject:[ForumPostTableSepCell buildCellDict]];
                }
            }
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    };
    
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
//        if ([dataSources count]==0) {
//            if (weakSelf.recommendUser.userId>0) {
//                [dataSources addObject:[MatchTableViewCell buildCellDict:weakSelf.recommendUser]];
//            }
//            [dataSources addObject:[ForumPostSearchTableCell buildCellDict]];
//        }
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            
            RecommendUser *recommendUser = [[RecommendUser alloc] initWithJSONDictionary:dict];
            if (recommendUser.userId>0) {
                [dataSources addObject:[MatchTableViewCell buildCellDict:recommendUser]];
                [dataSources addObject:[ForumPostTableSepCell buildCellDict]];
            }
        }
        weakSelf.dataSources = dataSources;
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
//    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
//        
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = YES;
//        
//        [weakSelf hideLoadingView];
//        
//        NSMutableArray *dataSources = [[NSMutableArray alloc] init];
//        if (weakSelf.recommendUser.userId>0) {
//            [dataSources addObject:[ForumTopicDescTableViewCell buildCellDict:weakSelf.topicVO.head_text]];
//        }
//        [dataSources addObject:[ForumPostSearchTableCell buildCellDict]];
//        
//        CGFloat cellHeight = weakSelf.tableView.height-[ForumPostSearchTableCell rowHeightForPortrait];
//        [dataSources addObject:[ForumPostListNoContentTableCell buildCellDict:cellHeight]];
//        weakSelf.dataSources = dataSources;
//        [weakSelf.tableView reloadData];
//        
//        [weakSelf setNavTitleBar:weakSelf.selectedFilterVO.display];
//    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    if ([weakSelf.dataSources count]==0) {
        [weakSelf showLoadingView].backgroundColor = [UIColor clearColor];
    }
    [_dataListLogic firstLoadFromCache];
}

-(void)setUpUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if ([tableViewCell isKindOfClass:[MatchTableViewCell class]]) {
        MatchTableViewCell *matchtableViewCell = (MatchTableViewCell *)tableViewCell;
        [matchtableViewCell updateCellWithDict:dict];
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

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
        [_dataListLogic nextPage];
}

@end
