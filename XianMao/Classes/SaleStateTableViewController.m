//
//  SaleStateTableViewController.m
//  XianMao
//
//  Created by apple on 16/5/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SaleStateTableViewController.h"
#import "PullRefreshTableView.h"
#import "DataListLogic.h"
#import "Session.h"
#import "SepTableViewCell.h"
#import "VerifyModel.h"
#import "VerifyCell.h"
#import "NetworkAPI.h"
#import "TradeService.h"
#import "SoldViewController.h"
#import "OrderTableViewCell.h"
#import "AddressInfo.h"
#import "Session.h"
#import "Masonry.h"
#import "WCAlertView.h"
#import "WebViewController.h"
#import "UserAddressViewController.h"

@interface SaleStateTableViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong) NSMutableArray *mailTypeList;
@property (nonatomic, strong) AddressInfo *addressInfo;

@property (nonatomic, strong) UIView *pickerBackView;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIButton *certainBtn;
@property (nonatomic, strong) UIButton *cancleBtn;
@property (nonatomic, strong) NSMutableArray *receiveNumArr;
@property (nonatomic, strong) NSString *receiveNum;
@property (nonatomic, copy) NSString *goodsId;
@end

@implementation SaleStateTableViewController

-(UIView *)pickerBackView{
    if (!_pickerBackView) {
        _pickerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 215)];
        _pickerBackView.backgroundColor = [UIColor whiteColor];
    }
    return _pickerBackView;
}

-(UIButton *)cancleBtn{
    if (!_cancleBtn) {
        _cancleBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancleBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        _cancleBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_cancleBtn sizeToFit];
    }
    return _cancleBtn;
}

-(UIButton *)certainBtn{
    if (!_certainBtn) {
        _certainBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_certainBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_certainBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        _certainBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_certainBtn sizeToFit];
    }
    return _certainBtn;
}

-(UIPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, kScreenHeight-200, kScreenWidth, 200)];
        _pickerView.backgroundColor = [UIColor whiteColor];
        //        _pickerView.showsSelectionIndicator = YES;
    }
    return _pickerView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero];
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-35);
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithString:@"f1f1ed"];
    [self.view addSubview:self.tableView];
    
    [self.view addSubview:self.pickerBackView];
    self.receiveNumArr = [[NSMutableArray alloc] initWithObjects:@"一个月", @"两个月", @"三个月", @"四个月", @"五个月", @"无期限", nil];
    self.pickerView.dataSource = self;
    self.pickerView.delegate = self;
    [self.pickerBackView addSubview:self.pickerView];
    self.pickerView.frame = CGRectMake(0, self.pickerBackView.height - 200, kScreenWidth, 200);
    [self.pickerBackView addSubview:self.certainBtn];
    [self.pickerBackView addSubview:self.cancleBtn];
    [self.certainBtn addTarget:self action:@selector(clickCertainBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.cancleBtn addTarget:self action:@selector(clickCancelBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.certainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerBackView.mas_top).offset(18);
        make.right.equalTo(self.pickerBackView.mas_right).offset(-31);
    }];
    
    [self.cancleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.certainBtn.mas_top);
        make.left.equalTo(self.pickerBackView.mas_left).offset(31);
    }];

    
//    [self initDataListLogic];
}

- (void)initDataListLogic
{
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"goods/consignment" path:@"selling_goods_list" pageSize:20];
    _dataListLogic.parameters = @{@"user_id":@([Session sharedInstance].currentUserId), @"status":[NSNumber numberWithInteger:self.status]};
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        } else {
            [weakSelf showLoadingView];
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            VerifyModel *verifyModel = [[VerifyModel alloc] initWithJSONDictionary:addedItems[i]];
            [newList addObject:[VerifyCell buildCellDict:verifyModel]];
            [newList addObject:[SepTableViewCell buildCellDict]];
        }
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
        for (int i=0;i<[addedItems count];i++) {
            VerifyModel *verifyModel = [[VerifyModel alloc] initWithJSONDictionary:addedItems[i]];
            [newList addObject:[VerifyCell buildCellDict:verifyModel]];
            [newList addObject:[SepTableViewCell buildCellDict]];
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
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
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
        [weakSelf loadEndWithNoContentWithRetryButton:@"无在售商品"].handleRetryBtnClicked=^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };;
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic firstLoadFromCache];
    
    [weakSelf showLoadingView];
}

