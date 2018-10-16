//
//  GoodsAboutDescCell.h
//  XianMao
//
//  Created by WJH on 16/10/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface GoodsAboutDescCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSString*)contentText;

- (void)updateCellWithDict:(NSDictionary *)dict;
@end
