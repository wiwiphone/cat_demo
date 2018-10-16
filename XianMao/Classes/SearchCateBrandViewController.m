//
//  SearchCateBrandViewController.m
//  XianMao
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SearchCateBrandViewController.h"
#import "SearchViewController.h"
#import "NSString+Addtions.h"
#import "RecommendViewController.h"
#import "CategoryBrandViewCell.h"
#import "ShoppingCartViewController.h"

#import "NetworkManager.h"
#import "Session.h"
#import "Masonry.h"

@interface SearchCateBrandViewController () <UISearchBarDelegate, SearchBarViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) SearchBarView *searchBarView;
@property(nonatomic,weak) TopBarRightButton *myTopBarRightButton;
@property (nonatomic, strong) UILabel *goodsNumLbl;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cateButton;
@property (nonatomic, strong) UIButton *brandButton;
@property (nonatomic, strong) UIView *moveLineView;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UICollectionView *categoryBrandView;

@end

static NSString *CategoryBrandViewID = @"categoryBrandViewID";
@implementation SearchCateBrandViewController


-(UICollectionView *)categoryBrandView{
    if (!_categoryBrandView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight-self.topBar.height-45);
        _categoryBrandView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _categoryBrandView.showsHorizontalScrollIndicator = NO;
        _categoryBrandView.showsVerticalScrollIndicator = NO;
        _categoryBrandView.pagingEnabled = YES;
        _categoryBrandView.delegate = self;
        _categoryBrandView.dataSource = self;
        _categoryBrandView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    }
    return _categoryBrandView;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _scrollView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
    }
    return _scrollView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
    }
    return _lineView;
}

-(UIView *)moveLineView{
    if (!_moveLineView) {
        _moveLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _moveLineView.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
    }
    return _moveLineView;
}