- (void)handleTopBarViewClicked {
    [_tableView scrollViewToTop:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [_dataListLogic reloadDataList];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [_dataListLogic nextPage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([tableViewCell isKindOfClass:[VerifyCell class]]) {
        VerifyCell *verifyCell = (VerifyCell *)tableViewCell;
        verifyCell.sendGoods = ^(NSString *goodsId){
            WEAKSELF;
            [weakSelf showProcessingHUD:nil];
            [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getUserAddressList:[Session sharedInstance].currentUserId type:1 completion:^(NSArray *addressDictList) {
                
                if (weakSelf.mailTypeList == nil || [weakSelf.mailTypeList count]==0) {
                    [TradeService listAllExpress:@"" completion:^(NSArray *mailTypeList, AddressInfo *addressInfo) {
                        [weakSelf hideHUD];
                        [DeliverInfoEditView showInView:weakSelf.view.superview.superview isSecuredTrade:YES mailTypeList:mailTypeList addressInfo:addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                            
                            if ([mailSN length]>0 && [mailType length]>0) {
                                NSDictionary *parat = @{@"user_id":@([Session sharedInstance].currentUserId), @"goods_sn":goodsId, @"mailSn":mailSN, @"mailType":mailType};
                                [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"/goods/consignment" path:@"send_goods" parameters:parat completionBlock:^(NSDictionary *data) {
                                    
                                    NSLog(@"%@", data);
                                    
                                } failure:^(XMError *error) {
                                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                } queue:nil]];
                                
                                
                                return YES;
                            } else {
                                if ([mailSN length]==0) {
                                    [weakSelf showHUD:@"请填写快递单号" hideAfterDelay:0.8f];
                                }
                                else if ([mailType length]==0) {
                                    [weakSelf showHUD:@"请选择快递公司" hideAfterDelay:0.8f];
                                }
                                else {
                                    [weakSelf showHUD:@"请填写完成的快递信息" hideAfterDelay:0.8f];
                                }
                                return NO;
                            }
                        }];
                        
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                } else {
                    [weakSelf hideHUD];
                    [DeliverInfoEditView showInView:weakSelf.view.superview.superview isSecuredTrade:YES mailTypeList:_mailTypeList addressInfo:_addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                        
                        if ([mailSN length]>0 && [mailType length]>0) {
                            
                            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"/goods/consignment" path:@"send_goods" parameters:@{@"user_id":@([Session sharedInstance].currentUserId), @"goods_sn":goodsId, @"mailSn":mailSN, @"mailType":mailType} completionBlock:^(NSDictionary *data) {
                                
                                
                            } failure:^(XMError *error) {
                                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                            } queue:nil]];
                            
                            
                            return YES;
                        } else {
                            if ([mailSN length]==0) {
                                [weakSelf showHUD:@"请填写快递单号" hideAfterDelay:0.8f];
                            }
                            else if ([mailType length]==0) {
                                [weakSelf showHUD:@"请选择快递公司" hideAfterDelay:0.8f];
                            }
                            else {
                                [weakSelf showHUD:@"请填写完成的快递信息" hideAfterDelay:0.8f];
                            }
                            return NO;
                        }
                    }];
                }
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
            }]];
        };
        
        verifyCell.lookLogistics = ^(VerifyModel *verifyModel){
            if (verifyModel.systemStatus == 6) {
                [weakSelf showHUD:@"暂无物流信息" hideAfterDelay:0.8];
            } else {
                WebViewController *webview = [[WebViewController alloc] init];
                webview.url = [NSString stringWithFormat:@"http://activity.aidingmao.com/tools/mailinfo?mail_type=%@&mail_sn=%@", verifyModel.mailType, verifyModel.mailSn];
                [weakSelf pushViewController:webview animated:YES];
            }
        };
        
        verifyCell.surePutaway = ^(NSString *goodsId){
            weakSelf.goodsId = goodsId;
            [weakSelf appearPickerBackView];
        };
        
        verifyCell.sendBackGoods = ^(NSString *goodsId){
            weakSelf.goodsId = goodsId;
            [weakSelf showProcessingHUD:nil];
            [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getUserAddressList:[Session sharedInstance].currentUserId type:1 completion:^(NSArray *addressDictList) {
                
                if ([addressDictList count]>0) {
                    
                    NSDictionary *param = @{@"user_id" : @([Session sharedInstance].currentUserId), @"goods_sn" : self.goodsId};
                    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods/consignment" path:@"send_up_back" parameters:param completionBlock:^(NSDictionary *data) {
                        
                        [weakSelf showHUD:@"申请寄回成功" hideAfterDelay:0.8];
                        [weakSelf initDataListLogic];
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
                    } queue:nil]];
                    
                } else {
                    [weakSelf hideHUD];
                    [WCAlertView showAlertWithTitle:@""
                                            message:@"请添加退货地址"
                                 customizationBlock:^(WCAlertView *alertView) {
                                     alertView.style = WCAlertViewStyleWhite;
                                 } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                                     if (buttonIndex == 0) {
                                         
                                     } else {
                                         UserAddressViewController *viewController = [[UserAddressViewControllerReturn alloc] init];
                                         [weakSelf pushViewController:viewController animated:YES];
                                     }
                                 } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
                }
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
            }]];
        };
        
        verifyCell.affirmGoods = ^(NSString *goodsId){
            [WCAlertView showAlertWithTitle:@"提示" message:@"您确定已经收到了货品吗" customizationBlock:^(WCAlertView *alertView) {
                
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                
                if (buttonIndex == 1) {
                    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods/consignment" path:@"confirm_goods_receipt" parameters:@{@"goods_sn":goodsId, @"user_id":@([Session sharedInstance].currentUserId)} completionBlock:^(NSDictionary *data) {
                        
                        [weakSelf showHUD:@"确认收货成功" hideAfterDelay:0.8];
                        [weakSelf initDataListLogic];
                        
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
                    } queue:nil]];
                }
                
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        };
    }
    
    [tableViewCell updateCellWithDict:dict];
    return tableViewCell;
}

