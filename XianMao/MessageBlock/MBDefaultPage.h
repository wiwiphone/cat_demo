//
//  MBDefaultPage.h
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MBPage.h"

@interface MBDefaultPage : UIView <MBPage>

//初始化一个page
- (id)initWithFrame:(CGRect)frame withViewDO:(id)viewDO;

//Page载入View
- (void)loadView;

@end

