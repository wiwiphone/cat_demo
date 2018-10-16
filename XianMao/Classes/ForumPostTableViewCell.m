//
//  ForumPostTableViewCell.m
//  XianMao
//
//  Created by simon cai on 26/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ForumPostTableViewCell.h"
#import "Command.h"
#import "NSDate+Category.h"

#import "Session.h"
#import "URLScheme.h"
#import "ForumAttachView.h"

#import "ForumService.h"

#import "Constants.h"

#import "Masonry.h"

//[附件]

@implementation TapDetectingMLEmojiLabel {
    UILongPressGestureRecognizer * _longPressGesture;
}

- (void)dealloc
{
    _handleSingleTapDetected = nil;
    _handleCopyMenuItemClicked = nil;
    _handleDeleteMenuItemClicked = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (gestureRecognizer==_longPressGesture) {
        return YES;
    }
    return NO;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (action == @selector(handleCopy:)||action == @selector(handleDelete:)) {
        return YES;
    }
    return NO;
}

- (BOOL)canBecomeFirstResponder{
    return YES;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.activeLink) {
        [super touchesEnded:touches withEvent:event];
    } else {
        if (_handleSingleTapDetected) {
            _handleSingleTapDetected(self);
        } else {
            [super touchesEnded:touches withEvent:event];
        }
    }
}

- (void)handleCopy:(id)sender
{
    if ( self.replyVO && [self.replyVO.content length]>0) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.replyVO.content;
    }
    
    if (_handleCopyMenuItemClicked) {
        _handleCopyMenuItemClicked(self);
    }
}

- (void)handleDelete:(id)sender
{
    if (_handleDeleteMenuItemClicked) {
        _handleDeleteMenuItemClicked(self);
    }
}

- (void)handleLongPress:(UIGestureRecognizer *)recognizer{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.backgroundColor = [UIColor colorWithHexString:@"e0e0e0"];
        [self becomeFirstResponder];
        CGRect frame = self.frame;
        frame.origin.y += 15;
        UIMenuItem *copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(handleCopy:)];
        UIMenuItem *delItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(handleDelete:)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        if (_isShowDelMenuItem) {
            [menu setMenuItems:[NSArray arrayWithObjects:copy,delItem, nil]];
        } else {
            [menu setMenuItems:[NSArray arrayWithObjects:copy, nil]];
        }
        [menu setTargetRect:frame inView:self.superview];
        [menu setMenuVisible:YES animated:YES];
    }
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        
        UILongPressGestureRecognizer * longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        [self addGestureRecognizer:longPressGesture];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuControllerDidHideMenuNotification) name:UIMenuControllerDidHideMenuNotification object:nil];
    }
    return self;
}

- (void)handleMenuControllerDidHideMenuNotification {
    self.backgroundColor = [UIColor clearColor];
}

@end

@implementation ForumPostTableSepCell {
    CALayer *_line;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostTableSepCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 2;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    return [self rowHeightForPortrait];
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostTableSepCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        // Initialization code
        _line = [CALayer layer];
        _line.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.contentView.layer addSublayer:_line];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _line.frame = CGRectMake(0, self.contentView.height-0.5, self.contentView.width, 0.5f);
}

@end


@implementation ForumTopicDescTableViewCell {
    UILabel *_lbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumTopicDescTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 0;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    return [self rowHeightForPortrait];
}

+ (NSMutableDictionary*)buildCellDict:(NSString*)topicText
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumTopicDescTableViewCell class]];
    if (topicText)[dict setObject:topicText forKey:@"topicText"];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        // Initialization code
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 34)];
        lbl.textColor = [UIColor whiteColor];
        lbl.textAlignment = NSTextAlignmentCenter;
        lbl.font = [UIFont systemFontOfSize:14.f];
        lbl.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
        [self.contentView addSubview:lbl];
        _lbl = lbl;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _lbl.frame = self.bounds;
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    NSString *topicText = [dict stringValueForKey:@"topicText"];
    _lbl.text = topicText;
    _lbl.hidden = YES;
    [self setNeedsLayout];
}

@end




@interface ForumPostTableViewCell () <MLEmojiLabelDelegate,TTTAttributedLabelDelegate>

@property(nonatomic, weak) MLEmojiLabel *contentLbl;
@property(nonatomic,weak) CommandButton *contentAttachmentsBtn;
@property(nonatomic,strong) NSDataDetector *detector;
@property(nonatomic,strong) NSDataDetector *phoneDetector;
@property(nonatomic,strong) NSArray *urlMatches;
@property(nonatomic,strong) NSArray *phoneMatches;

@property(nonatomic,weak) ForumPostAttachmentPicsView *picsView;

@property(nonatomic,weak) UILabel *timestampLbl;
@property(nonatomic,weak) CommandButton *delBtn;
@property(nonatomic,weak) CommandButton *statusBtn;
@property(nonatomic,weak) CommandButton *replyBtn;

@property(nonatomic,assign) NSInteger is_have_quote;

@property(nonatomic,weak) ForumPostMoreOprationView *moreOprationView;

@end



@implementation ForumPostTableViewCell



+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[self cellKeyForPostVO]];
    if ([postVO isKindOfClass:[ForumPostVO class]]) {
        height += 15;
        CGFloat contentHeight = [self heightForPostContent:postVO.content];
        if (contentHeight>0) {
            height += contentHeight;
            height += 10;
        }
        
        CGFloat picsHeight = 0;
        if ([postVO.attachments count]>0) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:postVO.attachments.count];
            for (ForumAttachmentVO *attchmentVO in postVO.attachments) {
                if (attchmentVO.type == ForumAttachTypePics) {
                    [array addObject:attchmentVO];
                }
            }
            picsHeight = [ForumPostAttachmentPicsView rowHeightForPortrait:array];
            if (picsHeight>0) {
                height += picsHeight;
                height += 10;
            }
            
            if ([array count]!=[postVO.attachments count]) {
                height += 20;
                height += 10;
            }
        }
        
        height += 24; //btns
        height += 5;
    }
    
    return height;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostTableViewCell class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    return dict;
}

+ (NSString*)cellKeyForPostVO {
    return @"postVO";
}

+ (NSString*)cellKeyForForumTopicVO {
    return @"forumTopicVO";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        MLEmojiLabel *contentLbl = [[self class] createContentLbl];
        contentLbl.emojiDelegate = self;
        contentLbl.delegate = self;
        [self.contentView addSubview:contentLbl];
        _contentLbl = contentLbl;
        
        ForumPostAttachmentPicsView *picsView = [[ForumPostAttachmentPicsView alloc] initWithFrame:CGRectZero];
        picsView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:picsView];
        _picsView = picsView;
        
        CommandButton *contentAttachmentsBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [contentAttachmentsBtn setImage:[UIImage imageNamed:@"forum_icon_attach"] forState:UIControlStateNormal];
        [contentAttachmentsBtn setTitle:@"请升级新版本" forState:UIControlStateNormal];
        contentAttachmentsBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [contentAttachmentsBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        _contentAttachmentsBtn = contentAttachmentsBtn;
        [self.contentView addSubview:contentAttachmentsBtn];
        
        _detector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
        _phoneDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypePhoneNumber error:nil];
        
        UIColor *textColor = [UIColor colorWithHexString:@"999999"];
        
        UILabel *timestampLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        timestampLbl.font = [UIFont systemFontOfSize:12.f];
        timestampLbl.textColor = textColor;
        [self.contentView addSubview:timestampLbl];
        _timestampLbl = timestampLbl;
        
        
        CommandButton *delBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [delBtn setTitle:@"删除" forState:UIControlStateNormal];
        [delBtn setTitleColor:textColor forState:UIControlStateNormal];
        delBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [self.contentView addSubview:delBtn];
        _delBtn = delBtn;
        
        CommandButton *statusBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [statusBtn setTitle:@"达成所愿" forState:UIControlStateNormal];
        [statusBtn setTitleColor:textColor forState:UIControlStateNormal];
        [statusBtn setTitleColor:[UIColor colorWithHexString:@"00d424"] forState:UIControlStateDisabled];
        statusBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [statusBtn setImage:[UIImage imageNamed:@"forum_topic_finish"] forState:UIControlStateNormal];
        [statusBtn setImage:[UIImage imageNamed:@"forum_topic_finished_icon"] forState:UIControlStateDisabled];
        [self.contentView addSubview:statusBtn];
        _statusBtn = statusBtn;
        
        CommandButton *replyBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [replyBtn setTitle:@"回复" forState:UIControlStateNormal];
        [replyBtn setTitleColor:textColor forState:UIControlStateNormal];
        replyBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [replyBtn setImage:[UIImage imageNamed:@"forum_topic_comment_icon"] forState:UIControlStateNormal];
        replyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        [self.contentView addSubview:replyBtn];
        _replyBtn = replyBtn;
        
        ForumPostMoreOprationView *moreOprationView = [[ForumPostMoreOprationView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:moreOprationView];
        moreOprationView.hidden = YES;
        _moreOprationView = moreOprationView;
        
        
        WEAKSELF;
        _delBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleDelPostBlock) {
                weakSelf.handleDelPostBlock(weakSelf.postVO);
            }
        };
        _statusBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleFinishPostBlock && !weakSelf.postVO.isFinshed) {
                weakSelf.handleFinishPostBlock(weakSelf.postVO);
            }
        };
        _moreOprationView.handleQuoteBlock = ^() {
            if (weakSelf.handleQuoteBlock) {
                weakSelf.handleQuoteBlock(weakSelf.postVO);
            }
            [weakSelf toggleMoreOprationView:NO sender:weakSelf.replyBtn];
        };
        _moreOprationView.handleReplyBlock = ^() {
            if (weakSelf.handleReplyBlock) {
                weakSelf.handleReplyBlock(weakSelf.postVO);
            }
            [weakSelf toggleMoreOprationView:NO sender:weakSelf.replyBtn];
        };
        _replyBtn.handleClickBlock = ^(CommandButton *sender) {
            NSLog(@"%ld", weakSelf.is_have_quote);
            if (weakSelf.is_have_quote>0) {
                BOOL isShow = [weakSelf.moreOprationView isHidden]?YES:NO;
                [weakSelf toggleMoreOprationView:isShow sender:sender];
            } else {
                if (weakSelf.handleReplyBlock) {
                    weakSelf.handleReplyBlock(weakSelf.postVO);
                }
            }
        };
        
        //
        contentAttachmentsBtn.handleClickBlock = ^(CommandButton *sender) {
            [URLScheme locateWithRedirectUri:APPSTORE_URL andIsShare:YES];
        };
        
        _picsView.handleSingleTapDetected = ^(NSInteger index, UIImageView *srcImageView, NSArray *imageViewArray) {
            if (weakSelf.handlePostPicsTapBlock) {
                weakSelf.handlePostPicsTapBlock(weakSelf.postVO,index,srcImageView,imageViewArray);
            }
        };
        
        
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dismissMoreOprationView:(NSNotification*)notifi {
    [self toggleMoreOprationView:NO sender:_replyBtn];
}

-(UIView *) hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGPoint p = [self convertPoint:point toView:_replyBtn];
    if (CGRectContainsPoint(_replyBtn.bounds, p)) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissMoreOprationViewForumPost" object:nil];
        return [super hitTest:point withEvent:event];
    }
    
    if (![_moreOprationView isHidden]) {
        p = [self convertPoint:point toView:_moreOprationView];
        if (self.is_have_quote && CGRectContainsPoint(_moreOprationView.bounds, p)) {
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"dismissMoreOprationViewForumPost" object:nil];
            return [super hitTest:point withEvent:event];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissMoreOprationViewForumPost" object:nil];
        }
    }
    
    
    //override hitTest to give swipe buttons a higher priority (diclosure buttons can steal input)
    return [super hitTest:point withEvent:event];
}

static bool hasShowMoreOprationView = NO;
+ (BOOL)hasShowMoreOprationView {
    return hasShowMoreOprationView;
}

- (void)toggleMoreOprationView:(BOOL)isShow sender:(CommandButton*)sender {
    WEAKSELF;
    if (isShow) {
        if ([weakSelf.moreOprationView isHidden]) {
            [weakSelf.contentView bringSubviewToFront:weakSelf.moreOprationView];
            weakSelf.moreOprationView.frame = CGRectMake(sender.left-5, sender.top-(weakSelf.moreOprationView.height-sender.height)/2, 0, weakSelf.moreOprationView.height);
            weakSelf.moreOprationView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.moreOprationView.frame = CGRectMake(sender.left-5-154, sender.top-(weakSelf.moreOprationView.height-sender.height)/2, 154, weakSelf.moreOprationView.height);
            }];
            
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissMoreOprationView:) name:@"dismissMoreOprationViewForumPost" object:nil];
            hasShowMoreOprationView = YES;
        }
    } else {
        if (![weakSelf.moreOprationView isHidden]) {
            [weakSelf.contentView bringSubviewToFront:weakSelf.moreOprationView];
            [UIView animateWithDuration:0.3 animations:^{
                weakSelf.moreOprationView.frame = CGRectMake(sender.left-5, sender.top-(weakSelf.moreOprationView.height-sender.height)/2, 0, weakSelf.moreOprationView.height);
            } completion:^(BOOL finished) {
                weakSelf.moreOprationView.hidden = YES;
            }];
            [[NSNotificationCenter defaultCenter] removeObserver:self];
            hasShowMoreOprationView = NO;
        }
    }
}

+ (MLEmojiLabel*)createContentLbl {
    MLEmojiLabel *contentLbl = [[MLEmojiLabel alloc]initWithFrame:CGRectZero];
    contentLbl.font = [UIFont systemFontOfSize:14.0f];
    contentLbl.lineBreakMode = NSLineBreakByCharWrapping;
    contentLbl.isNeedAtAndPoundSign = YES;
    contentLbl.numberOfLines = 0;
    
    contentLbl.enabledTextCheckingTypes = NSTextCheckingTypeLink;
    
    contentLbl.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    contentLbl.customEmojiPlistName = @"faceMap_ch.plist";
    [contentLbl setEmojiText:@""];
    return contentLbl;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _contentAttachmentsBtn.hidden = YES;
    _picsView.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginTop = 15;
    CGSize size = [_contentLbl sizeThatFits:CGSizeMake(kScreenWidth-30, CGFLOAT_MAX)];
    if (size.height>0) {
        _contentLbl.frame = CGRectMake(15, marginTop, kScreenWidth-30, size.height+2);
        marginTop += _contentLbl.height;
        marginTop += 10;
    }
    
    if (![_picsView isHidden]) {
        _picsView.frame = CGRectMake(0, marginTop, kScreenWidth, _picsView.height);
        marginTop += _picsView.height;
        marginTop += 10;
    }
    
    if (![_contentAttachmentsBtn isHidden]) {
        [_contentAttachmentsBtn sizeToFit];
        _contentAttachmentsBtn.frame = CGRectMake(15, marginTop, _contentAttachmentsBtn.width, 20);
        marginTop += _contentAttachmentsBtn.height;
        marginTop += 10;
    }
    
    [_timestampLbl sizeToFit];
    _timestampLbl.frame = CGRectMake(15, marginTop, _timestampLbl.width, 24);
    
    [_delBtn sizeToFit];
    _delBtn.frame = CGRectMake(_timestampLbl.right+14, marginTop, _delBtn.width, 24);
    
    if ([Session sharedInstance].currentUserId==_postVO.user_id) {
        
        if (_postVO.isFinshed) {
             _delBtn.hidden = YES;
            _statusBtn.hidden = NO;
            _statusBtn.enabled = NO;
            _replyBtn.hidden = YES;
            [_statusBtn sizeToFit];
            _statusBtn.frame = CGRectMake(self.contentView.width-15-_statusBtn.width, marginTop, _statusBtn.width, 24);
        } else {
             _delBtn.hidden = NO;
            _statusBtn.hidden = NO;
            _statusBtn.enabled = YES;
            _replyBtn.hidden = NO;
            
            [_replyBtn sizeToFit];
            _replyBtn.frame = CGRectMake(self.contentView.width-15-_replyBtn.width-2, marginTop, _replyBtn.width+2, 24);
            
            [_statusBtn sizeToFit];
            _statusBtn.frame = CGRectMake(_replyBtn.left-15-_statusBtn.width, marginTop, _statusBtn.width, 24);
        }
    } else {
        _delBtn.hidden = YES;
        
        if (_postVO.isFinshed) {
            _statusBtn.hidden = NO;
            _statusBtn.enabled = NO;
            _replyBtn.hidden = YES;
            
            [_statusBtn sizeToFit];
            _statusBtn.frame = CGRectMake(self.contentView.width-15-_statusBtn.width, marginTop, _statusBtn.width, 24);
            
        } else {
            _statusBtn.hidden = YES;
            _replyBtn.hidden = NO;
            
            [_replyBtn sizeToFit];
            _replyBtn.frame = CGRectMake(self.contentView.width-15-_replyBtn.width-2, marginTop, _replyBtn.width+2, 24);
        }
    }
    
    marginTop += 24;
}

- (void)updateCellWithDict:(NSDictionary*)dict forumTopicVO:(ForumTopicVO*)forumTopicVO {
    self.statusVoList = forumTopicVO.statusVoList;
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[[self class] cellKeyForPostVO]];
    if ([postVO isKindOfClass:[ForumPostVO class]]) {
        _postVO = postVO;
        if ([_postVO.attachments count]>0) {
            
        }
        [_contentLbl setEmojiText:postVO.content];
        
        _picsView.hidden = YES;
        _contentAttachmentsBtn.hidden = YES;
        
        if ([postVO.attachments count]>0) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:postVO.attachments.count];
            for (ForumAttachmentVO *attchmentVO in postVO.attachments) {
                if (attchmentVO.type == ForumAttachTypePics) {
                    [array addObject:attchmentVO];
                }
            }
            if ([array count]>0) {
                CGFloat picsHeight = [ForumPostAttachmentPicsView rowHeightForPortrait:array];
                _picsView.frame = CGRectMake(0, _picsView.top, kScreenWidth, picsHeight);
                _picsView.hidden = NO;
                [_picsView updateWithAttachmentPics:array];
            }
            if ([array count]<[postVO.attachments count]) {
                _contentAttachmentsBtn.hidden = NO;
            }
        }
        
        _urlMatches = [_detector matchesInString:postVO.content options:0 range:NSMakeRange(0, postVO.content.length)];
        _phoneMatches = [_phoneDetector matchesInString:postVO.content options:0 range:NSMakeRange(0, postVO.content.length)];
        
        for (ForumPostStatusVo *statusVO in forumTopicVO.statusVoList) {
            if (statusVO.status==postVO.status) {
                [_statusBtn setTitle:statusVO.display forState:UIControlStateNormal];
                break;
            }
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:postVO.timestamp/1000];
        _timestampLbl.text = [date formattedDateDescription];
        
        if ([Session sharedInstance].currentUserId==postVO.user_id && forumTopicVO.statusVoList) {
            
            if (_postVO.isFinshed) {
                _delBtn.hidden = YES;
                _statusBtn.hidden = NO;
                _statusBtn.enabled = NO;
                _replyBtn.hidden = YES;
            } else {
                _delBtn.hidden = NO;
                _statusBtn.hidden = NO;
                _statusBtn.enabled = YES;
                _replyBtn.hidden = NO;
            }
        } else {
            _delBtn.hidden = YES;
            if (postVO.isFinshed) {
                _statusBtn.hidden = NO;
                _statusBtn.enabled = NO;
                _replyBtn.hidden = YES;
            } else {
                _statusBtn.hidden = YES;
                _replyBtn.hidden = NO;
            }
        }
        
        self.is_have_quote = forumTopicVO.is_have_quote;
        
        if (forumTopicVO.is_have_quote>0) {
            [_replyBtn setTitle:nil forState:UIControlStateNormal];
            [_replyBtn setImage:[UIImage imageNamed:@"forum_icon_more"] forState:UIControlStateNormal];
            _replyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            [_replyBtn setTitle:@"" forState:UIControlStateNormal];
            [_replyBtn setImage:[UIImage imageNamed:@"forum_topic_comment_icon"] forState:UIControlStateNormal];
            _replyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        }
        _moreOprationView.hidden = YES;
        
        [self setNeedsLayout];
    }
}

- (BOOL)isIndex:(CFIndex)index inRange:(NSRange)range
{
    return index > range.location && index < range.location+range.length;
}

