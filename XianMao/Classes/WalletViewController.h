//
//  WalletViewController.h
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@class Wallet;
@interface WalletViewController : BaseViewController

@end

@interface WithdrawApplyViewController : BaseViewController

@property(nonatomic,strong) Wallet *wallet;

@end

@protocol WithdrawApplyViewControllerDelegate <NSObject>
@optional
- (void)withdrawDidFinish:(float)amount;
@end
