//
//  InsureViewController.m
//  XianMao
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "InsureViewController.h"

#import "HeaderView.h"
#import "BlackView.h"
#import "PromptView.h"
#import "RecoverLoadView.h"
#import "BaseTableViewCell.h"
#import "RecoverTableViewCell.h"
#import "ForumPostTableViewCell.h"
//#import "ForumPostListNoContentTableCell.h"

#import "NetworkManager.h"
#import "NetworkAPI.h"
#import "Masonry.h"
#import "Error.h"

#import "RecoveryGoodsVo.h"
#import "MainPic.h"
#import "HighestBidVo.h"
#import "SellerBasicInfo.h"

#import "NSDate+Category.h"

#import "MatchViewController.h"
#import "PullRefreshTableView.h"
#import "ChatViewController.h"

#import "JSONKit.h"
#import "NSString+URLEncoding.h"
#import "DataListLogic.h"

#import "Session.h"
@interface InsureViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate, HeaderViewDelegate>

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) PromptView *promrtView;
@property (nonatomic, strong) HeaderView *headerView;

@property (nonatomic, strong) PullRefreshTableView *tableView;

//@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, strong) HighestBidVo *bigVO;
@property (nonatomic, strong) HighestBidVo *bidPage;
@property (nonatomic, strong) RecoveryGoodsVo *recoveryGoodsVO;
@property (nonatomic, strong) SellerBasicInfo *basicInfo;
@property (nonatomic, strong) RecoveryGoodsDetail *goodsDetail;

@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, assign) BOOL isYes;

@property (nonatomic, assign) NSInteger viewCode;

@end

@implementation InsureViewController



-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

-(HeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[HeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 400)];
    }
    return _headerView;
}

//适配iOS7.0
-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.headerView layoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.viewCode = RecoveryGoodsQuoteViewCode;
    
    [super setupTopBar];
    if (self.index == 1) {
        [super setupTopBarBackButton];
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"back_Log_MF"] imgPressed:nil];
    }
    [super setupTopBarTitle:@"回收商报价"];
    [super setupTopBarRightButton:[UIImage imageNamed:@"Insure_rigth_btn_MF"] imgPressed:nil];
    
    self.tableView.tableHeaderView = self.headerView;
    self.headerView.headerDelegate = self;
//    if (!self.bidPage) {
//        self.tableView.tableFooterView = [[UIView alloc] init];
//    }
    
//    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getAuthBid:self.goodsID andUserID:self.bigVO.userId completion:^(NSDictionary *data) {
//        
//    } failure:^(XMError *error) {
//        
//    }]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.pullDelegate = self;
    self.tableView.separatorStyle = NO;
    
    [self.view addSubview:self.tableView];
    
    [self setUpUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMissBackView) name:@"dissMissBackView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(matchPushController) name:@"pushMatchController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushChatController:) name:@"pushChatController" object:nil];
//    [self loadData];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadAuthView) name:@"reloadAuthView" object:nil];
}

//-(void)reloadAuthView{
//    [self loadData];
//    [self getGoodsID:self.goodsID];
//}