- (void)highlightLinksWithIndex:(CFIndex)index {
    
    NSMutableAttributedString* attributedString = [_contentLbl.attributedText mutableCopy];
    
    for (NSTextCheckingResult *match in _urlMatches) {
        
        if ([match resultType] == NSTextCheckingTypeLink ) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:index inRange:matchRange]) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:matchRange];
            }
            else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c7af7a"] range:matchRange];
            }
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    
    for (NSTextCheckingResult *match in _phoneMatches) {
        
        if ( [match resultType] == NSTextCheckingTypePhoneNumber) {
            
            NSRange matchRange = [match range];
            
            if ([self isIndex:index inRange:matchRange]) {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:matchRange];
            }
            else {
                [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c7af7a"] range:matchRange];
            }
            
            [attributedString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:matchRange];
        }
    }
    
    _contentLbl.attributedText = attributedString;
}

- (CFIndex)characterIndexAtPoint:(CGPoint)point
{
    NSMutableAttributedString* optimizedAttributedText = [_contentLbl.attributedText mutableCopy];
    
    // use label's font and lineBreakMode properties in case the attributedText does not contain such attributes
    [_contentLbl.attributedText enumerateAttributesInRange:NSMakeRange(0, [_contentLbl.attributedText length]) options:0 usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        
        if (!attrs[(NSString*)kCTFontAttributeName])
        {
            [optimizedAttributedText addAttribute:(NSString*)kCTFontAttributeName value:_contentLbl.font range:NSMakeRange(0, [_contentLbl.attributedText length])];
        }
        
        if (!attrs[(NSString*)kCTParagraphStyleAttributeName])
        {
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineBreakMode:_contentLbl.lineBreakMode];
            
            [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
        }
    }];
    
    // modify kCTLineBreakByTruncatingTail lineBreakMode to kCTLineBreakByWordWrapping
    [optimizedAttributedText enumerateAttribute:(NSString*)kCTParagraphStyleAttributeName inRange:NSMakeRange(0, [optimizedAttributedText length]) options:0 usingBlock:^(id value, NSRange range, BOOL *stop)
     {
         NSMutableParagraphStyle* paragraphStyle = [value mutableCopy];
         
         if ([paragraphStyle lineBreakMode] == NSLineBreakByTruncatingTail) {
             [paragraphStyle setLineBreakMode:NSLineBreakByWordWrapping];
         }
         
         [optimizedAttributedText removeAttribute:(NSString*)kCTParagraphStyleAttributeName range:range];
         [optimizedAttributedText addAttribute:(NSString*)kCTParagraphStyleAttributeName value:paragraphStyle range:range];
     }];
    
    if (!CGRectContainsPoint(self.bounds, point)) {
        return NSNotFound;
    }
    
    CGRect textRect = _contentLbl.frame;
    
    if (!CGRectContainsPoint(textRect, point)) {
        return NSNotFound;
    }
    
    // Offset tap coordinates by textRect origin to make them relative to the origin of frame
    point = CGPointMake(point.x - textRect.origin.x, point.y - textRect.origin.y);
    // Convert tap coordinates (start at top left) to CT coordinates (start at bottom left)
    point = CGPointMake(point.x, textRect.size.height - point.y);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)optimizedAttributedText);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, textRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, [_contentLbl.attributedText length]), path, NULL);
    
    if (frame == NULL) {
        CFRelease(path);
        return NSNotFound;
    }
    
    CFArrayRef lines = CTFrameGetLines(frame);
    
    NSInteger numberOfLines = _contentLbl.numberOfLines > 0 ? MIN(_contentLbl.numberOfLines, CFArrayGetCount(lines)) : CFArrayGetCount(lines);
    
    if (numberOfLines == 0) {
        CFRelease(frame);
        CFRelease(path);
        return NSNotFound;
    }
    
    NSUInteger idx = NSNotFound;
    
    CGPoint lineOrigins[numberOfLines];
    CTFrameGetLineOrigins(frame, CFRangeMake(0, numberOfLines), lineOrigins);
    
    for (CFIndex lineIndex = 0; lineIndex < numberOfLines; lineIndex++) {
        
        CGPoint lineOrigin = lineOrigins[lineIndex];
        CTLineRef line = CFArrayGetValueAtIndex(lines, lineIndex);
        
        // Get bounding information of line
        
        
        CGFloat ascent, descent, leading, width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        CGFloat yMin = floor(lineOrigin.y - descent);
        CGFloat yMax = ceil(lineOrigin.y + ascent);
        
        // Check if we've already passed the line
        if (point.y > yMax) {
            break;
        }
        
        // Check if the point is within this line vertically
        if (point.y >= yMin) {
            
            // Check if the point is within this line horizontally
            if (point.x >= lineOrigin.x && point.x <= lineOrigin.x + width) {
                
                // Convert CT coordinates to line-relative coordinates
                CGPoint relativePoint = CGPointMake(point.x - lineOrigin.x, point.y - lineOrigin.y);
                idx = CTLineGetStringIndexForPosition(line, relativePoint);
                
                break;
            }
        }
    }
    
    CFRelease(frame);
    CFRelease(path);
    
    return idx;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [URLScheme locateWithRedirectUri:[url absoluteString] andIsShare:YES];
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    
}

static MLEmojiLabel *g_forumSizeLabel = nil;

+ (MLEmojiLabel*)forumSizeLabel {
    if (!g_forumSizeLabel) {
        g_forumSizeLabel = [self createContentLbl];
    }
    return g_forumSizeLabel;
}

+ (void)forumCleanup {
    g_forumSizeLabel = nil;
}

+(CGFloat)heightForPostContent:(NSString *)content
{
    if ([content length]>0) {
        MLEmojiLabel *label = [self forumSizeLabel];
        label.frame = CGRectMake(15, 0, kScreenWidth-30-40-15, 0);
        [label setEmojiText:content];
        CGSize size = [label sizeThatFits:CGSizeMake(kScreenWidth-30-40-15, CGFLOAT_MAX)];
        return size.height+4;
    } else {
        return 0;
    }
}



@end


@interface FroumCatDetailCell ()

@property (nonatomic, strong) CommandButton *iconButton;
@property (nonatomic, strong) UILabel *namesLabel;
@property (nonatomic, strong) CommandButton *shareBtn;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) CommandButton *supprotBtn;
@property (nonatomic, strong) UILabel *supportLabel;
@property (nonatomic, strong) CommandButton *payBtn;
@property (nonatomic, strong) CommandButton *topicNameBtn;

@property (nonatomic, strong) NSArray *tagArr;

@property (nonatomic, strong) CommandButton *tag1;
@property (nonatomic, strong) CommandButton *tag2;
@property (nonatomic, strong) CommandButton *tag3;
@property (nonatomic, strong) UIView *tagBackView;
@end

@implementation FroumCatDetailCell

-(UIView *)tagBackView{
    if (!_tagBackView) {
        _tagBackView = [[UIView alloc] initWithFrame:CGRectZero];
        //        _tagBackView.backgroundColor = [UIColor orangeColor];
    }
    return _tagBackView;
}

-(CommandButton *)tag3{
    if (!_tag3) {
        _tag3 = [[CommandButton alloc] initWithFrame:CGRectZero];
        _tag3.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tag3;
}

-(CommandButton *)tag2{
    if (!_tag2) {
        _tag2 = [[CommandButton alloc] initWithFrame:CGRectZero];
        _tag2.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tag2;
}

-(CommandButton *)tag1{
    if (!_tag1) {
        _tag1 = [[CommandButton alloc] initWithFrame:CGRectZero];
        _tag1.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tag1;
}

-(CommandButton *)topicNameBtn{
    if (!_topicNameBtn) {
        _topicNameBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        //        _topicNameBtn.backgroundColor = [UIColor orangeColor];
        //        _topicNameBtn.layer.masksToBounds = YES;
        //        _topicNameBtn.layer.cornerRadius = 10;
        [_topicNameBtn setTitleColor:[UIColor colorWithRed:215/255.f green:172/255.f blue:87/255.f alpha:1] forState:UIControlStateNormal];
        _topicNameBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        _topicNameBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _topicNameBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _topicNameBtn;
}

-(CommandButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _payBtn.backgroundColor = [UIColor whiteColor];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"pay-N"] forState:UIControlStateNormal];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"pay-S"] forState:UIControlStateSelected];
    }
    return _payBtn;
}

-(CommandButton *)iconButton{
    if (!_iconButton) {
        _iconButton = [[CommandButton alloc] initWithFrame:CGRectZero];
        _iconButton.layer.masksToBounds = YES;
        _iconButton.layer.cornerRadius = 20;
        [_iconButton setImage:[UIImage imageNamed:@"placeholder_mine.png"] forState:UIControlStateNormal];
        
    }
    return _iconButton;
}

-(UILabel *)namesLabel{
    if (!_namesLabel) {
        _namesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
    }
    return _namesLabel;
}

-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_shareBtn setImage:[UIImage imageNamed:@"share-MF"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

-(UILabel *)replyLabel{
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyLabel.text = @"14";
        _replyLabel.textColor = [UIColor grayColor];
        _replyLabel.font = [UIFont systemFontOfSize:14];
    }
    return _replyLabel;
}

-(CommandButton *)supprotBtn{
    if (!_supprotBtn) {
        _supprotBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_supprotBtn setImage:[UIImage imageNamed:@"mine_likes"] forState:UIControlStateNormal];
        [_supprotBtn setImage:[UIImage imageNamed:@"mine_like_S"] forState:UIControlStateSelected];
    }
    return _supprotBtn;
}

-(UILabel *)supportLabel{
    if (!_supportLabel) {
        _supportLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _supportLabel.text = @"800";
        _supportLabel.font = [UIFont systemFontOfSize:14];
        _supportLabel.textColor = [UIColor grayColor];
    }
    return _supportLabel;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0 + 40;
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[self cellKeyForPostVO]];
    if ([postVO isKindOfClass:[ForumPostVO class]]) {
        height += 15;
        CGFloat contentHeight = [self heightForPostContent:postVO.content];
        if (contentHeight>0) {
            height += contentHeight;
            height += 10;
        }
        
        CGFloat picsHeight = 0;
        if ([postVO.attachments count]>0) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:postVO.attachments.count];
            for (ForumAttachmentVO *attchmentVO in postVO.attachments) {
                if (attchmentVO.type == ForumAttachTypePics) {
                    [array addObject:attchmentVO];
                }
            }
            picsHeight = [ForumPostAttachmentPicsView rowHeightForPortrait:array];
            if (picsHeight>0) {
                height += picsHeight;
                height += 10;
            }
            
            if ([array count]!=[postVO.attachments count]) {
                height += 20;
                height += 10;
            }
        }
        
        height += 24; //btns
        height += 5;
    }
    
    return height;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[FroumCatDetailCell class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    return dict;
}

+ (NSString*)cellKeyForPostVO {
    return @"postVO";
}

+ (NSString*)cellKeyForForumTopicVO {
    return @"forumTopicVO";
}

//+(CGFloat)heightForPostContent:(NSString *)content
//{
//    if ([content length]>0) {
//        MLEmojiLabel *label = [self forumSizeLabel];
//        label.frame = CGRectMake(15, 0, kScreenWidth-30, 0);
//        [label setEmojiText:content];
//        CGSize size = [label sizeThatFits:CGSizeMake(kScreenWidth-30, CGFLOAT_MAX)];
//        return size.height+4;
//    } else {
//        return 0;
//    }
//}

//static MLEmojiLabel *g_forumSizeLabel = nil;
//+ (MLEmojiLabel*)forumSizeLabel {
//    if (!g_forumSizeLabel) {
//        g_forumSizeLabel = [self createContentLbl];
//    }
//    return g_forumSizeLabel;
//}
//
//+ (MLEmojiLabel*)createContentLbl {
//    MLEmojiLabel *contentLbl = [[MLEmojiLabel alloc]initWithFrame:CGRectZero];
//    contentLbl.font = [UIFont systemFontOfSize:14.0f];
//    contentLbl.lineBreakMode = NSLineBreakByCharWrapping;
//    contentLbl.isNeedAtAndPoundSign = YES;
//    contentLbl.numberOfLines = 0;
//    
//    contentLbl.enabledTextCheckingTypes = NSTextCheckingTypeLink;
//    
//    contentLbl.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
//    contentLbl.customEmojiPlistName = @"faceMap_ch.plist";
//    [contentLbl setEmojiText:@""];
//    return contentLbl;
//}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconButton];
        [self.contentView addSubview:self.namesLabel];
        [self.contentView addSubview:self.shareBtn];
        [self.contentView addSubview:self.replyLabel];
        [self.contentView addSubview:self.supprotBtn];
        [self.contentView addSubview:self.supportLabel];
        [self.contentView addSubview:self.payBtn];
        [self.contentView addSubview:self.topicNameBtn];
        
        [self.contentView addSubview:self.tagBackView];
        [self.tagBackView addSubview:self.tag1];
        [self.tagBackView addSubview:self.tag2];
        [self.tagBackView addSubview:self.tag3];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    CGFloat margin = 10;
    CGFloat left = 15;
    self.iconButton.frame = CGRectMake(left, margin, 40, 40);
    
    
//    CGFloat marginTop = self.delBtn.bottom;
    
    CGFloat marginTops = 15;
    CGSize size = [self.contentLbl sizeThatFits:CGSizeMake(kScreenWidth-30-self.iconButton.width-15, CGFLOAT_MAX)];
    if (size.height>0) {
        self.contentLbl.frame = CGRectMake(67, marginTops + 15, kScreenWidth-30-self.iconButton.width-15, size.height+2);
        marginTops += self.contentLbl.height;
        marginTops += 10;
    }
    
    if (!size.height>0) {
        marginTops += 10;
    }
    
    if (![self.picsView isHidden]) {
        self.picsView.frame = CGRectMake(50, marginTops + 10, kScreenWidth, self.picsView.height);
        marginTops += self.picsView.height;
        marginTops += 10;
    }
    
    if (![self.contentAttachmentsBtn isHidden]) {
        [self.contentAttachmentsBtn sizeToFit];
        self.contentAttachmentsBtn.frame = CGRectMake(15, marginTops, self.contentAttachmentsBtn.width, 20);
        marginTops += self.contentAttachmentsBtn.height;
        marginTops += 10;
    }
    
    [self.timestampLbl sizeToFit];
    self.timestampLbl.frame = CGRectMake(15 + self.iconButton.width + 11, marginTops + 40, self.timestampLbl.width, 24);
    self.topicNameBtn.frame = CGRectMake(15 + self.iconButton.width + 10, marginTops + 13, 44, 20);
    [self.topicNameBtn setTitle:self.postVO.topic_name forState:UIControlStateNormal];
    self.topicNameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.tagBackView.frame = CGRectMake(15 + self.iconButton.width + 15 + 42, marginTops + 13, kScreenWidth - (15 + self.iconButton.width + 15 + 72), 20);
    
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    self.tag3.hidden = YES;
    
    
    if (self.postVO.forum_tag.length > 0) {
        NSString *tagStr = [self.postVO.forum_tag substringWithRange:NSMakeRange(2, self.postVO.forum_tag.length - 4)];
        NSLog(@"%@", tagStr);
        NSArray *tagArr = [tagStr componentsSeparatedByString:@"\",\""]; //componentsSeparatedByString:
        NSLog(@"%@", tagArr);
        self.tagArr = tagArr;
        
        if (self.tagArr.count == 1) {
            self.tag1.hidden = NO;
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
        }
        
        if (tagArr.count == 2) {
            
            self.tag1.hidden = NO;
            [self.tag1 sizeToFit];
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
            
            self.tag2.hidden = NO;
            [self.tag2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag2.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag2 sizeToFit];
            NSString *tag2 = tagArr[1];
            [self.tag2 setTitle:tag2 forState:UIControlStateNormal];
            self.tag2.frame = CGRectMake(0 + self.tag1.width + 10, 0, self.tag2.width, 20);
        }
        
        if (tagArr.count == 3) {
            
            self.tag1.hidden = NO;
            [self.tag1 sizeToFit];
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
            
            self.tag2.hidden = NO;
            [self.tag2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag2.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag2 sizeToFit];
            NSString *tag2 = tagArr[1];
            [self.tag2 setTitle:tag2 forState:UIControlStateNormal];
            self.tag2.frame = CGRectMake(0 + self.tag1.width + 10, 0, self.tag2.width, 20);
            
            self.tag3.hidden = NO;
            [self.tag3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag3.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag3 sizeToFit];
            NSString *tag3 = tagArr[2];
            [self.tag3 setTitle:tag3 forState:UIControlStateNormal];
            self.tag3.frame = CGRectMake(0 + self.tag1.width + self.tag2.width + 10 * 2, 0, self.tag3.width, 20);
            
        }
        //        }
        
    } else {
        self.tag1.hidden = YES;
        self.tag2.hidden = YES;
        self.tag3.hidden = YES;
    }
    
    if ([Session sharedInstance].currentUserId==self.postVO.user_id) {
        
        if (self.postVO.isFinshed) {
            self.delBtn.hidden = YES;
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = NO;
            self.replyBtn.hidden = YES;
            self.shareBtn.hidden = YES;
            self.supprotBtn.hidden = YES;
            self.supportLabel.hidden = YES;
            self.replyLabel.hidden = YES;
            
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-15-self.statusBtn.width, marginTops + 40, self.statusBtn.width, 24);
            
        } else {
            self.delBtn.hidden = NO;
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = YES;
            self.replyBtn.hidden = NO;
            self.replyLabel.hidden = NO;
            self.shareBtn.hidden = NO;
            self.supportLabel.hidden = NO;
            self.supprotBtn.hidden = NO;
            
            [self.replyBtn sizeToFit];
            if (kScreenWidth == 320) {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-40, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-40, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-30-45-15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-27-self.replyBtn.width, marginTops + 42, 30, 18);
            } else {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-50, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width -15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50-45 - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-47-self.replyBtn.width, marginTops + 42, 30, 18);
            }
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-self.statusBtn.width - 15, margin, self.statusBtn.width, 24);
        }
        
        
    } else {
        self.delBtn.hidden = YES;
        
        if (self.postVO.isFinshed) {
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = NO;
            self.replyBtn.hidden = YES;
            self.shareBtn.hidden = YES;
            self.supprotBtn.hidden = YES;
            self.supportLabel.hidden = YES;
            self.replyLabel.hidden = YES;
            
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-15-self.statusBtn.width, marginTops + 40, self.statusBtn.width, 24);
            
        } else {
            self.statusBtn.hidden = YES;
            self.replyBtn.hidden = NO;
            self.replyLabel.hidden = NO;
            self.shareBtn.hidden = NO;
            self.supportLabel.hidden = NO;
            self.supprotBtn.hidden = NO;
            
            [self.replyBtn sizeToFit];
            if (kScreenWidth == 320) {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-40, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-40, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-30-45-15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-27-self.replyBtn.width, marginTops + 42, 30, 18);
            } else {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-50, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width -15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50-45 - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-47-self.replyBtn.width, marginTops + 42, 30, 18);
            }
        }
        
        //        if (self.statusVoList) {
        //            self.statusBtn.hidden = NO;
        //        } else {
        //            self.statusBtn.hidden = YES;
        //        }
    }
    [self.delBtn sizeToFit];
    if (kScreenWidth == 320) {
        self.delBtn.frame = CGRectMake(self.supprotBtn.left - 20, marginTops + 40, self.delBtn.width, 24);
    } else {
        self.delBtn.frame = CGRectMake(self.supprotBtn.left - 40, marginTops + 40, self.delBtn.width, 24);
    }
    
    
    marginTops += 24;
    
    if ([Session sharedInstance].currentUserId==self.postVO.user_id) {
        self.payBtn.hidden = YES;
    } else {
        self.payBtn.hidden = NO;
        [self.payBtn sizeToFit];
        self.payBtn.frame = CGRectMake(self.contentView.width-15-50, margin - 3, 45, 18);
    }
    
    
    self.namesLabel.frame = CGRectMake(left + self.iconButton.width + margin, margin, kScreenWidth - self.iconButton.width - left - margin, 20);
