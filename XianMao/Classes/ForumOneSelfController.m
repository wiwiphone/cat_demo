//
//  ForumOneSelfController.m
//  XianMao
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 XianMao. All rights reserved.
//


//
//  ForumPostListViewController.m
//  XianMao
//
//  Created by simon cai on 26/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ForumOneSelfController.h"
#import "ForumPostDetailViewController.h"
#import "ForumPublishViewController.h"
#import "ForumCatHouseDetailController.h"
#import "UserHomeViewController.h"
#import "ForumPostListViewController.h"

#import "Command.h"
#import "ForumInputToolBar.h"
#import "ForumService.h"

#import "ForumPostTableViewCell.h"
#import "PullRefreshTableView.h"
#import "DataListLogic.h"

#import "Error.h"
#import "JSONKit.h"
#import "NetworkAPI.h"

#import "NSString+URLEncoding.h"
#import "WCAlertView.h"

#import "NSString+Addtions.h"

#import "Session.h"
#import "SearchViewController.h"
#import "RecommendGoodsInfo.h"

#import "UIView+FirstResponder.h"

#import "ForumAttachView.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "DigitalKeyboardView.h"
#import "URLScheme.h"


@interface ForumOneSelfController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,ForumInputToolBarDelegate,DXChatBarMoreViewDelegate,UIGestureRecognizerDelegate,SearchViewControllerDelegate>

@property(nonatomic,weak) PullRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;

@property(nonatomic,weak) ForumInputToolBar *toolBar;
@property(nonatomic,strong) ForumTopicFilterVO *selectedFilterVO;

@property(nonatomic,strong) ForumPostVO *replyToPostVO;
@property(nonatomic,assign) NSInteger reply_user_id;
@property(nonatomic,weak) ForumAttachContainerView *attachContainerView;
@property (nonatomic, strong) NSMutableArray *topicArray;

@end

@implementation ForumOneSelfController

- (void)dealloc{
    [ForumPostReplyTableCell replyCleanup];
    [ForumPostTableViewCell forumCleanup];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    
//    
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarBackButton];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    
    CommandButton *cammerButton = [[CommandButton alloc] initWithFrame:CGRectMake(self.topBar.width-15-47, 15, 80, 50)];
    cammerButton.imageEdgeInsets = UIEdgeInsetsMake(14, 24, 14, 34);
    //    cammerButton.backgroundColor = [UIColor lightGrayColor];
    [cammerButton setImage:[UIImage imageNamed:@"mine-Cat"] forState:UIControlStateNormal];
    [cammerButton addTarget:self action:@selector(clickMineButton) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:cammerButton];
    
    [ForumService getTopicTopData:^(NSMutableArray *topic) {
        self.topicArray = [NSMutableArray arrayWithArray:topic];
    } failure:^(XMError *error) {
        
    }];

//    NSLog(@"%ld", self.user_id);
//    if ([Session sharedInstance].currentUserId == self.user_id) {
//        [self setupTopBarTitle:@"我的喵窝"];
//    } else {
//        [self setupTopBarTitle:[NSString stringWithFormat:@"%@的喵窝", self.postVO.username]];
//    }

    
//    self.topic_id = 1;
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    [self.view addSubview:scrollView];
    scrollView.scrollEnabled = NO;
    
    self.dataSources = [NSMutableArray arrayWithCapacity:60];
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height) style:UITableViewStylePlain];
    [scrollView addSubview:tableView];
    self.tableView = tableView;
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    
    ForumInputToolBar *toolBar = [[ForumInputToolBar alloc] initWithFrame:CGRectMake(0, scrollView.height-[ForumInputToolBar defaultHeight], scrollView.width, [ForumInputToolBar defaultHeight]) withInputTextView:nil];
    _toolBar = toolBar;
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    _toolBar.delegate = self;
    _toolBar.hiddenWhenNoEditing = YES;
    if ([_toolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        DXChatBarMoreView *moreView = (DXChatBarMoreView*)(_toolBar.moreView);
        moreView.delegate = self;
    }
    _toolBar.inputTextView.placeHolder = @"回复";
    _toolBar.hiddenWhenNoEditing = YES;
    _toolBar.hidden = YES;
    [scrollView addSubview:toolBar];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.toolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.toolBar.moreView setDelegate:self];
    }
    
    [self bringTopBarToTop];
    
    ForumAttachContainerView *attachContainerView = [[ForumAttachContainerView alloc] initWithFrame:CGRectMake(0, -40, kScreenWidth, 40)];
    [self.toolBar addSubview:attachContainerView];
    attachContainerView.hidden = YES;
    _attachContainerView = attachContainerView;
    _toolBar.attachContainerView = attachContainerView;
    
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapAnywhereToDismissKeyboard:)];
    singleTapGR.delegate = self;
    [self.view addGestureRecognizer:singleTapGR];
    
    [self showLoadingView];
    [self loadData];
    
    
    
}

-(void)clickMineButton{
    UserHomeViewController *userHome = [[UserHomeViewController alloc] init];
    userHome.userId = self.user_id;
    [self pushViewController:userHome animated:YES];
}



