//
//  ConversationViewController.m
//  XianMao
//
//  Created by simon on 1/2/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ConversationViewController.h"
#import "SRRefreshView.h"
#import "ConversationCell.h"
#import "NSDate+Category.h"
#import "ChatViewController.h"
#import "ConvertToCommonEmoticonsHelper.h"

#import "UIViewController+HUD.h"
#import "MessageModelManager.h"
#import "Command.h"
#import "NetworkAPI.h"
#import "EaseMessageModel.h"

#import "MsgCountManager.h"
#import "Session.h"
#import "Datasources.h"
#import "EMSession.h"
#import "ChatViewController.h"

#import "EMSearchBar.h"
#import "EMSearchDisplayController.h"
#import "WCAlertView.h"

#import "NewMessageHeaderView.h"
#import "LoadingView.h"

@interface ConversationViewController ()<UITableViewDelegate,UITableViewDataSource, UISearchDisplayDelegate,SRRefreshDelegate, UISearchBarDelegate, EMChatManagerDelegate>

@property (strong, nonatomic) NSMutableArray        *dataSource;

@property (strong, nonatomic) UITableView           *tableView;
//@property (nonatomic, strong) EMSearchBar           *searchBar;
@property (nonatomic, strong) SRRefreshView         *slimeView;
@property (nonatomic, strong) UIView                *networkStateView;
@property(nonatomic,strong) HTTPRequest *request;

//@property (strong, nonatomic) EMSearchDisplayController *searchController;

@end

@implementation ConversationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSource = [NSMutableArray array];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
    [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    [self removeEmptyConversationsFromDB];
    
    [self.tableView removeFromSuperview];
    [self.view addSubview:self.tableView];
    
    
    [self.slimeView removeFromSuperview];
    
    [self.slimeView removeFromSuperview];
    [self.tableView addSubview:self.slimeView];
    [self networkStateView];
    [self registerNotifications];
    
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"dcdddd"];
//     [self searchController];
}

-(void)dealloc
{
    _request = nil;
     [self unregisterNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    self.view = nil;
//    self.networkStateView = nil;
//    [self.slimeView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
//    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
//        if (self.isViewLoaded && !self.view.window) {
//            self.view = nil;
//            self.networkStateView = nil;
//            [self.slimeView removeFromSuperview];
//        }
//    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshDataSource];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
   
}
     
- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];//[[EaseMob sharedInstance].chatManager conversations];
        NSMutableArray *needRemoveConversations;
        for (EMConversation *conversation in conversations) {
            
            if ((!conversation.latestMessage && !conversation.latestMessageFromOthers) && conversation.unreadMessagesCount==0) {
                if (!needRemoveConversations) {
                    needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
                }
                
                [needRemoveConversations addObject:conversation.conversationId];
            }
        }
        
        if (needRemoveConversations && needRemoveConversations.count > 0) {
//            [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
//                                                                 deleteMessages:YES
//                                                                    append2Chat:NO];
            [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations deleteMessages:YES];
        }
}
- (void)removeChatroomConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];//[[EaseMob sharedInstance].chatManager conversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (conversation.type == EMConversationTypeChatRoom) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation.conversationId];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
//        [[EaseMob sharedInstance].chatManager removeConversationsByChatters:needRemoveConversations
//                                                             deleteMessages:YES
//                                                                append2Chat:NO];
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations deleteMessages:YES];
    }
}

#pragma mark - getter

- (SRRefreshView *)slimeView
{
    if (!_slimeView) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor colorWithHexString:@"efd8a4"];
        _slimeView.slime.skinColor = [UIColor colorWithHexString:@"efd8a4"];
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor colorWithHexString:@"efd8a4"];
        _slimeView.backgroundColor = [UIColor whiteColor];
    }
    return _slimeView;
}

//- (UISearchBar *)searchBar
//{
//    if (!_searchBar) {
//        _searchBar = [[EMSearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
//        _searchBar.delegate = self;
//        _searchBar.placeholder = NSLocalizedString(@"search", @"Search");
//        _searchBar.backgroundColor = [UIColor colorWithRed:0.747 green:0.756 blue:0.751 alpha:1.000];
//    }
//    
//    return _searchBar;
//}

- (UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height ) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[ConversationCell class] forCellReuseIdentifier:@"chatListCell"];
    }
    _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height );
    
    return _tableView;
}

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}


#pragma mark - private

- (NSMutableArray *)loadDataSource
{
    NSMutableArray *ret = nil;
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];//[[EaseMob sharedInstance].chatManager conversations];
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

// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                ret = @"[图片]";
            } break;
            case EMMessageBodyTypeText:{
                
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                ret = @"[语音]";
            } break;
            case EMMessageBodyTypeLocation: {
                ret = @"[位置]";
            } break;
            case EMMessageBodyTypeVideo: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}

#pragma mark - TableViewDelegate & TableViewDatasource

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"chatListCell";
    ConversationCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[ConversationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    if (conversation.type == EMConversationTypeChat) {
        EMMessage *message = conversation.latestMessage;
        NSDictionary *extMessage = message.ext;
        NSString *imageUrl = nil;
        if ([message.from isEqualToString:[Session sharedInstance].emAccount.emUserName]) {
            imageUrl = [extMessage objectForKey:@"toHeaderImg"];
            cell.name = [extMessage objectForKey:@"toNickname"];
        } else {
            
            if (![extMessage objectForKey:@"fromHeaderImg"] && ![extMessage objectForKey:@"fromNickname"]) {
                imageUrl = [Session sharedInstance].emKEFUAccount.avatar;
                cell.name = [Session sharedInstance].emKEFUAccount.username;
            } else {
                imageUrl = [extMessage objectForKey:@"fromHeaderImg"];
                cell.name = [extMessage objectForKey:@"fromNickname"];
            }
        }
        
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        
    }
    else{
        NSString *imageName = @"groupPublicHeader";
        NSArray *groupArray = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];//[[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:conversation.conversationId]) {
                cell.name = group.subject;
                imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                break;
            }
        }
        cell.placeholderImage = [UIImage imageNamed:imageName];
    }
    cell.detailMsg = [self subTitleMessageByConversation:conversation];
    cell.time = [self lastMessageTimeByConversation:conversation];
    cell.unreadCount = [self unreadMessageCountByConversation:conversation];
    cell.lineView.hidden = NO;
    if (indexPath.row == ([self.dataSource count]-1)) {
        cell.lineView.hidden = YES;
    }

    return cell;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.dataSource.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [ConversationCell tableView:tableView heightForRowAtIndexPath:indexPath];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    EMConversation *conversation = [self.dataSource objectAtIndex:indexPath.row];
    
    ChatViewController *chatController;
    NSString *title = conversation.conversationId;
    NSString *nickName = nil;
    NSString *imageUrl = nil;
    NSInteger userId = 0;
    if (conversation.type != EMConversationTypeChat) {
        NSArray *groupArray = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];//[[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:conversation.conversationId]) {
                title = group.subject;
                break;
            }
        }
    } else {
        EMMessage *message = conversation.latestMessageFromOthers;
        if (message == nil) {
            message = conversation.latestMessage;
        }
        
        NSDictionary *extMessage = message.ext;

        if (extMessage != nil && ![message.from isEqualToString:[Session sharedInstance].emAccount.emUserName]) {
            imageUrl = [extMessage objectForKey:@"fromHeaderImg"];
            nickName = [extMessage objectForKey:@"fromNickname"];
            userId = [extMessage integerValueForKey:@"fromUserId"];
        } else {
            imageUrl = [extMessage objectForKey:@"toHeaderImg"];
            nickName = [extMessage objectForKey:@"toNickname"];
            userId = [extMessage integerValueForKey:@"toUserId"];
        }
    }
    
    NSString *chatter = conversation.conversationId;
//    chatController = [[ChatViewController alloc] initWithChatter:chatter sellerName:nickName sellerHeader:imageUrl sellerUserId:userId goodsId:nil];
//    chatController.title = @"聊天";
//    NSLog(@"%@", [Session sharedInstance].emKEFUAccount);
    if (!nickName&&!imageUrl) {
        chatController = [[ChatViewController alloc] initWithChatter:chatter sellerName:[Session sharedInstance].emKEFUAccount.username sellerHeader:[Session sharedInstance].emKEFUAccount.avatar sellerUserId:userId goodsId:nil];
        chatController.title = @"聊天";
    } else {
        chatController = [[ChatViewController alloc] initWithChatter:chatter sellerName:nickName sellerHeader:imageUrl sellerUserId:userId goodsId:nil];
        chatController.title = @"聊天";
    }