//    self.contentLbl.frame = CGRectMake(left + self.iconButton.width + margin, margin + self.iconButton.height - 20, kScreenWidth - self.iconButton.width - left - margin, size.height+2);
//    self.picsView.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin*2, self.picsView.width, self.picsView.height);
    //    if (self.picsView.height > 1) {
    //        self.timestampLbl.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin * 3 + self.picsView.height, self.timestampLbl.width, self.timestampLbl.height);
    //    } else if (!self.picsView.height < 1) {
    //        self.timestampLbl.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin * 2, self.timestampLbl.width, self.timestampLbl.height);
    //    }
    
    //    self.moreOprationView.frame = CGRectMake(margin, self.timestampLbl.top-(self.moreOprationView.height-self.timestampLbl.height)/2 + 40, 0, self.moreOprationView.height);
    
    
    self.namesLabel.text = self.postVO.username;
    [self.iconButton sd_setImageWithURL:[NSURL URLWithString:self.postVO.avatar] forState:UIControlStateNormal completed:nil];
    
    self.replyLabel.text = [NSString stringWithFormat:@"%ld", self.postVO.reply_num];
    self.supportLabel.text = [NSString stringWithFormat:@"%ld", self.postVO.like_num];
    
    if (self.postVO.is_like == 1) {
        self.supprotBtn.selected = YES;
    } else if (self.postVO.is_like == 0) {
        self.supprotBtn.selected = NO;
    }
    
    if (self.postVO.is_following == 1) {
        self.payBtn.selected = YES;
    } else if (self.postVO.is_following == 0) {
        self.payBtn.selected = NO;
    }
    
    
    WEAKSELF;
    self.supprotBtn.handleClickBlock = ^(CommandButton *sender) {
        if (![Session sharedInstance].isLoggedIn) {
            NSLog(@"弹出登陆框");
            if (weakSelf.handleLikeBlock) {
                weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.postVO.is_like);
            }
            return;
        }
        if (weakSelf.postVO.is_like == 0) {
            
            weakSelf.postVO.is_like = 1;
            weakSelf.supprotBtn.selected = YES;
            weakSelf.postVO.like_num += 1;
            
            if (weakSelf.handleLikeBlock) {
                weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.postVO.is_like);
            }
            
        } else if (weakSelf.postVO.is_like == 1) {
            weakSelf.postVO.is_like = 0;
            weakSelf.supprotBtn.selected = NO;
            weakSelf.postVO.like_num -= 1;
            
            if (weakSelf.handleLikeBlock) {
                weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.postVO.is_like);
            }
        }
        //            else {
        //                if (weakSelf.handleLikeBlock) {
        //                    weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.isLike);
        //                }
        //            }
        NSLog(@"%ld", weakSelf.isLike);
    };
    
    self.tag1.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagBlock) {
            weakSelf.handleTagBlock(weakSelf.tag1.titleLabel.text);
        }
    };
    
    self.tag2.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagBlock) {
            weakSelf.handleTagBlock(weakSelf.tag2.titleLabel.text);
        }
    };
    
    self.tag3.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagBlock) {
            weakSelf.handleTagBlock(weakSelf.tag3.titleLabel.text);
        }
    };
    
    
    self.topicNameBtn.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagNameBtnBlock) {
            weakSelf.handleTagNameBtnBlock(weakSelf.postVO.topic_id);
        }
    };
    
    //帖子的iconButton
    self.iconButton.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleIconBlock) {
            weakSelf.handleIconBlock(weakSelf.postVO);
        }
    };
    
    //    NSInteger fans = 1;
    
    self.payBtn.handleClickBlock = ^(CommandButton *sender) {
        
        NSLog(@"%ld", weakSelf.postVO.is_following);
        
        if (![Session sharedInstance].isLoggedIn) {
            NSLog(@"弹出登陆框");
            if (weakSelf.handlePayBlock) {
                weakSelf.handlePayBlock(weakSelf.postVO, weakSelf.fans);
            }
            return;
        }
        if (weakSelf.postVO.is_following == 0) {
            weakSelf.payBtn.selected = NO;
            weakSelf.postVO.is_following = 1;
            //            weakSelf.fans = 1;
        }else if (weakSelf.postVO.is_following == 1) {
            weakSelf.payBtn.selected = YES;
            weakSelf.postVO.is_following = 0;
            //            weakSelf.fans = 0;
        }
        
        if (weakSelf.handlePayBlock) {
            weakSelf.handlePayBlock(weakSelf.postVO, weakSelf.fans);
        }
        
    };
    
    self.shareBtn.handleClickBlock = ^(CommandButton *sender) {
        if (weakSelf.handleShareBlock) {
            weakSelf.handleShareBlock(weakSelf.postVO);
        }
    };

    
}

@end




@interface ForumCatDetailTableViewCell ()

@property (nonatomic, strong) CommandButton *iconButton;
@property (nonatomic, strong) UILabel *namesLabel;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) UIButton *supprotBtn;
@property (nonatomic, strong) UILabel *supportLabel;
@property (nonatomic, strong) CommandButton *payBtn;
//@property (nonatomic, strong) CommandButton *topicNameBtn;

@property (nonatomic, strong) NSArray *tagArr;

@property (nonatomic, strong) UIButton *tag1;
@property (nonatomic, strong) UIButton *tag2;
@property (nonatomic, strong) UIButton *tag3;

@end

@implementation ForumCatDetailTableViewCell

//-(CommandButton *)topicNameBtn{
//    if (!_topicNameBtn) {
//        _topicNameBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
//        _topicNameBtn.backgroundColor = [UIColor orangeColor];
//        _topicNameBtn.layer.masksToBounds = YES;
//        _topicNameBtn.layer.cornerRadius = 10;
//        [_topicNameBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        _topicNameBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        
//    }
//    return _topicNameBtn;
//}


-(UIButton *)tag3{
    if (!_tag3) {
        _tag3 = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _tag3;
}

-(UIButton *)tag2{
    if (!_tag2) {
        _tag2 = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _tag2;
}

-(UIButton *)tag1{
    if (!_tag1) {
        _tag1 = [[UIButton alloc] initWithFrame:CGRectZero];
    }
    return _tag1;
}

-(CommandButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _payBtn.backgroundColor = [UIColor grayColor];
    }
    return _payBtn;
}

-(CommandButton *)iconButton{
    if (!_iconButton) {
        _iconButton = [[CommandButton alloc] initWithFrame:CGRectZero];
        _iconButton.layer.masksToBounds = YES;
        _iconButton.layer.cornerRadius = 25;
        [_iconButton setImage:[UIImage imageNamed:@"placeholder_mine.png"] forState:UIControlStateNormal];
        
    }
    return _iconButton;
}

-(UILabel *)namesLabel{
    if (!_namesLabel) {
        _namesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
    }
    return _namesLabel;
}

-(UIButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_shareBtn setImage:[UIImage imageNamed:@"share-MF"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

-(UILabel *)replyLabel{
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyLabel.text = @"14";
        _replyLabel.textColor = [UIColor grayColor];
        _replyLabel.font = [UIFont systemFontOfSize:14];
    }
    return _replyLabel;
}

-(UIButton *)supprotBtn{
    if (!_supprotBtn) {
        _supprotBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_supprotBtn setImage:[UIImage imageNamed:@"mine_like"] forState:UIControlStateNormal];
        [_supprotBtn setImage:[UIImage imageNamed:@"mine_like_S"] forState:UIControlStateSelected];
    }
    return _supprotBtn;
}

-(UILabel *)supportLabel{
    if (!_supportLabel) {
        _supportLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _supportLabel.text = @"800";
        _supportLabel.font = [UIFont systemFontOfSize:14];
        _supportLabel.textColor = [UIColor grayColor];
    }
    return _supportLabel;
}


+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0 + 40;
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[self cellKeyForPostVO]];
    if ([postVO isKindOfClass:[ForumPostVO class]]) {
        height += 15;
        CGFloat contentHeight = [self heightForPostContent:postVO.content];
        if (contentHeight>0) {
            height += contentHeight;
            height += 10;
        }
        
        CGFloat picsHeight = 0;
        if ([postVO.attachments count]>0) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:postVO.attachments.count];
            for (ForumAttachmentVO *attchmentVO in postVO.attachments) {
                if (attchmentVO.type == ForumAttachTypePics) {
                    [array addObject:attchmentVO];
                }
            }
            picsHeight = [ForumPostAttachmentPicsView rowHeightForPortrait:array];
            if (picsHeight>0) {
                height += picsHeight;
                height += 10;
            }
            
            if ([array count]!=[postVO.attachments count]) {
                height += 20;
                height += 10;
            }
        }
        
        height += 24; //btns
        height += 5;
    }
    
    return height;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumCatDetailTableViewCell class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    return dict;
}

+ (NSString*)cellKeyForPostVO {
    return @"postVO";
}

+ (NSString*)cellKeyForForumTopicVO {
    return @"forumTopicVO";
}


- (void)updateCellWithDict:(NSDictionary*)dict forumTopicVO:(ForumTopicVO*)forumTopicVO {
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[[self class] cellKeyForPostVO]];
    if ([postVO isKindOfClass:[ForumPostVO class]]) {
        self.postVO = postVO;
        if ([self.postVO.attachments count]>0) {
            
        }
        [self.contentLbl setEmojiText:postVO.content];
        
        self.picsView.hidden = YES;
        self.contentAttachmentsBtn.hidden = YES;
        
        if ([postVO.attachments count]>0) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:postVO.attachments.count];
            for (ForumAttachmentVO *attchmentVO in postVO.attachments) {
                if (attchmentVO.type == ForumAttachTypePics) {
                    [array addObject:attchmentVO];
                }
            }
            if ([array count]>0) {
                CGFloat picsHeight = [ForumPostAttachmentPicsView rowHeightForPortrait:array];
                self.picsView.frame = CGRectMake(0, self.picsView.top, kScreenWidth, picsHeight);
                self.picsView.hidden = NO;
                [self.picsView updateWithAttachmentPics:array];
            }
            if ([array count]<[postVO.attachments count]) {
                self.contentAttachmentsBtn.hidden = NO;
            }
        }
        
        self.urlMatches = [self.detector matchesInString:postVO.content options:0 range:NSMakeRange(0, postVO.content.length)];
        self.phoneMatches = [self.phoneDetector matchesInString:postVO.content options:0 range:NSMakeRange(0, postVO.content.length)];
        
        for (ForumPostStatusVo *statusVO in forumTopicVO.statusVoList) {
            if (statusVO.status==postVO.status) {
                [self.statusBtn setTitle:statusVO.display forState:UIControlStateNormal];
                break;
            }
        }
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:postVO.timestamp/1000];
        self.timestampLbl.text = [date formattedDateDescription];
        
        if ([Session sharedInstance].currentUserId==postVO.user_id) {
            
            if (self.postVO.isFinshed) {
                self.delBtn.hidden = YES;
                self.statusBtn.hidden = NO;
                self.statusBtn.enabled = NO;
                self.replyBtn.hidden = YES;
                self.replyLabel.hidden = YES;
                self.shareBtn.hidden = YES;
                self.supportLabel.hidden = YES;
                self.supprotBtn.hidden = YES;

                
            } else {
                self.delBtn.hidden = NO;
                self.statusBtn.hidden = NO;
                self.statusBtn.enabled = YES;
                self.replyBtn.hidden = NO;
                self.replyLabel.hidden = NO;
                self.shareBtn.hidden = NO;
                self.supportLabel.hidden = NO;
                self.supprotBtn.hidden = NO;

            }
        } else {
            self.delBtn.hidden = YES;
            if (postVO.isFinshed) {
                self.statusBtn.hidden = NO;
                self.statusBtn.enabled = NO;
                self.replyBtn.hidden = YES;
                self.replyLabel.hidden = YES;
                self.shareBtn.hidden = YES;
                self.supportLabel.hidden = YES;
                self.supprotBtn.hidden = YES;

            } else {
                self.statusBtn.hidden = YES;
                self.replyBtn.hidden = NO;
                self.replyLabel.hidden = NO;
                self.shareBtn.hidden = NO;
                self.supportLabel.hidden = NO;
                self.supprotBtn.hidden = NO;

            }
        }
        
        self.is_have_quote = forumTopicVO.is_have_quote;
        
        
        if (forumTopicVO.is_have_quote>0) {
            [self.replyBtn setTitle:nil forState:UIControlStateNormal];
            [self.replyBtn setImage:[UIImage imageNamed:@"forum_icon_more"] forState:UIControlStateNormal];
            self.replyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        } else {
            [self.replyBtn setTitle:@"" forState:UIControlStateNormal];
            [self.replyBtn setImage:[UIImage imageNamed:@"forum_topic_comment_icon"] forState:UIControlStateNormal];
            self.replyBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        }
        self.moreOprationView.hidden = YES;
        
        [self setNeedsLayout];
    }
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.iconButton];
        [self.contentView addSubview:self.namesLabel];
        [self.contentView addSubview:self.shareBtn];
        [self.contentView addSubview:self.replyLabel];
        [self.contentView addSubview:self.supprotBtn];
        [self.contentView addSubview:self.supportLabel];
//        [self.contentView addSubview:self.payBtn];
//        [self.contentView addSubview:self.topicNameBtn];
        [self.contentView addSubview:self.tag1];
        [self.contentView addSubview:self.tag2];
        [self.contentView addSubview:self.tag3];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat left = 15;
    
    self.iconButton.frame = CGRectMake(left, margin, 50, 50);
    
//    self.payBtn.hidden = YES;
//    CGFloat marginTop = self.delBtn.bottom;
    
    
//    if (![self.arrowView isHidden]) {
//        self.arrowView.frame = CGRectMake(30, marginTop+(12-self.arrowView.height) + 40, self.arrowView.width, self.arrowView.height);
//        marginTop += 12;
//        
//        CGFloat tmpMarginTop = marginTop;
//        
//        marginTop += 6;
//        
//        if (![self.quoteNumLbl isHidden]) {
//            [self.quoteNumLbl sizeToFit];
//            self.quoteNumLbl.frame = CGRectMake(15+10, marginTop + 40, self.quoteNumLbl.width, self.quoteNumLbl.height+4);
//            marginTop += self.quoteNumLbl.height;
//        }
//        
//        if (![self.reply1Lbl isHidden]) {
//            CGSize size = [self.reply1Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
//            self.reply1Lbl.frame = CGRectMake(15+10, marginTop + 40, kScreenWidth-30-20, size.height+4);
//            marginTop += self.reply1Lbl.height;
//        }
//        
//        if (![self.reply2Lbl isHidden]) {
//            CGSize size = [self.reply2Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
//            self.reply2Lbl.frame = CGRectMake(15+10, marginTop + 40, kScreenWidth-30-20, size.height+4);
//            marginTop += self.reply2Lbl.height;
//        }
//        
//        if (![self.reply3Lbl isHidden]) {
//            CGSize size = size = [self.reply3Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
//            self.reply3Lbl.frame = CGRectMake(15+10, marginTop + 40, kScreenWidth-30-20, size.height+4);
//            marginTop += self.reply3Lbl.height;
//        }
//        
//        if (![self.allRepliesBtn isHidden]) {
//            [self.allRepliesBtn sizeToFit];
//            self.allRepliesBtn.frame = CGRectMake(15+10, marginTop + 40, self.allRepliesBtn.width, self.allRepliesBtn.height+6);
//            marginTop += self.allRepliesBtn.height;
//        }
//        
//        marginTop += 4;
//        self.bgView.frame = CGRectMake(15, tmpMarginTop + 40, self.contentView.width-30, marginTop-tmpMarginTop);
//    }
    
    
    
    
    
    
    
    
    CGFloat marginTops = 15;
    CGSize size = [self.contentLbl sizeThatFits:CGSizeMake(kScreenWidth-30-self.iconButton.width-15, CGFLOAT_MAX)];
    if (size.height>0) {
        self.contentLbl.frame = CGRectMake(15, marginTops, kScreenWidth-30-self.iconButton.width-15, size.height+2);
        marginTops += self.contentLbl.height;
        marginTops += 10;
    }
    
    if (![self.picsView isHidden]) {
        self.picsView.frame = CGRectMake(0, marginTops, kScreenWidth, self.picsView.height);
        marginTops += self.picsView.height;
        marginTops += 10;
    }
    
    if (![self.contentAttachmentsBtn isHidden]) {
        [self.contentAttachmentsBtn sizeToFit];
        self.contentAttachmentsBtn.frame = CGRectMake(15, marginTops, self.contentAttachmentsBtn.width, 20);
        marginTops += self.contentAttachmentsBtn.height;
        marginTops += 10;
    }
    
    [self.timestampLbl sizeToFit];
    self.timestampLbl.frame = CGRectMake(15 + self.iconButton.width + 10, marginTops + 40, self.timestampLbl.width, 24);
//    self.topicNameBtn.frame = CGRectMake(15 + self.iconButton.width + 10, marginTops + 13, 43, 20);
//    [self.topicNameBtn setTitle:self.postVO.topic_name forState:UIControlStateNormal];
    
    
    if ([Session sharedInstance].currentUserId==self.postVO.user_id) {
        
        if (self.postVO.isFinshed) {
            self.delBtn.hidden = YES;
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = NO;
            self.replyBtn.hidden = YES;
            self.shareBtn.hidden = YES;
            self.supprotBtn.hidden = YES;
            self.supportLabel.hidden = YES;
            self.replyLabel.hidden = YES;
            
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-15-self.statusBtn.width, marginTops + 40, self.statusBtn.width, 24);
            
        } else {
            self.delBtn.hidden = NO;
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = YES;
            self.replyBtn.hidden = NO;
            self.replyLabel.hidden = NO;
            self.shareBtn.hidden = NO;
            self.supportLabel.hidden = NO;
            self.supprotBtn.hidden = NO;
            
            [self.replyBtn sizeToFit];
            if (kScreenWidth == 320) {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-40, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-40, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-30-45-15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-27-self.replyBtn.width, marginTops + 42, 30, 18);
            } else {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-50, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width -15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50-45 - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-47-self.replyBtn.width, marginTops + 42, 30, 18);
            }
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-self.statusBtn.width - 15, margin, self.statusBtn.width, 24);
        }
        
        
    } else {
        self.delBtn.hidden = YES;
        
        if (self.postVO.isFinshed) {
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = NO;
            self.replyBtn.hidden = YES;
            self.shareBtn.hidden = YES;
            self.supprotBtn.hidden = YES;
            self.supportLabel.hidden = YES;
            self.replyLabel.hidden = YES;
            
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-15-self.statusBtn.width, marginTops + 40, self.statusBtn.width, 24);
            
        } else {
            self.statusBtn.hidden = YES;
            self.replyBtn.hidden = NO;
            self.replyLabel.hidden = NO;
            self.shareBtn.hidden = NO;
            self.supportLabel.hidden = NO;
            self.supprotBtn.hidden = NO;
            
            [self.replyBtn sizeToFit];
            if (kScreenWidth == 320) {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-40, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-40, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-30-45-15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-27-self.replyBtn.width, marginTops + 42, 30, 18);
            } else {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-50, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width -15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50-45 - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-47-self.replyBtn.width, marginTops + 42, 30, 18);
            }
        }
        
        //        if (self.statusVoList) {
        //            self.statusBtn.hidden = NO;
        //        } else {
        //            self.statusBtn.hidden = YES;
        //        }
    }
    [self.delBtn sizeToFit];
    if (kScreenWidth == 320) {
        self.delBtn.frame = CGRectMake(self.supprotBtn.left - 20, marginTops + 40, self.delBtn.width, 24);
    } else {
        self.delBtn.frame = CGRectMake(self.supprotBtn.left - 40, marginTops + 40, self.delBtn.width, 24);
    }
    
    marginTops += 24;
    
    
    if (self.postVO.forum_tag.length > 0) {
        NSString *tagStr = [self.postVO.forum_tag substringWithRange:NSMakeRange(2, self.postVO.forum_tag.length - 4)];
        NSLog(@"%@", tagStr);
        NSArray *tagArr = [tagStr componentsSeparatedByString:@"\",\""]; //componentsSeparatedByString:
        NSLog(@"%@", tagArr);
        self.tagArr = tagArr;
        if (self.tagArr.count == 1) {
            self.tag1.hidden = NO;
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
        }
        
        if (tagArr.count == 2) {
            
            self.tag1.hidden = NO;
            [self.tag1 sizeToFit];
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
            
            self.tag2.hidden = NO;
            [self.tag2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag2.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag2 sizeToFit];
            NSString *tag2 = tagArr[1];
            [self.tag2 setTitle:tag2 forState:UIControlStateNormal];
            self.tag2.frame = CGRectMake(0 + self.tag1.width + 10, 0, self.tag2.width, 20);
        }
        
        if (tagArr.count == 3) {
            
            self.tag1.hidden = NO;
            [self.tag1 sizeToFit];
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
            
            self.tag2.hidden = NO;
            [self.tag2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag2.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag2 sizeToFit];
            NSString *tag2 = tagArr[1];
            [self.tag2 setTitle:tag2 forState:UIControlStateNormal];
            self.tag2.frame = CGRectMake(0 + self.tag1.width + 10, 0, self.tag2.width, 20);
            
            self.tag3.hidden = NO;
            [self.tag3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag3.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag3 sizeToFit];
            NSString *tag3 = tagArr[2];
            [self.tag3 setTitle:tag3 forState:UIControlStateNormal];
            self.tag3.frame = CGRectMake(0 + self.tag1.width + self.tag2.width + 10 * 2, 0, self.tag3.width, 20);
            
        }
        //        }
        
    } else {
        self.tag1.hidden = YES;
        self.tag2.hidden = YES;
        self.tag3.hidden = YES;
    }
    
    self.namesLabel.frame = CGRectMake(left + self.iconButton.width + margin, margin, kScreenWidth - self.iconButton.width - left - margin, 20);
    self.contentLbl.frame = CGRectMake(left + self.iconButton.width + margin, margin + self.iconButton.height - 20, kScreenWidth - self.iconButton.width - left - margin, size.height+2);
    self.picsView.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin*2, self.picsView.width, self.picsView.height);
