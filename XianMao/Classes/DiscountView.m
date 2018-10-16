//
//  DiscountView.m
//  XianMao
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "DiscountView.h"
#import "PullRefreshTableView.h"
#import "BaseTableViewCell.h"
#import "DataListLogic.h"
#import "Error.h"
#import "BonusNewTableViewCell.h"
#import "BonusListViewController.h"
#import "BonusNewNewTableViewCell.h"
#import "NetworkManager.h"
#import "NSString+Addtions.h"
#import "TradeService.h"
#import "BounsNoTableViewCell.h"

@interface DiscountView () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) DataListLogic *dataListLogic;
@property (nonatomic, strong) NSMutableArray *dataSources;

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UITextField *textfield;
@property (nonatomic, strong) UIButton *convertBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) NSMutableArray *useingArr;
@property (nonatomic, strong) NSMutableArray *usedArr;
@property (nonatomic, strong) NSMutableArray *unUsedArr;

@property (nonatomic, assign) NSInteger viewType;
@end

@implementation DiscountView

-(NSMutableArray *)unUsedArr{
    if (!_unUsedArr) {
        _unUsedArr = [[NSMutableArray alloc] init];
    }
    return _unUsedArr;
}

-(NSMutableArray *)usedArr{
    if (!_usedArr) {
        _usedArr = [[NSMutableArray alloc] init];
    }
    return _usedArr;
}

-(NSMutableArray *)useingArr{
    if (!_useingArr) {
        _useingArr = [[NSMutableArray alloc] init];
    }
    return _useingArr;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"bbbbbb"];
    }
    return _lineView;
}

-(UIButton *)convertBtn{
    if (!_convertBtn) {
        _convertBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_convertBtn setTitle:@"兑换" forState:UIControlStateNormal];
        [_convertBtn setTitleColor:[UIColor colorWithHexString:@"000000"] forState:UIControlStateNormal];
        _convertBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _convertBtn.layer.borderColor = [UIColor colorWithHexString:@"000000"].CGColor;
        _convertBtn.layer.borderWidth = 1.f;
    }
    return _convertBtn;
}

-(UITextField *)textfield{
    if (!_textfield) {
        _textfield = [[UITextField alloc] initWithFrame:CGRectZero];
        _textfield.placeholder = @"请输入兑换码";
        _textfield.font = [UIFont systemFontOfSize:15.f];
        _textfield.textColor = [UIColor colorWithHexString:@"282828"];
        _textfield.textAlignment = NSTextAlignmentLeft;
        _textfield.keyboardType = UIKeyboardTypeEmailAddress;
        _textfield.clearButtonMode = UITextFieldViewModeWhileEditing;
        _textfield.tag = 100;
    }
    return _textfield;
}

-(UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 78)];
        _headerView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _headerView;
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.pullDelegate = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _tableView.enableLoadingMore = NO;
        _tableView.enableRefreshing = NO;
    }
    return _tableView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.headerView addSubview:self.textfield];
        [self.headerView addSubview:self.convertBtn];
        [self.headerView addSubview:self.lineView];
        
        [self addSubview:self.tableView];
        self.tableView.tableHeaderView = self.headerView;
        self.type = 1;
        [self setUpUI];
        [self reloadData];
        
        [self.convertBtn addTarget:self action:@selector(clickConvertBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)clickConvertBtn:(UIButton *)sender{
    WEAKSELF;
    NSString *codekey = [[self.textfield.text trim] lowercaseString];
    if ([codekey length]>0) {
        [weakSelf.textfield endEditing:YES];
        [[CoordinatingController sharedInstance] showProcessingHUD:nil];
        [BonusService convertBonus:codekey completion:^(BonusInfo *bonusInfo) {
            [[CoordinatingController sharedInstance] hideHUD];
            [weakSelf.unUsedArr addObject:[BonusNewNewTableViewCell buildCellDict:bonusInfo]];
            [weakSelf.unUsedArr addObject:[SepTableViewCellBonus buildCellDict]];
            [weakSelf.tableView reloadData];
        } failure:^(XMError *error) {
            [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    } else {
        [[CoordinatingController sharedInstance] showHUD:@"请输入兑换码" hideAfterDelay:0.8f];
    }
}

-(void)setUpUI{
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.convertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.width.equalTo(@67);
        make.height.equalTo(@29);
    }];
    
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.headerView.mas_centerY);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.convertBtn.mas_left).offset(-15);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textfield.mas_left);
        make.bottom.equalTo(self.textfield.mas_bottom).offset(3);
        make.right.equalTo(self.textfield.mas_right);
        make.height.equalTo(@1);
    }];
    
}