//-(void)setSubsData:(NSNotification *)notify{
//    NSMutableArray *postVOArr = notify.object;
//    self.listArr = [NSMutableArray arrayWithArray:postVOArr];
////    self.postVO = dict[@"postVO"];
//    NSLog(@"%@", notify.userInfo[@"postVO"]);
//    ForumPostVO *postVO = notify.userInfo[@"postVO"];
//    self.postVO = postVO;
////    [self.tableView reloadData];
//}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    CGRect rect = [self.view convertRect:self.attachContainerView.bounds fromView:self.attachContainerView];
    if (CGRectContainsPoint(rect, point) && ![self.attachContainerView isHidden]) {
        return NO;
    }
    if ([self.view findFirstResponder] || [self.toolBar isInEditing] || ![self.attachContainerView isHidden]) {
        if (![[gestureRecognizer.view superview] isKindOfClass:[ForumAttachmentView class]])
            return YES;
    }
    
    return NO;
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    [self.toolBar endEditing:YES];
}

- (void)setNavTitleBar:(NSString *)title {
    
    
}

- (void)showNavPopupMenu:(NSArray*)filterList {
    WEAKSELF;
    [CoordinatingController showMaskView:^{
        [weakSelf hideNavPopupMenu];
    }];
    if ((self.topicVO.filterList.count-(self.selectedFilterVO?1:0))>0) {
        ForumOneSelfPopupView *popupView = (ForumOneSelfPopupView*)[self.view viewWithTag:2000];
        if (!popupView) {
            popupView = [[ForumOneSelfPopupView alloc] initWithFrame:CGRectZero];
            popupView.tag = 2000;
            [self.view addSubview:popupView];
            
            UIImage *bgImage = [UIImage imageNamed:@"forum_popup_menu_bg"];
            [popupView setImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2]];
            popupView.handleFilterSelectedBlock = ^(ForumOneSelfPopupView *view,ForumTopicFilterVO *filterVO) {
                weakSelf.selectedFilterVO = filterVO;
                [weakSelf setNavTitleBar:filterVO.display];
                [weakSelf hideNavPopupMenu];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf initDataListLogic];
                });
            };
        }
        
        popupView.hidden = NO;
        popupView.frame = CGRectMake((self.view.width-134)/2, super.topBarHeight-10, 140, (self.topicVO.filterList.count-(self.selectedFilterVO?1:0))*45+10);
        [popupView updateWithFilterList:filterList selectedFilterVO:self.selectedFilterVO];
        
        [self.view bringSubviewToFront:popupView];
    }
    
    CommandButton *sender = (CommandButton*)[super.topBar viewWithTag:1000];
    sender.selected = YES;
    CGSize size = [[sender titleForState:UIControlStateNormal] sizeWithFont: sender.titleLabel.font];
    UIImageView *arrowView = (UIImageView*)[weakSelf.topBar viewWithTag:1001];
    arrowView.frame = CGRectMake(weakSelf.topBar.width/2+size.width/2, kTopBarContentMarginTop+(sender.height-arrowView.height)/2, arrowView.width, arrowView.height);
    [arrowView setImage:sender.isSelected?[UIImage imageNamed:@"forum_nav_arrow_up"]:[UIImage imageNamed:@"forum_nav_arrow_down"]];
}

- (void)hideNavPopupMenu {
    [CoordinatingController dismissMaskView];
    
    ForumOneSelfPopupView *popupView = (ForumOneSelfPopupView*)[self.view viewWithTag:2000];
    popupView.hidden = YES;
    
    WEAKSELF;
    CommandButton *sender = (CommandButton*)[super.topBar viewWithTag:1000];
    sender.selected = NO;
    CGSize size = [[sender titleForState:UIControlStateNormal] sizeWithFont: sender.titleLabel.font];
    UIImageView *arrowView = (UIImageView*)[weakSelf.topBar viewWithTag:1001];
    arrowView.frame = CGRectMake(weakSelf.topBar.width/2+size.width/2, kTopBarContentMarginTop+(sender.height-arrowView.height)/2, arrowView.width, arrowView.height);
    [arrowView setImage:sender.isSelected?[UIImage imageNamed:@"forum_nav_arrow_up"]:[UIImage imageNamed:@"forum_nav_arrow_down"]];
}

