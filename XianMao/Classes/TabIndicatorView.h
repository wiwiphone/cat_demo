//
//  TabIndicatorView.h
//  XianMao
//
//  Created by simon on 11/25/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabIndicatorView : UIView

+ (CGFloat)heightForOrientationPortrait;

- (id)initWithFrame:(CGRect)frame tabCount:(NSInteger)tabCount;

@property(nonatomic,assign) NSInteger curTabIndex;

@end
