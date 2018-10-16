//
//  SoldCollectionViewController.m
//  XianMao
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SoldCollectionViewController.h"
#import "SoldViewController.h"
#import "OnSaleViewController.h"
#import "Masonry.h"
@interface SoldCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIButton *btn5;
@property (nonatomic, strong) UIButton *btn6;

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *bottonView;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) SoldCollectionViewCell *cell;

@end

static NSString *ID = @"SoldCollectionViewCell";
static CGFloat topViewHeight = 44;
@implementation SoldCollectionViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarBackButton];
    [super setupTopBarTitle:@"我卖出的"];
    //缺少搜索图片
//    [super setupTopBarRightButton:[UIImage imageNamed:@" "] imgPressed:nil];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight, kScreenHeight, topViewHeight)];
    UIButton *btn1 = [[UIButton alloc] init];
    [btn1 setTitle:@"全部" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn1 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn1 sizeToFit];
    [btn1 addTarget:self action:@selector(clickBtn1:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn2 = [[UIButton alloc] init];
    [btn2 setTitle:@"待发货" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn2 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn2 sizeToFit];
    [btn2 addTarget:self action:@selector(clickBtn2:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn3 = [[UIButton alloc] init];
    [btn3 setTitle:@"已成交" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn3 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn3 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn3 sizeToFit];
    [btn3 addTarget:self action:@selector(clickBtn3:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn4 = [[UIButton alloc] init];
    [btn4 setTitle:@"已关闭" forState:UIControlStateNormal];
    btn4.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn4 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn4 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn4 sizeToFit];
    [btn4 addTarget:self action:@selector(clickBtn4:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn5 = [[UIButton alloc] init];
    [btn5 setTitle:@"待鉴定" forState:UIControlStateNormal];
    btn5.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn5 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn5 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn5 sizeToFit];
    [btn5 addTarget:self action:@selector(clickBtn5:) forControlEvents:UIControlEventTouchUpInside];
    UIButton *btn6 = [[UIButton alloc] init];
    [btn6 setTitle:@"待收货" forState:UIControlStateNormal];
    btn6.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [btn6 setTitleColor:[UIColor colorWithHexString:@"f9384c"] forState:UIControlStateSelected];
    [btn6 setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn6 sizeToFit];
    [btn6 addTarget:self action:@selector(clickBtn6:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *bottonView = [[UIView alloc] initWithFrame:CGRectZero];
    bottonView.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    
    UIView *bottonLine = [[UIView alloc] initWithFrame:CGRectMake(0, topViewHeight-1, kScreenWidth, 1)];
    bottonLine.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    btn1.selected = YES;
    [self.view addSubview:topView];
    
    [topView addSubview:btn1];
    [topView addSubview:btn2];
    [topView addSubview:btn3];
    [topView addSubview:btn4];
    [topView addSubview:btn5];
    [topView addSubview:btn6];
    [topView addSubview:bottonView];
    [topView addSubview:bottonLine];
    
    self.bottonView = bottonView;
    self.topView = topView;
    self.btn1 = btn1;
    self.btn2 = btn2;
    self.btn3 = btn3;
    self.btn4 = btn4;
    self.btn5 = btn5;
    self.btn6 = btn6;
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
    [collectionView registerClass:[SoldCollectionViewCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    if (self.collectionViewIP) {
        [collectionView scrollToItemAtIndexPath:self.collectionViewIP atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
        if (self.collectionViewIP.item == 1) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width + 18 * 1, topBarHeight - 2, self.btn2.width, 2);
        } else if (self.collectionViewIP.item == 2) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width + 18 * 2, topBarHeight - 2, self.btn3.width, 2);
        } else if (self.collectionViewIP.item == 3) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn5.width + 18 * 3, topBarHeight - 2, self.btn5.width, 2);
        }else if (self.collectionViewIP.item == 4) {
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn5.width+self.btn3.width + 18 * 4, topBarHeight - 2, self.btn4.width, 2);
        }
    }
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
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:4 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn4:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:5 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn5:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)clickBtn6:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
-(void)setUpUI{
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.topView.mas_left).offset(15);
    }];
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn1.mas_right).offset(18);
    }];
    [self.btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn2.mas_right).offset(18);
    }];
    [self.btn6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn5.mas_right).offset(18);
    }];
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn6.mas_right).offset(18);
    }];
    [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.mas_centerY);
        make.left.equalTo(self.btn3.mas_right).offset(18);
    }];
    NSLog(@"%f", self.btn1.left);
    self.bottonView.frame = CGRectMake(15, topViewHeight-2, self.btn1.width, 2);
    
    [self.view setNeedsDisplay];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 6;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SoldCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    
    self.cell = cell;
    NSInteger Code;
    switch (indexPath.item) {
        case 0:
            [self client:SoldAllViewCode];
            Code = SoldAllViewCode;
            break;
        case 1:
            [self client:SoldWaitOutGoodsViewCode];
            Code = SoldWaitOutGoodsViewCode;
            break;
        case 2:
            [self client:SoldAlrStrikeViewCode];
            Code = SoldAlrStrikeViewCode;
            break;
        case 3:
            [self client:SoldCloseViewCode];
            Code = SoldCloseViewCode;
            break;
        default:
            break;
    }
    cell.soldViewController.viewCode = Code;
