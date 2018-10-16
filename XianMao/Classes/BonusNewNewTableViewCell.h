//
//  BonusNewNewTableViewCell.h
//  XianMao
//
//  Created by apple on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BonusInfo.h"

@interface BonusNewNewTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(BonusInfo*)bonusInfo;
+ (NSString*)cellKeyForBonusInfo;
+ (NSString*)cellKeyForBonusIndex;
+ (NSString*)cellKeyForBonusSeleted;
- (void)updateCellWithDict:(NSDictionary*)dict index:(NSInteger)index;

@end
