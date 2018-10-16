//
//  RecoverLisdTableViewController.m
//  XianMao
//
//  Created by apple on 16/3/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverLisdTableViewController.h"
#import "PullRefreshTableView.h"
#import "DataListLogic.h"
#import "BaseTableViewCell.h"
#import "SepTableViewCell.h"
#import "RecoverGoodsController.h"
#import "RecoveryGoodsVo.h"

#import "NSString+URLEncoding.h"
#import "JSONKit.h"
#import "JSONModel.h"
#import "JSONModelProperty.h"
#import "Error.h"

#import "RecoveryListGoodsCell.h"
//更换单行cell
#import "RecoveryDanListGoodsCell.h"

#import "OfferedViewController.h"

@interface RecoverLisdTableViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>



@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong) NSMutableArray *fondArr;

@property (nonatomic, assign) CGFloat topBarHeigth;
@end

@implementation RecoverLisdTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.qk = @"createTime";
    self.qv = @"DESC";
    CGFloat topBarHeigth = [super setupTopBar];
    self.topBarHeigth = topBarHeigth;
    self.topBar.hidden = YES;
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - topBarHeigth - 42  - 138) style:UITableViewStylePlain];
    self.tableView = tableView;
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];//@"F7F7F7"
    [self.view addSubview:tableView];
    
    [self loadData];
    [self.fondArr removeAllObjects];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPreferenceInJsonArr:) name:@"getPreferenceInJsonArr" object:nil];
    
}

-(void)getJsonArr:(NSMutableArray *)arr{
    if (arr) {
        self.fondArr = arr;
        [self initDataListLogic];
    } else {
        self.fondArr = nil;
        [self initDataListLogic];
    }
}

-(void)getPreferenceInJsonArr:(NSNotification *)notify{
    id fondArr = notify.object;
    //如果object == 1, 是所有
    if ([fondArr isKindOfClass:[NSMutableArray class]]) {
        self.fondArr = fondArr;
    } else {
        self.fondArr = nil;
//        [self initDataListLogic];
    }
//    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    if (self.dataSources.count % 2 == 0) {
//        return self.dataSources.count / 2;
//    } else {
//        return self.dataSources.count / 2 + 1;
//    }
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
//    if ([tableViewCell isKindOfClass:[RecoveryListGoodsCell class]]) {
//        RecoveryListGoodsCell *listGoodsCell = (RecoveryListGoodsCell *)tableViewCell;
//        [listGoodsCell updateCellWithDict:dict];
//        WEAKSELF;
//        listGoodsCell.pushGoodsDetailController = ^(NSString *goods_id){
//            OfferedViewController *offeredViewController = [[OfferedViewController alloc] init];
//            offeredViewController.goodID = goods_id;
//            [weakSelf pushViewController:offeredViewController animated:YES];
//        };
//        
//    }
    
    if ([tableViewCell isKindOfClass:[RecoveryDanListGoodsCell class]]) {
        RecoveryDanListGoodsCell *listGoodsCell = (RecoveryDanListGoodsCell *)tableViewCell;
        [listGoodsCell updateCellWithDict:dict];
    }
    
//    static NSString *ID = @"Cell";
//    RecoveryListGoodsCell *tableViewCell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!tableViewCell) {
//        tableViewCell = [[RecoveryListGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    RecoveryGoodsVo *goodsVO = dict[@"recoveryGoodsVO"];
    BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[RecoveryDanListGoodsCell class]]) {
        OfferedViewController *offeredViewController = [[OfferedViewController alloc] init];
        offeredViewController.goodID = goodsVO.goodsSn;
        
        NSDictionary *data = @{@"goodsId":goodsVO.goodsSn};
        switch (self.seletedIndex) {
            case 0:
                [self client:RecoveryGoodsNewViewCode data:data];
                break;
            case 1:
                [self client:RecoveryGoodsHotViewCode data:data];
                break;
            case 2:
                [self client:RecoveryGoodsDownViewCode data:data];
                break;
            default:
                break;
        }
        
        [self pushViewController:offeredViewController animated:YES];
    }
}

-(void)client:(NSInteger)regionCode data:(NSDictionary *)data{
    [ClientReportObject clientReportObjectWithViewCode:RecoveryGoodsNewViewCode regionCode:regionCode referPageCode:regionCode andData:data];
}

