//
//  PartialView.h
//  XianMao
//
//  Created by apple on 16/7/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ParyialDo.h"
#import "PayTypeView.h"
typedef void(^clickProtialCloseBrn)();
typedef void(^showPayWayView)();
typedef void(^inputPrice)(NSString *priceNum, ParyialDo *partialDo);
typedef void(^payBtn)(ParyialDo *paryialDo);

@interface PartialView : UIView

@property (nonatomic, copy) clickProtialCloseBrn clickProtialCloseBtn;
@property (nonatomic, copy) showPayWayView showPayWayView;
@property (nonatomic, copy) inputPrice inputPrice;
@property (nonatomic, strong) PayTypeView *payTypeView;
@property (nonatomic, copy) payBtn payBtn;
@property (nonatomic, strong) UITextField *textField;
-(void)getPartialDo:(ParyialDo *)partialDo;
-(void)getPayingPrice:(CGFloat )payingPrice;

@end