- (void)loadData {
    WEAKSELF;
    
    if (weakSelf.dataListLogic) {
        [weakSelf.dataListLogic reloadDataListByForce];
    } else {
        [weakSelf initDataListLogic];
    }
    
//    if ([weakSelf.dataSources count]>0) {
//        weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
//    }
    
//    [ForumService getTopic:self.topic_id completion:^(ForumTopicVO *topic) {
//        [weakSelf hideLoadingView];
//        
//        weakSelf.topicVO = topic;
//        if (!weakSelf.selectedFilterVO) {
//            if ([topic.filterList count]>0) {
//                ForumTopicFilterVO *selectedFilterVO = (ForumTopicFilterVO*)[topic.filterList objectAtIndex:0];
//                weakSelf.selectedFilterVO = selectedFilterVO;
//                [weakSelf setNavTitleBar:selectedFilterVO.display];
//            }
//        }
//        
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (weakSelf.dataListLogic) {
//                [weakSelf.dataListLogic reloadDataListByForce];
//            } else {
//                [weakSelf initDataListLogic];
//            }
//        });
//    } failure:^(XMError *error) {
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
//            [weakSelf loadData];
//        };
//    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    [self.toolBar endEditing:YES];
    
    if ([self.topicVO.subscribe_url length]>0) {
        if ([self.view viewWithTag:3000]) {
            [self hidePublishPopupMenu];
        } else {
            [self showPublishPopupMenu];
        }
    } else {
//        [self publishPostImpl];
    }
}

- (void)showPublishPopupMenu {
    WEAKSELF;
    [CoordinatingController showMaskView:^{
        [weakSelf hidePublishPopupMenu];
    }];
    UIImageView *popupMenu = (UIImageView*)[self.view viewWithTag:3000];
    if (!popupMenu) {
        popupMenu = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 119, 99)];
        popupMenu.tag = 3000;
        popupMenu.userInteractionEnabled = YES;
        [self.view addSubview:popupMenu];
        
        UIImage *bgImage = [UIImage imageNamed:@"forum_popup_menu_bg"];
        [popupMenu setImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2]];
        
        CommandButton *publishBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 9, popupMenu.width, (popupMenu.height-9)/2)];
        [publishBtn setTitle:self.topicVO.publish_title forState:UIControlStateNormal];
        [publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        publishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [popupMenu addSubview:publishBtn];
        
        CommandButton *subscribeBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 9+publishBtn.height, popupMenu.width, (popupMenu.height-9)/2)];
        [subscribeBtn setTitle:@"订阅关键字" forState:UIControlStateNormal];
        [subscribeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        subscribeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [popupMenu addSubview:subscribeBtn];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor blackColor].CGColor;
        line.frame = CGRectMake(0, 9+(popupMenu.height-9)/2, popupMenu.width-15, 0.5);
        [popupMenu.layer addSublayer:line];
        
//        publishBtn.handleClickBlock = ^(CommandButton *sender) {
//            [weakSelf hidePublishPopupMenu];
//            [weakSelf publishPostImpl];
//        };
        subscribeBtn.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf hidePublishPopupMenu];
            [URLScheme locateWithRedirectUri:self.topicVO.subscribe_url andIsShare:NO];
        };
    }
    
    popupMenu.hidden = NO;
    popupMenu.frame = CGRectMake(self.view.width-3-popupMenu.width, super.topBarHeight-10, popupMenu.width, popupMenu.height);
    [self.view bringSubviewToFront:popupMenu];
}

- (void)hidePublishPopupMenu {
    [CoordinatingController dismissMaskView];
    UIImageView *popupMenu = (UIImageView*)[self.view viewWithTag:3000];
    [popupMenu removeFromSuperview];
}

//- (void)publishPostImpl {
//    ForumPublishViewController *viewController = [[ForumPublishViewController alloc] init];
////    viewController.title = @"求购"; //self.topicVO.publish_title;
//    //viewController.topic_id = 1; //self.topicVO.topic_id;
//    
////    NSLog(@"%@", self.topicArray);
//    
////    viewController.topic_array = self.topicArray;
//    [self pushViewController:viewController animated:YES];
//    WEAKSELF;
//    viewController.handlePublishedBlock = ^(ForumPostVO *postVO) {
////        self.postVO = postVO;5
//        [weakSelf showHUD:@"发布成功" hideAfterDelay:0.8f];
//        NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
//        if ([dataSources count]>=2 && [weakSelf.topicVO.head_text length]>0) {
//            [dataSources insertObject:[ForumPostTableSepCell buildCellDict] atIndex:2];
//            [dataSources insertObject:[ForumOneSelfTableViewCell buildCellDict:postVO forumTopicVO:weakSelf.topicVO] atIndex:2];
//        } else {
//            [dataSources insertObject:[ForumPostTableSepCell buildCellDict] atIndex:1];
//            [dataSources insertObject:[ForumOneSelfTableViewCell buildCellDict:postVO forumTopicVO:weakSelf.topicVO] atIndex:1];
////            [dataSources insertObject:[ForumPostSearchTableCell buildCellDict] atIndex:0];
//        }
//        weakSelf.dataSources = dataSources;
//        [weakSelf.tableView reloadData];
//        [weakSelf hideLoadingView];
//    };
//}