//    self.payBtn.frame = CGRectMake(self.contentView.width-15-self.statusBtn.width, margin, self.statusBtn.width, 24);
    //    if (self.picsView.height > 1) {
    //        self.timestampLbl.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin * 3 + self.picsView.height, self.timestampLbl.width, self.timestampLbl.height);
    //    } else if (!self.picsView.height < 1) {
    //        self.timestampLbl.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin * 2, self.timestampLbl.width, self.timestampLbl.height);
    //    }
    
    //    self.moreOprationView.frame = CGRectMake(margin, self.timestampLbl.top-(self.moreOprationView.height-self.timestampLbl.height)/2 + 40, 0, self.moreOprationView.height);
    
    
    self.namesLabel.text = self.postVO.username;
//    NSLog(@"%@", self.postVO.avatar);
    [self.iconButton sd_setImageWithURL:[NSURL URLWithString:self.postVO.avatar] forState:UIControlStateNormal completed:nil];
    [self setNeedsLayout];
}


@end


@interface ForumPostTableViewCellWithReply () <TTTAttributedLabelDelegate>

{
//    UIView *_bgView;
//    UIImageView *_arrowView;
//    UILabel *_quoteNumLbl;
//    TapDetectingMLEmojiLabel *_reply1Lbl;
//    TapDetectingMLEmojiLabel *_reply2Lbl;
//    TapDetectingMLEmojiLabel *_reply3Lbl;
//    TapDetectingLabel *_allRepliesBtn;
}

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *quoteNumLbl;
@property (nonatomic, strong) UIImageView *arrowView;
@property (nonatomic, strong) TapDetectingMLEmojiLabel *reply1Lbl;
@property (nonatomic, strong) TapDetectingMLEmojiLabel *reply2Lbl;
@property (nonatomic, strong) TapDetectingMLEmojiLabel *reply3Lbl;
@property (nonatomic, strong) TapDetectingLabel *allRepliesBtn;


@end

@implementation ForumPostTableViewCellWithReply

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostTableViewCellWithReply class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat height = 0;
//    ForumTopicVO *forumTopicVO = (ForumTopicVO*)[dict objectForKey:[self cellKeyForForumTopicVO]];
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[self cellKeyForPostVO]];
    if ([postVO isKindOfClass:[ForumPostVO class]]) {
        height += 15 + 10;
        CGFloat contentHeight = [self heightForPostContent:postVO.content];
        if (contentHeight>0) {
            height += contentHeight;
            height += 10;
        } else {
            height += 20;
        }
        
        CGFloat picsHeight = 0;
        if ([postVO.attachments count]>0) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:postVO.attachments.count];
            for (ForumAttachmentVO *attchmentVO in postVO.attachments) {
                if (attchmentVO.type == ForumAttachTypePics) {
                    [array addObject:attchmentVO];
                }
            }
            picsHeight = [ForumPostAttachmentPicsView rowHeightForPortrait:array];
            if (picsHeight>0) {
                height += picsHeight;
                height += 10;
            }
            
            if ([array count]!=[postVO.attachments count]) {
                height += 20;
                height += 10;
            }
        }
        
        height += 24; //btns
        
        
        NSMutableArray *replyVOList = postVO.topReplies;
        if (([replyVOList isKindOfClass:[NSMutableArray class]]&&[replyVOList count]>0)||postVO.quote_num>0) {
            height += 12; //arrow height
            
            if (postVO.quote_num>0) {
                NSString *quoteNumString = @"暂无报价";
                height += [quoteNumString sizeWithFont:[UIFont systemFontOfSize:14]].height;
                height += 4;
            }
            if ([replyVOList isKindOfClass:[NSMutableArray class]]&&[replyVOList count]>0) {
                for (ForumPostReplyVO *replyVO in replyVOList) {
                    height += [ForumPostReplyTableCell heightForReplyContent:replyVO];
                    height += 4;
                }
                if (postVO.reply_num>3) {
                    NSString *allReplies = [NSString stringWithFormat:@"展开全部 %ld 条回复",(long)postVO.reply_num];
                    height += [allReplies sizeWithFont:[UIFont systemFontOfSize:13.f]].height;
                    height += 6;
                }
            }
            
            height += 10;//top bottom
        }
        
        height += 15;
    }
    
    return height;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostTableViewCellWithReply class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    return dict;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO forumTopicVO:(ForumTopicVO*)forumTopicVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostTableViewCellWithReply class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    if (forumTopicVO) [dict setObject:forumTopicVO forKey:[self cellKeyForForumTopicVO]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        // Initialization code
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forum_comment_arrow"]];
        [self.contentView addSubview:_arrowView];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        [self.contentView addSubview:_bgView];
        
        _quoteNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _quoteNumLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _quoteNumLbl.text = @"暂无报价";
        _quoteNumLbl.font = [UIFont systemFontOfSize:14];
        _quoteNumLbl.hidden = YES;
        [self.contentView addSubview:_quoteNumLbl];
        
        TapDetectingMLEmojiLabel *reply1Lbl = [ForumPostReplyTableCell createReplyLbl];
        _reply1Lbl = reply1Lbl;
        _reply1Lbl.emojiDelegate = self;
        _reply1Lbl.delegate = self;
        _reply1Lbl.hidden = YES;
        [self.contentView addSubview:_reply1Lbl];
        
        _reply2Lbl = [ForumPostReplyTableCell createReplyLbl];
        _reply2Lbl.emojiDelegate = self;
        _reply2Lbl.delegate = self;
        _reply2Lbl.hidden = YES;
        [self.contentView addSubview:_reply2Lbl];
        
        _reply3Lbl = [ForumPostReplyTableCell createReplyLbl];
        _reply3Lbl.emojiDelegate = self;
        _reply3Lbl.delegate = self;
        _reply3Lbl.hidden = YES;
        [self.contentView addSubview:_reply3Lbl];
        
        _allRepliesBtn = [[TapDetectingLabel alloc] initWithFrame:CGRectZero];
        _allRepliesBtn.textColor = [UIColor colorWithHexString:@"999999"];
        _allRepliesBtn.font = [UIFont systemFontOfSize:13.0f];
        _allRepliesBtn.hidden = YES;
        [self.contentView addSubview:_allRepliesBtn];
        
        WEAKSELF;
        _allRepliesBtn.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
            if (weakSelf.handleAllRepliesBlock) {
                weakSelf.handleAllRepliesBlock(weakSelf.postVO);
            }
        };
        
        _reply1Lbl.handleSingleTapDetected = ^(TapDetectingMLEmojiLabel *view) {
            if (weakSelf.handleReplyToBlock && [weakSelf.postVO.topReplies count]>0) {
                weakSelf.handleReplyToBlock(weakSelf.postVO,[weakSelf.postVO.topReplies objectAtIndex:0]);
            }
        };
        _reply2Lbl.handleSingleTapDetected = ^(TapDetectingMLEmojiLabel *view) {
            if (weakSelf.handleReplyToBlock && [weakSelf.postVO.topReplies count]>1) {
                weakSelf.handleReplyToBlock(weakSelf.postVO,[weakSelf.postVO.topReplies objectAtIndex:1]);
            }
        };
        _reply3Lbl.handleSingleTapDetected = ^(TapDetectingMLEmojiLabel *view) {
            if (weakSelf.handleReplyToBlock && [weakSelf.postVO.topReplies count]>2) {
                weakSelf.handleReplyToBlock(weakSelf.postVO,[weakSelf.postVO.topReplies objectAtIndex:2]);
            }
        };
        
        void(^handleCopyMenuItemClickedBlock)(TapDetectingMLEmojiLabel *view) = ^(TapDetectingMLEmojiLabel *view){
            
        };
        void(^handleDeleteMenuItemClickedBlock)(TapDetectingMLEmojiLabel *view) = ^(TapDetectingMLEmojiLabel *view){
            if (weakSelf.handleDeleteReplyBlock) {
                weakSelf.handleDeleteReplyBlock(weakSelf.postVO,view.replyVO);
            }
        };
        _reply1Lbl.handleCopyMenuItemClicked = handleCopyMenuItemClickedBlock;
        _reply2Lbl.handleCopyMenuItemClicked = handleCopyMenuItemClickedBlock;
        _reply3Lbl.handleCopyMenuItemClicked = handleCopyMenuItemClickedBlock;
        
        _reply1Lbl.handleDeleteMenuItemClicked = handleDeleteMenuItemClickedBlock;
        _reply2Lbl.handleDeleteMenuItemClicked = handleDeleteMenuItemClickedBlock;
        _reply3Lbl.handleDeleteMenuItemClicked = handleDeleteMenuItemClickedBlock;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    _arrowView.hidden = YES;
    _bgView.hidden = YES;
    _reply1Lbl.hidden = YES;
    _reply2Lbl.hidden = YES;
    _reply3Lbl.hidden = YES;
    _allRepliesBtn.hidden = YES;
    _quoteNumLbl.hidden = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat marginTop = self.timestampLbl.bottom;
    
    
    if (![self.arrowView isHidden]) {
        //        self.arrowView.backgroundColor = [UIColor redColor];
        self.arrowView.frame = CGRectMake(30, marginTop+(12-self.arrowView.height), self.arrowView.width, self.arrowView.height);
        marginTop += 12;
        
        CGFloat tmpMarginTop = marginTop;
        
        marginTop += 6;
        
        if (![self.quoteNumLbl isHidden]) {
            [self.quoteNumLbl sizeToFit];
            self.quoteNumLbl.frame = CGRectMake(15+10, marginTop, self.quoteNumLbl.width, self.quoteNumLbl.height+4);
            marginTop += self.quoteNumLbl.height;
        }
        
        if (![self.reply1Lbl isHidden]) {
            CGSize size = [self.reply1Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
            self.reply1Lbl.frame = CGRectMake(15+10, marginTop, kScreenWidth-30-20, size.height+4);
            marginTop += self.reply1Lbl.height;
        }
        
        if (![self.reply2Lbl isHidden]) {
            CGSize size = [self.reply2Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
            self.reply2Lbl.frame = CGRectMake(15+10, marginTop, kScreenWidth-30-20, size.height+4);
            marginTop += self.reply2Lbl.height;
        }
        
        if (![self.reply3Lbl isHidden]) {
            CGSize size = size = [self.reply3Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
            self.reply3Lbl.frame = CGRectMake(15+10, marginTop, kScreenWidth-30-20, size.height+4);
            marginTop += self.reply3Lbl.height;
        }
        
        if (![self.allRepliesBtn isHidden]) {
            [self.allRepliesBtn sizeToFit];
            self.allRepliesBtn.frame = CGRectMake(15+10, marginTop, self.allRepliesBtn.width, self.allRepliesBtn.height+6);
            marginTop += self.allRepliesBtn.height;
        }
        
        marginTop += 4;
        self.bgView.frame = CGRectMake(15, tmpMarginTop, self.contentView.width-30, marginTop-tmpMarginTop);
    }
}

- (void)updateCellWithDict:(NSDictionary*)dict forumTopicVO:(ForumTopicVO*)forumTopicVO {
    [super updateCellWithDict:dict forumTopicVO:forumTopicVO];
    
    NSMutableArray *replyVOList = self.postVO.topReplies;
    if ([replyVOList isKindOfClass:[NSMutableArray class]]) {
        if ([replyVOList count]>0 || self.postVO.quote_num>0) {
            _arrowView.hidden = NO;
            _bgView.hidden = NO;
            
            if (self.postVO.quote_num>0) {
                _quoteNumLbl.text = [NSString stringWithFormat:@"已经有%ld人报价",(long)self.postVO.quote_num];
                _quoteNumLbl.hidden = NO;
            }
            
            if ([replyVOList count]>0) {
                ForumPostReplyVO *replyVO = (ForumPostReplyVO*)[replyVOList objectAtIndex:0];
                [[self class] setContentLblEmojiText:_reply1Lbl postVO:self.postVO replyVO:replyVO];
                _reply1Lbl.replyVO = replyVO;
                _reply1Lbl.isShowDelMenuItem = [Session sharedInstance].currentUserId==replyVO.user_id?YES:NO;
                _reply1Lbl.hidden = NO;
                
                if ([replyVOList count]>1) {
                    replyVO = (ForumPostReplyVO*)[replyVOList objectAtIndex:1];
                    [[self class] setContentLblEmojiText:_reply2Lbl postVO:self.postVO replyVO:replyVO];
                    _reply2Lbl.replyVO = replyVO;
                    _reply2Lbl.isShowDelMenuItem = [Session sharedInstance].currentUserId==replyVO.user_id?YES:NO;
                    _reply2Lbl.hidden = NO;
                } else {
                    _reply2Lbl.hidden = YES;
                }
                
                if ([replyVOList count]>2) {
                    replyVO = (ForumPostReplyVO*)[replyVOList objectAtIndex:2];
                    [[self class] setContentLblEmojiText:_reply3Lbl postVO:self.postVO replyVO:replyVO];
                    _reply3Lbl.replyVO = replyVO;
                    _reply3Lbl.isShowDelMenuItem = [Session sharedInstance].currentUserId==replyVO.user_id?YES:NO;
                    _reply3Lbl.hidden = NO;
                } else {
                    _reply3Lbl.hidden = YES;
                }
                
                if (self.postVO.reply_num>3) {
                    _allRepliesBtn.hidden = NO;
                    _allRepliesBtn.text = [NSString stringWithFormat:@"查看全部 %ld 条回复",(long)self.postVO.reply_num];
                } else {
                    _allRepliesBtn.hidden = YES;
                }
            }
            
        } else {
            _arrowView.hidden = YES;
            _bgView.hidden = YES;
            _reply1Lbl.hidden = YES;
            _reply2Lbl.hidden = YES;
            _reply3Lbl.hidden = YES;
        }
        
        [self setNeedsLayout];
    }
}

+ (void)setContentLblEmojiText:(TapDetectingMLEmojiLabel*)contentLbl postVO:(ForumPostVO*)postVO replyVO:(ForumPostReplyVO*)replyVO {
    
    NSMutableArray *attachRedirectArray = [[NSMutableArray alloc] init];
    
    NSMutableString *attachString = [[NSMutableString alloc] init];
    for (ForumAttachmentVO *attachmentVO in replyVO.attachments) {
        if ([attachString length]>0) {
            [attachString appendString:@" "];
        }
        if ([attachmentVO.item isKindOfClass:[ForumAttachItemRemindUpgradeVO class]]) {
            NSString *subString = @"请升级新版本";
            [attachString appendString:subString];
            ForumAttachRedirectInfo *redirectInfo = [ForumAttachRedirectInfo allocWithData:NSMakeRange(attachString.length-subString.length-attachRedirectArray.count*3, subString.length-3) redirectUri:APPSTORE_URL];
            [attachRedirectArray addObject:redirectInfo];
        } else if ([attachmentVO.item isKindOfClass:[ForumAttachItemGoodsVO class]]) {
            ForumAttachItemGoodsVO *itemGoodsVO = (ForumAttachItemGoodsVO*)attachmentVO.item;
            NSString *subString = [NSString stringWithFormat:@"[附件]%@",itemGoodsVO.goods_name];
            [attachString appendString:subString];
            ForumAttachRedirectInfo *redirectInfo = [ForumAttachRedirectInfo allocWithData:NSMakeRange(attachString.length-subString.length-attachRedirectArray.count*3, subString.length-3) redirectUri:kURLSchemeGoodsDetail(itemGoodsVO.goods_id)];
            [attachRedirectArray addObject:redirectInfo];
        }
    }
    
    contentLbl.isShowDelMenuItem = [Session sharedInstance].currentUserId==replyVO.user_id?YES:NO;
    contentLbl.replyVO = replyVO;
    
    NSString *content = nil;
    if ([replyVO.reply_username length]>0) {
        NSString *replyString = [NSString stringWithFormat:@"%@ 回复 %@：", replyVO.username, replyVO.reply_username];
        if ([replyVO.content length]>0) {
            content = [NSString stringWithFormat:@"%@%@ ", replyString,replyVO.content];
        } else {
            content = replyString;
        }
        if ([attachString length]>0) {
            [contentLbl setEmojiText:[NSString stringWithFormat:@"%@%@",content,attachString]];
            NSInteger totalLength = contentLbl.attributedText.length;
            
            UIColor *color = [UIColor colorWithHexString:@"c2a79d"];
            ForumAttachRedirectInfo *lastRedirectInfo = [attachRedirectArray objectAtIndex:attachRedirectArray.count-1];
            NSInteger location = totalLength-(lastRedirectInfo.range.location+lastRedirectInfo.range.length);
            for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                
                NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                [contentLbl addLinkToURL:[NSURL URLWithString:redirectInfo.redirectUri] withRange:range];
            }
            
            NSMutableAttributedString *mutableAttributedString = [contentLbl.attributedText mutableCopy];
            for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                
                NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName
                                                value:(id)color.CGColor
                                                range:range];
            }
            contentLbl.attributedText = mutableAttributedString;
            [contentLbl setNeedsDisplay];
        } else {
            [contentLbl setEmojiText:content];
        }
        
        [contentLbl addLinkToURL:postVO.user_id==replyVO.user_id?[NSURL URLWithString:@""]:[NSURL URLWithString:kURLSchemeUserHome(replyVO.user_id)] withRange:NSMakeRange(0, replyVO.username.length)];
        
        [contentLbl addLinkToURL:postVO.user_id==replyVO.reply_user_id?[NSURL URLWithString:@""]:[NSURL URLWithString:kURLSchemeUserHome(replyVO.reply_user_id)] withRange:NSMakeRange(replyString.length-replyVO.reply_username.length-1, replyVO.reply_username.length+1)];
        
        
    } else {
        if ([replyVO.content length]>0) {
            content = [NSString stringWithFormat:@"%@：%@ ", replyVO.username,replyVO.content];
        } else {
            content = [NSString stringWithFormat:@"%@：", replyVO.username];
        }
        
        if ([attachString length]>0) {
            [contentLbl setEmojiText:[NSString stringWithFormat:@"%@%@",content,attachString]];
            NSInteger totalLength = contentLbl.attributedText.length;
            
            UIColor *color = [UIColor colorWithHexString:@"c2a79d"];
            ForumAttachRedirectInfo *lastRedirectInfo = [attachRedirectArray objectAtIndex:attachRedirectArray.count-1];
            NSInteger location = totalLength-(lastRedirectInfo.range.location+lastRedirectInfo.range.length);
            for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                
                NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                [contentLbl addLinkToURL:[NSURL URLWithString:redirectInfo.redirectUri] withRange:range];
            }
            
            NSMutableAttributedString *mutableAttributedString = [contentLbl.attributedText mutableCopy];
            for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                
                NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName
                                                value:(id)color.CGColor
                                                range:range];
            }
            contentLbl.attributedText = mutableAttributedString;
            [contentLbl setNeedsDisplay];
            
            //                ForumAttachRedirectInfo *lastRedirectInfo = [attachRedirectArray objectAtIndex:attachRedirectArray.count-1];
            //                NSInteger location = totalLength-(lastRedirectInfo.range.location+lastRedirectInfo.range.length);
            //                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
            //                    [_contentLbl addLinkToURL:[NSURL URLWithString:redirectInfo.redirectUri] withRange:NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length)];
            //                }
        } else {
            [contentLbl setEmojiText:content];
        }
        
        [contentLbl addLinkToURL:postVO.user_id==replyVO.user_id?[NSURL URLWithString:@""]:[NSURL URLWithString:kURLSchemeUserHome(replyVO.user_id)] withRange:NSMakeRange(0, replyVO.username.length+1)];
    }
    
