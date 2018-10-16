//
//  ExpandYiJianCell.h
//  yuncangcat
//
//  Created by apple on 16/8/12.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PublishAttrInfo.h"

typedef void(^yijianpipei)(NSMutableDictionary *dict);
typedef void(^yijianEndEdit)(NSString *text, NSInteger attrId);

@interface ExpandYiJianCell : BaseTableViewCell

@property (nonatomic, copy) yijianpipei yijianpipei;
@property (nonatomic, copy) yijianEndEdit yijianEndEdit;

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(PublishAttrInfo *)attrInfo brandId:(NSInteger)brandId cateId:(NSInteger)cateId;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
