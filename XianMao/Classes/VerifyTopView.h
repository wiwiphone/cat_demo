//
//  VerifyTopView.h
//  XianMao
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VerifyTopViewDelegate <NSObject>

@optional
-(void)selectedItem:(NSInteger)index;

@end

@interface VerifyTopView : UIView

@property (nonatomic, weak) id<VerifyTopViewDelegate> delegate;
-(void)selectedTopBtn:(NSInteger)index;
-(void)getSelectIndex:(NSInteger)selectedindex;

@end
