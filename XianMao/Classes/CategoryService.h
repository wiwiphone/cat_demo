//
//  CategoryService.h
//  XianMao
//
//  Created by simon cai on 17/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkManager.h"

@interface CategoryService : NSObject

+ (void)getAttrInfoList:(NSInteger)cateId
             completion:(void (^)(NSArray *attrInfoList))completion
                failure:(void (^)(XMError *error))failure;

+ (void)getCateList:(void (^)(NSDictionary *data))completion
            failure:(void (^)(XMError *error))failure;

+ (void)getCateSample:(NSInteger)cateId
           completion:(void (^)(NSArray *sampleList))completion
              failure:(void (^)(XMError *error))failure;

+ (void)getArecoveryAttrInfoList:(NSInteger)cateId
                      completion:(void (^)(NSArray *attrInfoList))completion
                         failure:(void (^)(XMError *error))failure;

@end


//category/attr_info_list?cate_id=27[GET] {cate_id} 发布时类目下的属性
//

@interface BrandService : NSObject

+ (void)getBrandList:(NSInteger)cateId
          completion:(void (^)(NSArray *brandList))completion
             failure:(void (^)(XMError *error))failure;

@end


@interface CateSampleVo : NSObject

@property(nonatomic,copy) NSString *explain;
@property(nonatomic,copy) NSString *picUrl;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end



