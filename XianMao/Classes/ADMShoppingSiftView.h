//
//  ADMShoppingSiftView.h
//  XianMao
//
//  Created by apple on 16/9/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Command.h"
@class SearchFilterInfo;

typedef void(^handleFilterButtonActionBlock)(SearchFilterInfo *filterInfo);
typedef void(^showSiftView)();

@interface ADMShoppingSiftView : UIView

-(void)getFilterInfoArray:(NSMutableArray *)filterInfoArray;
@property (nonatomic, copy) handleFilterButtonActionBlock handleFilterButtonActionBlock;
@property (nonatomic, copy) showSiftView showSiftView;

@end



@interface UserHomeFilterButton : CommandButton
@property(nonatomic,strong) SearchFilterInfo *filterInfo;
@end