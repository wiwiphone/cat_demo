//
//  ForumPostDetailViewController.h
//  XianMao
//
//  Created by simon cai on 26/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "ForumTopicVO.h"
#import "DigitalKeyboardView.h"

@class DataListLogic;
@class PullRefreshTableView;
@interface ForumPostDetailViewController : BaseViewController

@property(nonatomic,strong) ForumTopicVO *topicVO;
@property(nonatomic,strong) ForumPostVO *postVO;

@property(nonatomic,assign) NSInteger post_id;

@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property(nonatomic,weak) PullRefreshTableView *tableView;
- (void)initDataListLogic;

@property (nonatomic, assign) BOOL tagYes;
@property (nonatomic, copy) NSString *tag;

@end

//
//forum/post[GET]{post_id} 获取帖子{postVo:(post_id, content, user_id, status, reply_num, is_myself, timestmap, topReplies[], attachment)}


@interface ForumQuoteInputView : DigitalInputContainerView

@property(nonatomic,strong) UITextField *textFiled;
@property(nonatomic,assign) NSInteger priceCent;
@property (nonatomic, assign) NSInteger index;

@end
