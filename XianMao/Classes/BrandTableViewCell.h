//
//  BrandTableViewCell.h
//  XianMao
//
//  Created by simon on 2/13/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecommendInfo.h"
#import "Command.h"

@interface BrandTableViewCell : BaseTableViewCell

@property(nonatomic,copy) void(^handleFilterItemTapDetected)(RedirectInfo *redirectInfo);

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(NSArray*)redirectItems;
+ (NSString*)cellKeyForedRidrectItems;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end


@interface BrandItemView : TapDetectingView

@property(nonatomic,strong) RedirectInfo *redirectInfo;

- (void)updateWithRedirectInfo:(RedirectInfo*)item;

@end