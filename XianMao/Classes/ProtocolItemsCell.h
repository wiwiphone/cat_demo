//
//  ProtocolItemsCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ProtocolItemsCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * itemsLabel;



+ (NSString *)reuseIdentifier;
+(CGFloat)rowHeightForPortrait:(NSDictionary *)dict;
+(NSMutableDictionary *)buildCellTitle:(NSString *)items;
-(void)updateCellWithDict:(NSDictionary *)dict;
@end
