//
//  BrandViewController.m
//  XianMao
//
//  Created by simon on 2/13/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BrandViewController.h"
#import "PullRefreshTableView.h"
#import "BrandTableViewCell.h"

#import "Error.h"
#import "NetworkAPI.h"

#import "RecommendInfo.h"
#import "SearchViewController.h"
#import "URLScheme.h"

@interface BrandViewController () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) SearchFilterInfo *filterInfo;
@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) HTTPRequest *request;

@end

@implementation BrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"品牌馆"];
    [super setupTopBarBackButton];
    
    _dataSources = [[NSMutableArray alloc] init];
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = YES;
    tableView.showsVerticalScrollIndicator = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self loadData];
}

- (void)loadData
{
    [super showLoadingView];
    WEAKSELF;
    _request = [[NetworkAPI sharedInstance] getBrandRedirectList:^(NSDictionary *data) {
        
        [weakSelf hideLoadingView];
        
        NSString *name = [data stringValueForKey:@"name"];
        [weakSelf setupTopBarTitle:[name length]>0?name:@"品牌馆"];
        
        NSArray *itemsDictArray = [data arrayValueForKey:@"items"];
        if ([itemsDictArray count]>0) {
            [weakSelf.dataSources removeAllObjects];
            
            for (NSInteger i=0;i<[itemsDictArray count];i+=2) {
                NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
                [itemsArray addObject:[RedirectInfo createWithDict:[itemsDictArray objectAtIndex:i]]];
                if (i+1<[itemsDictArray count]) {
                    [itemsArray addObject:[RedirectInfo createWithDict:[itemsDictArray objectAtIndex:i+1]]];
                    [weakSelf.dataSources addObject:[BrandTableViewCell buildCellDict:itemsArray]];
                } else {
                    [weakSelf.dataSources addObject:[BrandTableViewCell buildCellDict:itemsArray]];
                    break;
                }
            }
            [weakSelf.tableView reloadData];

        }
        
    } failure:^(XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf loadData];
            };
        }
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [tableViewCell updateCellWithDict:dict];
    
    ((BrandTableViewCell*)tableViewCell).handleFilterItemTapDetected = ^(RedirectInfo *redirectInfo) {
        [MobClick event:@"click_table_brand"];
        [URLScheme locateWithRedirectUri:redirectInfo.redirectUri andIsShare:NO];
    };
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end