- (void)initDataListLogic
{
    WEAKSELF;
    
    if (self.tagYes) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 100, 0, 200, self.topBarHeight)];
        view.backgroundColor = [UIColor whiteColor];
        [self.topBar addSubview:view];
        
        self.topBarRightButton.hidden = YES;
        [self setupTopBarTitle:self.tag];
        NSString *tagP = [[self.tag JSONString] URLEncodedString];
        _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"forum" path:@"post_list_by_label" pageSize:20];
        _dataListLogic.parameters = @{@"label":tagP};
        _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    } else {
        
        _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"forum" path:@"forum_home" pageSize:20];
        _dataListLogic.parameters = @{@"user_id":[NSNumber numberWithInteger:self.user_id]};
        _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    }
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
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:addedItems.count];
        
        if ([Session sharedInstance].currentUserId==weakSelf.user_id) {
            [newList addObject:[ForumOneSelfTodayCell buildCellDict]];
            [newList addObject:[ForumPostTableSepCell buildCellDict]];
        }
        
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                ForumPostVO *postVO = [[ForumPostVO alloc] initWithJSONDictionary:dict];
                if ([postVO.content length]>0 || [postVO.attachments count]>0) {
                    if ([Session sharedInstance].currentUserId == self.user_id) {
                        [weakSelf setupTopBarTitle:@"我的喵窝"];
                    } else {
                        [weakSelf setupTopBarTitle:[NSString stringWithFormat:@"%@的喵窝", postVO.username]];
                    }
                    [newList addObject:[ForumOneSelfTableViewCell buildCellDict:postVO forumTopicVO:weakSelf.topicVO]];
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
        if ([dataSources count]==0) {
            if ([weakSelf.topicVO.head_text length]>0) {
                [dataSources addObject:[ForumTopicDescTableViewCell buildCellDict:weakSelf.topicVO.head_text]];
            }
            
            [dataSources addObject:[ForumOneSelfTodayCell buildCellDict]];
            [dataSources addObject:[ForumPostTableSepCell buildCellDict]];
            
        }
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            
            ForumPostVO *postVO = [[ForumPostVO alloc] initWithJSONDictionary:dict];
            if ([postVO.content length]>0 || [postVO.attachments count]>0) {
                [dataSources addObject:[ForumOneSelfTableViewCell buildCellDict:postVO forumTopicVO:weakSelf.topicVO]];
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
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        
        [weakSelf hideLoadingView];
        
        NSMutableArray *dataSources = [[NSMutableArray alloc] init];
        if ([weakSelf.topicVO.head_text length]>0) {
            [dataSources addObject:[ForumTopicDescTableViewCell buildCellDict:weakSelf.topicVO.head_text]];
        }
        [dataSources addObject:[ForumPostSearchTableCell buildCellDict]];
        
        CGFloat cellHeight = weakSelf.tableView.height-[ForumPostSearchTableCell rowHeightForPortrait];
        [dataSources addObject:[ForumPostListNoContentTableCell buildCellDict:cellHeight]];
        weakSelf.dataSources = dataSources;
        [weakSelf.tableView reloadData];
        
        [weakSelf setNavTitleBar:weakSelf.selectedFilterVO.display];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    if ([weakSelf.dataSources count]==0) {
        [weakSelf showLoadingView].backgroundColor = [UIColor clearColor];
    }
    [_dataListLogic firstLoadFromCache];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.view findFirstResponder] || [self.toolBar isInEditing] || ![self.attachContainerView isHidden]) {
        [self.toolBar endEditing:YES];
        [self.view endEditing:YES];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissMoreOprationViewForumPost" object:nil];
    });
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [self loadData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [_dataListLogic nextPage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    NSLog(@"%ld, %ld", self.listArr.count, self.dataSources.count);
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
    
    if ([tableViewCell isKindOfClass:[ForumOneSelfTableViewCell class]]) {
        WEAKSELF;
        ForumOneSelfTableViewCell *postTableViewCell = (ForumOneSelfTableViewCell*)tableViewCell;
        [postTableViewCell updateCellWithDict:dict forumTopicVO:weakSelf.topicVO];
        
        postTableViewCell.handleDelPostBlock = ^(ForumPostVO *postVO) {
            
            [WCAlertView showAlertWithTitle:@"" message:@"确认删除?" customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex==0) {
                    
                } else {
                    [weakSelf showProcessingHUD:nil];
                    [ForumService delete_post:postVO.post_id completion:^(NSInteger post_id){
                        [weakSelf showHUD:@"删除成功" hideAfterDelay:0.8f];
                        
                        SEL selector = @selector($$handleDeletePostDidFinishNotification:postId:);
                        MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:post_id]);
//                        [weakSelf loadData];
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        };
        postTableViewCell.handleFinishPostBlock = ^(ForumPostVO *postVO) {
            
            NSString *alertText = @"已达成所愿?";
            
            [WCAlertView showAlertWithTitle:@"" message:alertText customizationBlock:^(WCAlertView *alertView) {
                alertView.style = WCAlertViewStyleWhite;
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex==0) {
                    
                } else {
                    [weakSelf showProcessingHUD:nil];
                    [ForumService complete_post:postVO.post_id completion:^(ForumPostVO *postVO){
                        [weakSelf hideHUD];
                        
                        SEL selector = @selector($$handleCompletePostDidFinishNotification:postVO:);
                        MBGlobalSendNotificationForSELWithBody(selector, postVO);
                        
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        };
        postTableViewCell.handleReplyBlock = ^(ForumPostVO *postVO) {
            weakSelf.reply_user_id = 0;
            weakSelf.replyToPostVO = postVO;
            weakSelf.toolBar.inputTextView.placeHolder = @"回复";
            [weakSelf.toolBar beginEditing];
        };
        postTableViewCell.handleReplyToBlock = ^(ForumPostVO *postVO, ForumPostReplyVO *replyVO) {
            if (![postVO isFinshed]) {
                weakSelf.replyToPostVO = postVO;
                if ([Session sharedInstance].currentUserId==replyVO.user_id) {
                    weakSelf.reply_user_id = 0;
                    weakSelf.toolBar.inputTextView.placeHolder = @"回复";
                } else {
                    weakSelf.reply_user_id = replyVO.user_id;
                    weakSelf.toolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复%@",replyVO.username];
                }
                [weakSelf.toolBar  beginEditing];
            } else {
                weakSelf.replyToPostVO = nil;
            }
        };
        postTableViewCell.handleAllRepliesBlock = ^(ForumPostVO *postVO) {
            ForumPostDetailViewController *viewController = [[ForumPostDetailViewController alloc] init];
            viewController.postVO = postVO;
            viewController.topicVO = weakSelf.topicVO;
            [weakSelf pushViewController:viewController animated:YES];
        };
        
        postTableViewCell.handleDeleteReplyBlock = ^(ForumPostVO *postVO, ForumPostReplyVO *replyVO) {
            
            [weakSelf showProcessingHUD:nil];
            [ForumService delete_reply:replyVO.reply_id completion:^{
                [weakSelf hideHUD];
                SEL selector = @selector($$handleDeleteReplyFinishNotification:replyId:);
                MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:replyVO.reply_id]);
                
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
        
        postTableViewCell.handlePostPicsTapBlock = ^(ForumPostVO *postVO, NSInteger index, UIImageView *srcImageView, NSArray *imageViewArray) {
            
            [weakSelf.toolBar endEditing:YES];
            [weakSelf.view endEditing:YES];
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:postVO.attachments.count];
            for (ForumAttachmentVO *attchmentVO in postVO.attachments) {
                if (attchmentVO.type == ForumAttachTypePics) {
                    [array addObject:attchmentVO];
                }
            }
            if ([array count]>0) {
                
                [weakSelf setNavTitleBar:weakSelf.selectedFilterVO.display];
                [weakSelf hideNavPopupMenu];
                
                // 1.封装图片数据
                NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[array count]];
                for (NSInteger i=0;i< [array count];i++) {
                    ForumAttachmentVO *attachVO = [array objectAtIndex:i];
                    
                    MJPhoto *photo = [[MJPhoto alloc] init];
                    NSString *QNDownloadUrl = ((ForumAttachItemPicsVO*)(attachVO.item)).pic_url;
                    //                    QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:((ForumAttachItemPicsVO*)(attachVO.item)).pic_url isWebP:NO scaleType:XMWebImageScale750x750];
                    
                    photo.url = [NSURL URLWithString:QNDownloadUrl]; // 图片路径
                    if (i<imageViewArray.count) {
                        photo.srcImageView = [imageViewArray objectAtIndex:i];
                    } else {
                        photo.srcImageView = srcImageView; // 来源于哪个UIImageView
                    }
                    [photos addObject:photo];
                }
                
                if ([photos count]>0) {
                    // 2.显示相册
                    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
                    browser.currentPhotoIndex = index; // 弹出相册时显示的第一张图片是？
                    browser.photos = photos; // 设置所有的图片
                    //                    browser.delegate = self;
                    [browser show];
                }
            }
        };
        
        postTableViewCell.handleQuoteBlock = ^(ForumPostVO *postVO) {
            ForumQuoteInputView *inputView = [[ForumQuoteInputView alloc] initWithFrame:CGRectZero];
            [DigitalKeyboardView showInView:self.view inputContainerView:inputView textFieldArray:[NSArray arrayWithObjects:inputView.textFiled, nil] completion:^(DigitalInputContainerView *inputContainerView) {
                NSInteger priceCent = [((ForumQuoteInputView*)inputContainerView) priceCent];
                if (priceCent >0) {
                    [weakSelf showProcessingHUD:nil];
                    [ForumService quote:postVO.post_id priceCent:priceCent completion:^(NSInteger quote_num){
                        [weakSelf showHUD:@"报价成功" hideAfterDelay:1.f];
                        postVO.quote_num = quote_num;
//                        [weakSelf.tableView reloadData];
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.f];
                    }];
                }
            }];
        };
        
//        postTableViewCell.handleIconBlock = ^(ForumPostVO *postVO) {
//            
//            
////            self.postVO = postVO;
//            
//            ForumOneSelfController *selfController = [[ForumOneSelfController alloc] init];
//            selfController.user_id = postVO.user_id;
//            [weakSelf pushViewController:selfController animated:YES];
//            
//            //            [ForumService getHomePost:postVO.user_id completion:^(NSMutableArray *home) {
//            //
//            ////                self.listArr = [NSMutableArray arrayWithArray:home];
//            ////                NSLog(@"%@", self.listArr);
//            //
//            //                NSDictionary *dict = @{@"postVO" : postVO};
//            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"setData" object:home userInfo:dict];
//            //
//            ////                [[NSNotificationCenter defaultCenter] postNotificationName:@"setData" object:home];
//            //
//            //                [weakSelf.tableView reloadData];
//            //            } failure:^(XMError *error) {
//            //
//            //            }];
//            //
//            //            [weakSelf pushViewController:oneSelf animated:YES];
//            //
//            //
//            
//            
//            
//        };
        
        postTableViewCell.handleLikeBlock = ^(ForumPostVO *postVO, NSInteger like) {
            
            BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
                
            }];
            if (!isLoggedIn) {
                return;
            }
            
            [ForumService post:postVO.post_id like:like completion:^(ForumTopicIsLike *likeArr) {
                NSLog(@"%@", likeArr);
                
                [weakSelf.tableView reloadData];
            } failure:^(XMError *error) {
                
            }];
        };
        
        
        postTableViewCell.handleTagBlock = ^(NSString *tagText){
            ForumPostListViewController *tagController = [[ForumPostListViewController alloc] init];
            tagController.tagYes =YES;
            tagController.tag = tagText;
            
            //            [ForumService getPostTagData:tagText completion:^(NSMutableArray *topic) {
            //                NSLog(@"%@", topic);
            //            } failure:^(XMError *error) {
            //
            //            }];
            
            [self pushViewController:tagController animated:YES];
        };
        
        postTableViewCell.handleTagNameBtnBlock = ^(NSInteger topic_id) {
            ForumPostListViewController *postList = [[ForumPostListViewController alloc] init];
            postList.topic_id = topic_id;
            [self pushViewController:postList animated:YES];
        };
        
        postTableViewCell.handlePayBlock = ^(ForumPostVO *postVO, NSInteger fans){
            
            BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
                
            }];
            if (!isLoggedIn) {
                return;
            }
            
            if (postVO.is_following) {
                [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] followUser:postVO.user_id isFollow:postVO.is_following completion:^(NSInteger totalNum) {
                    
                    [weakSelf showHUD:@"关注成功" hideAfterDelay:0.8f];
                    
                    for (NSDictionary *dict in self.dataSources) {
                        ForumPostVO *postNewVO = dict[@"postVO"];
                        if (postNewVO.user_id == postVO.user_id) {
                            postNewVO.is_following = 1;
                        }
                    }
                    
                    [weakSelf.tableView reloadData];
                    
                } failure:^(XMError *error) {
                    
                }]];
                
            } else {
                [WCAlertView showAlertWithTitle:@"" message:@"确认取消关注?" customizationBlock:^(WCAlertView *alertView) {
                    alertView.style = WCAlertViewStyleWhite;
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    if (buttonIndex==0) {
                        for (NSDictionary *dict in self.dataSources) {
                            ForumPostVO *postNewVO = dict[@"postVO"];
                            if (postNewVO.user_id == postVO.user_id) {
                                postNewVO.is_following = 1;
                            }
                        }
                        return ;
                    } else {
                        [weakSelf showProcessingHUD:nil];
                        [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] followUsers:postVO.user_id isFollow:postVO.is_following completion:^(User *user) {
                            [weakSelf showHUD:@"已取消关注" hideAfterDelay:0.8f];
                            
                            for (NSDictionary *dict in self.dataSources) {
                                ForumPostVO *postNewVO = dict[@"postVO"];
                                if (postNewVO.user_id == postVO.user_id) {
                                    postNewVO.is_following = 0;
                                }
                            }
                            
                            [weakSelf.tableView reloadData];
                        } failure:^(XMError *error) {
                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                        }]];
                        
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                
                //
                
            };
            
        };
        
        postTableViewCell.handleShareBlock = ^(ForumPostVO *postVO){
            NSString *shareStr = [NSString stringWithFormat:@"http://activity.aidingmao.com/forum/share/detail/%ld", postVO.post_id];
            
            //分享测试
            [[CoordinatingController sharedInstance] shareWithTitle:@"喵窝分享"
                                                              image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:postVO.avatar]]] //[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:postVO.attachments[0][@"pic_url"]]]]
                                                                url:shareStr
                                                            content:postVO.content];
        };
        
        
