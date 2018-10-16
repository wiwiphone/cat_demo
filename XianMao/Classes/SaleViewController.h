//
//  SaleViewController.h
//  XianMao
//
//  Created by simon cai on 11/10/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "RecommendViewController.h"
#import "DataListViewController.h"

#import "BaseTableViewCell.h"

@interface SaleViewController : DataListViewController

- (void)showPublishGoodsView;

@end


@interface SaleTableViewCell : BaseTableViewCell
+ (NSMutableDictionary*)buildCellDict:(UIImage*)image;
@end


//
///recommend/launch_list[GET] 获取启动配置信息 ｛list｝
///recommend/publish_info[GET] 获取发布配置信息 ｛list｝
//UserBasicInfoVo增加score