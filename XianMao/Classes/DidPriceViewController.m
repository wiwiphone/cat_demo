//
//  DidPriceViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/3/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "DidPriceViewController.h"
#import "MJRefresh.h"
#import "NetworkManager.h"
#import "JSONKit.h"
#import "SDWebImageManager.h"
#import "Masonry.h"
#import "RecoveryGoodsVo.h"
#import "OfferedViewController.h"
#import "NetworkAPI.h"
#import "RecoveryGoodsDetail.h"
#import "HighestBidVo.h"
#import "MJDIYHeader.h"

@interface DidPriceViewController ()<UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate, PullRefreshTableViewDelegate> {
    UIView *segmentBottomView;
    UISegmentedControl *segment;
    
    NSArray *refreshPhotoArr;
    
    UIActivityIndicatorView *myLoadingView;
}

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottonView;

@end

@implementation DidPriceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.916 alpha:1.000];
    
    [self setupTopBar];
    [self setupTopBarTitle:@"我出价的商品"];
//    [super setupTopBarRightButton:[UIImage imageNamed:@"Recover_Search_MF"] imgPressed:nil];
    [self setupTopBarBackButton];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"全部", @"出价中", @"已授权", @"出价结束", nil];
    
    CGFloat topBarHeight = [super setupTopBar];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight, kScreenHeight, 44)];
    self.topView = topView;
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"全部" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
    [btn1 sizeToFit];
    [btn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setTitle:@"出价中" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
    [btn2 sizeToFit];
    [btn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn3 = [[UIButton alloc] init];
    [btn3 setTitle:@"已授权" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btn3 setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
    [btn3 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
    [btn3 sizeToFit];
    [btn3 addTarget:self action:@selector(clickBtn3:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn4 = [[UIButton alloc] init];
    [btn4 setTitle:@"出价结束" forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btn4 setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
    [btn4 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
    [btn4 sizeToFit];
    [btn4 addTarget:self action:@selector(clickBtn4:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectZero];
//    bottonView.frame = CGRectMake(15, self.btn1.bottom - 4, self.btn1.width, 2);
    bottonView.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
    
    btn1.selected = YES;
    [self.view addSubview:self.topView];
    [topView addSubview:btn1];
    [topView addSubview:btn2];
    [topView addSubview:btn3];
    [topView addSubview:btn4];
    [topView addSubview:bottonView];
    
    self.bottonView = bottonView;
    self.topView = topView;
    self.btn1 = btn1;
    self.btn2 = btn2;
    self.btn3 = btn3;
    self.btn4 = btn4;
    
    self.bgScrollView.frame = CGRectMake(0, kTopBarHeight + 50, kScreenWidth, kScreenHeight - kTopBarHeight - 50);
    self.bgScrollView.contentSize = CGSizeMake(kScreenWidth * titleArr.count, 0);
    self.bgScrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bgScrollView];
    
    
    self.tableViewOne.frame = CGRectMake(0, 0, kScreenWidth, self.bgScrollView.frame.size.height);
    self.tableViewTwo.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.bgScrollView.frame.size.height);
    self.tableViewThree.frame = CGRectMake(kScreenWidth * 2, 0, kScreenWidth, self.bgScrollView.frame.size.height);
    self.tableViewFour.frame = CGRectMake(kScreenWidth * 3, 0, kScreenWidth, self.bgScrollView.frame.size.height);
    
    [self.bgScrollView addSubview:self.tableViewOne];
    [self.bgScrollView addSubview:self.tableViewTwo];
    [self.bgScrollView addSubview:self.tableViewThree];
    [self.bgScrollView addSubview:self.tableViewFour];
    
    
    self.dataURL = @"/recovery/get_bid_goods_list";
    
    [self.tableViewOne.mj_header beginRefreshing];
    [self.tableViewTwo.mj_header beginRefreshing];
    [self.tableViewThree.mj_header beginRefreshing];
    [self.tableViewFour.mj_header beginRefreshing];
    
    [self bringTopBarToTop];
    
    [self setUpUI];
}
- (void)addLoading:(UITableView *)tableView {
    if (!myLoadingView) {
        myLoadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        myLoadingView.center = tableView.center;
        [myLoadingView startAnimating];
        [myLoadingView setHidesWhenStopped:YES];
    }
    [myLoadingView removeFromSuperview];
    [tableView addSubview:myLoadingView];
    [myLoadingView startAnimating];
}

- (void)removeLoading {
    [myLoadingView stopAnimating];
}

#pragma mark -pullTableviewDelegate

//- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)tableView {
//    [self refresh:tableView];
//}
//- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)tableView {
//    [self loadMoreData:tableView];
//}


- (void)refresh:(UITableView *)tableView {
//    WEAKSELF;
    if (tableView.tag == 1001) {
//        NSLog(@"第一个刷新");
        NSDictionary *params = @{@"page":@(0), @"size":@(15), @"status":@(0)};
        
        //URL未初始化
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.dataURL path:@"" parameters:params completionBlock:^(NSDictionary *data) {
            [tableView.mj_header endRefreshing];
            
            NSLog(@"date:%@", data);
            
            [tableView.mj_footer resetNoMoreData];
            
            self.followPageOne = 1;
            NSString *str = [data JSONString];
            NSLog(@"%@", str);
            
            if (self.dataSourceArrOne.count > 0) {
                [self.dataSourceArrOne removeAllObjects];
            }
            NSArray *array = data[@"list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                didPriceCellModel *model = [[didPriceCellModel alloc] initWithDictionary:dic];
//                NSLog(@"add dic:%@", dic);
                [self.dataSourceArrOne addObject:model];
            }
            
            if ([data[@"hasNextPage"] integerValue] != 1 && self.dataSourceArrOne.count > 0) {
                //显示没有更多内容
                [tableView.mj_footer endRefreshingWithNoMoreData];
//                [tableView.mj_footer 
            }
            
            if (!(self.dataSourceArrOne.count > 0)) {
                [tableView addSubview:self.noContentImageViewOne];
                [tableView bringSubviewToFront:self.noContentImageViewOne];
//
//                [super loadEndWithNoContentWithRetryButtonHaveView:@"无出价商品" andView:self.topView.frame.size.height].handleRetryBtnClicked=^(UIView *view) {
//                    [self refresh:self.tableViewOne];
//                };
                
            }
            
            [tableView reloadData];
            
        } failure:nil queue:nil]];
    }
    if (tableView.tag == 1002) {
        NSLog(@"第二个刷新");
        NSDictionary *params = @{@"page":@(0), @"size":@(15), @"status":@(1)};
        
        //URL未初始化
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.dataURL path:@"" parameters:params completionBlock:^(NSDictionary *data) {
            [tableView.mj_header endRefreshing];
            
            [tableView.mj_footer resetNoMoreData];
            
            self.followPageTwo = 1;
//            NSString *str = [data JSONString];
//            NSLog(@"datasourceTwo:%@", str);
            
            if (self.dataSourceArrTwo.count > 0) {
                [self.dataSourceArrTwo removeAllObjects];
            }
            NSArray *array = data[@"list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                didPriceCellModel *model = [[didPriceCellModel alloc] initWithDictionary:dic];
                [self.dataSourceArrTwo addObject:model];
            }
            
            if ([data[@"hasNextPage"] integerValue] != 1 && self.dataSourceArrTwo.count > 0) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (!(self.dataSourceArrTwo.count > 0)) {
                [tableView addSubview:self.noContentImageViewTwo];
                [tableView bringSubviewToFront:self.noContentImageViewTwo];
//                [self loadEndWithNoContentWithRetryButtonNotTopBar:@"无出价中商品"].handleRetryBtnClicked = ^(LoadingView *view) {
//                    [self refresh:self.tableViewTwo];
//                };
//                [super loadEndWithNoContentWithRetryButtonHaveView:@"无出价中商品" andView:self.topView.frame.size.height].handleRetryBtnClicked=^(UIView *view) {
//                    [self refresh:self.tableViewTwo];
//                };
            }
            
            [tableView reloadData];
            
        } failure:nil queue:nil]];
    }
    if (tableView.tag == 1003) {
        NSLog(@"第三个刷新");
        NSDictionary *params = @{@"page":@(0), @"size":@(15), @"status":@(2)};
        
        //URL未初始化
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.dataURL path:@"" parameters:params completionBlock:^(NSDictionary *data) {
            [tableView.mj_header endRefreshing];
            
            [tableView.mj_footer resetNoMoreData];
            
            self.followPageThree = 1;
//            NSString *str = [data JSONString];
//            NSLog(@"datasourceThree:%@", str);
            if (self.dataSourceArrThree.count > 0) {
                [self.dataSourceArrThree removeAllObjects];
            }
            NSArray *array = data[@"list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                didPriceCellModel *model = [[didPriceCellModel alloc] initWithDictionary:dic];
                [self.dataSourceArrThree addObject:model];
            }
            
            if ([data[@"hasNextPage"] integerValue] != 1 && self.dataSourceArrThree.count > 0) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (!(self.dataSourceArrThree.count > 0)) {
                [tableView addSubview:self.nocontentImageViewThree];
                [tableView bringSubviewToFront:self.nocontentImageViewThree];
//                [self loadEndWithNoContentWithRetryButtonNotTopBar:@"无出价成功商品"].handleRetryBtnClicked = ^(LoadingView *view) {
//                    [self refresh:self.tableViewThree];
//                };
//                [super loadEndWithNoContentWithRetryButtonHaveView:@"无出价成功商品" andView:self.topView.frame.size.height].handleRetryBtnClicked=^(UIView *view) {
//                    [self refresh:self.tableViewThree];
//                };
            }
            
            [tableView reloadData];
            
        } failure:nil queue:nil]];
    }
    if (tableView.tag == 1004) {
        NSLog(@"第四个刷新");
        NSDictionary *params = @{@"page":@(0), @"size":@(15), @"status":@(3)};
        
        //URL未初始化
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.dataURL path:@"" parameters:params completionBlock:^(NSDictionary *data) {
            [tableView.mj_header endRefreshing];
            
            
            [tableView.mj_footer resetNoMoreData];
            self.followPageFour = 1;
            //            NSString *str = [data JSONString];
            //            NSLog(@"datasourceThree:%@", str);
            if (self.dataSourceArrFour.count > 0) {
                [self.dataSourceArrFour removeAllObjects];
            }
            NSArray *array = data[@"list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                didPriceCellModel *model = [[didPriceCellModel alloc] initWithDictionary:dic];
                [self.dataSourceArrFour addObject:model];
            }
            if ([data[@"hasNextPage"] integerValue] != 1 && self.dataSourceArrFour.count > 0) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            if (!(self.dataSourceArrFour.count > 0)) {
                [tableView addSubview:self.noContentImageViewFour];
                [tableView bringSubviewToFront:self.noContentImageViewFour];
                
                
//                [super loadEndWithNoContentWithRetryButtonHaveView:@"" andView:self.topView.frame.size.height].handleRetryBtnClicked=^(UIView *view) {
//                    [self refresh:self.tableViewFour];
//                };
            }
            
            [tableView reloadData];
            
        } failure:nil queue:nil]];
    }

}

