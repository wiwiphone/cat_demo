//
//  IdleBannerTableViewCell.h
//  XianMao
//
//  Created by WJH on 16/11/4.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecommendVo.h"

@interface IdleBannerTableViewCell : BaseTableViewCell

@property (nonatomic, strong) void(^handleClickBannerBlock)();

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(RecommendVo *)recommendInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;


@end
