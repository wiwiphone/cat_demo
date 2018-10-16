//
//  RecommendButlerCell.h
//  XianMao
//
//  Created by apple on 16/4/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AdviserPage.h"

@interface RecommendButlerCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(AdviserPage *)viserPage;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
