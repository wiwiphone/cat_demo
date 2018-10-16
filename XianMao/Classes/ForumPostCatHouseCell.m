//
//  ForumPostCatHouseCell.m
//  XianMao
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import "ForumPostCatHouseCell.h"
#import "ForumPostListViewController.h"
#import "ForumTopicVO.h"
#import "ForumPostTableViewCell.h"
#import "DataListLogic.h"
#import "ForumCatHouseDetailController.h"
#import "ForumPublishViewController.h"
#import "ForumPoatCatHouseControllerTwo.h"
#import "RecommendGoodsInfo.h"
#import "ForumAttachView.h"

#import "ForumInputToolBar.h"
#import "ForumService.h"
#import "ForumTopicVO.h"

#import "Error.h"
#import "JSONKit.h"
#import "Session.h"

#import "NSString+URLEncoding.h"
#import "NSString+Addtions.h"
#import "WCAlertView.h"


@interface ForumPostListViewControllerTwo () <UITableViewDelegate, PullRefreshTableViewDelegate>

@end

@implementation ForumPostListViewControllerTwo

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//    [self.tableView reloadData];
//}

-(instancetype)init{
    self = [super init];
    if (self) {
//        [super initDataListLogicSetBlock];
        self.tableView.delegate = self;
        self.tableView.pullDelegate = self;
        
        self.index = 0;
        self.topic_id = -1;
        
        
        

        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CGFloat topBarHeight = [self topBarHeight];
    self.toolBar.frame = CGRectMake(0, topBarHeight + 30, self.view.width, self.view.height-topBarHeight - [ForumInputToolBar defaultHeight]);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishPostImpl:) name:@"pushCammerController" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backTopMethod) name:@"backTop" object:nil];
}

-(void)backTopMethod{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
}

- (CGFloat)topBarHeight {
    return self.topBar.bounds.size.height-self.topbarShadowHeight;
}

//- (void)publishPostImpl:(NSNotification *)notify {
////    ForumPublishViewController *viewController = [[ForumPublishViewController alloc] init];
////    viewController.title = self.topicVO.publish_title;
////    viewController.topic_id = self.topicVO.topic_id;
////    [self pushViewController:viewController animated:YES];
//    ForumPostVO *postVO = notify.object;
//    WEAKSELF;
////    viewController.handlePublishedBlock = ^(ForumPostVO *postVO) {
//        [weakSelf showHUD:@"发布成功" hideAfterDelay:0.8f];
//    NSMutableArray *dataSources = weakSelf.dataSources;
//        if ([dataSources count]>=2 && [weakSelf.topicVO.head_text length]>0) {
//            [dataSources insertObject:[ForumPostTableSepCell buildCellDict] atIndex:2];
//            [dataSources insertObject:[ForumPostCatHouseTableViewCell buildCellDict:postVO forumTopicVO:weakSelf.topicVO] atIndex:2];
//        } else {
//            [dataSources insertObject:[ForumPostTableSepCell buildCellDict] atIndex:1];
//            [dataSources insertObject:[ForumPostCatHouseTableViewCell buildCellDict:postVO forumTopicVO:weakSelf.topicVO] atIndex:1];
//            //            [dataSources insertObject:[ForumPostSearchTableCell buildCellDict] atIndex:0];
//        }
////        weakSelf.dataSources = dataSources;
//        [weakSelf.tableView reloadData];
//        [weakSelf hideLoadingView];
////    };
//}


- (void)publishPostImpl:(NSNotification *)notify {
    
    
    ForumPostVO *postVO = notify.object;
    
    [self showHUD:@"发布成功" hideAfterDelay:0.8f];
    NSMutableArray *dataSources = self.dataSources;
    if ([dataSources count]>=2 && [self.topicVO.head_text length]>0) {
        [dataSources insertObject:[ForumPostTableSepCell buildCellDict] atIndex:2];
        [dataSources insertObject:[ForumPostCatHouseTableViewCell buildCellDict:postVO forumTopicVO:self.topicVO] atIndex:2];
    } else {
        [dataSources insertObject:[ForumPostTableSepCell buildCellDict] atIndex:1];
        [dataSources insertObject:[ForumPostCatHouseTableViewCell buildCellDict:postVO forumTopicVO:self.topicVO] atIndex:1];
        //            [dataSources insertObject:[ForumPostSearchTableCell buildCellDict] atIndex:0];
    }
    self.dataSources = dataSources;
    [self.tableView reloadData];
    [self loadData];
    [self hideLoadingView];

}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self.tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [self loadDataImpl];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [self.dataListLogic nextPage];
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
    } //else if ([postVO isKindOfClass:[ForumTopicVO class]]) {
    
    //        ForumPostCatHouseDetailController *viewController = [[ForumPostCatHouseDetailController alloc] init];
    //        viewController.postVO = postVO;
    //        viewController.topicVO = self.topicVO;
    //        [self pushViewController:viewController animated:YES];
    //        handled = YES;
    //
    //    }
    if (handled) {
        [self.view endEditing:YES];
        [self.toolBar endEditing:YES];
    }
}