//    NSString *content = nil;
//    if ([replyVO.reply_username length]>0) {
//        NSString *replyString = [NSString stringWithFormat:@"%@ 回复 %@", replyVO.username, replyVO.reply_username];
//        content = [NSString stringWithFormat:@"%@：%@", replyString,replyVO.content];
//        [contentLbl setEmojiText:content];
//        [contentLbl addLinkToURL:[NSURL URLWithString:kURLSchemeUserHome(replyVO.user_id)] withRange:NSMakeRange(0, replyVO.username.length)];
//        [contentLbl addLinkToURL:[NSURL URLWithString:kURLSchemeUserHome(replyVO.reply_user_id)] withRange:NSMakeRange(replyString.length-replyVO.reply_username.length, replyVO.reply_username.length+1)];
//    } else {
//        content = [NSString stringWithFormat:@"%@：%@", replyVO.username,replyVO.content];
//        [contentLbl setEmojiText:content];
//        [contentLbl addLinkToURL:[NSURL URLWithString:kURLSchemeUserHome(replyVO.user_id)] withRange:NSMakeRange(0, replyVO.username.length+1)];
//    }
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [URLScheme locateWithRedirectUri:[url absoluteString] andIsShare:YES];
}

@end




@interface ForumPostCatHouseTableViewCell ()

@property (nonatomic, strong) CommandButton *iconButton;
@property (nonatomic, strong) UILabel *namesLabel;
@property (nonatomic, strong) CommandButton *shareBtn;
@property (nonatomic, strong) UILabel *replyLabel;
@property (nonatomic, strong) CommandButton *supprotBtn;
@property (nonatomic, strong) UILabel *supportLabel;

@property (nonatomic, strong) CommandButton *topicNameBtn;
@property (nonatomic, strong) NSArray *tagArr;

@property (nonatomic, strong) CommandButton *tag1;
@property (nonatomic, strong) CommandButton *tag2;
@property (nonatomic, strong) CommandButton *tag3;
@property (nonatomic, strong) UIView *tagBackView;

@property (nonatomic, strong) ForumTopicIsLike *tagicLike;

@end


@implementation ForumPostCatHouseTableViewCell

-(UIView *)tagBackView{
    if (!_tagBackView) {
        _tagBackView = [[UIView alloc] initWithFrame:CGRectZero];
//        _tagBackView.backgroundColor = [UIColor orangeColor];
    }
    return _tagBackView;
}

-(CommandButton *)tag3{
    if (!_tag3) {
        _tag3 = [[CommandButton alloc] initWithFrame:CGRectZero];
        _tag3.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tag3;
}

-(CommandButton *)tag2{
    if (!_tag2) {
        _tag2 = [[CommandButton alloc] initWithFrame:CGRectZero];
        _tag2.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tag2;
}

-(CommandButton *)tag1{
    if (!_tag1) {
        _tag1 = [[CommandButton alloc] initWithFrame:CGRectZero];
        _tag1.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tag1;
}

-(CommandButton *)topicNameBtn{
    if (!_topicNameBtn) {
        _topicNameBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
//        _topicNameBtn.backgroundColor = [UIColor orangeColor];
//        _topicNameBtn.layer.masksToBounds = YES;
//        _topicNameBtn.layer.cornerRadius = 10;
        [_topicNameBtn setTitleColor:[UIColor colorWithRed:215/255.f green:172/255.f blue:87/255.f alpha:1] forState:UIControlStateNormal];
        _topicNameBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        _topicNameBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        
    }
    return _topicNameBtn;
}

-(CommandButton *)payBtn{
    if (!_payBtn) {
        _payBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _payBtn.backgroundColor = [UIColor whiteColor];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"pay-N"] forState:UIControlStateNormal];
        [_payBtn setBackgroundImage:[UIImage imageNamed:@"pay-S"] forState:UIControlStateSelected];
    }
    return _payBtn;
}

-(CommandButton *)iconButton{
    if (!_iconButton) {
        _iconButton = [[CommandButton alloc] initWithFrame:CGRectZero];
        _iconButton.layer.masksToBounds = YES;
        _iconButton.layer.cornerRadius = 20;
        [_iconButton setImage:[UIImage imageNamed:@"placeholder_mine.png"] forState:UIControlStateNormal];
        
    }
    return _iconButton;
}

-(UILabel *)namesLabel{
    if (!_namesLabel) {
        _namesLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        
    }
    return _namesLabel;
}

-(CommandButton *)shareBtn{
    if (!_shareBtn) {
        _shareBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_shareBtn setImage:[UIImage imageNamed:@"share-MF"] forState:UIControlStateNormal];
    }
    return _shareBtn;
}

-(UILabel *)replyLabel{
    if (!_replyLabel) {
        _replyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _replyLabel.text = @"14";
        _replyLabel.textColor = [UIColor grayColor];
        _replyLabel.font = [UIFont systemFontOfSize:14];
    }
    return _replyLabel;
}

-(CommandButton *)supprotBtn{
    if (!_supprotBtn) {
        _supprotBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_supprotBtn setImage:[UIImage imageNamed:@"mine_likes"] forState:UIControlStateNormal];
        [_supprotBtn setImage:[UIImage imageNamed:@"mine_like_S"] forState:UIControlStateSelected];
    }
    return _supprotBtn;
}

-(UILabel *)supportLabel{
    if (!_supportLabel) {
        _supportLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _supportLabel.text = @"800";
        _supportLabel.font = [UIFont systemFontOfSize:14];
        _supportLabel.textColor = [UIColor grayColor];
    }
    return _supportLabel;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostCatHouseTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostCatHouseTableViewCell class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    return dict;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO forumTopicVO:(ForumTopicVO*)forumTopicVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostCatHouseTableViewCell class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    if (forumTopicVO) [dict setObject:forumTopicVO forKey:[self cellKeyForForumTopicVO]];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        WEAKSELF;
        
        [self.contentView addSubview:self.iconButton];
        [self.contentView addSubview:self.namesLabel];
        [self.contentView addSubview:self.shareBtn];
        [self.contentView addSubview:self.replyLabel];
        [self.contentView addSubview:self.supprotBtn];
        [self.contentView addSubview:self.supportLabel];
        [self.contentView addSubview:self.payBtn];
        [self.contentView addSubview:self.topicNameBtn];
        
        [self.contentView addSubview:self.tagBackView];
        [self.tagBackView addSubview:self.tag1];
        [self.tagBackView addSubview:self.tag2];
        [self.tagBackView addSubview:self.tag3];
//        [self.iconButton addTarget:self action:@selector(clickIconButton) forControlEvents:UIControlEventTouchUpInside];
//        [self.supprotBtn addTarget:self action:@selector(clickSupportBtn) forControlEvents:UIControlEventTouchUpInside];
        
//        self.isLike = 0;
        
        
        
    }
    return self;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat height = 0;
    //    ForumTopicVO *forumTopicVO = (ForumTopicVO*)[dict objectForKey:[self cellKeyForForumTopicVO]];
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[self cellKeyForPostVO]];
    if ([postVO isKindOfClass:[ForumPostVO class]]) {
        height += 15 + 10;
        CGFloat contentHeight = [self heightForPostContents:postVO.content];
        if (contentHeight>0) {
            height += contentHeight;
            height += 10;
            height += 10;
        }
        
        CGFloat picsHeight = 0;
        if ([postVO.attachments count]>0) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:postVO.attachments.count];
            for (ForumAttachmentVO *attchmentVO in postVO.attachments) {
                if (attchmentVO.type == ForumAttachTypePics) {
                    [array addObject:attchmentVO];
                }
            }
            picsHeight = [ForumPostAttachmentPicsView rowHeightForPortrait:array];
            if (picsHeight>0) {
                height += picsHeight;
                height += 10;
            }
            
            if ([array count]!=[postVO.attachments count]) {
                height += 20;
                height += 10;
            }
        }
        
        height += 24; //btns
        
        
        NSMutableArray *replyVOList = postVO.topReplies;
        if (([replyVOList isKindOfClass:[NSMutableArray class]]&&[replyVOList count]>0)||postVO.quote_num>0) {
            height += 12; //arrow height
            
            if (postVO.quote_num>0) {
                NSString *quoteNumString = @"暂无报价";
                height += [quoteNumString sizeWithFont:[UIFont systemFontOfSize:14]].height;
                height += 4;
            }
            if ([replyVOList isKindOfClass:[NSMutableArray class]]&&[replyVOList count]>0) {
                for (ForumPostReplyVO *replyVO in replyVOList) {
                    height += [ForumPostReplyTableCell heightForReplyContent:replyVO];
                    height += 4;
                }
                if (postVO.reply_num>3) {
                    NSString *allReplies = [NSString stringWithFormat:@"展开全部 %ld 条回复",(long)postVO.reply_num];
                    height += [allReplies sizeWithFont:[UIFont systemFontOfSize:13.f]].height;
                    height += 6;
                }
            }
            
            height += 10;//top bottom
        }
        
        height += 40;
    }
    
    return height;
}

+(CGFloat)heightForPostContents:(NSString *)content
{
    if ([content length]>0) {
        MLEmojiLabel *label = [self forumSizeLabel];
        label.frame = CGRectMake(67, 0, kScreenWidth-30-55, 0);
        [label setEmojiText:content];
        CGSize size = [label sizeThatFits:CGSizeMake(kScreenWidth-30-55, CGFLOAT_MAX)];
        return size.height+4;
    } else {
        return 0;
    }
}

//-(void)clickIconButton{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickIconButton" object:nil];
//}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat margin = 10;
    CGFloat left = 15;
    
    self.iconButton.frame = CGRectMake(left, margin, 40, 40);
    self.namesLabel.frame = CGRectMake(left + self.iconButton.width + margin, margin, kScreenWidth - self.iconButton.width - left - margin, 20);
    
    CGFloat marginTops = 15;
    CGSize size = [self.contentLbl sizeThatFits:CGSizeMake(kScreenWidth-30-self.iconButton.width-15, CGFLOAT_MAX)];
    if (size.height>0) {
        self.contentLbl.frame = CGRectMake(67, marginTops + 15, kScreenWidth-30-self.iconButton.width-15, size.height+2);
        marginTops += self.contentLbl.height;
        marginTops += 10;
    }
    
    if (!size.height>0) {
        marginTops += 10;
    }
    
    if (![self.picsView isHidden]) {
        self.picsView.frame = CGRectMake(50, marginTops + 10, kScreenWidth, self.picsView.height);
        marginTops += self.picsView.height;
        marginTops += 10;
    }
    
    if (![self.contentAttachmentsBtn isHidden]) {
        [self.contentAttachmentsBtn sizeToFit];
        self.contentAttachmentsBtn.frame = CGRectMake(15, marginTops, self.contentAttachmentsBtn.width, 20);
        marginTops += self.contentAttachmentsBtn.height;
        marginTops += 10;
    }
    
    [self.timestampLbl sizeToFit];
    self.timestampLbl.frame = CGRectMake(15 + self.iconButton.width + 10, marginTops + 40, self.timestampLbl.width, 24);
    
    CGFloat marginTop = self.timestampLbl.bottom;
    
    
    if (![self.arrowView isHidden]) {
        //        self.arrowView.backgroundColor = [UIColor redColor];
        self.arrowView.frame = CGRectMake(30 + 50, marginTop+(12-self.arrowView.height), self.arrowView.width, self.arrowView.height);
        marginTop += 12;
        
        CGFloat tmpMarginTop = marginTop;
        
        marginTop += 6;
        
        if (![self.quoteNumLbl isHidden]) {
            [self.quoteNumLbl sizeToFit];
            self.quoteNumLbl.frame = CGRectMake(15+10 + 50, marginTop, self.quoteNumLbl.width, self.quoteNumLbl.height+4);
            marginTop += self.quoteNumLbl.height;
        }
        
        if (![self.reply1Lbl isHidden]) {
            CGSize size = [self.reply1Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
            self.reply1Lbl.frame = CGRectMake(15+10 + 50, marginTop, kScreenWidth-30-20 - 50, size.height+4);
            marginTop += self.reply1Lbl.height;
        }
        
        if (![self.reply2Lbl isHidden]) {
            CGSize size = [self.reply2Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
            self.reply2Lbl.frame = CGRectMake(15+10 + 50, marginTop, kScreenWidth-30-20 - 50, size.height+4);
            marginTop += self.reply2Lbl.height;
        }
        
        if (![self.reply3Lbl isHidden]) {
            CGSize size = size = [self.reply3Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
            self.reply3Lbl.frame = CGRectMake(15+10 + 50, marginTop, kScreenWidth-30-20 - 50, size.height+4);
            marginTop += self.reply3Lbl.height;
        }
        
        if (![self.allRepliesBtn isHidden]) {
            [self.allRepliesBtn sizeToFit];
            self.allRepliesBtn.frame = CGRectMake(15+10 + 50, marginTop, self.allRepliesBtn.width, self.allRepliesBtn.height+6);
            marginTop += self.allRepliesBtn.height;
        }
        
        marginTop += 4;
        self.bgView.frame = CGRectMake(15 + 50, tmpMarginTop, self.contentView.width-30 - 50, marginTop-tmpMarginTop);
    }

    self.topicNameBtn.frame = CGRectMake(15 + self.iconButton.width + 10, marginTops + 13, 44, 20);
    [self.topicNameBtn setTitle:self.postVO.topic_name forState:UIControlStateNormal];
    self.topicNameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.tagBackView.frame = CGRectMake(15 + self.iconButton.width + 15 + 52, marginTops + 13, kScreenWidth - (15 + self.iconButton.width + 15 + 72), 20);
    self.tag1.hidden = YES;
    self.tag2.hidden = YES;
    self.tag3.hidden = YES;
    
    NSLog(@"%lu", self.postVO.forum_tag.length - 2);
    if (self.postVO.forum_tag.length > 0) {
        NSString *tagStr = [self.postVO.forum_tag substringWithRange:NSMakeRange(2, self.postVO.forum_tag.length - 4)];
        NSLog(@"%@", tagStr);
        NSArray *tagArr = [tagStr componentsSeparatedByString:@"\",\""]; //componentsSeparatedByString:
        NSLog(@"%@", tagArr);
        self.tagArr = tagArr;
        
        if (self.tagArr.count == 1) {
            self.tag1.hidden = NO;
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
        }
        
        if (tagArr.count == 2) {
            
            self.tag1.hidden = NO;
            [self.tag1 sizeToFit];
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
            
            self.tag2.hidden = NO;
            [self.tag2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag2.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag2 sizeToFit];
            NSString *tag2 = tagArr[1];
            [self.tag2 setTitle:tag2 forState:UIControlStateNormal];
            self.tag2.frame = CGRectMake(0 + self.tag1.width + 10, 0, self.tag2.width, 20);
        }
        
        if (tagArr.count == 3) {
            
            self.tag1.hidden = NO;
            [self.tag1 sizeToFit];
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
            
            self.tag2.hidden = NO;
            [self.tag2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag2.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag2 sizeToFit];
            NSString *tag2 = tagArr[1];
            [self.tag2 setTitle:tag2 forState:UIControlStateNormal];
            self.tag2.frame = CGRectMake(0 + self.tag1.width + 10, 0, self.tag2.width, 20);
            
            self.tag3.hidden = NO;
            [self.tag3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag3.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag3 sizeToFit];
            NSString *tag3 = tagArr[2];
            [self.tag3 setTitle:tag3 forState:UIControlStateNormal];
            self.tag3.frame = CGRectMake(0 + self.tag1.width + self.tag2.width + 10 * 2, 0, self.tag3.width, 20);

        }
                //        }
        
    } else {
        self.tag1.hidden = YES;
        self.tag2.hidden = YES;
        self.tag3.hidden = YES;
    }
    
    
    if ([Session sharedInstance].currentUserId==self.postVO.user_id) {
        
        if (self.postVO.isFinshed) {
            self.delBtn.hidden = YES;
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = NO;
            self.replyBtn.hidden = YES;
            self.shareBtn.hidden = YES;
            self.supprotBtn.hidden = YES;
            self.supportLabel.hidden = YES;
            self.replyLabel.hidden = YES;
            
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-15-self.statusBtn.width, marginTops + 40, self.statusBtn.width, 24);
            
        } else {
            self.delBtn.hidden = NO;
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = YES;
            self.replyBtn.hidden = NO;
            self.replyLabel.hidden = NO;
            self.shareBtn.hidden = NO;
            self.supportLabel.hidden = NO;
            self.supprotBtn.hidden = NO;
            
            [self.replyBtn sizeToFit];
            if (kScreenWidth == 320) {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-40, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-40, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-30-45-15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-27-self.replyBtn.width, marginTops + 42, 30, 18);
            } else {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-50, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width -15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50-45 - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-47-self.replyBtn.width, marginTops + 42, 30, 18);
            }
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-self.statusBtn.width - 15, margin, self.statusBtn.width, 24);
        }
        
        
    } else {
        self.delBtn.hidden = YES;
        
        if (self.postVO.isFinshed) {
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = NO;
            self.replyBtn.hidden = YES;
            self.shareBtn.hidden = YES;
            self.supprotBtn.hidden = YES;
            self.supportLabel.hidden = YES;
            self.replyLabel.hidden = YES;
            
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-15-self.statusBtn.width, marginTops + 40, self.statusBtn.width, 24);
            
        } else {
            self.statusBtn.hidden = YES;
            self.replyBtn.hidden = NO;
            self.replyLabel.hidden = NO;
            self.shareBtn.hidden = NO;
            self.supportLabel.hidden = NO;
            self.supprotBtn.hidden = NO;
            
            [self.replyBtn sizeToFit];
            if (kScreenWidth == 320) {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-40, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-40, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-30-45-15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-27-self.replyBtn.width, marginTops + 42, 30, 18);
            } else {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50, marginTops + 40 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-50, marginTops + 42, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width -15, marginTops + 40 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50-45 - 15, marginTops + 40 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-47-self.replyBtn.width, marginTops + 42, 30, 18);
            }
        }
        
        //        if (self.statusVoList) {
        //            self.statusBtn.hidden = NO;
        //        } else {
        //            self.statusBtn.hidden = YES;
        //        }
    }
    [self.delBtn sizeToFit];
    if (kScreenWidth == 320) {
        self.delBtn.frame = CGRectMake(self.supprotBtn.left - 20, marginTops + 40, self.delBtn.width, 24);
    } else {
        self.delBtn.frame = CGRectMake(self.supprotBtn.left - 40, marginTops + 40, self.delBtn.width, 24);
    }

    
    marginTops += 24;
    
    if ([Session sharedInstance].currentUserId==self.postVO.user_id) {
        self.payBtn.hidden = YES;
    } else {
        self.payBtn.hidden = NO;
        [self.payBtn sizeToFit];
        self.payBtn.frame = CGRectMake(self.contentView.width-15-50, margin - 3, 45, 18);
    }
    
    
    
//    self.contentLbl.frame = CGRectMake(left + self.iconButton.width + margin, margin + self.iconButton.height - 20, kScreenWidth - self.iconButton.width - left - margin, size.height+2);
//    self.picsView.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin*2 + 20, self.picsView.width, self.picsView.height);
//    if (self.picsView.height > 1) {
//        self.timestampLbl.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin * 3 + self.picsView.height, self.timestampLbl.width, self.timestampLbl.height);
//    } else if (!self.picsView.height < 1) {
//        self.timestampLbl.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin * 2, self.timestampLbl.width, self.timestampLbl.height);
//    }
    
