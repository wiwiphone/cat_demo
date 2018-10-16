//
//  OrderTableViewCell.m
//  XianMao
//
//  Created by simon on 1/14/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "OrderTableViewCell.h"
#import "NSDictionary+Additions.h"
#import "OrderInfo.h"
#import "GoodsInfo.h"
#import "DataSources.h"
#import "Command.h"

#import "Session.h"
#import "NetworkAPI.h"
#import "Masonry.h"

#import "CoordinatingController.h"
#import "ChatViewController.h"
#import "RecoverDetailViewController.h"

#import "BoughtViewController.h"

#import "WeakTimerTarget.h"
#import "User.h"
#import "NSDate+Category.h"
@interface OrderTableViewCell ()

@property(nonatomic,strong) UILabel *timestampLbl;
@property(nonatomic,strong) UILabel *statusDescLbl;
@property(nonatomic,strong) UIView  *goodsViews;
@property(nonatomic,strong) CALayer *topLine;
@property(nonatomic,strong) CALayer *goodsMidLine;
@property(nonatomic,strong) UILabel *totalNumLbl;
@property(nonatomic,strong) UILabel *totalPriceLbl;
@property(nonatomic,strong) CALayer *middleLine;
@property(nonatomic,strong) CALayer *bottomLine;
@property (nonatomic, strong) UILabel *goodsTypeLbl;

@property(nonatomic,strong) CommandButton *selectedBtn;

@property(nonatomic,copy) NSString *orderId;

@property(nonatomic,strong) OrderInfo *orderInfo;

@property (nonatomic, strong) OrderGoodsView *goodsView;

@property (nonatomic, strong) UIImageView *goodsTypeImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, strong) UILabel *timerLbl;
@property (nonatomic, strong) UIButton *timeStatusDescLbl;
@property (nonatomic, strong) UILabel *statusLbl;

@property (nonatomic, strong) UILabel *remTime;
@property (nonatomic, strong) UILabel *remPrice;

@property (nonatomic, strong) UIButton *payExplain;
@end

@implementation OrderTableViewCell

-(UIButton *)payExplain{
    if (!_payExplain) {
        _payExplain = [[UIButton alloc] initWithFrame:CGRectZero];
        [_payExplain setTitle:@"dianji" forState:UIControlStateNormal];
        _payExplain.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _payExplain;
}

-(UILabel *)remPrice{
    if (!_remPrice) {
        _remPrice = [[UILabel alloc] initWithFrame:CGRectZero];
        _remPrice.font = [UIFont systemFontOfSize:12.f];
        _remPrice.textColor = [UIColor colorWithHexString:@"f54d49"];
        [_remPrice sizeToFit];
    }
    return _remPrice;
}

-(UILabel *)remTime{
    if (!_remTime) {
        _remTime = [[UILabel alloc] initWithFrame:CGRectZero];
        _remTime.font = [UIFont systemFontOfSize:12.f];
        _remTime.textColor = [UIColor colorWithHexString:@"f54d49"];
        [_remTime sizeToFit];
    }
    return _remTime;
}

-(UILabel *)statusLbl{
    if (!_statusLbl) {
        _statusLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _statusLbl.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _statusLbl.font = [UIFont systemFontOfSize:14.f];
        [_statusLbl sizeToFit];
    }
    return _statusLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    OrderInfo *orderInfo = [dict objectForKey:[[self class] cellDictKeyForOrderInfo]];
    return [self calculateHeightAndLayoutSubviews:nil orderInfo:orderInfo];
}

+ (NSMutableDictionary*)buildCellDict:(OrderInfo*)orderInfo {
    
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderTableViewCell class]];
    if (orderInfo)[dict setObject:orderInfo forKey:[self cellDictKeyForOrderInfo]];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:[self cellDictKeyForSeleted]];
    
    return dict;
}

+ (NSString*)cellDictKeyForOrderInfo {
    return @"orderInfo";
}

+ (NSString*)cellDictKeyForSeleted {
    return @"seleted";
}

+ (NSString*)cellDictKeyForIsSold {
    return @"isSold";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _rightImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _rightImageView.image = [UIImage imageNamed:@"Right_Allow_New_MF"];
        [_rightImageView sizeToFit];
        [self.contentView addSubview:_rightImageView];
        
        _goodsTypeImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:_goodsTypeImageView];
        
        _goodsTypeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsTypeLbl.textColor = [UIColor blackColor];
        _goodsTypeLbl.font = [UIFont systemFontOfSize:13.f];
        //        _goodsTypeLbl.text = @"阿萨德才XX";
        [self.contentView addSubview:_goodsTypeLbl];
        
        _goodsViews = [[UIView alloc] initWithFrame:CGRectZero];
        _goodsViews.backgroundColor = [UIColor clearColor];
        _goodsViews.clipsToBounds = YES;
        [self.contentView addSubview:_goodsViews];
        
        
        _selectedBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_selectedBtn setImage:[UIImage imageNamed:@"shopping_cart_uncgoose_new"] forState:UIControlStateNormal];
        [_selectedBtn setImage:[UIImage imageNamed:@"shopping_cart_choosed_new"] forState:UIControlStateSelected];
        _selectedBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        _selectedBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        [self.contentView addSubview:_selectedBtn];
        _selectedBtn.hidden = YES;
        
        WEAKSELF;
        _selectedBtn.handleClickBlock = ^(CommandButton *sender) {
            
            if (weakSelf.handleOrderActionSelectBlock) {
                weakSelf.handleOrderActionSelectBlock(weakSelf.orderId);
            }
        };
        
        _timestampLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timestampLbl.textColor = [UIColor colorWithHexString:@"A7A7A7"];
        _timestampLbl.font = [UIFont systemFontOfSize:10.f];
        _timestampLbl.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_timestampLbl];
        
        _statusDescLbl = [[UILabel alloc] initWithFrame:CGRectZero];//CGRectNull];
        _statusDescLbl.backgroundColor = [UIColor clearColor];
        _statusDescLbl.textColor = [UIColor colorWithHexString:@"E56573"];
        _statusDescLbl.textAlignment = NSTextAlignmentRight;
        _statusDescLbl.font = [UIFont systemFontOfSize:12.f];
        _statusDescLbl.numberOfLines = 0;
        [self addSubview:_statusDescLbl];
        
        
        _topLine = [CALayer layer];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_topLine];
        
        _goodsMidLine = [CALayer layer];
        _goodsMidLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_goodsMidLine];
        
        _totalNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalNumLbl.font = [UIFont systemFontOfSize:11.5f];
        _totalNumLbl.textColor = [UIColor colorWithHexString:@"181818"];
        [self.contentView addSubview:_totalNumLbl];
        
        _totalPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _totalPriceLbl.font = [UIFont systemFontOfSize:11.5f];
        _totalPriceLbl.textColor = [UIColor colorWithHexString:@"181818"];
        [self.contentView addSubview:_totalPriceLbl];
        
        _middleLine = [CALayer layer];
        _middleLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_middleLine];
        
        _actionsView = [[OrderActionsView alloc] initWithFrame:CGRectZero];//CGRectNull];
        _actionsView.orderTableViewCell = self;
        [self.contentView addSubview:_actionsView];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.contentView.layer addSublayer:_bottomLine];
        
        _timeStatusDescLbl = [[UIButton alloc] initWithFrame:CGRectZero];
        [_timeStatusDescLbl setTitleColor:[UIColor colorWithHexString:@"A7A7A7"] forState:UIControlStateNormal];
        _timeStatusDescLbl.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _timeStatusDescLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _timeStatusDescLbl.enabled = NO;
        _timeStatusDescLbl.hidden = YES;
        [self.contentView addSubview:_timeStatusDescLbl];
        
        _timerLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timerLbl.textColor = [UIColor colorWithHexString:@"A7A7A7"];
        _timerLbl.font = [UIFont systemFontOfSize:12.f];
        _timerLbl.numberOfLines = 1;
        _timerLbl.attributedText = nil;
        _timerLbl.hidden = YES;
        [self.contentView addSubview:_timerLbl];
        
        [self.contentView addSubview:self.statusLbl];
        [self.contentView addSubview:self.remPrice];
        [self.contentView addSubview:self.remTime];
        
        [self.contentView addSubview:self.payExplain];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doUpdateOrderInfoView:) name:kDoUpdateOrderInfoNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doUpdateOrderInfoView:) name:kDoUpdateOrderInfoInDetailNotification object:nil];
        
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doUpdateOrderInfoView:) name:kDoUpdateOrderInfoNotification object:nil];
    }
    return self;
}
- (void)dealloc
{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)doUpdateOrderInfoView:(NSNotification*)notifi
{
    NSArray *orderIds = (NSArray*)notifi.object;
    if ([orderIds isKindOfClass:[NSArray class]]) {
        if ([orderIds containsObject:self.orderInfo.orderId]) {
            //            if ([[self.goodsViews subviews] count]>=[self.orderInfo.goodsList count]) {
            //                for (NSInteger i=0;i<[self.orderInfo.goodsList count];i++) {
            //                    GoodsInfo *goodsInfo = [self.orderInfo.goodsList objectAtIndex:i];
            //                    OrderGoodsView *goodsView = [[self.goodsViews subviews] objectAtIndex:i];
            //                    [goodsView updateWithOrderInfo:goodsInfo orderInfo:self.orderInfo];
            //                }
            //            }
            [self updateCellWithDict:@{@"orderInfo":self.orderInfo}];
        }
    }
    
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _selectedBtn.hidden = YES;
    
    _timestampLbl.frame = CGRectZero;
    _statusDescLbl.text = nil;
    _statusDescLbl.frame = CGRectZero;
    NSArray *subviews = [_goodsViews subviews];
    for (NSInteger i=0;i<[subviews count];i++) {
        UIView *view = (UIView*)[subviews objectAtIndex:i];
        view.hidden = YES;
    }
    _topLine.frame = CGRectZero;
    _goodsMidLine.frame = CGRectZero;
    _totalNumLbl.frame = CGRectZero;
    _totalPriceLbl.frame = CGRectZero;
    _middleLine.frame = CGRectZero;
    _middleLine.hidden = YES;
    
    [_actionsView prepareForReuse];
    
    _bottomLine.frame = CGRectZero;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [[self class] calculateHeightAndLayoutSubviews:self orderInfo:_orderInfo];
    [self.goodsView layoutSubviews];
}

