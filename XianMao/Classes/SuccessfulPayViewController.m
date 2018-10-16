//
//  SuccessfulPayViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SuccessfulPayViewController.h"
#import "PullRefreshTableView.h"
#import "FreightStatusCell.h"
#import "HandsetCell.h"
#import "SepTableViewCell.h"
#import "PayPricesCell.h"
#import "SepTableViewCell.h"
#import "OrderFavortTitleCell.h"
#import "Error.h"

#import "GoodsService.h"
#import "RecommendTableViewCell.h"

@interface SuccessfulPayViewController ()<PullRefreshTableViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSources;
@property (nonatomic, strong) NSMutableArray *goodsRecommendList;

@property (nonatomic, strong) OrderDetailInfo *orderDetailInfo;
@end

@implementation SuccessfulPayViewController

-(NSMutableArray *)goodsRecommendList{
    if (!_goodsRecommendList) {
        _goodsRecommendList = [[NSMutableArray alloc] init];
    }
    return _goodsRecommendList;
}

-(NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, self.topBarHeight, kScreenWidth, kScreenHeight-self.topBarHeight)];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.enableLoadingMore = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarTitle:@"支付成功"];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton:[UIImage imageNamed:@"more_wjh"] imgPressed:nil];
    
    if (self.goodsId) {
        WEAKSELF;
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"trade" path:@"goods_last_order" parameters:@{@"goods_sn":self.goodsId} completionBlock:^(NSDictionary *data) {
            
            OrderDetailInfo *detailInfo = [[OrderDetailInfo alloc] initWithDict:data[@"order_detail"]];
            weakSelf.orderDetailInfo = detailInfo;
            [weakSelf loadRecommandGoods];
            
        } failure:^(XMError *error) {
            
        } queue:nil]];
    
    }
    
}


-(void)loadData
{
    [self.dataSources removeAllObjects];
    [self.dataSources addObject:[FreightStatusCell buildCellDict]];
    [self.dataSources addObject:[OrderTabViewCellSmallTwo buildCellDict]];
    [self.dataSources addObject:[HandsetCell buildCellDict:self.orderDetailInfo.addressInfo]];
    [self.dataSources addObject:[OrderTabViewCellSmallTwo buildCellDict]];
    [self.dataSources addObject:[PayPricesCell buildCellDict:self.orderDetailInfo]];
    [self.dataSources addObject:[SepTableViewCell buildCellDict]];
    if ([self.goodsRecommendList count]>0) {
        [self.dataSources addObject:[OrderFavortTitleCell buildCellTitle:@"你可能还喜欢的"]];
//        [self.dataSources addObject:[GoodsRecommendSepCell buildCellDict]];
        for (NSInteger i=0;i<[self.goodsRecommendList count];i++) {
            
            NSArray *array = [self.goodsRecommendList objectAtIndex:i];
            [self.dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
            
            [self.dataSources addObject:[SepTwoTableViewCell buildCellDict]];
        }
    }
}

- (void)loadRecommandGoods {
    WEAKSELF;
    if (self.goodsId) {
        [self showLoadingView];
        [GoodsService recommend_goods:self.goodsId completion:^(NSArray *goods_list) {
            [self hideLoadingView];
            NSMutableArray *goodsRecommendList = [[NSMutableArray alloc] init];
            for (NSInteger i=0;i<[goods_list count];i+=2) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                [array addObject:[goods_list objectAtIndex:i]];
                if (i+1>=[goods_list count]) {
                    [goodsRecommendList addObject:array];
                    break;
                }
                [array addObject:[goods_list objectAtIndex:i+1]];
                [goodsRecommendList addObject:array];
            }
            
            weakSelf.goodsRecommendList = goodsRecommendList;
            
            [weakSelf.view addSubview:weakSelf.tableView];
            [weakSelf loadData];
            [self.tableView reloadData];
            
            return;
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
            
            return ;
        }];
        
    }
    
    if(self.orderDetailInfo) {
        if (weakSelf.orderDetailInfo.orderInfo.goodsList.count > 0) {
            GoodsInfo *goodsInfo = self.orderDetailInfo.orderInfo.goodsList[0];
            [GoodsService recommend_goods:goodsInfo.goodsId completion:^(NSArray *goods_list) {
                
                NSMutableArray *goodsRecommendList = [[NSMutableArray alloc] init];
                for (NSInteger i=0;i<[goods_list count];i+=2) {
                    NSMutableArray *array = [[NSMutableArray alloc] init];
                    [array addObject:[goods_list objectAtIndex:i]];
                    if (i+1>=[goods_list count]) {
                        [goodsRecommendList addObject:array];
                        break;
                    }
                    [array addObject:[goods_list objectAtIndex:i+1]];
                    [goodsRecommendList addObject:array];
                }
                
                weakSelf.goodsRecommendList = goodsRecommendList;
                
                [weakSelf.view addSubview:weakSelf.tableView];
                [weakSelf loadData];
                [self.tableView reloadData];
                
                return;
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
                
                return;
            }];
            
        }
    }
    
}

-(void)getOrderDetailInfo:(OrderDetailInfo *)orderDetailInfo{
    self.orderDetailInfo = orderDetailInfo;
    [self loadRecommandGoods];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [clsTableViewCell rowHeightForPortrait:dict];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString * reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell * Cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (Cell == nil) {
        Cell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        Cell.backgroundColor = [UIColor whiteColor];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    [Cell updateCellWithDict:dict];
    return Cell;
}

@end
