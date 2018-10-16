//
//  GoodsCommentsViewController.m
//  XianMao
//
//  Created by simon cai on 13/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "GoodsCommentsViewController.h"

#import "ForumInputToolBar.h"

#import "PullRefreshTableView.h"
#import "DataListLogic.h"

#import "ForumService.h"
#import "ForumPostTableViewCell.h"

#import "NSString+Addtions.h"
#import "Error.h"

#import "Session.h"
#import "SearchViewController.h"
#import "WCAlertView.h"

#import "ForumAttachView.h"

#import "RecommendInfo.h"

#import "CommentVo.h"
#import "CommentTableViewCell.h"
#import "GoodsService.h"


@interface GoodsCommentsViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,ForumInputToolBarDelegate,DXChatBarMoreViewDelegate,SearchViewControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,weak) XHMessageTextView *inputTextView;
@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) ForumInputToolBar *toolBar;

@property(nonatomic,weak) PullRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;

@property(nonatomic,assign) NSInteger reply_user_id;

@property(nonatomic,weak) ForumAttachContainerView *attachContainerView;
@end

@implementation GoodsCommentsViewController

- (void)dealloc
{
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat height = [self setupTopBar];
    
    CGFloat topBarHeight = 0;
    
    [super setupTopBarBackButton];
    [self setupTopBarTitle:@"评论"];
    
    CGFloat hegight = self.topBarRightButton.height;
    [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.topBarRightButton sizeToFit];
    self.topBarRightButton.frame = CGRectMake(self.topBar.width-15-self.topBarRightButton.width, self.topBarRightButton.top, self.topBarRightButton.width, hegight);
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    scrollView.scrollEnabled = NO;
    scrollView.backgroundColor = [UIColor clearColor];
    _scrollView = scrollView;
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height-[ForumInputToolBar defaultHeight]) style:UITableViewStylePlain];
    tableView.contentMarginTop = kTopBarHeight-2;
    self.tableView = tableView;
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    [scrollView addSubview:self.tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
    footerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = footerView;
    
    
    ForumInputToolBar *toolBar = [[ForumInputToolBar alloc] initWithFrame:CGRectMake(0, scrollView.height - [ForumInputToolBar defaultHeight], scrollView.width, [ForumInputToolBar defaultHeight]) withInputTextView:nil];
    _toolBar = toolBar;
    _toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    _toolBar.delegate = self;
    if ([_toolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        DXChatBarMoreView *moreView = (DXChatBarMoreView*)(_toolBar.moreView);
        moreView.delegate = self;
    }
    _toolBar.inputTextView.placeHolder = @"评论";
    [scrollView addSubview:toolBar];
    
    //将self注册为chatToolBar的moreView的代理
    if ([self.toolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
        [(DXChatBarMoreView *)self.toolBar.moreView setDelegate:self];
    }
    
    ForumAttachContainerView *attachContainerView = [[ForumAttachContainerView alloc] initWithFrame:CGRectMake(0, -40, kScreenWidth, 40)];
    [self.toolBar addSubview:attachContainerView];
    attachContainerView.hidden = YES;
    _attachContainerView = attachContainerView;
    _toolBar.attachContainerView = attachContainerView;
    
    [self bringTopBarToTop];
    
    [self setupForDismissKeyboard];
    
    [self initDataListLogic];
    
    _reply_user_id = 0;
    
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(tapAnywhereToDismissKeyboard:)];
    singleTapGR.delegate = self;
    [self.view addGestureRecognizer:singleTapGR];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self.view];
    CGRect rect = [self.view convertRect:self.attachContainerView.bounds fromView:self.attachContainerView];
    if (CGRectContainsPoint(rect, point) && ![self.attachContainerView isHidden]) {
        return NO;
    }
    if ([self.view findFirstResponder] || [self.toolBar isInEditing] || ![self.attachContainerView isHidden]) {
        return YES;
    }
    return NO;
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    [self.toolBar endEditing:YES];
}

