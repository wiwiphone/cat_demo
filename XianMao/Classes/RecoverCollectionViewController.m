//
//  RecoverCollectionViewController.m
//  XianMao
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverCollectionViewController.h"
#import "OnSaleViewController.h"
#import "Masonry.h"

@interface RecoverCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) RecoverCollectionViewCell *cell;

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottonView;

@property (nonatomic, assign) NSInteger itemNum;
@property (nonatomic, assign) BOOL isRecover;

@end

static NSString *ID = @"recoverCollectionCell";
static CGFloat topViewHeight = 44;
@implementation RecoverCollectionViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.itemNum = 4;
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton:[UIImage imageNamed:@"Recover_Search_MF"] imgPressed:nil];
    NSArray *segmentedArray = [[NSArray alloc] initWithObjects:@"自己卖",@"求回收",nil];
    UISegmentedControl *segmentedController = [[UISegmentedControl alloc] initWithItems:segmentedArray];
    segmentedController.frame = CGRectMake(kScreenWidth / 2 - 71, topBarHeight - 33, 142, 25);
    segmentedController.selectedSegmentIndex = self.segmentIndex;
    segmentedController.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedController.tintColor = [UIColor colorWithHexString:@"3e3a39"];
    [segmentedController addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    
//    [self.topBar addSubview:segmentedController];
    [self setupTopBarTitle:@"我发布的"];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight, kScreenHeight, topViewHeight)];
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"全部" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
    [btn1 sizeToFit];
    [btn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setTitle:@"售卖中" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
    [btn2 sizeToFit];
    [btn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn3 = [[UIButton alloc] init];
    [btn3 setTitle:@"已下架" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btn3 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn3 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
    [btn3 sizeToFit];
    [btn3 addTarget:self action:@selector(clickBtn3:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn4 = [[UIButton alloc] init];
    [btn4 setTitle:@"待审核" forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:12.f];
    [btn4 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn4 setTitleColor:[UIColor colorWithHexString:@"b4b4b5"] forState:UIControlStateNormal];
    [btn4 sizeToFit];
    [btn4 addTarget:self action:@selector(clickBtn4:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectZero];
    bottonView.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    
    UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight-1, kScreenWidth, 1)];
    bottomLine.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    btn1.selected = YES;
    [self.view addSubview:topView];
    [topView addSubview:btn1];
    [topView addSubview:btn2];
    [topView addSubview:btn3];
    [topView addSubview:btn4];
    [topView addSubview:bottonView];
    [topView addSubview:bottomLine];
    
    self.bottonView = bottonView;
    self.topView = topView;
    self.btn1 = btn1;
    self.btn2 = btn2;
    self.btn3 = btn3;
    self.btn4 = btn4;
    [self setUpUI];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - topBarHeight - 44);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topBarHeight + 44, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight - 44) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [collectionView registerClass:[RecoverCollectionViewCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    if (self.collectionViewIP) {
        [collectionView scrollToItemAtIndexPath:self.collectionViewIP atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        if (self.collectionViewIP.item == 1) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width + 20 * 1, topViewHeight-2, self.btn2.width, 2);
        } else if (self.collectionViewIP.item == 2) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width + 20 * 2, topViewHeight-2, self.btn3.width, 2);
        } else if (self.collectionViewIP.item == 3) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width + 20 * 3, topViewHeight-2, self.btn4.width, 2);
        }
        
    }
    
    _isRecover = NO;
    
    [self selectedSegment:self.type];
    
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    SearchMyGoodsViewController *viewController = [[SearchMyGoodsViewController alloc] init];
    [self pushViewController:viewController animated:YES];
}

-(void)clickBtn1:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn2:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn3:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn4:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