+ (CGFloat)orderActionsViewHeight:(OrderInfo*)orderInfo
{
    return [OrderActionsView heightForOrientationPortrait:orderInfo];
}

+ (CGFloat)calculateHeightAndLayoutSubviews:(OrderTableViewCell*)cell orderInfo:(OrderInfo*)orderInfo {
    CGFloat marginTop = 0.f;
    
    marginTop += 15;
    
    //    if (cell) {
    //        cell.timestampLbl.frame = CGRectMake(15, marginTop, cell.contentView.width-30, 12);
    //        [cell.statusDescLbl sizeToFit];
    //        cell.statusDescLbl.frame = CGRectMake(cell.contentView.width-15-cell.statusDescLbl.width, marginTop, cell.statusDescLbl.width, cell.statusDescLbl.height);
    //    }
    //    marginTop += 10;
    
    //    marginTop += 15;
    
    if (cell && orderInfo.goodsList.count > 0) {
        
        
        [cell.goodsTypeImageView sizeToFit];
        cell.goodsTypeImageView.frame = CGRectMake(15, marginTop-2, 20, 20);
        cell.goodsTypeImageView.layer.cornerRadius = 10;
        cell.goodsTypeImageView.layer.masksToBounds = YES;
        //        switch (orderInfo.orderStatus) {
        //            case 1:
        //                cell.goodsTypeLbl.text = @"寄卖交易";
        //                break;
        //            case 2:
        //                cell.goodsTypeLbl.text = @"寄卖交易";
        //                break;
        //            case 1:
        //                cell.goodsTypeLbl.text = @"寄卖交易";
        //                break;
        //            case 1:
        //                cell.goodsTypeLbl.text = @"寄卖交易";
        //                break;
        //            case 1:
        //                cell.goodsTypeLbl.text = @"寄卖交易";
        //                break;
        //            case 1:
        //                cell.goodsTypeLbl.text = @"寄卖交易";
        //                break;
        //            case 1:
        //                cell.goodsTypeLbl.text = @"寄卖交易";
        //                break;
        //            case 1:
        //                cell.goodsTypeLbl.text = @"寄卖交易";
        //                break;
        //            case 1:
        //                cell.goodsTypeLbl.text = @"寄卖交易";
        //                break;
        //            default:
        //                break;
        //        }
        
        
        
        [cell.goodsTypeLbl sizeToFit];
        cell.goodsTypeLbl.frame = CGRectMake(cell.goodsTypeImageView.right + 8, marginTop, cell.goodsTypeLbl.width, cell.goodsTypeLbl.height);
        
        cell.rightImageView.frame = CGRectMake(cell.goodsTypeLbl.right + 8, marginTop, cell.rightImageView.width, cell.rightImageView.height);
        
        [cell.statusLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(cell.contentView.mas_right).offset(-12);
            make.centerY.equalTo(cell.goodsTypeLbl.mas_centerY);
        }];
        
        marginTop += cell.goodsTypeLbl.height;
        marginTop += 10;
        
        CGFloat selectAllBtnWidth = 50;
        CGFloat marginLeft = [cell.selectedBtn isHidden]?0:selectAllBtnWidth-15;
        CGFloat marginTopPrev = marginTop;
        CGFloat marginTopSubview = 0.f;
        cell.goodsViews.frame = CGRectMake(marginLeft, marginTopPrev, cell.contentView.width-marginLeft, 0);
        NSArray *subviews = [cell.goodsViews subviews];
        for (NSInteger i=0;i<[subviews count];i++) {
            OrderGoodsView *view = (OrderGoodsView*)[subviews objectAtIndex:i];
            if (!view.hidden) {
                //                NSArray *subLayers = [view.layer sublayers];
                //                if (i > 0) {
                //                    CALayer *layer = [subLayers objectAtIndex:4];
                //                    layer.frame = CGRectMake(15, marginTop, cell.contentView.width-30, 20);
                //                    marginTop += 20;
                //                    marginTopSubview += 20;
                //                }
                view.frame = CGRectMake(0, marginTopSubview, cell.goodsViews.width, [OrderGoodsView heightForOrientationPortrait]);
                marginTopSubview += view.height;
                marginTop += [OrderGoodsView heightForOrientationPortrait];
                
                //                if (i != [subviews count]-1) {
                //
                //                    CALayer *midLine1 = [subLayers objectAtIndex:5];
                //
                //                    midLine1.frame = CGRectMake(15, marginTop, cell.contentView.width-30, 10);
                //
                //                    marginTop += 10;
                //                    marginTopSubview += 10;
                //
                //                    CALayer *goodsMidLine = [subLayers objectAtIndex:6];
                //                    goodsMidLine.frame = CGRectMake(15, marginTop, cell.contentView.width-30, 1);
                //                    marginTop += 1;
                //                    marginTopSubview += 1;
                //                }
                
            }
        }
        if ([cell.selectedBtn isHidden]) {
            cell.goodsViews.frame = CGRectMake(0, marginTopPrev, cell.contentView.width, marginTop-marginTopPrev);
        } else {
            cell.selectedBtn.frame = CGRectMake(0, marginTopPrev, selectAllBtnWidth,marginTop-marginTopPrev);
            cell.goodsViews.frame = CGRectMake(marginLeft, marginTopPrev, cell.contentView.width-marginLeft, marginTop-marginTopPrev);
        }
        
        
    } else {
        for (NSInteger i=0;i<[orderInfo.goodsList count];i++) {
            marginTop += [OrderGoodsView heightForOrientationPortrait];
        }
    }
    
    //    if (cell) {
    //        cell.topLine.frame = CGRectMake(15, marginTop, cell.contentView.width-30, 1);
    //    }
    //    marginTop += 1;
    
    //    if (cell) {
    //        [cell.totalNumLbl sizeToFit];
    //        cell.totalNumLbl.frame = CGRectMake(15, marginTop, cell.totalNumLbl.width, 44);
    //
    //        [cell.totalPriceLbl sizeToFit];
    //        cell.totalPriceLbl.frame = CGRectMake(cell.contentView.width-cell.totalPriceLbl.width-15, marginTop, cell.totalPriceLbl.width, 44);
    //    }
    //    marginTop += 38;
    
    if (cell && orderInfo.goodsList.count > 0) {
        //        [cell.timeStatusDescLbl setImage:[UIImage imageNamed:@"trade_icon_time"] forState:UIControlStateDisabled];
        //        [cell.timeStatusDescLbl sizeToFit];
        cell.timeStatusDescLbl.frame = CGRectMake(15, marginTop + 15, cell.timeStatusDescLbl.width, cell.timeStatusDescLbl.height);
        //        if ([cell.timeStatusDescLbl imageForState:UIControlStateDisabled]) {
        //            [cell.timeStatusDescLbl sizeToFit];
        //            cell.timeStatusDescLbl.frame = CGRectMake(15, marginTop, cell.timeStatusDescLbl.width+cell.timeStatusDescLbl.titleEdgeInsets.left+cell.timeStatusDescLbl.titleEdgeInsets.right, cell.timeStatusDescLbl.height);
        //        } else {
        //            CGSize size = [[cell.timeStatusDescLbl titleForState:UIControlStateDisabled] sizeWithFont:cell.timeStatusDescLbl.titleLabel.font constrainedToSize:CGSizeMake(cell.contentView.width-15-15, 0)];
        //            cell.timeStatusDescLbl.frame = CGRectMake(15, marginTop, size.width, size.height);
        //        }
        
        [cell.timerLbl sizeToFit];
        cell.timerLbl.frame = CGRectMake(15+5+cell.timeStatusDescLbl.width, marginTop + 15, cell.timerLbl.width, cell.timerLbl.height);
    }
    
    if (cell && orderInfo.goodsList.count > 0) {
        cell.middleLine.frame = CGRectMake(15, marginTop, cell.contentView.width-30, 1);
    }
    marginTop += 1;
    
    if (cell && orderInfo.goodsList.count > 0) {
        cell.actionsView.frame = CGRectMake(0, marginTop, cell.contentView.width, [self orderActionsViewHeight:orderInfo]);
        marginTop += cell.actionsView.height;
    } else {
        marginTop += [self orderActionsViewHeight:orderInfo];
    }
    
    //    if (cell) {
    //        cell.remPrice.frame = CGRectMake(kScreenWidth-cell.remPrice.width-14, marginTop, cell.remPrice.width, cell.remPrice.height);
    //    }
    
    if (cell && orderInfo.goodsList.count > 0) {
        cell.bottomLine.frame = CGRectMake(0, marginTop, cell.contentView.width, 1);
    }
    
    //    if (cell) {
    //        cell.remTime.frame = CGRectMake(14, marginTop+30, cell.remTime.width, cell.remPrice.height);
    //    }
    
    if (cell && orderInfo.goodsList.count > 0) {
        [cell.remPrice mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(cell.goodsView.mas_bottom).offset(-5);
            make.right.equalTo(cell.contentView.mas_right).offset(-14);
        }];
        
        //        cell.remPrice.frame = CGRectMake(kScreenWidth-cell.remPrice.width-14, cell.goodsView.bottom-cell.remPrice.height-5, cell.remPrice.width, cell.remPrice.height);
        //        cell.remTime.frame = CGRectMake(12, cell.goodsView.bottom+30, cell.remTime.width, cell.remTime.height);
        
        [cell.remTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.goodsView.mas_bottom).offset(30);
            make.left.equalTo(cell.contentView.mas_left).offset(12);
        }];
    }
    
    marginTop += 1;
    
    //为上面的goodsTypeLbl平衡
    marginTop += 20;
    return marginTop;
}