- (void)initDataListLogic
{
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"comment" path:@"list" pageSize:20];
    _dataListLogic.parameters = @{@"goods_id":self.goodsId};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        weakSelf.tableView.backgroundColor = [UIColor whiteColor];
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                if ([newList count]>0) {
                    [newList addObject:[CommentTableViewCell buildCellDict:[[CommentVo alloc] initWithJSONDictionary:dict]]];
                } else {
                    [newList addObject:[CommentTableViewCell buildCellDictNoTopLine:[[CommentVo alloc] initWithJSONDictionary:dict]]];
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
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                if ([dataSources count]>0) {
                    [dataSources addObject:[CommentTableViewCell buildCellDict:[[CommentVo alloc] initWithJSONDictionary:dict]]];
                } else {
                    [dataSources addObject:[CommentTableViewCell buildCellDictNoTopLine:[[CommentVo alloc] initWithJSONDictionary:dict]]];
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
        
        [weakSelf loadEndWithNoContent:@"暂无评论"];
        
        [weakSelf.view bringSubviewToFront:weakSelf.scrollView];
        [weakSelf.scrollView bringSubviewToFront:weakSelf.toolBar];
        
        [weakSelf bringTopBarToTop];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    if ([weakSelf.dataSources count]==0) {
        [weakSelf showLoadingView].backgroundColor = [UIColor clearColor];
    }
    [_dataListLogic firstLoadFromCache];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.view findFirstResponder] || [self.toolBar isInEditing]|| ![self.attachContainerView isHidden]) {
        [self.toolBar endEditing:YES];
        [self.view endEditing:YES];
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
    
    WEAKSELF;
    if ([tableViewCell isKindOfClass:[CommentTableViewCell class]]) {
        ((CommentTableViewCell*)tableViewCell).handleDelCommentBlock = ^(CommentVo *comment) {
            [weakSelf showProcessingHUD:nil];
            [GoodsService comment_delete:comment.comment_id completion:^{
                [weakSelf hideHUD];
                SEL selector = @selector($$handleGoodsCommentDeleted:commentId:);
                MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:comment.comment_id]);
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
    }
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    CommentVo *comment = (CommentVo*)[dict objectForKey:[CommentTableViewCell cellKeyForComment]];
    if ([comment isKindOfClass:[CommentVo class]]) {
        if (comment.user_id == [Session sharedInstance].currentUserId) {
            self.reply_user_id = 0;
            self.toolBar.inputTextView.placeHolder = @"评论";
            [self.toolBar beginEditing];
        } else {
            self.reply_user_id = comment.user_id;
            self.toolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复 %@", comment.username];
            [self.toolBar beginEditing];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
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
    if ([content length]>0|| [weakSelf.attachContainerView.attachments count]>0) {
        [weakSelf showProcessingHUD:nil];
        
        [GoodsService comment_publish:weakSelf.goodsId
                        reply_user_id:weakSelf.reply_user_id
                              content:content
                          attachments:weakSelf.attachContainerView.attachments completion:^(CommentVo *commentVo)
         {
             [weakSelf showHUD:@"评论成功" hideAfterDelay:0.8f];
             
             [weakSelf.attachContainerView clear];
             
             
             GoodsCommentVoWrapper *obj = [[GoodsCommentVoWrapper alloc] init];
             obj.goodsId = weakSelf.goodsId;
             obj.comment = commentVo;
             SEL selector = @selector($$handleGoodsCommentAdd:comment:);
             MBGlobalSendNotificationForSELWithBody(selector, obj);
             
             weakSelf.reply_user_id = 0;
             
             weakSelf.toolBar.inputTextView.placeHolder = @"评论";
             weakSelf.toolBar.inputTextView.text = @"";
             [weakSelf.toolBar textViewDidChange:weakSelf.toolBar.inputTextView];
             
             [weakSelf.view endEditing:YES];
             [weakSelf.toolBar endEditing:YES];
             
         } failure:^(XMError *error) {
             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
         }];
    }
}


- (void)$$handleGoodsCommentAdd:(id<MBNotification>)notifi comment:(GoodsCommentVoWrapper*)commentWrapper
{
    if ([commentWrapper.goodsId isEqualToString:self.goodsId]) {
        [self hideNoContentView];
        if (!self.dataSources) {
            self.dataSources = [[NSMutableArray alloc] init];
        }
        if ([self.dataSources count]>0) {
            NSMutableDictionary *dict = [self.dataSources objectAtIndex:0];
            [dict setObject:[NSNumber numberWithBool:YES] forKey:[CommentTableViewCell cellKeyForIsShowTopLine]];
        }
        [self.dataSources insertObject: [CommentTableViewCell buildCellDictNoTopLine:commentWrapper.comment] atIndex:0];
        [_tableView reloadData];
    }
}

- (void)$$handleGoodsCommentDeleted:(id<MBNotification>)notifi commentId:(NSNumber*)commentId
{
    for (NSInteger i=0;i<[self.dataSources count];i++) {
        NSDictionary *dict = (NSDictionary*)[self.dataSources objectAtIndex:i];
        CommentVo *comment = [dict objectForKey:[CommentTableViewCell cellKeyForComment]];
        if (comment.comment_id == [commentId integerValue]) {
            [self.dataSources removeObjectAtIndex:i];
            
            if ([self.dataSources count]>0) {
                NSMutableDictionary *dictTmp = [self.dataSources objectAtIndex:0];
                [dictTmp setObject:[NSNumber numberWithBool:YES] forKey:[CommentTableViewCell cellKeyForIsShowTopLine]];
            }
            [_tableView reloadData];
            break;
        }
    }
    
    if ([self.dataSources count]==0) {
        [self loadEndWithNoContent:@"暂无评论"];
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


@implementation GoodsCommentVoWrapper

@end

