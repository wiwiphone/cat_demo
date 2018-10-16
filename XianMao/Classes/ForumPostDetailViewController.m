//
//  ForumPostDetailViewController.m
//  XianMao
//
//  Created by simon cai on 26/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ForumPostDetailViewController.h"
#import "ForumInputToolBar.h"
#import "ForumOneSelfController.h"
#import "ForumPostListViewController.h"

#import "ForumPublishViewController.h"

#import "PullRefreshTableView.h"
#import "DataListLogic.h"

#import "ForumService.h"
#import "ForumPostTableViewCell.h"

#import "NetworkAPI.h"

#import "NSString+Addtions.h"
#import "Error.h"
#import "NSString+URLEncoding.h"
#import "JSONModelProperty.h"
#import "JSONModel.h"
#import "JSONKit.h"

#import "Session.h"
#import "SearchViewController.h"
#import "WCAlertView.h"

#import "ForumAttachView.h"

#import "RecommendInfo.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@interface ForumPostDetailViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,ForumInputToolBarDelegate,DXChatBarMoreViewDelegate,SearchViewControllerDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,weak) XHMessageTextView *inputTextView;
@property(nonatomic,weak) UIScrollView *scrollView;
@property(nonatomic,weak) ForumInputToolBar *toolBar;



@property(nonatomic,assign) NSInteger reply_user_id;

@property(nonatomic,weak) ForumAttachContainerView *attachContainerView;
@end

@implementation ForumPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:[self.title length]>0?self.title:@"详情"];
    //[NSString stringWithFormat:@"全部 %ld 条回复",(long)self.postVO.reply_num]
    [super setupTopBarBackButton];
    
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    [self.view addSubview:scrollView];
    scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    scrollView.scrollEnabled = NO;
    _scrollView = scrollView;
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, scrollView.width, scrollView.height-[ForumInputToolBar defaultHeight]) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
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
    _toolBar.inputTextView.placeHolder = @"回复";
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
    
    [self loadData];
    
    _reply_user_id = 0;
    
    [self updateWithCompletePost];
    
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
    
    self.reply_user_id = 0;
    self.toolBar.inputTextView.placeHolder = @"回复";
    //            [weakSelf.toolBar.inputTextView becomeFirstResponder];
    [self.toolBar beginEditing];
    
    return NO;
}

- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    [self.toolBar endEditing:YES];
}

