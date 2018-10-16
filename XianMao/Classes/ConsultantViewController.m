//
//  ConsultantViewController.m
//  XianMao
//
//  Created by apple on 16/3/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ConsultantViewController.h"
#import "PullRefreshTableView.h"
#import "BaseTableViewCell.h"
#import "DataListLogic.h"
#import "ConsultantTableViewCell.h"
#import "UserHomeViewController.h"

#import "AdviserPage.h"


#import "PromptView.h"
#import "Session.h"

#import "Error.h"
#import "Masonry.h"

@interface ConsultantViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, assign) CGFloat topBarHeigth;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) PromptView *promrtView;
@end

@implementation ConsultantViewController

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.pullDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor colorWithString:@"F7F7F7"];
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    self.topBarHeigth = topBarHeight;
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"我的顾问"];
    [super setupTopBarRightButton:[UIImage imageNamed:@"Insure_rigth_btn_MF"] imgPressed:nil];
    [self.view addSubview:self.tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissBlackView) name:@"dissMissBackView" object:nil];
    [self setUpUI];
    [self showLoadingView];
    [self loadData];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    if (!self.backView) {
        self.backView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    self.backView.backgroundColor = [UIColor blackColor];
    self.backView.alpha = 0;
    [self.view addSubview:self.backView];
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0.7;
    } completion:^(BOOL finished) {
        nil;
    }];
    
    if (!self.promrtView) {
        self.promrtView = [[PromptView alloc] init];
    }
    self.promrtView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.promrtView];
    
    UIImageView *promrtImageView = [[UIImageView alloc] init];
    promrtImageView.image = [UIImage imageNamed:@"promrt_MF"];
    [self.promrtView addSubview:promrtImageView];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor colorWithHexString:@"595757"];
    NSString *str = @"1.什么是爱丁猫顾问？\n"
    "爱丁猫顾问是爱丁猫特邀合作的奢侈品咨询顾问专家，他们在一些奢侈品品类有比较丰富的购买、使用经验。\n"
    "2.爱丁猫顾问能做什么？\n"
    "我们希望当你在爱丁猫购购，甚至只要是购买奢侈品时遇到困惑，爱丁猫顾问都能购为您提供一定帮助。\n"
    "3.顾问咨询收费吗？\n"
    "目前是免费的。";
    [textLabel sizeToFit];
    textLabel.text = str;
    [promrtImageView addSubview:textLabel];
    //调整行间距
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineSpacing = 11.f;
    
    //设置部分颜色
    NSMutableAttributedString *hintString=[[NSMutableAttributedString alloc]initWithString:@"1.什么是爱丁猫顾问？\n"
                                           "爱丁猫顾问是爱丁猫特邀合作的奢侈品咨询顾问专家，他们在一些奢侈品品类有比较丰富的购买、使用经验。\n"
                                           "2.爱丁猫顾问能做什么？\n"
                                           "我们希望当你在爱丁猫购购，甚至只要是购买奢侈品时遇到困惑，爱丁猫顾问都能购为您提供一定帮助。\n"
                                           "3.顾问咨询收费吗？\n"
                                           "目前是免费的。"];
    //获取要调整颜色的文字位置,调整颜色
    NSRange range1=[[hintString string]rangeOfString:@"爱丁猫顾问是爱丁猫特邀合作的奢侈品咨询顾问专家，他们在一些奢侈品品类有比较丰富的购买、使用经验。"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"898989"] range:range1];
    NSRange range2=[[hintString string]rangeOfString:@"我们希望当你在爱丁猫购购，甚至只要是购买奢侈品时遇到困惑，爱丁猫顾问都能购为您提供一定帮助。"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"898989"] range:range2];
    NSRange range3=[[hintString string]rangeOfString:@"目前是免费的。"];
    [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"898989"] range:range3];
    
    NSRange range4 = [[hintString string]rangeOfString:@"1.什么是爱丁猫顾问？\n"
                      "爱丁猫顾问是爱丁猫特邀合作的奢侈品咨询顾问专家，他们在一些奢侈品品类有比较丰富的购买、使用经验。\n"
                      "2.爱丁猫顾问能做什么？\n"
                      "我们希望当你在爱丁猫购购，甚至只要是购买奢侈品时遇到困惑，爱丁猫顾问都能购为您提供一定帮助。\n"
                      "3.顾问咨询收费吗？\n"
                      "目前是免费的。"];
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:15], NSParagraphStyleAttributeName:paragraphStyle};
    [hintString addAttributes:attributes range:range4];
    textLabel.attributedText = hintString;//[[NSAttributedString alloc]initWithString:textLabel.text attributes:attributes];
    
    UIButton *dissBtn = [[UIButton alloc] init];
    [dissBtn setImage:[UIImage imageNamed:@"dissMiss_Recocer_MF"] forState:UIControlStateNormal];
    [promrtImageView addSubview:dissBtn];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"爱丁猫顾问";
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:15.f];
    [titleLabel sizeToFit];
    [promrtImageView addSubview:titleLabel];
    
    [self.promrtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(15);
        make.right.equalTo(self.view.mas_right).offset(-15);
        make.centerY.equalTo(self.view.mas_centerY);
        make.height.equalTo(textLabel.mas_height).offset(115);
    }];
    
    [promrtImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.promrtView);
    }];
    
    [textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promrtImageView.mas_top).offset(75);
        make.left.equalTo(promrtImageView.mas_left).offset(15);
        make.right.equalTo(promrtImageView.mas_right).offset(-15);
        //        make.bottom.equalTo(self.promrtView.mas_bottom).offset(-35);
    }];
    
    [dissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(promrtImageView.mas_top).offset(5);
        make.right.equalTo(promrtImageView.mas_right).offset(-15);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(promrtImageView.mas_centerX);
        make.top.equalTo(promrtImageView.mas_top).offset(11);
    }];
    
    self.promrtView.alpha = 0;
    [UIView animateWithDuration:0.25 animations:^{
        self.promrtView.alpha = 1;
    }];
}