//        NSLog(@"%@", self.listArr);
//        ForumPostList *postList = weakSelf.listArr[indexPath.row];
//        weakSelf.postList = postList;
//        [postTableViewCell setSubsDataWithList:postList];
        
    }
        
//        searchTableCell.handlePostDoSearch = ^(NSString *keywords) {
//            if (![weakSelf.keywords isEqualToString:keywords]) {
//                weakSelf.keywords = keywords;
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf initDataListLogic];
//                });
//            }
//        };
//        searchTableCell.handlePostCancelSearch = ^() {
//            if ([weakSelf.keywords length]>0) {
//                weakSelf.keywords = @"";
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf initDataListLogic];
//                });
//            }
//        };
//        [tableViewCell updateCellWithDict:dict];
//    }
    else {
        [tableViewCell updateCellWithDict:dict];
    }
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL handled = NO;
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[ForumPostTableViewCell cellKeyForPostVO]];
    if ([postVO isKindOfClass:[ForumPostVO class]]) {
        ForumCatHouseDetailController *viewController = [[ForumCatHouseDetailController alloc] init];
//        viewController.postVO = postVO;
//        viewController.topicVO = self.topicVO;
        viewController.post_id = postVO.post_id;
        [self pushViewController:viewController animated:YES];
        handled = YES;
    }
    if (handled) {
        [self.view endEditing:YES];
        [self.toolBar endEditing:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)$$handleQuoteFinishNotification:(id<MBNotification>)notifi {
    [self.tableView reloadData];
}


- (void)$$handleDeleteReplyFinishNotification:(id<MBNotification>)notifi replyId:(NSNumber*)replyId
{
    WEAKSELF;
    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
        NSDictionary *dict = (NSDictionary*)[weakSelf.dataSources objectAtIndex:i];
        Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        if (ClsTableViewCell == [ForumOneSelfTableViewCell class]) {
            ForumPostVO *postVOTmp = (ForumPostVO*)[dict objectForKey:[ForumPostTableViewCell cellKeyForPostVO]];
            if ([postVOTmp isKindOfClass:[ForumPostVO class]]) {
                
                for (NSInteger j=0;j<[postVOTmp.topReplies count];j++) {
                    ForumPostReplyVO *replyVO = [postVOTmp.topReplies objectAtIndex:j];
                    if (replyVO.reply_id == [replyId integerValue]) {
                        [postVOTmp.topReplies removeObjectAtIndex:j];
                        postVOTmp.reply_num -= 1;
                        if (postVOTmp.reply_num<=0) {
                            postVOTmp.reply_num = 0;
                        }
                        break;
                    }
                }
            }
        }
    }
    [weakSelf.tableView reloadData];
}

