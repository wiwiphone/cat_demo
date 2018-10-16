//
//  SearchNewViewController.h
//  XianMao
//
//  Created by apple on 16/9/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
@class SearchNewViewController;

@class RecommendGoodsInfo;
@protocol SearchViewControllerDelegate <NSObject>
@optional
- (void)searchViewGoodsSelected:(SearchNewViewController*)viewController recommendGoods:(RecommendGoodsInfo*)recommendGoodsInfo;
@end

@interface SearchNewViewController : BaseViewController

@property(nonatomic,copy) NSString *queryKey;
@property(nonatomic,assign) NSInteger searchType;
@property(nonatomic,copy) NSString *searchKeywords;
@property(nonatomic,assign) BOOL isForSelected;
@property(nonatomic,assign) id<SearchViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger sellerId;

@end
