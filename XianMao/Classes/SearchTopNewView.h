//
//  SearchTopNewView.h
//  XianMao
//
//  Created by apple on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchFilterTopItemView;

@interface SearchTopNewView : UIView

@property(nonatomic,copy) void(^showSiftView)();
@property(nonatomic,copy) void(^handleTopItemTapDetected)(SearchFilterTopItemView *view);
@property(nonatomic,copy) void(^handleTopItemCancelTapDetected)(SearchFilterTopItemView *view);

- (void)updateByFilterInfos:(NSArray*)filterInfos;
- (NSArray*)filterInfos;

@end
