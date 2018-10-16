//
//  XMPageView.h
//  XianMao
//
//  Created by darren on 15/1/23.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMPageViewDelegate;
@protocol XMPageViewDatasource;

@class XMPageViewScrollView;
@interface XMPageView : UIView<UIScrollViewDelegate>
{
    NSInteger _totalPages;
    NSInteger _curPage;
    
    BOOL _autoSwitch;
}

@property (nonatomic,weak) id<XMPageViewDatasource> datasource;
@property (nonatomic,weak) id<XMPageViewDelegate> delegate;

@property (nonatomic,assign) NSInteger currentPage;

- (id)initWithFrame:(CGRect)frame autoSwitch:(BOOL)autoSwitch;
- (void)reloadData;

@end

@protocol XMPageViewDelegate <NSObject>
@optional
- (void)didClickViewPage:(XMPageView *)csView atPageIndex:(NSInteger)index;
@end

@protocol XMPageViewDatasource <NSObject>
@required
- (NSInteger)numberOfViewPages;
- (UIView *)viewAtPageIndex:(NSInteger)index;
@end
