//
//  PublishGoodsViewController.h
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewCell.h"
#import "Command.h"
#import "PictureItemsEditView.h"
#import "PhotoTableViewCell.h"

@class GoodsEditableInfo;
@class AttrEditableInfo;

@protocol PublishGoodsViewControllerDelegate <NSObject>
@optional

@end

@interface PublishGoodsViewController : BaseViewController

@property(nonatomic,copy) void(^handlePublishGoodsFinished)(GoodsEditableInfo *goodsEditableInfo);
@property(nonatomic,copy) NSString *goodsId;
@property(nonatomic,assign) BOOL isEditGoods;

@end

@protocol PublishGoodsContentViewDelegate <NSObject>

@optional
-(void)pushWebViewController:(UIViewController *)controller;

@end

@interface PublishGoodsContentView : UIScrollView

@property(nonatomic,strong) GoodsEditableInfo *editableInfo;
@property(nonatomic,weak) BaseViewController *viewController;
@property (nonatomic, weak) UIView *backView1;
@property (nonatomic, weak) id<PublishGoodsContentViewDelegate> publishGoodsDelegate;
- (void)publish;

@end

@interface AttrInfoEditButton : CommandButton
@property(nonatomic,strong) AttrEditableInfo *attrEditableInfo;
@end

@interface PublishSelectableItem : NSObject

@property (nonatomic, copy) NSString *brandName;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *summary;
@property(nonatomic,strong) NSObject *attachedItem;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,assign) BOOL hasChildren;

+ (PublishSelectableItem*)buildSelectableItem:(NSString*)title
                                      summary:(NSString*)summary
                                   isSelected:(BOOL)isSelected attatchedItem:(NSObject*)attatchedItem;

+ (PublishSelectableItem*)buildSelectableItem:(NSString*)title
                                      summary:(NSString*)summary
                                  hasChildren:(BOOL)hasChildren attatchedItem:(NSObject*)attatchedItem;

- (NSString *)getFirstName;

@end


@interface PublishItemSearchResultTableViewCell : BaseTableViewCell
@property(nonatomic,strong) PublishSelectableItem *selectableItem;
+ (NSMutableDictionary*)buildCellDict:(PublishSelectableItem*)item;
+ (NSString*)cellKeyForSelectableItem;
- (void)updateCellWithDict:(NSDictionary*)dict;
@end

@interface PublishSelectableTableViewCell : BaseTableViewCell
@property(nonatomic,strong) PublishSelectableItem *selectableItem;
+ (NSMutableDictionary*)buildCellDict:(PublishSelectableItem*)item;
+ (NSString*)cellKeyForSelectableItem;
- (void)updateCellWithDict:(NSDictionary*)dict;
@end

@class PublishSelectViewController;
@protocol PublishSelectViewControllerDelegate <NSObject>
@optional
- (void)publishDidSelect:(PublishSelectViewController*)viewController selectableItem:(PublishSelectableItem*)selectableItem;

-(void)publishDidSelectHeaderView:(NSInteger)brandId andBrandName:(NSString *)brandName;
@end

@interface PublishSelectViewController : BaseViewController
@property(nonatomic,assign) id<PublishSelectViewControllerDelegate> delegate;
@property(nonatomic,strong) NSArray *selectableItemArray;
@property(nonatomic,copy) void(^callbackBlockAfterWiewDidLoad)();
@property(nonatomic,assign) BOOL isGroupedWithName;
@property(nonatomic,assign) BOOL isSupportSearch;

@property (nonatomic, assign) BOOL isShowHeader;
@property (nonatomic, assign) NSInteger cate_id;
- (void)reloadData;
@end

@class PublishSelectFitPeopleViewController;
@protocol PublishSelectFitPeopleViewControllerDelegate <NSObject>
@optional
- (void)publishDidSelect:(PublishSelectFitPeopleViewController*)viewController fitPeople:(NSInteger)fitPeople title:(NSString*)title;
@end
@interface PublishSelectFitPeopleViewController : BaseViewController
@property(nonatomic,assign) id<PublishSelectFitPeopleViewControllerDelegate> delegate;
@property(nonatomic,strong) NSArray *selectableItemArray;
@property(nonatomic,assign) NSInteger fitPeople;
@end

@class PublishTextEditViewController;
@protocol PublishTextEditViewControllerDelegate <NSObject>
@optional
- (void)publishDidEdit:(PublishTextEditViewController*)viewController selectableItem:(PublishSelectableItem*)selectableItem;
@end

@interface PublishTextEditViewController : BaseViewController
@property(nonatomic,assign) id<PublishTextEditViewControllerDelegate> delegate;
@property(nonatomic,strong) PublishSelectableItem *selectableItem;
@end


@interface PictureItemsEditViewForPublishGoods : PictureItemsEditView

@property (nonatomic, assign) PhotoTableViewCell *contentCell;
@property(nonatomic,assign) PublishGoodsContentView *contentView;
@property(nonatomic,copy) void(^handleAddPicActionBlock)(NSInteger userData);

@end

//
//private int expected_delivery_type;    0）未知 1）立即 2）1～3天 3）3～5天 4）5～10天 5）10天以上   goodsinfoVo和goodsEditableInfo都加了 @白骁 @卢云


@interface PublishGoodsMoreDetailView : UIView


+ (void)showInView:(PublishGoodsContentView*)contentView;

@end

@interface PriceView : UIView

@property (nonatomic, strong) UITextField *buyPriceFD;
@property (nonatomic, strong) UITextField *sellPriceFD;

@end


@protocol ColourSubViewDelegate <NSObject>

- (void)didSelectColourBtnWithTag:(NSInteger)tag;

@end

@interface ColourSubView : UIView


- (instancetype)initWithFrame:(CGRect)frame andArr:(NSArray *)arr;
//- (void)updateWithArr:(NSArray *)arr;
@property (nonatomic, assign) id<ColourSubViewDelegate>delegate;

@end


@interface ColourView : UIView
@property (nonatomic, strong) UILabel *btnLeftLB;
@property (nonatomic, strong) ColourSubView *selectSubView;
@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, assign) BOOL isShow;  //是否展开
- (instancetype)initWithFrame:(CGRect)frame andSelectArr:(NSArray *)arr;

@end

//渠道来源
@protocol SourceSubViewDelegate <NSObject>

- (void)didSelectSourceViewWithBtn1Tag:(NSInteger)tag1 andBtn2Tag:(NSInteger)tag2;

@end

@interface SourceSubView : UIView

@property (nonatomic, assign) id<SourceSubViewDelegate>delegate;

@end


@interface SourceView : UIView

@property (nonatomic, assign) BOOL isShow;
@property (nonatomic, strong) UIButton *showBtn;
@property (nonatomic, strong) UILabel *btnLeftLB;
@property (nonatomic, strong) SourceSubView *selectSubView;

- (instancetype)initWithFrame:(CGRect)frame andDic:(NSDictionary *)dic;

@end

@interface SegView : UIView



@end




