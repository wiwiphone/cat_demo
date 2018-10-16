//
//  FilterItemViewTwo.h
//  XianMao
//
//  Created by 阿杜 on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterItemModel.h"

@interface FilterItemViewTwo : UIView



- (void)getFilterItemArray:(FilterItemModel *)filterItem qk:(NSString *)qk multiSelected:(NSInteger)multiSelected filterArray:(NSArray *)filterArray;
@end
