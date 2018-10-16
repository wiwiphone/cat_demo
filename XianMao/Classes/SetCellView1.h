//
//  SetCellView1.h
//  XianMao
//
//  Created by apple on 16/3/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SetCellView1Delegate <NSObject>

@optional
-(void)touchBegin;

@end

@interface SetCellView1 : UIView

@property (nonatomic, strong) UILabel *rigthLbl;
@property (nonatomic, weak) id<SetCellView1Delegate> setCellView1Delegate;
@end