- (void)loadMoreData:(UITableView *)tableView {
    if (tableView.tag == 1001) {
        NSLog(@"第一个加载更多");
        NSDictionary *paramss = @{@"page":@(self.followPageOne), @"size":@(15), @"status":@(0)};
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.dataURL path:@"" parameters:paramss completionBlock:^(NSDictionary *data) {
            if ([data[@"hasNextPage"] integerValue] != 1 && self.dataSourceArrOne.count >= 1) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [tableView.mj_footer endRefreshing];
            }
            
            self.followPageOne++;
//            NSString *str = [data JSONString];
//            NSLog(@"%@", str);
            NSArray *array = data[@"list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                didPriceCellModel *model = [[didPriceCellModel alloc] initWithDictionary:dic];
                [self.dataSourceArrOne addObject:model];
            }
            
            [tableView reloadData];
            
        } failure:nil queue:nil]];
    }
    if (tableView.tag == 1002) {
        NSLog(@"第二个加载更多");
        NSDictionary *paramss = @{@"page":@(self.followPageTwo), @"size":@(15), @"status":@(1)};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.dataURL path:@"" parameters:paramss completionBlock:^(NSDictionary *data) {
            
            if ([data[@"hasNextPage"] integerValue] != 1 && self.dataSourceArrTwo.count > 0) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [tableView.mj_footer endRefreshing];
            }
            
            
            
            self.followPageTwo++;
            //            NSString *str = [data JSONString];
            //            NSLog(@"%@", str);
            NSArray *array = data[@"list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                didPriceCellModel *model = [[didPriceCellModel alloc] initWithDictionary:dic];
                [self.dataSourceArrTwo addObject:model];
            }
            
            [tableView reloadData];
            
        } failure:nil queue:nil]];
    }
    if (tableView.tag == 1003) {
        NSLog(@"第三个加载更多");
        NSDictionary *paramss = @{@"page":@(self.followPageThree), @"size":@(15), @"status":@(2)};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.dataURL path:@"" parameters:paramss completionBlock:^(NSDictionary *data) {
            if ([data[@"hasNextPage"] integerValue] != 1 && self.dataSourceArrThree.count > 0) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [tableView.mj_footer endRefreshing];
            }
            
            self.followPageThree++;
//            NSString *str = [data JSONString];
//            NSLog(@"loadmore: %@", str);
            NSArray *array = data[@"list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                didPriceCellModel *model = [[didPriceCellModel alloc] initWithDictionary:dic];
                [self.dataSourceArrThree addObject:model];
            }
            
            [tableView reloadData];
            
        } failure:nil queue:nil]];
    }
    
    if (tableView.tag == 1004) {
        NSLog(@"第四个加载更多");
        NSDictionary *paramss = @{@"page":@(self.followPageFour), @"size":@(15), @"status":@(3)};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.dataURL path:@"" parameters:paramss completionBlock:^(NSDictionary *data) {
            if ([data[@"hasNextPage"] integerValue] != 1 && self.dataSourceArrFour.count > 0) {
                [tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [tableView.mj_footer endRefreshing];
            }
            
            self.followPageFour++;
            //            NSString *str = [data JSONString];
            //            NSLog(@"loadmore: %@", str);
            NSArray *array = data[@"list"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                didPriceCellModel *model = [[didPriceCellModel alloc] initWithDictionary:dic];
                [self.dataSourceArrFour addObject:model];
            }
            
            [tableView reloadData];
            
        } failure:nil queue:nil]];
    }

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 1001) {
        return self.dataSourceArrOne.count;
    }
    if (tableView.tag == 1002) {
        return self.dataSourceArrTwo.count;
    }
    if (tableView.tag == 1003) {
        return self.dataSourceArrThree.count;
    }
    if (tableView.tag == 1004) {
        return self.dataSourceArrFour.count;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.tag == 1001) {
        didPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"one"];
        if (!cell) {
            cell = [[didPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"one"];
//            NSLog(@"dic:%@", self.dataSourceArrOne[indexPath.row]);
        }
//        [cell updataWithDic:self.dataSourceArrOne[indexPath.row]];
        [cell updataWithModel:self.dataSourceArrOne[indexPath.row]];
        return cell;
    }
    if (tableView.tag == 1002) {
        didPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"two"];
        if (!cell) {
            cell = [[didPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"two"];
//            NSLog(@"dic:%@", self.dataSourceArrOne[indexPath.row]);
        }
        [cell updataWithModel:self.dataSourceArrTwo[indexPath.row]];
//        cell.statusLB.text = @"出价中";
        return cell;
    }
    if (tableView.tag == 1003) {
        didPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"three"];
        if (!cell) {
            cell = [[didPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"three"];
//            NSLog(@"dic:%@", self.dataSourceArrOne[indexPath.row]);
        }
        [cell updataWithModel:self.dataSourceArrThree[indexPath.row]];
//        cell.statusLB.text = @"出价成功";
        return cell;
    }
    
    if (tableView.tag == 1004) {
        didPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"four"];
        if (!cell) {
            cell = [[didPriceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"four"];
            //            NSLog(@"dic:%@", self.dataSourceArrOne[indexPath.row]);
        }
        [cell updataWithModel:self.dataSourceArrFour[indexPath.row]];
//        cell.statusLB.text = @"出价结束";
        return cell;
    }
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *dic = [NSDictionary dictionary];
    didPriceCellModel *model = [[didPriceCellModel alloc] init];
    if (tableView.tag == 1001) {
        model = self.dataSourceArrOne[indexPath.row];
    }
    if (tableView.tag == 1002) {
        model = self.dataSourceArrTwo[indexPath.row];
    }
    if (tableView.tag == 1003) {
        model = self.dataSourceArrThree[indexPath.row];
    }
    if (tableView.tag == 1004) {
        model = self.dataSourceArrFour[indexPath.row];
    }
    
    OfferedViewController *offeredConroller = [[OfferedViewController alloc] init];
    offeredConroller.goodID = model.goodsSn;
    [self pushViewController:offeredConroller animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (UITableView *)tableViewOne {
    if (!_tableViewOne) {
        _tableViewOne = [[UITableView alloc] initWithFrame:CGRectZero];
        _tableViewOne.tag = 1001;
        
//        _tableViewOne.pullDelegate = self;
        _tableViewOne.delegate = self;
        _tableViewOne.dataSource = self;
        _tableViewOne.backgroundColor = [UIColor whiteColor];
        UIView *footView = [[UIView alloc] init];
        footView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        _tableViewOne.tableFooterView = footView;
        _tableViewOne.separatorStyle = UITableViewCellSeparatorStyleNone;
////        _tableViewOne.enableRefreshing = YES;
////        _tableViewOne.enableLoadingMore = YES;
//        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//            [self refresh:_tableViewOne];
//        }];
        MJDIYHeader *headert = [MJDIYHeader headerWithRefreshingBlock:^{
            [self refresh:_tableViewOne];
        }];
//        NSArray *imageArr = [NSArray arrayWithObjects:[UIImage imageNamed:@"pull_refresh_arrow"], [UIImage imageNamed:@"pull_refresh_arrow"], nil];
        //设置普通状态的动画图片
//        [header setImages:nil forState:MJRefreshStateIdle];
//        
//        [header setimage:[UIImage imageNamed:@"pull_refresh_arrow"] forState:MJRefreshStateIdle];
//        
//        [header setimage:[UIImage imageNamed:@"pull_round_refreshing"] forState:MJRefreshStateRefreshing];
//        
//        [header setimage:[UIImage imageNamed:@"pull_refresh_arrow"] forState:MJRefreshStatePulling];
//        //设置即将刷新状态的动画图片
//        [header setImages:nil forState:MJRefreshStatePulling];
//        
//        //设置正在刷新状态的动画图片
//        [header setImages:nil forState:MJRefreshStateRefreshing];
        
        _tableViewOne.mj_header = headert;
        
//        header.lastUpdatedTimeLabel.hidden = YES;
//        
//        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//        [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
//        [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//        
//        header.stateLabel.font = [UIFont systemFontOfSize:12];
//        header.stateLabel.textColor = [UIColor grayColor];
        
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            [self loadMoreData:_tableViewOne];
        }];
        //        [footer setImages:<#(NSArray *)#> forState:<#(MJRefreshState)#>]
        
        [footer setTitle:@" " forState:MJRefreshStateIdle];
        [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        footer.stateLabel.textColor = [UIColor grayColor];
        
        _tableViewOne.mj_footer = footer;
//        _tableViewOne.mj_footer.hidden = YES;
    }
    return _tableViewOne;
}

