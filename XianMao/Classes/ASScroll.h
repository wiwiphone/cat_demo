//
//  ASScroll.h
//  ScrollView Source control
//
//  Created by Ahmed Salah on 12/14/13.
//  Copyright (c) 2013 Ahmed Salah. All rights reserved.
//

#import <UIKit/UIKit.h>

#define itemWidth (_scrollview.frame.size.width - 2 * self.halfGap)

static NSInteger statusLblCurrentWidth = 80;

@protocol ASScrollViewDelegate;

@interface ASScroll : UIView<UIScrollViewDelegate>
{
    float previousTouchPoint;
    UIScrollView * _scrollview ;
    BOOL didEndAnimate;
}

@property (nonatomic, assign) NSInteger isHaveRightPage;
@property (nonatomic, assign) BOOL isHavePagePoint;
@property (nonatomic,assign) NSInteger currentPage;
@property (nonatomic, assign, readonly) BOOL isCanSeeMore;
@property (nonatomic,weak) id<ASScrollViewDelegate> delegate;

-(void)setArrOfImages:(NSMutableArray *)arrOfImages;

@end

@protocol ASScrollViewDelegate <NSObject>

@optional
- (void)didClickViewPage:(UIImageView *)imageView imageViewArray:(NSArray*)imageViewArray;

- (void)asscrollViewDidScroll:(UIScrollView *)scrollView ASScrollView:(ASScroll *)aSScrollView;
@end


@interface ASScrollPageIndicatorView : UIView

@property(assign,nonatomic) NSInteger numberOfPages;
@property(assign,nonatomic) NSInteger currentPage;

@end

@interface ASScrollPageNewView : UIView

@end