- (void)updateCellWithDict:(NSDictionary*)dict {
    OrderInfo *orderInfo = [dict objectForKey:[[self class] cellDictKeyForOrderInfo]];
    User *user = orderInfo.user;
    if (orderInfo) {
        
        self.orderInfo = orderInfo;
        
        self.orderId = orderInfo.orderId;
        
        if (orderInfo.logic_type == NOMALGOODS) {
            self.goodsTypeLbl.text = user.userName;//@"普通商品";
            [self.goodsTypeImageView sd_setImageWithURL:[NSURL URLWithString:user.avatarUrl]];
        } else if (orderInfo.logic_type == RETURNGOODS) {
            self.goodsTypeLbl.text = @"原价回购";
            self.goodsTypeImageView.image = [UIImage imageNamed:@"WristwatchRecovery_GoodsDetail_Icon_Black"];
        } else if (orderInfo.logic_type == SELFGOODS) {
            self.goodsTypeLbl.text = @"自选商品";
            self.goodsTypeImageView.image = [UIImage imageNamed:@"Self_Goods"];
        }
        
        self.statusLbl.text = orderInfo.shortStatusDesc;
        
        _selectedBtn.hidden = YES;//![orderInfo isWaitingForPay] || orderInfo.payWay == PayWayOffline;
        _selectedBtn.selected = [dict boolValueForKey:[OrderTableViewCell cellDictKeyForSeleted]];
        
        _timestampLbl.text = [NSDate stringForTimestampSince1970:orderInfo.createTime];
        _statusDescLbl.text = orderInfo.statusDesc;
        _timestampLbl.hidden = YES;
        _statusDescLbl.hidden = YES;
        
        NSArray *subviews = [_goodsViews subviews];
        NSInteger count = [subviews count];
        if (count<[orderInfo.goodsList count]) {
            for (NSInteger i=count;i<[orderInfo.goodsList count];i++) {
                OrderGoodsView *goodsView = [[OrderGoodsView alloc] init];
                self.goodsView = goodsView;
                goodsView.hidden = YES;
                goodsView.orderTableViewCell = self;
                [_goodsViews addSubview:goodsView];
                
                
                //                    CALayer *midLine = [CALayer layer];
                //                    midLine.backgroundColor = [UIColor clearColor].CGColor;
                //                   // midLine.frame = CGRectMake(15, marginTop, cell.contentView.width-30, 20);
                //                    [goodsView.layer addSublayer:midLine];
                //                   // marginTop += 20;
                //                    //marginTopSubview += 20;
                //
                //
                //
                //
                //                    CALayer *midLine1 = [CALayer layer];
                //                    midLine1.backgroundColor = [UIColor clearColor].CGColor;
                //                   // midLine1.frame = CGRectMake(15, marginTop, cell.contentView.width-30, 10);
                //                    [goodsView.layer addSublayer:midLine1];
                ////                    marginTop += 10;
                ////                    marginTopSubview += 10;
                //
                //                    CALayer *goodsMidLine = [CALayer layer];
                //                    goodsMidLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
                //                    //goodsMidLine.frame = CGRectMake(15, marginTop, cell.contentView.width-30, 1);
                //                    [goodsView.layer addSublayer:goodsMidLine];
                ////                    marginTop += 1;
                ////                    marginTopSubview += 1;
                //
            }
        }
        
        double totalPrice = orderInfo.totalPrice;
        if (orderInfo.payStatus==2) {
            totalPrice = ((double)orderInfo.actual_pay_cent/100.f)+ + ((double)orderInfo.adm_money_pay_cent/100.f);
        }
        
        for (NSInteger i=0;i<[orderInfo.goodsList count];i++) {
            GoodsInfo *goodsInfo = [orderInfo.goodsList objectAtIndex:i];
            OrderGoodsView *goodsView = [[_goodsViews subviews] objectAtIndex:i];
            goodsView.hidden = NO;
            [goodsView updateWithOrderInfo:goodsInfo orderInfo:orderInfo];
            _actionsView.goodsInfo = goodsInfo;
            //            totalPrice += goodsInfo.dealPrice;
        }
        
        _totalNumLbl.text = [NSString stringWithFormat:@"共%lu件商品",(long)[orderInfo.goodsList count]];
        
        NSString *totalPriceTitle = @"实付款：";
        NSString *totalPriceString = [NSString stringWithFormat:@"¥ %.2f",totalPrice];
        NSString *mailPriceTitle = @"邮费：";
        NSString *mailPriceString = @"包邮";
        
        NSString *labelText = [NSString stringWithFormat:@"%@%@  %@%@",mailPriceTitle,mailPriceString,totalPriceTitle,totalPriceString];
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c2a79d"] range:NSMakeRange(mailPriceTitle.length, [mailPriceString length])];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c2a79d"] range:NSMakeRange(labelText.length-totalPriceString.length, [totalPriceString length])];
        _totalPriceLbl.attributedText = attributedString;
        
        CGFloat actionsViewHeight = [[self class] orderActionsViewHeight:orderInfo];
        _middleLine.hidden = actionsViewHeight>0?NO:YES;
        
        _statusDescLbl.textColor = orderInfo.orderStatus == 0?[UIColor colorWithHexString:@"e01111"]:[UIColor colorWithHexString:@"A7A7A7"];
        
        [_actionsView updateWithOrderInfo:orderInfo];
        
        if (orderInfo.orderStatus==0) {
            if (orderInfo.payStatus==0) {
                //付款倒计时
                [_timeStatusDescLbl setImage:[UIImage imageNamed:@"trade_icon_time"] forState:UIControlStateDisabled];
                _timeStatusDescLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
                _timerLbl.attributedText = orderInfo.pay_remainingString;
                _timerLbl.hidden = NO;
                _timeStatusDescLbl.hidden = NO;
            }
            else if (orderInfo.payStatus==2 && orderInfo.shippingStatus==1) {
                //确认收货倒计时
                [_timeStatusDescLbl setImage:[UIImage imageNamed:@"trade_icon_time"] forState:UIControlStateDisabled];
                _timeStatusDescLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
                _timerLbl.attributedText = orderInfo.receive_remainingString;
                _timerLbl.hidden = NO;
                _timeStatusDescLbl.hidden = NO;
            }
            else if (orderInfo.payStatus==2 && orderInfo.refund_status==1) {
                //1申请退款中
                [_timeStatusDescLbl setImage:[UIImage imageNamed:@"trade_icon_time"] forState:UIControlStateDisabled];
                _timeStatusDescLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
                _timerLbl.attributedText = orderInfo.refund_remainingString;
                _timerLbl.hidden = NO;
                _timeStatusDescLbl.hidden = NO;
            } else {
                _timerLbl.hidden = YES;
                _timeStatusDescLbl.hidden = YES;
            }
            [_timerLbl sizeToFit];
            [_timeStatusDescLbl sizeToFit];
        } else {
            _timerLbl.hidden = YES;
            _timeStatusDescLbl.hidden = YES;
        }
        
        if (orderInfo.pay_remaining > 0) {
            //            NSDate *date = [NSDate dateWithTimeIntervalSince1970:orderInfo.pay_remaining];
            if (orderInfo.pay_remaining/3600 > 1) {
                self.remTime.text = [NSString stringWithFormat:@"付款剩余%ld小时", orderInfo.pay_remaining/3600];//[date formattedDateDescriptionMF];
            } else {
                self.remTime.text = [NSString stringWithFormat:@"付款剩余%ld分钟", orderInfo.pay_remaining/60];//[date formattedDateDescriptionMF];
            }
            
        }
        
        self.remPrice.text = [NSString stringWithFormat:@"还需付款¥%.2f", orderInfo.remain_price];
        
        if (orderInfo.payStatus == 1 && orderInfo.orderStatus == 0) {
            self.remTime.hidden = NO;
            self.remPrice.hidden = NO;
        } else {
            self.remTime.hidden = YES;
            self.remPrice.hidden = YES;
        }
        
        [self setNeedsDisplay];
    }
}

@end


@interface OrderGoodsView ()

@property(nonatomic,strong) XMWebImageView *thumbView;
@property(nonatomic,strong) UILabel *nameLbl;
@property(nonatomic,strong) UILabel *gradeLbl;
@property(nonatomic,strong) UILabel *shopPriceLbl;
@property(nonatomic,strong) CommandButton *modifyPriceBtn;
@property(nonatomic,assign) BOOL isCanModifyPrice;
@property(nonatomic,assign) BOOL isCopyEnable;

@property(nonatomic,strong) CommandButton *renewBtn;

@property(nonatomic,strong) UIButton *statusDescLbl;
@property(nonatomic,strong) UILabel *timerLbl;

@property(nonatomic,copy) NSString *orderId;
@property(nonatomic,copy) NSString *goodsId;

@property(nonatomic,strong) GoodsInfo *goodsInfo;
@property(nonatomic,strong) OrderInfo *orderInfo;

@property (nonatomic, strong) UIButton *deterImageBtn;
@property (nonatomic, strong) UILabel *countLbl;
@property (nonatomic, strong) UILabel *payPriceLbl;
@property (nonatomic, strong) UIImageView * washIcon;

@end

@implementation OrderGoodsView

-(UIImageView *)washIcon
{
    if (!_washIcon) {
        _washIcon = [[UIImageView alloc] init];
        _washIcon.image = [UIImage imageNamed:@"washIcon_wjh"];
        _washIcon.hidden = YES;
    }
    return _washIcon;
}

-(UILabel *)payPriceLbl{
    if (!_payPriceLbl) {
        _payPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _payPriceLbl.textColor = [DataSources colorf9384c];
        _payPriceLbl.font = [UIFont systemFontOfSize:15.f];
        [_payPriceLbl sizeToFit];
    }
    return _payPriceLbl;
}

-(UILabel *)countLbl{
    if (!_countLbl) {
        _countLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _countLbl.textColor = [UIColor colorWithHexString:@"bbbbbb"];
        _countLbl.font = [UIFont systemFontOfSize:13.f];
        _countLbl.text = @"×1";
        [_countLbl sizeToFit];
    }
    return _countLbl;
}

