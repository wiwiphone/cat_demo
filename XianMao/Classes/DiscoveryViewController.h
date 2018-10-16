//
//  RecommendViewController.h
//  XianMao
//
//  Created by simon on 2/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "PullRefreshTableView.h"
#import "Command.h"

@class DiscoveryViewController;
@protocol DiscoveryViewControllerDelegate <NSObject>
@optional
- (void)recommendTableViewScrollViewDidScroll:(UIScrollView *)scrollView viewController:(DiscoveryViewController*)viewController;
@end

@class PullRefreshTableView;
@class DataListLogic;
@interface DiscoveryViewController : BaseViewControllerHandleMemoryWarning

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property(nonatomic,weak) PullRefreshTableView *tableView;
@property(nonatomic,weak) UIButton *shoppingCartBtn;
@property(nonatomic,weak) UIButton *goodsNumLbl;

@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) NSString *titleText;

@property(nonatomic,assign) id<DiscoveryViewControllerDelegate> delegate;

- (void)initDataListLogic;
@end

@interface TopBarRightNewButton : CommandButton

@property(nonatomic,assign) BOOL isInEditing;
@end

@interface HomeRecommendNewViewController : DiscoveryViewController

@end

@interface FeedsNewViewController : DiscoveryViewController

@end


@interface FollowingsNewViewController : DiscoveryViewController

@end


@interface DataListNewViewController : DiscoveryViewController

@property(nonatomic,copy) NSString *module;
@property(nonatomic,copy) NSString *path;
@property(nonatomic,copy) NSString *params;
@property(nonatomic,assign) BOOL isNeedShowSeperator;

@property(nonatomic,assign) BOOL isShowTitleBar;
@property(nonatomic,assign) CGFloat tableViewContentMarginTop;

@end



