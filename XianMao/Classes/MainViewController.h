//
//  MainViewController.h
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface MainViewController : BaseViewController

@property(nonatomic,assign) BOOL hidesTabBarWithAnimated;

- (void)setSelectedAtIndex:(NSInteger)selectedIndex;

- (UIView*)HUDForView;

- (UIViewController*)visibleController;

- (void)restMsgButtonCount:(NSInteger)msgCount;

@end

#define kBottomTabBarHeight    (IS_IPHONE_6P ? 56.f : 50.f)