- (void)loadData {
    WEAKSELF;
    [self getGoodsID:self.goodsID];
    if ([weakSelf.dataSources count]>0) {
        NSDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        if (ClsTableViewCell!=[ForumPostListNoContentTableCell class]) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
    }
    
//    [weakSelf showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getBidPage:self.goodsID completion:^(NSDictionary *data) {
//        [weakSelf hideLoadingView];
        NSMutableArray *listArr = data[@"list"];
//        weakSelf.dataSources = listArr;
        if (listArr.count > 1) {
            HighestBidVo *bigVO = (HighestBidVo*)[listArr objectAtIndex:1];
//            self.bidPage = bigVO;
            self.bigVO = bigVO;
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self loadData];
    [self getGoodsID:self.goodsID];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"remTimer" object:nil];
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
    if ([tableViewCell isKindOfClass:[RecoverTableViewCell class]]) {
        RecoverTableViewCell *recoverTableViewCell = (RecoverTableViewCell *)tableViewCell;
        [recoverTableViewCell updateCellWithDict:dict];
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
    [self.tableView scrollViewDidScroll:scrollView];
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

-(void)initDataListLogic{
    
    WEAKSELF;
    NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
    if (self.bigVO) {
        [paramsArray addObject:self.bigVO];
    }
    NSString *paramsJsonData = [[[paramsArray toJSONArray] JSONString] URLEncodedString];
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"recovery" path:@"get_bid_page" pageSize:20];
    _dataListLogic.parameters = @{@"params":paramsJsonData,@"goods_sn":self.goodsID};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        
//        if ([weakSelf.dataSources count]>0) {
//            NSDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
//            Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
//            if (ClsTableViewCell!=[ForumPostListNoContentTableCell class]) {
//                weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
//            }
//        }
        if (weakSelf.isYes) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        } else {
            weakSelf.isYes = YES;
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
        
        for (int i=1;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                HighestBidVo *bidVO = [[HighestBidVo alloc] initWithJSONDictionary:dict];
                if (bidVO.userId>0) {
                    if (weakSelf.goodsDetail.authBidVo) {
                        [weakSelf.dataSources removeAllObjects];
                    } else {
                        [newList addObject:[RecoverTableViewCell buildCellDict:bidVO]];
                        [newList addObject:[ForumPostTableSepCell buildCellDict]];
                    }
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
        for (int i=1;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            
            HighestBidVo *bidVO = [[HighestBidVo alloc] initWithJSONDictionary:dict];
            if (bidVO.userId>0) {
                if (weakSelf.goodsDetail.authBidVo) {
                    [weakSelf.dataSources removeAllObjects];
                } else {
                    [dataSources addObject:[RecoverTableViewCell buildCellDict:bidVO]];
                    [dataSources addObject:[ForumPostTableSepCell buildCellDict]];
                }
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
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        
        [weakSelf hideLoadingView];
        
        //            NSMutableArray *dataSources = [[NSMutableArray alloc] init];
        //            if (weakSelf.recommendUser.userId>0) {
        //                [dataSources addObject:[ForumTopicDescTableViewCell buildCellDict:weakSelf.topicVO.head_text]];
        //            }
        //            [dataSources addObject:[ForumPostSearchTableCell buildCellDict]];
        //
        //            CGFloat cellHeight = weakSelf.tableView.height-[ForumPostSearchTableCell rowHeightForPortrait];
        //            [dataSources addObject:[ForumPostListNoContentTableCell buildCellDict:cellHeight]];
        //            weakSelf.dataSources = dataSources;
        //            [weakSelf.tableView reloadData];
        //
        //            [weakSelf setNavTitleBar:weakSelf.selectedFilterVO.display];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    if ([weakSelf.dataSources count]==0) {
//        [weakSelf showLoadingView].backgroundColor = [UIColor clearColor];
//        [weakSelf showHUD:@"暂无报价" hideAfterDelay:1];
    }
    [_dataListLogic firstLoadFromCache];
    
}

//headerViewDelegate

-(void)pushChatViewController:(HighestBidVo *)authBidVO{
    [UserSingletonCommand chatRecoverWithUser:authBidVO.userId andIsYes:1 andGoodsVO:self.recoveryGoodsVO andBidVO:authBidVO];
}

-(void)pushChatController:(NSNotification *)notify{
//    ChatViewController *chatController = [[ChatViewController alloc] init];
    self.bigVO = notify.object;
    [UserSingletonCommand chatRecoverWithUser:self.bigVO.userId andIsYes:1 andGoodsVO:self.recoveryGoodsVO andBidVO:self.bigVO];
//    chatController.isYes = YES;
//    [self pushViewController:chatController animated:YES];
}

-(void)matchPushController{
    
    MatchViewController *matchController = [[MatchViewController alloc] init];
    [matchController getRecoverGoodsVO:self.recoveryGoodsVO];
    matchController.goods_id = self.goodsID;
    [self pushViewController:matchController animated:YES];
}

-(void)getGoodsID:(NSString *)goodsID{
    self.goodsID = goodsID;
    WEAKSELF;
    
    if (!self.goodsID) {
        return;
    }
    
//    [self showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getRecoverGoodsDetail:goodsID completion:^(NSDictionary *dict) {
//        [weakSelf hideLoadingView];
        
        RecoveryGoodsDetail *goodsDetail = [[RecoveryGoodsDetail alloc] initWithJSONDictionary:dict];
        self.goodsDetail = goodsDetail;
        
        if (![dict isEqual:[NSNull null]]) {
            NSDictionary *mainP = dict[@"recoveryGoodsVo"];
            if (![mainP isEqual:[NSNull null]]) {
                MainPic *mainPic = [[MainPic alloc] initWithJSONDictionary:[mainP dictionaryValueForKey:@"mainPic"]];
                
                RecoveryGoodsVo *recoveryGoodsVO = [[RecoveryGoodsVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"recoveryGoodsVo"]];
                self.recoveryGoodsVO = recoveryGoodsVO;
                
                SellerBasicInfo *basicInfo = recoveryGoodsVO.sellerBasicInfo;
                self.basicInfo = basicInfo;
                
                HighestBidVo *bidVO = [[HighestBidVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"highestBidVo"]];
                weakSelf.bigVO = bidVO;
                [weakSelf.headerView getRecoveryGoodsVO:recoveryGoodsVO andMianPic:mainPic andBigVO:bidVO andGoodsDetail:goodsDetail andDict:dict];
            }
        } else {
            [weakSelf dismiss];
        }
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }]];
}

-(void) setUpUI {
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
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

//-(void)handleTopBarBackButtonClicked:(UIButton *)sender{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

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
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.recoveryGoodsVO.exprTime/1000];
    NSString *time = [NSString stringWithFormat:@"%ld", (long)[date minute]];
    textLabel.text = [NSString stringWithFormat:@"收集到的报价，按照价格由低到高展现。\n\n"
                      "您授权买家购买后，\n\n"
                      "买家有%@分钟的独家拍下的权限，\n\n"
                      "超时未拍下，您可重新选择买家授权。\n\n\n", time];
    
    [promrtImageView addSubview:textLabel];
    
    UIButton *dissBtn = [[UIButton alloc] init];
    [dissBtn setImage:[UIImage imageNamed:@"dissMiss_Recocer_MF"] forState:UIControlStateNormal];
    [promrtImageView addSubview:dissBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"小贴士";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
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
