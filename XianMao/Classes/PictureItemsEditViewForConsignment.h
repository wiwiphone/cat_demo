//
//  PictureItemsEditViewForConsignment.h
//  XianMao
//
//  Created by WJH on 17/2/7.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cate.h"

@protocol PictureItemsEditViewForConsignmentDelegate <NSObject>
@optional

- (void)imagePickerDidFinishPickingPhotos:(CGFloat)height picTrueItem:(NSArray *)pictreus;
- (void)pulishSelectCate;

@end

@interface PictureItemsEditViewForConsignment : UIView

@property (nonatomic, weak) id<PictureItemsEditViewForConsignmentDelegate> delegate;
@property (nonatomic, strong) Cate *selectedCate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger maxImagesCount;
@property (nonatomic, assign) NSInteger defautViewHeight;
@property (nonatomic, assign) BOOL isNeedPushViewCtrl;


- (void)addPictures;

@end
