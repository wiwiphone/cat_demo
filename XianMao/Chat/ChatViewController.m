//
//  ChatViewController.m
//  XianMao
//
//  Created by simon cai on 11/13/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ChatViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import "ConsignmentViewController.h"
#import "SRRefreshView.h"
#import "EaseRecordView.h"
#import "EMChatViewCell.h"
#import "EMChatTimeCell.h"
#import "EaseSDKHelper.h"
#import "EaseMessageReadManager.h"
#import "MessageModelManager.h"
#import "UIViewController+HUD.h"
#import "WCAlertView.h"
#import "NSDate+Category.h"
#import "DXMessageToolBar.h"
#import "User.h"
#import "Session.h"
#import "IQKeyboardManager.h"
#import "DataSources.h"
#import "GoodsInfo.h"
#import "GoodsDetailViewController.h"
#import "GoodsMemCache.h"
#import "UIActionSheet+Blocks.h"
#import "NSString+Addtions.h"
#import "EMChatGoodsBubbleView.h"
#import "EMCDDeviceManager.h"
#import "EMCDDeviceManagerDelegate.h"
#import "ChatService.h"
#import "ChatTabReplyVo.h"
#import "EMChatGoodsCell.h"
#import "ReplyDetailVo.h"
#import "OnSaleViewController.h"
#import "SearchViewController.h"
#import "RecoverDetailViewController.h"
#import "OfferedViewController.h"
#import "EMChatNewArrivalCell.h"
#import "EMChatSpecialCell.h"
#import "RecommendGoodsInfo.h"

#import "AssetPickerController.h"
#import "UIImage+Resize.h"

#import "ReportViewController.h"
#import "BaseService.h"

#import "WeakTimerTarget.h"

#import "UserService.h"
#import "NetworkAPI.h"

#import "ChatHeaderView.h"
#import "ConfirmView.h"
#import "ConfirmBackView.h"

#import "Masonry.h"
#import "EaseConvertToCommonEmoticonsHelper.h"
#import "UserLikesViewController.h"
#import "EMCallManagerDelegate.h"

#import "EMSDKFull.h"
#import "DXRecordView.h"
#import "EMConversation.h"

#import "ChatRecordItem.h"
#import "jsonModel.h"

#import "BoughtCollectionViewController.h"
#import "SeekToPurchasePublishController.h"
#import "ChatConsultantHeaderView.h"
#import "ChatHobbiesView.h"

#define KPageCount 30

#define KcontentMarginTop 156

#define chatHobbiesViewHeight  40

static CGFloat EMChatSpecialCellType = 4;
static CGFloat EMChatNewArrivalCellType = 5;
static CGFloat EMChatTextCellType = 0;


@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, SRRefreshDelegate, EMChatManagerDelegate, DXChatBarMoreViewDelegate, DXMessageToolBarDelegate, EMCDDeviceManagerDelegate,SearchViewControllerDelegate,EMCDDeviceManagerDelegate,EMCallManagerDelegate,AssetPickerControllerDelegate, ConfirmViewDelegate, ConfirmBackViewDelegate,EMChatroomManagerDelegate,EMClientDelegate,EMGroupManagerDelegate,EMContactManagerDelegate, PullRefreshTableViewDelegate>
{
    UIMenuController *_menuController;
    UIMenuItem *_copyMenuItem;
    UIMenuItem *_deleteMenuItem;
    NSIndexPath *_longPressIndexPath;
    
    NSInteger _recordingCount;
    
    dispatch_queue_t _messageQueue;
    
    NSMutableArray *_messages;
    BOOL _isScrollToBottom;
    BOOL _isTimeLimited;
}

@property (nonatomic) BOOL isChatGroup;
@property (strong, nonatomic) NSString *chatter;

@property (strong, nonatomic) NSMutableArray *dataSource;//tableView数据源
@property (strong, nonatomic) SRRefreshView *slimeView;
@property (strong, nonatomic) PullRefreshTableView *tableView;
@property (strong, nonatomic) DXMessageToolBar *chatToolBar;//DXMessageToolBar
@property (strong, nonatomic) ChatTabReplyVo * chatTapReplyVo;
@property (nonatomic, strong) NSMutableArray * chatTapReplyList;
@property (nonatomic, strong) ChatHeaderView *chatHeaderView;
@property (nonatomic, strong) ConfirmView *confirmView;
@property (nonatomic, strong) ChatHobbiesView * chatHobbiesView;
@property (strong, nonatomic) UIImagePickerController *imagePicker;

@property (strong, nonatomic) EaseMessageReadManager *messageReadManager;//message阅读的管理者
@property (strong, nonatomic) EMConversation *conversation;//会话管理者
@property (strong, nonatomic) NSDate *chatTagDate;

@property (strong, nonatomic) NSMutableArray *messages;

@property (nonatomic) BOOL isScrollToBottom;
@property (nonatomic) BOOL isPlayingAudio;

@property (nonatomic,copy) NSString *sellerName;
@property (nonatomic,assign) NSInteger sellerId;
@property (nonatomic, copy) NSString *sellerHeaderImg;

@property (nonatomic, copy) NSMutableDictionary *extMessage;

@property (nonatomic, assign)BOOL wasKeyboardManagerEnabled;

@property (nonatomic, copy) NSString *goodsId;

@property (nonatomic,strong) NSTimer *maxDurationTimer;

@property(nonatomic,strong) UIInsetLabel *tipsLbl;
@property(nonatomic,strong) NSArray *sensitivityWordsArray;

@property(nonatomic,copy) NSString *messageWantToSend;
@property (nonatomic, strong) RecoveryGoodsVo *goodsVO;
@property (nonatomic, strong) HighestBidVo *bidVO;
@property (nonatomic, strong) RecoveryGoodsDetail *goodsDeatil;
@property (nonatomic, weak) ConfirmBackView *backView;
@property (nonatomic, weak) UIButton *goodsBtn;

@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property (nonatomic, strong) NSDictionary *goodsDic;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, assign) NSInteger viewCode;
@property (nonatomic, strong) HTTPRequest * request;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, strong) ChatConsultantHeaderView *headerImageView;
@end

@implementation ChatViewController

-(ConfirmView *)confirmView{
    if (!_confirmView) {
        _confirmView = [[ConfirmView alloc] initWithFrame:CGRectZero];
        _confirmView.backgroundColor = [UIColor whiteColor];
    }
    return _confirmView;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.confirmView layoutSubviews];
    [self.chatHeaderView layoutSubviews];
}

- (instancetype)initWithChatter:(NSString *)chatter
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isPlayingAudio = NO;
        _chatter = chatter;
        _isChatGroup = NO;
        
        //根据接收者的username获取当前会话的管理者
        //        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:eConversationTypeChat];
        _conversation = [[EMClient sharedClient].chatManager getConversation:_chatter type:EMConversationTypeChat createIfNotExist:YES];
        
    }
    
    return self;
}

-(instancetype) initWithChatter:(NSString *)chatter Customer:(NSString *)groupName {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _chatter = chatter;
        _isPlayingAudio = NO;
        _isChatGroup = NO;
        _messages = [NSMutableArray array];
        
        //根据接收者的username获取当前会话的管理者
        //        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:eConversationTypeChat];
        _conversation = [[EMClient sharedClient].chatManager getConversation:_chatter type:EMConversationTypeChat createIfNotExist:YES];
        _extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"weichat" : @{@"queueName" : groupName}}];
        
    }
    
    return self;
}

- (instancetype)initWithChatter:(NSString *)chatter
                     sellerName:(NSString*)sellerName
                   sellerHeader:(NSString *)headerImg
                   sellerUserId:(NSInteger )userId
                        message:(NSString *)message {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _userId = userId;
        _isPlayingAudio = NO;
        _chatter = chatter;
        _isChatGroup = NO;
        _messages = [NSMutableArray array];
        //根据接收者的username获取当前会话的管理者
        //        _conversation = [[EaseMob sharedInstance].chatManager conversationForChatter:chatter conversationType:eConversationTypeChat];
        _conversation = [[EMClient sharedClient].chatManager getConversation:_chatter type:EMConversationTypeChat createIfNotExist:YES];
        _sellerName = sellerName;
        _sellerHeaderImg = [XMWebImageView imageUrlToQNImageUrl:headerImg isWebP:NO scaleType:XMWebImageScale240x240];
        _sellerId = userId;
        
        NSString *avatarUrl = [Session sharedInstance].currentUser.avatarUrl;
        
        _extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"fromNickname" : [Session sharedInstance].currentUser.userName?[Session sharedInstance].currentUser.userName:@"",
                                                                      @"fromHeaderImg" : [avatarUrl length]>0?avatarUrl:@"",
                                                                      @"fromUserId" : [NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId],
                                                                      @"toNickname" : [_sellerName length]>0?_sellerName:@"",
                                                                      @"toHeaderImg": [_sellerHeaderImg length]>0?_sellerHeaderImg:@"",
                                                                      @"toUserId" : [NSNumber numberWithInteger:userId]}];
        //        _extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"fromNickname" : [_sellerName length]>0?_sellerName:@"",
        //                                                                      @"fromHeaderImg" : [_sellerHeaderImg length]>0?_sellerHeaderImg:@"",
        //                                                                      @"fromUserId" : [NSNumber numberWithInteger:userId],
        //                                                                      @"toNickname" : [Session sharedInstance].currentUser.userName?[Session sharedInstance].currentUser.userName:@"",
        //                                                                      @"toHeaderImg": [avatarUrl length]>0?avatarUrl:@"",
        //                                                                      @"toUserId" : [NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]}];
        
        
        if ([message length]>0) {
            _messageWantToSend = message;
        }
    }
    
    return self;
}

- (instancetype)initWithChatter:(NSString *)chatter
                     sellerName:(NSString*)sellerName
                   sellerHeader:(NSString *)headerImg
                   sellerUserId:(NSInteger )userId
                        goodsId:(NSString *)goodsId