-(void)initDataListLogicSetBlock{
    [super initDataListLogicSetBlock];
    WEAKSELF;
    
    self.dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        [weakSelf.dataSources removeAllObjects];
        [weakSelf.tableView reloadData];
        NSMutableArray *newList = weakSelf.dataSources;
        
//        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        if ([weakSelf.topicVO.head_text length]>0) {
            [newList addObject:[ForumTopicDescTableViewCell buildCellDict:weakSelf.topicVO.head_text]];
        }
        [newList addObject:[ForumPostSearchTableCell buildCellDict]];
        
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                ForumPostVO *postVO = [[ForumPostVO alloc] initWithJSONDictionary:dict];
                if ([postVO.content length]>0 || [postVO.attachments count]>0) {
                    [newList addObject:[ForumPostCatHouseTableViewCell buildCellDict:postVO forumTopicVO:weakSelf.topicVO]];
                    [newList addObject:[ForumPostTableSepCell buildCellDict]];
                }
            }
        }
        [weakSelf.tableView reloadData];
    };
    
    self.dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *dataSources = weakSelf.dataSources;
        if ([dataSources count]==0) {
            if ([weakSelf.topicVO.head_text length]>0) {
                [dataSources addObject:[ForumTopicDescTableViewCell buildCellDict:weakSelf.topicVO.head_text]];
            }
//            [dataSources addObject:[ForumPostSearchTableCell buildCellDict]];
        }
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            
            ForumPostVO *postVO = [[ForumPostVO alloc] initWithJSONDictionary:dict];
            if ([postVO.content length]>0 || [postVO.attachments count]>0) {
                [dataSources addObject:[ForumPostCatHouseTableViewCell buildCellDict:postVO forumTopicVO:weakSelf.topicVO]];
                [dataSources addObject:[ForumPostTableSepCell buildCellDict]];
            }
        }
        [weakSelf.tableView reloadData];
    };
    
//    self.dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
//        
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = YES;
//        
//        [weakSelf hideLoadingView];
//        
//        NSMutableArray *dataSources = [[NSMutableArray alloc] init];
//        CGFloat cellHeight = weakSelf.tableView.height;
//        [dataSources addObject:[ForumPostListNoContentTableCell buildCellDict:cellHeight]];
//        weakSelf.dataSources = dataSources;
//        [weakSelf.tableView reloadData];
//    };
    
}

- (void)loadData {
    [super loadData];
}

- (void)loadDataImpl {
    
    [super loadData];
//    [self initDataListLogic];
}