- (void)loadData {
    
    WEAKSELF;
    if (weakSelf.topicVO && weakSelf.postVO) {
        [weakSelf initDataListLogic];
    } else if (weakSelf.post_id>0) {
        [weakSelf showLoadingView];
        [ForumService post:weakSelf.post_id completion:^(ForumPostVO *postVO) {
            weakSelf.postVO = postVO;
            [ForumService getTopic:postVO.topic_id completion:^(ForumTopicVO *topic) {
                [weakSelf hideLoadingView];
                weakSelf.topicVO = topic;
                [weakSelf initDataListLogic];
            } failure:^(XMError *error) {
                [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
                    [weakSelf loadData];
                };
            }];
        } failure:^(XMError *error) {
            [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
                [weakSelf loadData];
            };
        }];
    }
}

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
    
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"forum" path:@"post_reply_list" pageSize:50];
    _dataListLogic.parameters = @{@"post_id":[NSNumber numberWithInteger:self.postVO.post_id]};
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
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        [newList addObject:[FroumCatDetailCell buildCellDict:weakSelf.postVO]];
        [newList addObject:[ForumPostReplyTableTopCell buildCellDict:weakSelf.postVO]];
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [addedItems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [newList addObject:[ForumPostReplyTableCell buildCellDict:[[ForumPostReplyVO alloc] initWithJSONDictionary:dict] needShowTopSep:[newList count]>2?YES:NO]];
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
                [dataSources addObject:[ForumPostReplyTableCell buildCellDict: [[ForumPostReplyVO alloc] initWithJSONDictionary:dict] needShowTopSep:[dataSources count]>2?YES:NO]];
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
        
        NSMutableArray *newList = [[NSMutableArray alloc] init];
        [newList addObject:[FroumCatDetailCell buildCellDict:weakSelf.postVO]];
        [newList addObject:[ForumPostNoReplyTableCell buildCellDict:weakSelf.postVO]];
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic reloadDataListByForce];
    
    [weakSelf showLoadingView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.view findFirstResponder] || [self.toolBar isInEditing]|| ![self.attachContainerView isHidden]) {
        [self.toolBar endEditing:YES];
        [self.view endEditing:YES];
    }
    if ([ForumPostTableViewCell hasShowMoreOprationView]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissMoreOprationViewForumPost" object:nil];
        });
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
    
    if ([tableViewCell isKindOfClass:[ForumPostReplyTableCell class]]) {
        WEAKSELF;
        ForumPostReplyTableCell *replyTableCell = (ForumPostReplyTableCell*)tableViewCell;
        [replyTableCell updateCellWithDict:dict postVO:self.postVO];
        
        replyTableCell.handleDeleteReplyBlock = ^(ForumPostVO *postVO, ForumPostReplyVO *replyVO) {
            [weakSelf showProcessingHUD:nil];
            [ForumService delete_reply:replyVO.reply_id completion:^{
                [weakSelf hideHUD];
                SEL selector = @selector($$handleDeleteReplyFinishNotificationForDetail:replyId:);
                MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:replyVO.reply_id]);
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
            }];
        };
    }
    else if ([tableViewCell isKindOfClass:[ForumPostTableViewCell class]]) {
        WEAKSELF;
        ForumPostTableViewCell *postTableViewCell = (ForumPostTableViewCell*)tableViewCell;
        [postTableViewCell updateCellWithDict:dict forumTopicVO:self.topicVO];
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
                        
                        [weakSelf.postVO assignWithOther:postVO];
                        
                        SEL selector = @selector($$handleCompletePostDidFinishNotification:postVO:);
                        MBGlobalSendNotificationForSELWithBody(selector, postVO);
                        [weakSelf loadData];
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        };
        postTableViewCell.handleReplyBlock = ^(ForumPostVO *postVO) {
            weakSelf.reply_user_id = 0;
            weakSelf.toolBar.inputTextView.placeHolder = @"回复";
            [weakSelf.toolBar beginEditing];
//            [weakSelf.toolBar.inputTextView becomeFirstResponder];
        };
        postTableViewCell.handleReplyToBlock = ^(ForumPostVO *postVO, ForumPostReplyVO *replyVO) {
            weakSelf.reply_user_id = 0;
            weakSelf.toolBar.inputTextView.placeHolder = @"回复";
//            [weakSelf.toolBar.inputTextView becomeFirstResponder];
            [weakSelf.toolBar beginEditing];
        };
        postTableViewCell.handleAllRepliesBlock = ^(ForumPostVO *postVO) {
            ForumPostDetailViewController *viewController = [[ForumPostDetailViewController alloc] init];
            viewController.postVO = postVO;
            viewController.topicVO = weakSelf.topicVO;
            [weakSelf pushViewController:viewController animated:YES];
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
                        
                        SEL selector = @selector($$handleQuoteFinishNotification:);
                        MBGlobalSendNotificationForSEL(selector);
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.f];
                    }];
                }
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
        
        postTableViewCell.handleIconBlock = ^(ForumPostVO *postVO) {
            
            
            
            
            ForumOneSelfController *selfController = [[ForumOneSelfController alloc] init];
            selfController.user_id = postVO.user_id;
            selfController.postVO = postVO;
            
            [weakSelf pushViewController:selfController animated:YES];
            
            //            [ForumService getHomePost:postVO.user_id completion:^(NSMutableArray *home) {
            //
            ////                self.listArr = [NSMutableArray arrayWithArray:home];
            ////                NSLog(@"%@", self.listArr);
            //
            //                NSDictionary *dict = @{@"postVO" : postVO};
            //                [[NSNotificationCenter defaultCenter] postNotificationName:@"setData" object:home userInfo:dict];
            //
            ////                [[NSNotificationCenter defaultCenter] postNotificationName:@"setData" object:home];
            //
            //                [weakSelf.tableView reloadData];
            //            } failure:^(XMError *error) {
            //
            //            }];
            //            
            //            [weakSelf pushViewController:oneSelf animated:YES];
            //
            //            
            
            
            
        };
        
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
        
