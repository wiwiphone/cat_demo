//
//  WristInviteView.h
//  XianMao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WristView.h"

typedef void(^inviteDismiss)();

@interface WristInviteView : WristView

@property (nonatomic, copy) inviteDismiss inviteDiss;

@end
