//
//  SearchSiftView.h
//  XianMao
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>


@class FilterModel;

@interface SearchSiftView : UIView

@property (nonatomic, copy) void(^ handleFinishButtonClick)();

-(void)getFilterModel:(FilterModel *)filterModel keyworlds:(NSString *)keyworlds array:(NSMutableArray *)FilterArray;

@end
