//
//  HandsetCell.h
//  XianMao
//
//  Created by 阿杜 on 16/9/14.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AddressInfo.h"

@interface HandsetCell : BaseTableViewCell

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(AddressInfo *)addressInfo;
-(void)updateCellWithDict:(NSDictionary *)dict;

@end