-(UIButton *)deterImageBtn{
    if (!_deterImageBtn) {
        _deterImageBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_deterImageBtn setImage:[UIImage imageNamed:@"Raisal_G_MF"] forState:UIControlStateNormal];
        [_deterImageBtn setImage:[UIImage imageNamed:@"Raisal_S_MF_New"] forState:UIControlStateSelected];
        _deterImageBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _deterImageBtn;
}

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, [[self class] heightForOrientationPortrait])];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.deterImageBtn.userInteractionEnabled = NO;
        [self addSubview:self.deterImageBtn];
        
        _thumbView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _thumbView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _thumbView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbView.clipsToBounds = YES;
        [self addSubview:_thumbView];
        
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLbl.font = [UIFont systemFontOfSize:15.f];
        _nameLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _nameLbl.numberOfLines = 2;
        [self addSubview:_nameLbl];
        
        _gradeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _gradeLbl.font = [UIFont systemFontOfSize:15.f];
        _gradeLbl.textColor = [UIColor colorWithHexString:@"A7A7A7"];
        _gradeLbl.numberOfLines = 0;
        [self addSubview:_gradeLbl];
        
        _shopPriceLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _shopPriceLbl.font = [UIFont boldSystemFontOfSize:15.f];
        _shopPriceLbl.textColor = [UIColor colorWithHexString:@"181818"];
        _shopPriceLbl.numberOfLines = 0;
        [self addSubview:_shopPriceLbl];
        
        //        _renewBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        //        _renewBtn.layer.masksToBounds = YES;
        //        _renewBtn.layer.cornerRadius = 5.f;
        //        _renewBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        //        _renewBtn.layer.borderWidth = 1.0f;
        //        [_renewBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        //        _renewBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        //        [_renewBtn setTitle:@"重新上架" forState:UIControlStateNormal];
        //        [self addSubview:_renewBtn];
        
        _modifyPriceBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _modifyPriceBtn.layer.masksToBounds = YES;
        _modifyPriceBtn.layer.cornerRadius = 5.f;
        _modifyPriceBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
        _modifyPriceBtn.layer.borderWidth = 1.0f;
        [_modifyPriceBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
        _modifyPriceBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [_modifyPriceBtn setTitle:@"修改价格" forState:UIControlStateNormal];
        [self addSubview:_modifyPriceBtn];
        
        _statusDescLbl = [[UIButton alloc] initWithFrame:CGRectZero];
        [_statusDescLbl setTitleColor:[UIColor colorWithHexString:@"A7A7A7"] forState:UIControlStateNormal];
        _statusDescLbl.titleLabel.font = [UIFont systemFontOfSize:12.f];
        _statusDescLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        _statusDescLbl.enabled = NO;
        [self addSubview:_statusDescLbl];
        
        _timerLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timerLbl.textColor = [UIColor colorWithHexString:@"A7A7A7"];
        _timerLbl.textColor = [UIColor colorWithHexString:@"f4433e"];
        _timerLbl.font = [UIFont systemFontOfSize:12.f];
        _timerLbl.numberOfLines = 1;
        [self addSubview:_timerLbl];
        
        [self addSubview:self.countLbl];
        [self addSubview:self.payPriceLbl];
        [self addSubview:self.washIcon];
        WEAKSELF;
        _thumbView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            if (weakSelf.goodsInfo.serviceType == 10) {
                //                [[CoordinatingController sharedInstance] gotoRecoverDetailViewController:weakSelf.goodsId index:1 animated:YES];
                [[CoordinatingController sharedInstance] gotoOfferedViewController:weakSelf.goodsId index:1 animated:YES];
            } else {
                [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:weakSelf.goodsId animated:YES];
            }
        };
        
        _modifyPriceBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderGoodsModifyPriceBlock) {
                
                weakSelf.orderTableViewCell.handleOrderGoodsModifyPriceBlock(weakSelf.orderId,weakSelf.goodsInfo);
            }
        };
        _renewBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionRenewGoodsBlock) {
                weakSelf.orderTableViewCell.handleOrderActionRenewGoodsBlock(weakSelf.goodsId);
            }
        };
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doUpdateOrderInfoView:) name:kDoUpdateOrderInfoNotification object:nil];
        //        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(doUpdateOrderInfoView:) name:kDoUpdateOrderInfoInDetailNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)doUpdateOrderInfoView:(NSNotification*)notifi
{
    NSArray *orderIds = (NSArray*)notifi.object;
    if ([orderIds isKindOfClass:[NSArray class]]) {
        if ([orderIds containsObject:self.orderInfo.orderId]) {
            [self updateWithOrderInfo:self.goodsInfo orderInfo:self.orderInfo isCanModifyPrice:self.isCanModifyPrice isCopyEnable:self.isCopyEnable];
        }
    }
    
}

+ (CGFloat)heightForOrientationPortrait {
    return 95+38.f;
}

- (void)prepareForReuse {
    
}

- (void)updateWithOrderInfo:(GoodsInfo*)goodsInfo orderInfo:(OrderInfo*)orderInfo {
    [self updateWithOrderInfo:goodsInfo orderInfo:orderInfo isCanModifyPrice:NO isCopyEnable:NO];
}

- (void)updateWithOrderInfo:(GoodsInfo*)goodsInfo orderInfo:(OrderInfo*)orderInfo isCanModifyPrice:(BOOL)isCanModifyPrice isCopyEnable:(BOOL)isCopyEnable {
    
    //    [_thumbView sd_setImageWithURL:[NSURL URLWithString:goodsInfo.thumbUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    //    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.orderInfo.tradeType == 9) {
            self.deterImageBtn.hidden = YES;
        }else{
            self.deterImageBtn.hidden = NO;
            if (orderInfo.securedStatus == 6) {
                self.deterImageBtn.selected = NO;
            } else {
                self.deterImageBtn.selected = YES;
            }
        }
    });
    
    if (goodsInfo.guarantee.iconUrl.length > 0) {
        self.washIcon.hidden = NO;
    }else{
        self.washIcon.hidden = YES;
    }
    
    _isCopyEnable = isCopyEnable;
    _isCanModifyPrice = isCanModifyPrice;
    _goodsInfo = goodsInfo;
    _orderInfo = orderInfo;
    _orderId = orderInfo.orderId;
    _goodsId = goodsInfo.goodsId;
    
    _renewBtn.hidden = !isCopyEnable;
    _modifyPriceBtn.hidden = YES;//!isCanModifyPrice;
    if (![_modifyPriceBtn isHidden] || orderInfo.tradeType == 5) {
        _renewBtn.hidden = YES;
    }
    
    [_thumbView setImageWithURL:goodsInfo.thumbUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    
    _nameLbl.text = goodsInfo.goodsName;
    _gradeLbl.text = [NSString stringWithFormat:@"成色：%@",goodsInfo.gradeTag.value&&[goodsInfo.gradeTag.value length]>0?goodsInfo.gradeTag.value:@"未知"];
    _gradeLbl.hidden = YES;
    
    if ([_modifyPriceBtn isHidden]) {
        _shopPriceLbl.text = [NSString stringWithFormat:@"¥%.2f",goodsInfo.dealPrice];
    } else {
        _shopPriceLbl.text = [NSString stringWithFormat:@"价格：¥%.2f",goodsInfo.dealPrice];
    }
    
    
    [_statusDescLbl setTitle:orderInfo.statusDesc forState:UIControlStateDisabled];
    
    [_statusDescLbl setImage:nil forState:UIControlStateDisabled];
    _statusDescLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    _timerLbl.attributedText = nil;
    _timerLbl.hidden = YES;
    
    //    if (detailInfo.orderInfo.payStatus == 2
    //        && detailInfo.orderInfo.shippingStatus == 0
    //        && detailInfo.orderInfo.payWay != PayWayOffline
    //        && detailInfo.orderInfo.securedStatus==0
    //        && detailInfo.orderInfo.refund_enable
    
    if (orderInfo.orderStatus==0) {
        if (orderInfo.payStatus==0) {
            //付款倒计时
            [_statusDescLbl setImage:[UIImage imageNamed:@"trade_icon_time"] forState:UIControlStateDisabled];
            _statusDescLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
            _timerLbl.attributedText = self.orderInfo.pay_remainingString;
            _timerLbl.hidden = NO;
        }
        else if (orderInfo.payStatus==2 && orderInfo.shippingStatus==1) {
            //确认收货倒计时
            [_statusDescLbl setImage:[UIImage imageNamed:@"trade_icon_time"] forState:UIControlStateDisabled];
            _statusDescLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
            _timerLbl.attributedText = self.orderInfo.receive_remainingString;
            _timerLbl.hidden = NO;
        }
        else if (orderInfo.payStatus==2 && orderInfo.refund_status==1) {
            //1申请退款中
            [_statusDescLbl setImage:[UIImage imageNamed:@"trade_icon_time"] forState:UIControlStateDisabled];
            _statusDescLbl.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
            _timerLbl.attributedText = self.orderInfo.refund_remainingString;
            _timerLbl.hidden = NO;
        }
        
    }
    
    self.payPriceLbl.text = [NSString stringWithFormat:@"实付¥%.2f", orderInfo.actual_pay];
    if (orderInfo.actual_pay > 0) {
        self.payPriceLbl.hidden = NO;
    } else {
        self.payPriceLbl.hidden = YES;
    }
    
    [self setUpUI];
    [self setNeedsLayout];
}

