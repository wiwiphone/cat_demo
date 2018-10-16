//
//  PushView.m
//  XianMao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "PushView.h"
#import "PullRefreshTableView.h"
#import "RecoverBrandCell.h"
#import "RecoverCateView.h"
#import "GoodsService.h"
#import "ChineseInclude.h"
#import "PublishGoodsViewController.h"
#import "PinYinForObjc.h"

#import "Masonry.h"

@interface PushView () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, RecoverCateViewDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) RecoveryPreference *preference;
@property (nonatomic, weak) UISearchBar *searchBar;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *resetBtn;
@property (nonatomic, strong) UIButton *sureBtn;
@property (nonatomic, strong) RecoverCateView *cateView;
@property (nonatomic, strong) UIView *bottomLineView;

@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) NSMutableArray *paramArr;
@property (nonatomic, strong) NSArray *InJsonArr;

@property (nonatomic, strong) NSMutableArray *searchResults;;

@end

@implementation PushView {
    UISearchDisplayController *_searchDisplayController;
}

-(NSMutableArray *)searchResults{
    if (!_searchResults) {
        _searchResults = [[NSMutableArray alloc] init];
    }
    return _searchResults;
}

-(NSMutableArray *)paramArr{
    if (!_paramArr) {
        _paramArr = [[NSMutableArray alloc] init];
    }
    return _paramArr;
}

-(UIView *)bottomLineView{
    if (!_bottomLineView) {
        _bottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomLineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    }
    return _bottomLineView;
}

-(RecoverCateView *)cateView{
    if (!_cateView) {
        _cateView = [[RecoverCateView alloc] initWithFrame:CGRectZero];
    }
    return _cateView;
}

-(UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _sureBtn.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _sureBtn;
}

-(UIButton *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _resetBtn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [_resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _resetBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _resetBtn;
}

-(UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
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
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.0f)];
        _searchBar = searchBar;
        _searchBar.delegate =self;
        _searchBar.placeholder = @"搜索列表";
        _searchBar.tintColor = [UIColor lightGrayColor];
        _searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
        _searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _searchBar.keyboardType = UIKeyboardTypeDefault;
        
        _searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:_searchBar contentsController:self.viewController];
        _searchDisplayController.active = NO;
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.searchResultsDelegate = self;
        _searchResults = [[NSMutableArray alloc] init];
        [self addSubview:searchBar];
        
//        self.tableView.tableHeaderView = searchBar;
        [self addSubview:self.cateView];
        [self addSubview:self.bottomLineView];
        [self addSubview:self.tableView];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.resetBtn];
        [self.bottomView addSubview:self.sureBtn];
        self.tableView.separatorStyle = NO;
        self.tableView.enableLoadingMore = NO;
        self.tableView.enableRefreshing = NO;
        
        self.cateView.cateDelegate = self;
        
        [self.resetBtn addTarget:self action:@selector(clickResetBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.sureBtn addTarget:self action:@selector(clickSureBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self setUpUI];
    }
    return self;
}

-(void)clickResetBtn{
    
    for (int i = 0; i < self.dataSources.count; i++) {
        NSDictionary *dict = self.dataSources[i];
        RecoveryItem *item = dict[@"item"];
        if (item.is_selected == 1) {
            item.is_selected = 0;
        }
    }
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"resetMenu" object:nil];
    
    if (self.resetMenu) {
        self.resetMenu();
    }
}

-(void)clickSureBtn:(NSMutableArray *)cateArr{
    [self.paramArr removeAllObjects];
    for (int i = 0; i < self.dataSources.count; i++) {
        NSDictionary *dict = self.dataSources[i];
        RecoveryItem *item = dict[@"item"];
        RecoveryPreference *preference = dict[@"preference"];
        if (item.is_selected == 1) {
            NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
            [params setObject:preference.query_key forKey:@"qk"];
            [params setObject:item.query_value forKey:@"qv"];
            [self.paramArr addObject:params];
        }
    }
    
    [self.cateView getRecoverArr:self.paramArr];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"sureMenuArr" object:self.paramArr];
    
    
}

