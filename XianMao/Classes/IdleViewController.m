//
//  IdleViewController.m
//  XianMao
//
//  Created by apple on 16/4/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "IdleViewController.h"
#import "Session.h"
#import "ShoppingCartViewController.h"
#import "PullRefreshTableView.h"
#import "BaseTableViewCell.h"
#import "DataListLogic.h"
#import "IdleTableViewCell.h"
#import "IdleSegCell.h"
#import "GoodsDetailViewController.h"
#import "SearchViewController.h"
#import "TagScrollView.h"
#import "TagListModel.h"
#import "FqParamsModel.h"
#import "JSONKit.h"
#import "NSString+URLEncoding.h"
#import "TagScrollView.h"
#import "IdleBannerTableViewCell.h"
#import "SegmentedControlBottomView.h"
#import "IdleListViewController.h"

@interface IdleViewController () <SGTopTitleViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) UIButton *goodsNumLbl;
@property (nonatomic, strong) NSMutableArray *tagListArray;
@property (nonatomic, strong) TagScrollView *topTitleView;
@property (nonatomic, strong) SegmentedControlBottomView *bottomSView;

@end

@implementation IdleViewController

-(NSMutableArray *)tagListArray
{
    if (!_tagListArray) {
        _tagListArray = [[NSMutableArray alloc] init];
    }
    return _tagListArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [self setupTopBarTitle:@"个人闲置"];
    
    [super setupTopBarBackButton:[[SkinIconManager manager] isValidWithPath:KIdle_TopBarLeftImg]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KIdle_TopBarLeftImg]]:[UIImage imageNamed:@"search_wjh"] imgPressed:[UIImage imageNamed:@"search_wjh"]];
    [super setupTopBarRightButton:[[SkinIconManager manager] isValidWithPath:KIdle_TopBarRightImg]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KIdle_TopBarRightImg]]:[UIImage imageNamed:@"Mine_New_ShoppingBad_White_MF"] imgPressed:[UIImage imageNamed:@"Mine_New_ShoppingBad_White_MF"]];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    UIButton *goodsNumLbl = [self buildGoodsNumLbl];
    self.goodsNumLbl = goodsNumLbl;
    [self.topBarRightButton addSubview:goodsNumLbl];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    

    
    [self createSearchTag];  
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    // 计算滚动到哪一页
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    // 1.添加子控制器view
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
    
    // 2.把对应的标题选中
    [self.topTitleView changeThePositionOfTheSelectedBtnWithScrollView:scrollView];
}

-(void)createSearchTag
{
    WEAKSELF;
    NSDictionary * parameters = @{@"page":[NSNumber numberWithInteger:0]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"fq_tag_list" parameters:parameters completionBlock:^(NSDictionary *data) {
        
        NSArray * array = data[@"result"];
        NSMutableArray * tagListArray = [[NSMutableArray alloc] init];
        for (NSDictionary * dict in array) {
            TagListModel * tag = [[TagListModel alloc] initWithJSONDictionary:dict];
            [tagListArray addObject:tag];
        }
        weakSelf.tagListArray = tagListArray;

        
        weakSelf.topTitleView = [TagScrollView topTitleViewWithFrame:CGRectMake(0, 65.5, self.view.frame.size.width, 60)];
        _topTitleView.scrollTagArr = [NSArray arrayWithArray:weakSelf.tagListArray];
        _topTitleView.delegate_SG = weakSelf;
        [weakSelf.view addSubview:_topTitleView];
        
        
        
        
        
        NSMutableArray * childVC = [[NSMutableArray alloc] init];
        for (int i = 0; i < weakSelf.tagListArray.count; i++) {
            IdleListViewController * viewController = [[IdleListViewController alloc] init];
            //加载数据
            NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
            TagListModel * model = [self.tagListArray objectAtIndex:i];
            NSArray * array = model.fqParams;
            for (FqParamsModel * fqParams in array) {
                if ([fqParams isKindOfClass:[FqParamsModel class]]) {
                    NSDictionary * dict = @{@"qk":fqParams.qk,@"qv":fqParams.qv};
                    [paramsArray addObject:dict];
                }
            }
            viewController.params = [[paramsArray JSONString] URLEncodedString];
            [viewController initDataListLogic:i title:model.title];
//            [self addChildViewController:viewController];
            [childVC addObject:viewController];
        }
        weakSelf.bottomSView = [[SegmentedControlBottomView alloc] initWithFrame:CGRectMake(0, 65.5+60, kScreenWidth, kScreenHeight-65.5-60-50)];
        _bottomSView.childViewController = childVC;
        _bottomSView.delegate = weakSelf;
        [weakSelf.bottomSView showChildVCViewWithIndex:0 outsideVC:weakSelf];
        [weakSelf.view addSubview:_bottomSView];
        
        
        
        
        
    } failure:^(XMError *error) {
        
    } queue:nil]];
    
}

-(void)SGTopTitleView:(TagScrollView *)topTitleView didSelectTitleAtIndex:(NSInteger)index
{

    NSLog(@"index - - %ld", (long)index);
    // 计算滚动的位置
    CGFloat offsetX = index * self.view.frame.size.width;
    self.bottomSView.contentOffset = CGPointMake(offsetX, 0);
    [self.bottomSView showChildVCViewWithIndex:index outsideVC:self];
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    ShoppingCartViewController *shopCarViewController = [[ShoppingCartViewController alloc] init];
    [self pushViewController:shopCarViewController animated:YES];
}

-(void)handleTopBarBackButtonClicked:(UIButton *)sender{
    SearchViewController *search = [[SearchViewController alloc] init];
    search.isXianzhi = 1;
    [self pushViewController:search animated:YES];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];

}

- (void)updateGoodsNumLbl:(NSInteger)goodsNum
{
    if (goodsNum > 0) {
        if (goodsNum<100) {
            NSString *title = [NSString stringWithFormat:@"%ld",(long)goodsNum];
            //            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:9.5f]];
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            _goodsNumLbl.hidden = NO;
        } else {
            NSString *title = @"...";
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            _goodsNumLbl.hidden = NO;
        }
        
    } else {
        [_goodsNumLbl setTitle:@"" forState:UIControlStateDisabled];
        _goodsNumLbl.hidden = YES;
    }
}

- (UIButton*)buildGoodsNumLbl
{
//        UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(27.5, 6, 14, 13)];
    goodsNumLbl.backgroundColor = [UIColor colorWithHexString:@"fb0006"];
    goodsNumLbl.layer.cornerRadius = 6.5f;
    goodsNumLbl.layer.masksToBounds = YES;
    [goodsNumLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    goodsNumLbl.enabled = NO;
    goodsNumLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    goodsNumLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    goodsNumLbl.titleLabel.font = [UIFont systemFontOfSize:9.5f];
    return goodsNumLbl;
}

@end



