//
//  FilterSmallItemModel.h
//  XianMao
//
//  Created by 阿杜 on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilterSmallItemModel : NSObject

@property (nonatomic, assign) NSInteger sortIndex;
@property (nonatomic, copy) NSString * logo_url;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * query_value;
@property (nonatomic, copy) NSString * rate;



+(instancetype)createWithDict:(NSDictionary *)dict;
-(instancetype)initWithDict:(NSDictionary *)dict;

@end
