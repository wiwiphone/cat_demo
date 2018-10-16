//
//  PreferenceInJson.h
//  XianMao
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface PreferenceInJson : JSONModel

@property (nonatomic, assign) NSInteger qv;
@property (nonatomic, copy) NSString *qk;

@end
