//
//  CommentCell.m
//  XianMao
//
//  Created by simon cai on 11/11/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "CommentTableViewCell.h"

#import "NSDate+Category.h"

#import "DataSources.h"
#import "CoordinatingController.h"
#import "ForumPostTableViewCell.h"

#import "CoordinatingController.h"
#import "URLScheme.h"

#import "Session.h"

@interface CommentTableViewCell () <MLEmojiLabelDelegate,TTTAttributedLabelDelegate>
@property(nonatomic,strong) CALayer *topLine;
@property(nonatomic,strong) XMWebImageView *avatarView;
@property(nonatomic,strong) UILabel *nickNameLbl;
@property(nonatomic,strong) UILabel *timestampLbl;
@property(nonatomic,strong) TapDetectingMLEmojiLabel *contentLbl;
@property(nonatomic,strong) CommentVo *comment;
@end

@implementation CommentTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([CommentTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat rowHeight = 50.f;
    NSObject *obj = [dict objectForKey:[self cellKeyForComment]];
    if ([obj isKindOfClass:[CommentVo class]]) {
        rowHeight = [CommentTableViewCell calculateHeightAndLayoutSubviews:nil item:(CommentVo*)obj];
    }
    return rowHeight;
}

+ (NSString*)cellKeyForComment {
    return @"item";
}

+ (NSString*)cellKeyForIsShowTopLine {
    return @"isShowTopLine";
}

+ (NSMutableDictionary*)buildCellDictNoTopLine:(CommentVo*)commentVo {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[CommentTableViewCell class]];
    if (commentVo) [dict setObject:commentVo forKey:[self cellKeyForComment]];
    [dict setObject:[NSNumber numberWithBool:NO] forKey:[self cellKeyForIsShowTopLine]];
    return dict;
}
+ (NSMutableDictionary*)buildCellDict:(CommentVo*)commentVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[CommentTableViewCell class]];
    if (commentVo) [dict setObject:commentVo forKey:[self cellKeyForComment]];
    [dict setObject:[NSNumber numberWithBool:YES] forKey:[self cellKeyForIsShowTopLine]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _avatarView = [[XMWebImageView alloc] initWithFrame:CGRectNull];
        _avatarView.layer.masksToBounds=YES;
        _avatarView.layer.cornerRadius=30.f/2.f;    //最重要的是这个地方要设成imgview高的一半
        _avatarView.backgroundColor = [DataSources globalPlaceholderBackgroundColor];
        _avatarView.userInteractionEnabled = YES;
        _avatarView.clipsToBounds = YES;
        _avatarView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_avatarView];
        
        self.nickNameLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.nickNameLbl.backgroundColor = [UIColor clearColor];
        self.nickNameLbl.textColor = [UIColor colorWithHexString:@"333333"];
        self.nickNameLbl.font = [DataSources commentNickNameFont];
        [self.contentView addSubview:self.nickNameLbl];
        
        self.timestampLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        self.timestampLbl.backgroundColor = [UIColor clearColor];
        self.timestampLbl.textColor = [UIColor colorWithHexString:@"a7a7a7"];
        self.timestampLbl.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.timestampLbl];
        
        _contentLbl = [ForumPostReplyTableCell createReplyLbl];
        _contentLbl.backgroundColor = [UIColor clearColor];
        _contentLbl.emojiDelegate = self;
        _contentLbl.delegate = self;
        _contentLbl.textColor = [UIColor colorWithHexString:@"555555"];
        [self.contentView addSubview:_contentLbl];
        
        _topLine = [CALayer layer];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
        [self.contentView.layer addSublayer:_topLine];
        
        WEAKSELF;
        _avatarView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
            [[CoordinatingController sharedInstance] gotoUserHomeViewController:weakSelf.comment.user_id animated:YES];
        };
        
        _contentLbl.handleCopyMenuItemClicked = ^(TapDetectingMLEmojiLabel *view) {
            if (weakSelf.comment) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = weakSelf.comment.content;
            }
            if (weakSelf.handleCopyCommentBlock) {
                weakSelf.handleCopyCommentBlock(weakSelf.comment);
            }
        };
        
        _contentLbl.handleDeleteMenuItemClicked = ^(TapDetectingMLEmojiLabel *view) {
            if (weakSelf.handleDelCommentBlock) {
                weakSelf.handleDelCommentBlock(weakSelf.comment);
            }
        };
    }
    return self;
}

