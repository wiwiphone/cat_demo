//
//  MineNewHeaderView.h
//  XianMao
//
//  Created by apple on 16/4/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VisualEffectView;
@interface MineNewHeaderView : UIImageView

@property(nonatomic,copy) void(^handleNewSingleTapDetected)(MineNewHeaderView *view);

-(void)setData;

@end
