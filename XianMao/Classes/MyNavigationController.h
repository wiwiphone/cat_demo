//
//  MyNavigationController.h
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

#define WINDOW  [[UIApplication sharedApplication]keyWindow]

#define kNotificationOrientationChange  @"kNotificationOrientationChange"

@protocol MyNavigationControllerDelegate;

@interface MyNavigationController : UINavigationController

@property (nonatomic, assign) id <MyNavigationControllerDelegate> myNaigationDelegate;

@end

@protocol MyNavigationControllerDelegate <NSObject>

@optional
- (BOOL)willDismissNavigationController:(MyNavigationController*)navigatonController;

@end