- (UITableView *)tableViewTwo {
    if (!_tableViewTwo) {
        _tableViewTwo = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tableViewTwo.tag = 1002;
        _tableViewTwo.delegate = self;
        _tableViewTwo.dataSource = self;
        _tableViewTwo.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableViewTwo.backgroundColor = [UIColor clearColor];
        
        [_tableViewTwo registerClass:[didPriceCell class] forCellReuseIdentifier:@"two"];
        
//        _tableViewTwo.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//            [self refresh:_tableViewTwo];
//        }];
//        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//            [self refresh:_tableViewTwo];
//        }];
//        //设置普通状态的动画图片
//        [header setImages:refreshPhotoArr forState:MJRefreshStateIdle];
//        //设置即将刷新状态的动画图片
//        [header setImages:refreshPhotoArr forState:MJRefreshStatePulling];
//        //设置正在刷新状态的动画图片
//        [header setImages:refreshPhotoArr forState:MJRefreshStateRefreshing];
//        
//        _tableViewTwo.mj_header = header;
//        
//        header.lastUpdatedTimeLabel.hidden = YES;
//        
//        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//        [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
//        [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        
        
        
//        header.stateLabel.font = [UIFont systemFontOfSize:12];
//        header.stateLabel.textColor = [UIColor grayColor];
        
        MJDIYHeader *headert = [MJDIYHeader headerWithRefreshingBlock:^{
            [self refresh:_tableViewTwo];
        }];
        _tableViewTwo.mj_header = headert;
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            [self loadMoreData:_tableViewTwo];
        }];
        //        [footer setImages:<#(NSArray *)#> forState:<#(MJRefreshState)#>]
        
        [footer setTitle:@" " forState:MJRefreshStateIdle];
        [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        footer.stateLabel.textColor = [UIColor grayColor];
        
        _tableViewTwo.mj_footer = footer;
//        _tableViewTwo.mj_footer.hidden = YES;
    }
    return _tableViewTwo;
}

