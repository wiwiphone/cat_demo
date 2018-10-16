//
//  ForumPostListViewController.h
//  XianMao
//
//  Created by simon cai on 26/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "ForumTopicVO.h"
#import "PullRefreshTableView.h"

@class DataListLogic;
@class ForumInputToolBar;
@class ForumPostTableViewCell;
@class ForumAttachContainerView;
@interface ForumPostListViewController : BaseViewController

@property(nonatomic,weak) PullRefreshTableView *tableView;
@property(nonatomic,assign) NSInteger topic_id;
@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property (nonatomic, weak) UIScrollView *scrollView;
@property(nonatomic,strong) ForumTopicVO *topicVO;
@property(nonatomic,strong) ForumTopicFilterVO *selectedFilterVO;
@property(nonatomic,weak) ForumInputToolBar *toolBar;
@property(nonatomic,copy) NSString *keywords;
@property(nonatomic,weak) ForumAttachContainerView *attachContainerView;
@property (nonatomic, assign) BOOL tagYes;
@property (nonatomic, copy) NSString *tag;

@property(nonatomic,strong) ForumPostVO *replyToPostVO;
@property(nonatomic,assign) NSInteger reply_user_id;

@property (nonatomic, weak) ForumPostTableViewCell *tableViewCell;

- (void)loadData;
- (void)initDataListLogic;
- (void)initDataListLogicSetBlock;
- (void)publishPostImpl;
- (void)setNavTitleBar:(NSString *)title;

@end


@interface ForumFilterListPopupView : UIImageView

@property(nonatomic,copy) void(^handleFilterSelectedBlock)(ForumFilterListPopupView *view,ForumTopicFilterVO *filterVO);
- (void)updateWithFilterList:(NSArray*)filterList selectedFilterVO:(ForumTopicFilterVO*)selectedFilterVO;

@end