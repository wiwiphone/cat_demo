//
//  BoughtViewController.h
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "Command.h"
#import "NetworkAPI.h"
#import "ParyialDo.h"
#import "BoughtCollectionViewController.h"
#import "AccountCard.h"

@class BonusInfo;

@interface BoughtViewController : BaseViewController

-(void)initDataListLogic;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger viewCode;
//判断是否需要选择鉴定
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) BoughtCollectionViewController *boughtCollectionVC;

@property (nonatomic, assign) NSInteger goonWithPayController;
@end

@interface VerifyPasswordView : UIView

+ (void)showInView:(UIView*)view
   completionBlock:(void (^)(NSString *password))completionBlock;

+ (void)showInViewMF:(UIView*)view
   completionBlock:(void (^)(NSString *password))completionBlock;
@end

@interface ChoosePayWayView : UIView

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) CommandButton *buyBtn;
@property(nonatomic,strong) CommandButton *cancelBtn;


- (id)initWithFrame:(CGRect)frame
     totalPriceCent:(NSInteger)totalPriceCent
      payWayDOArray:(NSArray*)payWayDOArray
             payWay:(PayWayType)payWay
       recoverIndex:(NSInteger)recoverIndex
  reward_money_cent:(NSInteger)reward_money_cent
available_money_cent:(NSInteger)available_money_cent
     quanItemsArray:(NSArray*)quanItemsArray
      xihuCardArray:(NSArray *)xihuCardArray
          partialDo:(ParyialDo *)partialDo;

+ (ChoosePayWayView*)showInView:(UIView*)view
                 totalPriceCent:(NSInteger)totalPriceCent
                  payWayDOArray:(NSArray*)payWayDOArray
                         payWay:(PayWayType)payWay
                          index:(NSInteger)index
              reward_money_cent:(NSInteger)reward_money_cent
           available_money_cent:(NSInteger)available_money_cent
                 quanItemsArray:(NSArray*)quanItemsArray
                  xihuCardArray:(NSArray *)xihuCardArray
              is_partial_pay:(NSInteger)is_partial_pay
                      partialDo:(ParyialDo *)partialDo
                completionBlock:(void (^)(NSInteger payWay, BOOL is_used_reward_money, BOOL is_used_adm_money, BonusInfo *seletedBonusInfo, AccountCard *accountCard,NSInteger deterIndex, NSInteger index))completionBlock;

+ (ChoosePayWayView*)getBonusInfoAndAccountCard:(UIView*)view
                                 totalPriceCent:(NSInteger)totalPriceCent
                                  payWayDOArray:(NSArray*)payWayDOArray
                                         payWay:(PayWayType)payWay
                                          index:(NSInteger)index
                              reward_money_cent:(NSInteger)reward_money_cent
                           available_money_cent:(NSInteger)available_money_cent
                                 quanItemsArray:(NSArray*)quanItemsArray
                                  xihuCardArray:(NSArray *)xihuCardArray
                                 is_partial_pay:(NSInteger)is_partial_pay
                                      partialDo:(ParyialDo *)partialDo
                                completionBlock:(void (^)(NSInteger payWay1, BOOL is_used_reward_money1, BOOL is_used_adm_money1, BonusInfo *seletedBonusInfo1, AccountCard *accountCard1,NSInteger deterIndex1, NSInteger index1))completionBlock;

@end

@interface PaySelectedItemView: TapDetectingView

@property(nonatomic,assign) BOOL selected;

- (id)init:(NSString*)icon title:(NSString*)title;
- (id)initWithFrame:(CGRect)frame icon:(NSString*)icon title:(NSString*)title;
- (id)init:(NSString*)iconUrl placeHolder:(NSString*)placeHolder title:(NSString*)title;
- (id)initWithFrame:(CGRect)frame icon:(NSString*)iconUrl placeHolder:(NSString*)placeHolder title:(NSString*)title;

@end



@interface PayWayListView : UIView
@property(nonatomic,copy) void(^handlePayWayChangedBlock)(PayWayListView *listView, NSInteger payWay);
@property(nonatomic,copy) void(^handleBackClickedBlock)(PayWayListView *listView);

- (id)initWithFrame:(CGRect)frame
        payWayArray:(NSArray*)payWayDOArray defaultPayWay:(NSInteger)payWay;
@end