- (UITableView *)tableViewThree {
    if (!_tableViewThree) {
        _tableViewThree = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tableViewThree.tag = 1003;
        _tableViewThree.delegate = self;
        _tableViewThree.dataSource = self;
        _tableViewThree.backgroundColor = [UIColor clearColor];
        _tableViewThree.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableViewThree registerClass:[didPriceCell class] forCellReuseIdentifier:@"three"];
        
//        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//            [self refresh:_tableViewThree];
//        }];
//        //设置普通状态的动画图片
//        [header setImages:refreshPhotoArr forState:MJRefreshStateIdle];
//        //设置即将刷新状态的动画图片
//        [header setImages:refreshPhotoArr forState:MJRefreshStatePulling];
//        //设置正在刷新状态的动画图片
//        [header setImages:refreshPhotoArr forState:MJRefreshStateRefreshing];
//        
//        _tableViewThree.mj_header = header;
//        
//        header.lastUpdatedTimeLabel.hidden = YES;
//        
//        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//        [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
//        [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//        
//        header.stateLabel.font = [UIFont systemFontOfSize:12];
//        header.stateLabel.textColor = [UIColor grayColor];
        
        MJDIYHeader *headert = [MJDIYHeader headerWithRefreshingBlock:^{
            [self refresh:_tableViewThree];
        }];
        _tableViewThree.mj_header = headert;
        
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            [self loadMoreData:_tableViewThree];
        }];
//        [footer setImages:<#(NSArray *)#> forState:<#(MJRefreshState)#>]
        
        [footer setTitle:@" " forState:MJRefreshStateIdle];
        [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        footer.stateLabel.textColor = [UIColor grayColor];
        
        _tableViewThree.mj_footer = footer;
//        _tableViewThree.mj_footer.hidden = YES;
    }
    return _tableViewThree;
}

