//
//  GoodsGradeHUDView.h
//  XianMao
//
//  Created by Marvin on 17/3/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfo.h"

@interface GoodsGradeHUDView : UIView

+ (GoodsGradeHUDView *)show;


- (void)getGradeTag:(GoodsGradeTag *)gradeTag;

@end
