//
//  RecoverCollectionViewController.h
//  XianMao
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
@class OnSaleViewController;

@interface RecoverCollectionViewController : BaseViewController
@property (nonatomic, strong) NSIndexPath *collectionViewIP;
@property (nonatomic, assign) NSInteger segmentIndex;
@property (nonatomic, assign) NSInteger type;
@end


@interface RecoverCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) OnSaleViewController *onSaleViewController;

@end