- (UITableView *)tableViewFour {
    if (!_tableViewFour) {
        _tableViewFour = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _tableViewFour.tag = 1004;
        _tableViewFour.delegate = self;
        _tableViewFour.dataSource = self;
        _tableViewFour.backgroundColor = [UIColor clearColor];
        _tableViewFour.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        [_tableViewFour registerClass:[didPriceCell class] forCellReuseIdentifier:@"four"];
        
//        MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingBlock:^{
//            [self refresh:_tableViewFour];
//        }];
//        //设置普通状态的动画图片
//        [header setImages:refreshPhotoArr forState:MJRefreshStateIdle];
//        //设置即将刷新状态的动画图片
//        [header setImages:refreshPhotoArr forState:MJRefreshStatePulling];
//        //设置正在刷新状态的动画图片
//        [header setImages:refreshPhotoArr forState:MJRefreshStateRefreshing];
//        
//        _tableViewFour.mj_header = header;
//        
//        header.lastUpdatedTimeLabel.hidden = YES;
//        
//        [header setTitle:@"下拉刷新" forState:MJRefreshStateIdle];
//        [header setTitle:@"释放更新" forState:MJRefreshStatePulling];
//        [header setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
//        
//        header.stateLabel.font = [UIFont systemFontOfSize:12];
//        header.stateLabel.textColor = [UIColor grayColor];
        
        MJDIYHeader *headert = [MJDIYHeader headerWithRefreshingBlock:^{
            [self refresh:_tableViewFour];
        }];
        _tableViewFour.mj_header = headert;
        
        MJRefreshAutoGifFooter *footer = [MJRefreshAutoGifFooter footerWithRefreshingBlock:^{
            [self loadMoreData:_tableViewFour];
        }];
        //        [footer setImages:<#(NSArray *)#> forState:<#(MJRefreshState)#>]
        
        [footer setTitle:@" " forState:MJRefreshStateIdle];
        [footer setTitle:@"加载中..." forState:MJRefreshStateRefreshing];
        [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        footer.stateLabel.textColor = [UIColor grayColor];
        
        _tableViewFour.mj_footer = footer;
        //        _tableViewThree.mj_footer.hidden = YES;
    }
    return _tableViewFour;
}



- (UIScrollView *)bgScrollView {
    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.tag = 1005;
        _bgScrollView.delegate = self;
    }
    return _bgScrollView;
}

