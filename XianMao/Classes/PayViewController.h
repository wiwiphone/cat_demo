//
//  PayViewController.h
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "PlaceHolderTextView.h"
#import "Command.h"
#import "GoodsInfo.h"
#import "ParyialDo.h"
#import "AccountCard.h"

@class BonusInfo;
@class Wallet;
@class ShoppingCartItem;
@interface PayViewController : BaseViewController

@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property(nonatomic,strong) NSArray *items;
@property (nonatomic, assign) NSInteger index;
@property(nonatomic,copy) void(^handlePayDidFnishBlock)(BaseViewController*payViewController, NSInteger index);

@property (nonatomic, assign) NSInteger formShopCar;
@property (nonatomic, strong) ParyialDo *surePartialDo;
@end


@class AddressInfo;
@interface PayTableHeaderView : TapDetectingView

+ (CGFloat)heightForOrientationPortrait:(AddressInfo*)addressInfo;

- (void)updateByAddressInfo:(AddressInfo*)addressInfo;

@end



@protocol PayTableFooterViewDelegate <NSObject>

-(void)attributedLabelSelect:(NSURL *)url;

@end
@interface PayTableFooterView : UIView

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property (nonatomic, strong) AddressInfo * addressInfo;
@property(nonatomic,weak) BaseViewController *viewController;
@property(nonatomic,readonly) NSString *message;

@property (nonatomic, assign) BOOL isDetermine;
@property(nonatomic,copy) void(^handleUsingReward)(BOOL usingReward);
@property(nonatomic,copy) void(^handleUsingQuan)(BonusInfo *bonusInfo);
@property(nonatomic,copy) void(^handleUsingXihuCard)(AccountCard *accountCard);
@property(nonatomic,copy) void(^handleUsingAdmMoney)(NSInteger payway);

@property(nonatomic,copy) void(^changeXihuCardArr)(NSArray *xihuCardArr);

@property (nonatomic, assign) NSInteger index;
@property(nonatomic,strong) PayWayDO *payWayDOSelected;
@property(nonatomic,strong) NSArray *payWays;;
@property (nonatomic, strong) UIButton *agreeBtn;

@property (nonatomic, assign) NSInteger selectedIndex;
@property (nonatomic,weak) id<PayTableFooterViewDelegate>delegate;
//@property (nonatomic,copy) void(^attributedLabelSelect)(NSURL *url);

@property(nonatomic,copy) void(^handlePayWayChangedBlock1)(NSInteger payWay);

- (id)init:(NSInteger)totalPrice reward_money_cent:(NSInteger)reward_money_cent available_money_cent:(NSInteger)available_money_cent
   payWays:(NSArray*)payWays
quanItemArray:(NSArray*)quanItemArray
     index:(NSInteger)index xiHuCardArray:(NSArray *)xiHuCardArray itemArr:(NSArray *)items;

- (NSInteger)payWay;
- (NSInteger)isPartialPay;

@end


@interface PayTableFooterItemView: TapDetectingView

@property(nonatomic,assign) BOOL selected;
@property(nonatomic) NSString *subTitle;
@property(nonatomic) NSString *indicatorTitle;
@property (nonatomic, assign) CGFloat available_money_cent;
@property (nonatomic, assign) CGFloat titlePriceCent;


-(void)getTitlePriceCent:(NSInteger)titlePriceCent available_money_cent:(CGFloat)available_money_cent;

- (id)init:(NSString*)icon title:(NSString*)title subTitle:(NSString*)subTitle isCanSelected:(BOOL)isCanSelected indicatorTitle:(NSString*)indicatorTitle;
- (id)init:(NSString*)icon title:(NSString*)title;
- (id)init:(NSString*)iconUrl placeHolder:(NSString*)placeHolder title:(NSString*)title payDo:(PayWayDO *)payWayDo;
- (id)initWithFrame:(CGRect)frame icon:(NSString*)icon title:(NSString*)title;

@end

@interface PayTableFooterQuanView: PayTableFooterItemView

- (id)init:(NSString*)icon title:(NSString*)title;
- (void)setQuanAmount:(double)amount;

@end

@interface PayQuanViewController : BaseViewController

@property(nonatomic,strong) NSMutableArray *quanItemList;
@property(nonatomic,strong) BonusInfo *seletedBonusInfo;
@property(nonatomic,copy) void(^handleDidSelectBonusInfo)(PayQuanViewController *viewController, BonusInfo *bonusInfo);

@property (nonatomic, assign) BOOL isHaveUnableLbl;
@end






