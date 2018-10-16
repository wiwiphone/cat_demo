//
//  PictureItemsEditView.h
//  XianMao
//
//  Created by simon cai on 10/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Command.h"
#import "BaseViewController.h"
#import "GoodsEditableInfo.h"


@class PictureItemView;
@protocol PictureItemViewDelegate <NSObject>

-(void)updatePictureItemView:(PictureItemView *)picItemView;

@end

@interface PictureItemView : CommandButton
@property(nonatomic,weak) id<PictureItemViewDelegate> delegate;
@property(nonatomic,strong) CommandButton *delBtn;
@property(nonatomic,assign) BOOL isEdit;
@property(nonatomic,copy) void(^handleDeleteTapDetected)(PictureItemView *view);
@property(nonatomic,strong) PictureItem *pictureItem;
@property(nonatomic,assign) BOOL isMainPicture;
@end


@class PictureItemsEditView;
@protocol PictureItemsEditViewDelegate <NSObject>
@optional
- (void)picturesEditViewHeightChanged:(PictureItemsEditView*)view height:(CGFloat)height;
- (void)picturesEditViewPictureItemDeleted:(PictureItemsEditView*)view item:(PictureItem*)item;
- (void)picturesEditViewPictureItemAdded:(PictureItemsEditView*)view;
- (void)picturesEditViewPictureItemOrdersChanged:(PictureItemsEditView*)view;
- (void)showPhotoShootTechniqueView;
@end

@interface PictureItemsEditView : UIView

@property(nonatomic,assign) id<PictureItemsEditViewDelegate> delegate;
@property(nonatomic) NSArray *picItemsArray;
@property(nonatomic,assign) NSInteger maxItemsCount;
@property(nonatomic,weak) BaseViewController *viewController;
@property(nonatomic,assign) BOOL isShowMainPicTip;
@property (nonatomic, assign) BOOL isEdit;

- (id)initWithFrame:(CGRect)frame isShowMainPicTip:(BOOL)isShowMainPicTip;
- (id)initWithFrame:(CGRect)frame isShowMainPicTip:(BOOL)isShowMainPicTip isHaveFengM:(BOOL)isHave;
+ (CGFloat)itemViewWidth;
+ (CGFloat)itemViewHeight;
+ (CGFloat)heightForOrientationPortrait:(NSInteger)totalCount maxItemsCount:(NSInteger)maxItemsCount;
- (void)addPics:(UIButton*)sender;
- (void)handlePikeImageFromAlum:(NSInteger)tag;
- (void)handlePikeImageFromCamera:(NSInteger)tag;
- (void)handleImagePicked:(NSInteger)userData image:(UIImage*)image filePath:(NSString*)filePath;

@end





