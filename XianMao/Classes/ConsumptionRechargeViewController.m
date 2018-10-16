//
//  ConsumptionRechargeViewController.m
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ConsumptionRechargeViewController.h"
#import "CardView.h"
#import "RechargeAmountView.h"
#import "NetworkAPI.h"
#import "RechargeRule.h"
#import "Error.h"

@interface ConsumptionRechargeViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) CardView * cardView;
@property (nonatomic, strong) RechargeAmountView * amountView;

@end

@implementation ConsumptionRechargeViewController

-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 65.5, kScreenWidth, kScreenHeight-65.5)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(RechargeAmountView *)amountView
{
    if (!_amountView) {
        _amountView = [[RechargeAmountView alloc] initWithFrame:CGRectZero];
    }
    return _amountView;
}

-(CardView *)cardView
{
    if (!_cardView) {
        _cardView = [[CardView alloc] initWithFrame:CGRectZero];
    }
    return _cardView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarTitle:@"消费卡充值"];
    [super setupTopBarBackButton];
    
    [self showLoadingView];
    NSDictionary * parameters = @{@"card_type":[NSNumber numberWithInteger:self.accountCard.cardType]};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"account_card" path:@"recharge_rule_list" parameters:parameters completionBlock:^(NSDictionary *data) {
        [self hideLoadingView];
        NSArray * cardList = data[@"card_list"];
        NSMutableArray * dataSources = [[NSMutableArray alloc] init];
        if (cardList && cardList.count > 0) {
            for (NSDictionary * dict in cardList) {
                RechargeRule * rechargeRule = [RechargeRule createWithDict:dict];
                [dataSources addObject:rechargeRule];
            }
            self.amountView.dataSources = dataSources;
            [self.view addSubview:self.scrollView];
            [self.scrollView addSubview:self.cardView];
            [self.scrollView addSubview:self.amountView];
            self.amountView.accountCard = self.accountCard;
            self.cardView.accountCard = self.accountCard;
            [self customUI];

        }
    } failure:^(XMError *error) {
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
    
}

- (void)customUI
{
    NSInteger marginTop = 0;
    self.cardView.frame = CGRectMake(0, 0, kScreenWidth, 110);
    marginTop += 110;
    self.amountView.frame = CGRectMake(0, marginTop, kScreenWidth, 565);
    marginTop += 565;
    self.scrollView.contentSize = CGSizeMake(kScreenWidth, marginTop);
}




@end
