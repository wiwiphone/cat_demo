//
//  ExpandTableViewCell.h
//  yuncangcat
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ExpandTableViewCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(NSMutableArray *)listArr andCateId:(NSInteger)cateId andBrandId:(NSInteger)brandId;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
