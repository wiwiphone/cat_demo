//
//  ExpandInputCell.h
//  yuncangcat
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PublishAttrInfo.h"

typedef void(^returnInputTextField)(NSString *text, NSInteger attrId);

@interface ExpandInputCell : BaseTableViewCell

@property (nonatomic, copy) returnInputTextField returnInputTextField;

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(PublishAttrInfo *)attrInfo andAttrDict:(NSDictionary *)attrDict;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
