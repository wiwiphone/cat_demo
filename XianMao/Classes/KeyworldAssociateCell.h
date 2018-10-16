//
//  KeyworldAssociateCell.h
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface KeyworldAssociateCell : BaseTableViewCell

@property (nonatomic, copy) void(^keyworldsDidSelected)(NSString * keyworlds);

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+(NSMutableDictionary *)buildCellDict:(NSString *)keyworlds searchKeyworlds:(NSString *)searchKeyworlds;
-(void)updateCellWithDict:(NSDictionary *)dict;


@end
