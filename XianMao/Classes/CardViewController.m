//
//  CardViewController.m
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CardViewController.h"
#import "ExpenseCardView.h"
#import "DiscountView.h"

@interface CardViewController ()

@property (nonatomic, strong) ExpenseCardView * expenseCardView;
@property (nonatomic, strong) DiscountView * disCountView;

@end

@implementation CardViewController

-(UISegmentedControl *)segmentControl
{
    if (!_segmentControl) {
        _segmentControl = [[UISegmentedControl alloc] initWithItems:[[NSArray alloc]initWithObjects:@"优惠券",@"消费卡",nil]];
        _segmentControl.tintColor = [UIColor colorWithHexString:@"050505"];
        _segmentControl.selectedSegmentIndex = 0;
    }
    return _segmentControl;
}

-(ExpenseCardView *)expenseCardView
{
    if (!_expenseCardView) {
        _expenseCardView = [[ExpenseCardView alloc] init];
        _expenseCardView.hidden = YES;
    }
    return _expenseCardView;
}

-(DiscountView *)disCountView
{
    if (!_disCountView) {
        _disCountView = [[DiscountView alloc] initWithFrame:CGRectMake(0, 65.5, kScreenWidth, kScreenHeight-65.5)];
    }
    return _disCountView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarBackButton];
    [self.topBar addSubview:self.segmentControl];
    [self.segmentControl addTarget:self action:@selector(didClicksegmentedControlAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.expenseCardView];
    [self.view addSubview:self.disCountView];
    
    [self setupUI];
}

- (void)didClicksegmentedControlAction:(UISegmentedControl *)segmentedControl
{
    NSInteger Index = segmentedControl.selectedSegmentIndex;
    switch (Index) {
        case 0:
        {
            _disCountView.hidden = NO;
            _expenseCardView.hidden = YES;
            break;
        }
        case 1:
        {
            _disCountView.hidden = YES;
            _expenseCardView.hidden = NO;
            break;
        }
        default:
            break;
    }
}

- (void)setupUI {
    [self.segmentControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.topBar.mas_centerX);
        make.top.equalTo(self.topBar.mas_top).offset(30);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*150, 28));
    }];
    
    [self.expenseCardView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view).with.insets(UIEdgeInsetsMake(65.5, 0, 0, 0));
    }];
    
 
}



@end
