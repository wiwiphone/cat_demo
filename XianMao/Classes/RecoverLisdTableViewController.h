//
//  RecoverLisdTableViewController.h
//  XianMao
//
//  Created by apple on 16/3/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
@class PullRefreshTableView;

@protocol RecoverLisdTableViewControllerDelegate <NSObject>

@optional
-(void)changeTableViewHeight:(CGFloat)scrollIndex;

@end

@interface RecoverLisdTableViewController : BaseViewController

@property (nonatomic, assign) NSInteger seletedIndex;

@property (nonatomic, copy) NSString *qk;
@property (nonatomic, copy) NSString *qv;
-(void)getJsonArr:(NSMutableArray *)arr;
- (void)initDataListLogic;
@property (nonatomic, strong) PullRefreshTableView *tableView;

@property (nonatomic, weak) id<RecoverLisdTableViewControllerDelegate> recovertListDelegate;
@end
