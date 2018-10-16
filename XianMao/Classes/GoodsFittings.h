//
//  GoodsFittings.h
//  XianMao
//
//  Created by apple on 16/6/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface GoodsFittings : JSONModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) CGFloat price;
@property (nonatomic, copy) NSString *pic;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *info;
@property (nonatomic, assign) NSInteger type;

@end
