//
//  ForumAttachView.h
//  XianMao
//
//  Created by simon cai on 29/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Command.h"
#import "ForumTopicVO.h"

@interface ForumAttachContainerView : UIView

@property(nonatomic,readonly) NSArray *attachments;
- (void)attachItem:(ForumAttachmentVO*)attachVO;
- (void)clear;

@end


@interface ForumAttachmentView : TapDetectingView

@property(nonatomic,strong) ForumAttachmentVO *attachmentVO;
@property(nonatomic,copy) void(^handleDeleteAttachmentBlock)(ForumAttachmentView* itemView);

- (id)initWithFrame:(CGRect)frame itemVO:(ForumAttachmentVO*)attachmentVO;
- (id)initWithFrame:(CGRect)frame itemVO:(ForumAttachmentVO*)attachmentVO isShowDelBtn:(BOOL)isShowDelBtn;
+ (ForumAttachmentView*)createAttachView:(ForumAttachmentVO*)attachmentVO;

@end

@interface ForumAttachmentViewGoods : ForumAttachmentView

@end

@interface ForumAttachmentViewRemindUpgrade : ForumAttachmentView

@end



@interface ForumReplyAttachContainerView : UIView
- (void)updateAttachReplyView:(NSArray*)attachments;
@end


