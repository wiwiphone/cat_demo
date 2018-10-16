//
//  BonusListViewController.h
//  XianMao
//
//  Created by simon on 2/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "SepTableViewCell.h"

@class CommandButton;
@interface BonusListViewController : BaseViewController

@property(nonatomic,strong) NSArray *bonusItems;

@end

@interface BonusListTabBar : UIView

@property(nonatomic,copy) void(^didSelectAtIndex)(NSInteger index);

- (id)initWithFrame:(CGRect)frame tabBtnTitles:(NSArray*)tabBtnTitles;
- (void)setTabAtIndex:(NSInteger)index animated:(BOOL)animated;

@end


@class BonusInfo;

@interface BonusListView : UIView

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type;
- (void)addBonusViaCodeConvert:(BonusInfo*)bonusInfo;
- (void)reloadData;

@end


@class BonusCodeConvertController;


@protocol BonusCodeConvertControllerDelegate <NSObject>
- (void)bonusCodeConvertDidFinish:(BonusCodeConvertController*)viewController bonusInfo:(BonusInfo*)bonusInfo;
@end

@interface BonusCodeConvertController : BaseViewController
@property(nonatomic,assign) id<BonusCodeConvertControllerDelegate> delegate;
@property(nonatomic,copy) NSString *code;
@end

@interface SepTableViewCellBonus : SepTableViewCell
@end