- (void)initDataListLogic {
    //do nothing
//    if ([self.dataSources count]==0) {
//        [super initDataListLogic];
////
//    }
    
    WEAKSELF;
    NSString *keywords = @"";
    if ([weakSelf.keywords length]>0) {
        keywords = [weakSelf.keywords URLEncodedString];
    }
    self.dataListLogic = [[DataListLogic alloc] initWithModulePath:@"forum" path:@"post_list" pageSize:20];
    self.dataListLogic.parameters = @{@"keywords":keywords, @"topic_id" : @0};
    self.dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    
    [self initDataListLogicSetBlock];
    
    if ([weakSelf.dataSources count]==0) {
        [weakSelf showLoadingView].backgroundColor = [UIColor clearColor];
    }
    [self.dataListLogic firstLoadFromCache];
    
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
                if (ClsTableViewCell == [ForumPostCatHouseTableViewCell class]) {
                    ForumPostVO *postVOTmp = (ForumPostVO*)[dict objectForKey:[ForumPostTableViewCell cellKeyForPostVO]];
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

- (LoadingView*)showLoadingView {
    LoadingView *view = [LoadingView showLoadingView:self.view];
    view.frame = CGRectMake(0, 0, self.view.width, self.view.height-self.topBarHeight + 20);
    view.backgroundColor = [UIColor whiteColor];
    [self bringTopBarToTop];
    return view;
}

- (void)$$handleReplyDidFinishNotification:(id<MBNotification>)notifi replyVO:(ForumPostReplyVO*)replyVO {
    WEAKSELF;
    [weakSelf.tableView reloadData];
}

- (void)$$handleQuoteFinishNotification:(id<MBNotification>)notifi {
    [self.tableView reloadData];
}

//- (void)$$handlePayPostDidFinishNotification:(id<MBNotification>)notifi postId:(NSNumber*)postId{
//    WEAKSELF;
//    NSInteger post_id = [postId integerValue];
//    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
//        NSDictionary *dict = (NSDictionary*)[weakSelf.dataSources objectAtIndex:i];
//        Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
//        if (ClsTableViewCell == [ForumPostCatHouseTableViewCell class]) {
//            ForumPostVO *postVOTmp = (ForumPostVO*)[dict objectForKey:[ForumPostTableViewCell cellKeyForPostVO]];
//            if ([postVOTmp isKindOfClass:[ForumPostVO class]]) {
//                if (postVOTmp.post_id == post_id) {
//                    [weakSelf.tableView reloadData];
//                    break;
//                }
//            }
//        }
//    }
//    [weakSelf.tableView reloadData];
//}

- (void)$$handleDeletePostDidFinishNotification:(id<MBNotification>)notifi postId:(NSNumber*)postId{
    WEAKSELF;
    NSInteger post_id = [postId integerValue];
    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
        NSDictionary *dict = (NSDictionary*)[weakSelf.dataSources objectAtIndex:i];
        Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        if (ClsTableViewCell == [ForumPostCatHouseTableViewCell class]) {
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

- (void)$$handleDeleteReplyFinishNotification:(id<MBNotification>)notifi replyId:(NSNumber*)replyId
{
    WEAKSELF;
    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
        NSDictionary *dict = (NSDictionary*)[weakSelf.dataSources objectAtIndex:i];
        Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        if (ClsTableViewCell == [ForumPostCatHouseTableViewCell class]) {
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

- (void)$$handleCompletePostDidFinishNotification:(id<MBNotification>)notifi postVO:(ForumPostVO*)postVO {
    WEAKSELF;
    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
        NSMutableDictionary *dict = (NSMutableDictionary*)[weakSelf.dataSources objectAtIndex:i];
        Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        if (ClsTableViewCell == [ForumPostCatHouseTableViewCell class]) {
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

@end


@interface ForumPostCatHouseCell ()
@property(nonatomic,strong) ForumPostListViewControllerTwo *viewController;
@end

@implementation ForumPostCatHouseCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _viewController = [[ForumPostListViewControllerTwo alloc] init];
        
    }
    return self;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    _viewController.view.frame = self.contentView.bounds;
    _viewController.topBar.hidden = YES;
    _viewController.scrollView.frame = CGRectMake(0, 0, kScreenWidth, _viewController.view.height - _viewController.topBarHeight + 15);
}

- (void)updateWithTopic:(ForumPostCatHouseVO*)catHouseVO {
    
    if (_viewController.topic_id!=catHouseVO.topicVO.topic_id) {
        _viewController.topic_id = catHouseVO.topicVO.topic_id;
        _viewController.dataSources = catHouseVO.dataSources;
        _viewController.dataListLogic = catHouseVO.dataListLogic;
        [_viewController initDataListLogicSetBlock];
        [_viewController.tableView reloadData];
    }
    if (_viewController.view.superview != self.contentView) {
        [_viewController.view removeFromSuperview];
        _viewController.view.frame = self.contentView.bounds;
        [self.contentView addSubview:_viewController.view];
    }
    
    [self setNeedsLayout];
    
    if ([catHouseVO.dataSources count]>0) {
        //[_viewController.tableView reloadData];
    } else {
        [_viewController loadDataImpl];
    }
}



@end




@implementation ForumPostCatHouseVO

@end