- (void)dealloc
{
    self.avatarView = nil;
    self.nickNameLbl = nil;
    self.contentLbl = nil;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.avatarView.frame = CGRectNull;
    self.nickNameLbl.frame = CGRectNull;
    self.contentLbl.frame = CGRectNull;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [CommentTableViewCell calculateHeightAndLayoutSubviews:self item:self.comment];
}

+ (CGFloat)calculateHeightAndLayoutSubviews:(CommentTableViewCell*)cell item:(CommentVo*)comment
{
    if (cell) {
        cell.avatarView.frame = CGRectMake(15, 15, 30, 30);
        cell.topLine.frame = CGRectMake(55, 0, kScreenWidth-55, 0.5);
    }
    
    CGFloat marginTop = 14.f;
    CGFloat marginLeft = 55;
    
    NSString *nickName = comment?comment.username:cell.nickNameLbl.text;
    CGSize nickNameSize = [nickName sizeWithFont:[DataSources commentNickNameFont]
                                 constrainedToSize:CGSizeMake(kScreenWidth-marginLeft-15.f,MAXFLOAT)
                                     lineBreakMode:NSLineBreakByWordWrapping];
    
    if (cell) {
        cell.nickNameLbl.frame = CGRectMake(55, marginTop, nickNameSize.width, nickNameSize.height);
        [cell.timestampLbl sizeToFit];
        cell.timestampLbl.frame = CGRectMake(cell.nickNameLbl.right+8, cell.nickNameLbl.top, cell.timestampLbl.width, cell.nickNameLbl.height);
    }
    
    marginTop += nickNameSize.height;
    marginTop += 5;
    
    if (cell) {
        
        NSMutableArray *attachRedirectArray = [[NSMutableArray alloc] init];
        
        NSMutableString *attachString = [[NSMutableString alloc] init];
        for (ForumAttachmentVO *attachmentVO in comment.attachments) {
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
        
        cell.contentLbl.isShowDelMenuItem = [Session sharedInstance].currentUserId==comment.user_id?YES:NO;
        
        NSString *content = nil;
        if ([comment.reply_username length]>0) {
            NSString *replyString = [NSString stringWithFormat:@"回复 %@：", comment.reply_username];
            if ([comment.content length]>0) {
                content = [NSString stringWithFormat:@"%@%@ ", replyString,comment.content];
            } else {
                content = replyString;
            }
            if ([attachString length]>0) {
                [cell.contentLbl setEmojiText:[NSString stringWithFormat:@"%@%@",content,attachString]];
                NSInteger totalLength = cell.contentLbl.attributedText.length;
                
                UIColor *color = [UIColor colorWithHexString:@"c2a79d"];
                ForumAttachRedirectInfo *lastRedirectInfo = [attachRedirectArray objectAtIndex:attachRedirectArray.count-1];
                NSInteger location = totalLength-(lastRedirectInfo.range.location+lastRedirectInfo.range.length);
                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                    
                    NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                    [cell.contentLbl addLinkToURL:[NSURL URLWithString:redirectInfo.redirectUri] withRange:range];
                }
                
                NSMutableAttributedString *mutableAttributedString = [cell.contentLbl.attributedText mutableCopy];
                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                    
                    NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                    [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName
                                                    value:(id)color.CGColor
                                                    range:range];
                }
                cell.contentLbl.attributedText = mutableAttributedString;
                [cell.contentLbl setNeedsDisplay];
            } else {
                [cell.contentLbl setEmojiText:content];
            }
            
//            [cell.contentLbl addLinkToURL:postVO.user_id==_replyVO.user_id?[NSURL URLWithString:@""]:[NSURL URLWithString:kURLSchemeUserHome(comment.user_id)] withRange:NSMakeRange(0, comment.username.length)];
            
            [cell.contentLbl addLinkToURL:[NSURL URLWithString:kURLSchemeUserHome(comment.reply_user_id)] withRange:NSMakeRange(replyString.length-comment.reply_username.length-1, comment.reply_username.length+1)];
            
            
        } else {
            if ([comment.content length]>0) {
                content = comment.content;
            } else {
                content = @"";
            }
            
            if ([attachString length]>0) {
                [cell.contentLbl setEmojiText:[NSString stringWithFormat:@"%@%@",content,attachString]];
                NSInteger totalLength = cell.contentLbl.attributedText.length;
                
                UIColor *color = [UIColor colorWithHexString:@"c2a79d"];
                ForumAttachRedirectInfo *lastRedirectInfo = [attachRedirectArray objectAtIndex:attachRedirectArray.count-1];
                NSInteger location = totalLength-(lastRedirectInfo.range.location+lastRedirectInfo.range.length);
                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                    
                    NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                    [cell.contentLbl addLinkToURL:[NSURL URLWithString:redirectInfo.redirectUri] withRange:range];
                }
                
                NSMutableAttributedString *mutableAttributedString = [cell.contentLbl.attributedText mutableCopy];
                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                    
                    NSRange range = NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length);
                    [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName
                                                    value:(id)color.CGColor
                                                    range:range];
                }
                cell.contentLbl.attributedText = mutableAttributedString;
                [cell.contentLbl setNeedsDisplay];
                
                //                ForumAttachRedirectInfo *lastRedirectInfo = [attachRedirectArray objectAtIndex:attachRedirectArray.count-1];
                //                NSInteger location = totalLength-(lastRedirectInfo.range.location+lastRedirectInfo.range.length);
                //                for (ForumAttachRedirectInfo *redirectInfo in attachRedirectArray) {
                //                    [_contentLbl addLinkToURL:[NSURL URLWithString:redirectInfo.redirectUri] withRange:NSMakeRange(location+redirectInfo.range.location, redirectInfo.range.length)];
                //                }
            } else {
                [cell.contentLbl setEmojiText:content];
            }