{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _isPlayingAudio = NO;
        _chatter = chatter;
        _isChatGroup = NO;
        _messages = [NSMutableArray array];
        //根据接收者的username获取当前会话的管理者
        _conversation = [[EMClient sharedClient].chatManager getConversation:_chatter type:EMConversationTypeChat createIfNotExist:YES];
        _sellerName = sellerName;
        _sellerHeaderImg = [XMWebImageView imageUrlToQNImageUrl:headerImg isWebP:NO scaleType:XMWebImageScale240x240];
        _sellerId = userId;
        
        NSString *avatarUrl = [Session sharedInstance].currentUser.avatarUrl;
        
        _extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"fromNickname" : [Session sharedInstance].currentUser.userName?[Session sharedInstance].currentUser.userName:@"",
                                                                      @"fromHeaderImg" : [avatarUrl length]>0?avatarUrl:@"",
                                                                      @"fromUserId" : [NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId],
                                                                      @"toNickname" : [_sellerName length]>0?_sellerName:@"",
                                                                      @"toHeaderImg": [_sellerHeaderImg length]>0?_sellerHeaderImg:@"",
                                                                      @"toUserId" : [NSNumber numberWithInteger:userId]}];
        if (goodsId != nil) {
            _goodsId = goodsId;
            GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:goodsId];
            if (goodsInfo!=nil) {
                NSDictionary *goodsDic = @{@"goods_id":goodsId,
                                           @"goods_name" : [goodsInfo.goodsName length]>0?goodsInfo.goodsName:@"",
                                           @"shop_price" : [NSNumber numberWithDouble:goodsInfo.shopPrice],
                                           @"thumb_url" : [goodsInfo.thumbUrl length]>0?goodsInfo.thumbUrl:@"",
                                           @"service_type" : [NSNumber numberWithInteger:goodsInfo.serviceType]};
                self.goodsDic = goodsDic;
                self.goodsInfo = goodsInfo;
                [_extMessage addEntriesFromDictionary:@{@"type":@1,@"goods":goodsDic}];
                //                [ChatService chatNotice:_sellerId isAdd:YES];
            } else {
                _goodsId  = nil;
            }
        }
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.index = 1;
    
    self.viewCode = ChatViewCode;
    [[Session sharedInstance] client:self.viewCode data:nil];
    
    //以下三行代码必须写，注册为SDK的ChatManager的delegate
    [EMCDDeviceManager sharedInstance].delegate = self;
    [[EMClient sharedClient] removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
    [[EMClient sharedClient].contactManager removeDelegate:self];
    [[EMClient sharedClient].roomManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    //注册为SDK的ChatManager的delegate
    [[EMClient sharedClient] addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].contactManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].roomManager addDelegate:self delegateQueue:nil];
    
    //目前这个.a文件没有实时通话功能
    //    [[EMClient sharedClient].callManager removeDelegate:self];
    //    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    
    //    [[EaseMob sharedInstance].callManager removeDelegate:self];
    //    // 注册为Call的Delegate
    //    [[EaseMob sharedInstance].callManager addDelegate:self delegateQueue:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeAllMessages:) name:@"RemoveAllMessages" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"chatApplicationDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(finishAuthPopController) name:@"finishAuth" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadChatController:) name:@"reloadChatController" object:nil];
    
    _messageQueue = dispatch_queue_create("com.aidingmao.im", NULL);
    _isScrollToBottom = YES;
    _isTimeLimited = NO;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    [super setupTopBar];
    [super setupTopBarTitle:_sellerName&&[_sellerName length]>0?[NSString stringWithFormat:@"%@",_sellerName]:@"聊天"];
    [super setupTopBarBackButton];
    
    UIImage *moreImg = [UIImage imageNamed:@"more_wjh"];
    [super setupTopBarRightButton:moreImg imgPressed:nil];
    super.topBarBackButton.backgroundColor = [UIColor clearColor];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    
    
    [self.view addSubview:self.tableView];
    //    [self.tableView addSubview:self.slimeView];
    
    [self.view addSubview:self.chatToolBar];
    [self.view addSubview:self.chatHobbiesView];
    
    //    NSArray *arr = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];
    //    EMConversation *con = arr[0];
    
    if ((self.isGuwen || self.isConsultant)&&!self.isKefu) {
        self.topBar.image = [UIImage imageNamed:@"Chat_Consultant_topBar"];
        [self.topBarBackButton setImage:[UIImage imageNamed:@"back_button-white"] forState:UIControlStateNormal];
        [self.topBarRightButton setImage:[UIImage imageNamed:@"three_point"] forState:UIControlStateNormal];
        self.topBarTitleLbl.textColor = [UIColor whiteColor];
        
        ChatConsultantHeaderView *headerImageView = [[ChatConsultantHeaderView alloc] initWithFrame:CGRectMake(0, -KcontentMarginTop, kScreenWidth, KcontentMarginTop)];
        headerImageView.image = [UIImage imageNamed:@"Chat_Consultant_Bottom"];
        [self.tableView addSubview:headerImageView];
        [headerImageView getAdviserPage:self.adviserPage];
        self.topBarlineView.hidden = YES;
        self.headerImageView = headerImageView;
        self.tableView.contentMarginTop = KcontentMarginTop;
        
    }
    [self getchatTabReplylist];
    
    if (self.isYes) {
        self.chatHeaderView = [[ChatHeaderView alloc] initWithFrame:CGRectMake(0, self.topBarHeight, kScreenWidth, 68)];
        [self.chatHeaderView getHeaderViewGoodsVO:self.goodsVO andBidVO:self.bidVO andGoodsDeatil:self.goodsDeatil];
        self.tableView.frame = CGRectMake(0, self.chatHeaderView.bottom, self.view.frame.size.width, self.view.frame.size.height-self.chatToolBar.frame.size.height-self.topBarHeight - 68);
        [self.view addSubview:self.chatHeaderView];
        ConfirmBackView *backView = [[ConfirmBackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        backView.alpha = 0.7;
        backView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:backView];
        backView.confirmBackDelegate = self;
        backView.hidden = YES;
        self.backView = backView;
        
        [self.view addSubview:self.confirmView];
        [self.confirmView bringSubviewToFront:self.view];
        self.confirmView.conDelegate = self;
        [self.confirmView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_centerY).offset(-100);
            make.left.equalTo(self.view.mas_left).offset(15);
            make.right.equalTo(self.view.mas_right).offset(-15);
            make.bottom.equalTo(self.view.mas_centerY).offset(150);
        }];
        
        self.confirmView.hidden = YES;
    }
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.chatToolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.chatToolBar.moreView setDelegate:self];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    
    WEAKSELF;
    //通过会话管理者获取已收发消息
    //[self loadMoreMessages];
    long long timestamp = [[NSDate date] timeIntervalSince1970] * 1000 + 1;
    [self loadMoreMessagesFrom:timestamp count:KPageCount append:NO loadDone:^{
        
        if (weakSelf.goodsId != nil) {
            //注释这段代码，防止聊天时自动发送消息 2016.3.2 Feng
            
            //            UIButton *goodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(weakSelf.topBarRightButton.left - 30 - 10, weakSelf.topBar.centerY - 5, 20, 20)];
            //            [goodsBtn setTitle:@"发送链接" forState:UIControlStateNormal];
            //            [goodsBtn setTitleColor:[UIColor colorWithHexString:@"c7c7c7"] forState:UIControlStateNormal];
            //            goodsBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
            //            [goodsBtn sizeToFit];
            //            weakSelf.goodsBtn = goodsBtn;
            //            [weakSelf.topBar addSubview:goodsBtn];
            //            [goodsBtn addTarget:self action:@selector(sendGoodsMessage) forControlEvents:UIControlEventTouchUpInside];
            //            [weakSelf sendTextMessage:@"[商品信息]"];
            //            weakSelf.goodsId = nil;
        }
        if ([weakSelf.messageWantToSend length]>0) {
            [weakSelf sendTextMessage:weakSelf.messageWantToSend];
            weakSelf.messageWantToSend = nil;
        }
    }];
    
    
    [super bringTopBarToTop];
    
    
    [PlatformService loadSensitivityWords:^(NSArray *sensitivityWordsArray) {
        weakSelf.sensitivityWordsArray = sensitivityWordsArray;
    }];
    
    //插入商品cell
    if (self.goodsInfo && ![self.dataSource containsObject:self.goodsInfo]) {
        [self.dataSource addObject:self.goodsInfo];
    }
    //插入自动回复cell
    if (self.isConsultant) {
        NSString *avatarUrl = [Session sharedInstance].currentUser.avatarUrl;
        NSMutableDictionary *extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"fromNickname" : [_sellerName length]>0?_sellerName:@"",
                                                                                          @"fromHeaderImg" : [_sellerHeaderImg length]>0?_sellerHeaderImg:@"",
                                                                                          @"fromUserId" : [NSNumber numberWithInteger:_userId],
                                                                                          @"toNickname" : [Session sharedInstance].currentUser.userName?[Session sharedInstance].currentUser.userName:@"",
                                                                                          @"toHeaderImg": [avatarUrl length]>0?avatarUrl:@"",
                                                                                          @"toUserId" : [NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId]}];
        
        //插入内存一条消息
        EMChatType type = _isChatGroup ? EMChatTypeGroupChat : EMChatTypeChat;
        NSString *willSendText = @"";
        if (self.consultantStr != nil) {
            willSendText = [EaseConvertToCommonEmoticonsHelper convertToCommonEmoticons:self.consultantStr];
        }
        EMTextMessageBody *text = [[EMTextMessageBody alloc] initWithText:willSendText];
        
        EMMessage *retureMsg = [[EMMessage alloc] initWithConversationID:_conversation.conversationId from:[Session sharedInstance].currentUser.userName?[Session sharedInstance].currentUser.userName:@"" to:_conversation.conversationId body:text ext:nil];
        
        //        retureMsg.requireEncryption = NO;
        retureMsg.chatType = type;
        retureMsg.ext = extMessage;
        
        EaseMessageModel *model = [[EaseMessageModel alloc] initWithMessage:retureMsg];//[MessageModelManager firstModelWithMessage:retureMsg];
        model.isSender = NO;
        model.index = 1;
        
        NSDate *date = [NSDate date];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
        NSString *DateTime = [formatter stringFromDate:date];
        [self.dataSource addObject:DateTime];
        [self.dataSource addObject:model];
    }
    //插入顾问休息提示cell
    if (([self isBetweenFromHour:9 toHour:23] && self.isConsultant) || (self.isGuwen && [self isBetweenFromHour:9 toHour:23])) {
        NSDictionary * AutoDict = @{@"autoReply":@"\n23:00至次日09:00顾问休息，亲先留下问题，等顾问醒来，会第一时间回复亲噢"};
        [self.dataSource addObject:AutoDict];
    }
    
    //收到消息埋点
    int unReadMessageNum = _conversation.unreadMessagesCount;
    NSArray *messages = [weakSelf.conversation loadMoreMessagesFromId:@"" limit:unReadMessageNum direction:EMMessageSearchDirectionUp];
    if (messages.count > 0) {
        [self chatSaveChatPoint:messages uploadType:CHAT_RECEIVE isRecive:YES];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addChatData:) name:@"addChatData" object:nil];
}

/**
 顾问聊天获取今日上新 专题..
 */
#pragma mark 顾问聊天获取今日上新 专题
- (void)getchatTabReplylist{
    //self.userid
    
    WEAKSELF;
    
    self.tableView.frame = CGRectMake(0, self.topBarHeight, self.view.frame.size.width, self.view.frame.size.height - self.topBarHeight - chatHobbiesViewHeight -self.chatToolBar.height);
    _request = [[NetworkAPI sharedInstance] getchatTabReplylist:self.userId completion:^(NSArray *replyTablist) {
        if (replyTablist && replyTablist.count > 0) {
            NSMutableArray * chatTapReplyList = [[NSMutableArray alloc] init];
            for (NSDictionary * dict in replyTablist) {
                ChatTabReplyVo * chatTabReplyVo = [[ChatTabReplyVo alloc] initWithJSONDictionary:dict];
                [chatTapReplyList addObject:chatTabReplyVo];
            }
            _chatTapReplyList = chatTapReplyList;
            weakSelf.chatHobbiesView.hidden = NO;
            weakSelf.tableView.frame = CGRectMake(0, self.topBarHeight, self.view.frame.size.width, self.view.frame.size.height - self.topBarHeight - chatHobbiesViewHeight -self.chatToolBar.height);
            [weakSelf.chatHobbiesView getchatTabReplyData:weakSelf.chatTapReplyList];
        }else{
            weakSelf.tableView.frame = CGRectMake(0, self.topBarHeight, self.view.frame.size.width, self.view.frame.size.height - self.topBarHeight -self.chatToolBar.height);
            weakSelf.chatHobbiesView.hidden = YES;
        }
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
        weakSelf.chatHeaderView.hidden = YES;
    }];
    
    _chatHobbiesView.handleChatTabReplyBlock = ^(ChatTabReplyVo *chatTapReplyVo) {
        
        weakSelf.request = [[NetworkAPI sharedInstance] getchatReplydetail:chatTapReplyVo.id completion:^(NSDictionary *data) {
            ReplyDetailVo * replyDetailVo = [ReplyDetailVo createWithDict:[data objectForKey:@"reply_detail"]];
            
            NSLog(@" %@",replyDetailVo.tabTitle);
            [weakSelf sendChatTabReply:replyDetailVo];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
        }];
    };
    
}

- (void)sendChatTabReply:(ReplyDetailVo *)replyDetailVo{
    
    
    for (ReplyVo * replyVo in replyDetailVo.replyList) {
        NSMutableDictionary *tabReplyDict = [NSMutableDictionary dictionaryWithDictionary:@{@"type":@(replyVo.type),
                                                                                            @"title":replyVo.title,
                                                                                            @"redirectUrl":replyVo.redirectUrl}];
        NSMutableArray *replyData = [NSMutableArray array];
        for (RedirectInfo * info in replyVo.data) {
            
            NSDictionary * dict = @{
                                    @"title":          info.title,
                                    @"subtitle":       info.subTitle,
                                    @"image_url":      info.imageUrl,
                                    @"width":          @(info.width),
                                    @"height":         @(info.height),
                                    @"redirect_uri":   info.redirectUri,
                                    @"source":         info.source
                                    };
            [replyData addObject:dict];
            
        }
        [tabReplyDict setObject:replyData forKey:@"data"];
        
        NSMutableDictionary *extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"fromNickname" : [Session sharedInstance].currentUser.userName,
                                                                                          @"fromHeaderImg" : [_sellerHeaderImg length]>0?_sellerHeaderImg:@"",
                                                                                          @"fromUserId" : [NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId],
                                                                                          @"toNickname" : [_sellerName length]>0?_sellerName:@"",
                                                                                          @"toHeaderImg": [_sellerHeaderImg length]>0?_sellerHeaderImg:@"",
                                                                                          @"toUserId" : [NSNumber numberWithInteger:_sellerId]}];
        
        [extMessage addEntriesFromDictionary:@{@"type":@(replyVo.type),KtabReplyDictKEY:tabReplyDict}];
        
        NSLog(@"tabReplyDict --- :%@",tabReplyDict);
        
        EMMessage *tempMessage = [EaseSDKHelper sendTextMessage:replyVo.title to:_conversation.conversationId messageType:_isChatGroup messageExt:extMessage];
        [self saveChatToDatabase:tempMessage];
    }
    
    
}

