//
//  RecoverDetailViewController.m
//  XianMao
//
//  Created by apple on 16/2/1.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverDetailViewController.h"
#import "PullRefreshTableView.h"
#import "NetworkAPI.h"
#import "MainPic.h"
#import "RecoveryGoodsVo.h"
#import "BaseTableViewCell.h"

#import "RecoverDetailTableViewCell.h"
#import "RecoverSegTableViewCell.h"
#import "RecoverTitleCell.h"
#import "RecoverImageCell.h"
#import "RecoverFirstImageCell.h"
#import "RecoverDetailTopCell.h"

#import "OfferedViewController.h"
#import "InsureViewController.h"

#import "Session.h"
#import "GoodsMemCache.h"
#import "GoodsInfo.h"
#import "BottomView.h"
#import "ForumService.h"

#import "Error.h"
#import "Masonry.h"
#import "RecoverDateCell.h"

@interface RecoverDetailViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) MainPic *mainPic;
@property (nonatomic, strong) RecoveryGoodsVo *recoveryGoodsVO;
@property (nonatomic, strong) HighestBidVo *authBidVO;
@property (nonatomic, strong) RecoveryGoodsDetail *goodsDetail;
@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong) BottomView *bottomView;
@property (nonatomic, strong) UIButton *supportBtn;
@property (nonatomic, strong) UIView *segView;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, assign) BOOL isLike;

@property (nonatomic, strong) UIView *topDateView;
@property (nonatomic, strong) UILabel *timeLabel;

@end

@implementation RecoverDetailViewController

- (UIView *)topDateView {
    if (!_topDateView) {
        _topDateView = [[UIView alloc] initWithFrame:CGRectZero];
        
        UIButton *timeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [timeBtn setImage:[UIImage imageNamed:@"recover_time_MF"] forState:UIControlStateNormal];
        [timeBtn setTitleColor:[UIColor colorWithHexString:@"9fa0a0"] forState:UIControlStateNormal];
        [timeBtn setTitle:@"出价时间仅剩 " forState:UIControlStateNormal];
        timeBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [timeBtn sizeToFit];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLabel.font = [UIFont systemFontOfSize:14];
        _timeLabel.textColor = [UIColor colorWithHexString:@"c2a79d"];
//        _timeLabel
        [_timeLabel sizeToFit];
        
        
        [_topDateView addSubview:timeBtn];
        [_topDateView addSubview:_timeLabel];
    }
    return _topDateView;
}

-(UIButton *)buyButton{
    if (!_buyButton) {
        _buyButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buyButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_buyButton setTitle:@"确认出价" forState:UIControlStateNormal];
        _buyButton.titleLabel.textAlignment = NSTextAlignmentCenter;
//        _buyButton.backgroundColor = [UIColor orangeColor];
//        [_buyButton sizeToFit];
    }
    return _buyButton;
}

-(UIView *)segView{
    if (!_segView) {
        _segView = [[UIView alloc] initWithFrame:CGRectZero];
        _segView.backgroundColor = [UIColor colorWithHexString:@"c19f66"];
    }
    return _segView;
}

-(UIButton *)supportBtn{
    if (!_supportBtn) {
        _supportBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_supportBtn setImage:[UIImage imageNamed:@"support_recover_N_MF"] forState:UIControlStateNormal];
        [_supportBtn setImage:[UIImage imageNamed:@"support_recover_MF"] forState:UIControlStateSelected];
        _supportBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 20);
        
    }
    return _supportBtn;
}

-(BottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[BottomView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    }
    return _tableView;
}

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [super setupTopBar];
    [super setupTopBarTitle:@"商品信息"];
    [super setupTopBarBackButton];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = NO;
    self.tableView.enableLoadingMore = NO;
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.bottomView];
    [self.bottomView addSubview:self.supportBtn];
    [self.bottomView bringSubviewToFront:self.view];
    [self.bottomView addSubview:self.segView];
    [self.bottomView addSubview:self.buyButton];
    
    
    
    if (self.index == 2) {
        self.bottomView.hidden = YES;
    } else {
        self.bottomView.hidden = NO;
    }
    
    [self.buyButton addTarget:self action:@selector(clickBuyButton) forControlEvents:UIControlEventTouchUpInside];
    [self.supportBtn addTarget:self action:@selector(clickSupportBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadData];
    [self setUpUI];
}

-(void)clickSupportBtn{
    WEAKSELF;
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{
        
    }];
    if (!isLoggedIn) {
        return;
    }
    
    if (self.supportBtn.selected == NO) {
        self.isLike = YES;
        self.supportBtn.selected = YES;
    } else if (self.supportBtn.selected == YES) {
        self.isLike = NO;
        self.supportBtn.selected = NO;
    }
    
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] likeGoods:self.goodsID isLike:self.isLike completion:^(NSInteger likeNum, User *likedUser) {
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }]];
}

-(void)clickBuyButton{
    //添加已售出逻辑
    if (self.goodsDetail.authBidVo) {
        HighestBidVo *authBidVo = self.goodsDetail.authBidVo;
        if (authBidVo.payId) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"商品已售出" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
    }
    
    OfferedViewController *offeredConroller = [[OfferedViewController alloc] init];
    offeredConroller.goodID = self.goodsID;
    [offeredConroller getExprtime:self.recoveryGoodsVO andAuthBidVO:self.authBidVO];
    [self pushViewController:offeredConroller animated:YES];
}

