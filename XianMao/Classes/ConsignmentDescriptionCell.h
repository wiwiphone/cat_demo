//
//  ConsignmentDescriptionCell.h
//  XianMao
//
//  Created by WJH on 17/2/8.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"


typedef void(^textViewReturnText)(NSString *textViewText);

@interface ConsignmentDescriptionCell : BaseTableViewCell
@property (nonatomic, copy) textViewReturnText returnText;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