-(void)saveChatToDatabase:(EMMessage *)message{
    
    WEAKSELF;
    dispatch_async(_messageQueue, ^{
        
        NSMutableArray * array = [[NSMutableArray alloc] init];
        [array addObject:message];
        
        //消息存入环信数据库
        [[EMClient sharedClient].chatManager importMessages:array];
        [_conversation insertMessage:message];
        NSArray *messages = [weakSelf addChatToMessage:message];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < messages.count; i++) {
            id obj = [messages objectAtIndex:i];
            if (([obj isKindOfClass:[EaseMessageModel class]])) {
                EaseMessageModel *model = (EaseMessageModel *)[messages objectAtIndex:i];
                model.isSender = NO;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count+i inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView beginUpdates];
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
            
            [self.tableView reloadData];
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.dataSource.count-1 inSection:0];
            [weakSelf.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
            
        });
    });
}

#pragma mark

//-(void)sendGoodsMessage{
//    [self sendTextMessage:@"[商品信息]"];
//}

-(void)setIsKefu:(BOOL)isKefu{
    _isKefu = isKefu;
}

-(void)setIsConsultant:(BOOL)isConsultant{
    _isConsultant = isConsultant;
}

-(void)setIsGuwen:(BOOL)isGuwen{
    _isGuwen = isGuwen;
}

-(void)setAdviserPage:(AdviserPage *)adviserPage{
    _adviserPage = adviserPage;
}

-(void)dissMissConBackView{
    self.backView.hidden = YES;
    self.confirmView.hidden = YES;
}

-(void)authUser:(HighestBidVo *)bidVO{
    //授权
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getAuthBid:self.goodsVO.goodsSn andUserID:bidVO.userId completion:^(NSDictionary *data) {
        
        [self dismiss];
        
    } failure:^(XMError *error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:error.errorMsg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }]];
}

-(void)finishAuthPopController{
    //    [self dismiss];
    
    //聊天通知接收者会注册两次,导致crash.添加判断.
    self.backView.hidden = NO;
    self.confirmView.hidden = NO;
    if (self.goodsVO) {
        [ClientReportObject clientReportObjectWithViewCode:ChatViewCode regionCode:RecoveryGoodsAuthUserViewCode referPageCode:RecoveryGoodsAuthUserViewCode andData:@{@"goodsId":self.goodsVO.goodsSn}];
        [self.confirmView getBidVO:self.bidVO andGoodsVO:self.goodsVO];
    } else {
        [self showHUD:@"请尝试到\"我发布的\"进行授权" hideAfterDelay:0.8];
    }
    
}

-(void)getGoodsVO:(RecoveryGoodsVo *)goodsVO andBidVO:(HighestBidVo *)bidVO{
    self.goodsVO = goodsVO;
    self.bidVO = bidVO;
}

- (void)showTipsLbl:(NSString*)message {
    if (!_tipsLbl) {
        _tipsLbl= [[UIInsetLabel alloc] initWithFrame:CGRectMake(0, self.topBarHeight, kScreenWidth, 30) andInsets:UIEdgeInsetsMake(0, 10, 0, 10)];
        _tipsLbl.numberOfLines = 0;
        _tipsLbl.backgroundColor = [UIColor colorWithRed:172.f/255.f green:126.f/255.f blue:51.f/255.f alpha:0.9];//colorWithRed:226.f/255.f green:187.f/255.f blue:102.f/255.f alpha:0.9]; //E2BB66
        _tipsLbl.font = [UIFont systemFontOfSize:11.f];
        _tipsLbl.textColor = [UIColor whiteColor];
    }
    
    BOOL needShowTips = NO;
    NSString *remindText = nil;
    if ([self.sensitivityWordsArray count]>0) {
        for (SensitivityWords *sensitivityWords in self.sensitivityWordsArray) {
            NSArray *words = sensitivityWords.words;
            for (NSString *word in words) {
                if ([message rangeOfString:word options:NSCaseInsensitiveSearch].length>0) {
                    needShowTips = YES;
                    NSLog(@"adviser--------------%@", self.adviserPage);
                    if (self.adviserPage.adviserId > 0) {
                        
                    } else {
                        remindText = sensitivityWords.remind;
                    }
                    break;
                }
            }
        }
    }
    
    if (needShowTips && [remindText length]>0) {
        _tipsLbl.hidden = NO;
        _tipsLbl.alpha = 1.0f;
        [_tipsLbl removeFromSuperview];
        _tipsLbl.text = [NSString stringWithFormat:@"提示: %@",remindText];
        [_tipsLbl sizeToFit];
        _tipsLbl.frame = CGRectMake(0, self.topBarHeight, kScreenWidth, _tipsLbl.height+8);
        [self.view addSubview:_tipsLbl];
        [super bringTopBarToTop];
        
        WEAKSELF;
        double delayInSeconds = 8;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [UIView animateWithDuration:3 animations:^{
                weakSelf.tipsLbl.alpha = 0.f;
            } completion:^(BOOL finished) {
                weakSelf.tipsLbl.hidden = YES;
                [weakSelf.tipsLbl removeFromSuperview];
            }];
        });
    }
}


- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    WEAKSELF;
    if (self.isConsultant) {
        
        [UIActionSheet showInView:self.view
                        withTitle:nil
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:[NSArray arrayWithObjects:@"举报", @"屏蔽", @"复制微信号", nil]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 ReportViewController *viewController = [[ReportViewController alloc] init];
                                 viewController.userId = _sellerId;
                                 [weakSelf pushViewController:viewController animated:YES];
                             }
                             else if (buttonIndex==1) {
                                 [WCAlertView showAlertWithTitle:nil message:@"屏蔽后将不可恢复，确定屏蔽该用户?" customizationBlock:^(WCAlertView *alertView) {
                                     alertView.style = WCAlertViewStyleWhite;
                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                     if (buttonIndex==0) {
                                         
                                     } else {
                                         [weakSelf showProcessingHUD:nil];
                                         [UserService shield:weakSelf.sellerId completion:^{
                                             [weakSelf hideHUD];
                                             [weakSelf dismiss];
                                             
                                             SEL selector = @selector($$handleShieldUserNotification:chatter:);
                                             MBGlobalSendNotificationForSELWithBody(selector,weakSelf.chatter);
                                             
                                         } failure:^(XMError *error) {
                                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
                                         }];
                                     }
                                 } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                             } else if (buttonIndex == 2) {
                                 if (self.adviserPage.weixinId && self.adviserPage.weixinId.length > 0) {
                                     UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                                     [pasteboard setString:self.adviserPage.weixinId];
                                     [WCAlertView showAlertWithTitle:@"复制成功" message:[NSString stringWithFormat:@"腕表顾问 [%@] 微信号 (%@) 复制成功，是否打开微信粘贴查找？", self.adviserPage.username, self.adviserPage.weixinId] customizationBlock:^(WCAlertView *alertView) {
                                         
                                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                         if (buttonIndex == 1) {
                                             NSDictionary *data = @{@"weixinId":self.adviserPage.weixinId};
                                             [ClientReportObject clientReportObjectWithViewCode:MineConsultantViewCode regionCode:CopyWChatNumRegionCode referPageCode:CopyWChatNumRegionCode andData:data];
                                             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"weixin://dl/"]]];
                                         } else {
                                             
                                         }
                                     } cancelButtonTitle:@"稍后添加" otherButtonTitles:@"去添加", nil];
                                 } else {
                                     [weakSelf showHUD:@"复制失败\n暂无微信号" hideAfterDelay:1.8];
                                 }
                             }
                         }];
        
    } else {
        [UIActionSheet showInView:self.view
                        withTitle:nil
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:[NSArray arrayWithObjects:@"举报", @"屏蔽",nil]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 ReportViewController *viewController = [[ReportViewController alloc] init];
                                 viewController.userId = _sellerId;
                                 [weakSelf pushViewController:viewController animated:YES];
                             }
                             else if (buttonIndex==1) {
                                 [WCAlertView showAlertWithTitle:nil message:@"屏蔽后将不可恢复，确定屏蔽该用户?" customizationBlock:^(WCAlertView *alertView) {
                                     alertView.style = WCAlertViewStyleWhite;
                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                     if (buttonIndex==0) {
                                         
                                     } else {
                                         [weakSelf showProcessingHUD:nil];
                                         [UserService shield:weakSelf.sellerId completion:^{
                                             [weakSelf hideHUD];
                                             [weakSelf dismiss];
                                             
                                             SEL selector = @selector($$handleShieldUserNotification:chatter:);
                                             MBGlobalSendNotificationForSELWithBody(selector,weakSelf.chatter);
                                             
                                         } failure:^(XMError *error) {
                                             [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2];
                                         }];
                                     }
                                 } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                             }
                         }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 * @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 * @param hour 如hour为“8”，就是上午8:00（本地时间）
 */
- (NSDate *)getCustomDateWithHour:(NSInteger)hour
{
    //获取当前时间
    NSDate *currentDate = [NSDate date];
    NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init];
    [resultComps setYear:[currentComps year]];
    [resultComps setMonth:[currentComps month]];
    [resultComps setDay:[currentComps day]];
    [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    return [resultCalendar dateFromComponents:resultComps];
}

- (BOOL)isBetweenFromHour:(NSInteger)fromHour toHour:(NSInteger)toHour
{
    NSDate *date8 = [self getCustomDateWithHour:23];
    NSDate *date23 = [self getCustomDateWithHour:9];
    
    NSDate *currentDate = [NSDate date];
    
    if ([currentDate compare:date8]==NSOrderedDescending && [currentDate compare:date23]==NSOrderedAscending)
    {
        NSLog(@"该时间在 %ld:00-%ld:00 之间！", fromHour, toHour);
        return YES;
    }
    return NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (_isScrollToBottom) {
        [self scrollViewToBottom:YES];
    }
    else{
        _isScrollToBottom = YES;
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // 设置当前conversation的所有message为已读
    //    [_conversation markAllMessagesAsRead:YES];
    [_conversation markAllMessagesAsRead];
    
    
}

- (void)dealloc
{
    [_maxDurationTimer invalidate];
    _maxDurationTimer = nil;
    
    _tableView.delegate = nil;
    _tableView.dataSource = nil;
    _tableView = nil;
    
    _slimeView.delegate = nil;
    _slimeView = nil;
    
    _chatToolBar.delegate = nil;
    _chatToolBar = nil;
    
    _goodsBtn = nil;
    
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"RemoveAllMessages" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"addChatData" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"chatApplicationDidEnterBackground" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"finishAuth" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadChatController" object:nil];
    
    // 以下第一行代码必须写，将self从ChatManager的代理中移除
    //    [[EaseMob sharedInstance].chatManager removeDelegate:self];
    //    [[EaseMob sharedInstance].callManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
    //    [[EMClient sharedClient].callManager removeDelegate:self];
}

- (void)handleTopBarBackButtonClicked:(UIButton *)sender
{
    [super handleTopBarBackButtonClicked:sender];
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    //判断当前会话是否为空，若符合则删除该会话
    EMMessage *message = [_conversation latestMessage];
    if (message == nil) {
        [[EMClient sharedClient].chatManager deleteConversation:_conversation.conversationId deleteMessages:YES];
    }
}
- (void)handleSwipBackGuesture
{
    EMMessage *message = [_conversation latestMessage];
    if (message == nil) {
        [[EMClient sharedClient].chatManager deleteConversation:_conversation.conversationId deleteMessages:YES];
    }
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
    [self.chatToolBar cancelTouchRecord];
}


#pragma mark - helper
- (NSURL *)convert2Mp4:(NSURL *)movUrl {
    NSURL *mp4Url = nil;
    AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:movUrl options:nil];
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
    
    if ([compatiblePresets containsObject:AVAssetExportPresetHighestQuality]) {
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset
                                                                              presetName:AVAssetExportPresetHighestQuality];
        mp4Url = [movUrl copy];
        mp4Url = [mp4Url URLByDeletingPathExtension];
        mp4Url = [mp4Url URLByAppendingPathExtension:@"mp4"];
        exportSession.outputURL = mp4Url;
        exportSession.shouldOptimizeForNetworkUse = YES;
        exportSession.outputFileType = AVFileTypeMPEG4;
        dispatch_semaphore_t wait = dispatch_semaphore_create(0l);
        [exportSession exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSession status]) {
                case AVAssetExportSessionStatusFailed: {
                    NSLog(@"failed, error:%@.", exportSession.error);
                } break;
                case AVAssetExportSessionStatusCancelled: {
                    NSLog(@"cancelled.");
                } break;
                case AVAssetExportSessionStatusCompleted: {
                    NSLog(@"completed.");
                } break;
                default: {
                    NSLog(@"others.");
                } break;
            }
            dispatch_semaphore_signal(wait);
        }];
        long timeout = dispatch_semaphore_wait(wait, DISPATCH_TIME_FOREVER);
        if (timeout) {
            NSLog(@"timeout.");
        }
        if (wait) {
            //dispatch_release(wait);
            wait = nil;
        }
    }
    
    return mp4Url;
}

