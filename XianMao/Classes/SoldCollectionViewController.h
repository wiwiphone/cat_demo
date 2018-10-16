//
//  SoldCollectionViewController.h
//  XianMao
//
//  Created by apple on 16/2/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
@class SoldViewController;
@interface SoldCollectionViewController : BaseViewController
@property (nonatomic, strong) NSIndexPath *collectionViewIP;
@end


@interface SoldCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) SoldViewController *soldViewController;

@end