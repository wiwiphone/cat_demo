//
//  NoticeCell.h
//  XianMao
//
//  Created by simon on 11/22/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@class Notice;
@interface NoticeTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(Notice*)item;
+ (NSString*)cellDictKeyForNotice;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
