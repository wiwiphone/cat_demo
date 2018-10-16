//
//  ForumPostCatHouseCell.h
//  XianMao
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ForumPostListViewController.h"

@class ForumTopicVO;
@class DataListLogic;
@class ForumPostListViewControllerTwo;
@interface ForumPostCatHouseVO : NSObject

@property(nonatomic,strong) ForumTopicVO *topicVO;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property(nonatomic,strong) NSMutableArray *dataSources;
@end




@interface ForumPostCatHouseCell : UICollectionViewCell

- (void)updateWithTopic:(ForumPostCatHouseVO*)catHouseVO;

@end

@interface ForumPostListViewControllerTwo : ForumPostListViewController

@property (nonatomic, assign) NSInteger index;

@end
