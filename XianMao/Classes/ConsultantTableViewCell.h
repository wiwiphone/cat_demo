//
//  ConsultantTableViewCell.h
//  XianMao
//
//  Created by apple on 16/3/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AdviserPage.h"

typedef void(^pushChatViewController)(NSInteger userId, AdviserPage *adviserPage);

@interface ConsultantTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(AdviserPage*)adviserPage;
-(void)upDataWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) pushChatViewController pushChatViewController;

@end
