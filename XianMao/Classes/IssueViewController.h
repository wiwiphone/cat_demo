//
//  IssueViewController.h
//  XianMao
//
//  Created by apple on 16/1/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface IssueViewController : BaseViewController

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, assign) NSInteger cate_id;
@property (nonatomic, assign) NSInteger brand_id;
@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, copy) NSString *brandName;
@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, assign) BOOL releaseIndex;

@end
