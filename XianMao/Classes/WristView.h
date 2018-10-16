//
//  WristView.h
//  XianMao
//
//  Created by apple on 16/6/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WristViewDelegate <NSObject>

@optional
-(void)wristDissBtn;

@end

@interface WristView : UIView

@property (nonatomic, weak) id<WristViewDelegate> wristDissDelegate;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UIButton *imageView;

@end
