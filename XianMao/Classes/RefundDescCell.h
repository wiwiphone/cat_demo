//
//  RefundDescCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "getrderReturnsModel.h"

@interface RefundDescCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * refundDescLbl;


+ (NSString *)reuseIdentifier;
+(CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;
+ (NSMutableDictionary*)buildCellDict:(getrderReturnsModel *)getrderReturnsModel;
@end
