//
//  TabBarView.h
//  VoPai
//
//  Created by simon cai on 10/15/13.
//  Copyright (c) 2013 taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarButton.h"

@protocol TabBarViewDelegate;

@interface TabBarView : UIImageView

@property (nonatomic, assign) id<TabBarViewDelegate> delegate;
@property (nonatomic, readonly) CGFloat realHeight;

- (id)initWithFrame:(CGRect)frame buttonDicts:(NSArray *)buttonDicts;
- (void)selectTabAtIndex:(NSInteger)index;
-(void)setButtonDicts:(NSArray *)buttonDicts;

- (NSArray*)tabBarButtonArray;

@end

typedef enum {
    TabBarButtonSelected = 0,
    TabBarButtonSelectedByClicked,
    TabBarButtonSelectedByDoubleClicked,
    TabBarButtonSelectedByLongPressed,
} TabBarButtonSelectedMethod;

@protocol TabBarViewDelegate<NSObject>
@optional
- (void)catapultOptionView;
- (BOOL)tabBarView:(TabBarView *)tabBar beforeSelectAtIndex:(NSInteger)index selectedMethod:(TabBarButtonSelectedMethod)selectedMethod;
- (void)tabBarView:(TabBarView *)tabBar didSelectAtIndex:(NSInteger)index selectedMethod:(TabBarButtonSelectedMethod)selectedMethod;
@end


