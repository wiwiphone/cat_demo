//
//  VisualEffectView.h
//  XianMao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MFBlurEffectStyle) {
    MFBlurEffectStyleExtraLight,
    MFBlurEffectStyleLight,
    MFBlurEffectStyleDark
};

typedef void(^touchView)();

@interface VisualEffectView : UIVisualEffectView

@property (nonatomic, assign) MFBlurEffectStyle *style;
@property (nonatomic, copy) touchView touchView;
@property (nonatomic, assign) CGFloat alpleValue;

-(instancetype)initWithFrame:(CGRect)frame style:(MFBlurEffectStyle)style;
@end