- (NSMutableArray *)dataSourceArrOne {
    if (!_dataSourceArrOne) {
        _dataSourceArrOne = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArrOne;
}

- (NSMutableArray *)dataSourceArrTwo {
    if (!_dataSourceArrTwo) {
        _dataSourceArrTwo = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArrTwo;
}

- (NSMutableArray *)dataSourceArrThree {
    if (!_dataSourceArrThree) {
        _dataSourceArrThree = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArrThree;
}

-  (NSMutableArray *)dataSourceArrFour {
    if (!_dataSourceArrFour) {
        _dataSourceArrFour = [NSMutableArray arrayWithCapacity:0];
    }
    return _dataSourceArrFour;
}

- (UIImageView *)noContentImageViewOne {
    if (!_noContentImageViewOne) {
        _noContentImageViewOne = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content_icon"]];
        _noContentImageViewOne.center = self.tableViewOne.center;
        
        self.labelOne = [[UILabel alloc] initWithFrame:CGRectZero];
        [_noContentImageViewOne addSubview:self.labelOne];
        self.labelOne.textAlignment = NSTextAlignmentCenter;
        self.labelOne.font = [UIFont systemFontOfSize:14];
        self.labelOne.text = @"无出价商品";
        [self.labelOne sizeToFit];
        
//        self.labelOne.backgroundColor = [UIColor grayColor];
    }
    return _noContentImageViewOne;
}

- (UIImageView *)noContentImageViewTwo {
    if (!_noContentImageViewTwo) {
        _noContentImageViewTwo = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content_icon"]];
        _noContentImageViewTwo.center = self.tableViewOne.center;
        
        self.labelTwo = [[UILabel alloc] initWithFrame:CGRectZero];
        [_noContentImageViewTwo addSubview:self.labelTwo];
        self.labelTwo.textAlignment = NSTextAlignmentCenter;
        self.labelTwo.font = [UIFont systemFontOfSize:14];
        self.labelTwo.text = @"无出价中商品";
        [self.labelTwo sizeToFit];

    }
    return _noContentImageViewTwo;
}

- (UIImageView *)nocontentImageViewThree {
    if (!_nocontentImageViewThree) {
        _nocontentImageViewThree = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content_icon"]];
        _nocontentImageViewThree.center = self.tableViewOne.center;
        
        
        self.labelThree = [[UILabel alloc] initWithFrame:CGRectZero];
        [_nocontentImageViewThree addSubview:self.labelThree];
        self.labelThree.textAlignment = NSTextAlignmentCenter;
        self.labelThree.font = [UIFont systemFontOfSize:14];
        self.labelThree.text = @"无出价成功商品";
        
        [self.labelThree sizeToFit];
    }
    return _nocontentImageViewThree;
}

- (UIImageView *)noContentImageViewFour {
    if (!_noContentImageViewFour) {
        _noContentImageViewFour = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content_icon"]];
        _noContentImageViewFour.center = self.tableViewOne.center;
        
        
        self.labelFour = [[UILabel alloc] initWithFrame:CGRectZero];
        [_noContentImageViewFour addSubview:self.labelFour];
        self.labelFour.textAlignment = NSTextAlignmentCenter;
        self.labelFour.font = [UIFont systemFontOfSize:14];
        self.labelFour.text = @"无出价结束商品";
        
        [self.labelFour sizeToFit];
    }
    return _noContentImageViewFour;
}

-(void)setUpUI{
        [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView.mas_centerY);
            make.left.equalTo(self.topView.mas_left).offset(15);
        }];
        [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView.mas_centerY);
            make.left.equalTo(self.btn1.mas_right).offset(20);
        }];
        [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView.mas_centerY);
            make.left.equalTo(self.btn2.mas_right).offset(20);
        }];
        [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.topView.mas_centerY);
            make.left.equalTo(self.btn3.mas_right).offset(20);
        }];
    
        [self.view setNeedsDisplay];
    
    
        if (self.noContentImageViewOne) {
            [self.labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.noContentImageViewOne.mas_centerX);
                make.height.equalTo(@20);
                make.top.equalTo(self.noContentImageViewOne.mas_bottom).offset(+20);
            }];
        }
        if (self.noContentImageViewTwo) {
            [self.labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.noContentImageViewTwo.mas_bottom).offset(+20);
                make.centerX.equalTo(self.noContentImageViewTwo.mas_centerX);
            }];
        }
        if (self.nocontentImageViewThree) {
            [self.labelThree mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.nocontentImageViewThree.mas_centerX);
                make.top.equalTo(self.nocontentImageViewThree.mas_bottom).offset(+20);
            }];
        }
        if (self.noContentImageViewFour) {
            [self.labelFour mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(self.noContentImageViewFour.mas_centerX);
                make.top.equalTo(self.noContentImageViewFour.mas_bottom).offset(+20);
            }];
        }
    
        if (self.btn1.isSelected) {
            self.bottonView.frame = CGRectMake(15, self.btn1.bottom + 4, self.btn1.width, 2);
        }
        if (self.btn2.isSelected) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width + 20 * 1, self.btn2.bottom - 4, self.btn2.width, 2);
        }
        if (self.btn3.isSelected) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width + 20 * 2, self.btn3.bottom - 4, self.btn3.width, 2);
        }
        if (self.btn4.isSelected) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width + 20 * 3, self.btn4.bottom - 4, self.btn4.width, 2);
        }

}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    //适配ios7.0 布局移动到setUpUI中
//    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.topView.mas_centerY);
//        make.left.equalTo(self.topView.mas_left).offset(15);
//    }];
//    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.topView.mas_centerY);
//        make.left.equalTo(self.btn1.mas_right).offset(20);
//    }];
//    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.topView.mas_centerY);
//        make.left.equalTo(self.btn2.mas_right).offset(20);
//    }];
//    [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.topView.mas_centerY);
//        make.left.equalTo(self.btn3.mas_right).offset(20);
//    }];
//    
//    [self.view setNeedsDisplay];
//    
//    
//    if (self.noContentImageViewOne) {
//        [self.labelOne mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.noContentImageViewOne.mas_centerX);
//            make.height.equalTo(@20);
//            make.top.equalTo(self.noContentImageViewOne.mas_bottom).offset(+20);
//        }];
//    }
//    if (self.noContentImageViewTwo) {
//        [self.labelTwo mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.noContentImageViewTwo.mas_bottom).offset(+20);
//            make.centerX.equalTo(self.noContentImageViewTwo.mas_centerX);
//        }];
//    }
//    if (self.nocontentImageViewThree) {
//        [self.labelThree mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.nocontentImageViewThree.mas_centerX);
//            make.top.equalTo(self.nocontentImageViewThree.mas_bottom).offset(+20);
//        }];
//    }
//    if (self.noContentImageViewFour) {
//        [self.labelFour mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.equalTo(self.noContentImageViewFour.mas_centerX);
//            make.top.equalTo(self.noContentImageViewFour.mas_bottom).offset(+20);
//        }];
//    }
//    
//    if (self.btn1.isSelected) {
//        self.bottonView.frame = CGRectMake(15, self.btn1.bottom - 4, self.btn1.width, 2);
//    }
//    if (self.btn2.isSelected) {
//        self.bottonView.frame = CGRectMake(15 + self.btn1.width + 20 * 1, self.btn2.bottom - 4, self.btn2.width, 2);
//    }
//    if (self.btn3.isSelected) {
//        self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width + 20 * 2, self.btn3.bottom - 4, self.btn3.width, 2);
//    }
//    if (self.btn4.isSelected) {
//        self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width + 20 * 3, self.btn4.bottom - 4, self.btn4.width, 2);
//    }

}

-(void)clickBtn1:(UIButton *)sender{
    [self.bgScrollView setContentOffset:CGPointMake(kScreenWidth * 0, 0) animated:YES];
    self.btn1.selected = YES;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    self.btn4.selected = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottonView.frame = CGRectMake(15, self.btn1.bottom - 4, self.btn1.width, 2);
    }];
}
-(void)clickBtn2:(UIButton *)sender{
    [self.bgScrollView setContentOffset:CGPointMake(kScreenWidth * 1, 0) animated:YES];
    self.btn1.selected = NO;
    self.btn2.selected = YES;
    self.btn3.selected = NO;
    self.btn4.selected = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottonView.frame = CGRectMake(15 + self.btn1.width + 20 * 1, self.btn2.bottom - 4, self.btn2.width, 2);
    }];
}
-(void)clickBtn3:(UIButton *)sender{
    [self.bgScrollView setContentOffset:CGPointMake(kScreenWidth * 2, 0) animated:YES];
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = YES;
    self.btn4.selected = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width + 20 * 2, self.btn3.bottom - 4, self.btn3.width, 2);
    }];
}
-(void)clickBtn4:(UIButton *)sender{
    [self.bgScrollView setContentOffset:CGPointMake(kScreenWidth * 3, 0) animated:YES];
    self.btn1.selected = NO;
    self.btn2.selected = NO;
    self.btn3.selected = NO;
    self.btn4.selected = YES;
    [UIView animateWithDuration:0.25 animations:^{
        self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width + 20 * 3, self.btn4.bottom - 4, self.btn4.width, 2);
    }];
}