#pragma mark - getter

- (NSMutableArray *)dataSource
{
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (SRRefreshView *)slimeView
{
    if (_slimeView == nil) {
        _slimeView = [[SRRefreshView alloc] init];
        _slimeView.delegate = self;
        _slimeView.upInset = 0;
        _slimeView.slimeMissWhenGoingBack = YES;
        _slimeView.slime.bodyColor = [UIColor colorWithHexString:@"efd8a4"];//[DataSources globalButtonColor];//[UIColor grayColor];
        _slimeView.slime.skinColor = [UIColor colorWithHexString:@"efd8a4"];//;[DataSources globalButtonColor];;
        _slimeView.slime.lineWith = 1;
        _slimeView.slime.shadowBlur = 4;
        _slimeView.slime.shadowColor = [UIColor colorWithHexString:@"efd8a4"];//;[DataSources globalButtonColor];
    }
    
    
    return _slimeView;
}

- (PullRefreshTableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        lpgr.minimumPressDuration = .5;
        [_tableView addGestureRecognizer:lpgr];
        
        _tableView.enableLoadingMore = NO;
    }
    
    return _tableView;
}

- (ChatHobbiesView *)chatHobbiesView{
    if (!_chatHobbiesView) {
        _chatHobbiesView = [[ChatHobbiesView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - _chatToolBar.height - chatHobbiesViewHeight, kScreenWidth, chatHobbiesViewHeight)];
        _chatHobbiesView.hidden = YES;
        _chatHobbiesView.backgroundColor = [UIColor whiteColor];
    }
    return _chatHobbiesView;
}

- (DXMessageToolBar *)chatToolBar
{
    if (_chatToolBar == nil) {
        //        if (self.isYes) {
        //            _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight] - 68)];
        //        } else {
        _chatToolBar = [[DXMessageToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - [DXMessageToolBar defaultHeight], self.view.frame.size.width, [DXMessageToolBar defaultHeight])];
        //        }
        _chatToolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _chatToolBar.delegate = self;
        if (self.isConsultant || self.isGuwen) {
            _chatToolBar.isGuwen = YES;
        }
        
        if (self.isJimai) {
            _chatToolBar.isJimai = YES;
        }
    }
    return _chatToolBar;
}

- (UIImagePickerController *)imagePicker
{
    if (_imagePicker == nil) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    
    return _imagePicker;
}

- (EaseMessageReadManager *)messageReadManager
{
    if (_messageReadManager == nil) {
        _messageReadManager = [EaseMessageReadManager defaultManager];
    }
    
    return _messageReadManager;
}

- (NSDate *)chatTagDate
{
    if (_chatTagDate == nil) {
        _chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:0];
    }
    
    return _chatTagDate;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@", self.dataSource);
    if (indexPath.row < [self.dataSource count]) {
        id obj = [self.dataSource objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[NSString class]]) {
            EMChatTimeCell *timeCell = (EMChatTimeCell *)[tableView dequeueReusableCellWithIdentifier:@"MessageCellTime"];
            if (timeCell == nil) {
                timeCell = [[EMChatTimeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MessageCellTime"];
                timeCell.backgroundColor = [UIColor clearColor];
                timeCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            timeCell.textLabel.text = (NSString *)obj;
            return timeCell;
        }
        
        else if ([obj isKindOfClass:[GoodsInfo class]]) {
            WEAKSELF;
            GoodsInfo *goodsInfo = (GoodsInfo *)obj;
            EMChatGoodsCell *goodsCell = (EMChatGoodsCell *)[tableView dequeueReusableCellWithIdentifier:@"GoodsView"];
            if (!goodsCell) {
                goodsCell = [[EMChatGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"GoodsView"];
                goodsCell.goodsInfo = goodsInfo;
            }
            
            goodsCell.sendGoodsMessage = ^(){
                
                NSString *avatarUrl = [Session sharedInstance].currentUser.avatarUrl;
                NSMutableDictionary *extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"fromNickname" : [Session sharedInstance].currentUser.userName,
                                                                                                  @"fromHeaderImg" : [avatarUrl length]>0?avatarUrl:@"",
                                                                                                  @"fromUserId" : [NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId],
                                                                                                  @"toNickname" : [_sellerName length]>0?_sellerName:@"",
                                                                                                  @"toHeaderImg": [_sellerHeaderImg length]>0?_sellerHeaderImg:@"",
                                                                                                  @"toUserId" : [NSNumber numberWithInteger:_sellerId]}];
                
                [extMessage addEntriesFromDictionary:@{@"type":@1,@"goods":_goodsDic}];
                
                //                EMMessage *tempMessage = [EaseSDKHelper sendTextMessageWithString:@"[商品信息]"
                //                                                                        toUsername:_conversation.conversationId
                //                                                                       isChatGroup:_isChatGroup
                //                                                                 requireEncryption:NO
                //                                                                               ext:extMessage];
                
                EMMessage *tempMessage = [EaseSDKHelper sendTextMessage:@"[商品信息]" to:_conversation.conversationId messageType:_isChatGroup messageExt:extMessage];
                [self addChatDataToMessage:tempMessage isSend:YES];
                
            };
            
            __block BOOL isPush = YES;
            goodsCell.gotoBoughtViewController = ^(BaseViewController *payViewController){
                if (isPush) {
                    isPush = NO;
                    BoughtCollectionViewController *viewContrller = [[BoughtCollectionViewController alloc] init];
                    [weakSelf pushViewController:viewContrller animated:YES];
                    //                    [payViewController dismiss:NO];
                }
            };
            
            return goodsCell;
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary * dict = (NSDictionary *)obj;
            EMChatTimeCell1 *timeCell1 = (EMChatTimeCell1 *)[tableView dequeueReusableCellWithIdentifier:@"guwenOnlineTime"];
            if (!timeCell1) {
                timeCell1 = [[EMChatTimeCell1 alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"guwenOnlineTime"];
            }
            timeCell1.onLineLbl.text = dict[@"autoReply"];
            [timeCell1.onLineLbl sizeToFit];
            return  timeCell1;
            
        }
        else if ([obj isKindOfClass:[EaseMessageModel class]]) {
            EaseMessageModel *model = (EaseMessageModel *)obj;
            NSLog(@"-----:%@",[model.message.ext objectForKey:@"type"]);
            if ([[model.message.ext objectForKey:@"type"]  isEqual: @(EMChatNewArrivalCellType)]) {
                
                NSString *cellIdentifier = [EMChatNewArrivalCell cellIdentifierForEMChatNewArrivalCell];
                EMChatNewArrivalCell *cell = (EMChatNewArrivalCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[EMChatNewArrivalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.messageModel = model;
                return cell;
                
                
                
            } else if ([[model.message.ext objectForKey:@"type"]  isEqual: @(EMChatSpecialCellType)]) {
                NSString *cellIdentifier = [EMChatSpecialCell cellIdentifierForEMChatSpecialCell];
                EMChatSpecialCell *cell = (EMChatSpecialCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[EMChatSpecialCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
                cell.messageModel = model;
                return cell;
                
                
            }else if ([[model.message.ext objectForKey:@"type"]  isEqual: @(EMChatTextCellType)]){
                model.isSender = NO;
                if (model.isSender) {
                    model.headImageURL =[NSURL URLWithString: [Session sharedInstance].currentUser.avatarUrl];
                } else {
                    model.headImageURL = [NSURL URLWithString:[model.message.ext stringValueForKey:@"fromHeaderImg"]];
                }
                
                
                NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
                EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                    
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.userId = model.isSender ? [Session sharedInstance].currentUser.userId : [model.message.ext integerValueForKey:@"fromUserId"];
                    
                }
                
                cell.messageModel = model;
                
                return cell;
                
                
            }else{
                if (model.isSender) {
                    
                    model.headImageURL =[NSURL URLWithString: [Session sharedInstance].currentUser.avatarUrl];
                } else {
                    model.headImageURL = [NSURL URLWithString:[model.message.ext stringValueForKey:@"fromHeaderImg"]];
                }
                
                
                NSString *cellIdentifier = [EMChatViewCell cellIdentifierForMessageModel:model];
                EMChatViewCell *cell = (EMChatViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
                if (cell == nil) {
                    cell = [[EMChatViewCell alloc] initWithMessageModel:model reuseIdentifier:cellIdentifier];
                    
                    cell.backgroundColor = [UIColor clearColor];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.userId = model.isSender ? [Session sharedInstance].currentUser.userId : [model.message.ext integerValueForKey:@"fromUserId"];
                    
                }
                
                cell.messageModel = model;
                
                return cell;
            }
        }
    }
    
    return nil;
}

#pragma mark - Table view delegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSObject *obj = [self.dataSource objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return 40;
    } else if ([obj isKindOfClass:[GoodsInfo class]]) {
        return 91;
    } else if ([obj isKindOfClass:[NSDictionary class]]) {
        return 40;
    }
    else {
        if ([[((EaseMessageModel *)obj).message.ext objectForKey:@"type"]  isEqual: @(EMChatNewArrivalCellType)]) {
            return [EMChatNewArrivalCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(EaseMessageModel *)obj];;
        }else if ([[((EaseMessageModel *)obj).message.ext objectForKey:@"type"]  isEqual: @(EMChatSpecialCellType)]){
            return [EMChatSpecialCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(EaseMessageModel *)obj];
        }else{
            return [EMChatViewCell tableView:tableView heightForRowAtIndexPath:indexPath withObject:(EaseMessageModel *)obj];
        }
        
    }
}

#pragma mark - scrollView delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //    if (_slimeView) {
    //        [_slimeView scrollViewDidScroll];
    //    }
    [_tableView scrollViewDidScroll:scrollView];
    
    if (self.isGuwen || self.isConsultant) {
        NSLog(@"%.2f", scrollView.contentOffset.y);
        if (scrollView.contentOffset.y<= - KcontentMarginTop) {
            self.headerImageView.frame = CGRectMake(0, scrollView.contentOffset.y, self.headerImageView.width, self.headerImageView.height);
        }
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat contentSet = scrollView.contentOffset.y;
    if (scrollView.contentOffset.y < 0) {
        contentSet = 0;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //    if (_slimeView) {
    //        [_slimeView scrollViewDidEndDraging];
    //    }
    [_tableView scrollViewDidEndDragging:scrollView];
}

#pragma mark - pullTableView delegate
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView.contentOffset.y > 300) {
//        self.scrollTopBtn.hidden = NO;
//    } else {
//        self.scrollTopBtn.hidden = YES;
//    }
//    [_tableView scrollViewDidScroll:scrollView];
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    [_tableView scrollViewDidEndDragging:scrollView];
//}

//调整刷新
-(void)pullTableViewDidTriggerRefresh:(PullRefreshTableView *)tableView{
    _tableView.pullTableIsRefreshing = YES;
    _chatTagDate = nil;
    EMMessage *firstMessage = [self.messages firstObject];
    if (firstMessage)
    {
        self.messageId = firstMessage.messageId;
        [self loadMoreMessagesFrom:firstMessage.timestamp count:KPageCount append:YES];
    }
    _tableView.pullTableIsRefreshing = NO;
}

#pragma mark - slimeRefresh delegate
//加载更多
- (void)slimeRefreshStartRefresh:(SRRefreshView *)refreshView
{
    _chatTagDate = nil;
    EMMessage *firstMessage = [self.messages firstObject];
    if (firstMessage)
    {
        self.messageId = firstMessage.messageId;
        [self loadMoreMessagesFrom:firstMessage.timestamp count:KPageCount append:YES];
    }
    [_slimeView endRefresh];
    
}

#pragma mark - GestureRecognizer

// 点击背景隐藏
-(void)keyBoardHidden
{
    [self.chatToolBar endEditing:YES];
}

- (void)handleLongPress:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan && [self.dataSource count] > 0) {
        CGPoint location = [recognizer locationInView:self.tableView];
        NSIndexPath * indexPath = [self.tableView indexPathForRowAtPoint:location];
        id object = [self.dataSource objectAtIndex:indexPath.row];
        if ([object isKindOfClass:[EaseMessageModel class]]) {
            EMChatViewCell *cell = (EMChatViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            [cell becomeFirstResponder];
            _longPressIndexPath = indexPath;
            [self showMenuViewController:cell.bubbleView andIndexPath:indexPath messageType:cell.messageModel.bodyType];
        }
    }
}

#pragma mark - UIResponder actions

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo
{
    EaseMessageModel *model = [userInfo objectForKey:KMESSAGEKEY];
    if ([eventName isEqualToString:kRouterEventTextURLTapEventName]) {
        [self chatTextCellUrlPressed:[userInfo objectForKey:@"url"]];
    }
    else if ([eventName isEqualToString:kRouterEventAudioBubbleTapEventName]) {
        [self chatAudioCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventImageBubbleTapEventName]){
        [self chatImageCellBubblePressed:model];
    }
    else if ([eventName isEqualToString:kRouterEventGoodsBubbleTapEventName]) {
        [self chatGoodsCellBubblePressed:model];
    }
    else if([eventName isEqualToString:kResendButtonTapEventName]){
        EMChatViewCell *resendCell = [userInfo objectForKey:kShouldResendCell];
        EaseMessageModel *messageModel = resendCell.messageModel;
        if ((messageModel.messageStatus != EMMessageStatusFailed) && (messageModel.messageStatus != EMMessageStatusPending))
        {
            return;
        }
        id <IEMChatManager> chatManager = [[EMClient sharedClient] chatManager];//[[EaseMob sharedInstance] chatManager];
        //        [chatManager asyncResendMessage:messageModel.message progress:nil];
        [chatManager asyncResendMessage:messageModel.message progress:nil completion:nil];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:resendCell];
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
    }
    //    }else if([eventName isEqualToString:kRouterEventChatCellVideoTapEventName]){
    //        [self chatVideoCellPressed:model];
    //    }
}
- (void)chatGoodsCellBubblePressed:(id<IMessageModel>)model
{
    NSDictionary *goodsDict = [model.message.ext objectForKey:@"goods"];
    if ([model.message.ext[@"goods"] isKindOfClass:[NSDictionary class]]) {
        goodsDict = model.message.ext[@"goods"];
    } else {
        goodsDict = [self dictionaryWithJsonString:model.message.ext[@"goods"]];
    }
    
    NSInteger service_type =  [goodsDict integerValueForKey:@"service_type"];
    NSInteger userId = [goodsDict integerValueForKey:@"fromUserId"];
    if (service_type == 10) {
        //        RecoverDetailViewController *recoverDetailViewController = [[RecoverDetailViewController alloc] init];
        OfferedViewController *viewController = [[OfferedViewController alloc] init];
        if (userId == [Session sharedInstance].currentUserId) {
            //            viewController.index = 2;
            viewController.index = 2;
        }
        viewController.goodID = [goodsDict stringValueForKey:@"goods_id"];
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    } else {
        GoodsDetailViewControllerContainer *viewController = [[GoodsDetailViewControllerContainer alloc] init];
        viewController.goodsId = [goodsDict stringValueForKey:@"goods_id"];
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    }
}

//链接被点击
- (void)chatTextCellUrlPressed:(NSURL *)url
{
    if (url) {
        [[UIApplication sharedApplication] openURL:url];
    }
}

// 语音的bubble被点击
-(void)chatAudioCellBubblePressed:(id<IMessageModel>)model
{
    EMFileMessageBody *body = (EMFileMessageBody *)model.message.body;
    EMDownloadStatus downloadStatus = [body downloadStatus];
    if (downloadStatus == EMDownloadStatusDownloading) {
        [self showHint:NSEaseLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        return;
    }
    else if (downloadStatus == EMDownloadStatusFailed)
    {
        [self showHint:NSEaseLocalizedString(@"message.downloadingAudio", @"downloading voice, click later")];
        [[EMClient sharedClient].chatManager asyncDownloadMessageAttachments:model.message progress:nil completion:NULL];
        return;
    }
    
    // 播放音频
    if (model.bodyType == EMMessageBodyTypeVoice) {
        //send the acknowledgement  发送已读回执
        [self shouldAckMessage:model.message read:YES];
        __weak ChatViewController *weakSelf = self;
        BOOL isPrepare = [[EaseMessageReadManager defaultManager] prepareMessageAudioModel:model updateViewCompletion:^(EaseMessageModel *prevAudioModel, EaseMessageModel *currentAudioModel) {
            if (prevAudioModel || currentAudioModel) {
                [weakSelf.tableView reloadData];
            }
        }];
        
        if (isPrepare) {
            _isPlayingAudio = YES;
            __weak ChatViewController *weakSelf = self;
            [[EMCDDeviceManager sharedInstance] enableProximitySensor];
            [[EMCDDeviceManager sharedInstance] asyncPlayingWithPath:model.fileLocalPath completion:^(NSError *error) {
                [[EaseMessageReadManager defaultManager] stopMessageAudioModel];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.tableView reloadData];
                    weakSelf.isPlayingAudio = NO;
                    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
                });
            }];
        }
        else{
            _isPlayingAudio = NO;
        }
    }
}


