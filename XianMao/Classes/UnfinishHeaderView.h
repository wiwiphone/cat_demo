//
//  UnfinishHeaderView.h
//  XianMao
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UnfinishHeaderViewDelegate <NSObject>

@optional
-(void)selectedItem:(NSInteger)index;

@end

@interface UnfinishHeaderView : UIView

@property (nonatomic, weak) id<UnfinishHeaderViewDelegate> delegate;
-(void)selectedTopBtn:(NSInteger)index;
-(void)getSelectIndex:(NSInteger)selectedindex;

@end
