//
//  InformationViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/8/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "InformationViewController.h"
#import "MsgCountManager.h"
#import "Session.h"
#import "ShoppingCartViewController.h"
#import "PullRefreshTableView.h"
#import "InformationCell.h"
#import "NoticeViewController.h"
#import "SepTableViewCell.h"
#import "NewConversationCell.h"
#import "NetworkAPI.h"
#import "EMSession.h"
#import "MsgCountManager.h"

@interface InformationViewController ()<UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,EMChatManagerDelegate>
{
    NSInteger lastNotice_count;
}

@property (nonatomic, strong) UIButton *goodsNumLbl;
@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray * dataSources;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger labourId;
@property (nonatomic, strong) HTTPRequest * request;
@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) NoticesModel * notice;

@end

@implementation InformationViewController

-(NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView
{
    if (!_tableView) {
        CGFloat topbarHeight = [super topBarHeight];
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topbarHeight, kScreenWidth, kScreenHeight-topbarHeight-kBottomTabBarHeight)];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.pullDelegate = self;
        _tableView.enableLoadingMore = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [[MsgCountManager sharedInstance] syncNoticeCount];
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
    [self loginEaseMob];
    [self requestData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat topbarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"消息"];
    [self showLoadingView];
    
    
    [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    [self removeEmptyConversationsFromDB];
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
        [self hideLoadingView];
        AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
        NSInteger userId = adviserPage.userId;
        self.userId = userId;
        self.labourId = adviserPage.labourId;
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:userId] forKey:@"userID"];
    } failure:^(XMError *error) {
        
    } queue:nil]];
    
    //购物袋
    [self setupTopBarRightButton:[[SkinIconManager manager] isValidWithPath:KMessage_TopBarRightImg]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KMessage_TopBarRightImg]]:[UIImage imageNamed:@"Mine_New_ShoppingBad_White_MF"] imgPressed:[UIImage imageNamed:@"Mine_New_ShoppingBad_White_MF"]];
    [[MsgCountManager sharedInstance] syncMsgCount];
    UIButton *goodsNumLbl = [self buildGoodsNumLbl];
    _goodsNumLbl = goodsNumLbl;
    [self.topBarRightButton addSubview:goodsNumLbl];
    
    [self.view addSubview:self.tableView];
    self.tableView.frame = CGRectMake(0, topbarHeight+2.5, kScreenWidth, kScreenHeight-topbarHeight-kBottomTabBarHeight);
//    [self loginEaseMob];
//    [self requestData];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChatController:) name:@"reloadChatController" object:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];

}

-(void)didReceiveMessages:(NSArray *)aMessages
{
    [self requestData];
}

//-(void)reloadChatController:(NSNotification *)n
//{
//    [self requestData];
//}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        
        if ((!conversation.latestMessage && !conversation.latestMessageFromOthers) && conversation.unreadMessagesCount==0) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:conversations.count];
            }
            [needRemoveConversations addObject:conversation];
        }
    }
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations deleteMessages:YES];
    }
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{ }];
    if (isLoggedIn) {
        [MobClick event:@"click_shopping_chart_from_recommend"];
        if ([self.navigationController.viewControllers count]>1) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
            if ([viewController isKindOfClass:[ShoppingCartViewController class]]) {
                [self dismiss];
                return;
            }
        }
        ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }
}

