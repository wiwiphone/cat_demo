//
//  QuanListPopupView.h
//  XianMao
//
//  Created by simon on 2/14/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BonusInfo.h"

#import "ActionSheet.h"

typedef void (^QuanListPopupViewConfirmClickedBlock)(BonusInfo *bonusInfo);
typedef void (^QuanListPopupViewCancelClickedBlock)();

@interface QuanListPopupView : UIView

- (id)init;

- (void)showInView:(UIView *)view
        bonusItems:(NSArray*)bonusItems
confirmClickedBlock:(QuanListPopupViewConfirmClickedBlock)confirmClickedBlock
cancelClickedBlock:(QuanListPopupViewCancelClickedBlock)cancelClickedBlock;

@end
