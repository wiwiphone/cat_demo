//
//  GoodsStatusView.h
//  XianMao
//
//  Created by simon on 3/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsStatusMaskViewDelegate;
@class OrderLockInfo;
@interface GoodsStatusMaskView : UIView

@property(nonatomic,assign) id<GoodsStatusMaskViewDelegate> delegate;
@property(nonatomic) NSString *statusString;
@property(nonatomic) OrderLockInfo *orerLockInfo;
@property (nonatomic, strong) UILabel *statusLbl;

- (id)initForCircle:(CGFloat)diameter;


@end


@protocol GoodsStatusMaskViewDelegate <NSObject>
@optional
- (void)goodsStatusMaskViewGoodsUnLocked:(GoodsStatusMaskView*)maskView;
@end
