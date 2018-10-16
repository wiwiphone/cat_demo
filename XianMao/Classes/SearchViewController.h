//
//  SearchGoodsViewController.h
//  XianMao
//
//  Created by simon cai on 11/9/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "SearchFilterInfo.h"
#import "Command.h"
#import "BaseTableViewCell.h"
#import "KeywordMapdetail.h"
@interface SearchTableSepViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
@end

@protocol SearchViewControllerDelegate;

@interface SearchViewController : BaseViewController

+ (NSArray*)createQueryFilterKVs:(NSString*)paramsJsonData;

@property (nonatomic, assign) NSInteger isXianzhi;
@property(nonatomic,copy) NSString *queryKey;
@property(nonatomic,strong) SearchFilterItem *filterItem;
@property(nonatomic,strong) NSArray *queryKVItemsArray;
@property(nonatomic,copy) NSString *searchKeywords;
@property(nonatomic,assign) NSInteger searchType;
@property(nonatomic,strong) KeywordMapdetail * keywordMap;
@property(nonatomic,assign) id<SearchViewControllerDelegate> delegate;
@property(nonatomic,assign) BOOL isForSelected;
@property(nonatomic,assign) NSInteger sellerId;

@end

@class RecommendGoodsInfo;
@protocol SearchViewControllerDelegate <NSObject>
@optional
- (void)searchViewGoodsSelected:(SearchViewController*)viewController recommendGoods:(RecommendGoodsInfo*)recommendGoodsInfo;
@end

@class SearchBarView;
@protocol SearchBarViewDelegate <NSObject>
@optional
- (void)searchBarTextDidBeginEditingBefore:(SearchBarView *)searchBarView;
- (BOOL)searchBarPromptingWordsDoSearch:(SearchBarView*)view keywords:(NSString*)keywords;

@end

@interface SearchBarView : UISearchBar<UIGestureRecognizerDelegate,UISearchBarDelegate>  {
    UIButton *_canccelButton;
}

@property(nonatomic,assign) id<SearchBarViewDelegate> searchBarDelegate;
@property(nonatomic,assign) NSInteger currentSearchType;
@property(nonatomic,strong) NSString * mapText;

- (id)initWithFrame:(CGRect)frame isShowClearButton:(BOOL)isShowClearButton;
- (id)initWithFrame:(CGRect)frame isShowClearButton:(BOOL)isShowClearButton isShowLeftCombBox:(BOOL)isShowLeftCombBox;
- (id)initWithFrame:(CGRect)frame isShowClearButton:(BOOL)isShowClearButton isShowLeftCombBox:(BOOL)isShowLeftCombBox isShowHotWords:(BOOL)isShowHotWords;
-(void)enableCancelButton:(BOOL)enable;
- (void)setCurrentSearchType:(NSInteger)currentSearchType;
- (NSInteger)currentSearchType ;

+ (NSMutableDictionary*)loadSearchHisotryItems;
+ (void)saveSearchHisotryWord:(NSString*)word forKey:(NSString*)key;

@end


@interface SearchFilterItemView : CommandButton

@property(nonatomic,strong) SearchFilterItem *filterItem;

- (void)updateByFilterItem:(SearchFilterItem*)filterItem;

@end


@interface SearchFilterTopItemView : SearchFilterItemView

@property(nonatomic,strong) SearchFilterInfo* filterInfo;
@property(nonatomic,readonly) NSInteger itemViewTag;
@property(nonatomic,strong) TapDetectingImageView *chosingView;
- (void)setChosingState:(BOOL)chosing;
- (BOOL)isChosingState;

@end

@interface SearchFilterTopView : UIView

@property(nonatomic,copy) void(^handleTopItemTapDetected)(SearchFilterTopItemView *view);
@property(nonatomic,copy) void(^handleTopItemCancelTapDetected)(SearchFilterTopItemView *view);

- (void)updateByFilterInfos:(NSArray*)filterInfos;
- (void)updateTopItemsSelectedState;
- (void)cancelFilter;
- (NSArray*)filterInfos;

@end

@interface SearchFilterInfoView : UIView

@property(nonatomic,strong) SearchFilterInfo* filterInfo;
@property(nonatomic,assign) BOOL isShowBottomeLine;
@property(nonatomic,assign) BOOL isShowTitle;
@property(nonatomic,assign) BOOL isAllowMultiSelected;
@property(nonatomic,copy) void(^handleFilterItemTapDetected)(SearchFilterItemView *view);

+ (CGFloat)rowHeightForPortrait:(SearchFilterInfo*)filterInfo isShowTitle:(BOOL)isShowTitle columnNum:(NSInteger)columnNum;
- (void)updateByFilterInfo:(SearchFilterInfo*)filterInfo columnNum:(NSInteger)columnNum;

- (NSArray*)selectedFilterItems;
- (void)cancelFilter;
- (NSArray*)filterItemViews;

@end


@interface SearchFilterContainerView : UIView

@property(nonatomic,copy) void(^handleFilterCancelDetected)(SearchFilterContainerView *view);
@property(nonatomic,copy) void(^handleFilterItemsSelected)(SearchFilterContainerView *view, NSArray *filterInfos);
@property(nonatomic,strong) SearchFilterInfo* filterInfo;

- (void)updateByFilterInfo:(SearchFilterInfo*)filterInfo;
- (NSArray*)selectedFilterInfos;
- (void)cancelFilter;
@end





//search/filter 返回 timestamp，    search/list 中翻下一页的时候都传参数latesttime=timestamp









