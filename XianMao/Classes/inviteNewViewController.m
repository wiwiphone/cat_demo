//
//  inviteNewViewController.m
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "inviteNewViewController.h"
#import "Command.h"
#import "PullRefreshTableView.h"
#import "BaseTableViewCell.h"
#import "DataListLogic.h"
#import "Error.h"

#import "InviteHeaderTableViewCell.h"
#import "ReceiveCell.h"
#import "InviteNumCell.h"
#import "AnnotateCell.h"
#import "SepTableViewCell.h"
#import "MoneyReceiveCell.h"
#import "ReceivePersonCell.h"
#import "InvitationPersonNumCell.h"

#import "WCAlertView.h"
#import "Session.h"
#import "InvitationVo.h"
#import "InvitationUserVo.h"
#import "UMSocialData.h"
#import "UMSocialDataService.h"
#import "UMSocialSnsPlatformManager.h"
@interface inviteNewViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) CommandButton *backBtn;
@property (nonatomic, strong) CommandButton *backBgBtn;
@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) NSMutableArray *list;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) InvitationVo *invitationVo;

@property (nonatomic, assign) NSInteger is_received;
@end

@implementation inviteNewViewController

-(NSMutableArray *)list{
    if (!_list) {
        _list = [[NSMutableArray alloc] init];
    }
    return _list;
}

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

-(CommandButton *)backBgBtn{
    if (!_backBgBtn) {
        _backBgBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _backBgBtn.backgroundColor = [UIColor clearColor];
    }
    return _backBgBtn;
}

-(CommandButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_backBtn setImage:[UIImage imageNamed:@"back_button-white"] forState:UIControlStateNormal];
        [_backBtn sizeToFit];
    }
    return _backBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    WEAKSELF;
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"invitation" path:@"detail" parameters:nil completionBlock:^(NSDictionary *data) {
        
        InvitationVo *invaVo = [[InvitationVo alloc] initWithJSONDictionary:data];
        weakSelf.invitationVo = invaVo;
        
        weakSelf.is_received = invaVo.hasReceived;
        [weakSelf.view addSubview:weakSelf.tableView];
        [weakSelf.view addSubview:weakSelf.backBtn];
        [weakSelf.view addSubview:weakSelf.backBgBtn];
        
        weakSelf.backBgBtn.handleClickBlock = ^(CommandButton *sender){
            [weakSelf dismiss];
        };
        [weakSelf setUpUI];
        [weakSelf loadCell];
        [weakSelf loadData];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.6];
    } queue:nil]];
    
}

-(void)loadCell{
    User *user = [Session sharedInstance].currentUser;
    [self.dataSources addObject:[InviteHeaderTableViewCell buildCellDict:user]];
    if (self.is_received == 0) {//1 隐藏
        [self.dataSources addObject:[ReceiveCell buildCellDict:self.invitationVo]];
    }
    [self.dataSources addObject:[SepWhiteTableViewCell1 buildCellDict]];
    [self.dataSources addObject:[AnnotateCell buildCellDict:self.invitationVo]];
    [self.dataSources addObject:[InviteNumCell buildCellDict:self.invitationVo]];
    [self.dataSources addObject:[SepTableViewCell buildCellDict]];
//    [self.dataSources addObject:[MoneyReceiveCell buildCellDict:self.invitationVo]];
    [self.dataSources addObject:[InvitationPersonNumCell buildCellDict:self.invitationVo]];
    [self.dataSources addObject:[SepTableViewCell buildCellDict]];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    WEAKSELF;
    if ([tableViewCell isKindOfClass:[ReceiveCell class]]) {
        ReceiveCell *cell = (ReceiveCell *)tableViewCell;
        cell.handleRecriveBtn = ^(NSDictionary *dict){
            [WCAlertView showAlertWithTitle:@"" message:dict[@"title"] customizationBlock:^(WCAlertView *alertView) {
                
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex == 0) {
                    weakSelf.is_received = (long)dict[@"is_received"];
                    [weakSelf loadData];
                    [weakSelf.tableView reloadData];
                }
            } cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        };
    }
    
    if ([tableViewCell isKindOfClass:[InviteNumCell class]]) {
        InviteNumCell * cell = (InviteNumCell *)tableViewCell;
        
        cell.handleQQshareBlock = ^(CommandButton * sender){
            [weakSelf share:self.invitationVo.share.redirect_uri title:self.invitationVo.share.title shareName:UMShareToQQ content:self.invitationVo.share.subtitle image:[UIImage imageNamed:@"AppIcon_120"]];
        };
        
        cell.handlewecatShareBlock = ^(CommandButton * sender){
            [weakSelf share:self.invitationVo.share.redirect_uri title:self.invitationVo.share.title shareName:UMShareToWechatSession content:self.invitationVo.share.subtitle image:[UIImage imageNamed:@"AppIcon_120"]];
        };
        
        cell.handlemoreShareBlock = ^(CommandButton * sender){
            [[CoordinatingController sharedInstance] shareWithTitle:self.invitationVo.share.title
                                                              image:[UIImage imageNamed:@"AppIcon_120"]
                                                                url:self.invitationVo.share.redirect_uri
                                                            content:self.invitationVo.share.subtitle];
        };
    }
    
    [tableViewCell updateCellWithDict:dict];
    return tableViewCell;
}