//            
//            [cell.contentLbl addLinkToURL:postVO.user_id==comment.user_id?[NSURL URLWithString:@""]:[NSURL URLWithString:kURLSchemeUserHome(comment.user_id)] withRange:NSMakeRange(0, comment.username.length+1)];
    
        }
        
        CGSize size = [cell.contentLbl sizeThatFits:CGSizeMake(kScreenWidth-55-15, CGFLOAT_MAX)];
        cell.contentLbl.frame = CGRectMake(55, marginTop, kScreenWidth-55-15, size.height+4);
        marginTop += cell.contentLbl.height;
    } else {
        CGFloat height = [[self class] heightForContent:comment];
        marginTop += height;
    }
    marginTop += 14;
    
    return marginTop;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    [URLScheme locateWithRedirectUri:[url absoluteString] andIsShare:YES];
}

- (void)updateCellWithDict:(NSDictionary *)dict
{
    if (dict) {
        BOOL isShowTopLine = [dict boolValueForKey:@"isShowTopLine"];
        NSObject *obj = [dict objectForKey:@"item"];
        if ([obj isKindOfClass:[CommentVo class]]) {
            CommentVo *comment = (CommentVo*)obj;
            _comment = comment;
            _nickNameLbl.text = comment.username;
            
            NSDate *date = [NSDate dateWithTimeIntervalSince1970:comment.create_time/1000];
            _timestampLbl.text = [date formattedDateDescription];
            _topLine.hidden = !isShowTopLine;
            [_avatarView setImageWithURL:comment.avatar_url placeholderImage:[DataSources globalPlaceHolderSeller] XMWebImageScaleType:XMWebImageScale80x80];
            
//            self.nickNameLbl.text = ((Comment*)obj).nickName;
//            self.contentLbl.text = ((Comment*)obj).content;
        }
    }
    [self setNeedsLayout];
}

+(CGFloat)heightForContent:(CommentVo *)comment
{
    NSMutableString *attachString = [[NSMutableString alloc] init];
    for (ForumAttachmentVO *itemVO in comment.attachments) {
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
    
    MLEmojiLabel *label = [ForumPostReplyTableCell replySizeLabel];
    NSString *content = nil;
    if ([comment.reply_username length]>0) {
        NSString *replyString = [NSString stringWithFormat:@"回复 %@：", comment.reply_username];
        if ([comment.content length]>0) {
            content = [NSString stringWithFormat:@"%@%@ ", replyString,comment.content];
        } else {
            content = replyString;
        }
    } else {
        if ([comment.content length]>0) {
            content = comment.content;
        } else {
            content = @"";
        }
    }
    
    label.numberOfLines = 0;
    label.frame = CGRectMake(55, 0, kScreenWidth-55-15, CGFLOAT_MAX);
    if ([attachString length]>0) {
        [label setEmojiText:[NSString stringWithFormat:@"%@%@",content,attachString]];
    } else {
        [label setEmojiText:content];
    }
    CGSize size = [label sizeThatFits:CGSizeMake(kScreenWidth-55-15, CGFLOAT_MAX)];
    return size.height;
}


@end




