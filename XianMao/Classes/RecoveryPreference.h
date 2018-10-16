//
//  RecoveryPreference.h
//  XianMao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface RecoveryPreference : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *query_key;
@property (nonatomic, assign) NSInteger multi_selected;
@property (nonatomic, strong) NSArray *items;

@end
