//
//  AreaViewController.h
//  XianMao
//
//  Created by simon on 12/5/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@protocol AreaViewControllerDelegate;

@interface AreaViewController : BaseViewController

@property(nonatomic,assign) id<AreaViewControllerDelegate> delegate;
@property(nonatomic,assign) NSInteger areaTableType;
@property(nonatomic,strong) NSArray * areaItems;
@property(nonatomic,copy) NSString *areaName;

@end


@protocol AreaViewControllerDelegate <NSObject>

- (void)areaDidSelected:(AreaViewController*)viewController districtID:(NSString*)districtID areaName:(NSString*)areaName;

@end