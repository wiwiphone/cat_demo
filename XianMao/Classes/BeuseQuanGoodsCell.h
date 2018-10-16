//
//  BeuseQuanGoodsCell.h
//  XianMao
//
//  Created by apple on 16/11/5.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BeuseQuanGoodsCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSMutableArray*)array;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