-(void)setSuccess:(NSMutableArray *)cateArr{
    if (self.sureMenu) {
        self.sureMenu(cateArr);
    }
//    [self clickSureBtn:cateArr];
    
}

-(void)getInJsonArr:(NSArray *)arr{
    self.InJsonArr = arr;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setUpUI{
    self.searchBar.frame = CGRectMake(0, 0, kScreenWidth, 44);
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchBar.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-67);
    }];
    //    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 67);
    
    
    [self.cateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-67);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
        //        make.width.equalTo(@80);
        make.right.equalTo(self.mas_centerX).offset(-75);
    }];
    
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.resetBtn.mas_top);
        make.left.equalTo(self.resetBtn.mas_right);
        make.right.equalTo(self.self.mas_right).offset(-15);
        make.bottom.equalTo(self.resetBtn.mas_bottom);
    }];
    
    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@0.5);
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    //适配ios7.0 将布局移动到setUpUI中
//    self.searchBar.frame = CGRectMake(0, 0, kScreenWidth, 44);
//    
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.searchBar.mas_bottom);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom).offset(-67);
//    }];
////    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 67);
//    
//    
//    [self.cateView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.mas_top);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom).offset(-67);
//    }];
//    
//    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.tableView.mas_bottom);
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.bottom.equalTo(self.mas_bottom);
//    }];
//    
//    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.bottomView.mas_top).offset(15);
//        make.left.equalTo(self.mas_left).offset(15);
//        make.bottom.equalTo(self.mas_bottom).offset(-15);
////        make.width.equalTo(@80);
//        make.right.equalTo(self.mas_centerX).offset(-75);
//    }];
//    
//    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.resetBtn.mas_top);
//        make.left.equalTo(self.resetBtn.mas_right);
//        make.right.equalTo(self.self.mas_right).offset(-15);
//        make.bottom.equalTo(self.resetBtn.mas_bottom);
//    }];
//    
//    [self.bottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.mas_left);
//        make.right.equalTo(self.mas_right);
//        make.top.equalTo(self.mas_top);
//        make.height.equalTo(@0.5);
//    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    if (tableView == _searchDisplayController.searchResultsTableView)  {
//        return _searchResults.count;
//    } else {
        return self.dataSources.count;
//    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = nil;
//    if (_searchResults.count > 0)  {
//        dict = [self.searchResults objectAtIndex:indexPath.row];
//    } else {
        dict = [self.dataSources objectAtIndex:[indexPath row]];
//    }
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([tableViewCell isKindOfClass:[RecoverBrandCell class]]) {
        RecoverBrandCell *brandCell = (RecoverBrandCell *)tableViewCell;
        RecoveryItem *item = dict[@"item"];
        if (item.is_selected == 0) {
            brandCell.nameLabel.layer.borderWidth = 1.0f;
            brandCell.nameLabel.layer.borderColor = [UIColor clearColor].CGColor;
        } else {
            brandCell.nameLabel.layer.borderWidth = 1.0f;
            brandCell.nameLabel.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        }
        [brandCell updateCellWithDict:dict];
    }
    else {
        [tableViewCell updateCellWithDict:dict];
    }
    
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
    BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[RecoverBrandCell class]]) {
        RecoveryItem *item = dict[@"item"];
        if (item.is_selected == 0) {
            RecoverBrandCell *brandCell = (RecoverBrandCell *)cell;
            brandCell.nameLabel.layer.borderWidth = 1.0f;
            brandCell.nameLabel.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
            item.is_selected = 1;
        } else {
            RecoverBrandCell *brandCell = (RecoverBrandCell *)cell;
            brandCell.nameLabel.layer.borderWidth = 1.0f;
            brandCell.nameLabel.layer.borderColor = [UIColor clearColor].CGColor;
            item.is_selected = 0;
        }
        
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[RecoverBrandCell class]]) {
        if (self.preference.multi_selected == 0) {
            RecoveryItem *item = dict[@"item"];
            RecoverBrandCell *brandCell = (RecoverBrandCell *)cell;
            brandCell.nameLabel.layer.borderWidth = 1.0f;
            brandCell.nameLabel.layer.borderColor = [UIColor clearColor].CGColor;
            if (item.is_selected == 1) {
                item.is_selected = 0;
            }
        }
    }
}