//    self.moreOprationView.frame = CGRectMake(margin, self.timestampLbl.top-(self.moreOprationView.height-self.timestampLbl.height)/2 + 40, 0, self.moreOprationView.height);
    
    
    self.namesLabel.text = self.postVO.username;
    [self.iconButton sd_setImageWithURL:[NSURL URLWithString:self.postVO.avatar] forState:UIControlStateNormal completed:nil];
    
    self.replyLabel.text = [NSString stringWithFormat:@"%ld", self.postVO.reply_num];
    self.supportLabel.text = [NSString stringWithFormat:@"%ld", self.postVO.like_num];
    
    if (self.postVO.is_like == 1) {
        self.supprotBtn.selected = YES;
    } else if (self.postVO.is_like == 0) {
        self.supprotBtn.selected = NO;
    }
    
    if (self.postVO.is_following == 1) {
        self.payBtn.selected = YES;
    } else if (self.postVO.is_following == 0) {
        self.payBtn.selected = NO;
    }
    
    
    WEAKSELF;
    self.supprotBtn.handleClickBlock = ^(CommandButton *sender) {
        if (![Session sharedInstance].isLoggedIn) {
            NSLog(@"弹出登陆框");
            if (weakSelf.handleLikeBlock) {
                weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.postVO.is_like);
            }
            return;
        }
        if (weakSelf.postVO.is_like == 0) {
            
//            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//                weakSelf.supprotBtn.transform = CGAffineTransformMakeScale(1, 1);
//            } completion:^(BOOL finished) {
//                
//            }];
            
            weakSelf.postVO.is_like = 1;
            weakSelf.supprotBtn.selected = YES;
            weakSelf.postVO.like_num += 1;
            
            if (weakSelf.handleLikeBlock) {
                weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.postVO.is_like);
            }
            
        } else if (weakSelf.postVO.is_like == 1) {
            weakSelf.postVO.is_like = 0;
            weakSelf.supprotBtn.selected = NO;
            weakSelf.postVO.like_num -= 1;
            
            if (weakSelf.handleLikeBlock) {
                weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.postVO.is_like);
            }
            
        }

        NSLog(@"%ld", weakSelf.isLike);
    };
    
    self.topicNameBtn.handleClickBlock = ^(CommandButton *sender) {
        if (weakSelf.handleTagNameBtnBlock) {
            weakSelf.handleTagNameBtnBlock(weakSelf.postVO.topic_id);
        }
    };
    
    self.tag1.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagBlock) {
            weakSelf.handleTagBlock(weakSelf.tag1.titleLabel.text);
        }
    };
    
    self.tag2.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagBlock) {
            weakSelf.handleTagBlock(weakSelf.tag2.titleLabel.text);
        }
    };
    
    self.tag3.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagBlock) {
            weakSelf.handleTagBlock(weakSelf.tag3.titleLabel.text);
        }
    };
    
    //帖子的iconButton
    self.iconButton.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleIconBlock) {
            weakSelf.handleIconBlock(weakSelf.postVO);
        }
    };
    
//    self.replyBtn.handleClickBlock = ^(CommandButton *sender) {
//        if (weakSelf.is_have_quote>0) {
//            BOOL isShow = [weakSelf.moreOprationView isHidden]?YES:NO;
//            [weakSelf toggleMoreOprationView:isShow sender:sender];
//        } else {
//            if (weakSelf.handleReplyBlock) {
//                weakSelf.handleReplyBlock(weakSelf.postVO);
//            }
//        }
//    };
    
//    NSInteger fans = 1;
    
    self.payBtn.handleClickBlock = ^(CommandButton *sender) {
        
        NSLog(@"%ld", weakSelf.postVO.is_following);
        
        if (![Session sharedInstance].isLoggedIn) {
            NSLog(@"弹出登陆框");
            if (weakSelf.handleLikeBlock) {
                weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.postVO.is_like);
            }
            return;
        }
        if (weakSelf.postVO.is_following == 0) {
            weakSelf.payBtn.selected = NO;
            weakSelf.postVO.is_following = 1;
//            weakSelf.fans = 1;
        }else if (weakSelf.postVO.is_following == 1) {
            
            weakSelf.payBtn.selected = YES;
            weakSelf.postVO.is_following = 0;
            
        }
        
        if (weakSelf.handlePayBlock) {
            weakSelf.handlePayBlock(weakSelf.postVO, weakSelf.fans);
        }
        
    };
    
    self.shareBtn.handleClickBlock = ^(CommandButton *sender) {
        if (weakSelf.handleShareBlock) {
            weakSelf.handleShareBlock(weakSelf.postVO);
        }
    };
    
}

@end



@interface ForumOneSelfTableViewCell ()

@property (nonatomic, strong) UILabel *timeTopLabel;
@property (nonatomic, strong) UILabel *mouLabel;

@end

@implementation ForumOneSelfTableViewCell

-(UILabel *)mouLabel{
    if (!_mouLabel) {
        _mouLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _mouLabel.font = [UIFont systemFontOfSize:14];
    }
    return _mouLabel;
}

-(UILabel *)timeTopLabel{
    if (!_timeTopLabel) {
        _timeTopLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    }
    return _timeTopLabel;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumOneSelfTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumOneSelfTableViewCell class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    return dict;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO forumTopicVO:(ForumTopicVO*)forumTopicVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumOneSelfTableViewCell class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    if (forumTopicVO) [dict setObject:forumTopicVO forKey:[self cellKeyForForumTopicVO]];
    return dict;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self.contentView addSubview:self.timeTopLabel];
        [self.contentView addSubview:self.mouLabel];
        [self.contentView addSubview:self.topicNameBtn];
        [self.contentView addSubview:self.tagBackView];
        [self.tagBackView addSubview:self.tag1];
        [self.tagBackView addSubview:self.tag2];
        [self.tagBackView addSubview:self.tag3];
        
        
    }
    return self;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat height = 0;
    //    ForumTopicVO *forumTopicVO = (ForumTopicVO*)[dict objectForKey:[self cellKeyForForumTopicVO]];
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[self cellKeyForPostVO]];
    NSMutableArray *replyVOList = postVO.topReplies;
    
    if ([postVO isKindOfClass:[ForumPostVO class]]) {
        height += 15 + 10;
        CGFloat contentHeight = [self heightForPostContents:postVO.content];
        if (contentHeight>0) {
            height += contentHeight;
            height += 10;
        }
        
        CGFloat picsHeight = 0;
        if ([postVO.attachments count]>0) {
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:postVO.attachments.count];
            for (ForumAttachmentVO *attchmentVO in postVO.attachments) {
                if (attchmentVO.type == ForumAttachTypePics) {
                    [array addObject:attchmentVO];
                }
            }
            picsHeight = [ForumPostAttachmentPicsView rowHeightForPortrait:array];
            if (picsHeight>0) {
                height += picsHeight;
                height += 10;
//                height += 30;
                if (![replyVOList count]>0) {
                    height += 15;
                }
            }
            
            if ([array count]!=[postVO.attachments count]) {
                height += 20;
                height += 10;
                height += 10;
            }
        }
        
        height += 24; //btns
        
        
        
        if (([replyVOList isKindOfClass:[NSMutableArray class]]&&[replyVOList count]>0)||postVO.quote_num>0) {
            height += 12; //arrow height
            
            if (postVO.quote_num>0) {
                NSString *quoteNumString = @"暂无报价";
                height += [quoteNumString sizeWithFont:[UIFont systemFontOfSize:14]].height;
                height += 4;
            }
            if ([replyVOList isKindOfClass:[NSMutableArray class]]&&[replyVOList count]>0) {
                for (ForumPostReplyVO *replyVO in replyVOList) {
                    height += [ForumPostReplyTableCell heightForReplyContent:replyVO];
                    height += 4;
                }
                if (postVO.reply_num>3) {
                    NSString *allReplies = [NSString stringWithFormat:@"展开全部 %ld 条回复",(long)postVO.reply_num];
                    height += [allReplies sizeWithFont:[UIFont systemFontOfSize:13.f]].height;
                    height += 10;
                }
            }
            
            height += 10;//top bottom
        }
        
        height += 40;
    }
    
    return height;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    
    
    CGFloat margin = 10;
    CGFloat left = 15;
    CGSize size = [self.contentLbl sizeThatFits:CGSizeMake(kScreenWidth-30-self.iconButton.width-15, CGFLOAT_MAX)];
    
    self.iconButton.frame = CGRectMake(left, margin, 40, 40);
    
    CGFloat marginTop = self.timestampLbl.bottom;
    
    
    if (![self.arrowView isHidden]) {
//        self.arrowView.backgroundColor = [UIColor redColor];
        self.arrowView.frame = CGRectMake(30 + 50, marginTop+(12-self.arrowView.height), self.arrowView.width, self.arrowView.height);
        marginTop += 12;
        
        CGFloat tmpMarginTop = marginTop;
        
        marginTop += 6;
        
        if (![self.quoteNumLbl isHidden]) {
            [self.quoteNumLbl sizeToFit];
            self.quoteNumLbl.frame = CGRectMake(15+10 + 50, marginTop, self.quoteNumLbl.width, self.quoteNumLbl.height+4);
            marginTop += self.quoteNumLbl.height;
        }
        
        if (![self.reply1Lbl isHidden]) {
            CGSize size = [self.reply1Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
            self.reply1Lbl.frame = CGRectMake(15+10 + 50, marginTop, kScreenWidth-30-20 - 50, size.height+4);
            marginTop += self.reply1Lbl.height;
        }
        
        if (![self.reply2Lbl isHidden]) {
            CGSize size = [self.reply2Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
            self.reply2Lbl.frame = CGRectMake(15+10 + 50, marginTop, kScreenWidth-30-20 - 50, size.height+4);
            marginTop += self.reply2Lbl.height;
        }
        
        if (![self.reply3Lbl isHidden]) {
            CGSize size = size = [self.reply3Lbl sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
            self.reply3Lbl.frame = CGRectMake(15+10 + 50, marginTop, kScreenWidth-30-20 - 50, size.height+4);
            marginTop += self.reply3Lbl.height;
        }
        
        if (![self.allRepliesBtn isHidden]) {
            [self.allRepliesBtn sizeToFit];
            self.allRepliesBtn.frame = CGRectMake(15+10 + 50, marginTop, self.allRepliesBtn.width, self.allRepliesBtn.height+6);
            marginTop += self.allRepliesBtn.height;
        }
        
        marginTop += 4;
        self.bgView.frame = CGRectMake(15 + 50, tmpMarginTop, self.contentView.width-30 - 50, marginTop-tmpMarginTop);
    }
    
    
    
    
    
    
    
    
    CGFloat marginTops = 15;
    if (size.height>0) {
        self.contentLbl.frame = CGRectMake(67, marginTops + 25, kScreenWidth-30-self.iconButton.width-15, size.height+2);
        marginTops += self.contentLbl.height;
        marginTops += 10;
    }
    
    if (!size.height>0) {
        marginTops += 10;
    }
    
    if (![self.picsView isHidden]) {
        self.picsView.frame = CGRectMake(50, marginTops + 25, kScreenWidth, self.picsView.height);
        marginTops += self.picsView.height;
        marginTops += 10;
    }
    
    if (![self.contentAttachmentsBtn isHidden]) {
        [self.contentAttachmentsBtn sizeToFit];
        self.contentAttachmentsBtn.frame = CGRectMake(15, marginTops, self.contentAttachmentsBtn.width, 20);
        marginTops += self.contentAttachmentsBtn.height;
        marginTops += 10;
    }
    
    [self.timestampLbl sizeToFit];
    self.timestampLbl.frame = CGRectMake(15 + self.iconButton.width + 10, marginTops + 50, self.timestampLbl.width, 24);
    
    self.topicNameBtn.frame = CGRectMake(15 + self.iconButton.width + 10, marginTops + 30, 44, 20);
    [self.topicNameBtn setTitle:self.postVO.topic_name forState:UIControlStateNormal];
    self.topicNameBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
    
    self.namesLabel.frame = CGRectMake(left + self.iconButton.width + margin, margin, kScreenWidth - self.iconButton.width - left - margin, 20);
//    self.contentLbl.frame = CGRectMake(left + self.iconButton.width + margin, margin + self.iconButton.height - 20, kScreenWidth - self.iconButton.width - left - margin, size.height+2);
//    self.picsView.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin*2, self.picsView.width, self.picsView.height);
    //    if (self.picsView.height > 1) {
    //        self.timestampLbl.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin * 3 + self.picsView.height, self.timestampLbl.width, self.timestampLbl.height);
    //    } else if (!self.picsView.height < 1) {
    //        self.timestampLbl.frame = CGRectMake(self.iconButton.width + margin, self.iconButton.height + margin * 2, self.timestampLbl.width, self.timestampLbl.height);
    //    }
    
    //    self.moreOprationView.frame = CGRectMake(margin, self.timestampLbl.top-(self.moreOprationView.height-self.timestampLbl.height)/2 + 40, 0, self.moreOprationView.height);
    
    
    self.namesLabel.text = self.postVO.username;
    [self.iconButton sd_setImageWithURL:[NSURL URLWithString:self.postVO.avatar] forState:UIControlStateNormal completed:nil];
    
    self.replyLabel.text = [NSString stringWithFormat:@"%ld", self.postVO.reply_num];
    self.supportLabel.text = [NSString stringWithFormat:@"%ld", self.postVO.like_num];
    
    if (self.postVO.is_like == 1) {
        self.supprotBtn.selected = YES;
    } else if (self.postVO.is_like == 0) {
        self.supprotBtn.selected = NO;
    }
    
    if (self.postVO.is_following == 1) {
        self.payBtn.selected = YES;
    } else if (self.postVO.is_following == 0) {
        self.payBtn.selected = NO;
    }
    
    //    CGFloat marginTop = 15;
    self.iconButton.hidden = YES;
    //    self.namesLabel.frame = CGRectMake(left, margin, kScreenWidth - self.iconButton.width - left - margin, 20);
    self.namesLabel.hidden = YES;
//    self.topicNameBtn.hidden = YES;
    //    self.tag1.hidden = YES;
    //    self.tag2.hidden = YES;
    //    self.tag3.hidden = YES;
    
//    self.tagBackView.hidden = YES;
    self.tagBackView.frame = CGRectMake(15 + self.iconButton.width + 15 + 52, marginTops + 30, kScreenWidth - (15 + self.iconButton.width + 15 + 72), 20);
    
//    self.tag1.hidden = YES;
//    self.tag2.hidden = YES;
//    self.tag3.hidden = YES;
    
    NSLog(@"%lu", self.postVO.forum_tag.length - 2);
    if (self.postVO.forum_tag.length > 0) {
        NSString *tagStr = [self.postVO.forum_tag substringWithRange:NSMakeRange(2, self.postVO.forum_tag.length - 4)];
        NSLog(@"%@", tagStr);
        NSArray *tagArr = [tagStr componentsSeparatedByString:@"\",\""]; //componentsSeparatedByString:
        NSLog(@"%@", tagArr);
        self.tagArr = tagArr;
        //        for (NSString *tagStr in tagArr) {
        //
        ////            UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(15 + self.iconButton.width + 10 + 43, marginTops + 13, 43, 20)];
        ////            [tagLabel sizeToFit];
        ////            tagLabel.backgroundColor = [UIColor orangeColor];
        ////            tagLabel.text = tagStr;
        ////            [self.contentView addSubview:tagLabel];
        //            UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(15 + self.iconButton.width + 10 + 43 * , marginTops + 13, 80, 20)];
        //            tagButton.backgroundColor = [UIColor redColor];
        ////            [tagButton sizeToFit];
        //            [tagButton setTitle:tagStr forState:UIControlStateNormal];
        //            [self.contentView addSubview:tagButton];
        //        }
        
        if (self.tagArr.count == 1) {
            self.tag1.hidden = NO;
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
        }
        
        if (tagArr.count == 2) {
            
            self.tag1.hidden = NO;
            [self.tag1 sizeToFit];
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
            
            self.tag2.hidden = NO;
            [self.tag2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag2.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag2 sizeToFit];
            NSString *tag2 = tagArr[1];
            [self.tag2 setTitle:tag2 forState:UIControlStateNormal];
            self.tag2.frame = CGRectMake(0 + self.tag1.width + 10, 0, self.tag2.width, 20);
        }
        
        if (tagArr.count == 3) {
            
            self.tag1.hidden = NO;
            [self.tag1 sizeToFit];
            [self.tag1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag1.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag1 sizeToFit];
            NSString *tag1 = tagArr[0];
            self.tag1.frame = CGRectMake(0, 0, self.tag1.width, 20);
            [self.tag1 setTitle:tag1 forState:UIControlStateNormal];
            
            self.tag2.hidden = NO;
            [self.tag2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag2.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag2 sizeToFit];
            NSString *tag2 = tagArr[1];
            [self.tag2 setTitle:tag2 forState:UIControlStateNormal];
            self.tag2.frame = CGRectMake(0 + self.tag1.width + 10, 0, self.tag2.width, 20);
            
            self.tag3.hidden = NO;
            [self.tag3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            self.tag3.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.tag3 sizeToFit];
            NSString *tag3 = tagArr[2];
            [self.tag3 setTitle:tag3 forState:UIControlStateNormal];
            self.tag3.frame = CGRectMake(0 + self.tag1.width + self.tag2.width + 10 * 2, 0, self.tag3.width, 20);
            
        }
        //        }
        
    } else {
        self.tag1.hidden = YES;
        self.tag2.hidden = YES;
        self.tag3.hidden = YES;
    }
    
    
    self.timeTopLabel.frame = CGRectMake(left, margin, kScreenWidth - self.iconButton.width - left - margin, 33);
    self.mouLabel.frame = CGRectMake(left + 37, margin + 10, kScreenWidth - self.iconButton.width, 20);
    
//    self.contentLbl.frame = CGRectMake(left + self.iconButton.width + margin, margin + self.iconButton.height, kScreenWidth - self.iconButton.width - left - margin, size.height+2);
//    self.picsView.frame = CGRectMake(left + self.iconButton.width - 5, margin + self.iconButton.height + 30, kScreenWidth - self.iconButton.width - left - margin, self.picsView.height);
    
    
    //    for (NSString *tagStr in (NSArray *)self.postVO.forum_tag) {
    //        UIButton *tagButton = [[UIButton alloc] initWithFrame:CGRectMake(15 + self.iconButton.width + 10 + 43, marginTops + 13, 43, 20)];
    //        [tagButton setTitle:tagStr forState:UIControlStateNormal];
    //    }
    
    
    
    if ([Session sharedInstance].currentUserId==self.postVO.user_id) {
        
        if (self.postVO.isFinshed) {
            self.delBtn.hidden = YES;
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = NO;
            self.replyBtn.hidden = YES;
            self.shareBtn.hidden = YES;
            self.supprotBtn.hidden = YES;
            self.supportLabel.hidden = YES;
            self.replyLabel.hidden = YES;
            
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-15-self.statusBtn.width, marginTops + 40, self.statusBtn.width, 24);
            
        } else {
            self.delBtn.hidden = NO;
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = YES;
            self.replyBtn.hidden = NO;
            self.replyLabel.hidden = NO;
            self.shareBtn.hidden = NO;
            self.supportLabel.hidden = NO;
            self.supprotBtn.hidden = NO;
            
            [self.replyBtn sizeToFit];
            if (kScreenWidth == 320) {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-40, marginTops + 50 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-40, marginTops + 52, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width - 15, marginTops + 50 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-30-45-15, marginTops + 50 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-27-self.replyBtn.width, marginTops + 52, 30, 18);
            } else {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50, marginTops + 50 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-50, marginTops + 52, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width -15, marginTops + 50 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50-45 - 15, marginTops + 50 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-47-self.replyBtn.width, marginTops + 52, 30, 18);
            }
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-self.statusBtn.width - 15, margin, self.statusBtn.width, 24);
        }
        
        
    } else {
        self.delBtn.hidden = YES;
        
        if (self.postVO.isFinshed) {
            self.statusBtn.hidden = NO;
            self.statusBtn.enabled = NO;
            self.replyBtn.hidden = YES;
            self.shareBtn.hidden = YES;
            self.supprotBtn.hidden = YES;
            self.supportLabel.hidden = YES;
            self.replyLabel.hidden = YES;
            
            [self.statusBtn sizeToFit];
            self.statusBtn.frame = CGRectMake(self.contentView.width-15-self.statusBtn.width, marginTops + 40, self.statusBtn.width, 24);
            
        } else {
            self.statusBtn.hidden = YES;
            self.replyBtn.hidden = NO;
            self.replyLabel.hidden = NO;
            self.shareBtn.hidden = NO;
            self.supportLabel.hidden = NO;
            self.supprotBtn.hidden = NO;
            
            [self.replyBtn sizeToFit];
            if (kScreenWidth == 320) {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-40, marginTops + 50 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-40, marginTops + 52, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width - 15, marginTops + 50 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-30-45-15, marginTops + 50 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-27-self.replyBtn.width, marginTops + 52, 30, 18);
            } else {
                self.replyBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50, marginTops + 50 - 15, self.replyBtn.width+2, 24 + 30);
                self.replyBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 0, 15, 0);
                self.replyLabel.frame = CGRectMake(self.contentView.width-15-50, marginTops + 52, 30, 18);
                self.shareBtn.frame = CGRectMake(self.contentView.width-10-self.replyBtn.width -15, marginTops + 50 + 3 - 15, 48, 48);
                self.shareBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supprotBtn.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-50-45 - 15, marginTops + 50 + 3 - 15, 48, 48);
                self.supprotBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 15, 15);
                self.supportLabel.frame = CGRectMake(self.contentView.width-15-self.replyBtn.width-47-self.replyBtn.width, marginTops + 52, 30, 18);
            }
        }
        
        //        if (self.statusVoList) {
        //            self.statusBtn.hidden = NO;
        //        } else {
        //            self.statusBtn.hidden = YES;
        //        }
    }
    [self.delBtn sizeToFit];
    if (kScreenWidth == 320) {
        self.delBtn.frame = CGRectMake(self.supprotBtn.left - 20, marginTops + 40, self.delBtn.width, 24);
    } else {
        self.delBtn.frame = CGRectMake(self.supprotBtn.left - 40, marginTops + 40 + 10, self.delBtn.width, 24);
    }
    
    marginTops += 24;
    
