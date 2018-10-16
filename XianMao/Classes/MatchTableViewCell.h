//
//  MatchTableViewCell.h
//  XianMao
//
//  Created by apple on 16/1/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"
#import "RecommendUser.h"

@interface MatchTableViewCell : BaseTableViewCell

+ (NSDictionary*)buildCellDict:(RecommendUser*)recommendUser;
- (void)updateCellWithDict:(NSDictionary *)dict;

@end
