//
//  SoldViewController.h
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"


@interface SoldViewController : BaseViewController

@property (nonatomic, assign) NSInteger status;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger viewCode;
-(void)initDataListLogic;

@end


@interface ModifyOrderGoodsPriceView : UIView

+ (void)showInView:(UIView*)view dealPrice:(double)dealPrice completionBlock:(void (^)(float newPrice))completionBlock;
@end


@class AddressInfo;
@interface DeliverInfoEditView : UIView

+ (void)showInView:(UIView*)view
    isSecuredTrade:(BOOL)isSecuredTrade
      mailTypeList:(NSArray*)mailTypeList
       addressInfo:(AddressInfo*)addressInfo
   completionBlock:(BOOL (^)(NSString *mailSN, NSString* mailType))completionBlock;

+ (void)showInViewWithAdress:(UIView*)view
              isSecuredTrade:(BOOL)isSecuredTrade
                mailTypeList:(NSArray*)mailTypeList
                 addressInfo:(AddressInfo*)addressInfo
             completionBlock:(BOOL (^)(NSString *mailSN, NSString* mailType))completionBlock;
@end


@interface SoldViewControllerForGoodsOrders : SoldViewController
@property(nonatomic,copy) NSString *goodsId;
@end


