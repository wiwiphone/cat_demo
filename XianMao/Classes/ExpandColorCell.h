//
//  ExpandColorCell.h
//  yuncangcat
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PublishAttrInfo.h"
#import "XMWebImageView.h"

typedef void(^clickColor)(XMWebImageView *sender);

@interface ExpandColorCell : BaseTableViewCell

@property (nonatomic, copy) clickColor clickColor;

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(PublishAttrInfo *)attrInfo andDict:(NSDictionary *)attDict;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
