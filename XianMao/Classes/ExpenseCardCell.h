//
//  ExpenseCardCell.h
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AccountCard.h"

@interface ExpenseCardCell : BaseTableViewCell

@property (nonatomic, copy) void (^handleRechargeBlock)(AccountCard * accountCard);

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict:(AccountCard *)accountCard selected:(BOOL)isYesSelect;
+ (NSString*)cellDictKeyForCardInfo;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
