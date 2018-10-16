//
//  GoodsAboutCell.h
//  XianMao
//
//  Created by 阿杜 on 16/9/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface GoodsAboutCell : BaseTableViewCell

@property (nonatomic, copy) void(^handleDoubtImageViewBlock)();

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(NSString *)attrName attrValue:(NSString *)attrValue isExpand:(NSInteger)isExpand;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
