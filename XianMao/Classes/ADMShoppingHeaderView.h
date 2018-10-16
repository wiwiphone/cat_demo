//
//  ADMShoppingHeaderView.h
//  XianMao
//
//  Created by apple on 16/9/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetailInfo.h"

@interface ADMShoppingHeaderView : UIView

@property (nonatomic, assign) NSInteger userId;
-(void)getUserDetailInfo:(UserDetailInfo *)userDetailInfo;

@end