//        postTableViewCell.handlePayBlock
    }
//    else if ([tableViewCell isKindOfClass:[ForumPostSearchTableCell class]]) {
//        WEAKSELF;
//        ForumPostSearchTableCell *searchTableCell = (ForumPostSearchTableCell*)tableViewCell;
//        
//        
//        
//        [tableViewCell updateCellWithDict:dict];
//    }
    
    else {
        [tableViewCell updateCellWithDict:dict];
    }
    
    return tableViewCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    if (ClsTableViewCell == [ForumPostReplyTableCell class]) {
        if (![self.postVO isFinshed]) {
            ForumPostReplyVO *replyVO = (ForumPostReplyVO*)[dict objectForKey:[ForumPostReplyTableCell cellKeyForReplyVO]];
            if ([Session sharedInstance].currentUserId==replyVO.user_id) {
                self.reply_user_id = 0;
                self.toolBar.inputTextView.placeHolder = @"回复";
            } else {
                self.reply_user_id = replyVO.user_id;
                self.toolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复%@",replyVO.username];
            }
            [self.toolBar beginEditing];
//            [self.toolBar.inputTextView becomeFirstResponder];
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
    //    [_menuController setMenuItems:nil];
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
    if ([content length]>0 || [weakSelf.attachContainerView.attachments count]>0) {
        [weakSelf showProcessingHUD:nil];
        [ForumService reply_post:weakSelf.postVO.post_id reply_user_id:weakSelf.reply_user_id content:content attachments:weakSelf.attachContainerView.attachments completion:^(ForumPostReplyVO *replyVO) {
            [weakSelf showHUD:@"回复成功" hideAfterDelay:0.8f];
            
            SEL selector = @selector($$handleReplyDidFinishNotification:replyVO:);
            MBGlobalSendNotificationForSELWithBody(selector, replyVO);
            
            weakSelf.toolBar.inputTextView.placeHolder = @"回复";
            weakSelf.toolBar.inputTextView.text = @"";
            [weakSelf.toolBar textViewDidChange:weakSelf.toolBar.inputTextView];
            
            weakSelf.reply_user_id = 0;
            [weakSelf.view endEditing:YES];
            [weakSelf.toolBar endEditing:YES];
            [weakSelf.attachContainerView clear];
            
           
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    }
}

- (void)$$handleQuoteFinishNotification:(id<MBNotification>)notifi {
    [self.tableView reloadData];
}

- (void)$$handleDeleteReplyFinishNotification:(id<MBNotification>)notifi replyId:(NSNumber*)replyId {
    
}

- (void)$$handlePayReplyFinishNotification:(id<MBNotification>)notifi replyID:(NSNumber *)replyId{
    
}

- (void)$$handleDeleteReplyFinishNotificationForDetail:(id<MBNotification>)notifi replyId:(NSNumber*)replyId
{
    BOOL isHanledForReplyNum = NO;
    for (NSInteger j=0;j<[self.postVO.topReplies count];j++) {
        ForumPostReplyVO *replyVO = [self.postVO.topReplies objectAtIndex:j];
        if (replyVO.reply_id == [replyId integerValue]) {
            [self.postVO.topReplies removeObjectAtIndex:j];
            self.postVO.reply_num -= 1;
            if (self.postVO.reply_num<=0) {
                self.postVO.reply_num = 0;
            }
            isHanledForReplyNum = YES;
            break;
        }
    }
    
    WEAKSELF;
    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
        NSDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
        Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        if (ClsTableViewCell == [ForumPostReplyTableCell class]) {
            ForumPostReplyVO *replyVO = [dict objectForKey:[ForumPostReplyTableCell cellKeyForReplyVO]];
            if (replyVO.reply_id==[replyId integerValue]) {
                [weakSelf.dataSources removeObjectAtIndex:i];
                if (!isHanledForReplyNum) {
                    weakSelf.postVO.reply_num -= 1; //不处理
                }
                break;
            }
        }
    }
    if (weakSelf.postVO.reply_num<=0) {
        weakSelf.postVO.reply_num = 0;
        NSMutableArray *newList = [[NSMutableArray alloc] init];
        [newList addObject:[ForumPostTableViewCell buildCellDict:weakSelf.postVO]];
        [newList addObject:[ForumPostNoReplyTableCell buildCellDict]];
        weakSelf.dataSources = newList;
    }
    [weakSelf.tableView reloadData];
    [weakSelf updateWithCompletePost];
    
    SEL selector = @selector($$handleDeleteReplyFinishNotification:replyId:);
    MBGlobalSendNotificationForSELWithBody(selector, replyId);
}

- (void)$$handleReplyDidFinishNotification:(id<MBNotification>)notifi replyVO:(ForumPostReplyVO*)replyVO {
    WEAKSELF;

    NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
    if ([dataSources count]>1) {
        NSDictionary *dict = [dataSources objectAtIndex:1];
        Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        if (ClsTableViewCell == [ForumPostNoReplyTableCell class]) {
            [dataSources removeObjectAtIndex:1];
            [dataSources addObject:[ForumPostReplyTableTopCell buildCellDict:weakSelf.postVO]];
            [dataSources addObject:[ForumPostReplyTableCell buildCellDict:replyVO needShowTopSep:[dataSources count]>2?YES:NO]];
        } else {
            if (!_dataListLogic.hasNextPage) {
                [dataSources addObject:[ForumPostReplyTableCell buildCellDict:replyVO needShowTopSep:[dataSources count]>2?YES:NO]];
            }
        }
    }
    if (!weakSelf.postVO.topReplies) {
        weakSelf.postVO.topReplies = [[NSMutableArray alloc] init];
    }
    if ([weakSelf.postVO.topReplies count]<3) {
        [weakSelf.postVO.topReplies addObject:replyVO];
    }
    weakSelf.postVO.reply_num = weakSelf.postVO.reply_num+1;
    weakSelf.dataSources = dataSources;
    [weakSelf.tableView reloadData];
    
    [super setupTopBarTitle:[self.title length]>0?self.title:[NSString stringWithFormat:@"全部 %ld 条回复",(long)self.postVO.reply_num]];
}

- (void)$$handleDeletePostDidFinishNotification:(id<MBNotification>)notifi postId:(NSNumber*)postId {
    
    WEAKSELF;
    double delayInSeconds = 0.5;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [weakSelf dismiss];
    });
}

