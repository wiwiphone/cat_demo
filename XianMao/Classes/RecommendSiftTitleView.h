//
//  RecommendSiftTitleView.h
//  XianMao
//
//  Created by apple on 16/10/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecommendInfo.h"
#import "Command.h"

typedef void(^handleRecommendBtn)(CommandButton *sender);

@interface RecommendSiftTitleView : UIView

@property (nonatomic, copy) handleRecommendBtn handleRecommendBtn;

@property (nonatomic, strong) UIScrollView *scrollView;
-(void)getRecommendInfo:(RecommendInfo *)recommendInfo andTag:(NSInteger)tag;
- (void)scrollTitleLabelSelectededCenter:(CommandButton *)btn;

@end
