//
//  ExploreViewController.h
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"

//
//@interface ExploreViewController : BaseViewControllerHandleMemoryWarning
//
//@property(nonatomic,assign) NSInteger tabIndex;
//@property(nonatomic,assign) BOOL isShowBackBtn;
//
//@end



@interface ExploreViewController : BaseViewControllerHandleMemoryWarning

@property(nonatomic,assign) NSInteger tabIndex;
@property(nonatomic,assign) BOOL isShowBackBtn;

@end

@class PullRefreshTableView;
@interface ExploreBrandViewController : BaseViewControllerHandleMemoryWarning

@property(nonatomic,weak) PullRefreshTableView *tableView;
@property(nonatomic,assign) CGFloat tableViewContentMarginTop;
@property(nonatomic,assign) BOOL isShowTitleBar;
@property(nonatomic,copy) NSString *params;
@property(nonatomic,assign) NSInteger numOfColumns;

@end

#import "BaseTableViewCell.h"

@interface ExploreBrandTableViewCell : BaseTableViewCell

+ (NSMutableDictionary*)buildCellDict:(NSArray*)brandsList numOfColums:(NSInteger)numOfColums marginLeft:(CGFloat)marginLeft;

@end

@interface ExploreLeftTabView : UIView

@property(nonatomic,copy) void(^handleDidSelectAtIndexBlock)(NSInteger index);

- (void)setSelectAtIndex:(NSInteger)index;
- (void)updateWithBtnTitles:(NSArray*)btnTitiles;

@end

