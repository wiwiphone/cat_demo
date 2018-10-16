//
//  CommentCell.h
//  XianMao
//
//  Created by simon cai on 11/11/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CommentVo.h"

@interface CommentTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDictNoTopLine:(CommentVo*)commentVo;
+ (NSMutableDictionary*)buildCellDict:(CommentVo*)commentVo;
+ (NSString*)cellKeyForComment;
+ (NSString*)cellKeyForIsShowTopLine;

@property(nonatomic,copy) void(^handleCopyCommentBlock)(CommentVo *comment);
@property(nonatomic,copy) void(^handleDelCommentBlock)(CommentVo *comment);


- (void)updateCellWithDict:(NSDictionary *)dict;

@end
