//
//  RXRotateButtonOverlayView.h
//  XianMao
//
//  Created by WJH on 17/2/28.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RXRotateButtonOverlayViewDelegate <NSObject>
@optional
-(void)pushPublishNofm;
-(void)pushPublishRecovery;
-(void)pushPublishDraft;
@end

//解决iOS7和iOS11.2崩溃问题 修改父类
@interface RXRotateButtonOverlayView : UIView

@property (nonatomic, weak) id<RXRotateButtonOverlayViewDelegate> delegate;

@property (nonatomic, strong) NSArray* titles;
@property (nonatomic, strong) NSArray* titleImages;
@property (nonatomic, strong) NSArray* subTitles;

- (void)show;
- (void)dismiss;

@end
