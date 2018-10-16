//
//  ExpandCell.h
//  yuncangcat
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PublishAttrInfo.h"
#import "AttrListInfo.h"
#import "Command.h"

typedef void(^getAttrInfo)(CommandButton *sender, NSInteger isMutChoose);

@interface ExpandCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(PublishAttrInfo *)attrInfo dict:(NSDictionary *)attrDict;
-(void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, copy) getAttrInfo getAttrInfo;

@end
