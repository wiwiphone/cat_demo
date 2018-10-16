//
//  PhotoTipListVo.h
//  yuncangcat
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JSONModel.h"

@interface PhotoTipListVo : JSONModel

@property (nonatomic, copy) NSString *categoryName;
@property (nonatomic, strong) NSArray *tipItemList;

@end