-(void)setUpUI{
    CGFloat marginLeft = 15.f;
    CGFloat marginTop = 0.f;
    
    _thumbView.frame = CGRectMake(marginLeft, marginTop, 80, 80);
    marginTop += _thumbView.height;
    
    _modifyPriceBtn.frame = CGRectMake(marginLeft, _thumbView.bottom + 10, 70, 25);
    _renewBtn.frame = _modifyPriceBtn.frame;
    _modifyPriceBtn.frame = CGRectMake(marginLeft, _thumbView.bottom + 10, 70, 25);
    marginLeft += _thumbView.width;
    marginLeft += 14.f;
    
    [_shopPriceLbl sizeToFit];
    //    _shopPriceLbl.frame = CGRectMake(kScreenWidth - 15 - _shopPriceLbl.width, 0, _shopPriceLbl.width, _shopPriceLbl.height);
    
    [_shopPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    //    _nameLbl.frame = CGRectMake(marginLeft, 0, self.width-marginLeft-15, 0);
    [_nameLbl sizeToFit];
    //    _nameLbl.frame = CGRectMake(marginLeft, 0, self.width-_shopPriceLbl.width-15-marginLeft, _nameLbl.height);
    [_nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(_thumbView.mas_right).offset(12);
        make.width.equalTo(@(self.width-_shopPriceLbl.width-15-marginLeft));
    }];
    
    
    
    
    //    _statusDescLbl.frame = CGRectMake(marginLeft, _thumbView.bottom-_statusDescLbl.height, self.width-marginLeft-15, 0);
    //    if ([_statusDescLbl imageForState:UIControlStateDisabled]) {
    //        [_statusDescLbl sizeToFit];
    //        _statusDescLbl.frame = CGRectMake(marginLeft, _thumbView.bottom-_statusDescLbl.height, _statusDescLbl.width+_statusDescLbl.titleEdgeInsets.left+_statusDescLbl.titleEdgeInsets.right, _statusDescLbl.height);
    //    } else {
    //        CGSize size = [[_statusDescLbl titleForState:UIControlStateDisabled] sizeWithFont:_statusDescLbl.titleLabel.font constrainedToSize:CGSizeMake(self.width-marginLeft-15, 0)];
    //        _statusDescLbl.frame = CGRectMake(marginLeft, _thumbView.bottom-size.height, size.width, size.height);
    //    }
    
    //    [_timerLbl sizeToFit];
    //    _timerLbl.frame = CGRectMake(self.width-15-_timerLbl.width, _thumbView.bottom-_timerLbl.height, _timerLbl.width, _timerLbl.height);
    
    [self.deterImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_thumbView.mas_bottom);
        make.left.equalTo(_thumbView.mas_right).offset(12);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [self.washIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deterImageBtn.mas_centerY);
        make.left.equalTo(self.deterImageBtn.mas_right).offset(5);
        make.width.equalTo(@18.5);
        make.height.equalTo(@18.5);
    }];
    
    [self.countLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.deterImageBtn.mas_top).offset(-5);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    [self.payPriceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_thumbView.mas_bottom).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    //适配ios7.0
    //    CGFloat marginLeft = 15.f;
    //    CGFloat marginTop = 0.f;
    //
    //    _thumbView.frame = CGRectMake(marginLeft, marginTop, 80, 80);
    //    marginTop += _thumbView.height;
    //
    //    marginLeft += _thumbView.width;
    //    marginLeft += 14.f;
    //
    //    _nameLbl.frame = CGRectMake(marginLeft, 0, self.width-marginLeft-15, 0);
    //    [_nameLbl sizeToFit];
    //    _nameLbl.frame = CGRectMake(marginLeft, 0, self.width-marginLeft-15, _nameLbl.height);
    //
    //    [_shopPriceLbl sizeToFit];
    //    _shopPriceLbl.frame = CGRectMake(marginLeft, _nameLbl.bottom+5, self.width-marginLeft-15, _shopPriceLbl.height);
    //
    //    _modifyPriceBtn.frame = CGRectMake(kScreenWidth - 100, _shopPriceLbl.bottom-15, 70, 25);
    //    _renewBtn.frame = _modifyPriceBtn.frame;
    //
    //    _statusDescLbl.frame = CGRectMake(marginLeft, _thumbView.bottom-_statusDescLbl.height, self.width-marginLeft-15, 0);
    //    if ([_statusDescLbl imageForState:UIControlStateDisabled]) {
    //        [_statusDescLbl sizeToFit];
    //        _statusDescLbl.frame = CGRectMake(marginLeft, _thumbView.bottom-_statusDescLbl.height, _statusDescLbl.width+_statusDescLbl.titleEdgeInsets.left+_statusDescLbl.titleEdgeInsets.right, _statusDescLbl.height);
    //    } else {
    //        CGSize size = [[_statusDescLbl titleForState:UIControlStateDisabled] sizeWithFont:_statusDescLbl.titleLabel.font constrainedToSize:CGSizeMake(self.width-marginLeft-15, 0)];
    //        _statusDescLbl.frame = CGRectMake(marginLeft, _thumbView.bottom-size.height, size.width, size.height);
    //    }
    //
    //    [_timerLbl sizeToFit];
    //    _timerLbl.frame = CGRectMake(self.width-15-_timerLbl.width, _thumbView.bottom-_timerLbl.height, _timerLbl.width, _timerLbl.height);
    //
    //    [self.deterImageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.mas_centerY);
    //        make.right.equalTo(self.mas_right).offset(-15);
    //        make.width.equalTo(@20);
    //        make.height.equalTo(@20);
    //    }];
    //    _modifyPriceBtn.frame = CGRectMake(_deterImageBtn.left - 70 - 10, _shopPriceLbl.bottom-15, 70, 25);
}
@end

@interface OrderActionsView ()
@property(nonatomic,strong) OrderInfo *orderInfo;
//@property (nonatomic, strong) UILabel *remTime;
@end

@implementation OrderActionsView

//-(UILabel *)remTime{
//    if (!_remTime) {
//        _remTime = [[UILabel alloc] initWithFrame:CGRectZero];
//        _remTime.font = [UIFont systemFontOfSize:12.f];
//        _remTime.textColor = [UIColor colorWithHexString:@"f54d49"];
//        [_remTime sizeToFit];
//    }
//    return _remTime;
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //        [self addSubview:self.remTime];
    }
    return self;
}

- (void)dealloc
{
    
}

+ (CGFloat)heightForOrientationPortrait:(OrderInfo*)orderInfo {
    
    CGFloat height = 50.f;
    
    if (orderInfo.orderStatus == 0) {
        //@"进行中";
        ///...
        if (orderInfo.payStatus == 0) {
            //@"待付款"
            if (orderInfo.payWay == PayWayOffline) {
                height = 0.f;
            }
        } else if (orderInfo.payStatus == 2) {
            //@"已付款"
            
            if (orderInfo.shippingStatus == 0) {
                
            } else if (orderInfo.shippingStatus == 1) {
                ///...
            } else if (orderInfo.shippingStatus == 2) {
                ///已收货，交易完成了
                height = 0.f;
            }
        } else if (orderInfo.payStatus == 1) {
            
        }
    } else if(orderInfo.orderStatus == 1){
        
    }else{
  
    }
    return height;
}