//- (void)segmentAction:(UISegmentedControl *)segmentt {
//    [UIView animateWithDuration:0.3 animations:^{
//        segmentBottomView.frame = CGRectMake((segmentBottomView.frame.size.width + 16) * segmentt.selectedSegmentIndex + 8, segmentBottomView.frame.origin.y, segmentBottomView.frame.size.width, segmentBottomView.frame.size.height);
//    }];
//    [self.bgScrollView setContentOffset:CGPointMake(kScreenWidth * segmentt.selectedSegmentIndex, 0) animated:YES];
//}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView.tag == 1005) {
        NSString *className = [NSString stringWithFormat:@"btn%.f", scrollView.contentOffset.x / kScreenWidth + 1];
        if ([className isEqualToString:@"btn1"]) {
            self.btn1.selected = YES;
            self.btn2.selected = NO;
            self.btn3.selected = NO;
            self.btn4.selected = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.bottonView.frame = CGRectMake(15, self.btn1.bottom - 4, self.btn1.width, 2);
            }];
        } else if ([className isEqualToString:@"btn2"]) {
            self.btn1.selected = NO;
            self.btn2.selected = YES;
            self.btn3.selected = NO;
            self.btn4.selected = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.bottonView.frame = CGRectMake(15 + self.btn1.width + 20 * 1, self.btn2.bottom - 4, self.btn2.width, 2);
            }];
        } else if ([className isEqualToString:@"btn3"]) {
            self.btn1.selected = NO;
            self.btn2.selected = NO;
            self.btn3.selected = YES;
            self.btn4.selected = NO;
            [UIView animateWithDuration:0.25 animations:^{
                self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width + 20 * 2, self.btn3.bottom - 4, self.btn3.width, 2);
            }];
        } else if ([className isEqualToString:@"btn4"]) {
            self.btn1.selected = NO;
            self.btn2.selected = NO;
            self.btn3.selected = NO;
            self.btn4.selected = YES;
            [UIView animateWithDuration:0.25 animations:^{
                self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width + 20 * 3, self.btn4.bottom - 4, self.btn4.width, 2);
            }];
        }

    }
}


//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView.tag == 1005) {
//        [segment setSelectedSegmentIndex:scrollView.contentOffset.x / kScreenWidth];
//        [UIView animateWithDuration:0.3 animations:^{
//            segmentBottomView.frame = CGRectMake((segmentBottomView.frame.size.width + 16) * segment.selectedSegmentIndex + 8, segmentBottomView.frame.origin.y, segmentBottomView.frame.size.width, segmentBottomView.frame.size.height);
//        }];
//    }
//}


@end
#define kMarginV 5
#define kTextColor [UIColor colorWithHexString:@"595757"]
#define kTextFon [UIFont systemFontOfSize:13]
@implementation didPriceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
        grayView.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];
        
        self.myImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.myImageView.clipsToBounds = YES;
        
        [self.myImageView sizeToFit];
        

        self.myTitleLB = [[UILabel alloc] initWithFrame:CGRectZero];
        self.myTitleLB.font = kTextFon;
        self.myTitleLB.textColor = kTextColor;
        
//        [self.myTitleLB sizeToFit];
        
        self.myNewLB = [[UILabel alloc] initWithFrame:CGRectZero];
        self.myNewLB.font = kTextFon;
        self.myNewLB.textColor = kTextColor;
        
//        [self.myNewLB sizeToFit];
        
        self.countLB = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.countLB.backgroundColor = [UIColor grayColor];
        self.countLB.textAlignment = NSTextAlignmentRight;
        self.countLB.font = kTextFon;
        self.countLB.textColor = kTextColor;
        
//        [self.countLB sizeToFit];
        
        self.sourceLB = [[UILabel alloc] initWithFrame:CGRectZero];
        self.sourceLB.font = kTextFon;
        self.sourceLB.textColor = kTextColor;
        
//        [self.sourceLB sizeToFit];
        
        self.fontPriceLB = [[UILabel alloc] initWithFrame:CGRectZero];
        self.fontPriceLB.font = kTextFon;
        self.fontPriceLB.text = @"我出 ";
        self.fontPriceLB.textAlignment = NSTextAlignmentRight;
        self.fontPriceLB.textColor = kTextColor;
        
//        [self.fontPriceLB sizeToFit];
        
        self.priceLB = [[UILabel alloc] initWithFrame:CGRectZero];
        self.priceLB.textAlignment = NSTextAlignmentRight;
        self.priceLB.font = kTextFon;
        self.priceLB.textColor = [UIColor colorWithHexString:@"c2a79d"];
        
//        [self.priceLB sizeToFit];
        
        self.HXView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.myTitleLB.frame), CGRectGetMaxY(self.sourceLB.frame) + kMarginV + 2, self.myTitleLB.frame.size.width, 1.2)];
        self.HXView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1.000];
        
//        [self.HXView sizeToFit];

        
        self.statusLB = [[UILabel alloc] initWithFrame:CGRectZero];
//        self.statusLB.backgroundColor = [UIColor grayColor];
        self.statusLB.textAlignment = NSTextAlignmentRight;
        self.statusLB.font = kTextFon;
        self.statusLB.textColor = kTextColor;
        
//        [self.sourceLB sizeToFit];
        
        [self.contentView addSubview:grayView];
        [self.contentView addSubview:self.myImageView];
        [self.contentView addSubview:self.myTitleLB];
        [self.contentView addSubview:self.myNewLB];
        [self.contentView addSubview:self.countLB];
        [self.contentView addSubview:self.sourceLB];
        [self.contentView addSubview:self.fontPriceLB];
        [self.contentView addSubview:self.priceLB];
        [self.contentView addSubview:self.HXView];
        [self.contentView addSubview:self.statusLB];
    }
    return self;
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(14+5);
//        make.left.equalTo(self.contentView.mas_left).offset(5);
//        make.width.equalTo(@100);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
//    }];
//    
//}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(14+5);
        make.left.equalTo(self.contentView.mas_left).offset(5);