//-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
//    //準備搜尋前，把上面調整的TableView調整回全屏幕的狀態，如果要產生動畫效果，要另外執行animation代碼
//    self.tableView.frame = CGRectMake(0, 0, 320, self.tableView.frame.size.height);
//    return YES;
//}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    [self.dataSources removeAllObjects];
    if (self.preference.type == 0) {
        self.tableView.hidden = NO;
        self.cateView.hidden = YES;
        for (int i = 0; i < self.preference.items.count; i++) {
            RecoveryItem *item = self.preference.items[i];
            [self.dataSources addObject:[RecoverBrandCell buildCellDict:item andPreference:self.preference]];
        }
    } else if (self.preference.type == 1) {
        self.tableView.hidden = YES;
        self.cateView.hidden = NO;
        [self.cateView getRecoverPreference:self.preference];
        [self.cateView getInJsonArr:self.InJsonArr];
    }
    [self.tableView reloadData];
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSMutableArray *searchResults = [[NSMutableArray alloc]init];
    
    if (_searchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:_searchBar.text]) {
        for (int i=0; i<_dataSources.count; i++) {
            NSDictionary *dict = _dataSources[i];
            RecoveryItem *recoverItem = dict[@"item"];
            RecoveryPreference *preference = dict[@"preference"];
            if ([ChineseInclude isIncludeChineseInString:recoverItem.title]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:recoverItem.title];
                NSRange titleResult=[tempPinYinStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:[RecoverBrandCell buildCellDict:recoverItem andPreference:preference]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:recoverItem.title];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:searchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [searchResults addObject:[RecoverBrandCell buildCellDict:recoverItem andPreference:preference]];
                }
            }
            else {
                NSRange titleResult=[recoverItem.title rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [searchResults addObject:[RecoverBrandCell buildCellDict:recoverItem andPreference:preference]];
                }
            }
        }
    }
    else if (_searchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:_searchBar.text]) {
        for (int i=0; i<_dataSources.count; i++) {
            NSDictionary *dict = _dataSources[i];
            RecoveryItem *recoverItem = dict[@"item"];
            RecoveryPreference *preference = dict[@"preference"];
            NSRange titleResult=[recoverItem.title rangeOfString:_searchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [searchResults addObject:[RecoverBrandCell buildCellDict:recoverItem andPreference:preference]];
            }
        }
    }
    self.dataSources = searchResults;
    if (self.dataSources.count == 0) {
        if (self.preference.type == 0) {
            self.tableView.hidden = NO;
            self.cateView.hidden = YES;
            for (int i = 0; i < self.preference.items.count; i++) {
                RecoveryItem *item = self.preference.items[i];
                [self.dataSources addObject:[RecoverBrandCell buildCellDict:item andPreference:self.preference]];
            }
        } else if (self.preference.type == 1) {
            self.tableView.hidden = YES;
            self.cateView.hidden = NO;
            [self.cateView getRecoverPreference:self.preference];
            [self.cateView getInJsonArr:self.InJsonArr];
        }
    }
    [self.tableView reloadData];
}

-(void)getData:(RecoveryPreference *)prederence{
    if (prederence) {
        _preference = prederence;
        [self.dataSources removeAllObjects];
        if (prederence.type == 0) {
            _searchBar.hidden = NO;
            self.tableView.hidden = NO;
            self.cateView.hidden = YES;
            for (int i = 0; i < prederence.items.count; i++) {
                RecoveryItem *item = prederence.items[i];
                [self.dataSources addObject:[RecoverBrandCell buildCellDict:item andPreference:prederence]];
            }
        } else if (prederence.type == 1) {
            _searchBar.hidden = YES;
            self.tableView.hidden = YES;
            self.cateView.hidden = NO;
//            [self.cateView getRecoverPreference:prederence];
            self.cateView.preference = prederence;
            [self.cateView getInJsonArr:self.InJsonArr];
        }
        [self.tableView reloadData];
    }
}

@end
