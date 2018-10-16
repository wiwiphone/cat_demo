//
//  MineSeekCell.h
//  XianMao
//
//  Created by apple on 17/2/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "NeedModel.h"

@interface MineSeekCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NeedModel *)needModel;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
