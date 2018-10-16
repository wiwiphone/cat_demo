//
//  BoughtCollectionViewController.h
//  XianMao
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "ParyialDo.h"
@class BoughtViewController;
@interface BoughtCollectionViewController : BaseViewController
@property (nonatomic, strong) NSIndexPath *collectionViewIP;
@property (nonatomic, assign) NSInteger selectSegmentIndex;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, assign) NSInteger goonWithPayController;
@end


@interface BoughtCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) BoughtViewController *boughtController;

@end
