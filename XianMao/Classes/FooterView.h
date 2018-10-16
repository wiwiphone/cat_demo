//
//  FooterView.h
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FooterViewDelegate <NSObject>

@optional
-(void)releaseBtnClick;

@end

@interface FooterView : UIView

@property (nonatomic, weak)id <FooterViewDelegate> footDelegate;
@property (nonatomic, assign) NSInteger isEdit;
@end