- (UIButton*)buildGoodsNumLbl
{
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

- (void)updateGoodsNumLbl:(NSInteger)goodsNum
{
    if (goodsNum > 0) {
        if (goodsNum<100) {
            NSString *title = [NSString stringWithFormat:@"%ld",(long)goodsNum];
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


-(void)requestData
{
    WEAKSELF;
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"notification" path:@"get_notice_types" parameters:nil completionBlock:^(NSDictionary *data) {
        [self hideLoadingView];
        
        
        NSArray *arr = [data objectForKey:@"get_notices_types"];
        NSMutableArray * dataSources = [[NSMutableArray alloc] init];

        for (int i = 0; i < arr.count; i++) {
            NoticesModel * notice = [NoticesModel createWithDict:[arr objectAtIndex:i]];
            weakSelf.notice = notice;
            [dataSources addObject:[InformationCell buildCellDict:weakSelf.notice]];
        }

        NSMutableArray * tempArray = [self loadDataSource];
        
        for (int i = 0; i < tempArray.count; i++) {
            EMConversation * conversation = tempArray[i];
            NSInteger  userId;
            if (conversation.latestMessage.direction == EMMessageDirectionReceive) {
                userId = [conversation.latestMessage.ext[@"fromUserId"] integerValue];
            }else {
                userId = [conversation.latestMessage.ext[@"toUserId"] integerValue];
            }
            
            if (userId == self.userId) {
                [dataSources addObject:[NewConversationCell buildCellDict:conversation userId:userId]];
                [dataSources addObject:[SepTableViewCell buildCellDict]];
                [tempArray removeObjectAtIndex:i];
                break;
                
            }
        }
        for (EMConversation * conversation in tempArray) {
            
            NSInteger  userId;
            if (conversation.latestMessage.direction == EMMessageDirectionReceive) {
                userId = [conversation.latestMessage.ext[@"fromUserId"] integerValue];
            }else {
                userId = [conversation.latestMessage.ext[@"toUserId"] integerValue];
            }
            
            [dataSources addObject:[NewConversationCell buildCellDict:conversation userId:userId]];
        }

        self.dataSources = dataSources;
        
        [weakSelf.tableView reloadData];
        weakSelf.tableView.pullTableIsRefreshing = NO;
    } failure:^(XMError *error) {
        [self showHUD:error.errorMsg hideAfterDelay:0.8];
        weakSelf.tableView.pullTableIsRefreshing = NO;
    } queue:nil]];
}


- (NSMutableArray *)loadDataSource
{
    
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    if (conversations.count == 0) {
        conversations = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    }
    NSArray* sorte = [conversations sortedArrayUsingComparator:
                      ^(EMConversation *obj1, EMConversation* obj2){
                          EMMessage *message1 = [obj1 latestMessage];
                          EMMessage *message2 = [obj2 latestMessage];
                          if(message1.timestamp > message2.timestamp) {
                              return(NSComparisonResult)NSOrderedAscending;
                          }else {
                              return(NSComparisonResult)NSOrderedDescending;
                          }
                      }];
    ret = [[NSMutableArray alloc] initWithArray:sorte];
    return ret;
}

-(void)loginEaseMob
{

    NSMutableArray * dataArray = [self loadDataSource];
    if (!dataArray || [dataArray count] == 0) {
    
        WEAKSELF;
        if ([NetworkManager sharedInstance].isReachable && [Session sharedInstance].isLoggedIn
            && (![EMClient sharedClient].isLoggedIn)) {
            NSArray *userIds = [NSArray arrayWithObjects:[NSNumber numberWithInteger:[Session sharedInstance].currentUserId], nil];
            _request = [[NetworkAPI sharedInstance] getEMAccounts:userIds completion:^(NSArray *accountDicts) {
                
                NSLog(@"%@", accountDicts);
                EMAccount *currentUserEMAccount = nil;
                for (NSInteger i=0;i< [accountDicts count]; i++) {
                    NSDictionary *dict = [accountDicts objectAtIndex:i];
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        EMAccount *emAccount = [EMAccount createWithDict:dict];
                        if (emAccount.userId == [Session sharedInstance].currentUserId) {
                            currentUserEMAccount = emAccount;
                            break;
                        }
                    }
                }
                if (currentUserEMAccount) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[Session sharedInstance] setUserEMAccount:currentUserEMAccount];
                        [[EMSession sharedInstance] loginWithUsername:currentUserEMAccount.emUserName password:currentUserEMAccount.emPassword completion:^{
                            [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
                            [weakSelf removeEmptyConversationsFromDB];
                        } failure:^(XMError *error) {
                            _$showHUD([error errorMsg], 0.8f);
                        }];
                    });
                } else {
                    _$showHUD(@"注册聊天服务失败，请重新登录", 0.8f);
                }
            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            }];
            
        }
        
    } else {
        [_tableView reloadData];
    }


}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}


- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    _tableView.pullTableIsRefreshing = YES;
    [self requestData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    if (ClsTableViewCell == [InformationCell class]) {
        InformationCell *cell = (InformationCell *)[tableView cellForRowAtIndexPath:indexPath];
        //        cell.numlbl.text = @"0";
        //        cell.numlbl.hidden = YES;
        self.notice.noticecountl = 0;
        NoticeViewController *notiVC = [[NoticeViewController alloc] init];
        NoticesModel * noticesModel = [dict objectForKey:[InformationCell cellForkey]];
        notiVC.titleStr = noticesModel.name;
        notiVC.noticeType = noticesModel.type;
        notiVC.notice_count = noticesModel.noticecountl;
        if (lastNotice_count) {
            lastNotice_count -= noticesModel.noticecountl;
        }
        NSDictionary *data = @{@"type":@(indexPath.row)};
        [ClientReportObject clientReportObjectWithViewCode:MessageNavNotifyTypeViewCode regionCode:MessageNavNotifyViewCode referPageCode:MessageNavNotifyViewCode andData:data];
        [self pushViewController:notiVC animated:YES];
    }
    
    if (ClsTableViewCell == [NewConversationCell class]) {
        
        NewConversationCell * cell = (NewConversationCell *)[tableView cellForRowAtIndexPath:indexPath];
        cell.unreadCount = 0;
        cell.unreadLabel.text = @"0";
        cell.unreadLabel.hidden = YES;
        
        
        NSInteger userId;
        EMConversation * conversation = [dict objectForKey:[NewConversationCell cellForConversationkey]];
        //        [conversation markMessageAsReadWithId:conversation.latestMessage.messageId];
        NSLog(@"%@", conversation.conversationId);
        if (conversation.latestMessage.direction == EMMessageDirectionReceive) {
            userId = [conversation.latestMessage.ext[@"fromUserId"] integerValue];
        }else{
            userId = [conversation.latestMessage.ext[@"toUserId"] integerValue];
        }
        NSLog(@"%ld", (long)userId);
        
        if (userId == 0 && !userId) {
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"chat" path:@"em_user" parameters:nil completionBlock:^(NSDictionary *data) {
                EMAccount *emAccount = [[EMAccount alloc] initWithDict:data[@"emUser"]];
                [[Session sharedInstance] setUserKEFUEMAccount:emAccount];
                [UserSingletonCommand chatWithGroup:emAccount isShowDownTime:YES message:@"亲爱的，有什么可以帮您？" isKefu:YES];
            } failure:^(XMError *error) {
                
            } queue:nil]];
        }else{
            
            if (userId == self.userId || userId == self.labourId) {
//                 [UserSingletonCommand chatWithGuwen:userId isGuwen:YES];
                [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
                    
                    AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
                    [UserSingletonCommand chatWithUserHasWXNum:adviserPage.userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings] adviser:adviserPage nadGoodsId:nil];
                    
                } failure:^(XMError *error) {
                    
                } queue:nil]];
            }else{
                 [UserSingletonCommand chatWithGuwen:userId isGuwen:NO];
            }
            
           
        }
    }
    [self.tableView reloadData];
    [[MsgCountManager sharedInstance] syncNoticeCount];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[NewConversationCell class]]) {
        return YES;
    }
    return NO;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation * conversation = [[self.dataSources objectAtIndex:indexPath.row] objectForKey:[NewConversationCell cellForConversationkey]];
        [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId deleteMessages:YES];
        [self.dataSources removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)$$handleNoticeCountDidFinishNotification:(id<MBNotification>)notifi noticeCount:(NSNumber*)noticeCount
{
    NSLog(@"%ld,%ld", lastNotice_count, [noticeCount integerValue]);
    if (lastNotice_count != [noticeCount integerValue]) {
        [self requestData];
        [self.tableView reloadData];
        lastNotice_count = [noticeCount integerValue];
    }
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);   
    return [clsTableViewCell rowHeightForPortrait:dict];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString * reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell * Cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (Cell == nil) {
        Cell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        Cell.backgroundColor = [UIColor whiteColor];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    EMConversation * conversation = [dict objectForKey:[NewConversationCell cellForConversationkey]];
     NSLog(@"===========%@---------------", conversation.conversationId);
    [Cell updateCellWithDict:dict];
    return Cell;

}



@end