- (LoadingView*)showLoadingView {
    LoadingView *view = [LoadingView showLoadingView:self];
    view.frame = CGRectMake(0, 0, self.width, self.height);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)reloadData {
    
    WEAKSELF;
    [self showLoadingView];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"bonus" path:@"user_bonus_list" parameters:nil completionBlock:^(NSDictionary *data) {
        [LoadingView hideLoadingView:self];
        
        NSArray *list = data[@"user_bonus_list"];
//        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[list count]];
//        [newList addObject:[SepTableViewCellBonus buildCellDict]];
        for (int i=0;i<[list count];i++) {
            BonusInfo *info = [BonusInfo createWithDict:[list objectAtIndex:i]];
            if (info.status == UNUSED) {
                [weakSelf.unUsedArr addObject:[BonusNewNewTableViewCell buildCellDict:info]];
                [weakSelf.unUsedArr addObject:[SepTableViewCellBonus buildCellDict]];
            } else if (info.status == USEING) {
                [weakSelf.useingArr addObject:[BonusNewNewTableViewCell buildCellDict:info]];
                [weakSelf.useingArr addObject:[SepTableViewCellBonus buildCellDict]];
            } else if (info.status == USED) {
                [weakSelf.usedArr addObject:[BonusNewNewTableViewCell buildCellDict:info]];
                [weakSelf.usedArr addObject:[SepTableViewCellBonus buildCellDict]];
            }
//            [newList addObject:[BonusNewNewTableViewCell buildCellDict:info]];
//            [newList addObject:[SepTableViewCellBonus buildCellDict]];
            
            if (i == list.count - 1) {
                if (weakSelf.unUsedArr.count > 0) {
                    [weakSelf.dataSources addObject:weakSelf.unUsedArr];
                } else {
                    [weakSelf.unUsedArr addObject:[BounsNoTableViewCell buildCellDict]];
                    [weakSelf.dataSources addObject:weakSelf.unUsedArr];
                }
                if (weakSelf.useingArr.count > 0) {
                    [weakSelf.dataSources addObject:weakSelf.useingArr];
                }
                if (weakSelf.usedArr.count > 0) {
                    [weakSelf.dataSources addObject:weakSelf.usedArr];
                }
            }
            
        }
//        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
    } failure:^(XMError *error) {
        [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
    
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSMutableArray *arr = self.dataSources[section];
    if (section == 0) {
        if (arr.count > 0) {
            NSDictionary *dict = arr[0];
            if ([dict[@"clsName"] isEqualToString:@"BounsNoTableViewCell"]) {
                return 0;
            } else {
                return 30;
            }
        } else {
            return 30;
        }
    } else if (section == 1) {
        if (arr.count > 0) {
            return 30;
        } else {
            return 0;
        }
    } else {
        if (arr.count > 0) {
            return 30;
        } else {
            return 0;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSMutableArray *arr = self.dataSources[section];
    NSDictionary *dict = arr[0];
    BonusInfo *info = dict[@"bonusInfo"];
    self.viewType = info.status;
    
    UIView *view = [[UIView alloc] init];
    
    if (self.viewType == UNUSED) {
        
        UIView *view1 = [[UIView alloc] init];
        view1.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.font = [UIFont systemFontOfSize:15.f];
        titleLbl.textColor = [UIColor colorWithHexString:@"999999"];
        titleLbl.text = @"下单时可直接抵用";
        [titleLbl sizeToFit];
        [view1 addSubview:titleLbl];
        
        UIView *leftView = [[UIView alloc] init];
        leftView.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
        [view1 addSubview:leftView];
        
        UIView *rightView = [[UIView alloc] init];
        rightView.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
        [view1 addSubview:rightView];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view1.mas_top);
            make.centerX.equalTo(view1.mas_centerX);
        }];
        
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLbl.mas_centerY);
            make.left.equalTo(titleLbl.mas_right).offset(15);
            make.right.equalTo(view1.mas_right).offset(-15);
            make.height.equalTo(@1);
        }];
        
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLbl.mas_centerY);
            make.left.equalTo(view1.mas_left).offset(20);
            make.right.equalTo(titleLbl.mas_left).offset(-15);
            make.height.equalTo(@1);
        }];
        
        view = view1;
        
    } else if (self.viewType == USEING) {
        UIView *view2 = [[UIView alloc] init];
        view2.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.font = [UIFont systemFontOfSize:15.f];
        titleLbl.textColor = [UIColor colorWithHexString:@"999999"];
        titleLbl.text = @"已使用";
        [titleLbl sizeToFit];
        [view2 addSubview:titleLbl];
        
        UIView *leftView = [[UIView alloc] init];
        leftView.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
        [view2 addSubview:leftView];
        
        UIView *rightView = [[UIView alloc] init];
        rightView.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
        [view2 addSubview:rightView];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view2.mas_top);
            make.centerX.equalTo(view2.mas_centerX);
        }];
        
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLbl.mas_centerY);
            make.left.equalTo(titleLbl.mas_right).offset(15);
            make.right.equalTo(view2.mas_right).offset(-15);
            make.height.equalTo(@1);
        }];
        
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLbl.mas_centerY);
            make.left.equalTo(view2.mas_left).offset(20);
            make.right.equalTo(titleLbl.mas_left).offset(-15);
            make.height.equalTo(@1);
        }];
        
        view = view2;
    } else if (self.viewType == USED) {
        UIView *view3 = [[UIView alloc] init];
        view3.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLbl.font = [UIFont systemFontOfSize:15.f];
        titleLbl.textColor = [UIColor colorWithHexString:@"999999"];
        titleLbl.text = @"已过期";
        [titleLbl sizeToFit];
        [view3 addSubview:titleLbl];
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view3.mas_top);
            make.centerX.equalTo(view3.mas_centerX);
        }];
        
        UIView *leftView = [[UIView alloc] init];
        leftView.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
        [view3 addSubview:leftView];
        
        UIView *rightView = [[UIView alloc] init];
        rightView.backgroundColor = [UIColor colorWithHexString:@"d2d2d2"];
        [view3 addSubview:rightView];
        
        [titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view3.mas_top);
            make.centerX.equalTo(view3.mas_centerX);
        }];
        
        [rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLbl.mas_centerY);
            make.left.equalTo(titleLbl.mas_right).offset(15);
            make.right.equalTo(view3.mas_right).offset(-15);
            make.height.equalTo(@1);
        }];
        
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(titleLbl.mas_centerY);
            make.left.equalTo(view3.mas_left).offset(20);
            make.right.equalTo(titleLbl.mas_left).offset(-15);
            make.height.equalTo(@1);
        }];
        view = view3;
    }
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataSources[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSMutableArray *arr = [self.dataSources objectAtIndex:[indexPath section]];
    dict = [arr objectAtIndex:[indexPath row]];
//    if (indexPath.section == 0) {
//        dict = [self.unUsedArr objectAtIndex:[indexPath row]];
//    } else if (indexPath.section == 1) {
//        dict = [self.useingArr objectAtIndex:[indexPath row]];
//    } else {
//        dict = [self.usedArr objectAtIndex:[indexPath row]];
//    }
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    
    
    [tableViewCell updateCellWithDict:dict index:[indexPath row]];
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [(NSMutableArray *)([self.dataSources objectAtIndex:[indexPath section]]) objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
   
}

@end