-(UIButton *)brandButton{
    if (!_brandButton) {
        _brandButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_brandButton setTitle:@"品牌" forState:UIControlStateNormal];
        [_brandButton setTitleColor:[UIColor colorWithHexString:@"4c4c4c"] forState:UIControlStateNormal];
        [_brandButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        _brandButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _brandButton;
}

-(UIButton *)cateButton{
    if (!_cateButton) {
        _cateButton = [[UIButton alloc] initWithFrame:CGRectZero];
        [_cateButton setTitle:@"分类" forState:UIControlStateNormal];
        [_cateButton setTitleColor:[UIColor colorWithHexString:@"4c4c4c"] forState:UIControlStateNormal];
        [_cateButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        _cateButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _cateButton;
}

-(UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
    }
    return _topView;
}

-(UILabel *)goodsNumLbl{
    if (!_goodsNumLbl) {
        _goodsNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsNumLbl.text = [NSString stringWithFormat:@"%ld", [Session sharedInstance].shoppingCartNum];
        _goodsNumLbl.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
        _goodsNumLbl.textColor = [UIColor whiteColor];
        _goodsNumLbl.font = [UIFont systemFontOfSize:10.f];
        _goodsNumLbl.layer.masksToBounds = YES;
        _goodsNumLbl.layer.cornerRadius = 6;
        _goodsNumLbl.textAlignment = NSTextAlignmentCenter;
        [_goodsNumLbl sizeToFit];
    }
    return _goodsNumLbl;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cateButton.selected = YES;
    
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    [self.topBarRightButton setImage:[UIImage imageNamed:@"ShopBag_New_MF"] forState:UIControlStateNormal];
    self.topBarRightButton.frame = CGRectMake(super.topBar.width-44-10, super.topBar.height-super.topBarRightButton.height-2, 44, super.topBarRightButton.height);
    [self.topBar addSubview:self.goodsNumLbl];
    
    SearchBarView *searchBarView = [[SearchBarView alloc] initWithFrame:CGRectMake(38, topBarHeight-11.f-25, kScreenWidth-38.f-15-29, 29)];
    searchBarView.layer.borderWidth = 0.5;
    searchBarView.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    _searchBarView = searchBarView;
    _searchBarView.placeholder = @"想要什么？";
    UITextField *txfSearchField = [_searchBarView valueForKey:@"_searchField"];
    txfSearchField.font = [UIFont systemFontOfSize:13.f];
    _searchBarView.delegate = self;
    _searchBarView.searchBarDelegate = self;
    [self.topBar addSubview:searchBarView];
    
    TopBarRightButton *myTopBarRightButton = [[TopBarRightButton alloc] initWithFrame:CGRectMake(searchBarView.right-46, searchBarView.top, 46, searchBarView.height)];
    _myTopBarRightButton = myTopBarRightButton;
    _myTopBarRightButton.backgroundColor = [UIColor clearColor];
    _myTopBarRightButton.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    _myTopBarRightButton.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    [_myTopBarRightButton addTarget:self action:@selector(handleMyTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_myTopBarRightButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
    [self.topBar addSubview:self.myTopBarRightButton];
    
    searchBarView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
    searchBarView.layer.masksToBounds = YES;
    searchBarView.layer.cornerRadius = (searchBarView.height)/6;

    //controller中的内容⬇️
    [self.view addSubview:self.topView];
    [self.topView addSubview:self.cateButton];
    [self.topView addSubview:self.brandButton];
    [self.topView addSubview:self.lineView];
    [self.topView addSubview:self.moveLineView];
    [self.view addSubview:self.categoryBrandView];
    [self.categoryBrandView registerClass:[CategoryBrandViewCell class] forCellWithReuseIdentifier:CategoryBrandViewID];
    
    [self.cateButton addTarget:self action:@selector(clickCateBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.brandButton addTarget:self action:@selector(clickBrandBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpUI];
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    ShoppingCartViewController *shoppingViewController = [[ShoppingCartViewController alloc] init];
    [self pushViewController:shoppingViewController animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CategoryBrandViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CategoryBrandViewID forIndexPath:indexPath];
    
    cell.index = indexPath.item + 1;
//    if (indexPath.item == 0) {
//        self.cateButton.selected = YES;
//        self.brandButton.selected = NO;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.moveLineView.frame = CGRectMake(kScreenWidth/4 - 42, 44, 84, 1);
//        }];
//    } else if (indexPath.item == 1) {
//        self.cateButton.selected = NO;
//        self.brandButton.selected = YES;
//        [UIView animateWithDuration:0.25 animations:^{
//            self.moveLineView.frame = CGRectMake(kScreenWidth/4*3 - 42, 44, 84, 1);
//        }];
//    }
    
    return cell;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    CGFloat index = scrollView.contentOffset.x/kScreenWidth;
    if (index == 0) {
        self.cateButton.selected = YES;
        self.brandButton.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.moveLineView.frame = CGRectMake(kScreenWidth/4 - 42, 44, 84, 1);
        }];
    } else if (index == 1) {
        self.cateButton.selected = NO;
        self.brandButton.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.moveLineView.frame = CGRectMake(kScreenWidth/4*3 - 42, 44, 84, 1);
        }];
    }
}

-(void)clickCateBtn{
    if (self.cateButton.selected) {
        
    } else {
        self.cateButton.selected = YES;
        self.brandButton.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.moveLineView.frame = CGRectMake(kScreenWidth/4 - 42, 44, 84, 1);
        }];
        [self.categoryBrandView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

-(void)clickBrandBtn{
    if (self.brandButton.selected) {
        
    } else {
        self.cateButton.selected = NO;
        self.brandButton.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.moveLineView.frame = CGRectMake(kScreenWidth/4*3 - 42, 44, 84, 1);
        }];
        [self.categoryBrandView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    }
}

-(void)setUpUI{
    if ([Session sharedInstance].shoppingCartNum == 0) {
        self.goodsNumLbl.hidden = YES;
    } else {
        self.goodsNumLbl.hidden = NO;
        [self.goodsNumLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.topBar.mas_right).offset(-5);
            make.top.equalTo(self.topBarRightButton.mas_top).offset(5);
            make.width.equalTo(@(self.goodsNumLbl.width + 5));
        }];
    }
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@45);
    }];
    
    [self.cateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topView.mas_left);
        make.top.equalTo(self.topView.mas_top);
        make.bottom.equalTo(self.topView.mas_bottom);
        make.width.equalTo(@(kScreenWidth/2));
    }];
    
    [self.brandButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.topView.mas_right);
        make.top.equalTo(self.topView.mas_top);
        make.bottom.equalTo(self.topView.mas_bottom);
        make.width.equalTo(@(kScreenWidth/2));
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@0.5);
    }];
    
    self.moveLineView.frame = CGRectMake(kScreenWidth/4 - 42, 44, 84, 1);
    
    [self.categoryBrandView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    
}

- (void)handleMyTopBarRightButtonClicked:(UIButton*)sender
{
    [self.view endEditing:YES];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
    //    _searchHistoryView.hidden = NO;
    [ClientReportObject clientReportObjectWithViewCode:HomeViewCode regionCode:HomeSearchViewCode referPageCode:HomeSearchViewCode andData:nil];
    _myTopBarRightButton.hidden = NO;
    _myTopBarRightButton.isInEditing = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    _myTopBarRightButton.isInEditing = NO;
    
    _myTopBarRightButton.hidden = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    //    _searchHistoryView.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keywords = [searchBar.text trim];
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    if ([keywords length]>0 && [searchBar isKindOfClass:[SearchBarView class]]) {
        
        //埋点
        NSDictionary *data = @{@"keywords":keywords};
        [ClientReportObject clientReportObjectWithViewCode:HomeViewCode regionCode:SearchGoodsClickRegionCode referPageCode:NoReferPageCode andData:data];
        
        SearchViewController *viewController = [[SearchViewController alloc] init];
        viewController.searchKeywords = keywords;
        viewController.searchType = ((SearchBarView*)searchBar).currentSearchType;
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

@end