- (void)$$handleReplyDidFinishNotification:(id<MBNotification>)notifi replyVO:(ForumPostReplyVO*)replyVO {
    WEAKSELF;
    [weakSelf.tableView reloadData];
}

- (void)$$handleDeletePostDidFinishNotification:(id<MBNotification>)notifi postId:(NSNumber*)postId {
    WEAKSELF;
    NSInteger post_id = [postId integerValue];
    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
        NSDictionary *dict = (NSDictionary*)[weakSelf.dataSources objectAtIndex:i];
        Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        if (ClsTableViewCell == [ForumOneSelfTableViewCell class]) {
            ForumPostVO *postVOTmp = (ForumPostVO*)[dict objectForKey:[ForumPostTableViewCell cellKeyForPostVO]];
            if ([postVOTmp isKindOfClass:[ForumPostVO class]]) {
                if (postVOTmp.post_id == post_id) {
                    if (i+1<[weakSelf.dataSources count]) {
                        NSDictionary *dictSep = (NSDictionary*)[weakSelf.dataSources objectAtIndex:i+1];
                        if (NSClassFromString([dictSep stringValueForKey:[BaseTableViewCell dictKeyOfClsName]])==[ForumPostTableSepCell class]) {
                            [weakSelf.dataSources removeObjectAtIndex:i+1];
                        }
                    }
                    [weakSelf.dataSources removeObjectAtIndex:i];
                    break;
                }
            }
        }
    }
    [weakSelf.tableView reloadData];
}

