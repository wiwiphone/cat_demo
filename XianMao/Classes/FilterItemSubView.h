//
//  FilterItemSubView.h
//  XianMao
//
//  Created by 阿杜 on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FilterItemSubView : UIView


- (void)getFilterItemArray:(NSArray *)smallItemArray qk:(NSString *)qk multiSelected:(NSInteger)multiSelected filterArray:(NSArray *)filterArray;
- (NSInteger)getFilterItemArray:(NSArray *)smallItemArray type:(NSInteger)type qk:(NSString *)qk multiSelected:(NSInteger)multiSelected filterArray:(NSArray *)filterArray;

@end
