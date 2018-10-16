//
//  MineNewBottomCell.h
//  XianMao
//
//  Created by apple on 16/7/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^handleCell)();

@interface MineNewBottomCell : UIView

-(instancetype)initWithIcon:(NSString *)iconName title:(NSString *)title subTitle:(NSString *)subTitle isRightAllow:(BOOL)isYes;
@property (nonatomic, copy) handleCell handlsCell;

@end