- (void)prepareForReuse {
    NSArray *subviews = [self subviews];
    for (NSInteger i=0;i<[subviews count];i++) {
        CommandButton *btn = (CommandButton*)[subviews objectAtIndex:0];
        btn.hidden = YES;
        btn.handleClickBlock = nil;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    int btnCount = 0;
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *subviews = [self subviews];
    for (NSInteger i=[subviews count]-1;i>=0;i--) {
        CommandButton *btn = (CommandButton*)[subviews objectAtIndex:i];
        if (![btn isHidden]) {
            btnCount++;
            [array addObject:btn];
        }
    }
    
    if ([array count]==1) {
        CGFloat marginRight = 15.f;
        CommandButton *btn0  = [array objectAtIndex:0];
        btn0.frame = CGRectMake(self.width-marginRight-btn0.width, (self.height-btn0.height)/2, 64, 24);
    }
    else if ([array count]==2) {
        CGFloat marginRight = 15.f;
        CommandButton *btn0  = [array objectAtIndex:0];
        btn0.frame = CGRectMake(self.width-marginRight-btn0.width, (self.height-btn0.height)/2, 64, 24);//btn0.width, btn0.height);
        CommandButton *btn1  = [array objectAtIndex:1];
        btn1.frame = CGRectMake(self.width-marginRight-btn0.width-btn1.width-10, (self.height-btn1.height)/2, 64, 24);
    } else {
        CGFloat marginRight = 15.f;
        for (NSInteger i=[subviews count]-1;i>=0;i--) {
            CommandButton *btn = (CommandButton*)[subviews objectAtIndex:i];
            if (![btn isHidden]) {
                btn.frame = CGRectMake(self.width-marginRight-btn.width, (self.height-btn.height)/2, 64, 24);
                marginRight += btn.width;
                marginRight += 10.f;
            }
        }
    }
    
    //    [self.remTime mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.centerY.equalTo(self.mas_centerY);
    //        make.left.equalTo(self.mas_left).offset(12);
    //    }];
}

- (void)updateWithOrderInfo:(OrderInfo*)orderInfo {
    self.orderInfo = orderInfo;
    
    NSInteger count = [self.subviews count];
    if (count < 4) {
        for (NSInteger i=count;i<4-count;i++) {
            [self addSubview:[self createBtnWithStatus:0]];
        }
    }
    
    NSArray *subviews = [self subviews];
    CGFloat marginRight = 15.f;
    for (NSInteger i=[subviews count]-1;i>=0;i--) {
        CommandButton *btn = (CommandButton*)[subviews objectAtIndex:i];
        btn.frame = CGRectMake(self.width-marginRight-btn.width, (self.height-btn.height)/2, 64, 24);
        marginRight += btn.width;
        marginRight += 10.f;
        btn.hidden = YES;
    }
    
    //    if (orderInfo.logic_type == RETURNGOODS) {
    //        if (orderInfo.buttonStats == 2) {
    //
    //        } else if (orderInfo.buttonStats == 4) {
    //
    //        }
    //    }
    //联系卖家  我要付款  更多（关闭交易，付款遇到问题，取消） ＝》待付款
    //联系卖家          提醒发货                         ＝》等待卖家发货给爱丁猫（系统通知＋短信）
    //联系卖家          查看物流                         ＝》卖家已发货给爱丁猫
    //联系卖家  确认收货  更多（延长收货，查看物流，取消）     ＝》爱丁猫鉴定通过发货给买家
    
    if (orderInfo.orderStatus == 0) {
        //@"进行中";
        
        //延长收货  查看物流 确认收货 付款
        
        
        WEAKSELF;
        if (orderInfo.payStatus == 0) {
            //@"待付款"
            if (orderInfo.payWay == PayWayOffline) {
                
            } else {
                CommandButton *btn0 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                [btn0 setTitle:@"···" forState:UIControlStateNormal];
                btn0.hidden = NO;
                btn0.handleClickBlock = ^(CommandButton *sender) {
                    [MobClick event:@"click_bought_order_more"];
                    //                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionPayBlock) {
                    //                        weakSelf.orderTableViewCell.handleOrderActionPayBlock(weakSelf.orderInfo.orderId,weakSelf.orderInfo.payWay);
                    //                    }
                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionMoreBlock) {
                        weakSelf.orderTableViewCell.handleOrderActionMoreBlock(weakSelf.orderInfo,1);
                    }
                };
                
                CommandButton *btn1 = [self toBlackThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-2]];
                btn1.hidden = NO;
                [btn1 setTitleColor:[DataSources colorf9384c] forState:UIControlStateNormal];
                btn1.layer.borderColor = [DataSources colorf9384c].CGColor;
                [btn1 setTitle:@"付款" forState:UIControlStateNormal];
                btn1.handleClickBlock = ^(CommandButton *sender) {
                    [MobClick event:@"click_payment"];
                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionPayBlock) {
                        weakSelf.orderTableViewCell.handleOrderActionPayBlock(weakSelf.orderInfo.orderId,weakSelf.orderInfo.payWay,weakSelf.orderInfo);
                    }
                };
                
                CommandButton *btn2 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-3]];
                btn2.hidden = NO;
                if (orderInfo.logic_type == RETURNGOODS || orderInfo.logic_type == SELFGOODS) {
                    [btn2 setTitle:@"联系顾问" forState:UIControlStateNormal];
                    btn2.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionChatBlock) {
                            weakSelf.orderTableViewCell.handleOrderActionChatBlock(weakSelf.orderInfo.sellerId,weakSelf.orderInfo,1);
                        }
                    };
                } else {
                    [btn2 setTitle:@"联系卖家" forState:UIControlStateNormal];
                    btn2.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionChatBlock) {
                            weakSelf.orderTableViewCell.handleOrderActionChatBlock(weakSelf.orderInfo.sellerId,weakSelf.orderInfo,0);
                        }
                    };
                }
                
                CommandButton *btn3 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-4]];
                btn3.backgroundColor = [UIColor clearColor];
                if (orderInfo.payTipVo) {
                    btn3.hidden = NO;
                } else {
                    btn3.hidden = YES;
                }
                [btn3 setTitle:@"转账支付" forState:UIControlStateNormal];
                btn3.handleClickBlock = ^(CommandButton *sender) {
//                    [MobClick event:@"click_payment"];
                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionPayBlock) {
                        weakSelf.orderTableViewCell.handleOrderActionShowPayTipBlock(weakSelf.orderInfo);
                    }
                };
                
                if (orderInfo.sellerId == orderInfo.buyerId) {
                    btn2.hidden = YES;
                }
                
                
            }
            
        } else if (orderInfo.payStatus == 2) {
            //@"已付款"
            
            if (orderInfo.shippingStatus == 0) {
                //查看物流 >0
                if (orderInfo.payWay != PayWayOffline) {
                    //secured_status //0初始 1卖家发货 2鉴定中心收货 3通过 4不通过
                    if (orderInfo.securedStatus==0) {
                        if (orderInfo.refund_enable || orderInfo.refund_status==1) {
                            
                            if (orderInfo.refund_enable) {
                                if (orderInfo.tradeType == 4) {
                                    CommandButton *btn1 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                                    btn1.hidden = NO;
                                    [btn1 setTitle:@"我要发货" forState:UIControlStateNormal];
                                    btn1.handleClickBlock = ^(CommandButton *sender) {
                                        
                                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionSendBlock) {
                                            weakSelf.orderTableViewCell.handleOrderActionSendBlock(weakSelf.orderInfo);
                                        }
                                        //                                        [[NSNotificationCenter defaultCenter] postNotificationName:@"sendGoods" object:orderInfo];
                                    };
                                } else {
                                    CommandButton *btn1 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                                    btn1.hidden = NO;
                                    [btn1 setTitle:@"提醒发货" forState:UIControlStateNormal];
                                    btn1.handleClickBlock = ^(CommandButton *sender) {
                                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionRemindShippingGoodsBlock) {
                                            weakSelf.orderTableViewCell.handleOrderActionRemindShippingGoodsBlock(weakSelf.orderInfo);
                                        }
                                    };
                                }
                                
                                CommandButton *btn2 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-2]];
                                btn2.hidden = NO;
                                [btn2 setTitle:@"申请退款" forState:UIControlStateNormal];
                                btn2.handleClickBlock = ^(CommandButton *sender) {
                                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionApplyRefundBlock) {
                                        weakSelf.orderTableViewCell.handleOrderActionApplyRefundBlock(weakSelf.orderInfo);
                                    }
                                };
                            } else if (orderInfo.refund_status==1) {
                                CommandButton *btn2 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-2]];
                                btn2.hidden = NO;
                                [btn2 setTitle:@"撤销退款" forState:UIControlStateNormal];
                                btn2.handleClickBlock = ^(CommandButton *sender) {
                                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionCancelRefundBlock) {
                                        weakSelf.orderTableViewCell.handleOrderActionCancelRefundBlock(weakSelf.orderInfo);
                                    }
                                };
                            }
                            
                        } else {
                            CommandButton *btn1 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                            btn1.hidden = NO;
                            [btn1 setTitle:@"提醒发货" forState:UIControlStateNormal];
                            btn1.handleClickBlock = ^(CommandButton *sender) {
                                if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionRemindShippingGoodsBlock) {
                                    weakSelf.orderTableViewCell.handleOrderActionRemindShippingGoodsBlock(weakSelf.orderInfo);
                                }
                            };
                        }
                        
                    } else {
                        CommandButton *btn1 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                        btn1.hidden = NO;
                        [btn1 setTitle:@"查看物流" forState:UIControlStateNormal];
                        btn1.handleClickBlock = ^(CommandButton *sender) {
                            if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock) {
                                weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock(weakSelf.orderInfo);
                            }
                        };
                    }
                }
                
                CommandButton *btn3 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-3]];
                btn3.hidden = NO;
                if (orderInfo.logic_type == RETURNGOODS || orderInfo.logic_type == SELFGOODS) {
                    [btn3 setTitle:@"联系顾问" forState:UIControlStateNormal];
                    btn3.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionChatBlock) {
                            weakSelf.orderTableViewCell.handleOrderActionChatBlock(weakSelf.orderInfo.sellerId,weakSelf.orderInfo,1);
                        }
                    };
                } else {
                    [btn3 setTitle:@"联系卖家" forState:UIControlStateNormal];
                    btn3.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionChatBlock) {
                            weakSelf.orderTableViewCell.handleOrderActionChatBlock(weakSelf.orderInfo.sellerId,weakSelf.orderInfo,0);
                        }
                    };
                }
                if (orderInfo.sellerId == orderInfo.buyerId) {
                    btn3.hidden = YES;
                }
                
                
            } else if (orderInfo.shippingStatus == 1) {
                if (orderInfo.payWay != PayWayOffline) {
                    
                    CommandButton *btn0 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                    [btn0 setTitle:@"···" forState:UIControlStateNormal];
                    btn0.hidden = NO;
                    btn0.handleClickBlock = ^(CommandButton *sender) {
                        //                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionTryDelayBlock) {
                        //                            weakSelf.orderTableViewCell.handleOrderActionTryDelayBlock(weakSelf.orderInfo.orderId);
                        //                        }
                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionMoreBlock) {
                            weakSelf.orderTableViewCell.handleOrderActionMoreBlock(weakSelf.orderInfo,2);
                        }
                    };
                    
                    //                    CommandButton *btn0 = [self toOrangeThemeButton:(CommandButton*)[subviews objectAtIndex:0]];
                    //                    [btn0 setTitle:@"延长收货" forState:UIControlStateNormal];
                    //                    btn0.hidden = NO;
                    //                    btn0.handleClickBlock = ^(CommandButton *sender) {
                    //                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionTryDelayBlock) {
                    //                            weakSelf.orderTableViewCell.handleOrderActionTryDelayBlock(weakSelf.orderInfo.orderId);
                    //                        }
                    //                    };
                    //
                    //                    CommandButton *btn1 = [self toOrangeThemeButton:(CommandButton*)[subviews objectAtIndex:1]];
                    //                    [btn1 setTitle:@"查看物流" forState:UIControlStateNormal];
                    //                    btn1.hidden = NO;
                    //                    btn1.handleClickBlock = ^(CommandButton *sender) {
                    //                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock) {
                    //                            weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock(weakSelf.orderInfo.orderId);
                    //                        }
                    //                    };
                }
                
                CommandButton *btn3 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-2]];
                btn3.hidden = NO;
                if (orderInfo.logic_type == RETURNGOODS || orderInfo.logic_type == SELFGOODS) {
                    [btn3 setTitle:@"联系顾问" forState:UIControlStateNormal];
                    btn3.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionChatBlock) {
                            weakSelf.orderTableViewCell.handleOrderActionChatBlock(weakSelf.orderInfo.sellerId,weakSelf.orderInfo,1);
                        }
                    };
                } else {
                    [btn3 setTitle:@"联系卖家" forState:UIControlStateNormal];
                    btn3.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionChatBlock) {
                            weakSelf.orderTableViewCell.handleOrderActionChatBlock(weakSelf.orderInfo.sellerId,weakSelf.orderInfo,0);
                        }
                    };
                }
                if (orderInfo.sellerId == orderInfo.buyerId) {
                    btn3.hidden = YES;
                }
                
                if (orderInfo.repurchase_status == 0 || orderInfo.repurchase_status == 5) {
                    CommandButton *btn2 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-3]];
                    [btn2 setTitle:@"确认收货" forState:UIControlStateNormal];
                    btn2.hidden = NO;
                    btn2.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionConfirmReceivingBlock) {
                            weakSelf.orderTableViewCell.handleOrderActionConfirmReceivingBlock(weakSelf.orderInfo.orderId);
                        }
                    };
                }
            }
        } else if (orderInfo.payStatus == 1) {//分次支付支付中
            CommandButton *btn1 = [self toBlackThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
            btn1.hidden = NO;
            [btn1 setTitle:@"继续支付" forState:UIControlStateNormal];
            btn1.handleClickBlock = ^(CommandButton *sender) {
                [MobClick event:@"click_payment"];
                if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionPayBlock) {
                    weakSelf.orderTableViewCell.handleOrderActionPayBlock(weakSelf.orderInfo.orderId,weakSelf.orderInfo.payWay,weakSelf.orderInfo);
                }
            };
            
            CommandButton *btn2 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-4]];
            btn2.backgroundColor = [UIColor clearColor];
            if (orderInfo.payTipVo) {
                btn2.hidden = NO;
            } else {
                btn2.hidden = YES;
            }
