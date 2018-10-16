//
//  InviteViewController.h
//  XianMao
//
//  Created by simon cai on 24/6/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface InviteCodeConvertController : BaseViewController

@end

@interface InviteViewController : BaseViewController

@end


@interface RewardListViewController : BaseViewController

@property(nonatomic,assign) float gain_reward_money;


@end

@interface InviteButtonsView : UIView

@property(nonatomic,weak) BaseViewController *viewController;
@property(nonatomic,copy) NSString *share_text;
@property(nonatomic,copy) NSString *share_url;

@end