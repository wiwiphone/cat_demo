//
//  ForumPoatCatHouseControllerTwo.h
//  XianMao
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "Command.h"
//@protocol ForumPoatCatHouseControllerTwoDele <NSObject>
//
//<#methods#>
//
//@end

@class ForumPostCatHouseTopView;
@class ForumTopicVO;

//@protocol ForumPoatCatHouseControllerTwoDelegate <NSObject>
//
//@optional
//-(void)backTopMethod;
//
//@end

@interface ForumPoatCatHouseControllerTwo : BaseViewController

@property(nonatomic,weak) UICollectionView *collectionView;
@property(nonatomic,weak) ForumPostCatHouseTopView *topCollectionView;
@property (nonatomic, assign) NSInteger topic_id;
@property (nonatomic, weak) CommandButton *iconButton;
@property (nonatomic, weak) CommandButton *cammerButton;
//@property (nonatomic, weak) id<ForumPoatCatHouseControllerTwoDelegate> delegateCatHouse;

@end
