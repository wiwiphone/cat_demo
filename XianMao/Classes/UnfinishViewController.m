//
//  UnfinishViewController.m
//  XianMao
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "UnfinishViewController.h"
#import "UnfinishHeaderView.h"
#import "Masonry.h"
#import "UnfinishCollectionViewCell.h"

@interface UnfinishViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UnfinishHeaderViewDelegate>

@property (nonatomic, strong) UnfinishHeaderView *topView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat topBarHeight;

@end
static NSString *UnfinishCollectionID = @"UnfinishCollectionID";
@implementation UnfinishViewController

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - 35 - self.topBarHeight);
        layout.minimumInteritemSpacing = 0;
        layout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64+35, kScreenWidth, kScreenHeight-64-35) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"e6e6e6"];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
    }
    return _collectionView;
}

-(UnfinishHeaderView *)topView{
    if (!_topView) {
        _topView = [[UnfinishHeaderView alloc] initWithFrame:CGRectZero];
        _topView.delegate = self;
    }
    return _topView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topBarHeight = [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"未完成状态"];
    
    [self.view addSubview:self.topView];
    [self.view addSubview:self.collectionView];
    [self.collectionView registerClass:[UnfinishCollectionViewCell class] forCellWithReuseIdentifier:UnfinishCollectionID];
    if (self.selectedIndexPath) {
        [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        [self.topView getSelectIndex:self.selectedIndexPath.item + 1];
    }
    [self setUpUI];
}

-(void)selectedItem:(NSInteger)index{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index-1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UnfinishCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:UnfinishCollectionID forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.unfinishController.status = 31;
        [cell.unfinishController initDataListLogic];
    } else if (indexPath.item == 1) {
        cell.unfinishController.status = 32;
        [cell.unfinishController initDataListLogic];
    } else if (indexPath.item == 2) {
        cell.unfinishController.status = 33;
        [cell.unfinishController initDataListLogic];
    }
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x < -50) {
        [self dismiss];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    [self.topView selectedTopBtn:index+1];
}

-(void)setUpUI{
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@35);
    }];
    
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topView.mas_bottom);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
    
}

@end