//    if ([Session sharedInstance].currentUserId==self.postVO.user_id) {
        self.payBtn.hidden = YES;
//    } else {
//        self.payBtn.hidden = NO;
//        [self.payBtn sizeToFit];
//        self.payBtn.frame = CGRectMake(self.contentView.width-15-50, margin - 3, 45, 18);
//    }
    
    WEAKSELF;
    
    self.tag1.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagBlock) {
            weakSelf.handleTagBlock(weakSelf.tag1.titleLabel.text);
        }
    };
    
    self.tag2.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagBlock) {
            weakSelf.handleTagBlock(weakSelf.tag2.titleLabel.text);
        }
    };
    
    self.tag3.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagBlock) {
            weakSelf.handleTagBlock(weakSelf.tag3.titleLabel.text);
        }
    };
    
    self.shareBtn.handleClickBlock = ^(CommandButton *sender) {
        if (weakSelf.handleShareBlock) {
            weakSelf.handleShareBlock(weakSelf.postVO);
        }
    };
    
    self.topicNameBtn.handleClickBlock = ^(CommandButton *sender){
        if (weakSelf.handleTagNameBtnBlock) {
            weakSelf.handleTagNameBtnBlock(weakSelf.postVO.topic_id);
        }
    };
    
    self.supprotBtn.handleClickBlock = ^(CommandButton *sender) {
        
        if (![Session sharedInstance].isLoggedIn) {
            if (weakSelf.handleLikeBlock) {
                weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.postVO.is_like);
            }
            return ;
        }
        if (weakSelf.postVO.is_like == 0) {
            
            weakSelf.postVO.is_like = 1;
            weakSelf.supprotBtn.selected = YES;
            weakSelf.postVO.like_num += 1;
            
            if (weakSelf.handleLikeBlock) {
                weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.postVO.is_like);
            }
            
        } else if (weakSelf.postVO.is_like == 1) {
            
            weakSelf.postVO.is_like = 0;
            weakSelf.supprotBtn.selected = NO;
            weakSelf.postVO.like_num -= 1;
            
            if (weakSelf.handleLikeBlock) {
                weakSelf.handleLikeBlock(weakSelf.postVO, weakSelf.postVO.is_like);
            }
        }
        NSLog(@"%ld", weakSelf.isLike);
    };
    
    self.payBtn.handleClickBlock = ^(CommandButton *sender) {
        
        
        if (![Session sharedInstance].isLoggedIn) {
            if (weakSelf.handlePayBlock) {
                weakSelf.handlePayBlock(weakSelf.postVO, weakSelf.fans);
            }
            return ;
        }
        if (weakSelf.postVO.is_following == 0) {
            weakSelf.payBtn.selected = NO;
            weakSelf.postVO.is_following = 1;
        }else if (weakSelf.postVO.is_following == 1) {
            
            weakSelf.payBtn.selected = YES;
            weakSelf.postVO.is_following = 0;
            
        }
        
        if (weakSelf.handlePayBlock) {
            weakSelf.handlePayBlock(weakSelf.postVO, weakSelf.fans);
        }
        
    };
    
    
    
    
}

- (void)updateCellWithDict:(NSDictionary*)dict forumTopicVO:(ForumTopicVO*)forumTopicVO {
    [super updateCellWithDict:dict forumTopicVO:forumTopicVO];
//    ForumPostVO *postVO = [[ForumPostVO alloc] initWithJSONDictionary:dict[@"postVO"]];
//    self.contentLbl.text = postVO.content;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.postVO.timestamp/1000];
    NSString *timeStr = [date formattedDateDay];
    NSLog(@"%@", timeStr);
    if ([timeStr isEqualToString:@"今天"] || [timeStr isEqualToString:@"昨天"]) {
        self.timeTopLabel.text = timeStr;
        self.mouLabel.hidden = YES;
        [_timeTopLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
    } else {
        [_timeTopLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
        self.mouLabel.hidden = NO;
        NSString *dayStr = [timeStr substringWithRange:NSMakeRange(8,2)];
        self.timeTopLabel.text = dayStr;
        //    self.timestampLbl.attributedText = NSStrokeWidthAttributeName ;
        
        NSString *mouStr = [timeStr substringWithRange:NSMakeRange(5, 2)];
        NSString *mouS = @"";
        if ([mouStr isEqualToString:@"01"]) {
            mouS = [NSString stringWithFormat:@"一月"];
        } else if ([mouStr isEqualToString:@"02"]) {
            mouS = [NSString stringWithFormat:@"二月"];
        } else if ([mouStr isEqualToString:@"03"]) {
            mouS = [NSString stringWithFormat:@"三月"];
        } else if ([mouStr isEqualToString:@"04"]) {
            mouS = [NSString stringWithFormat:@"四月"];
        } else if ([mouStr isEqualToString:@"05"]) {
            mouS = [NSString stringWithFormat:@"五月"];
        } else if ([mouStr isEqualToString:@"06"]) {
            mouS = [NSString stringWithFormat:@"六月"];
        } else if ([mouStr isEqualToString:@"07"]) {
            mouS = [NSString stringWithFormat:@"七月"];
        } else if ([mouStr isEqualToString:@"08"]) {
            mouS = [NSString stringWithFormat:@"八月"];
        } else if ([mouStr isEqualToString:@"09"]) {
            mouS = [NSString stringWithFormat:@"九月"];
        } else if ([mouStr isEqualToString:@"10"]) {
            mouS = [NSString stringWithFormat:@"十月"];
        } else if ([mouStr isEqualToString:@"11"]) {
            mouS = [NSString stringWithFormat:@"十一月"];
        } else if ([mouStr isEqualToString:@"12"]) {
            mouS = [NSString stringWithFormat:@"十二月"];
        }
        self.mouLabel.text = mouS;
    }
    
    
    self.timestampLbl.text = [date formattedDateDescription];
    //    self.timeTopLabel.text = @"name";
    if (self.postVO.is_following == 1) {
        self.payBtn.selected = YES;
    } else if (self.postVO.is_following == 0) {
        self.payBtn.selected = NO;
    }
    
    

}
//-(void)setSubsDataWithList:(ForumPostList *)postList{
//    NSLog(@"%@", postList);
//    self.contentLbl.text = postList.content;
//
//    NSDate *date = [NSDate dateWithTimeIntervalSince1970:postList.timestamp/1000];
//    NSString *timeStr = [date formattedDateDay];
//    NSLog(@"%@", timeStr);
//    if ([timeStr isEqualToString:@"今天"] || [timeStr isEqualToString:@"昨天"]) {
//        self.timeTopLabel.text = timeStr;
//        self.mouLabel.hidden = YES;
//        [_timeTopLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
//    } else {
//        [_timeTopLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
//        self.mouLabel.hidden = NO;
//        NSString *dayStr = [timeStr substringWithRange:NSMakeRange(8,2)];
//        self.timeTopLabel.text = dayStr;
//        //    self.timestampLbl.attributedText = NSStrokeWidthAttributeName ;
//        
//        NSString *mouStr = [timeStr substringWithRange:NSMakeRange(5, 2)];
//        NSString *mouS = @"";
//        if ([mouStr isEqualToString:@"01"]) {
//            mouS = [NSString stringWithFormat:@"一月"];
//        } else if ([mouStr isEqualToString:@"02"]) {
//            mouS = [NSString stringWithFormat:@"二月"];
//        } else if ([mouStr isEqualToString:@"03"]) {
//            mouS = [NSString stringWithFormat:@"三月"];
//        } else if ([mouStr isEqualToString:@"04"]) {
//            mouS = [NSString stringWithFormat:@"四月"];
//        } else if ([mouStr isEqualToString:@"05"]) {
//            mouS = [NSString stringWithFormat:@"五月"];
//        } else if ([mouStr isEqualToString:@"06"]) {
//            mouS = [NSString stringWithFormat:@"六月"];
//        } else if ([mouStr isEqualToString:@"07"]) {
//            mouS = [NSString stringWithFormat:@"七月"];
//        } else if ([mouStr isEqualToString:@"08"]) {
//            mouS = [NSString stringWithFormat:@"八月"];
//        } else if ([mouStr isEqualToString:@"09"]) {
//            mouS = [NSString stringWithFormat:@"九月"];
//        } else if ([mouStr isEqualToString:@"10"]) {
//            mouS = [NSString stringWithFormat:@"十月"];
//        } else if ([mouStr isEqualToString:@"11"]) {
//            mouS = [NSString stringWithFormat:@"十一月"];
//        } else if ([mouStr isEqualToString:@"12"]) {
//            mouS = [NSString stringWithFormat:@"十二月"];
//        }
//        self.mouLabel.text = mouS;
//    }
//    
//    
//    self.timestampLbl.text = [date formattedDateDescription];
////    self.timeTopLabel.text = @"name";
//    if (postList.is_following == 1) {
//        self.payBtn.selected = YES;
//    } else if (postList.is_following == 0) {
//        self.payBtn.selected = NO;
//    }
//    
//    
//}

@end



@implementation ForumPostNoReplyTableCell {
    UIImageView *_arrowView;
    UIView *_bgView;
    UILabel *_quoteNumLbl;
    UILabel *_textLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostNoReplyTableCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 40;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 40;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostNoReplyTableCell class]];
    return dict;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostNoReplyTableCell class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    return dict;
}

+ (NSString*)cellKeyForPostVO {
    return @"postVO";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        // Initialization code
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forum_comment_arrow"]];
        [self.contentView addSubview:_arrowView];
        
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        [self.contentView addSubview:_bgView];
        

        _quoteNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _quoteNumLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _quoteNumLbl.text = @"暂无报价";
        _quoteNumLbl.font = [UIFont systemFontOfSize:14];
        _quoteNumLbl.hidden = YES;
        [self.contentView addSubview:_quoteNumLbl];
        
        _textLbl= [[UILabel alloc] initWithFrame:CGRectZero];
        _textLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _textLbl.text = @"暂无回复";
        _textLbl.font = [UIFont systemFontOfSize:14.f];
        _textLbl.textAlignment = NSTextAlignmentLeft;
        _textLbl.hidden = YES;
        [self.contentView addSubview:_textLbl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _arrowView.frame = CGRectMake(30, 0, _arrowView.width, _arrowView.height);
    _bgView.frame = CGRectMake(15, _arrowView.height, self.contentView.width-30, self.contentView.height-_arrowView.height);
    
    _quoteNumLbl.frame = CGRectMake(25, _arrowView.height, self.contentView.width-50, self.contentView.height-_arrowView.height);
    _textLbl.frame = CGRectMake(25, _arrowView.height, self.contentView.width-50, self.contentView.height-_arrowView.height);
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[[self class] cellKeyForPostVO]];
    if (postVO && postVO.quote_num>0) {
        _quoteNumLbl.text = [NSString stringWithFormat:@"已经有%ld人报价",(long)postVO.quote_num];
        _quoteNumLbl.hidden = NO;
        _textLbl.hidden = YES;
    } else {
        _textLbl.hidden = NO;
        _quoteNumLbl.hidden = YES;
    }
    
    [self setNeedsLayout];
}

@end

@implementation ForumPostReplyTableTopCell {
    UIImageView *_arrowView;
    CALayer *_bgLayer;
    UILabel *_quoteNumLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostReplyTableTopCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 14;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 14;
    ForumPostVO *postVO = [dict objectForKey:[self cellKeyForPostVO]];
    if (postVO && postVO.quote_num>0) {
        if (postVO.quote_num>0) {
            NSString *quoteNumString = @"暂无报价";
            height += [quoteNumString sizeWithFont:[UIFont systemFontOfSize:14]].height;
            height += 4;
        }
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostReplyTableTopCell class]];
    return dict;
}

+ (NSDictionary*)buildCellDict:(ForumPostVO*)postVO {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostReplyTableTopCell class]];
    if (postVO)[dict setObject:postVO forKey:[self cellKeyForPostVO]];
    return dict;
}

+ (NSString*)cellKeyForPostVO {
    return @"postVO";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        // Initialization code
        
        _arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"forum_comment_arrow"]];
        [self.contentView addSubview:_arrowView];
        
        _bgLayer = [CALayer layer];
        _bgLayer.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"].CGColor;
        [self.contentView.layer addSublayer:_bgLayer];
        
        _quoteNumLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _quoteNumLbl.textColor = [UIColor colorWithHexString:@"c2a79d"];
        _quoteNumLbl.text = @"暂无报价";
        _quoteNumLbl.font = [UIFont systemFontOfSize:14];
        _quoteNumLbl.hidden = YES;
        [self.contentView addSubview:_quoteNumLbl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _arrowView.frame = CGRectMake(30 + 50, 0, _arrowView.width, _arrowView.height);
    _bgLayer.frame = CGRectMake(15 + 50, _arrowView.height, self.contentView.width-30 - 50, self.contentView.height-_arrowView.height);
    _quoteNumLbl.frame = CGRectMake(25 + 50, _arrowView.height+3, self.contentView.width-50 - 50, self.contentView.height-_arrowView.height);
}

-(void)updateCellWithDict:(NSDictionary *)dict {
    ForumPostVO *postVO = (ForumPostVO*)[dict objectForKey:[[self class] cellKeyForPostVO]];
    if (postVO && postVO.quote_num>0) {
        _quoteNumLbl.text = [NSString stringWithFormat:@"已经有%ld人报价",(long)postVO.quote_num];
        _quoteNumLbl.hidden = NO;
    } else {
        _quoteNumLbl.hidden = YES;
    }
    [self setNeedsLayout];
}
@end

@interface ForumPostReplyTableCell () <MLEmojiLabelDelegate,TTTAttributedLabelDelegate>

@property(nonatomic,weak) UIView *bgView;

@property(nonatomic,weak) UIView *topLineView;
@property(nonatomic, weak) TapDetectingMLEmojiLabel *contentLbl;
@property(nonatomic,strong) NSDataDetector *detector;
@property(nonatomic,strong) NSDataDetector *phoneDetector;
@property(nonatomic,strong) NSArray *urlMatches;
@property(nonatomic,strong) NSArray *phoneMatches;

@property(nonatomic,strong) ForumPostVO *postVO;
@property(nonatomic,strong) ForumPostReplyVO *replyVO;

@end

@implementation ForumPostReplyTableCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostReplyTableCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0;
    ForumPostReplyVO *replyVO = (ForumPostReplyVO*)[dict objectForKey:[self cellKeyForReplyVO]];
    if ([replyVO isKindOfClass:[ForumPostReplyVO class]]) {
        height += [self heightForReplyContent:replyVO];
        height += 8;
    }
    return height;
}

+ (NSDictionary*)buildCellDict:(ForumPostReplyVO*)replyVO  needShowTopSep:(BOOL)needShowTopSep {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostReplyTableCell class]];
    if (replyVO)[dict setObject:replyVO forKey:[self cellKeyForReplyVO]];
    [dict setObject:[NSNumber numberWithBool:needShowTopSep] forKey:[self cellKeyForNeedShowTopSep]];
    return dict;
}

+ (NSString*)cellKeyForReplyVO {
    return @"replyVO";
}

+ (NSString*)cellKeyForNeedShowTopSep {
    return @"needShowTopSep";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
        bgView.backgroundColor = [UIColor colorWithHexString:@"f6f6f6"];
        [self.contentView addSubview:bgView];
        _bgView = bgView;
        
        TapDetectingMLEmojiLabel *contentLbl = [[self class] createReplyLbl];
        contentLbl.emojiDelegate = self;
        contentLbl.delegate = self;
        [self.contentView addSubview:contentLbl];
        _contentLbl = contentLbl;
        
        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectZero];
        topLineView.backgroundColor = [UIColor colorWithHexString:@"abcacb"];
        [self.contentView addSubview:topLineView];
        _topLineView = topLineView;
        
        WEAKSELF;
        void(^handleCopyMenuItemClickedBlock)(TapDetectingMLEmojiLabel *view) = ^(TapDetectingMLEmojiLabel *view){
            
        };
        void(^handleDeleteMenuItemClickedBlock)(TapDetectingMLEmojiLabel *view) = ^(TapDetectingMLEmojiLabel *view){
            if (weakSelf.handleDeleteReplyBlock) {
                weakSelf.handleDeleteReplyBlock(weakSelf.postVO,weakSelf.replyVO);
            }
        };
        
        contentLbl.handleCopyMenuItemClicked = handleCopyMenuItemClickedBlock;
        contentLbl.handleDeleteMenuItemClicked = handleDeleteMenuItemClickedBlock;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _topLineView.frame = CGRectMake(25 + 50, 0, self.contentView.width-50 - 50, 0.25f);
    
    _bgView.frame = CGRectMake(15 + 50, 0, self.contentView.width-30 - 50, self.contentView.height);
    _contentLbl.frame = CGRectMake(25 + 50, 0, self.contentView.width-50 - 50, self.contentView.height);
//    [_contentLbl sizeToFit];
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _topLineView.hidden = YES;
}

