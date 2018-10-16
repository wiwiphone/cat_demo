//
//  ForumPostCatHouseTopView.h
//  XianMao
//
//  Created by apple on 15/12/28.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ForumTopicVO;

@protocol ForumPostCatHouseTopViewDelegate <NSObject>

@optional
-(void)scrollCollectionViewCell:(ForumTopicVO *)topicVO andIndexPath:(NSIndexPath *)indexPath;

@end

@interface ForumPostCatHouseTopView : UICollectionView

@property (nonatomic, weak) id<ForumPostCatHouseTopViewDelegate> catHouseDelegate;
- (void)reloadData:(NSArray*)array;
- (void)selectAtIndex:(NSInteger)index;
@end
