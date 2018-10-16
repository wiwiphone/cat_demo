//
//  ForumOneSelfController.h
//  XianMao
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "ForumTopicVO.h"

@interface ForumOneSelfController : BaseViewController

//@property(nonatomic,assign) NSInteger topic_id;
@property(nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) ForumPostVO *postVO;
@property(nonatomic,strong) ForumTopicVO *topicVO;

@property (nonatomic, assign) BOOL tagYes;
@property (nonatomic, copy) NSString *tag;

@end


@interface ForumOneSelfPopupView : UIImageView

@property(nonatomic,copy) void(^handleFilterSelectedBlock)(ForumOneSelfPopupView *view,ForumTopicFilterVO *filterVO);
- (void)updateWithFilterList:(NSArray*)filterList selectedFilterVO:(ForumTopicFilterVO*)selectedFilterVO;


@end

