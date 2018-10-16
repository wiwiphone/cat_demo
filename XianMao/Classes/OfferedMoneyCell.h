//
//  OfferedMoneyCell.h
//  XianMao
//
//  Created by apple on 16/2/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HighestBidVo.h"

@interface OfferedMoneyCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict;
+ (NSDictionary*)buildCellDict:(HighestBidVo*)bidVO;
- (void)updateCellWithDict:(HighestBidVo *)bidVO;

@end
