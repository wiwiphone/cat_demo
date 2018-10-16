//
//  ConfirmBackView.h
//  XianMao
//
//  Created by apple on 16/2/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ConfirmBackViewDelegate <NSObject>

@optional
-(void)dissMissConBackView;

@end

@interface ConfirmBackView : UIView

@property (nonatomic, weak) id<ConfirmBackViewDelegate> confirmBackDelegate;

@end
