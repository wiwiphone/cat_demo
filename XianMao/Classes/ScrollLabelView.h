//
//  ScorllLabelView.h
//  XianMao
//
//  Created by WJH on 16/11/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollLabelView : UIView


@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSMutableArray *titleNewArray;

- (void)beginScroll;
@end