//    [conversation markAllMessagesAsRead:YES];
    [self pushViewController:chatController animated:YES];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)$$handleShieldUserNotification:(id<MBNotification>)notifi chatter:(NSString*)chatter
{
    for (NSInteger i=0;i<[self.dataSource count];i++) {
        EMConversation *conversation = [self.dataSource objectAtIndex:i];
        if ([conversation.conversationId isEqualToString:chatter]) {
            [self.dataSource removeObjectAtIndex:i];
            break;
        }
    }
    
//    [[EaseMob sharedInstance].chatManager removeConversationByChatter:chatter deleteMessages:YES append2Chat:NO];
//    [[EaseMob sharedInstance].chatManager asyncBlockBuddy:chatter relationship:eRelationshipFrom];
    [[EMClient sharedClient].chatManager deleteConversation:chatter deleteMessages:YES];
    [[EMClient sharedClient].contactManager addUserToBlackList:chatter relationshipBoth:YES];
    [self.tableView reloadData];
    
    if (!self.dataSource || [self.dataSource count] == 0) {
        //[self showEmptyViewFrame:_tableView.frame mask:XMEmptyViewImageNone title:@"无聊天记录" subtitle:nil];
//        [self loadEndWithNoContent:@"无聊天记录"];
        [self loadEndWithNoContentAndImage:@"无聊天记录" imageName:@"ChatHistory_MF"];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
//        [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:NO append2Chat:NO];
        [[EMClient sharedClient].chatManager deleteConversation:converation.conversationId deleteMessages:NO];
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self refreshDataSource];

//        __weak typeof(self) weakSelf = self;
//        [WCAlertView showAlertWithTitle:@"温馨提示"
//                                message:@"该会话聊天记录认删除"
//                     customizationBlock:^(WCAlertView *alertView) {
//                         
//                     } completionBlock:
//         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
//             if (buttonIndex == 1) {
//                 EMConversation *converation = [self.dataSource objectAtIndex:indexPath.row];
//                 [[EaseMob sharedInstance].chatManager removeConversationByChatter:converation.chatter deleteMessages:NO append2Chat:NO];
//                 [self.dataSource removeObjectAtIndex:indexPath.row];
//                 [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
//                 [self refreshDataSource];
//             }
//         } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
}

#pragma mark - scrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_slimeView scrollViewDidScroll];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_slimeView scrollViewDidEndDraging];
}

#pragma mark - slimeRefresh delegate
//刷新消息列表
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    [self refreshDataSource];
    [_slimeView endRefresh];
}

#pragma mark - IChatMangerDelegate

-(void)didUnreadMessagesCountChanged
{
    [self refreshDataSource];
}

- (void)didUpdateGroupList:(NSArray *)allGroups error:(EMError *)error
{
    [self refreshDataSource];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
//    [[EaseMob sharedInstance].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
}

-(void)unregisterNotifications{
//    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
}

#pragma mark - public

-(void)refreshDataSource
{
    self.dataSource = [self loadDataSource];
    if (!self.dataSource || [self.dataSource count] == 0) {
        //[self showEmptyViewFrame:_tableView.frame mask:XMEmptyViewImageNone title:@"无聊天记录" subtitle:nil];
//        [self loadEndWithNoContent:@"无聊天记录"];
        [self loadEndWithNoContentAndImage:@"无聊天记录" imageName:@"ChatHistory_MF"];
        WEAKSELF
        
        //add code
//        NSString *URLstr = @"/notification/get_notices_types";
//        NSDictionary *params = @{@"page":@(0), @"size":@(15), @"status":@(0)};
//        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:URLstr path:@"" parameters:params completionBlock:^(NSDictionary *data) {
//            
//        } failure:^(XMError *error) {
//            NSLog(@"error");
//        } queue:nil]];
        
        if ([NetworkManager sharedInstance].isReachable && [Session sharedInstance].isLoggedIn
            && (![EMClient sharedClient].isLoggedIn)) {//[[EaseMob sharedInstance].chatManager isLoggedIn]
            
            
            NSArray *userIds = [NSArray arrayWithObjects:[NSNumber numberWithInteger:[Session sharedInstance].currentUserId], nil];
            _request = [[NetworkAPI sharedInstance] getEMAccounts:userIds completion:^(NSArray *accountDicts) {
                
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
//                            [[EaseMob sharedInstance].chatManager loadAllConversationsFromDatabaseWithAppend2Chat:YES];
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
        //[self hideEmptyView];
        [self hideNoContentView];
        [_tableView reloadData];
    }

    [self hideHud];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        _tableView.tableHeaderView = _networkStateView;
    }
    else{
        _tableView.tableHeaderView = nil;
    }
}

- (void)willReceiveOfflineMessages{
    NSLog(@"开始接收离线消息");
}

- (void)didFinishedReceiveOfflineMessages:(NSArray *)offlineMessages{
    NSLog(@"离线消息接收成功");
    [self refreshDataSource];
}

@end



