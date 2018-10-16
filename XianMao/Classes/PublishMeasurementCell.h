//
//  PublishMeasurementCell.h
//  yuncangcat
//
//  Created by apple on 16/7/27.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PublishAttrInfo.h"


@interface PublishMeasurementCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(PublishAttrInfo *)attrInfo dict:(NSDictionary *)textDict;

- (void)updateCellWithDict:(NSDictionary *)dict;

@end
