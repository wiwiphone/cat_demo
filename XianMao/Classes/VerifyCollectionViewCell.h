//
//  VerifyCollectionViewCell.h
//  XianMao
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VerifyTableViewController.h"

@interface VerifyCollectionViewCell : UICollectionViewCell

@property (nonatomic, assign) BOOL isThred;
@property (nonatomic, strong) VerifyTableViewController *verifyController;
@property (nonatomic, assign) BOOL isRecept;

@end
