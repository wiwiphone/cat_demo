//
//  GoodsDetailViewController.h
//  XianMao
//
//  Created by simon cai on 11/8/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "Command.h"
#import "PagesContainerView.h"

@interface GoodsDetailViewControllerContainer : BaseViewControllerHandleMemoryWarning

@property(nonatomic,copy) NSString *goodsId;
//@property(nonatomic,weak) PagesContainerView *pagesContainerView;

- (void)scrollViewDidScrollFromGoodsDetail:(UIScrollView *)scrollView;
- (void)setViewControllerAtIndex:(NSUInteger)index animated:(BOOL)animated;

@end


@interface GoodsDetailViewController : BaseViewControllerHandleMemoryWarning

@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,weak) GoodsDetailViewControllerContainer *controllerContainer;
@end


@protocol GoodsDetailHeaderTabViewDelegate;
@interface GoodsDetailHeaderTabView : UIView

@property(nonatomic,assign) id<GoodsDetailHeaderTabViewDelegate> delegate;
+ (CGFloat)heightForOrientationPortrait;

@property(nonatomic,assign) NSInteger curTabIndex;
@property(nonatomic,strong,readonly) UIButton *attrBtn;

@end

@protocol GoodsDetailHeaderTabViewDelegate <NSObject>
- (void)tabView:(GoodsDetailHeaderTabView*)view displayTabAtIndex:(NSInteger)index;
@end


@class GoodsDetailInfo;
@class GoodsDetailHeaderView;

typedef void(^GoodsDetailHeaderViewCoverClickBlock)(GoodsDetailHeaderView *sender);

@interface GoodsDetailHeaderView : UIView

@property (nonatomic, copy) void(^scrollTable)();
@property(nonatomic,copy) GoodsDetailHeaderViewCoverClickBlock coverClickBlock;

+ (CGFloat)heightForOrientationPortrait:(GoodsDetailInfo*)detailInfo;
- (CGFloat)updateWithDetailInfo:(GoodsDetailInfo *)detailInfo;

@end


//@interface BottomLadderShapedView : CommandButton
//
//@property (strong, nonatomic) UIColor *color;
//@property (assign, nonatomic) CGFloat topLeft;
//@property (assign, nonatomic) CGFloat bottomRight;
//
//@end


@interface GoodsAttributesPopupView : TapDetectingView

+ (void)showInView:(UIView*)view detailInfo:(GoodsDetailInfo*)detailInfo;

@end


@interface GoodsDetailTopBarIndicatorView : UIView

@property(nonatomic,copy) void(^didSelectAtIndex)(NSInteger index);
@property(nonatomic,copy) void(^beforeSelectAtIndex)(NSInteger index);
@property(nonatomic,strong) UIView *indicatorView;

- (id)initWithFrame:(CGRect)frame tabBtnTitles:(NSArray*)tabBtnTitles;
- (void)setTabAtIndex:(NSInteger)index animated:(BOOL)animated;

@end