-(void)share:(NSString *)url
       title:(NSString *)title
   shareName:(NSString *)shareName
     content:(NSString *)content
       image:(UIImage *)image{
    
    
    /*设置微信好友*/
    [UMSocialData defaultData].extConfig.wechatSessionData.title = title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    /*设置QQ*/
    [UMSocialData defaultData].extConfig.qqData.title = title;
    [UMSocialData defaultData].extConfig.qqData.url = url;
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeDefault;
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:url];
    //            NSMutableArray *arr = [NSMutableArray arrayWithArray:shareToSnsNames];
    //            [arr removeObject:@"ShareCopy"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareName] content:content image:image location:nil urlResource:nil presentedController:[CoordinatingController sharedInstance].visibleController completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

-(void)setUpUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(30);
        make.left.equalTo(self.view.mas_left).offset(15);
    }];
    
    [self.backBgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(20);
        make.left.equalTo(self.view.mas_left).offset(5);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
    }];
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

- (void)initDataListLogic {
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"invitation" path:@"list" pageSize:20];
//    _dataListLogic.parameters = @{@"keywords":@"",@"params":self.params?self.params:@""};
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
        
        [weakSelf.dataSources removeObjectsInArray:weakSelf.list];
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        if ([newList count]>0) {
            
        }
        
        for (int i=0;i<[addedItems count];i++) {
//            [newList addObject:[IdleTableViewCell buildCellDict:[GoodsInfo createWithDict:addedItems[i]]]];
//            [newList addObject:[IdleSegCell buildCellDict]];
            InvitationUserVo *invUserVo = [[InvitationUserVo alloc] initWithJSONDictionary:addedItems[i]];
            [newList addObject:[ReceivePersonCell buildCellDict:invUserVo]];
            [newList addObject:[SepLeftTableViewCell1 buildCellDict]];
        }
        
        weakSelf.list = newList;
        [weakSelf.dataSources addObjectsFromArray:weakSelf.list];
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
//            [newList addObject:[IdleTableViewCell buildCellDict:[GoodsInfo createWithDict:addedItems[i]]]];
//            [newList addObject:[IdleSegCell buildCellDict]];
            InvitationUserVo *invUserVo = [[InvitationUserVo alloc] initWithJSONDictionary:addedItems[i]];
            [newList addObject:[ReceivePersonCell buildCellDict:invUserVo]];
            [newList addObject:[SepLeftTableViewCell1 buildCellDict]];
        }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.list];
            if ([dataSources count]>0) {
                [weakSelf.dataSources removeObjectsInArray:weakSelf.list];
            }
            [weakSelf.list addObjectsFromArray:newList];
            
            [weakSelf.dataSources addObjectsFromArray:weakSelf.list];
            [weakSelf.tableView reloadData];
        }
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
//            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
//                [weakSelf.dataListLogic reloadDataListByForce];
//            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
//        [weakSelf loadEndWithNoContentWithRetryButton:@""].handleRetryBtnClicked=^(LoadingView *view) {
//            [weakSelf.dataListLogic reloadDataListByForce];
//        };;
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    [_dataListLogic firstLoadFromCache];
    
    //    [weakSelf showLoadingView];
}


@end
