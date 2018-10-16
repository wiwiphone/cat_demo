//
//  CellView.h
//  XianMao
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecoverUserInfo.h"

@protocol CellViewDelegate <NSObject>

@optional
-(void)touchBegin;

@end

@interface CellView : UIView
-(instancetype)initWithTitle:(NSString *)title andIsHaveSeleted:(BOOL)isYes andIsAlrSet:(BOOL)isSet;
-(void)getRecoverUserInfo:(RecoverUserInfo *)userInfo;
-(void)getReceiveNum:(id)receiveNum;
@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, weak) id<CellViewDelegate> cellViewDelegate;
@end


@protocol CellView1Delegate <NSObject>

@optional
-(void)touchBegin;

@end

@interface CellView1 : UIView
-(instancetype)initWithTitle:(NSString *)title andIsHaveSeleted:(BOOL)isYes andIsAlrSet:(BOOL)isSet;
-(void)getRecoverUserInfo:(RecoverUserInfo *)userInfo;
-(void)getReceiveNum:(NSNumber *)receiveNum;
@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, weak) id<CellView1Delegate> cellViewDelegate;
@end

@protocol CellView2Delegate <NSObject>

@optional
-(void)touchBegin;

@end

@interface CellView2 : UIView
-(instancetype)initWithTitle:(NSString *)title andIsHaveSeleted:(BOOL)isYes andIsAlrSet:(BOOL)isSet;
-(void)getRecoverUserInfo:(RecoverUserInfo *)userInfo;
-(void)getReceiveNum:(id)receiveNum;
@property (nonatomic, strong) UISwitch *switchBtn;
@property (nonatomic, weak) id<CellView2Delegate> cellViewDelegate;
@end