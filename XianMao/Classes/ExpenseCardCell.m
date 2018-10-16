//
//  ExpenseCardCell.m
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ExpenseCardCell.h"
#import "ConsumptionRechargeViewController.h"

@interface ExpenseCardCell()


@property (nonatomic, strong) XMWebImageView * cardImageView;
@property (nonatomic, strong) AccountCard * accountCard;
@property (nonatomic, strong) UILabel * balance;
@property (nonatomic, strong) UILabel * cardMoney;
@property (nonatomic, strong) UILabel * cardDesc;
@property (nonatomic, strong) UILabel * picDesc;
@property (nonatomic, strong) UIButton * rechargeBtn;

@property (nonatomic, strong) XMWebImageView *selectedView;
@end

@implementation ExpenseCardCell

-(XMWebImageView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _selectedView.image = [UIImage imageNamed:@"selected_card"];
    }
    return _selectedView;
}

-(XMWebImageView *)cardImageView
{
    if (!_cardImageView) {
        _cardImageView = [[XMWebImageView alloc] init];
    }
    return _cardImageView;
}

-(UILabel *)balance
{
    if (!_balance) {
        _balance = [[UILabel alloc] init];
        _balance.textColor = [UIColor whiteColor];
        _balance.font = [UIFont systemFontOfSize:15];
        _balance.textAlignment = NSTextAlignmentRight;
        _balance.text = @"余额:¥";
        [_balance sizeToFit];
    }
    return _balance;
}

-(UILabel *)cardMoney
{
    if (!_cardMoney) {
        _cardMoney = [[UILabel alloc] init];
        _cardMoney.textColor = [UIColor whiteColor];
        _cardMoney.font = [UIFont boldSystemFontOfSize:20];
        _cardMoney.textAlignment = NSTextAlignmentRight;
        [_cardMoney sizeToFit];
    }
    return _cardMoney;
}
- (UIButton *)rechargeBtn
{
    if (!_rechargeBtn) {
        _rechargeBtn = [[UIButton alloc] init];
        _rechargeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _rechargeBtn.layer.borderWidth = 1;
        _rechargeBtn.layer.masksToBounds = YES;
        _rechargeBtn.layer.cornerRadius = 10;
        [_rechargeBtn setTitle:@"充值" forState:UIControlStateNormal];
        _rechargeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    return _rechargeBtn;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ExpenseCardCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    AccountCard * accountCard =  [dict objectForKey:[ExpenseCardCell cellDictKeyForCardInfo]];
    NSInteger height = accountCard.cardPic.height;
    NSInteger width= accountCard.cardPic.width;
    NSInteger rowheight = (kScreenWidth-44)*height/width;
    return rowheight+12;
}

+ (NSMutableDictionary*)buildCellDict:(AccountCard *)accountCard selected:(BOOL)isYesSelect
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ExpenseCardCell class]];
    if (accountCard) {
        [dict setObject:accountCard forKey:[self cellDictKeyForCardInfo]];
    }
    [dict setObject:[NSNumber numberWithBool:isYesSelect] forKey:@"isYesSelected"];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.cardImageView];
        [self.cardImageView addSubview:self.rechargeBtn];
        [self.cardImageView addSubview:self.cardMoney];
        [self.cardImageView addSubview:self.balance];
        [self.cardImageView addSubview:self.selectedView];
        self.selectedView.hidden = YES;
        
        [self.rechargeBtn addTarget:self action:@selector(rechargeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)rechargeBtnClick
{
    if (self.handleRechargeBlock) {
        self.handleRechargeBlock(self.accountCard);
    }
    
    ConsumptionRechargeViewController * recharge = [[ConsumptionRechargeViewController alloc] init];
    recharge.accountCard = self.accountCard;
    [[CoordinatingController sharedInstance] pushViewController:recharge animated:YES];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    BOOL select = [dict boolValueForKey:@"isYesSelected"];
    AccountCard * accountCard =  [dict objectForKey:[ExpenseCardCell cellDictKeyForCardInfo]];
    self.accountCard = accountCard;
    if (accountCard.cardPic.pic_url.length > 0) {
        [self.cardImageView setImageWithURL:accountCard.cardPic.pic_url XMWebImageScaleType:XMWebImageScaleNone];
    }
    
    self.cardMoney.text = [NSString stringWithFormat:@"%.2f",accountCard.cardMoney];
    self.cardDesc.text = accountCard.cardDesc;
    self.picDesc.text = accountCard.cardPic.pic_desc;
    
    if (select) {
        self.selectedView.hidden = NO;
    } else {
        self.selectedView.hidden = YES;
    }
}

+ (NSString*)cellDictKeyForCardInfo {
    return @"accountCard";
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    [self.cardImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(6, 22, 6, 22));
    }];
    
    [self.rechargeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cardImageView.mas_bottom).offset(-18);
        make.right.equalTo(self.cardImageView.mas_right).offset(-20);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*47, 20));
    }];
    
    [self.cardMoney mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.cardImageView.mas_top).offset(20);
        make.right.equalTo(self.cardImageView.mas_right).offset(-17);
    }];
    
    [self.balance mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.cardMoney.mas_bottom);
        make.right.equalTo(self.cardMoney.mas_left);
    }];

    [self.selectedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.cardImageView);
    }];
}

@end
