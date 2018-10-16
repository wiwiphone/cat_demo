//
//  RecoverTableViewCell.h
//  XianMao
//
//  Created by apple on 16/1/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "HighestBidVo.h"

@interface RecoverTableViewCell : BaseTableViewCell

+ (NSDictionary*)buildCellDict:(HighestBidVo*)bidVO;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
