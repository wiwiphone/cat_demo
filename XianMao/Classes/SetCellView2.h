//
//  SetCellView2.h
//  XianMao
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetCellView2Delegate <NSObject>

@optional
-(void)touchBegin;

@end

@interface SetCellView2 : UIView

@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, weak) id<SetCellView2Delegate> setCellView2Delegate;
@end
