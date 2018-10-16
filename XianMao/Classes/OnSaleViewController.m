//
//  OnSaleViewController.m
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "OnSaleViewController.h"
#import "RreshenShowView.h"
#import "DataListLogic.h"

#import "NetworkAPI.h"
#import "Session.h"

#import "OnSaleTableViewCell.h"
#import "SepTableViewCell.h"

#import "GoodsInfo.h"
#import "RecoveryGoodsDetail.h"

#import "CoordinatingController.h"

#import "WCAlertView.h"
#import "PublishGoodsViewController.h"
#import "IssueViewController.h"

#import "GoodsService.h"

#import "SearchViewController.h"
//#import "ChatSendHelper.h"
#import "EaseSDKHelper.h"
#import "PublishViewController.h"


@interface OnSaleViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>


@property(nonatomic,strong) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property (strong, nonatomic) EMConversation *conversation;//会话管理者
@property (nonatomic, assign) BOOL isChatGroup;
@property(nonatomic,strong) HTTPRequest *request;
@property (nonatomic, strong) RreshenShowView * rreshen;

@end

@implementation OnSaleViewController

- (id)init {
    self = [super init];
    if (self) {
//        self.type = 1;
//        self.mineStatus = 1;
//        self.recoverStatus = 10;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
//    [super setupTopBarTitle:@"在售"];
//    [super setupTopBarBackButton];
    
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    
    if (self.isHaveTopbar) {
        CGFloat topBarHeight = [super setupTopBar];
        [super setupTopBarTitle:@"推荐商品"];
        [super setupTopBarBackButton];
        self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    } else {
        CGFloat topBarHeight = 0;
        self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight - 105)];
    }
    
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    [self.view addSubview:self.tableView];
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    
    [self initDataListLogic];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setMineSold) name:@"setMineSold" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setRecoverSold) name:@"setRecoverSold" object:nil];
}

-(void)setMineSold{
//    self.type = 1;
    self.mineStatus = 1;
    [self initDataListLogic];
}

-(void)setRecoverSold{
//    self.type = 2;
    self.recoverStatus = 10;
    [self initDataListLogic];
}

- (void)handleReachabilityChanged:(id)notificationObject {
    //self.tableView.enableLoadingMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)initDataListLogic {
    WEAKSELF;
    if (self.type == 1) {
        _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"goods" path:@"onsale" pageSize:20];
        _dataListLogic.parameters = @{@"status" : [NSNumber numberWithInteger:weakSelf.mineStatus]};
//        _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    } else if (self.type == 2) {
        _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"recovery" path:@"get_recovery_goods_list" pageSize:20];
        _dataListLogic.parameters = @{@"status" : [NSNumber numberWithInteger:weakSelf.recoverStatus]};
        
    }
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        } else {
            [weakSelf showLoadingView];
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            if (weakSelf.type == 1) {
                [newList addObject:[OnSaleTableViewCell buildCellDict:[GoodsInfo createWithDict:[addedItems objectAtIndex:i]]]];
            } else if (weakSelf.type == 2) {
                [newList addObject:[OnSaleTableViewCell buildRecoverCellDict:[[RecoveryGoodsDetail alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]]]];
//                RecoveryGoodsDetail *goodsDetail = [[RecoveryGoodsDetail alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]];
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
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            if (weakSelf.type == 1) {
                [newList addObject:[OnSaleTableViewCell buildCellDict:[GoodsInfo createWithDict:[addedItems objectAtIndex:i]]]];
            } else if (weakSelf.type == 2) {
                [newList addObject:[OnSaleTableViewCell buildRecoverCellDict:[[RecoveryGoodsDetail alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]]]];
                //                RecoveryGoodsDetail *goodsDetail = [[RecoveryGoodsDetail alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]];
            }
        }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                [newList insertObject:[SepTableViewCell buildCellDict] atIndex:0];
            }
            [dataSources addObjectsFromArray:newList];
            
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
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
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton:@"无在售商品"].handleRetryBtnClicked=^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };;
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic firstLoadFromCache];
    
    [weakSelf showLoadingView];
}