//            [btn2 setImage:[UIImage imageNamed:@"questionmark"] forState:UIControlStateNormal];
            [btn2 setTitle:@"转账支付" forState:UIControlStateNormal];
            btn2.handleClickBlock = ^(CommandButton *sender) {
                //                    [MobClick event:@"click_payment"];
                if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionPayBlock) {
                    weakSelf.orderTableViewCell.handleOrderActionShowPayTipBlock(weakSelf.orderInfo);
                }
            };
        }
        
    } else if(orderInfo.orderStatus == 1){
        
        WEAKSELF;
        CommandButton *btn0 = [self toBlackThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
        btn0.hidden = NO;
        [btn0 setTitle:@"一键转卖" forState:UIControlStateNormal];
        btn0.handleClickBlock = ^(CommandButton * sender){
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(handleOrderActionResellGoods:order:)]) {
                GoodsInfo * goodsInfo = [self.orderInfo.goodsList objectAtIndex:0];
                NSString * goodsId = goodsInfo.goodsId;
                [self.delegate handleOrderActionResellGoods:goodsId order:self.orderInfo.orderId];
            }
            
        };
        
        
        CommandButton *btn1 = [self toOrangeThemeChatButton:(CommandButton *)[subviews objectAtIndex:[subviews count]-2]];
        btn1.hidden = NO;
        [btn1 setTitle:@"查看物流" forState:UIControlStateNormal];
        btn1.handleClickBlock = ^(CommandButton * sender){
            if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock) {
                weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock(weakSelf.orderInfo);
            }
        };
        
        if ((orderInfo.tradeType == 4 && orderInfo.tradeType == 7) || orderInfo.tradeType == 9) {
            btn0.hidden = YES;
        } else {
            btn0.hidden = NO;
        }
        
        if (orderInfo.tradeType == 9) {
            CommandButton *btn1 = [self toOrangeThemeChatButton:(CommandButton *)[subviews objectAtIndex:[subviews count]-2]];
            btn1.hidden = NO;
            [btn1 setTitle:@"联系客服" forState:UIControlStateNormal];
            btn1.handleClickBlock = ^(CommandButton * sender){
                if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionSeriviceBlock) {
                    weakSelf.orderTableViewCell.handleOrderActionSeriviceBlock(weakSelf.orderInfo);
                }
            };
        }
        
    }else{
        WEAKSELF;
        CommandButton *btn0 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
        [btn0 setTitle:@"删除订单" forState:UIControlStateNormal];
        btn0.hidden = NO;
        btn0.handleClickBlock = ^(CommandButton * sender){
            if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionDeleteOrderBlock) {
                weakSelf.orderTableViewCell.handleOrderActionDeleteOrderBlock(self.orderInfo);
            }
        };
        //        WEAKSELF;
        //        if (orderInfo.logic_type == RETURNGOODS) {
        //
        //            if (orderInfo.buttonStats == 2) {
        //                CommandButton *btn0 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
        //                [btn0 setTitle:@"查看退货进度" forState:UIControlStateNormal];
        //                btn0.hidden = NO;
        //                btn0.handleClickBlock = ^(CommandButton *sender) {
        //                    //                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionTryDelayBlock) {
        //                    //                            weakSelf.orderTableViewCell.handleOrderActionTryDelayBlock(weakSelf.orderInfo.orderId);
        //                    //                        }
        //                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionMoreBlock) {
        //                        weakSelf.orderTableViewCell.handleOrderActionMoreBlock(weakSelf.orderInfo,2);
        //                    }
        //                };
        //            } else if (orderInfo.buttonStats == 4) {
        //                CommandButton *btn0 = [self toBlackBorThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
        //                [btn0 setTitle:@"查看回购进度" forState:UIControlStateNormal];
        //                btn0.hidden = NO;
        //                btn0.handleClickBlock = ^(CommandButton *sender) {
        //                    //                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionTryDelayBlock) {
        //                    //                            weakSelf.orderTableViewCell.handleOrderActionTryDelayBlock(weakSelf.orderInfo.orderId);
        //                    //                        }
        //                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionMoreBlock) {
        //                        weakSelf.orderTableViewCell.handleOrderActionMoreBlock(weakSelf.orderInfo,2);
        //                    }
        //                };
        //            }
        //        }
    }
    
    
    //    if (orderInfo.payStatus == 1) {
    //        self.remTime.hidden = NO;
    //        NSDate *date = [NSDate dateWithTimeIntervalSince1970:orderInfo.pay_remaining/1000];
    //        self.remTime.text = [date formattedDateDescriptionMF];
    //    } else {
    //        self.remTime.hidden = YES;
    //    }
    //    else {
    //        CommandButton *btn = (CommandButton*)[subviews objectAtIndex:[subviews count]-1];
    //        [btn setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    //        btn.hidden = NO;
    //        btn.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    //        if (orderInfo.orderStatus==1) {
    //            [btn setTitle:@"交易完成" forState:UIControlStateNormal];
    //        } else if (orderInfo.orderStatus==2) {
    //            [btn setTitle:@"已取消" forState:UIControlStateNormal];
    //        } else {
    //            [btn setTitle:@"交易失效" forState:UIControlStateNormal];
    //        }
    //
    //        if ([orderInfo.statusDesc length]>0) {
    //            btn.hidden = YES;
    //        }
    //    }
    
    [self setNeedsLayout];
}

- (CommandButton*)createBtnWithStatus:(NSInteger)status {
    CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 90, 40)];
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = nil;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.titleLabel.font = [UIFont systemFontOfSize:12.5f];
    btn.backgroundColor = [UIColor whiteColor];
    return btn;
}