- (void)chatTextCellPhonePressed:(NSString *)phone
{
    if (phone) {
        
        [UIActionSheet showInView:self.view
                        withTitle:@"拨打电话?"
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:phone
                otherButtonTitles:nil //[NSArray arrayWithObjects:@"拨打客服电话", nil]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             if (buttonIndex == 0) {
                                 NSString *phoneNumber = [@"tel://" stringByAppendingString:phone];
                                 [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
                             }
                         }];
    }
}

// 图片的bubble被点击
-(void)chatImageCellBubblePressed:(EaseMessageModel *)model
{
    NSMutableArray *imageUrlArr = [[NSMutableArray alloc] init];
    NSMutableArray *localPathArr = [[NSMutableArray alloc] init];
    
    NSArray *imageMessage = [_conversation loadMoreMessagesWithType:EMMessageBodyTypeImage before:-1 limit:-1 from:nil direction:EMMessageSearchDirectionUp];
    __weak ChatViewController *weakSelf = self;
    id <IEMChatManager> chatManager = [[EMClient sharedClient] chatManager];//[[EaseMob sharedInstance] chatManager];
    
    
    [weakSelf showHudInView:weakSelf.view hint:@"正在获取大图..."];
    for (int i = 0; i < imageMessage.count; i++) {
        EMMessage *message = imageMessage[i];
        if (message.body.type == EMMessageBodyTypeImage) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)message.body;
            if ([imageBody type] == EMMessageBodyTypeImage) {
                EMImageMessageBody *imageBody = (EMImageMessageBody *)message.body;
                if (imageBody.thumbnailDownloadStatus == EMDownloadStatusSuccessed) {
                    
                    [chatManager asyncDownloadMessageAttachments:message progress:nil completion:^(EMMessage *message, EMError *error) {
                        
                        if (!error) {
                            NSString *localPath = [imageBody localPath];//message == nil ? model.fileLocalPath :
                            if (localPath && localPath.length > 0) {
                                
                                if ([imageBody.displayName hasPrefix:CHAT_GOODS_PREFIX]) {
                                    GoodsDetailViewControllerContainer *viewController = [[GoodsDetailViewControllerContainer alloc] init];
                                    NSRange range = [imageBody.displayName rangeOfString:CHAT_GOODS_PREFIX];
                                    viewController.goodsId = [imageBody.displayName substringFromIndex:(range.location+range.length) ];
                                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                                    
                                } else {
                                    NSURL *url = [NSURL fileURLWithPath:localPath];
                                    [imageUrlArr addObject:url];
                                    [localPathArr addObject:localPath];
                                    weakSelf.isScrollToBottom = NO;
                                    if (i == imageMessage.count-1) {
                                        
                                        NSInteger index = 0;
                                        NSString *local = [[NSString alloc] init];
                                        EMImageMessageBody *imageBody;
                                        for (int i = 0; i < localPathArr.count; i++) {
                                            local = localPathArr[i];
                                            if ([model bodyType] == EMMessageBodyTypeImage) {
                                                imageBody = (EMImageMessageBody *)model.message.body;
                                                if ([local isEqualToString:imageBody.localPath]) {
                                                    index = i;
                                                    NSLog(@"%@---------%@", local, imageBody.localPath);
                                                    
                                                    NSLog(@"%ld", (long)index);
                                                }
                                            }
                                        }
                                        
                                        [weakSelf hideHud];
                                        [weakSelf.messageReadManager showBrowserWithImages:imageUrlArr andChooseIndex:index];
                                    }
                                }
                                
                                return ;
                            }
                        }
                        [weakSelf hideHud];
                        [weakSelf showHUD:[error errorDescription] hideAfterDelay:1.2f];
                        [weakSelf showHint:@"大图获取失败!"];
                    }];
                }else{
                    //获取缩略图
                    
                    [chatManager asyncDownloadMessageThumbnail:message progress:nil completion:^(EMMessage *message, EMError *error) {
                        if (!error) {
                            [weakSelf reloadTableViewDataWithMessage:message];
                        }else{
                            [weakSelf showHint:@"缩略图获取失败!"];
                        }
                    }];
                    
                }
            }else if (message.body.type == EMMessageBodyTypeVoice) {
                //获取缩略图
                EMVideoMessageBody *videoBody = (EMVideoMessageBody *)message.body;
                if (videoBody.thumbnailDownloadStatus != EMDownloadStatusSuccessed) {
                    
                    [chatManager asyncDownloadMessageThumbnail:message progress:nil completion:^(EMMessage *message, EMError *error) {
                        if (!error) {
                            [weakSelf reloadTableViewDataWithMessage:message];
                        }else{
                            [weakSelf showHint:@"缩略图获取失败!"];
                        }
                    }];
                }
            }
        }
    }
    
    [self keyBoardHidden];
}

#pragma mark - IChatManagerDelegate
//这里有点问题
-(void)didUpdateConversationList:(NSArray *)aConversationList{
    
}

-(void)didReceiveHasReadAcks:(NSArray *)aMessages{
    
    [self.dataSource enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         for (EMMessage *message in aMessages) {
             if ([obj isKindOfClass:[EaseMessageModel class]])
             {
                 EaseMessageModel *model = (EaseMessageModel*)obj;
                 if ([model.messageId isEqualToString:message.conversationId])
                 {
                     model.message.isReadAcked = YES;
                     *stop = YES;
                 }
             }
         }
         
     }];
    [self.tableView reloadData];
}

- (void)reloadTableViewDataWithMessage:(EMMessage *)message{
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        if ([weakSelf.conversation.conversationId isEqualToString:message.conversationId])
        {
            for (int i = 0; i < weakSelf.dataSource.count; i ++) {
                id object = [weakSelf.dataSource objectAtIndex:i];
                if ([object isKindOfClass:[EaseMessageModel class]]) {
                    EMMessage *currMsg = [weakSelf.dataSource objectAtIndex:i];
                    if ([message.messageId isEqualToString:currMsg.messageId]) {
                        
                        EaseMessageModel *cellModel = [[EaseMessageModel alloc] initWithMessage:message];
                        cellModel.headImageURL = [NSURL URLWithString:_sellerHeaderImg];
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.tableView beginUpdates];
                            [weakSelf.dataSource replaceObjectAtIndex:i withObject:cellModel];
                            [weakSelf.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                            [weakSelf.tableView endUpdates];
                            
                        });
                        
                        break;
                    }
                }
            }
        }
    });
}

