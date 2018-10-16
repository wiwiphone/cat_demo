//
//  PublishPromptCell.h
//  yuncangcat
//
//  Created by apple on 17/1/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PublishPromptCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellText:(NSString *)text;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
