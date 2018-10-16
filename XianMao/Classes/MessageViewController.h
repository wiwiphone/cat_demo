//
//  MessageViewController.h
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "PullRefreshTableView.h"
#import "Command.h"

@interface MessageViewController : BaseViewControllerHandleMemoryWarning

@end


@interface MessageTabBarButton : CommandButton

- (void)resetNumOfNotifications:(NSInteger)n;
- (void)addNumOfNotifications:(NSInteger)n;
- (void)removeNumOfNotifications:(NSInteger)n;
- (void)clearNotifications;

@end

@interface MessageTabBar : UIView

@property(nonatomic,copy) void(^didSelectAtIndex)(NSInteger index);

- (id)initWithFrame:(CGRect)frame tabBtnTitles:(NSArray*)tabBtnTitles;
- (void)setTabAtIndex:(NSInteger)index animated:(BOOL)animated;

- (void)resetNumOfNotifications:(NSInteger)n atIndex:(NSInteger)index;

@end




