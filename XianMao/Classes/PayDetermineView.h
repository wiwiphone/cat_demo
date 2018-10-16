//
//  PayDetermineView.h
//  XianMao
//
//  Created by apple on 16/12/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^chooseDetermine)(BOOL isSelected);

@interface PayDetermineView : UIView

@property (nonatomic, copy) chooseDetermine chooseDetermine;

@end
