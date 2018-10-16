//
//  JSONModel.h
//  CC
//
//  Created by simon cai on 24/4/15.
//  Copyright (c) 2015 simon cai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONModelKeyMapper : NSObject

- (id)initWithDictionary:(NSDictionary *)dict;

- (NSString *)modelKeyMappedFromJsonKey:(NSString *)jsonKey;
- (NSString *)jsonKeyMappedFromModelKey:(NSString *)modelKey;

@end


extern NSString * const JSONModelErrorDomain;

typedef NS_ENUM(int, JSONModelErrorCode) {
    JSONModelErrorCodeNilInput = 1,
    JSONModelErrorCodeDataInvalid = 2
};

@interface JSONModelError : NSError

+ (id)errorNilInput;
+ (id)errorDataInvalidWithDescription:(NSString *)description;

@end


@interface JSONModel : NSObject

+ (id)modelWithJSONDictionary:(NSDictionary *)dict;
+ (id)modelWithJSONDictionary:(NSDictionary *)dict error:(NSError **)error;

- (id)initWithJSONDictionary:(NSDictionary *)dict;
- (id)initWithJSONDictionary:(NSDictionary *)dict error:(NSError **)error;

- (NSDictionary *)toJSONDictionary;

- (void)setTreatBoolAsStringWhenModelToJSON:(BOOL)treatBoolAsStringWhenModelToJSON;

+ (JSONModelKeyMapper *)modelKeyMapper;

@end


@interface NSArray(JSONModel)

/*!
 将JSON转过来的一个数组转换成相应的model类型的数组，支持多级内嵌的模式
 简单的形式，字典的数组转换成model的数组:
 [{},{},{}] ===> [m1,m2,m3]
 
 也可能是nested的数组
 [[{},{}],[{},{}],[{}]] ===> [[m1,m2],[m3,m4],[m5]]
 
 从上面也可以看出局限性，就是数组或者内嵌数组中的元素转换后的目标model类型必须是同种类型
 */
- (NSArray *)modelArrayWithClass:(Class)modelClass;

- (NSArray *)toJSONArray;

@end


@interface NSDictionary(JSONModel)

/*!
 将JSON转过来的一个字典中的每一个key都转换成相应类型的model对象，不支持嵌套
 转换过程为:
 {key1:{},key2:{}} ===> {key1:m1,key2:m2}
 
 当然每一个key所对应的value转换后的model类型须为同一个类型
 */
- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass;

- (NSDictionary *)toJSONDictionary;

@end






