//
//  BonusTableViewCell.h
//  XianMao
//
//  Created by simon on 2/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "BonusInfo.h"

@interface BonusTableViewCell : BaseTableViewCell

@property (nonatomic ,strong) UIButton * selectButton;

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(BonusInfo*)bonusInfo BonusSeleted:(BOOL)BonusSeleted isHaveUnableLbl:(BOOL)isHaveUnableLbl;
+ (NSString*)cellKeyForBonusInfo;
+ (NSString*)cellKeyForBonusIndex;
+ (NSString*)cellKeyForBonusSeleted;
- (void)updateCellWithDict:(NSDictionary*)dict index:(NSInteger)index;

@property (nonatomic, assign) BOOL isHaveUnableLbl;
@end