-(void)setPushNews{
    if (!self.receiveNum) {
        [self showHUD:@"请选择寄卖日期" hideAfterDelay:0.8];
    }
    WEAKSELF;
    NSInteger time;
    if ([self.receiveNum isEqualToString:@"一个月"]) {
        time = 1;
    } else if ([self.receiveNum isEqualToString:@"两个月"]) {
        time = 2;
    } else if ([self.receiveNum isEqualToString:@"三个月"]) {
        time = 3;
    }  else if ([self.receiveNum isEqualToString:@"四个月"]) {
        time = 4;
    } else if ([self.receiveNum isEqualToString:@"五个月"]) {
        time = 5;
    } else if ([self.receiveNum isEqualToString:@"无限期"]) {
        time = 0;
    }
    NSDictionary *param = @{@"user_id" : @([Session sharedInstance].currentUserId), @"goods_sn" : self.goodsId, @"sell_time" : @(time)};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"goods/consignment" path:@"confirm_put_away" parameters:param completionBlock:^(NSDictionary *data) {
        
        [weakSelf showHUD:@"申请上架成功" hideAfterDelay:0.8];
        [weakSelf initDataListLogic];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
    
}

-(void)clickCertainBtn{
    [self setPushNews];
    [self dismissPickerBackView];
}

-(void)clickCancelBtn{
    [self dismissPickerBackView];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissPickerBackView];
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return self.receiveNumArr.count;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    //    NSNumber *num = [self.receiveNumArr objectAtIndex:row];
    //    if ([num isEqualToNumber:@0]) {
    //        return @"不限";
    //    } else {
    return [NSString stringWithFormat:@"%@", [self.receiveNumArr objectAtIndex:row]];
    //    }
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    self.receiveNum = [self.receiveNumArr objectAtIndex:row];
    NSLog(@"%@", self.receiveNum);
}

-(void)appearPickerBackView{
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBackView.frame = CGRectMake(0, kScreenHeight - 315, kScreenWidth, 315);
    }];
}

-(void)dismissPickerBackView{
    [UIView animateWithDuration:0.25 animations:^{
        self.pickerBackView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 215);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

@end
