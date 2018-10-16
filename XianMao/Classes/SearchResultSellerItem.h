//
//  SearchResultSellerItem.h
//  XianMao
//
//  Created by simon cai on 8/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#include "RedirectInfo.h"

@interface SearchResultSellerItem : NSObject

@property(nonatomic,strong) User *sellerInfo;
@property(nonatomic,strong) NSArray *redirectList;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end


@interface RecommendSellerInfo : SearchResultSellerItem

@end