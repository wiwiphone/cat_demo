//
//  OnSaleViewController.h
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewController.h"

@interface OnSaleViewController : BaseViewController

@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger mineStatus;
@property (nonatomic, assign) NSInteger recoverStatus;
@property (nonatomic, assign) BOOL isHaveTopbar;

@property (nonatomic, assign) NSInteger sellerId;
@property (nonatomic, copy) NSString *chatter;
@property (nonatomic, copy) NSString *sellerName;
@property (nonatomic, copy) NSString *sellerHeaderImg;
@property (nonatomic, assign) NSInteger isChatCome;

@property (nonatomic, assign) NSInteger viewCode;
-(void)initDataListLogic;

@end


@interface PublishedViewController : OnSaleViewController

@end

@protocol SearchMyGoodsViewControllerDelegate;

@class GoodsInfo;

@interface SearchMyGoodsViewController : OnSaleViewController
@property(nonatomic,assign) id<SearchMyGoodsViewControllerDelegate> delegate;
@end

@protocol SearchMyGoodsViewControllerDelegate <NSObject>
@optional
- (void)onSaleViewGoodsSelected:(SearchMyGoodsViewController*)viewController goods:(GoodsInfo*)goodsInfo;
@end