-(void)setUpUI{
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.topView.mas_left).offset(15);
    }];
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn1.mas_right).offset(20);
    }];
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn2.mas_right).offset(20);
    }];
    [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn3.mas_right).offset(20);
    }];
    NSLog(@"%f", self.btn1.left);
    self.bottonView.frame = CGRectMake(15, topViewHeight-2, self.btn1.width, 2);
    
    [self.view setNeedsDisplay];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < -100) {
        [self dismiss];
    }
    
    NSString *className = [NSString stringWithFormat:@"btn%.f", scrollView.contentOffset.x / kScreenWidth + 1];
    if ([className isEqualToString:@"btn1"]) {
        self.btn1.selected = YES;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.btn4.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15, topViewHeight-2, self.btn1.width, 2);
        }];
    } else if ([className isEqualToString:@"btn2"]) {
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        self.btn3.selected = NO;
        self.btn4.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width + 20 * 1, topViewHeight-2, self.btn2.width, 2);
        }];
    } else if ([className isEqualToString:@"btn3"]) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = YES;
        self.btn4.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width + 20 * 2, topViewHeight-2, self.btn3.width, 2);
        }];
    } else if ([className isEqualToString:@"btn4"]) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.btn4.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width + 20 * 3, topViewHeight-2, self.btn4.width, 2);
        }];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.itemNum;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecoverCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    self.cell = cell;
    cell.onSaleViewController.mineStatus = indexPath.item + 1;
    if (indexPath.item == 0) {
        cell.onSaleViewController.recoverStatus = 10;
    } else if (indexPath.item == 1) {
        cell.onSaleViewController.recoverStatus = 1;
    } else if (indexPath.item == 2) {
        cell.onSaleViewController.recoverStatus = 0;
    }
    
    NSInteger Code;
    if (_isRecover) {
        switch (indexPath.item) {
            case 0:
                [self client:RecoverAllViewCode];
                Code = RecoverAllViewCode;
                break;
            case 1:
                [self client:RecoverWaitRecoverViewCode];
                Code = RecoverWaitRecoverViewCode;
                break;
            case 2:
                [self client:RecoverEndViewCode];
                Code = RecoverEndViewCode;
                break;
            default:
                break;
        }
    } else {
        switch (indexPath.item) {
            case 0:
                [self client:RecoverOneSelfAllViewCode];
                Code = RecoverOneSelfAllViewCode;
                break;
            case 1:
                [self client:RecoverOneSelfSoldingViewCode];
                Code = RecoverOneSelfSoldingViewCode;
                break;
            case 2:
                [self client:RecoverOneSelfEndViewCode];
                Code = RecoverOneSelfEndViewCode;
                break;
            case 3:
                [self client:RecoverOneSelfWaitCheckViewCode];
                Code = RecoverOneSelfWaitCheckViewCode;
                break;
            default:
                break;
        }
    }
    cell.onSaleViewController.viewCode = Code;
    if (_isRecover) {
        cell.onSaleViewController.type = 2;
    } else {
        cell.onSaleViewController.type = 1;
    }
    
    [cell.onSaleViewController initDataListLogic];
    
    return cell;
}

-(void)client:(NSInteger)regionCode{
    [ClientReportObject clientReportObjectWithViewCode:MineOnSaleViewCode regionCode:regionCode referPageCode:regionCode andData:nil];
}

-(void)selectedSegment:(NSInteger)type{
    switch (type) {
        case 0:
            self.isRecover = NO;
            self.btn4.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setMineSold" object:nil];
            self.itemNum = 4;
            [self.btn1 setTitle:@"全部" forState:UIControlStateNormal];
            [self.btn2 setTitle:@"售卖中" forState:UIControlStateNormal];
            [self.btn3 setTitle:@"已下架" forState:UIControlStateNormal];
            [self.btn4 setTitle:@"待审核" forState:UIControlStateNormal];
            [self.collectionView reloadData];
            break;
        case 1:
            self.isRecover = YES;
            self.btn4.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setRecoverSold" object:nil];
            self.itemNum = 3;
            [self.btn1 setTitle:@"全部" forState:UIControlStateNormal];
            [self.btn2 setTitle:@"待回收" forState:UIControlStateNormal];
            [self.btn3 setTitle:@"已下架" forState:UIControlStateNormal];
            [self.collectionView reloadData];
            break;
        default:
            break;
    }
}

-(void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %ld", Index);
    switch (Index) {
        case 0:
            self.isRecover = NO;
            self.btn4.hidden = NO;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setMineSold" object:nil];
            self.itemNum = 4;
            [self.btn1 setTitle:@"全部" forState:UIControlStateNormal];
            [self.btn2 setTitle:@"售卖中" forState:UIControlStateNormal];
            [self.btn3 setTitle:@"已下架" forState:UIControlStateNormal];
            [self.btn4 setTitle:@"待审核" forState:UIControlStateNormal];
            [self.collectionView reloadData];
            break;
        case 1:
            self.isRecover = YES;
            self.btn4.hidden = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:@"setRecoverSold" object:nil];
            self.itemNum = 3;
            [self.btn1 setTitle:@"全部" forState:UIControlStateNormal];
            [self.btn2 setTitle:@"待回收" forState:UIControlStateNormal];
            [self.btn3 setTitle:@"已下架" forState:UIControlStateNormal];
            [self.collectionView reloadData];
            break;
        default:
            break;
    }
}

@end

@interface RecoverCollectionViewCell ()

@end

@implementation RecoverCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.onSaleViewController = [[OnSaleViewController alloc] init];
        [self.contentView addSubview:self.onSaleViewController.view];
        
    }
    return self;
}

@end

