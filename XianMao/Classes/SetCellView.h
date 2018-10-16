//
//  SetCellView.h
//  XianMao
//
//  Created by apple on 16/3/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetCellViewDelegate <NSObject>

@optional
-(void)touchBegin;

@end

@interface SetCellView : UIView

@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, weak) id<SetCellViewDelegate> setCellViewDelegate;
@end