- (void)handleTopBarViewClicked {
    [_tableView scrollViewToTop:YES];
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
    return [self.dataSources count];
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
    [tableViewCell updateCellWithDict:dict];
    
    if ([tableViewCell isKindOfClass:[OnSaleTableViewCell class]]) {
        OnSaleTableViewCell *saleTableViewCell = (OnSaleTableViewCell *)tableViewCell;
        [saleTableViewCell getIsChatCome:self.isChatCome];
        saleTableViewCell.type = self.type;
        WEAKSELF;
        ((OnSaleTableViewCell*)tableViewCell).handleApplyOffSaleBlock = ^(GoodsInfo *goodsInfo) {
            [weakSelf showProcessingHUD:nil];
            weakSelf.request = [[NetworkAPI sharedInstance] tryOffsale:goodsInfo.goodsId completion:^(NSInteger result, NSString *message) {
                //0 下架后商品将不能出售，确认申请下架吗
                //1 商品已下架
                //2 商品已交易锁定，不能申请下架
                //3 商品已出售，不能申请下架
                //4 商品下架处理中
                if (result == 0) {
                    [weakSelf hideHUD];
                    [weakSelf showOffsaleAlertView:goodsInfo.goodsId message:message];
                } else {
                    [weakSelf showHUD:message hideAfterDelay:1.2f forView:weakSelf.view];
                }
                
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
            }];
        };
        ((OnSaleTableViewCell*)tableViewCell).handleOnSaleBlock = ^(GoodsInfo *goodsInfo, RecoveryGoodsVo *goodsVO) {
            if (goodsVO) {
                if ([goodsVO isNotOnSales]) {
                    [weakSelf showProcessingHUD:nil];
                    [GoodsService switchOnSale:goodsVO.goodsSn onsale:YES completion:^{
                        [weakSelf hideHUD];
                        
                        GoodsStatusDO *statusDO = [[GoodsStatusDO alloc] init];
                        statusDO.goodsId = goodsVO.goodsSn;
                        statusDO.status = GOODS_STATUS_ON_SALE;
                        SEL selector = @selector($$handleOnSaleSatusChangedNotification:statusDO:);
                        MBGlobalSendNotificationForSELWithBody(selector, statusDO);
                        
                        //                    goodsInfo.status = GOODS_STATUS_ON_SALE;
                        //                    [weakSelf.tableView reloadData];
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                }
            } else if (goodsInfo) {
                if ([goodsInfo isNotOnSale]) {
                    [weakSelf showProcessingHUD:nil];
                    [GoodsService switchOnSale:goodsInfo.goodsId onsale:YES completion:^{
                        [weakSelf hideHUD];
                        
                        GoodsStatusDO *statusDO = [[GoodsStatusDO alloc] init];
                        statusDO.goodsId = goodsInfo.goodsId;
                        statusDO.status = GOODS_STATUS_ON_SALE;
                        SEL selector = @selector($$handleOnSaleSatusChangedNotification:statusDO:);
                        MBGlobalSendNotificationForSELWithBody(selector, statusDO);
                        
                        //                    goodsInfo.status = GOODS_STATUS_ON_SALE;
                        //                    [weakSelf.tableView reloadData];
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                }
            }
        };
        ((OnSaleTableViewCell*)tableViewCell).handleOffSaleBlock = ^(GoodsInfo *goodsInfo, RecoveryGoodsVo *goodsVO) {
            if (goodsVO) {
                if ([goodsVO isOnSales]) {
                    [weakSelf showProcessingHUD:nil];
                    [GoodsService switchOnSale:goodsVO.goodsSn onsale:NO completion:^{
                        [weakSelf hideHUD];
                        
                        GoodsStatusDO *statusDO = [[GoodsStatusDO alloc] init];
                        statusDO.goodsId = goodsVO.goodsSn;
                        statusDO.status = GOODS_STATUS_NOT_SALE;
                        SEL selector = @selector($$handleOnSaleSatusChangedNotification:statusDO:);
                        MBGlobalSendNotificationForSELWithBody(selector, statusDO);
                        
//                                            goodsVO.status = GOODS_STATUS_NOT_SALE;
//                        [RecoveryGoodsVo goodsStatusDescription:GOODS_STATUS_NOT_SALE];
//                                            [weakSelf.tableView reloadData];
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                }
            } else if (goodsInfo) {
                if ([goodsInfo isOnSale]) {
                    [weakSelf showProcessingHUD:nil];
                    [GoodsService switchOnSale:goodsInfo.goodsId onsale:NO completion:^{
                        [weakSelf hideHUD];
                        
                        GoodsStatusDO *statusDO = [[GoodsStatusDO alloc] init];
                        statusDO.goodsId = goodsInfo.goodsId;
                        statusDO.status = GOODS_STATUS_NOT_SALE;
                        SEL selector = @selector($$handleOnSaleSatusChangedNotification:statusDO:);
                        MBGlobalSendNotificationForSELWithBody(selector, statusDO);
                        
//                                            goodsInfo.status = GOODS_STATUS_NOT_SALE;
//                                            [weakSelf.tableView reloadData];
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                }
            }
        };
        ((OnSaleTableViewCell*)tableViewCell).handleEditBlock = ^(GoodsInfo *goodsInfo, RecoveryGoodsDetail *goodsDeatil) {
            if (self.type == 1) {
                PublishViewController *viewController = [[PublishViewController alloc] init];
                viewController.goodsId = goodsInfo.goodsId;
                viewController.isEditGoods = YES;
                viewController.isResell = NO;
                viewController.handlePublishGoodsFinished = ^(GoodsEditableInfo *goodsEditableInfo) {
                    [goodsInfo udpateWithEditableInfo:goodsEditableInfo];
                    [weakSelf.tableView reloadData];
                };
                [weakSelf pushViewController:viewController animated:YES];
            } else if (self.type == 2) {
                IssueViewController *viewController = [[IssueViewController alloc] init];
                RecoveryGoodsVo *goodsVO = goodsDeatil.recoveryGoodsVo;
                viewController.goodsID = goodsVO.goodsSn;
                viewController.index = 100;
                [weakSelf pushViewController:viewController animated:YES];
            }
            
        };
        
        typeof(tableViewCell) __weak weaktableViewCell = tableViewCell;
        ((OnSaleTableViewCell*)tableViewCell).handleRefreshBlock = ^(GoodsInfo *goodsInfo) {
            [weakSelf showProcessingHUD:nil];
            [GoodsService refreshGoods:goodsInfo.goodsId completion:^(long long modifyTime){
                
                for (NSDictionary *dict in weakSelf.dataSources) {
                    GoodsInfo *tmpGoodsInfo = (GoodsInfo*)[dict objectForKey:[OnSaleTableViewCell cellDictKeyForGoodsInfo]];
                    if (tmpGoodsInfo.goodsId == goodsInfo.goodsId) {
                        tmpGoodsInfo.modifyTime = modifyTime;
                        tmpGoodsInfo.isRefresh = 1;
                        tmpGoodsInfo.surplusDay = 30;
                        break;
                    }
                }
                
                [weakSelf.tableView reloadData];
                [((OnSaleTableViewCell*)weaktableViewCell).scrollLabel beginScroll];
                [weakSelf showHUD:@"已成功擦亮" hideAfterDelay:0.8f];
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
        
        
        ((OnSaleTableViewCell*)tableViewCell).handleRreshenBlock = ^(GoodsInfo * goodsInfo){
            
            RreshenShowView * rreshen = [[RreshenShowView alloc] initWithFrame:self.view.bounds];
            [rreshen getGoodsInfo:goodsInfo];
            typeof(rreshen) __weak weakRreshen = rreshen;
            rreshen.handleRreshenBlcok = ^(GoodsInfo * goodsInfo){
                [weakSelf showProcessingHUD:nil];
                [GoodsService refreshGoods:goodsInfo.goodsId completion:^(long long modifyTime){
                    [weakRreshen dismiss];
                    for (NSDictionary *dict in weakSelf.dataSources) {
                        GoodsInfo *tmpGoodsInfo = (GoodsInfo*)[dict objectForKey:[OnSaleTableViewCell cellDictKeyForGoodsInfo]];
                        if (tmpGoodsInfo.goodsId == goodsInfo.goodsId) {
                            tmpGoodsInfo.modifyTime = modifyTime;
                            tmpGoodsInfo.isRefresh = 1;
                            tmpGoodsInfo.surplusDay = 30;
                            break;
                        }
                    }
                    
                    [weakSelf.tableView reloadData];
                    [weakSelf showHUD:@"已成功擦亮" hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
                    [((OnSaleTableViewCell*)weaktableViewCell).scrollLabel beginScroll];
                } failure:^(XMError *error) {
                    [weakRreshen dismiss];
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
                }];
                
            };
            
            [rreshen show];
            
        };
        
        
        ((OnSaleTableViewCell*)tableViewCell).handleDeleteBlock = ^(NSString *goodsId) {
            [weakSelf showProcessingHUD:nil];
            [GoodsService deleteGoods:goodsId completion:^{
                
                SEL selector = @selector($$handleGoodsDeletedNotification:goodsId:);
                MBGlobalSendNotificationForSELWithBody(selector, goodsId);
                
//                for (NSInteger i=0;i<weakSelf.dataSources.count;i++) {
//                    NSDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
//                    GoodsInfo *tmpGoodsInfo = (GoodsInfo*)[dict objectForKey:[OnSaleTableViewCell cellDictKeyForGoodsInfo]];
//                    if ([tmpGoodsInfo.goodsId isEqualToString:goodsId]) {
//                        if (i+1<weakSelf.dataSources.count) {
//                            [weakSelf.dataSources removeObjectAtIndex:i+1];
//                            [weakSelf.dataSources removeObjectAtIndex:i];
//                        }
//                        else {
//                            if (i==weakSelf.dataSources.count-1 && i-1>=0) {
//                                [weakSelf.dataSources removeObjectAtIndex:i];
//                                [weakSelf.dataSources removeObjectAtIndex:i-1];
//                            } else {
//                                [weakSelf.dataSources removeObjectAtIndex:i];
//                            }
//                        }
//                        break;
//                    }
//                }
//                
//                [weakSelf.tableView reloadData];
                
                if ([weakSelf.dataSources count]==0) {
                    [weakSelf loadEndWithNoContentWithRetryButton:@"无在售商品"].handleRetryBtnClicked=^(LoadingView *view) {
                        [weakSelf.dataListLogic reloadDataListByForce];
                    };;
                }
                
                [weakSelf showHUD:@"商品已被删除" hideAfterDelay:0.8f];
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
    }
    
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
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    if (![dict isEqual:[NSNull null]]) {
        if (self.isHaveTopbar) {
            RecoveryGoodsDetail *goodsDeatil = (RecoveryGoodsDetail*)[dict objectForKey:@"goodsDetail"];
            RecoveryGoodsVo *goodsVO = goodsDeatil.recoveryGoodsVo;
            MainPic *mainPic = goodsVO.mainPic;
            NSDictionary *goodsDic = @{@"goods_id":goodsVO.goodsSn,
                                       @"goods_name" : [goodsVO.goodsName length]>0?goodsVO.goodsName:@"",
                                       //                                   @"shop_price" : [NSNumber numberWithDouble:goodsVO.shopPrice],
                                       @"thumb_url" : [mainPic.pic_url length]>0?mainPic.pic_url:@"",
                                       @"service_type" : [NSNumber numberWithInteger:goodsVO.service_type]};
            
            
            NSString *avatarUrl = [Session sharedInstance].currentUser.avatarUrl;
            
            NSMutableDictionary *extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"fromNickname" : [Session sharedInstance].currentUser.userName,
                                                                                              @"fromHeaderImg" : [avatarUrl length]>0?avatarUrl:@"",
                                                                                              @"fromUserId" : [NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId],
                                                                                              @"toNickname" : [_sellerName length]>0?_sellerName:@"",
                                                                                              @"toHeaderImg": [_sellerHeaderImg length]>0?_sellerHeaderImg:@"",
                                                                                              @"toUserId" : [NSNumber numberWithInteger:_sellerId]}];
            _isChatGroup = NO;
            [extMessage addEntriesFromDictionary:@{@"type":@1,@"goods":goodsDic}];
            
            //根据接收者的username获取当前会话的管理者
            //        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:_chatter conversationType:eConversationTypeChat];
            _conversation = [[EMClient sharedClient].chatManager getConversation:_chatter type:EMConversationTypeChat createIfNotExist:YES];
            
            //        EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:@"[商品信息]"
            //                                                                toUsername:_conversation.chatter
            //                                                               isChatGroup:_isChatGroup
            //                                                         requireEncryption:NO
            //                                                                       ext:extMessage];
            EMMessage *tempMessage = [EaseSDKHelper sendTextMessage:@"[商品信息]" to:_conversation.conversationId messageType:_isChatGroup messageExt:extMessage];
            
            //        [self addChatDataToMessage:tempMessage];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"addChatData" object:tempMessage];
            [self dismiss];
            
        } else {
            
            if (self.type == 1) {
                GoodsInfo *goodsInfo = (GoodsInfo*)[dict objectForKey:[OnSaleTableViewCell cellDictKeyForGoodsInfo]];
                if (goodsInfo) {
                    NSDictionary *data = @{@"goodsId":goodsInfo.goodsId};
                    [ClientReportObject clientReportObjectWithViewCode:self.viewCode regionCode:HomeChosenGoodsRegionCode referPageCode:HomeChosenGoodsRegionCode andData:data];
                    [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:goodsInfo.goodsId animated:YES];
                }
            } else if (self.type == 2) {
                RecoveryGoodsDetail *goodsDeatil = (RecoveryGoodsDetail*)[dict objectForKey:@"goodsDetail"];
                if (goodsDeatil) {
                    RecoveryGoodsVo *goodsVO = goodsDeatil.recoveryGoodsVo;
                    if (goodsVO) {
                        NSDictionary *data = @{@"goodsId":goodsVO.goodsSn};
                        [ClientReportObject clientReportObjectWithViewCode:self.viewCode regionCode:RecoveryGoodsDetailViewCode referPageCode:RecoveryGoodsDetailViewCode andData:data];
                        //            [[CoordinatingController sharedInstance] gotoRecoverDetailViewController:goodsVO.goodsSn index:2 animated:YES];
                        [[CoordinatingController sharedInstance] gotoOfferedViewController:goodsVO.goodsSn index:2 animated:YES];
                    }
                }
            }
        }
    }
    
//    PublishGoodsViewController *viewController = [[PublishGoodsViewController alloc] init];
//    viewController.goodsId = goodsInfo.goodsId;
//    viewController.isEditGoods = YES;
//    [self pushViewController:viewController animated:YES];
}

- (void)showOffsaleAlertView:(NSString*)goodsId message:(NSString*)message
{
    WEAKSELF;
    [WCAlertView showAlertWithTitle:@""
                            message:message&&[message length]>0?message:@"确认延长收货时间？\n每笔订单只能延长一次哦"
                 customizationBlock:^(WCAlertView *alertView) {
                     alertView.style = WCAlertViewStyleWhite;
                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                     if (buttonIndex == 0) {
                         
                     } else {
                         [weakSelf showProcessingHUD:nil forView:weakSelf.view];
                         weakSelf.request = [[NetworkAPI sharedInstance] apllyOffsale:goodsId completion:^() {
                             [weakSelf showHUD:@"申请下架成功" hideAfterDelay:1.2f forView:weakSelf.view];
                         } failure:^(XMError *error) {
                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
                         }];
                     }
                 } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
}


- (void)$$handleOnSaleSatusChangedNotification:(id<MBNotification>)notifi statusDO:(GoodsStatusDO*)statusDO
{
    WEAKSELF;
    for (NSInteger i=0;i<weakSelf.dataSources.count;i++) {
        NSDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
        GoodsInfo *tmpGoodsInfo = (GoodsInfo*)[dict objectForKey:[OnSaleTableViewCell cellDictKeyForGoodsInfo]];
        RecoveryGoodsDetail *goodsDetail = (RecoveryGoodsDetail *)[dict objectForKey:[OnSaleTableViewCell cellDictKeyForGoodsDetail]];
        if (tmpGoodsInfo) {
            if ([tmpGoodsInfo.goodsId isEqualToString:statusDO.goodsId]) {
                tmpGoodsInfo.status = statusDO.status;
                break;
            }
        }
        
        if (goodsDetail) {
            RecoveryGoodsVo *goodsVO = goodsDetail.recoveryGoodsVo;
            if ([goodsVO.goodsSn isEqualToString:statusDO.goodsId]) {
                goodsVO.status = statusDO.status;
                break;
            }
        }
        
        
        
    }
    
    [weakSelf.tableView reloadData];
}

- (void)$$handleGoodsDeletedNotification:(id<MBNotification>)notifi goodsId:(NSString*)goodsId {
    
    WEAKSELF;
    for (NSInteger i=0;i<weakSelf.dataSources.count;i++) {
        NSDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
        GoodsInfo *tmpGoodsInfo = (GoodsInfo*)[dict objectForKey:[OnSaleTableViewCell cellDictKeyForGoodsInfo]];
        RecoveryGoodsDetail *goodsDetail = (RecoveryGoodsDetail *)[dict objectForKey:[OnSaleTableViewCell cellDictKeyForGoodsDetail]];
        RecoveryGoodsVo *tmpGoodsVO = goodsDetail.recoveryGoodsVo;
        if ([tmpGoodsInfo.goodsId isEqualToString:goodsId] || [tmpGoodsVO.goodsSn isEqualToString:goodsId]) {
            if (i+1<weakSelf.dataSources.count) {
                [weakSelf.dataSources removeObjectAtIndex:i+1];
                [weakSelf.dataSources removeObjectAtIndex:i];
            }
            else {
                if (i==weakSelf.dataSources.count-1 && i-1>=0) {
                    [weakSelf.dataSources removeObjectAtIndex:i];
                    [weakSelf.dataSources removeObjectAtIndex:i-1];
                } else {
                    [weakSelf.dataSources removeObjectAtIndex:i];
                }
            }
            break;
        }
    }
    
    [weakSelf.tableView reloadData];
    
    if ([weakSelf.dataSources count]==0) {
        [weakSelf loadEndWithNoContentWithRetryButton:@"无在售商品"].handleRetryBtnClicked=^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };;
    }
}
@end



@implementation PublishedViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)initDataListLogic {
    WEAKSELF;
    super.dataListLogic = [[DataListLogic alloc] initWithModulePath:@"goods" path:@"get_published_goods" pageSize:20];
    super.dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    super.dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        } else {
            [weakSelf showLoadingView];
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    super.dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            [newList addObject:[OnSaleTableViewCellPublished buildCellDict:[GoodsInfo createWithDict:[addedItems objectAtIndex:i]]]];
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    };
    super.dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    super.dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            [newList addObject:[OnSaleTableViewCellPublished buildCellDict:[GoodsInfo createWithDict:[addedItems objectAtIndex:i]]]];
        }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                [newList insertObject:[SepTableViewCell buildCellDict] atIndex:0];
            }
            [dataSources addObjectsFromArray:newList];
            
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
    };
    super.dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
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
    super.dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton:@"无在售商品"].handleRetryBtnClicked =^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };
    };
    super.dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [super.dataListLogic firstLoadFromCache];
    
    [weakSelf showLoadingView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end


#import "TopBarRightCancelButton.h"
#import "NSString+Addtions.h"
#import "SoldViewController.h"

@interface SearchMyGoodsViewController () <UIScrollViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,SearchBarViewDelegate>

@property(nonatomic,weak) SearchBarView *searchBarView;
@property(nonatomic,weak) TopBarRightCancelButton *myTopBarRightButton;

@end

@implementation SearchMyGoodsViewController {
    DataListLogic *_searchDataListLogic;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarRightButton];
    //    [super setupTopBarBackButton];
    [self.topBarRightButton setTitle:@"取消" forState:UIControlStateNormal];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    
    SearchBarView *searchBarView = [[SearchBarView alloc] initWithFrame:CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-70.f, 29) isShowClearButton:NO isShowLeftCombBox:NO isShowHotWords:NO];
    _searchBarView = searchBarView;
    _searchBarView.placeholder = @"搜店铺商品";
    _searchBarView.delegate = self;
    _searchBarView.searchBarDelegate = self;
    
    [_searchBarView enableCancelButton:NO];
    [self.topBar addSubview:_searchBarView];
    
    _searchBarView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:0.85];
    
    self.tableView.frame = CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight);
    self.tableView.enableRefreshing = NO;
    
    [_searchBarView becomeFirstResponder];
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    [self dismiss];
}

- (void)initDataListLogic {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    UITableViewCell *tableViewCell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([tableViewCell isKindOfClass:[LockedOrSoldTableViewCell class]]) {
        ((LockedOrSoldTableViewCell*)tableViewCell).handleGoodsOrdersBlock = ^(NSString *goodsId) {
            if (goodsId && [goodsId length]>0) {
                SoldViewControllerForGoodsOrders *viewController = [[SoldViewControllerForGoodsOrders alloc] init];
                viewController.goodsId = goodsId;
                [weakSelf pushViewController:viewController animated:YES];
            }
        };
    }
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    GoodsInfo *goodsInfo = (GoodsInfo*)[dict objectForKey:[OnSaleTableViewCell cellDictKeyForGoodsInfo]];
    if (_delegate && [_delegate respondsToSelector:@selector(onSaleViewGoodsSelected:goods:)]) {
        [_delegate onSaleViewGoodsSelected:self goods:goodsInfo];
    } else {
        [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    }
}


#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keywords = [searchBar.text trim];
    [searchBar resignFirstResponder];
    [self doSearch:keywords];
//    searchBar.text = nil;
    
//    if ([keywords length]>0 && [searchBar isKindOfClass:[SearchBarView class]]) {
//        SearchViewController *viewController = [[SearchViewController alloc] init];
//        viewController.searchKeywords = keywords;
//        viewController.searchType = ((SearchBarView*)searchBar).currentSearchType;
//        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
//    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (BOOL)searchBarPromptingWordsDoSearch:(SearchBarView*)view keywords:(NSString*)keywords {
    view.text = keywords;
    [view resignFirstResponder];
    [self doSearch:keywords];
    return YES;
}

- (void)doSearch:(NSString*)keywords {
    WEAKSELF;
    weakSelf.dataListLogic = [[DataListLogic alloc] initWithModulePath:@"goods" path:@"search_goods" pageSize:20];
    weakSelf.dataListLogic.parameters = @{@"keywords":keywords?keywords:@""};
    weakSelf.dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    weakSelf.dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
//            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        } else {
            LoadingView *loadingView = [weakSelf showLoadingView];
            loadingView.backgroundColor = [UIColor clearColor];
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    weakSelf.dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if ([newList count]>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            
            GoodsInfo *goodsInfo = [GoodsInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([goodsInfo isValid]) {
                if (goodsInfo.status==GOODS_STATUS_LOCKED || goodsInfo.status==GOODS_STATUS_SOLD) {
                    [newList addObject:[LockedOrSoldTableViewCell buildCellDict:goodsInfo]];
                } else {
                    [newList addObject:[OnSaleTableViewCell buildCellDict:goodsInfo]];
                }
            } else {
                [newList addObject:[OnSaleTableViewCellPublished buildCellDict:goodsInfo]];
            }
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    };
    weakSelf.dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    weakSelf.dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            GoodsInfo *goodsInfo = [GoodsInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([goodsInfo isValid]) {
                if (goodsInfo.status==GOODS_STATUS_LOCKED || goodsInfo.status==GOODS_STATUS_SOLD) {
                    [newList addObject:[LockedOrSoldTableViewCell buildCellDict:goodsInfo]];
                } else {
                    [newList addObject:[OnSaleTableViewCell buildCellDict:goodsInfo]];
                }
            } else {
                [newList addObject:[OnSaleTableViewCellPublished buildCellDict:goodsInfo]];
            }
        }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            [dataSources addObjectsFromArray:newList];
            
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    weakSelf.dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
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
    weakSelf.dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton:@"无搜索结果"].handleRetryBtnClicked=^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };;
    };
    weakSelf.dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [weakSelf.dataListLogic firstLoadFromCache];
    
    LoadingView *loadingView = [weakSelf showLoadingView];
    loadingView.backgroundColor = [UIColor clearColor];
}

@end






