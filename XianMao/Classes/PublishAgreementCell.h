//
//  PublishAgreementCell.h
//  XianMao
//
//  Created by Marvin on 17/3/24.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PublishAgreementCell : BaseTableViewCell

@property (nonatomic, copy) void(^handleCircleBtnClickBlock)(BOOL isYES);

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSMutableDictionary*)buildCellDict;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end
