//
//  SideMenuController.h
//  alover
//
//  Created by simon cai on 8/6/14.
//  Copyright (c) 2014 alover.me. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideMenuController : UIViewController

@property (nonatomic, strong, readonly) UIViewController *menuViewController;
@property (nonatomic, strong, readonly) UIViewController *contentViewController;

@property (nonatomic, assign) CGFloat menuViewOverlapWidth;
@property (nonatomic, assign) CGFloat bezelWidth;
@property (nonatomic, assign) CGFloat contentViewScale;
@property (nonatomic, assign) CGFloat contentViewOpacity;
@property (nonatomic, assign) CGFloat shadowOpacity;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) BOOL panFromBezel;
@property (nonatomic, assign) BOOL panFromNavBar;
@property (nonatomic, assign) CGFloat animationDuration;

- (id)initWithMenuViewController:(UIViewController *)menuViewController
           contentViewController:(UIViewController *)contentViewController;

- (void)closeMenu;
- (void)openMenu;

- (void)reloadContentViewController:(UIViewController *)contentViewController closeMenu:(BOOL)closeMenu;
- (void)reloadMenuViewController:(UIViewController *)menuViewController closeMenu:(BOOL)closeMenu;

@end


@interface UIViewController (SideMenuController)
- (SideMenuController *)sideMenuController;
@end
