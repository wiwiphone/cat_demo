//
//  UserLikesViewController.m
//  XianMao
//
//  Created by simon cai on 11/11/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "UserLikesViewController.h"

#import "PullRefreshTableView.h"

#import "DataSources.h"

#import "CoordinatingController.h"

#import "DataListLogic.h"
#import "GoodsInfo.h"

#import "Session.h"
#import "NetworkAPI.h"

#import "UserHomeViewController.h"
#import "UserLikesTableViewCell.h"
#import "RecoverDetailViewController.h"
#import "OfferedViewController.h"
#import "EaseSDKHelper.h"

@interface UserLikesViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property(nonatomic,retain) PullRefreshTableView *tableView;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;

@property(nonatomic,strong) HTTPRequest *request;

@property (strong, nonatomic) EMConversation *conversation;//会话管理者
@end

@implementation UserLikesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    if (self.isHaveTopbar) {
        [super setupTopBarTitle:@"心动推荐"];
    } else {
        [super setupTopBarTitle:@"心动"];
    }
    [super setupTopBarBackButton];
//    [super setupTopBarRightButton];
//    self.topBarRightButton.backgroundColor = [UIColor clearColor];
//    [self.topBarRightButton setTitle:@"编辑" forState:UIControlStateNormal];
//    [self.topBarRightButton setTitle:@"完成" forState:UIControlStateSelected];
    
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    
    self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [DataSources globalWhiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithString:@"F7F7F7"];
    [self.view addSubview:self.tableView];
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    //[self updateTitleBar];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    
    if (self.userId>0) {   
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initDataListLogic];
        });
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)updateTitleBar
//{
//    if ([Session sharedInstance].isLoggedIn
//        && [Session sharedInstance].currentUserId==self.userId) {
//        self.topBarRightButton.hidden = NO;
//    } else {
//        self.topBarRightButton.hidden = YES;
//    }
//}

- (void)handleReachabilityChanged:(id)notificationObject {
    //self.tableView.enableLoadingMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
}


- (void)initDataListLogic
{
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"goods" path:@"get_likes" pageSize:20];
    _dataListLogic.parameters = @{@"user_id":[NSNumber numberWithInteger:self.userId]};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
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
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [newList addObject:[UserLikesTableViewCell buildCellDict: [GoodsInfo createWithDict:dict] isInEditMode:weakSelf.isEditing]];
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
        for (NSDictionary *dict in addedItems) {
            [dataSources addObject:[UserLikesTableViewCell buildCellDict: [GoodsInfo createWithDict:dict] isInEditMode:weakSelf.isEditing]];
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
        
        [weakSelf loadEndWithNoContent];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic firstLoadFromCache];
    
    [weakSelf showLoadingView];
}

//- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
//    
//    sender.selected = !sender.selected;
//    self.editing = sender.selected;
//    
//    for (NSInteger i=0;i<[self.dataSources count];i++) {
//        NSMutableDictionary *dict = [self.dataSources objectAtIndex:i];
//        [dict setObject:[NSNumber numberWithBool:self.editing] forKey:[UserLikesTableViewCell cellDictKeyForInEditMode]];
//    }
//    [self.tableView reloadData];
//}

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
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
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
    [MobClick event:@"click_item_from_persoanl_page_favor"];
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    if (self.isHaveTopbar) {
        GoodsInfo *goodsInfo = [dict objectForKey:[UserLikesTableViewCell cellKeyForUserLikesGoodsInfo]];
        NSDictionary *goodsDic = @{@"goods_id":goodsInfo.goodsId,
                                   @"goods_name" : [goodsInfo.goodsName length]>0?goodsInfo.goodsName:@"",
                                   @"shop_price" : [NSNumber numberWithDouble:goodsInfo.shopPrice],
                                   @"thumb_url" : [goodsInfo.thumbUrl length]>0?goodsInfo.thumbUrl:@"",
                                   @"service_type" : [NSNumber numberWithInteger:goodsInfo.serviceType]};
        
        
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
        
        EMMessage *tempMessage = [EaseSDKHelper sendTextMessage:@"[商品信息]" to:_conversation.conversationId messageType:_isChatGroup messageExt:extMessage];
        
//        EMMessage *tempMessage = [EaseSDKHelper sendTextMessageWithString:@"[商品信息]"
//                                                                toUsername:_conversation.chatter
//                                                               isChatGroup:_isChatGroup
//                                                         requireEncryption:NO
//                                                                       ext:extMessage];
        
        
        //        [self addChatDataToMessage:tempMessage];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"addChatData" object:tempMessage];
        [self dismiss];
    } else {
        GoodsInfo *goodsInfo = [dict objectForKey:[UserLikesTableViewCell cellKeyForUserLikesGoodsInfo]];
        if ([goodsInfo isKindOfClass:[goodsInfo class]]) {
            NSDictionary *data = @{@"goodsId":goodsInfo.goodsId};
            if (goodsInfo.serviceType == 10) {
                //            RecoverDetailViewController *viewController = [[RecoverDetailViewController alloc] init];
                [ClientReportObject clientReportObjectWithViewCode:MineLikeViewCode regionCode:RecoveryGoodsDetailViewCode referPageCode:RecoveryGoodsDetailViewCode andData:data];
                OfferedViewController *viewController = [[OfferedViewController alloc] init];
                viewController.goodID = goodsInfo.goodsId;
                [self pushViewController:viewController animated:YES];
            } else {
                [ClientReportObject clientReportObjectWithViewCode:MineLikeViewCode regionCode:HomeChosenGoodsRegionCode referPageCode:HomeChosenGoodsRegionCode andData:data];
                [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:goodsInfo.goodsId animated:YES];
            }
        }
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addChatData" object:nil];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([Session sharedInstance].currentUserId == _userId) {
        return YES;
    }
    
    return NO;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete) {
        
        NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
        GoodsInfo *goodsInfo = [dict objectForKey:[UserLikesTableViewCell cellKeyForUserLikesGoodsInfo]];
        [GoodsSingletonCommand unlikeGoods:goodsInfo.goodsId];
//        for (NSInteger i=0;i<[self.dataSources count];i++) {
//            NSDictionary *dict = (NSDictionary*)[self.dataSources objectAtIndex:i];
//            if ([dict isKindOfClass:[NSDictionary class]]) {
//                GoodsInfo *goodsInfo = (GoodsInfo*)[dict objectForKey:[UserLikesTableViewCell cellKeyForUserLikesGoodsInfo]];
//                if ([goodsInfo.goodsId isEqual:goodsId]) {
//                    indexPathRemoved = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.dataSources removeObjectAtIndex:indexPath.row];
//                    break;
//                }
//            }
//        }
       // if (indexPathRemoved) {
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [_tableView endUpdates];
        //}
    }
}

//-(NSArray*)swipeTableCell:(SwipeTableCell*) cell swipeButtonsForDirection:(SwipeCellDirection)direction
//        swipeCellSettings:(SwipeCellSettings*) swipeSettings expansionSettings:(SwipeCellExpansionSettings*) expansionSettings {
//    swipeSettings.transition = SwipeCellTransitionBorder;
//    
//    if (direction == SwipeCellDirectionLeftToRight) {
//        return nil;
//    }
//    else {
//        expansionSettings.buttonIndex = -1;
//        expansionSettings.fillOnTrigger = YES;
//        return [self createRightButtons];
//    }
//}
//
//-(BOOL)swipeTableCell:(SwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(SwipeCellDirection)direction fromExpansion:(BOOL) fromExpansion {
//    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
//          direction == SwipeCellDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
//    
//    if (direction == SwipeCellDirectionRightToLeft && index == 0) {
//        //delete button
//        
//        NSIndexPath * path = [self.tableView indexPathForCell:cell];
//        NSDictionary *dict = [_dataSources objectAtIndex:path.row];
//        ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
//        
//        WEAKSELF;
//        NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
//        [goodsIds addObject:item.goodsId];
//        [_request cancel];
//        _request = [[NetworkAPI sharedInstance] removeFromShoppingCart:goodsIds completion:^(NSInteger totalNum) {
//            //[weakSelf.dataSources removeObjectAtIndex:path.row];
//            //[self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
//            [[Session sharedInstance] setShoppingCartGoods:totalNum removedGoodsIds:goodsIds];
//        } failure:^(XMError *error) {
//            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
//        }];
//    }
//    return YES;
//}


@end