//    cell.soldViewController.status = indexPath.item + 1;
    if (indexPath.item == 0) {
        cell.soldViewController.status = 0;
    } else if (indexPath.item == 1) {
        cell.soldViewController.status = 1;
    } else if (indexPath.item == 2) {
        cell.soldViewController.status = 2;
    } else if (indexPath.item == 3) {
        cell.soldViewController.status = 3;
    } else if (indexPath.item == 4) {
        cell.soldViewController.status = 4;
    } else if (indexPath.item == 5) {
        cell.soldViewController.status = 5;
    }
    NSLog(@"%ld", cell.soldViewController.status);
    [cell.soldViewController initDataListLogic];
    
    return cell;
}

-(void)client:(NSInteger)regionCode{
    [ClientReportObject clientReportObjectWithViewCode:MineSoldViewCode regionCode:regionCode referPageCode:regionCode andData:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < -100) {
        [self dismiss];
    }
    
    NSString *className = [[NSString alloc] init];//[NSString stringWithFormat:@"btn%.f", scrollView.contentOffset.x / kScreenWidth + 1];
    if (scrollView.contentOffset.x / kScreenWidth + 1 == 3) {
        className = @"btn5";
    } else if (scrollView.contentOffset.x / kScreenWidth + 1 == 5) {
        className = @"btn3";
    } else if (scrollView.contentOffset.x / kScreenWidth + 1 == 6) {
        className = @"btn4";
    } else if (scrollView.contentOffset.x / kScreenWidth + 1 == 2) {
        className = @"btn2";
    } else if (scrollView.contentOffset.x / kScreenWidth + 1 == 1) {
        className = @"btn1";
    } else if (scrollView.contentOffset.x / kScreenWidth + 1 == 4) {
        className = @"btn6";
    }
    
    if ([className isEqualToString:@"btn1"]) {
        self.btn1.selected = YES;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.btn4.selected = NO;
        self.btn5.selected = NO;
        self.btn6.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15, topViewHeight - 2, self.btn1.width, 2);
        }];
    } else if ([className isEqualToString:@"btn2"]) {
        self.btn1.selected = NO;
        self.btn2.selected = YES;
        self.btn3.selected = NO;
        self.btn4.selected = NO;
        self.btn5.selected = NO;
        self.btn6.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width + 18 * 1, topViewHeight - 2, self.btn2.width, 2);
        }];
    } else if ([className isEqualToString:@"btn5"]) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.btn4.selected = NO;
        self.btn5.selected = YES;
        self.btn6.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+18*2, topViewHeight - 2, self.btn5.width, 2);
        }];
    } else if ([className isEqualToString:@"btn3"]) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = YES;
        self.btn4.selected = NO;
        self.btn5.selected = NO;
        self.btn6.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width + 18 * 4+self.btn5.width+self.btn6.width, topViewHeight - 2, self.btn3.width, 2);
        }];
    } else if ([className isEqualToString:@"btn4"]) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.btn4.selected = YES;
        self.btn5.selected = NO;
        self.btn6.selected = NO;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn3.width+self.btn5.width+self.btn6.width + 18 * 5, topViewHeight - 2, self.btn4.width, 2);
        }];
    } else if ([className isEqualToString:@"btn6"]) {
        self.btn1.selected = NO;
        self.btn2.selected = NO;
        self.btn3.selected = NO;
        self.btn4.selected = NO;
        self.btn5.selected = NO;
        self.btn6.selected = YES;
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonView.frame = CGRectMake(15 + self.btn1.width+self.btn2.width+self.btn5.width + 18 * 3, topViewHeight - 2, self.btn6.width, 2);
        }];
    }
}

@end



@interface SoldCollectionViewCell ()

@end

@implementation SoldCollectionViewCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.soldViewController = [[SoldViewController alloc] init];
        [self.contentView addSubview:self.soldViewController.view];
        
    }
    return self;
}

@end