- (void)didMessageAttachmentsStatusChanged:(EMMessage *)message
                                     error:(EMError *)error{
    if (!error) {
        EMFileMessageBody *fileBody = (EMFileMessageBody*)[message body];
        if ([fileBody type] == EMMessageBodyTypeImage) {
            EMImageMessageBody *imageBody = (EMImageMessageBody *)fileBody;
            if ([imageBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody type] == EMMessageBodyTypeVideo){
            EMVideoMessageBody *videoBody = (EMVideoMessageBody *)fileBody;
            if ([videoBody thumbnailDownloadStatus] == EMDownloadStatusSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }else if([fileBody type] == EMMessageBodyTypeVoice){
            if ([fileBody downloadStatus] == EMDownloadStatusSuccessed)
            {
                [self reloadTableViewDataWithMessage:message];
            }
        }
        
    }else{
        
    }
}

- (void)didFetchingMessageAttachments:(EMMessage *)message progress:(float)progress{
    NSLog(@"didFetchingMessageAttachment: %f", progress);
}

-(void)reloadChatController:(NSNotification *)notify{
}

-(void)didReceiveMessages:(NSArray *)aMessages{
    //    [self chatSaveChatPoint:aMessages uploadType:CHAT_RECEIVE];
    
    EMMessage *messageDemo = aMessages[0];
    NSLog(@"%@, %ld", messageDemo.ext[@"fromUserId"], _userId);
    
    if (((NSNumber *)messageDemo.ext[@"fromUserId"]).integerValue == _userId) {
        [self chatSaveChatPoint:aMessages uploadType:CHAT_RECEIVE isRecive:YES];
    }
    
    for (EMMessage *message in aMessages) {
        if (message.chatType == EMChatTypeChat) {
            if ([message.ext objectForKey:@"type"]!=nil &&
                [message.ext integerValueForKey:@"type"]==1) {
            } else {
                if (message.body && [message.body isKindOfClass:[EMTextMessageBody class]]) {
                    EMTextMessageBody *textMsgBody = (EMTextMessageBody *)message.body;
                    [self showTipsLbl:textMsgBody.text];
                }
            }
        }
        if (!message.isRead && [message.ext integerValueForKey:@"notify"] == 0 ) {
            [ChatService chatNotice:[Session sharedInstance].currentUserId isAdd:NO];
        }
        
        if ([_conversation.conversationId isEqualToString:message.conversationId]) {
            //        [_conversation markMessageWithId:message.messageId asRead:YES];
            [_conversation markMessageAsReadWithId:message.messageId];
            [self addChatDataToMessage:message isSend:NO];
        }
    }
}

//和在线使用同一个方法
-(void)didReceiveOfflineMessages:(NSArray *)offlineMessages{
    
}

#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    // 隐藏键盘
    [self keyBoardHidden];
    
    //    // 弹出照片选择
    //    self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    //    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    //    [self presentViewController:self.imagePicker animated:YES completion:NULL];
    
    //从手机相册选择
    WEAKSELF;
    AssetPickerController * imagePicker =  [[AssetPickerController alloc] init];
    imagePicker.minimumNumberOfSelection = 1;
    imagePicker.delegate = weakSelf;
    imagePicker.assetsFilter = [ALAssetsFilter allPhotos];
    imagePicker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
            return NO;
        } else {
            return YES;
        }
    }];
    [weakSelf presentViewController:imagePicker animated:YES completion:^{
    }];
}

- (void)moreViewGoodsAction:(DXChatBarMoreView *)moreView
{
    //    [self keyBoardHidden];
    WEAKSELF;
    NSArray *arr = [NSArray arrayWithObjects:@"自己卖", nil];
    [UIActionSheet showInView:self.view
                    withTitle:nil
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:arr
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         
                         if (buttonIndex == 0) {
                             
                             if ([Session sharedInstance].currentUser.type==1) { //客服
                                 SearchViewController *viewController = [[SearchViewController alloc] init];
                                 viewController.delegate = self;
                                 viewController.isForSelected = YES;
                                 [weakSelf pushViewController:viewController animated:YES];
                             } else if ([Session sharedInstance].currentUser.type == 2) { //顾问
                                 SearchViewController *viewController = [[SearchViewController alloc] init];
                                 viewController.delegate = self;
                                 viewController.isForSelected = YES;
                                 viewController.sellerId = ADMSHOPSELLER;
                                 [weakSelf pushViewController:viewController animated:YES];
                             } else {
                                 SearchViewController *viewController = [[SearchViewController alloc] init];
                                 viewController.delegate = self;
                                 viewController.isForSelected = YES;
                                 viewController.sellerId = [Session sharedInstance].currentUserId;
                                 [weakSelf pushViewController:viewController animated:YES];
                             }
                             
                         } else if (buttonIndex == 1) {
                             
                             //                             OnSaleViewController *onSaleViewController = [[OnSaleViewController alloc] init];
                             //                             onSaleViewController.isHaveTopbar = YES;
                             //                             onSaleViewController.sellerId = _sellerId;
                             //                             onSaleViewController.chatter = _chatter;
                             //                             onSaleViewController.sellerName = _sellerName;
                             //                             onSaleViewController.sellerHeaderImg = _sellerHeaderImg;
                             //                             onSaleViewController.type = 2;
                             //                             onSaleViewController.recoverStatus = 1;
                             //                             onSaleViewController.isChatCome = 1;
                             //                             [weakSelf pushViewController:onSaleViewController animated:YES];
                             
                         }  else if (buttonIndex == 2) {
                             
                         };
                     }];
}

-(void)moreViewSeekAction:(DXChatBarMoreView *)moreView{
    SeekToPurchasePublishController *viewController = [[SeekToPurchasePublishController alloc] init];
    [self pushViewController:viewController animated:YES];
}

- (void)moreViewJimaiAction:(DXChatBarMoreView *)moreView{
    ConsignmentViewController *viewController = [[ConsignmentViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

-(void)moreViewLikeAction:(DXChatBarMoreView *)moreView{
    UserLikesViewController *viewController = [[UserLikesViewController alloc] init];
    viewController.isHaveTopbar = YES;
    viewController.sellerName = _sellerName;
    viewController.sellerId = _sellerId;
    viewController.sellerHeaderImg = _sellerHeaderImg;
    viewController.userId = [Session sharedInstance].currentUserId;
    viewController.chatter = _chatter;
    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
}

- (void)searchViewGoodsSelected:(SearchViewController*)viewController recommendGoods:(RecommendGoodsInfo*)recommendGoodsInfo
{
    NSDictionary *goodsDic = @{@"goods_id":recommendGoodsInfo.goodsId,
                               @"goods_name" : [recommendGoodsInfo.goodsName length]>0?recommendGoodsInfo.goodsName:@"",
                               @"shop_price" : [NSNumber numberWithDouble:recommendGoodsInfo.shopPrice],
                               @"thumb_url" : [recommendGoodsInfo.thumbUrl length]>0?recommendGoodsInfo.thumbUrl:@""};
    
    
    NSString *avatarUrl = [Session sharedInstance].currentUser.avatarUrl;
    
    NSMutableDictionary *extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"fromNickname" : [Session sharedInstance].currentUser.userName,
                                                                                      @"fromHeaderImg" : [avatarUrl length]>0?avatarUrl:@"",
                                                                                      @"fromUserId" : [NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId],
                                                                                      @"toNickname" : [_sellerName length]>0?_sellerName:@"",
                                                                                      @"toHeaderImg": [_sellerHeaderImg length]>0?_sellerHeaderImg:@"",
                                                                                      @"toUserId" : [NSNumber numberWithInteger:_sellerId]}];
    
    [extMessage addEntriesFromDictionary:@{@"type":@1,@"goods":goodsDic}];
    
    //    EMMessage *tempMessage = [ChatSendHelper sendTextMessageWithString:@"[商品信息]"
    //                                                            toUsername:_conversation.chatter
    //                                                           isChatGroup:_isChatGroup
    //                                                     requireEncryption:NO
    //                                                                   ext:extMessage];
    EMMessage *tempMessage = [EaseSDKHelper sendTextMessage:@"[商品信息]" to:_conversation.conversationId messageType:_isChatGroup messageExt:extMessage];
    
    [self addChatDataToMessage:tempMessage isSend:YES];
    
    [viewController dismiss];
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    [self keyBoardHidden];
    
#if TARGET_IPHONE_SIMULATOR
    [self showHint:@"模拟器不支持拍照"];
#elif TARGET_OS_IPHONE
    self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.mediaTypes = @[(NSString *)kUTTypeImage];
    [self presentViewController:self.imagePicker animated:YES completion:NULL];
#endif
}

#pragma mark - DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    [_menuController setMenuItems:nil];
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    [UIView animateWithDuration:0.3 animations:^{
        self.chatHobbiesView.frame = CGRectMake(0, kScreenHeight-toHeight-chatHobbiesViewHeight, kScreenWidth, chatHobbiesViewHeight);
    }];
    
    if (self.isVisible) {
        CGRect rect = self.tableView.frame;
        if (self.isYes) {
            rect.origin.y = self.chatHeaderView.height + 60;
            rect.size.height = self.view.height-toHeight- self.chatHeaderView.height - 60;
        } else {
            rect.origin.y = self.topBarHeight;
            rect.size.height = self.view.height-toHeight- self.topBarHeight;
        }
        
        if (![self.chatHobbiesView isHidden]) {
            rect.origin.y = self.topBarHeight;
            rect.size.height = self.view.height - self.topBarHeight -self.chatHobbiesView.height-self.chatToolBar.height;
        }
        
        if ([self.chatToolBar.inputTextView isFirstResponder]) {
            self.tableView.frame = rect;
            [self scrollViewToBottom:YES];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                self.tableView.frame = rect;
                [self scrollViewToBottom:NO];
            } completion:^(BOOL finished) {
                self.tableView.frame = rect;
                [self scrollViewToBottom:YES];
            }];
        }
        
        
        
        //        [self scrollViewToBottom:YES];
    }
}

- (void)didSendFaceWithText:(NSString *)text
{
    //NSString *uuid = [[NSUUID UUID] UUIDString];
    if (_sellerId>0) {
        _extMessage = [NSMutableDictionary dictionaryWithDictionary:@{@"fromNickname" : [Session sharedInstance].currentUser.userName,
                                                                      @"fromHeaderImg" : [Session sharedInstance].currentUser.avatarUrl,
                                                                      @"fromUserId" : [NSNumber numberWithInteger:[Session sharedInstance].currentUser.userId],
                                                                      @"toNickname" : _sellerName,
                                                                      @"toHeaderImg": _sellerHeaderImg,
                                                                      @"toUserId" : [NSNumber numberWithInteger:_sellerId]}];
    }
    
    
    
    if (text && text.length > 0) {
        [self sendTextMessage:text];
    }
}

#pragma mark - audioAction

/**
 *  按下录音按钮开始录音
 */
- (void)didStartRecordingVoiceAction:(UIView *)recordView
{
    if ([self canRecord]) {
        DXRecordView *tmpView = (DXRecordView *)recordView;
        tmpView.center = self.view.center;
        [self.view addSubview:tmpView];
        [self.view bringSubviewToFront:recordView];
        int x = arc4random() % 100000;
        NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
        NSString *fileName = [NSString stringWithFormat:@"%d%d",(int)time,x];
        
        [[EMCDDeviceManager sharedInstance] asyncStartRecordingWithFileName:fileName
                                                                 completion:^(NSError *error)
         {
             if (error) {
                 NSLog(NSLocalizedString(@"message.startRecordFail", @"failure to start recording"));
             }
         }];
    }
    _isTimeLimited = NO;
    
    
    
    [_maxDurationTimer invalidate];
    _maxDurationTimer = nil;
    WeakTimerTarget *target = [[WeakTimerTarget alloc] initWithTarget:self selector:@selector(didFinishRecoingVoiceByTimeAction:)];
    _maxDurationTimer = [NSTimer scheduledTimerWithTimeInterval:[EMCDDeviceManager recordMaxDuration] target:target selector:@selector(timerDidFire:) userInfo:nil repeats:YES];
}

/**
 *  手指向上滑动取消录音
 */
- (void)didCancelRecordingVoiceAction:(UIView *)recordView
{
    [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
}

/**
 *  松开手指完成录音
 */
- (void)didFinishRecoingVoiceAction:(UIView *)recordView
{
    if (!_isTimeLimited) {
        __weak typeof(self) weakSelf = self;
        [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
            if (!error) {
                //                EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
                //                                                           displayName:@"audio"];
                //                voice.duration = aDuration;
                [weakSelf sendAudioMessage:recordPath andDuraion:aDuration];
            }else {
                [weakSelf showHudInView:self.view hint:NSLocalizedString(@"media.timeShort", @"The recording time is too short")];
                weakSelf.chatToolBar.recordButton.enabled = NO;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakSelf hideHud];
                    weakSelf.chatToolBar.recordButton.enabled = YES;
                });
            }
        }];
        
    }
}

- (void)didFinishRecoingVoiceByTimeAction:(UIView *)recordView
{
    if ([[EMCDDeviceManager sharedInstance] isRecording]) {
        _isTimeLimited = YES;
        __weak typeof(self) weakSelf = self;
        [self.chatToolBar.recordView removeFromSuperview];
        [self showHudInView:self.view hint:NSLocalizedString(@"media.timeLimited", @"Message too long")];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf hideHud];
            [[EMCDDeviceManager sharedInstance] cancelCurrentRecording];
        });
        
        [[EMCDDeviceManager sharedInstance] asyncStopRecordingWithCompletion:^(NSString *recordPath, NSInteger aDuration, NSError *error) {
            //            EMChatVoice *voice = [[EMChatVoice alloc] initWithFile:recordPath
            //                                                       displayName:@"audio"];
            //            voice.duration = aDuration;
            [weakSelf sendAudioMessage:recordPath andDuraion:aDuration];
            weakSelf.chatToolBar.recordButton.enabled = YES;
            [_maxDurationTimer invalidate];
        }];
        
    }
}