-(void)loadData{
    WEAKSELF;
    if (!self.goodsID) {
        return;
    }
    [self showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getRecoverGoodsDetail:self.goodsID completion:^(NSDictionary *dict) {
        [self hideLoadingView];
        
        RecoveryGoodsDetail *goodsDetail = [[RecoveryGoodsDetail alloc] initWithJSONDictionary:dict];
        if (goodsDetail) {
            self.goodsDetail = goodsDetail;
        }
        
        HighestBidVo *authBidVO = [[HighestBidVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"authBidVo"]];
        if (authBidVO) {
            self.authBidVO = authBidVO;
            if (authBidVO.userId == [Session sharedInstance].currentUserId) {
                [_buyButton setTitle:@"立即下单" forState:UIControlStateNormal];
            }
        } else {
            [_buyButton setTitle:@"出价收购" forState:UIControlStateNormal];
        }
        
        NSDictionary *mainP = dict[@"recoveryGoodsVo"];
        MainPic *mainPic = [[MainPic alloc] initWithJSONDictionary:[mainP dictionaryValueForKey:@"mainPic"]];
        self.mainPic = mainPic;
        RecoveryGoodsVo *recoveryGoodsVO = [[RecoveryGoodsVo alloc] initWithJSONDictionary:[dict dictionaryValueForKey:@"recoveryGoodsVo"]];
        self.recoveryGoodsVO = recoveryGoodsVO;
        
        if (self.index == 2) {
            [self.dataSources addObject:[RecoverDetailTopCell buildCellDict:recoveryGoodsVO]];
        } else {
            //add code
//            [self.dataSources addObject:[RecoverDateCell buildCellDict:recoveryGoodsVO]];
            
            
            [self.dataSources addObject:[RecoverDetailTableViewCell buildCellDict:recoveryGoodsVO]];
        }
        [self.dataSources addObject:[RecoverSegTableViewCell buildCellDict]];
        [self.dataSources addObject:[RecoverTitleCell buildCellDict:recoveryGoodsVO]];
        [self.dataSources addObject:[RecoverFirstImageCell buildCellDict:recoveryGoodsVO]];
        if (recoveryGoodsVO.is_liked == 1) {
            self.supportBtn.selected = YES;
        } else if (recoveryGoodsVO.is_liked == 0) {
            self.supportBtn.selected = NO;
        }
        if (self.recoveryGoodsVO.gallary > 0) {
            [self.dataSources addObject:[RecoverImageCell buildCellDict:recoveryGoodsVO]];
        }
        [self.tableView reloadData];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }]];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
//    NSLog(@"dict:%@", dict);
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
//    NSLog(@"reuseIdentifier:%@", reuseIdentifier);
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([tableViewCell isKindOfClass:[RecoverDetailTableViewCell class]]) {
        RecoverDetailTableViewCell *recoverTableViewCell = (RecoverDetailTableViewCell *)tableViewCell;
        [recoverTableViewCell updateCellWithDict:self.recoveryGoodsVO];
    }
    else if ([tableViewCell isKindOfClass:[RecoverTitleCell class]]) {
        RecoverTitleCell *titleCell = (RecoverTitleCell *)tableViewCell;
        [titleCell updateCellWithDict:self.recoveryGoodsVO];
    }
    else if ([tableViewCell isKindOfClass:[RecoverFirstImageCell class]]) {
        RecoverFirstImageCell *firstImageCell = (RecoverFirstImageCell *)tableViewCell;
        [firstImageCell updateCellWithDict:self.recoveryGoodsVO];
    }
    else if ([tableViewCell isKindOfClass:[RecoverImageCell class]]) {
        RecoverImageCell *imageViewTableViewCell = (RecoverImageCell *)tableViewCell;
        RecoveryGoodsVo *goodsVO = dict[@"recoveryGoodsVo"];
        [imageViewTableViewCell updateCellWithDict:goodsVO];
    }
    else if ([tableViewCell isKindOfClass:[RecoverDetailTopCell class]]) {
        RecoverDetailTopCell *topDetailCell = (RecoverDetailTopCell *)tableViewCell;
        [topDetailCell updateCellWithDict:self.goodsDetail];
    }
//    else if ([tableViewCell isKindOfClass:[RecoverDateCell class]]) {
//        RecoverDateCell *dataCell = (RecoverDateCell *)tableViewCell;
//        [dataCell updateCellWithDict:self.recoveryGoodsVO];
//    }
//    else if ([tableViewCell isKindOfClass:[RecoverImageCell class]]) {
//        RecoverImageCell *imageCell = (RecoverImageCell *)tableViewCell;
//        [imageCell updateCellWithDict:self.recoveryGoodsVO];
//    }
    return tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && self.index == 2) {
        InsureViewController *insureViewController = [[InsureViewController alloc] init];
        insureViewController.goodsID = self.goodsID;
        [self pushViewController:insureViewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

-(void)setUpUI{
    if (self.index == 2) {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.topBar.mas_bottom);
            make.top.equalTo(self.topBar.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
    } else {
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topBar.mas_bottom);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-50);
        }];
    }
    
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@50);
    }];
    
    [self.supportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.left.equalTo(self.bottomView.mas_left).offset(43);
        make.width.equalTo(@66);
        make.height.equalTo(@50);
    }];
    
    [self.segView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(10);
        make.left.equalTo(self.supportBtn.mas_right);
        make.bottom.equalTo(self.bottomView.mas_bottom).offset(-10);
        make.width.equalTo(@1);
    }];
    
    [self.buyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top);
        make.bottom.equalTo(self.bottomView.mas_bottom);
        make.right.equalTo(self.bottomView.mas_right);
        make.left.equalTo(self.segView.mas_right);
    }];
}

@end
