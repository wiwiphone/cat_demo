//
//  SaleStateHeaderView.h
//  XianMao
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SaleStateHeaderViewDelegate <NSObject>

@optional
-(void)selectedItem:(NSInteger)index;

@end

@interface SaleStateHeaderView : UIView

@property (nonatomic, weak) id<SaleStateHeaderViewDelegate> delegate;
-(void)selectedTopBtn:(NSInteger)index;
-(void)getSelectIndex:(NSInteger)selectedindex;

@end