- (void)$$handleCompletePostDidFinishNotification:(id<MBNotification>)notifi postVO:(ForumPostVO*)postVO {
    [self.tableView reloadData];
    [self.view endEditing:YES];
    [self.toolBar endEditing:YES];
    [self updateWithCompletePost];
}

- (void)updateWithCompletePost {
    if ([self.postVO isFinshed]) {
        self.toolBar.userInteractionEnabled = NO;
        self.toolBar.hidden = YES;
        self.tableView.frame = _scrollView.bounds;
    }
}

#pragma mark - EMChatBarMoreViewDelegate

-(void)moreViewPhotoAction:(DXChatBarMoreView *)moreView{
    
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


@implementation ForumQuoteInputView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, kScreenWidth, 44+20);
        self.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        
        CALayer *topLine = [CALayer layer];
        topLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        topLine.frame = CGRectMake(0, 0, kScreenWidth, 0.5);
        [self.layer addSublayer:topLine];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        lbl.textAlignment = NSTextAlignmentCenter;
//        if (self.index == 1) {
//            lbl.text = @"出价";
//        } else {
//            lbl.text = @"匿名报价";
//        }
        lbl.font = [UIFont systemFontOfSize:12];
        lbl.textColor = [UIColor colorWithHexString:@"999999"];
        [self addSubview:lbl];
        
        _textFiled = [[UIInsetTextField alloc] initWithFrame:CGRectMake(10, 20+4, kScreenWidth-10-10, 36) rectInsetDX:8 rectInsetDY:0];
        _textFiled.layer.masksToBounds = YES;
        _textFiled.layer.cornerRadius = 3;
        _textFiled.layer.borderColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        _textFiled.layer.borderWidth = 0.5f;
        _textFiled.backgroundColor = [UIColor whiteColor];
        [self addSubview:_textFiled];
        
    }
    return self;
}

- (NSInteger)priceCent {
    return [self.textFiled.text length]>0?[self.textFiled.text doubleValue]*100:0;
}

@end