- (CommandButton*)toBlackThemeButton:(CommandButton*)btn {
    btn.backgroundColor = [UIColor whiteColor];
    [btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.titleLabel.font = [UIFont systemFontOfSize:12.5f];
    [btn setImage:nil forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return btn;
}

- (CommandButton*)toOrangeThemeButton:(CommandButton*)btn {
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    [btn setImage:nil forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return btn;
}

- (CommandButton*)toBlackBorThemeButton:(CommandButton*)btn {
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    [btn setImage:nil forState:UIControlStateNormal];
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return btn;
}

- (CommandButton*)toOrangeThemeChatButton:(CommandButton*)btn {
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn setTitle:nil forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return btn;
}

- (CommandButton*)toOrangeThemeMoreButton:(CommandButton*)btn {
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [btn setTitle:nil forState:UIControlStateNormal];
    btn.layer.borderWidth = 1.f;
    btn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    [btn setImage:[UIImage imageNamed:@"order_action_icon_more"] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 3;
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    return btn;
}

@end

@interface OrderActionsViewSold ()
@end

@implementation OrderActionsViewSold

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    
}

+ (CGFloat)heightForOrientationPortrait:(OrderInfo*)orderInfo {
    
    CGFloat height = 50.f;
    
    if (orderInfo.orderStatus == 0) {
        //@"进行中";
        ///...
        if (orderInfo.payStatus == 0) {
            //@"待付款"
            if (orderInfo.payWay == PayWayOffline) {
                //线下支付
            }
            
        } else if (orderInfo.payStatus == 2) {
            //@"已付款"
            
            if (orderInfo.shippingStatus == 0) {
                //未发货
                
            } else if (orderInfo.shippingStatus == 1) {
                //已发货
                
            } else if (orderInfo.shippingStatus == 2) {
                ///已收货，交易完成了
                //                height = 0.f;
            }
        }
    } else {
        //        height = 0.f;
    }
    return height;
}


- (void)updateWithOrderInfo:(OrderInfo*)orderInfo {
    self.orderInfo = orderInfo;
    
    NSInteger count = [self.subviews count];
    if (count < 4) {
        for (NSInteger i=count;i<4-count;i++) {
            [self addSubview:[self createBtnWithStatus:0]];
        }
    }
    
    NSArray *subviews = [self subviews];
    CGFloat marginRight = 15.f;
    for (NSInteger i=[subviews count]-1;i>=0;i--) {
        CommandButton *btn = (CommandButton*)[subviews objectAtIndex:i];
        btn.frame = CGRectMake(self.width-marginRight-btn.width, (self.height-btn.height)/2, btn.width, btn.height);
        marginRight += btn.width;
        marginRight += 10.f;
        btn.hidden = YES;
    }
    
    if (orderInfo.orderStatus == 0) {
        //@"进行中";
        ///...
        if (orderInfo.payStatus == 0) {
            //@"待付款"
            
            WEAKSELF;
            if (orderInfo.payWay == PayWayOffline) {
                //线下支付
                //确认收款 －》
                CommandButton *btn = [self toBlackThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                [btn setTitle:@"确认收款" forState:UIControlStateNormal];
                btn.hidden = NO;
                btn.handleClickBlock = ^(CommandButton *sender) {
                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionOfflineConfirmPaymentBlock) {
                        weakSelf.orderTableViewCell.handleOrderActionOfflineConfirmPaymentBlock(weakSelf.orderInfo.orderId);
                    }
                };
            }
            
            CommandButton *btn2 = [self toOrangeThemeChatButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-2]];
            [btn2 setTitle:@"联系买家" forState:UIControlStateNormal];
            btn2.hidden = NO;
            btn2.handleClickBlock = ^(CommandButton *sender) {
                if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock) {
                    weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock(weakSelf.orderInfo.buyerId,weakSelf.orderInfo);
                }
            };
            
            CommandButton *btn3 = [self toOrangeThemeChatButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-3]];
            [btn3 setTitle:@"修改价格" forState:UIControlStateNormal];
            btn3.hidden = NO;
            btn3.handleClickBlock = ^(CommandButton *sender) {
                if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderGoodsModifyPriceBlock) {
                    weakSelf.orderTableViewCell.handleOrderGoodsModifyPriceBlock(weakSelf.orderInfo.orderId,weakSelf.goodsInfo);
                }
            };
            
            
        } else if (orderInfo.payStatus == 2) {
            //@"已付款"
            WEAKSELF;
            if (orderInfo.shippingStatus == 0) {
                //未发货
                //                if (orderInfo.payWay == PayWayOffline) {
                //                    //线下支付
                //                    //发货 －》
                //                    CommandButton *btn = [self toBlackThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                //                    [btn setTitle:@"我要发货" forState:UIControlStateNormal];
                //                    btn.hidden = NO;
                //                    btn.handleClickBlock = ^(CommandButton *sender) {
                //
                //                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionOfflineSendBlock) {
                //                            weakSelf.orderTableViewCell.handleOrderActionOfflineSendBlock(weakSelf.orderInfo);
                //                        }
                //                    };
                //
                //                    CommandButton *btn2 = [self toOrangeThemeChatButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-2]];
                //                    [btn2 setTitle:@"联系买家" forState:UIControlStateNormal];
                //                    btn2.hidden = NO;
                //                    btn2.handleClickBlock = ^(CommandButton *sender) {
                //                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock) {
                //                            weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock(weakSelf.orderInfo.buyerId,weakSelf.orderInfo);
                //                        }
                //                    };
                //                } else {
                //发货 －》发货给爱丁猫
                
                if (orderInfo.securedStatus == 0 || orderInfo.securedStatus == 6) {
                    if (orderInfo.refund_status==1) {
                        //同意退款
                        CommandButton *btn = [self toBlackThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                        [btn setTitle:@"同意退款" forState:UIControlStateNormal];
                        btn.hidden = NO;
                        btn.handleClickBlock = ^(CommandButton *sender) {
                            if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionAgreeRefundBlock) {
                                weakSelf.orderTableViewCell.handleOrderActionAgreeRefundBlock(weakSelf.orderInfo,YES);
                            }
                        };
                    }
                    else {
                        CommandButton *btn = [self toBlackThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                        [btn setTitle:@"我要发货" forState:UIControlStateNormal];
                        btn.hidden = NO;
                        btn.handleClickBlock = ^(CommandButton *sender) {
                            
                            if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionSendBlock) {
                                
                                weakSelf.orderTableViewCell.handleOrderActionSendBlock(weakSelf.orderInfo);
                            }
                        };
                    }
                } else {
                    CommandButton *btn = [self toOrangeThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                    [btn setTitle:@"查看物流" forState:UIControlStateNormal];
                    btn.hidden = NO;
                    btn.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock) {
                            weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock(weakSelf.orderInfo);
                        }
                    };
                }
                
                CommandButton *btn2 = [self toOrangeThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-2]];
                [btn2 setTitle:@"联系客服" forState:UIControlStateNormal];
                btn2.hidden = NO;
                btn2.handleClickBlock = ^(CommandButton *sender) {
                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionConnectADMBlock) {
                        weakSelf.orderTableViewCell.handleOrderActionConnectADMBlock(weakSelf.orderInfo.sellerId);
                    }
                };
                
                CommandButton *btn3 = [self toOrangeThemeChatButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-3]];
                [btn3 setTitle:@"联系买家" forState:UIControlStateNormal];
                btn3.hidden = NO;
                btn3.handleClickBlock = ^(CommandButton *sender) {
                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock) {
                        weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock(weakSelf.orderInfo.buyerId,weakSelf.orderInfo);
                    }
                };
                //                }
                
            } else if (orderInfo.shippingStatus == 1) {
                //已发货
                
                if (orderInfo.payWay != PayWayOffline) {
                    CommandButton *btn = [self toOrangeThemeButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                    [btn setTitle:@"查看物流" forState:UIControlStateNormal];
                    btn.hidden = NO;
                    btn.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock) {
                            weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock(weakSelf.orderInfo);
                        }
                    };
                }
                
                CommandButton *btn2 = [self toOrangeThemeChatButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-2]];
                [btn2 setTitle:@"联系买家" forState:UIControlStateNormal];
                btn2.hidden = NO;
                btn2.handleClickBlock = ^(CommandButton *sender) {
                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock) {
                        weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock(weakSelf.orderInfo.buyerId,weakSelf.orderInfo);
                    }
                };
                
            } else if (orderInfo.shippingStatus == 2) {
                //已收货
                
                CommandButton *btn1 = [self toOrangeThemeChatButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
                [btn1 setTitle:@"联系买家" forState:UIControlStateNormal];
                btn1.hidden = NO;
                btn1.handleClickBlock = ^(CommandButton *sender) {
                    if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock) {
                        weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock(weakSelf.orderInfo.buyerId,weakSelf.orderInfo);
                    }
                };
            }
        }
    } else  if(orderInfo.orderStatus == 1){
        
        WEAKSELF;
        CommandButton *btn0 = [self toOrangeThemeChatButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
        btn0.hidden = NO;
        [btn0 setTitle:@"联系买家" forState:UIControlStateNormal];
        btn0.handleClickBlock = ^(CommandButton * sender){
            if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock) {
                weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock(weakSelf.orderInfo.buyerId,weakSelf.orderInfo);
            }
        };
        
        
        CommandButton *btn1 = [self toOrangeThemeChatButton:(CommandButton *)[subviews objectAtIndex:[subviews count]-2]];
        btn1.hidden = NO;
        [btn1 setTitle:@"查看物流" forState:UIControlStateNormal];
        btn1.handleClickBlock = ^(CommandButton * sender){
            if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock) {
                weakSelf.orderTableViewCell.handleOrderActionLogisticsBlock(weakSelf.orderInfo);
            }
        };
        
    }else{
        WEAKSELF;
        CommandButton *btn1 = [self toOrangeThemeChatButton:(CommandButton*)[subviews objectAtIndex:[subviews count]-1]];
        [btn1 setTitle:@"联系买家" forState:UIControlStateNormal];
        btn1.hidden = NO;
        btn1.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.orderTableViewCell && weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock) {
                weakSelf.orderTableViewCell.handleOrderBuyerActionChatBlock(weakSelf.orderInfo.buyerId,weakSelf.orderInfo);
            }
        };
    }
    
    [self setNeedsLayout];
}

@end

//交易进行中   联系买家／改价       联系买家／发货    联系买家／已发货

@interface OrderTableViewCellSold ()

@end

@implementation OrderTableViewCellSold

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([OrderTableViewCellSold class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    OrderInfo *orderInfo = [dict objectForKey:[[self class] cellDictKeyForOrderInfo]];
    return [self calculateHeightAndLayoutSubviews:nil orderInfo:orderInfo];
}

+ (NSMutableDictionary*)buildCellDict:(OrderInfo*)orderInfo {
    
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[OrderTableViewCellSold class]];
    if (orderInfo)[dict setObject:orderInfo forKey:[self cellDictKeyForOrderInfo]];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:[self cellDictKeyForSeleted]];
    return dict;
}

+ (CGFloat)orderActionsViewHeight:(OrderInfo*)orderInfo
{
    return [OrderActionsViewSold heightForOrientationPortrait:orderInfo];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.actionsView removeFromSuperview];
        self.actionsView = [[OrderActionsViewSold alloc] initWithFrame:CGRectZero];
        self.actionsView.orderTableViewCell = self;
        [self.contentView addSubview:self.actionsView];
    }
    return self;
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    [super updateCellWithDict:dict];
    
    self.goodsTypeLbl.text = self.orderInfo.buyer.userName;
    [self.goodsTypeImageView sd_setImageWithURL:[NSURL URLWithString:self.orderInfo.buyer.avatarUrl]];
    
    double totalPrice = self.orderInfo.totalPrice;
    
    NSString *totalPriceTitle = @"实付款：";
    NSString *totalPriceString = [NSString stringWithFormat:@"¥ %.2f",totalPrice];
    NSString *mailPriceTitle = @"邮费：";
    NSString *mailPriceString = @"包邮";
    
    NSString *labelText = [NSString stringWithFormat:@"%@%@  %@%@",mailPriceTitle,mailPriceString,totalPriceTitle,totalPriceString];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c2a79d"] range:NSMakeRange(mailPriceTitle.length, [mailPriceString length])];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c2a79d"] range:NSMakeRange(labelText.length-totalPriceString.length, [totalPriceString length])];
    self.totalPriceLbl.attributedText = attributedString;
    
    self.selectedBtn.hidden = YES;
    
    OrderInfo *orderInfo = [dict objectForKey:[[self class] cellDictKeyForOrderInfo]];
    if (orderInfo) {
        //@"进行中"
        if (orderInfo.orderStatus == 0) {
            if (orderInfo.payStatus == 0) {
                //@"待付款"
                for (NSInteger i=0;i<[orderInfo.goodsList count];i++) {
                    GoodsInfo *goodsInfo = [orderInfo.goodsList objectAtIndex:i];
                    OrderGoodsView *goodsView = [[self.goodsViews subviews] objectAtIndex:i];
                    goodsView.hidden = NO;
                    if (orderInfo.payWay == PayWayOffline) {
                        [goodsView updateWithOrderInfo:goodsInfo orderInfo:orderInfo isCanModifyPrice:NO isCopyEnable:orderInfo.copy_enable];
                    }
                    else {
                        [goodsView updateWithOrderInfo:goodsInfo orderInfo:orderInfo isCanModifyPrice:YES isCopyEnable:orderInfo.copy_enable];
                    }
                }
                
            } else {
                //@"待付款"
                for (NSInteger i=0;i<[orderInfo.goodsList count];i++) {
                    GoodsInfo *goodsInfo = [orderInfo.goodsList objectAtIndex:i];
                    OrderGoodsView *goodsView = [[self.goodsViews subviews] objectAtIndex:i];
                    goodsView.hidden = NO;
                    [goodsView updateWithOrderInfo:goodsInfo orderInfo:orderInfo isCanModifyPrice:NO isCopyEnable:orderInfo.copy_enable];
                }
            }
        } else {
            for (NSInteger i=0;i<[orderInfo.goodsList count];i++) {
                GoodsInfo *goodsInfo = [orderInfo.goodsList objectAtIndex:i];
                OrderGoodsView *goodsView = [[self.goodsViews subviews] objectAtIndex:i];
                goodsView.hidden = NO;
                [goodsView updateWithOrderInfo:goodsInfo orderInfo:orderInfo isCanModifyPrice:NO isCopyEnable:orderInfo.copy_enable];
            }
        }
    }
    
    //case 0: status = @"进行中"; break;
    //case 1: status = @"交易完成"; break;
    //case 2: status = @"已取消"; break;
    //case 3: status = @"订单无效"; break;
    
    [self setNeedsLayout];
}

@end



