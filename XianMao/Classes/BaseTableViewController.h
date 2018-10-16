//
//  BaseTableViewController.h
//  XianMao
//
//  Created by simon cai on 11/16/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "PullRefreshTableView.h"

@interface BaseTableViewController : BaseViewController <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property(nonatomic,retain) PullRefreshTableView *tableView;
@property(nonatomic,retain) NSMutableArray *dataSources;

@end
