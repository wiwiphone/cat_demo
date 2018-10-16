//
//  publishBtn.h
//  yuncangcat
//
//  Created by 阿杜 on 16/8/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommandButton;

@interface publishBtn : UIView

@property (nonatomic,strong) UIButton * circleBtn;
@property (nonatomic,strong) CommandButton * publishBtn;
@property (nonatomic,copy) void(^buttonClick)();

@end