- (void)$$handleCompletePostDidFinishNotification:(id<MBNotification>)notifi postVO:(ForumPostVO*)postVO {
    WEAKSELF;
    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
        NSMutableDictionary *dict = (NSMutableDictionary*)[weakSelf.dataSources objectAtIndex:i];
        Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        if (ClsTableViewCell == [ForumOneSelfTableViewCell class]) {
            ForumPostVO *postVOTmp = (ForumPostVO*)[dict objectForKey:[ForumPostTableViewCell cellKeyForPostVO]];
            if ([postVOTmp isKindOfClass:[ForumPostVO class]]) {
                if (postVOTmp.post_id == postVO.post_id) {
                    [dict setObject:postVO forKey:[ForumPostTableViewCell cellKeyForPostVO]];
                    break;
                }
            }
        }
    }
    [weakSelf.tableView reloadData];
}

#pragma mark - DXMessageToolBarDelegate
- (void)inputTextViewWillBeginEditing:(XHMessageTextView *)messageInputTextView{
    
}

- (void)didChangeFrameToHeight:(CGFloat)toHeight
{
    
}

- (void)didSendFaceWithText:(NSString *)text
{
    WEAKSELF;
    if ([weakSelf.toolBar.inputTextView isFirstResponder]) {
        [weakSelf.view endEditing:YES];
        [weakSelf.toolBar endEditing:YES];
    }
    
    NSString *content = [self.toolBar.inputTextView.text trim];
    if (([content length]>0|| [weakSelf.attachContainerView.attachments count]>0) && weakSelf.replyToPostVO) {
        [weakSelf showProcessingHUD:nil];
        [ForumService reply_post:weakSelf.replyToPostVO.post_id reply_user_id:weakSelf.reply_user_id content:content attachments:weakSelf.attachContainerView.attachments completion:^(ForumPostReplyVO *replyVO) {
            [weakSelf showHUD:@"回复成功" hideAfterDelay:0.8f];
            
            for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
                NSMutableDictionary *dict = (NSMutableDictionary*)[weakSelf.dataSources objectAtIndex:i];
                Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
                if (ClsTableViewCell == [ForumOneSelfTableViewCell class]) {
                    ForumPostVO *postVOTmp = (ForumPostVO*)[dict objectForKey:[ForumOneSelfTableViewCell cellKeyForPostVO]];
                    if ([postVOTmp isKindOfClass:[ForumPostVO class]]) {
                        if (postVOTmp.post_id == weakSelf.replyToPostVO.post_id) {
                            postVOTmp.reply_num = postVOTmp.reply_num+1;
                            if (!postVOTmp.topReplies) {
                                postVOTmp.topReplies = [[NSMutableArray alloc] init];
                            }
                            if ([postVOTmp.topReplies count]<3) {
                                [postVOTmp.topReplies addObject:replyVO];
                            }
                            break;
                        }
                    }
                }
            }
            weakSelf.replyToPostVO = nil;
            weakSelf.reply_user_id = 0;
            
            [weakSelf.attachContainerView clear];
            [weakSelf.tableView reloadData];
            
            weakSelf.toolBar.inputTextView.placeHolder = @"回复";
            weakSelf.toolBar.inputTextView.text = @"";
            [weakSelf.toolBar textViewDidChange:weakSelf.toolBar.inputTextView];
            
            [weakSelf.view endEditing:YES];
            [weakSelf.toolBar endEditing:YES];
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    }
}

#pragma mark - EMChatBarMoreViewDelegate

- (void)moreViewPhotoAction:(DXChatBarMoreView *)moreView
{
    
}

- (void)moreViewGoodsAction:(DXChatBarMoreView *)moreView
{
    //    [self.view endEditing:YES];
    //    [self.toolBar endEditing:YES];
    
    if ([Session sharedInstance].currentUser.type==1) {
        SearchViewController *viewController = [[SearchViewController alloc] init];
        viewController.delegate = self;
        viewController.isForSelected = YES;
        [self pushViewController:viewController animated:YES];
    } else {
        SearchViewController *viewController = [[SearchViewController alloc] init];
        viewController.delegate = self;
        viewController.isForSelected = YES;
        viewController.sellerId = [Session sharedInstance].currentUserId;
        [self pushViewController:viewController animated:YES];
    }
}

- (void)searchViewGoodsSelected:(SearchViewController*)viewController recommendGoods:(RecommendGoodsInfo*)recommendGoodsInfo
{
    ForumAttachItemGoodsVO *attachGoodsVO = [[ForumAttachItemGoodsVO alloc] init];
    attachGoodsVO.goods_id = recommendGoodsInfo.goodsId;
    attachGoodsVO.goods_name = recommendGoodsInfo.goodsName;
    
    ForumAttachmentVO *attachmentVO = [[ForumAttachmentVO alloc] init];
    attachmentVO.type = ForumAttachTypeGoods;
    attachmentVO.item = attachGoodsVO;
    
    [_attachContainerView attachItem:attachmentVO];
    
    [viewController dismiss];
}

- (void)moreViewTakePicAction:(DXChatBarMoreView *)moreView
{
    
}


@end


@interface ForumOneSelfPopupView ()
@property(nonatomic,strong) NSArray *filterList;
@end

@implementation ForumOneSelfPopupView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)updateWithFilterList:(NSArray*)filterList selectedFilterVO:(ForumTopicFilterVO*)selectedFilterVO {
    
    _filterList = filterList;
    
    WEAKSELF;
    NSInteger count = [self.subviews count];
    for (NSInteger i=count;i<filterList.count;i++) {
        CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:16.f];
        btn.hidden = YES;
        [self addSubview:btn];
        btn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleFilterSelectedBlock) {
                weakSelf.handleFilterSelectedBlock(weakSelf,[weakSelf.filterList objectAtIndex:sender.tag]);
            }
        };
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectZero];
        lineView.backgroundColor = [UIColor blackColor];
        lineView.tag = 100;
        [btn addSubview:lineView];
    }
    for (CommandButton *btn in self.subviews) {
        btn.hidden = YES;
        [btn viewWithTag:100].hidden = YES;
    }
    
    for (NSInteger i=0;i<filterList.count;i++) {
        ForumTopicFilterVO *filterVO = (ForumTopicFilterVO*)[filterList objectAtIndex:i];
        if (filterVO!=selectedFilterVO) {
            CommandButton *btn = (CommandButton*)[self.subviews objectAtIndex:i];
            [btn setTitle:filterVO.display forState:UIControlStateNormal];
            btn.hidden = NO;
            btn.tag = i;
            [btn viewWithTag:100].hidden = NO;
        }
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CommandButton *lastBtn = nil;
    CGFloat marginTop = 10.f;
    for (NSInteger i=0;i<[self.subviews count];i++) {
        CommandButton *btn = (CommandButton*)[self.subviews objectAtIndex:i];
        if (![btn isHidden]) {
            btn.frame = CGRectMake(0, marginTop, self.width, 45);
            marginTop += btn.height;
            [lastBtn viewWithTag:100].frame = CGRectMake(2, btn.height-0.5, btn.width-4, 0.5f);
            lastBtn = btn;
        }
    }
    [lastBtn viewWithTag:100].hidden = YES;
}

@end