-(void)assetPickerController:(AssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *originalImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [weakSelf sendImageMessageWithOriginImage:originalImage];
        }
    });
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
        NSURL *videoURL = info[UIImagePickerControllerMediaURL];
        [picker dismissViewControllerAnimated:YES completion:nil];
        
        // we will convert it to mp4 format
        NSURL *mp4 = [self convert2Mp4:videoURL];
        NSFileManager *fileman = [NSFileManager defaultManager];
        if ([fileman fileExistsAtPath:videoURL.path]) {
            NSError *error = nil;
            [fileman removeItemAtURL:videoURL error:&error];
            if (error) {
                NSLog(@"failed to remove file, error:%@.", error);
            }
        }
        //        EMChatVideo *chatVideo = [[EMChatVideo alloc] initWithFile:[mp4 relativePath] displayName:@"video.mp4"];
        [self sendVideoMessage:[mp4 relativePath]];
        
    }else{
        UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
        [picker dismissViewControllerAnimated:YES completion:nil];
        [self sendImageMessageWithOriginImage:orgImage];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self.imagePicker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MenuItem actions

- (void)copyMenuAction:(id)sender
{
    // todo by du. 复制
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    if (_longPressIndexPath.row > 0) {
        EaseMessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        pasteboard.string = model.text;
    }
    
    _longPressIndexPath = nil;
}

- (void)deleteMenuAction:(id)sender
{
    if (_longPressIndexPath && _longPressIndexPath.row > 0) {
        EaseMessageModel *model = [self.dataSource objectAtIndex:_longPressIndexPath.row];
        NSMutableArray *messages = [NSMutableArray arrayWithObjects:model, nil];
        //        [_conversation removeMessage:model.message];
        [_conversation deleteMessageWithId:model.message.messageId];
        NSMutableArray *indexPaths = [NSMutableArray arrayWithObjects:_longPressIndexPath, nil];;
        if (_longPressIndexPath.row - 1 >= 0) {
            id nextMessage = nil;
            id prevMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row - 1)];
            if (_longPressIndexPath.row + 1 < [self.dataSource count]) {
                nextMessage = [self.dataSource objectAtIndex:(_longPressIndexPath.row + 1)];
            }
            if ((!nextMessage || [nextMessage isKindOfClass:[NSString class]]) && [prevMessage isKindOfClass:[NSString class]]) {
                [messages addObject:prevMessage];
                [indexPaths addObject:[NSIndexPath indexPathForRow:(_longPressIndexPath.row - 1) inSection:0]];
            }
        }
        [self.dataSource removeObjectsInArray:messages];
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    }
    
    _longPressIndexPath = nil;
}

#pragma mark - private

- (BOOL)canRecord
{
    __block BOOL bCanRecord = YES;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending)
    {
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        if ([audioSession respondsToSelector:@selector(requestRecordPermission:)]) {
            [audioSession performSelector:@selector(requestRecordPermission:) withObject:^(BOOL granted) {
                bCanRecord = granted;
            }];
        }
    }
    
    return bCanRecord;
}

- (void)stopAudioPlayingWithChangeCategory:(BOOL)isChange
{
    //停止音频播放及播放动画
    [[EMCDDeviceManager sharedInstance] stopPlaying];
    [[EMCDDeviceManager sharedInstance] disableProximitySensor];
    [EMCDDeviceManager sharedInstance].delegate = nil;
    EaseMessageModel *playingModel = [self.messageReadManager stopMessageAudioModel];
    NSIndexPath *indexPath = nil;
    if (playingModel) {
        indexPath = [NSIndexPath indexPathForRow:[self.dataSource indexOfObject:playingModel] inSection:0];
    }
    
    if (indexPath) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            [self.tableView endUpdates];
        });
    }
}

- (NSArray *)sortChatSource:(NSArray *)array
{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    if (array && [array count] > 0) {
        
        for (EMMessage *message in array) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                [resultArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            EaseMessageModel *model = [[EaseMessageModel alloc] initWithMessage:message];
            if (model) {
                [resultArray addObject:model];
            }
        }
    }
    
    return resultArray;
}

-(NSMutableArray *)addChatToMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    //    [self downloadMessageAttachments:message];
    EaseMessageModel *model = [[EaseMessageModel alloc] initWithMessage:message];//[MessageModelManager modelWithMessage:message];
    if (model) {
        [ret addObject:model];
    }
    
    return ret;
}

-(void)addChatData:(NSNotification *)notify{
    //    WEAKSELF;
    EMMessage *messagre = notify.object;
    //    [[EMClient sharedClient].chatManager asyncSendMessage:messagre progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
    //        weakSelf.messageId = aMessage.messageId;
    //        if (!aError) {
    //            //            [weakself _refreshAfterSentMessage:aMessage];
    //        }
    //        else {
    //            //            [weakself.tableView reloadData];
    //        }
    //    }];
    [self addChatDataToMessage:messagre isSend:YES];
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

-(void)chatSaveChatPoint:(NSArray *)Messages uploadType:(NSInteger)uploadType isRecive:(BOOL)isRecie{
    //聊天埋点
    NSMutableArray *recordItemList = [[NSMutableArray alloc] init];
    for (EMMessage *aMessage in Messages) {
        EaseMessageModel *messageModel = [[EaseMessageModel alloc] initWithMessage:aMessage];
        ChatRecordItem *recordItem = [[ChatRecordItem alloc] init];
        recordItem.fromNickname = aMessage.ext[@"fromNickname"];
        recordItem.fromUserId = ((NSNumber *)aMessage.ext[@"fromUserId"]).integerValue;
        recordItem.toNickname = aMessage.ext[@"toNickname"];
        recordItem.toUserId = ((NSNumber *)aMessage.ext[@"toUserId"]).integerValue;
        recordItem.contentType = [recordItem getContentType:aMessage];
        if (aMessage.ext[@"goods"]) {
            NSDictionary *ext = [[NSDictionary alloc] init];
            if ([aMessage.ext[@"goods"] isKindOfClass:[NSDictionary class]]) {
                ext = aMessage.ext[@"goods"];
            } else {
                ext = [self dictionaryWithJsonString:aMessage.ext[@"goods"]];
            }
            
            if (ext) {
                recordItem.goodsInfo = [[ChatGoodsInfo alloc] init];
                recordItem.goodsInfo.goodsSn = [ext objectForKey:@"goods_id"];//ext[@"goods_id"];
                recordItem.goodsInfo.goodsName = [ext objectForKey:@"goods_name"];//ext[@"goods_name"];
                recordItem.goodsInfo.shopPrice = ((NSNumber *)[ext objectForKey:@"shop_price"]).integerValue;//ext[@"shop_price"]
                recordItem.goodsInfo.thumbUrl = [ext objectForKey:@"thumb_url"];//ext[@"thumb_url"];
            }
        }
        
        if (messageModel.bodyType == EMMessageBodyTypeVoice) {
            recordItem.bodyMsg = messageModel.fileURLPath;
        } else {
            recordItem.bodyMsg = messageModel.text;
        }
        
        if (isRecie) {
            recordItem.hxReceiveTime = aMessage.localTime;
        } else {
            recordItem.hxSendTime = aMessage.localTime;
        }
        
        if (isRecie) {
            recordItem.hxMsgId = aMessage.messageId;
        }
        
        if (aMessage.ext) {
            if (isRecie) {
                recordItem.msgId = aMessage.ext[@"msgId"];
            } else {
                recordItem.msgId = aMessage.ext[@"msgId"];
            }
        }
        [recordItemList addObject:recordItem];
    }
    
    
    NSDictionary *param = @{@"uploadType":@(uploadType), @"chatRecordItemList":recordItemList};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodPOST:@"chat" path:@"record_upload" parameters:[param toJSONDictionary] completionBlock:^(NSDictionary *data) {
        
        NSLog(@"埋点成功");
        
    } failure:^(XMError *error) {
        NSLog(@"埋点失败 %@", error.errorMsg);
    } queue:nil]];
    
}

-(void)addChatDataToMessage:(EMMessage *)message isSend:(BOOL)isSend
{
    
    WEAKSELF;
    dispatch_async(_messageQueue, ^{
        
        NSMutableDictionary *ext = [[NSMutableDictionary alloc] initWithDictionary:message.ext];
        NSTimeInterval interval = [[NSDate date] timeIntervalSince1970] * 1000;
        NSMutableString *fromUseId = [[NSMutableString alloc] init];
        if (fromUseId.length < 6) {
            for (int i = 0; i < 6-[NSString stringWithFormat:@"%ld", (unsigned long)[Session sharedInstance].currentUserId].length; i++) {
                [fromUseId appendFormat:@"0"];
            }
            [fromUseId appendFormat:@"%ld", (unsigned long)[Session sharedInstance].currentUserId];
        }
        NSString *uuid = [[NSUUID UUID] UUIDString];
        [ext setObject:uuid forKey:@"msgId"];
        message.ext = ext;
        if (isSend) {
            [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
                weakSelf.messageId = aMessage.messageId;
                message.status = aMessage.status;
                
                [weakSelf chatSaveChatPoint:@[message] uploadType:CHAT_SEND isRecive:NO];
                
                if (!aError) {
                    //                    message.status = EMMessageStatusSuccessed;
                }
                else {
                    //                    message.status = EMMessageStatusFailed;
                }
                
                [weakSelf.tableView reloadData];
            }];
        }
        
        NSArray *messages = [weakSelf addChatToMessage:message];
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < messages.count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:weakSelf.dataSource.count+i inSection:0];
            [indexPaths addObject:indexPath];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView beginUpdates];
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
            
            [weakSelf.tableView scrollToRowAtIndexPath:[indexPaths lastObject] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}

- (NSArray *)formatMessages:(NSArray *)messagesArray
{
    NSMutableArray *formatArray = [[NSMutableArray alloc] init];
    if ([messagesArray count] > 0) {
        for (EMMessage *message in messagesArray) {
            NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
            NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
            if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
                [formatArray addObject:[createDate formattedTime]];
                self.chatTagDate = createDate;
            }
            
            EaseMessageModel *model =[[EaseMessageModel alloc] initWithMessage:message];
            //            if ([_delelgate respondsToSelector:@selector(nickNameWithChatter:)]) {
            //                NSString *showName = [_delelgate nickNameWithChatter:model.username];
            //                model.nickName = showName?showName:model.username;
            //            }else {
            //                model.nickName = model.username;
            //            }
            //
            //            if ([_delelgate respondsToSelector:@selector(avatarWithChatter:)]) {
            //                model.headImageURL = [NSURL URLWithString:[_delelgate avatarWithChatter:model.username]];
            //            }
            
            if (model) {
                [formatArray addObject:model];
            }
        }
    }
    
    return formatArray;
}

-(NSMutableArray *)formatMessage:(EMMessage *)message
{
    NSMutableArray *ret = [[NSMutableArray alloc] init];
    NSDate *createDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)message.timestamp];
    NSTimeInterval tempDate = [createDate timeIntervalSinceDate:self.chatTagDate];
    if (tempDate > 60 || tempDate < -60 || (self.chatTagDate == nil)) {
        [ret addObject:[createDate formattedTime]];
        self.chatTagDate = createDate;
    }
    
    EaseMessageModel *model = [[EaseMessageModel alloc] initWithMessage:message];
    model.nickname = model.username;
    
    
    if (model) {
        [ret addObject:model];
    }
    
    return ret;
}

-(void)addMessage:(EMMessage *)message
{
    [_messages addObject:message];
    __weak ChatViewController *weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf formatMessage:message];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.dataSource addObjectsFromArray:messages];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        });
    });
}

- (void)scrollViewToBottom:(BOOL)animated
{
    if (self.tableView.contentSize.height > self.tableView.frame.size.height)
    {
        CGPoint offset = CGPointMake(0, self.tableView.contentSize.height - self.tableView.frame.size.height);
        if (self.tableView.contentOffset.y+self.tableView.contentSize.height!=self.tableView.frame.size.height) {
            [self.tableView setContentOffset:offset animated:animated];
        }
    }
}

