//
//  TabBarButton.h
//  VoPai
//
//  Created by simon cai on 10/15/13.
//  Copyright (c) 2013 taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const kTabBarButtonSelectedImage;
extern NSString *const kTabBarButtonImage;
extern NSString *const kTabBarButtonText;
extern NSString *const kTabBarButtonTextFont;
extern NSString *const kTabBarButtonTextColor;
extern NSString *const kTabBarButtonSelectedTextColor;
extern NSString *const KTabBarIsCheckableBtn;
extern NSString *const KTabBarButtonIconPaddingTop;

@protocol TabBarButtonDelegate;

@interface TabBarButton : UIView

@property(nonatomic,assign) id<TabBarButtonDelegate> delegate;

@property(nonatomic,assign) BOOL enabled;
@property(nonatomic,assign) BOOL selected;
@property(nonatomic,readonly) BOOL isCheckableBtn;

- (id)initWithFrame:(CGRect)frame dict:(NSDictionary*)dict;

- (void)resetNumOfNotifications:(NSInteger)n;
- (void)addNumOfNotifications:(NSInteger)n;
- (void)removeNumOfNotifications:(NSInteger)n;
- (void)clearNotifications;

@end

@protocol TabBarButtonDelegate <NSObject>
@optional
- (void)handleTabBarButtonSingleTap:(TabBarButton*)btn;
- (void)handleTabBarButtonDoubleTap:(TabBarButton*)btn;
- (void)handleTabBarButtonLongPressed:(TabBarButton*)btn;
@end




