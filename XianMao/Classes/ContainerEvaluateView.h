//
//  ContainerEvaluateView.h
//  XianMao
//
//  Created by 阿杜 on 16/8/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Command.h"

@interface ContainerEvaluateView : UIView

@property (nonatomic,strong) TapDetectingImageView * colseBtn;
@property (nonatomic,strong) CommandButton * btn1;
@property (nonatomic,strong) CommandButton * btn2;


-(instancetype)initWithiconName:(NSString *)iconName
                      desString:(NSString *)desString
                       btn1Name:(NSString *)btn1Name
                       btn2Name:(NSString *)btn2Name;

@end