- (void)handleTopBarViewClicked {
    [_tableView scrollViewToTop:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
    
    CGFloat scrollIndex = scrollView.contentOffset.y;
    if ([self.recovertListDelegate respondsToSelector:@selector(changeTableViewHeight:)]) {
        [self.recovertListDelegate changeTableViewHeight:scrollIndex];
    }
    
    if (scrollIndex > 500) {
        if (scrollIndex >= 0+500 && scrollIndex < 545+500) {
            self.tableView.frame = CGRectMake(0, -(scrollIndex-500)/4, kScreenWidth, kScreenHeight - self.topBarHeigth - 42  - 138 + (scrollIndex-500)/4);
        }
    } else {
        self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - self.topBarHeigth - 42  - 138);
    }
    
}

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [_dataListLogic reloadDataListByForce];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [_dataListLogic nextPage];
}

- (void)initDataListLogic {
    WEAKSELF;
    
    NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
    [paramsDict setObject:self.qk forKey:@"qk"];
    [paramsDict setObject:self.qv forKey:@"qv"];
    [paramsArray addObject:paramsDict];
    for (int i = 0; i < self.fondArr.count; i++) {
        NSDictionary *dict = self.fondArr[i];
        NSMutableDictionary *paramsDict = [[NSMutableDictionary alloc] init];
        [paramsDict setObject:dict[@"qk"] forKey:@"qk"];
        [paramsDict setObject:dict[@"qv"] forKey:@"qv"];
        [paramsArray addObject:paramsDict];
    }
    
//    NSString *paramsJsonData = [[[paramsArray toJSONArray] JSONString] URLEncodedString];
//    _dataListLogic = [[DataListLogic alloc] init];
    
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"recovery" path:@"list" pageSize:20];
    _dataListLogic.isPOST = YES;
    _dataListLogic.parameters = @{@"params" : paramsArray};
    
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        } else {
//            [weakSelf showLoadingView];
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        NSLog(@"%@", addedItems);
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0; i<[addedItems count]; i++) { //i+=2
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            //更换单行显示cell
            [newList addObject:[RecoveryDanListGoodsCell buildCellDict:[[RecoveryGoodsVo alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]] andCellDictTwo:nil]];
//                if (addedItems.count % 2 != 0 && i + 1 == addedItems.count) {
//                    [newList addObject:[RecoveryListGoodsCell buildCellDict:[[RecoveryGoodsVo alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]] andCellDictTwo:nil]];
//                } else {
//                    [newList addObject:[RecoveryListGoodsCell buildCellDict:[[RecoveryGoodsVo alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]] andCellDictTwo:[[RecoveryGoodsVo alloc] initWithJSONDictionary:[addedItems objectAtIndex:i+1]]]];
//                }
//                NSLog(@"%d", i);
            }
//        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
            NSLog(@"%ld, %@", (unsigned long)addedItems.count, addedItems);
            for (int i = 0; i < addedItems.count; i++) { //i+=2
                if (i>0) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                //更换单行显示cell
                [newList addObject:[RecoveryDanListGoodsCell buildCellDict:[[RecoveryGoodsVo alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]] andCellDictTwo:nil]];
//                if (addedItems.count % 2 != 0 && i + 1 == addedItems.count) {
//                    [newList addObject:[RecoveryListGoodsCell buildCellDict:[[RecoveryGoodsVo alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]] andCellDictTwo:nil]];
//                } else {
//                    [newList addObject:[RecoveryListGoodsCell buildCellDict:[[RecoveryGoodsVo alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]] andCellDictTwo:[[RecoveryGoodsVo alloc] initWithJSONDictionary:[addedItems objectAtIndex:i+1]]]];
//                }
            }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                [newList insertObject:[SepTableViewCell buildCellDict] atIndex:0];
            }
            [dataSources addObjectsFromArray:newList];
            
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithErrorNotTopBar].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButtonNotTopBar:@"无在售商品"].handleRetryBtnClicked=^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };;
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic firstLoadFromCache];
    
    [weakSelf showLoadingViewNotTopBar];
}

- (void)loadData {
    WEAKSELF;
    
    if ([weakSelf.dataSources count]>0) {
        NSDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        //if (ClsTableViewCell!=[ForumPostListNoContentTableCell class]) {
        weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        // }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.dataListLogic) {
            [weakSelf.dataListLogic reloadDataListByForce];
        } else {
            [weakSelf initDataListLogic];
        }
    });
}

@end
