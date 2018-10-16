//
//  ForumPostTableViewCell.h
//  XianMao
//
//  Created by simon cai on 26/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MLEmojiLabel.h"
#import "ForumTopicVO.h"

@interface ForumTopicDescTableViewCell : BaseTableViewCell
+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(NSString*)topicText;
@end

@interface ForumPostTableViewCell : BaseTableViewCell

+ (void)forumCleanup;
+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO;
+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO forumTopicVO:(ForumTopicVO*)forumTopicVO;
+ (NSString*)cellKeyForPostVO;
- (void)updateCellWithDict:(NSDictionary*)dict forumTopicVO:(ForumTopicVO*)forumTopicVO;

//-(void)setSubsDataWithList:(ForumPostList *)postList;

+ (BOOL)hasShowMoreOprationView;

@property (nonatomic, strong) NSArray *statusVoList;
@property(nonatomic,strong) ForumPostVO *postVO;
@property(nonatomic,copy) void(^handleDelPostBlock)(ForumPostVO *postVO);
@property(nonatomic,copy) void(^handleFinishPostBlock)(ForumPostVO *postVO);
@property(nonatomic,copy) void(^handleReplyBlock)(ForumPostVO *postVO);
@property(nonatomic,copy) void(^handleReplyToBlock)(ForumPostVO *postVO, ForumPostReplyVO *replyVO);
@property(nonatomic,copy) void(^handleAllRepliesBlock)(ForumPostVO *postVO);
@property(nonatomic,copy) void(^handleDeleteReplyBlock)(ForumPostVO *postVO, ForumPostReplyVO *replyVO);
@property(nonatomic,copy) void(^handlePostPicsTapBlock)(ForumPostVO *postVO, NSInteger index, UIImageView *srcImageView, NSArray *imageViewArray);
@property(nonatomic,copy) void(^handleQuoteBlock)(ForumPostVO *postVO);

@property(nonatomic,copy) void(^handleLikeBlock)(ForumPostVO *postVO, NSInteger like);
@property (nonatomic, copy) void(^handleShareBlock)(ForumPostVO *postVO);
@property (nonatomic,copy) void(^handleIconBlock)(ForumPostVO *postVO);
@property (nonatomic,copy) void(^handlePayBlock)(ForumPostVO *postVO, NSInteger fans);
@property (nonatomic,copy) void(^handleTagBlock)(NSString *tagText);

@property (nonatomic,copy) void(^handleTagNameBtnBlock)(NSInteger topic_id);


@end


@interface FroumCatDetailCell : ForumPostTableViewCell

@property (nonatomic, assign) NSInteger isLike;
@property (nonatomic, assign) NSInteger fans;

@end


@interface ForumCatDetailTableViewCell : ForumPostTableViewCell
@end


@interface ForumPostTableViewCellWithReply : ForumPostTableViewCell



@end

@class CommandButton;
@interface ForumPostCatHouseTableViewCell : ForumPostTableViewCellWithReply

@property (nonatomic, assign) NSInteger isLike;
@property (nonatomic, assign) NSInteger fans;
@property (nonatomic, strong) CommandButton *payBtn;

@end

@interface ForumOneSelfTableViewCell : ForumPostCatHouseTableViewCell

@property (nonatomic,copy) void(^handleCammerBlock)(ForumTopicVO *topicVO);

@end

@interface ForumPostTableSepCell : BaseTableViewCell
+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
@end

@interface ForumPostReplyTableTopCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict;
+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO;
@end

@interface ForumPostNoReplyTableCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict;
+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO;
@end

@class TapDetectingMLEmojiLabel;
@interface ForumPostReplyTableCell : BaseTableViewCell

@property(nonatomic,copy) void(^handleDeleteReplyBlock)(ForumPostVO *postVO, ForumPostReplyVO *replyVO);

+ (MLEmojiLabel*)replySizeLabel;
+ (TapDetectingMLEmojiLabel*)createReplyLbl;
+ (void)replyCleanup;

+ (NSDictionary*)buildCellDict:(ForumPostReplyVO*)replyVO  needShowTopSep:(BOOL)needShowTopSep;
+ (NSString*)cellKeyForReplyVO;
+(CGFloat)heightForReplyContent:(ForumPostReplyVO *)replyVO;

- (void)updateCellWithDict:(NSDictionary*)dict postVO:(ForumPostVO*)postVO;
@end



@interface TapDetectingMLEmojiLabel : MLEmojiLabel
@property(nonatomic,copy) void(^handleSingleTapDetected)(TapDetectingMLEmojiLabel *view);
@property(nonatomic,copy) void(^handleCopyMenuItemClicked)(TapDetectingMLEmojiLabel *view);
@property(nonatomic,copy) void(^handleDeleteMenuItemClicked)(TapDetectingMLEmojiLabel *view);
@property(nonatomic,assign) BOOL isShowDelMenuItem;
@property(nonatomic,strong) ForumPostReplyVO *replyVO;
@end


@interface ForumPostAttachmentPicsView : UIView

+ (CGFloat)rowHeightForPortrait:(NSArray*)attachments;
- (void)updateWithAttachmentPics:(NSArray*)attachments;

@property(nonatomic,copy) void(^handleSingleTapDetected)(NSInteger index, UIImageView *srcImageView, NSArray *imageViewArray);

@end




@interface ForumPostMoreOprationView : UIView

@property(nonatomic,copy) void(^handleQuoteBlock)();
@property(nonatomic,copy) void(^handleReplyBlock)();

@end


@interface ForumPostSearchTableCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict;

@property(nonatomic,copy) void(^handlePostDoSearch)(NSString *keywords);
@property(nonatomic,copy) void(^handlePostCancelSearch)();


@end


@interface ForumOneSelfTodayCell : ForumPostSearchTableCell



@end


@interface ForumPostListNoContentTableCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict:(CGFloat)cellHeight;

@end




