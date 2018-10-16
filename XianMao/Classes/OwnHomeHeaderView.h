//
//  OwnHomeHeaderView.h
//  XianMao
//
//  Created by WJH on 17/3/2.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDetailInfo.h"

@interface OwnHomeHeaderView : UIView



+ (CGFloat)heightForOrientationPortrait:(User*)userInfo;
- (void)updateWithUserInfo:(UserDetailInfo*)userDetailInfo;

@end
