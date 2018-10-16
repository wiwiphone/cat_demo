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

@class RecommendViewController;
@protocol RecommendViewControllerDelegate <NSObject>
@optional
- (void)recommendTableViewScrollViewDidScroll:(UIScrollView *)scrollView viewController:(RecommendViewController*)viewController;
@end

@class PullRefreshTableView;
@class DataListLogic;
@interface RecommendViewController : BaseViewControllerHandleMemoryWarning

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property(nonatomic,weak) PullRefreshTableView *tableView;
@property(nonatomic,weak) UIButton *shoppingCartBtn;
@property (nonatomic,strong) CommandButton * TopBarLeftButton;
@property(nonatomic,weak) UIButton *goodsNumLbl;

@property(nonatomic,assign) id<RecommendViewControllerDelegate> delegate;

- (void)initDataListLogic;
@end

@interface TopBarRightButton : CommandButton

@property(nonatomic,assign) BOOL isInEditing;
@end

@interface HomeRecommendViewController : RecommendViewController

@end

@interface FeedsViewController : RecommendViewController

@end


@interface FollowingsViewController : RecommendViewController

@end


@interface DataListViewController : RecommendViewController

@property(nonatomic,copy) NSString *module;
@property(nonatomic,copy) NSString *path;
@property(nonatomic,copy) NSString *params;
@property(nonatomic,assign) BOOL isNeedShowSeperator;

@property(nonatomic,assign) BOOL isShowTitleBar;
@property(nonatomic,assign) CGFloat tableViewContentMarginTop;

@end



