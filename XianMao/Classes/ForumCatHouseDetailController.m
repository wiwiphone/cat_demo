//
//  ForumCatHouseDetailController.m
//  XianMao
//
//  Created by apple on 16/1/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ForumCatHouseDetailController.h"
#import "DataListLogic.h"
#import "PullRefreshTableView.h"
#import "ForumPostTableViewCell.h"

@interface ForumCatHouseDetailController ()

@end

@implementation ForumCatHouseDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initDataListLogic{
    [super initDataListLogic];
    WEAKSELF;
    
    weakSelf.dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
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
    
    weakSelf.dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        
        [weakSelf hideLoadingView];
        
        NSMutableArray *newList = [[NSMutableArray alloc] init];
        [newList addObject:[FroumCatDetailCell buildCellDict:weakSelf.postVO]];
        [newList addObject:[ForumPostNoReplyTableCell buildCellDict:weakSelf.postVO]];
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
//
    };
    
}

@end
