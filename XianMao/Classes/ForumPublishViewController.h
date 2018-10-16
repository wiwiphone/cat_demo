//
//  ForumPublishViewController.h
//  XianMao
//
//  Created by simon cai on 21/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "ForumTopicVO.h"

@interface ForumPublishViewController : BaseViewController

@property(nonatomic,assign) NSInteger topic_id;
@property(nonatomic,copy) void(^handlePublishedBlock)(ForumPostVO *postVO);
@property (nonatomic, strong) NSArray *topic_array;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) NSString *prompt;

@end

@interface TopicSelectButton : UIButton

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) int serNum;
@property (nonatomic, weak) UIImageView *closeIcon;
@end