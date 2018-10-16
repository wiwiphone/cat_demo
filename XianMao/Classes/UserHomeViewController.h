//
//  UserHomeViewController.h
//  XianMao
//
//  Created by simon cai on 11/10/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "Command.h"
#import "TagsPopView.h"
#import "ConfirmBackView.h"

@interface UserHomeViewController : BaseViewController

@property(nonatomic,assign) NSInteger userId;

@end


@class UserHomeHeaderView;
@protocol UserHomeHeaderViewDelegate <NSObject>
@optional
- (void)toggleDetailView:(UserHomeHeaderView*)headerView isShow:(BOOL)isShow;
- (void)headerViewModifyFront:(UserHomeHeaderView*)headerView;
- (void)pushCatHouseController;
@end

@class User;
@class UserDetailInfo;
@interface UserHomeHeaderView : UIView<ConfirmBackViewDelegate, tagsPopViewDelegate>

@property(nonatomic,assign) id<UserHomeHeaderViewDelegate> myDelegate;

@property (nonatomic, strong) TagsPopView *popView;
@property (nonatomic, strong) ConfirmBackView *popBgView;

+ (CGFloat)heightForOrientationPortrait:(UserDetailInfo*)userDetailInfo;

- (void)updateWithUserInfo:(UserDetailInfo*)userDetailInfo;
- (void)notifyHideDetailView;
- (CGFloat)tagsViewHeight;

@end


@class UserHomeDetailView;
@protocol UserHomeDetailViewDelegate <NSObject>
@optional
- (void)tappedHideDetailView:(UserHomeDetailView*)detailView;
@end

@interface UserHomeDetailView : UIView<UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate>
@property(nonatomic,assign) id<UserHomeDetailViewDelegate> delegate;
- (void)updateWithUserInfo:(UserDetailInfo*)userDetailInfo;
@end

