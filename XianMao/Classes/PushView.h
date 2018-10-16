//
//  PushView.h
//  XianMao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecoveryPreference.h"

typedef void(^resetMenu)();
typedef void(^sureMenu)(NSMutableArray *arr);

@interface PushView : UIView

-(void)getInJsonArr:(NSArray *)arr;
-(void)getData:(RecoveryPreference *)prederence;
@property (nonatomic, strong) UIViewController *viewController;

@property (nonatomic, copy) resetMenu resetMenu;
@property (nonatomic, copy) sureMenu sureMenu;

@end
