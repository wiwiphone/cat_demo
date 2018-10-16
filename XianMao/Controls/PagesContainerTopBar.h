//
//  PagesContainerTopBar.h
//  XianMao
//
//  Created by simon cai on 18/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PagesContainerTopBar;

@protocol PagesContainerTopBarDelegate <NSObject>

- (void)itemAtIndex:(NSUInteger)index didSelectInPagesContainerTopBar:(PagesContainerTopBar*)bar;

@end

@interface PagesContainerTopBar : UIImageView

@property (strong, nonatomic) NSArray *itemTitles;
@property (strong, nonatomic) UIFont *font;
@property (readonly, strong, nonatomic) NSArray *itemViews;
@property (readonly, strong, nonatomic) UIScrollView *scrollView;
@property (weak, nonatomic) id<PagesContainerTopBarDelegate> delegate;
@property(nonatomic,assign) CGFloat contentMarginTop;

- (CGPoint)centerForSelectedItemAtIndex:(NSUInteger)index;
- (CGPoint)contentOffsetForSelectedItemAtIndex:(NSUInteger)index;

@end