//        make.width.equalTo(@100);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.width.equalTo(self.myImageView.mas_height);
    }];

    
    [self.myTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(+14+9);
        make.left.equalTo(self.myImageView.mas_right).offset(+19);
        
    }];
    
    [self.myNewLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTitleLB.mas_bottom).offset(+10);
        make.left.equalTo(self.myTitleLB.mas_left);
    }];
    
    [self.countLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-19);
        make.top.equalTo(self.myTitleLB.mas_bottom).offset(+10);
    }];
    
    [self.sourceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myTitleLB.mas_left);
        make.top.equalTo(self.myTitleLB.mas_bottom).offset(+32);
    }];
    
    [self.priceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTitleLB.mas_bottom).offset(+32);
        make.right.equalTo(self.contentView.mas_right).offset(-19);
        
    }];
    
    [self.fontPriceLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLB.mas_left);
        make.top.equalTo(self.myTitleLB.mas_bottom).offset(+32);
    }];
    
//    [self.HXView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.sourceLB.mas_bottom).offset(+14);
//        make.left.equalTo(self.sourceLB.mas_left);
//        make.right.equalTo(self.contentView.mas_right).offset(-19);
//        make.height.equalTo(@1.2);
//    }];
    [self.HXView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_bottom).offset(-33.2);
        make.top.equalTo(self.statusLB.mas_top).offset(-11.2);
        make.left.equalTo(self.myTitleLB.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-19);
        make.height.equalTo(@1.2);
    }];
    
    [self.statusLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-19);
//        make.top.equalTo(self.HXView.mas_bottom).offset(+10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
    }];
    
}

- (void)updataWithModel:(didPriceCellModel *)model {
    
    //动态计算出价LB的宽度
//    NSString *str = [NSString stringWithFormat:@"￥%ld", [model.myBidPrice integerValue]];
//    
//    CGRect rect = [str boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
//    
//    
//    self.fontPriceLB.frame = CGRectMake(self.fontPriceLB.frame.origin.x, self.fontPriceLB.frame.origin.y, CGRectGetWidth(self.myTitleLB.frame) / 2. - rect.size.width, 20);
//    
//    self.priceLB.frame = CGRectMake(CGRectGetMaxX(self.fontPriceLB.frame), CGRectGetMinY(self.fontPriceLB.frame), rect.size.width, CGRectGetHeight(self.fontPriceLB.frame));
    
    NSString *newStr = [NSString stringWithFormat:@""];
    NSInteger j = [model.grade integerValue];
//    NSLog(@"j = %ld", j);
    switch (j) {
        case 1:
            newStr = @"N1";
            break;
        case 5:
            newStr = @"N2";
            break;
        case 2:
            newStr = @"N3";
            break;
        case 7:
            newStr = @"S1";
            break;
        case 3:
            newStr = @"S2";
            break;
        case 6:
            newStr = @"B1";
            break;
        case 4:
            newStr = @"B2";
            break;
        default:
        break;    }
    
    self.myTitleLB.text = [NSString stringWithFormat:@"%@-%@", model.brandName, model.categoryName];
    [self.myImageView setImageWithURL:[model.mainPic objectForKey:@"pic_url"] placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.myNewLB.text = newStr;
    self.sourceLB.text = model.channel;
    self.countLB.text = [NSString stringWithFormat:@"共有%ld次出价", [model.totalBidNum integerValue]];
    self.priceLB.text = [NSString stringWithFormat:@"￥%.2lf", [model.myBidPrice floatValue]];
    NSInteger n = [model.status integerValue];
    switch (n) {
        case 1:
            self.statusLB.text = @"出价中";
            break;
        case 2:
            self.statusLB.text = @"已授权";
            break;
        case 3:
            self.statusLB.text = @"出价结束";
            break;
        default:
            break;
    }

}

- (void)updataWithDic:(NSDictionary *)dic {
    
    //动态计算出价LB的宽度
    NSString *str = [NSString stringWithFormat:@"￥%.2lf", [[dic objectForKey:@"myBidPrice"] floatValue]];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(0, 20) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    
    
    self.fontPriceLB.frame = CGRectMake(self.fontPriceLB.frame.origin.x, self.fontPriceLB.frame.origin.y, CGRectGetWidth(self.myTitleLB.frame) / 2. - rect.size.width, 20);
    
    self.priceLB.frame = CGRectMake(CGRectGetMaxX(self.fontPriceLB.frame), CGRectGetMinY(self.fontPriceLB.frame), rect.size.width, CGRectGetHeight(self.fontPriceLB.frame));

    NSString *newStr = [NSString stringWithFormat:@""];
    NSInteger j = [[dic objectForKey:@"grade"] integerValue];
    switch (j) {
        case 1:
            newStr = @"N1";
            break;
        case 5:
            newStr = @"N2";
            break;
        case 2:
            newStr = @"N3";
            break;
        case 7:
            newStr = @"S1";
            break;
        case 3:
            newStr = @"S2";
            break;
        case 6:
            newStr = @"B1";
            break;
        case 4:
            newStr = @"B2";
            break;
        default:
            break;
    }
    
    self.myTitleLB.text = [NSString stringWithFormat:@"%@-%@", [dic objectForKey:@"brandName"], [dic objectForKey:@"categoryName"]];
    [self.myImageView setImageWithURL:[[dic objectForKey:@"mainPic"] objectForKey:@"pic_url"] placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.myNewLB.text = newStr;
    self.sourceLB.text = [dic objectForKey:@"channel"];
    self.countLB.text = [NSString stringWithFormat:@"共有%ld次出价", [[dic objectForKey:@"totalBidNum"] integerValue]];
    self.priceLB.text = [NSString stringWithFormat:@"￥%.2lf", [[dic objectForKey:@"myBidPrice"] floatValue]];
    NSInteger n = [[dic objectForKey:@"status"] integerValue];
    switch (n) {
        case 1:
            self.statusLB.text = @"出价中";
            break;
        case 2:
            self.statusLB.text = @"已授权";
            break;
        case 3:
            self.statusLB.text = @"出价结束";
            break;
        default:
            break;
    }
    
}

@end

@implementation didPriceCellModel

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary {
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:otherDictionary];
    }
    return self;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"didPriceCellModel序列化赋值有异常:key:%@", key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"didPriceCellModel序列化赋值有异常:value:%@", key);
    return nil;
}

@end
