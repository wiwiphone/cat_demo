//
//  SprangView.h
//  XianMao
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SprangViewDelegate <NSObject>

@optional
-(void)pushPublishNofm;
-(void)pushPublishRecovery;
-(void)pushPublishDraft;
@end

@interface SprangView : UIView

@property (nonatomic, weak) id<SprangViewDelegate> sprangDelegate;

@end
