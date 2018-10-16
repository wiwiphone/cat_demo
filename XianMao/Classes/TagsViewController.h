//
//  TagsViewController.h
//  XianMao
//
//  Created by simon cai on 7/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "BaseTableViewCell.h"
#import "Command.h"
#import "TagVo.h"

@interface TagsViewController : BaseViewController

@property(nonatomic,assign) NSInteger category_id;
@property(nonatomic,strong) NSArray *tagGroupList;
@property(nonatomic,copy) void(^handleTagsListFetchedBlock)(NSArray *tagGroupList);
@property(nonatomic,copy) void(^handleTagsDidSelectBlock)();

@end


@class TagButton;
@interface TagsTableViewCell : BaseTableViewCell

@property(nonatomic,copy) void(^handleTagButtonClickedBlock)(TagButton *sender);

+ (NSMutableDictionary*)buildCellDict:(TagGroupVo*)tagGroupVo;

@end



@interface TagButton : CommandButton
@property(nonatomic,strong) NSObject *tagVo;

+ (NSInteger)tagHeight;
+ (TagButton*)createTagButton:(NSObject*)tagVo;
- (void)updateWith:(NSObject*)tagVo;
- (void)bringMySelfToFront;

@end