- (void)updateCellWithDict:(NSDictionary*)dict postVO:(ForumPostVO*)postVO
{
//    BOOL needShowTopSep = [[dict objectForKey:[[self class] cellKeyForNeedShowTopSep]] boolValue];
//    self.topLineView.hidden = !needShowTopSep;
    self.topLineView.hidden = YES;
    
    ForumPostReplyVO *replyVO = (ForumPostReplyVO*)[dict objectForKey:[[self class] cellKeyForReplyVO]];
    if ([replyVO isKindOfClass:[ForumPostReplyVO class]]) {
        _replyVO = replyVO;
        _postVO = postVO;
        
        
        NSMutableArray *attachRedirectArray = [[NSMutableArray alloc] init];
        
        NSMutableString *attachString = [[NSMutableString alloc] init];
        for (ForumAttachmentVO *attachmentVO in _replyVO.attachments) {
            if ([attachString length]>0) {
                [attachString appendString:@" "];
            }
            if ([attachmentVO.item isKindOfClass:[ForumAttachItemRemindUpgradeVO class]]) {
                NSString *subString = @"请升级新版本";
                [attachString appendString:subString];
                ForumAttachRedirectInfo *redirectInfo = [ForumAttachRedirectInfo allocWithData:NSMakeRange(attachString.length-subString.length-attachRedirectArray.count*3, subString.length-3) redirectUri:APPSTORE_URL];
                [attachRedirectArray addObject:redirectInfo];
            } else if ([attachmentVO.item isKindOfClass:[ForumAttachItemGoodsVO class]]) {
                ForumAttachItemGoodsVO *itemGoodsVO = (ForumAttachItemGoodsVO*)attachmentVO.item;
                NSString *subString = [NSString stringWithFormat:@"[附件]%@",itemGoodsVO.goods_name];
                [attachString appendString:subString];
                ForumAttachRedirectInfo *redirectInfo = [ForumAttachRedirectInfo allocWithData:NSMakeRange(attachString.length-subString.length-attachRedirectArray.count*3, subString.length-3) redirectUri:kURLSchemeGoodsDetail(itemGoodsVO.goods_id)];
                [attachRedirectArray addObject:redirectInfo];
            }
        }
        
        _contentLbl.isShowDelMenuItem = [Session sharedInstance].currentUserId==replyVO.user_id?YES:NO;
        _contentLbl.replyVO = replyVO;
        
        NSString *content = nil;
        if ([replyVO.reply_username length]>0) {
            NSString *replyString = [NSString stringWithFormat:@"%@ 回复 %@：", replyVO.username, replyVO.reply_username];
            if ([replyVO.content length]>0) {
                content = [NSString stringWithFormat:@"%@%@ ", replyString,replyVO.content];
            } else {
                content = replyString;
            }
            if ([attachString length]>0) {
                [_contentLbl setEmojiText:[NSString stringWithFormat:@"%@%@",content,attachString]];
                NSInteger totalLength = _contentLbl.attributedText.length;
                
                UIColor *color = [UIColor colorWithHexString:@"c2a79d"];
                ForumAttachRedirectInfo *lastRedirectInfo = [attachRedirectArray objectAtIndex:attachRedirectArray.count-1];
                NSInteger location = totalLength-(lastRedirectInfo.range.location+lastRedirectInfo.range.length);
                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                    
                    NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                    [_contentLbl addLinkToURL:[NSURL URLWithString:redirectInfo.redirectUri] withRange:range];
                }
                
                NSMutableAttributedString *mutableAttributedString = [_contentLbl.attributedText mutableCopy];
                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                    
                    NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                    [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName
                                                    value:(id)color.CGColor
                                                    range:range];
                }
                _contentLbl.attributedText = mutableAttributedString;
                [_contentLbl setNeedsDisplay];
            } else {
                [_contentLbl setEmojiText:content];
            }
            
            [_contentLbl addLinkToURL:postVO.user_id==_replyVO.user_id?[NSURL URLWithString:@""]:[NSURL URLWithString:kURLSchemeUserHome(replyVO.user_id)] withRange:NSMakeRange(0, replyVO.username.length)];
            
            [_contentLbl addLinkToURL:postVO.user_id==_replyVO.reply_user_id?[NSURL URLWithString:@""]:[NSURL URLWithString:kURLSchemeUserHome(replyVO.reply_user_id)] withRange:NSMakeRange(replyString.length-replyVO.reply_username.length-1, replyVO.reply_username.length+1)];
            
            
        } else {
            if ([replyVO.content length]>0) {
                content = [NSString stringWithFormat:@"%@：%@ ", replyVO.username,replyVO.content];
            } else {
                content = [NSString stringWithFormat:@"%@：", replyVO.username];
            }
            
            if ([attachString length]>0) {
                [_contentLbl setEmojiText:[NSString stringWithFormat:@"%@%@",content,attachString]];
                NSInteger totalLength = _contentLbl.attributedText.length;

                UIColor *color = [UIColor colorWithHexString:@"c2a79d"];
                ForumAttachRedirectInfo *lastRedirectInfo = [attachRedirectArray objectAtIndex:attachRedirectArray.count-1];
                NSInteger location = totalLength-(lastRedirectInfo.range.location+lastRedirectInfo.range.length);
                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                    
                    NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                    [_contentLbl addLinkToURL:[NSURL URLWithString:redirectInfo.redirectUri] withRange:range];
                }
                
                NSMutableAttributedString *mutableAttributedString = [_contentLbl.attributedText mutableCopy];
                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                    
                    NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                    [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName
                                                    value:(id)color.CGColor
                                                    range:range];
                }
                _contentLbl.attributedText = mutableAttributedString;
                [_contentLbl setNeedsDisplay];
                
//                ForumAttachRedirectInfo *lastRedirectInfo = [attachRedirectArray objectAtIndex:attachRedirectArray.count-1];
//                NSInteger location = totalLength-(lastRedirectInfo.range.location+lastRedirectInfo.range.length);
//                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
//                    [_contentLbl addLinkToURL:[NSURL URLWithString:redirectInfo.redirectUri] withRange:NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length)];
//                }
            } else {
                [_contentLbl setEmojiText:content];
            }
            
            [_contentLbl addLinkToURL:postVO.user_id==_replyVO.user_id?[NSURL URLWithString:@""]:[NSURL URLWithString:kURLSchemeUserHome(replyVO.user_id)] withRange:NSMakeRange(0, replyVO.username.length+1)];
        }
        
        [self setNeedsLayout];
    }
}

- (void)mlEmojiLabel:(MLEmojiLabel*)emojiLabel didSelectLink:(NSString*)link withType:(MLEmojiLabelLinkType)type
{
    
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [URLScheme locateWithRedirectUri:[url absoluteString] andIsShare:YES];
}

static MLEmojiLabel *g_replySizeLabel = nil;

+ (MLEmojiLabel*)replySizeLabel {
    if (!g_replySizeLabel) {
        g_replySizeLabel = [self createReplyLbl];
    }
    return g_replySizeLabel;
}

+ (void)replyCleanup {
    g_replySizeLabel = nil;
}

+(CGFloat)heightForReplyContent:(ForumPostReplyVO *)replyVO
{
    NSMutableString *attachString = [[NSMutableString alloc] init];
    for (ForumAttachmentVO *itemVO in replyVO.attachments) {
        if ([attachString length]>0) {
            [attachString appendString:@" "];
        }
        if ([itemVO isKindOfClass:[ForumAttachItemRemindUpgradeVO class]]) {
            [attachString appendString:@"请升级新版本"];
        } else if ([itemVO.item isKindOfClass:[ForumAttachItemGoodsVO class]]) {
            ForumAttachItemGoodsVO *itemGoodsVO = (ForumAttachItemGoodsVO*)itemVO.item;
            [attachString appendString:@"[附件]"];
            [attachString appendString:itemGoodsVO.goods_name];
        }
    }
    
    MLEmojiLabel *label = [self replySizeLabel];
    NSString *content = nil;
    if ([replyVO.reply_username length]>0) {
        NSString *replyString = [NSString stringWithFormat:@"%@ 回复 %@：", replyVO.username, replyVO.reply_username];
        if ([replyVO.content length]>0) {
            content = [NSString stringWithFormat:@"%@%@ ", replyString,replyVO.content];
        } else {
            content = replyString;
        }
    } else {
        if ([replyVO.content length]>0) {
            content = [NSString stringWithFormat:@"%@：%@ ", replyVO.username,replyVO.content];
        } else {
            content = [NSString stringWithFormat:@"%@：", replyVO.username];
        }
    }
    
    label.numberOfLines = 0;
    label.frame = CGRectMake(25, 0, kScreenWidth-30-20, CGFLOAT_MAX);
    if ([attachString length]>0) {
        [label setEmojiText:[NSString stringWithFormat:@"%@%@",content,attachString]];
    } else {
        [label setEmojiText:content];
    }
    CGSize size = [label sizeThatFits:CGSizeMake(kScreenWidth-30-20, CGFLOAT_MAX)];
    return size.height;
}

+ (TapDetectingMLEmojiLabel*)createReplyLbl {
    TapDetectingMLEmojiLabel *contentLbl = [[TapDetectingMLEmojiLabel alloc] initWithFrame:CGRectZero];
    contentLbl.numberOfLines = 0;
    contentLbl.font = [UIFont systemFontOfSize:14.0f];
    contentLbl.lineBreakMode = NSLineBreakByCharWrapping;
    contentLbl.isNeedAtAndPoundSign = YES;
    
    contentLbl.customEmojiRegex = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";
    contentLbl.customEmojiPlistName = @"faceMap_ch.plist";
    contentLbl.customEmojiDictionaryForAttach = @{@"[附件]":@"forum_icon_attach"};
    [contentLbl setEmojiText:@""];
    
    NSMutableDictionary *mutableLinkAttributes = [NSMutableDictionary dictionary];
    [mutableLinkAttributes setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCTUnderlineStyleAttributeName];
    UIColor *commonLinkColor = [UIColor colorWithHexString:@"999999"];
    if ([NSMutableParagraphStyle class]) {
        [mutableLinkAttributes setObject:commonLinkColor forKey:(NSString *)kCTForegroundColorAttributeName];
        //把原有TTT的NSMutableParagraphStyle设置给去掉了。会影响到整个段落的设置
    } else {
        [mutableLinkAttributes setObject:(__bridge id)[commonLinkColor CGColor] forKey:(NSString *)kCTForegroundColorAttributeName];
        //把原有TTT的NSMutableParagraphStyle设置给去掉了。会影响到整个段落的设置
    }
    contentLbl.linkAttributes = mutableLinkAttributes;
    contentLbl.activeLinkAttributes = nil;
    return contentLbl;
}


@end



@interface ForumPostAttachmentPicsView ()
@property(nonatomic,strong) NSArray *attachments;
@end

@implementation ForumPostAttachmentPicsView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSArray *subviews = [self subviews];
    if ([subviews count]>=[_attachments count]) {
        if ([_attachments count]==1) {
            
            ForumAttachmentVO *attachVO = (ForumAttachmentVO*)[_attachments objectAtIndex:0];
            ForumAttachItemPicsVO *picVO = (ForumAttachItemPicsVO*)attachVO.item;
            
            CGFloat height = 192;
            if (picVO.width>0 && picVO.height>0) {
                height = 192.f/picVO.width*picVO.height;
            }
            
            UIView *view = [subviews objectAtIndex:0];
            view.frame = CGRectMake(15, 0, 192, height);
        }
        else if ([_attachments count]==2||[_attachments count]==3) {
            
            CGFloat marginLeft = 15;
            for (NSInteger i=0;i<[_attachments count];i++) {
                UIView *view = [subviews objectAtIndex:i];
                view.frame = CGRectMake(marginLeft, 0, kScreenWidth / 4.2, kScreenWidth / 4.2);
                marginLeft += view.width;
                marginLeft += 5;
            }
        }
        else if ([_attachments count]==4) {
            CGFloat marginLeft = 15;
            CGFloat marginTop = 0;
            for (NSInteger i=0;i<[_attachments count];i++) {
                UIView *view = [subviews objectAtIndex:i];
                view.frame = CGRectMake(marginLeft, marginTop, kScreenWidth / 4.2, kScreenWidth / 4.2);
                marginLeft += view.width;
                marginLeft += 5;
                if (i==1) {
                    marginTop += view.height;
                    marginTop += 5;
                    marginLeft = 15;
                }
            }
        }
        else {
            CGFloat marginLeft = 15;
            CGFloat marginTop = 0;
            for (NSInteger i=0;i<[_attachments count];i++) {
                UIView *view = [subviews objectAtIndex:i];
                view.frame = CGRectMake(marginLeft, marginTop, kScreenWidth / 4.2, kScreenWidth / 4.2);
                marginLeft += view.width;
                marginLeft += 5;
                if ((i+1)%3==0) {
                    marginTop += view.height;
                    marginTop += 5;
                    marginLeft = 15;
                }
            }
        }
    }
}

- (void)updateWithAttachmentPics:(NSArray*)attachments {
    self.attachments = attachments;
    
    NSArray *subviews = [self subviews];
    for (UIView *view in subviews) {
        view.hidden = YES;
    }
    NSInteger count = [subviews count];
    if (count < [attachments count]) {
        for (NSInteger i=count;i<[attachments count];i++) {
            XMWebImageView *view = [[XMWebImageView alloc] initWithFrame:CGRectZero];
            view.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
            view.hidden = YES;
            [self addSubview:view];
        }
    }
    WEAKSELF;
    for (NSInteger i=0;i<[attachments count];i++) {
        ForumAttachmentVO *attachVO = [attachments objectAtIndex:i];
        XMWebImageView *view = (XMWebImageView*)[[self subviews] objectAtIndex:i];
        view.tag = i;
        view.hidden = NO;
        
        CGFloat width = 192;
        CGFloat height = 192;
        if ([attachments count]==1) {
            ForumAttachmentVO *attachVO = (ForumAttachmentVO*)[_attachments objectAtIndex:0];
            ForumAttachItemPicsVO *picVO = (ForumAttachItemPicsVO*)attachVO.item;
            if (picVO.width>0 && picVO.height>0) {
                height = width/picVO.width*picVO.height;
            }
            
            width = width*2;
            height = height*2;
        }
        [view setImageWithURL:((ForumAttachItemPicsVO*)(attachVO.item)).pic_url placeholderImage:nil size:CGSizeMake(width, height) progressBlock:nil succeedBlock:nil failedBlock:nil];
        
        view.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            
            NSMutableArray *imageViewArray = [[NSMutableArray alloc] initWithCapacity:weakSelf.subviews.count];
            for (UIView *view in [weakSelf subviews]) {
                if (![view isHidden]) {
                    [imageViewArray addObject:view];
                }
            }
            
            if (weakSelf.handleSingleTapDetected) {
                weakSelf.handleSingleTapDetected(view.tag,(UIImageView*)[weakSelf viewWithTag:view.tag],imageViewArray);
            }
        };
    }
    
    [self setNeedsLayout];
}

+ (CGFloat)rowHeightForPortrait:(NSArray*)attachments {
    CGFloat height = 0;
    if ([attachments count]>0) {
        if ([attachments count]==1) {
            ForumAttachmentVO *attachVO = (ForumAttachmentVO*)[attachments objectAtIndex:0];
            ForumAttachItemPicsVO *picVO = (ForumAttachItemPicsVO*)attachVO.item;
            
            height = 192;
            if (picVO.width>0 && picVO.height>0) {
                height = 192.f/picVO.width*picVO.height;
            }
        }
        else if ([attachments count]==2||[attachments count]==3) {
            height = kScreenWidth / 4.2;
        }
        else if ([attachments count]==4) {
            height = kScreenWidth / 4.2*2+5;
        }
        else if ([attachments count]>4&&[attachments count]<=6) {
            height = kScreenWidth / 4.2*2+5;
        }
        else {
            height = kScreenWidth / 4.2*3 + 5;
        }
    }
    return height;
}

@end



@implementation ForumPostMoreOprationView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 152, 38);
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor colorWithHexString:@"2c2c2c"];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 3.f;
        
        CommandButton *quoteBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, self.width/2, self.height)];
        [quoteBtn setTitle:@"匿名报价" forState:UIControlStateNormal];
        [quoteBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        quoteBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:quoteBtn];
        
        CommandButton *commentBtn = [[CommandButton alloc] initWithFrame:CGRectMake(self.width/2, 0, self.width/2, self.height)];
        [commentBtn setTitle:@"回复" forState:UIControlStateNormal];
        [commentBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [commentBtn setImage:[UIImage imageNamed:@"forum_topic_comment_icon_white"] forState:UIControlStateNormal];
        commentBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        commentBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:commentBtn];
        
        CALayer *line = [CALayer layer];
        line.backgroundColor = [UIColor blackColor].CGColor;
        [self.layer addSublayer:line];
        line.frame = CGRectMake(self.width/2, 0, 0.5, self.height);
        
        WEAKSELF;
        quoteBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleQuoteBlock) {
                weakSelf.handleQuoteBlock();
            }
        };
        commentBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleReplyBlock) {
                weakSelf.handleReplyBlock();
            }
        };
    }
    return self;
}

@end

#import "LoadingView.h"

@interface ForumPostListNoContentTableCell ()
@property(nonatomic,weak) LoadingView *loadingView;
@end

@implementation ForumPostListNoContentTableCell {
    
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostListNoContentTableCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 44;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 44;
    if ([dict objectForKey:@"cellHeight"]) {
        height = [dict floatValueForKey:@"cellHeight"];
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(CGFloat)cellHeight {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostListNoContentTableCell class]];
    [dict setObject:[NSNumber numberWithFloat:cellHeight] forKey:@"cellHeight"];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _loadingView.frame = self.contentView.bounds;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    [LoadingView loadEndWithNoContent:self.contentView title:@"暂无内容"];
    [self setNeedsLayout];
}

@end


@interface ForumPostSearchTableCell() <UISearchBarDelegate>
@property(nonatomic,weak) UISearchBar *searchBar;
@property (nonatomic, strong) CommandButton *cancelButton;
@end

@implementation ForumPostSearchTableCell //{
//    CommandButton *_cancelButton;
//}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumPostSearchTableCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 44;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 44;
    return height;
}

+ (NSMutableDictionary*)buildCellDict {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumPostSearchTableCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
        // Initialization code
        
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
        searchBar.backgroundColor = [UIColor whiteColor];
        searchBar.placeholder = @"搜索";
        searchBar.showsCancelButton = NO;
        searchBar.delegate = self;
        [self.contentView addSubview:searchBar];
        _searchBar = searchBar;
        
        for (UIView *view in searchBar.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                NSArray *subviews = view.subviews;
                if ([subviews count]>0 && [[subviews objectAtIndex:0] isKindOfClass:NSClassFromString(@"UISearchBarBackground")] ) {
                    [[subviews objectAtIndex:0] removeFromSuperview];
                    break;
                }
            }
        }
        
        WEAKSELF;
        _cancelButton = [[CommandButton alloc] initWithFrame:CGRectZero];
        _cancelButton.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_cancelButton];
        _cancelButton.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf searchBarCancelButtonClicked:weakSelf.searchBar];
        };
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _searchBar.frame = CGRectMake(10, (self.contentView.height-30)/2, self.contentView.width-20, 30);
    
    CGRect frame = CGRectMake(self.contentView.width-54-10, 7, 54, 30);
    _cancelButton.frame = frame;
}

- (void)updateCellWithDict:(NSDictionary *)dict {
    
    [self setNeedsLayout];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self showCancelButton];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
//    searchBar.text = @"";
    if ([searchBar.text length]>0) {
        [self showCancelButton];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    if ([searchBar.text length]>0) {
        [self showCancelButton];

        if (self.handlePostDoSearch) {
            self.handlePostDoSearch(searchBar.text);
        }
        
        [searchBar endEditing:YES];
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar endEditing:YES];
    [self hideCancelButton];
    
    if (self.handlePostCancelSearch) {
        self.handlePostCancelSearch();
    }
}

- (void)showCancelButton {
    _cancelButton.hidden = NO;
    _searchBar.showsCancelButton = YES;
    for (UIView *view in [[_searchBar.subviews lastObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton*)view;
            [btn setTitle:@" 取消 " forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
            
            CGRect frame = CGRectMake(self.contentView.width-54-10, 7, 54, 30);
            _cancelButton.frame = frame;
        }
    }
}

- (void)hideCancelButton {
    _searchBar.showsCancelButton = NO;
    _cancelButton.hidden = YES;
}

@end

@interface ForumOneSelfTodayCell ()

@property (nonatomic, strong) UILabel *todayLabel;
@property (nonatomic, strong) CommandButton *cammerButton;
@property (nonatomic, strong) UIView *bjView;

@end


@implementation ForumOneSelfTodayCell

-(UIView *)bjView{
    if (!_bjView) {
        _bjView = [[UIView alloc] initWithFrame:CGRectZero];
        _bjView.backgroundColor = [UIColor colorWithWhite:0.67 alpha:1];
        _bjView.layer.masksToBounds = YES;
        _bjView.layer.cornerRadius = 5;
    }
    return _bjView;
}

-(CommandButton *)cammerButton{
    if (!_cammerButton) {
        _cammerButton = [[CommandButton alloc] initWithFrame:CGRectZero];
        _cammerButton.backgroundColor = [UIColor lightGrayColor];
        [_cammerButton setImage:[UIImage imageNamed:@"renewCammer_N"] forState:UIControlStateNormal];
        [_cammerButton setImage:[UIImage imageNamed:@"renewCammer_H"] forState:UIControlStateHighlighted];
    }
    return _cammerButton;
}

-(UILabel *)todayLabel{
    if (!_todayLabel) {
        _todayLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_todayLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:25]];
        _todayLabel.text = @"今天";
    }
    return _todayLabel;
}


+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ForumOneSelfTodayCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 44 + 50;
    return rowHeight;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 44 + 50;
    return height;
}

+ (NSMutableDictionary*)buildCellDict {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ForumOneSelfTodayCell class]];
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.todayLabel];
        [self.contentView addSubview:self.bjView];
        [self.bjView addSubview:self.cammerButton];
        
        [self.cammerButton addTarget:self action:@selector(pushCammerControllers) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

-(void)pushCammerControllers{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushCammerTopIconCortroller" object:nil];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat left = 15;
    CGFloat margin = 10;
    
    self.searchBar.hidden = YES;
    self.cancelButton.hidden = YES;
    
    self.todayLabel.frame = CGRectMake(left, margin, kScreenWidth, 20);
    self.cammerButton.frame = CGRectMake(15, 5, 40, 40);
    self.bjView.frame = CGRectMake(margin * 2 + 50, margin + 25, 70, 50);
}

@end