-(void)dismissBlackView{
    [UIView animateWithDuration:0.25 animations:^{
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.backView removeFromSuperview];
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [UIView animateWithDuration:0.25 animations:^{
        self.promrtView.alpha = 0;
        self.backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.promrtView removeFromSuperview];
        [self.backView removeFromSuperview];
    }];
}

-(void)setUpUI{
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
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
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"user" path:@"get_adviser_page" pageSize:20];
//    NSInteger userId = [Session sharedInstance].currentUserId;
//    _dataListLogic.parameters = @{@"userId":[NSNumber numberWithInteger:userId]};
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
            [newList addObject:[ConsultantTableViewCell buildCellDict:[[AdviserPage alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]]]];
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
            [newList addObject:[ConsultantTableViewCell buildCellDict:[[AdviserPage alloc] initWithJSONDictionary:[addedItems objectAtIndex:i]]]];
        }
        if ([newList count]>0) {
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                
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
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton:@"无服务管家"].handleRetryBtnClicked=^(LoadingView *view) {
            [weakSelf.dataListLogic reloadDataListByForce];
        };;
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    [_dataListLogic firstLoadFromCache];
    
    [weakSelf showLoadingView];
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
    
    if ([tableViewCell isKindOfClass:[ConsultantTableViewCell class]]) {
        ConsultantTableViewCell *consultantTabelViewCell = (ConsultantTableViewCell *)tableViewCell;
        [consultantTabelViewCell upDataWithDict:dict];
        consultantTabelViewCell.pushChatViewController = ^(NSInteger userId, AdviserPage *adviserPage){
            NSDictionary *data = @{@"userId":[NSNumber numberWithInteger:adviserPage.userId]};
            [ClientReportObject clientReportObjectWithViewCode:MineConsultantViewCode regionCode:ChatViewCode referPageCode:ChatViewCode andData:data];
            [UserSingletonCommand chatWithUserFirst:userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings]];//@"嗨，我是爱丁猫%@顾问，今天想要聊点儿啥？", adviserPage.categoryName]];
        };
    }
//    static NSString *ID = @"CELL";
//    ConsultantTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
//    if (!cell) {
//        cell = [[ConsultantTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    }
//    
//    cell.pushChatViewController = ^(){
//        [UserSingletonCommand chatWithUser:1644 msg:@"hah"];
//    };
    
    return tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    if (ClsTableViewCell == [ConsultantTableViewCell class]) {
        AdviserPage *adviserPage = dict[@"adviserPage"];
        
        UserHomeViewController *viewController = [[UserHomeViewController alloc] init];
        viewController.userId = adviserPage.userId;
        NSDictionary *data = @{@"userId":[NSNumber numberWithInteger:adviserPage.userId]};
        [ClientReportObject clientReportObjectWithViewCode:MineConsultantViewCode regionCode:HomeChosenUserHomeRegionCode referPageCode:UserHomeReferPageCode andData:data];
        [self pushViewController:viewController animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

@end
