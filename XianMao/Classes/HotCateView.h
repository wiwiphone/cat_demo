//
//  HotCateView.h
//  XianMao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CateHotButton.h"
typedef void(^clickHotCateBtn)(CateHotButton *sender);

@interface HotCateView : UIView

-(void)getData:(NSMutableArray *)dataArr;
@property (nonatomic, copy) clickHotCateBtn clickHotCateBtn;

@end