- (void)removeAllMessages:(id)sender
{
    if (_dataSource.count == 0) {
        [self showHint:@"消息已经清空"];
        return;
    }
    
    if ([sender isKindOfClass:[NSNotification class]]) {
        NSString *groupId = (NSString *)[(NSNotification *)sender object];
        if (_isChatGroup && [groupId isEqualToString:_conversation.conversationId]) {
            [_conversation deleteAllMessages];
            [_messages removeAllObjects];
            [_dataSource removeAllObjects];
            [_tableView reloadData];
            [self showHint:@"消息已经清空"];
        }
    }
    else{
        __weak typeof(self) weakSelf = self;
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"请确认删除"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:
         ^(NSUInteger buttonIndex, WCAlertView *alertView) {
             if (buttonIndex == 1) {
                 [weakSelf.conversation deleteAllMessages];
                 [weakSelf.dataSource removeAllObjects];
                 [weakSelf.tableView reloadData];
             }
         } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath messageType:(EMMessageBodyType)messageType
{
    if (_menuController == nil) {
        _menuController = [UIMenuController sharedMenuController];
    }
    if (_copyMenuItem == nil) {
        _copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMenuAction:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMenuAction:)];
    }
    
    if (messageType == EMMessageBodyTypeText) {
        [_menuController setMenuItems:@[_copyMenuItem, _deleteMenuItem]];
    }
    else{
        [_menuController setMenuItems:@[_deleteMenuItem]];
    }
    
    [_menuController setTargetRect:showInView.frame inView:showInView.superview];
    [_menuController setMenuVisible:YES animated:YES];
}


- (void)applicationDidEnterBackground
{
    [_chatToolBar cancelTouchRecord];
    
    // 设置当前conversation的所有message为已读
    [_conversation markAllMessagesAsRead];
}

- (BOOL)shouldAckMessage:(EMMessage *)message read:(BOOL)read
{
    NSString *account = [EMClient sharedClient].currentUsername;//[[EaseMob sharedInstance].chatManager loginInfo][kSDKUsername];
    if (message.chatType != EMChatTypeChat || message.isReadAcked || [account isEqualToString:message.from] || ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) )
    {
        return NO;
    }
    
    EMMessageBody *body = message.body;
    if (((body.type == EMMessageBodyTypeVideo) ||
         (body.type == EMMessageBodyTypeVoice) ||
         (body.type == EMMessageBodyTypeImage)) &&
        !read)
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

- (BOOL)shouldMarkMessageAsRead
{
    if (([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) )
    {
        return NO;
    }
    
    return YES;
}

//- (EMMessageType)messageType
//{
//    EMMessageType type = eMessageTypeChat;
//    switch (_conversationType) {
//        case eConversationTypeChat:
//            type = eMessageTypeChat;
//            break;
//        case eConversationTypeGroupChat:
//            type = eMessageTypeGroupChat;
//            break;
//        case eConversationTypeChatRoom:
//            type = eMessageTypeChatRoom;
//            break;
//        default:
//            break;
//    }
//    return type;
//}


#pragma mark - load Messages
- (void)loadMoreMessagesFrom:(long long)timestamp count:(NSInteger)count append:(BOOL)append {
    [self loadMoreMessagesFrom:timestamp count:count append:append loadDone:nil];
}

- (void)loadMoreMessagesFrom:(long long)timestamp count:(NSInteger)count append:(BOOL)append loadDone:(void (^)())loadDone
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(_messageQueue, ^{
        NSArray *messages = [weakSelf.conversation loadMoreMessagesFromId:self.messageId limit:(int)count direction:EMMessageSearchDirectionUp];//[weakSelf.conversation loadNumbersOfMessages:count before:timestamp];
        if ([messages count] > 0) {
            NSInteger currentCount = 0;
            if (append)
            {
                [weakSelf.messages insertObjects:messages atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [messages count])]];
                NSArray *formated = [weakSelf formatMessages:messages];
                id model = [weakSelf.dataSource firstObject];
                if ([model isKindOfClass:[NSString class]])
                {
                    NSString *timestamp = model;
                    [formated enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id model, NSUInteger idx, BOOL *stop) {
                        if ([model isKindOfClass:[NSString class]] && [timestamp isEqualToString:model])
                        {
                            [weakSelf.dataSource removeObjectAtIndex:0];
                            *stop = YES;
                        }
                    }];
                }
                currentCount = [weakSelf.dataSource count];
                [weakSelf.dataSource insertObjects:formated atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, [formated count])]];
                EMMessage *latest = [weakSelf.messages lastObject];
                weakSelf.chatTagDate = [NSDate dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)latest.timestamp];
            }
            else
            {
                weakSelf.messages = [messages mutableCopy];
                if ([messages count]>0 && [weakSelf.goodsId length]>0) {
                    EMMessage*emMsg = [messages objectAtIndex:messages.count-1];
                    if ([emMsg isKindOfClass:[EMMessage class]] && emMsg.ext) {
                        NSDictionary *goodsDict = [emMsg.ext objectForKey:@"goods"];
                        if ([goodsDict isKindOfClass:[NSDictionary class]]
                            && [[goodsDict stringValueForKey:@"goods_id"] isEqualToString:weakSelf.goodsId])
                        {
                            weakSelf.goodsId = nil;
                        }
                    }
                }
                weakSelf.dataSource = [[weakSelf formatMessages:messages] mutableCopy];
                if (weakSelf.goodsInfo && ![weakSelf.dataSource containsObject:weakSelf.goodsInfo]) {
                    [weakSelf.dataSource addObject:weakSelf.goodsInfo];
                }
                
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
                [weakSelf.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[weakSelf.dataSource count] - currentCount - 1 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                
                if (loadDone) {
                    loadDone();
                }
            });
            
            //从数据库导入时重新下载没有下载成功的附件
            for (EMMessage *message in messages)
            {
                [weakSelf downloadMessageAttachments:message];
            }
            
            NSMutableArray *unreadMessages = [NSMutableArray array];
            for (NSInteger i = 0; i < [messages count]; i++)
            {
                EMMessage *message = messages[i];
                if ([self shouldAckMessage:message read:NO])
                {
                    [unreadMessages addObject:message];
                }
            }
            if ([unreadMessages count])
            {
                [self sendHasReadResponseForMessages:unreadMessages];
            }
        } else {
            if (loadDone) {
                loadDone();
            }
        }
    });
}

- (void)downloadMessageAttachments:(EMMessage *)message
{
    __weak typeof(self) weakSelf = self;
    void (^completion)(EMMessage *aMessage, EMError *error) = ^(EMMessage *aMessage, EMError *error) {
        if (!error)
        {
            [weakSelf reloadTableViewDataWithMessage:message];
        }
        else
        {
            [weakSelf showHint:NSLocalizedString(@"message.thumImageFail", @"thumbnail for failure!")];
        }
    };
    
    EMMessageBody *messageBody = message.body;
    if (messageBody.type == EMMessageBodyTypeImage) {
        EMImageMessageBody *imageBody = (EMImageMessageBody *)messageBody;
        if (imageBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed)
        {
            //下载缩略图
            //            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
            [[[EMClient sharedClient] chatManager] asyncDownloadMessageThumbnail:message progress:nil completion:completion];
        }
    }
    else if (messageBody.type == EMMessageBodyTypeVideo)
    {
        EMVideoMessageBody *videoBody = (EMVideoMessageBody *)messageBody;
        if (videoBody.thumbnailDownloadStatus > EMDownloadStatusSuccessed)
        {
            //下载缩略图
            //            [[[EaseMob sharedInstance] chatManager] asyncFetchMessageThumbnail:message progress:nil completion:completion onQueue:nil];
            [[[EMClient sharedClient] chatManager] asyncDownloadMessageThumbnail:message progress:nil completion:completion];
        }
    }
    else if (messageBody.type == EMMessageBodyTypeVoice)
    {
        EMVoiceMessageBody *voiceBody = (EMVoiceMessageBody*)messageBody;
        if (voiceBody.downloadStatus > EMDownloadStatusSuccessed)
        {
            //下载语言
            //            [[EaseMob sharedInstance].chatManager asyncFetchMessage:message progress:nil];
            [[EMClient sharedClient].chatManager asyncResendMessage:message progress:nil completion:completion];
        }
    }
}


#pragma mark - send message

-(void)sendTextMessage:(NSString *)textMessage
{
    EMMessage *tempMessage = [EaseSDKHelper sendTextMessage:textMessage to:_conversation.conversationId messageType:_isChatGroup messageExt:_extMessage];
    [self addChatDataToMessage:tempMessage isSend:YES];
    if (self.goodsId) {
        if (self.index == 1) {
            [ChatService chatNotice:_sellerId isAdd:YES];
            self.index = 0;
        }
    }
}

- (void)sendImageMessageWithOriginImage:(UIImage*)originalImage {
    if (originalImage!=nil) {
        UIImage *image = originalImage;
        CGSize originalSize = originalImage.size;
        if (originalSize.width == kADMChatMaxImageSize && originalSize.height== kADMChatMaxImageSize) {
            //... originalImage
        } else {
            if (originalSize.width == originalSize.height) {
                if (originalSize.width>kADMChatMaxImageSize) {
                    CGSize size = CGSizeMake(kADMChatMaxImageSize, kADMChatMaxImageSize);
                    UIImage *scaledImage = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                    image = scaledImage;
                } else {
                    //... originalImage
                }
            } else {
                if (originalSize.width < kADMChatMaxImageSize && originalSize.height<kADMChatMaxImageSize) {
                    //... originalImage
                } else {
                    CGSize size = CGSizeMake(kADMChatMaxImageSize, kADMChatMaxImageSize);
                    UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFit bounds:size interpolationQuality:kCGInterpolationDefault];
                    image = scaledImage;
                }
            }
        }
        
        NSData *dataObj = UIImageJPEGRepresentation(image,0.9);
        [self sendImageMessage:[UIImage imageWithData:dataObj]];
    }
}

-(void)sendImageMessage:(UIImage *)imageMessage
{
    WEAKSELF;
    EMMessage *tempMessage = [EaseSDKHelper sendImageMessageWithImage:imageMessage to:_conversation.conversationId messageType:_isChatGroup messageExt:_extMessage];
    [self addChatDataToMessage:tempMessage isSend:YES];
}

-(void)sendAudioMessage:(NSString *)voicePath andDuraion:(NSInteger)duraion
{
    
    EMVoiceMessageBody *body = [[EMVoiceMessageBody alloc] initWithLocalPath:voicePath displayName:@"audio"];
    body.duration = (int)duraion;
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_conversation.conversationId from:from to:_conversation.conversationId body:body ext:_extMessage];
    message.chatType = _isChatGroup;// 设置为单聊消息
    //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    [self addChatDataToMessage:message isSend:YES];
}
- (void)sendHasReadResponseForMessages:(NSArray*)messages
{
    dispatch_async(_messageQueue, ^{
        for (EMMessage *message in messages)
        {
            //            [[EaseMob sharedInstance].chatManager sendReadAckForMessage:message];
            [[EMClient sharedClient].chatManager asyncSendReadAckForMessage:message];
        }
    });
}

-(void)sendVideoMessage:(NSString *)videoPath
{
    //    EMMessage *tempMessage = [ChatSendHelper sendVideo:video toUsername:_conversation.chatter isChatGroup:_isChatGroup requireEncryption:NO ext:_extMessage];
    //    [self addChatDataToMessage:tempMessage];
    EMVideoMessageBody *body = [[EMVideoMessageBody alloc] initWithLocalPath:videoPath displayName:@"video.mp4"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    // 生成message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:_conversation.conversationId from:from to:_conversation.conversationId body:body ext:nil];
    message.chatType = _isChatGroup;// 设置为单聊消息
    //message.chatType = EMChatTypeGroupChat;// 设置为群聊消息
    //message.chatType = EMChatTypeChatRoom;// 设置为聊天室消息
    [self addChatDataToMessage:message isSend:YES];
}

#pragma mark - EMCDDeviceManagerDelegate
- (void)proximitySensorChanged:(BOOL)isCloseToUser{
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    if (isCloseToUser)
    {
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    } else {
        [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        if (!_isPlayingAudio) {
            [[EMCDDeviceManager sharedInstance] disableProximitySensor];
        }
    }
    [audioSession setActive:YES error:nil];
}
- (void)sendCommodityMessageWithImage:(UIImage *)image ext:(NSDictionary *)ext
{
    if(image){
        //        EMMessage *tempMessage = [ChatSendHelper sendImageMessageWithImage:image toUsername:_conversation.chatter isChatGroup:NO requireEncryption:NO ext:ext];
        EMMessage *tempMessage = [EaseSDKHelper sendImageMessageWithImage:image to:_conversation.conversationId messageType:NO messageExt:ext];
        [self addChatDataToMessage:tempMessage isSend:YES];
    }
}

@end

//CGRect frame = self.frame;
//[self.inputTextView resignFirstResponder];
//[CATransaction begin];
//[self.layer removeAllAnimations];
//[CATransaction commit];
//self.frame = frame;

