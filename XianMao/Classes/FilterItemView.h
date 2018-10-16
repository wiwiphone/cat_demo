//
//  FilterItemView.h
//  XianMao
//
//  Created by 阿杜 on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterItemSubView.h"

@class FilterItemModel;

@protocol FilterItemViewDelegate <NSObject>

-(void)moreButtonClick:(NSInteger)height viewTag:(NSInteger)tag;

@end

@interface FilterItemView : UIView

@property (nonatomic, assign) BOOL isHiddenLine;
@property (nonatomic, assign) BOOL isShowSubItem;


@property (nonatomic, strong) FilterItemSubView * itemSubView;
@property (nonatomic, weak) id<FilterItemViewDelegate> delegate;




- (CGFloat)getFilterItemArray:(FilterItemModel *)filterItem viewTag:(NSInteger)tag filterArray:(NSArray *)filterArrayD;

@end
