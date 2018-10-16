//
//  recoveryItem.h
//  XianMao
//
//  Created by apple on 16/3/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface RecoveryItem : JSONModel

@property (nonatomic, copy) NSString *query_value;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *logo_url;
@property (nonatomic, assign) NSInteger is_selected;

@end
