//
//  RecoverBrandCell.h
//  XianMao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "RecoveryItem.h"
#import "RecoveryPreference.h"

@interface BrandLabel : UIButton

@end

@interface RecoverBrandCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(RecoveryItem*)item andPreference:(RecoveryPreference *)preference;
- (void)updateCellWithDict:(NSDictionary *)dict;

@property (nonatomic, strong) BrandLabel *nameLabel;

@end

