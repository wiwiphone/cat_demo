//
//  JSONModel.m
//  CC
//
//  Created by simon cai on 24/4/15.
//  Copyright (c) 2015 simon cai. All rights reserved.
//

#import <objc/runtime.h>
#import "JSONModel.h"
#import "JSONModelProperty.h"


@interface JSONModelKeyMapper()
@property(strong,nonatomic) NSMutableDictionary *jsonToModelMap;
@property(strong,nonatomic) NSMutableDictionary *modelToJsonMap;

@end

@implementation JSONModelKeyMapper

- (id)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self != nil) {
        self.jsonToModelMap = [[NSMutableDictionary alloc] initWithDictionary:dict];
        self.modelToJsonMap = [[NSMutableDictionary alloc] initWithCapacity:[dict count]];
        for (NSString *key in dict) {
            self.modelToJsonMap[dict[key]] = key;
        }
    }
    return self;
}


- (NSString *)modelKeyMappedFromJsonKey:(NSString *)jsonKey{
    NSString *mapped =  [self.jsonToModelMap objectForKey:jsonKey];
    return mapped ? mapped : jsonKey;
}

- (NSString *)jsonKeyMappedFromModelKey:(NSString *)modelKey{
    NSString *mapped = [self.modelToJsonMap objectForKey:modelKey];
    return mapped ? mapped : modelKey;
}

@end


NSString * const JSONModelErrorDomain = @"JSONModelErrorDomain";

@implementation JSONModelError
+ (JSONModelError *)errorNilInput{
    return [JSONModelError errorWithDomain:JSONModelErrorDomain code:JSONModelErrorCodeNilInput userInfo:@{NSLocalizedDescriptionKey: @"用于创建JSONModel的参数为nil"}];
}

+ (JSONModelError *)errorDataInvalidWithDescription:(NSString *)description{
    return [JSONModelError errorWithDomain:JSONModelErrorDomain code:JSONModelErrorCodeDataInvalid userInfo:@{NSLocalizedDescriptionKey: description}];
}
@end


NSString * const JSONModelBoolStringTrue = @"true";
NSString * const JSONModelBoolStringFalse = @"false";



//下面两个静态无需初始化，因为用于关联对象的key的时候只会用到其地址
static const char * kAssociatedMapperKey;
static const char * kAssociatedPropertiesKey;

@interface JSONModel(){
    BOOL _treatBoolAsStringWhenModelToJSON;
}

@end

@implementation JSONModel

#pragma mark -
#pragma mark Private
- (void)_setupKeyMapper{
    if (objc_getAssociatedObject(self.class, &kAssociatedMapperKey) == nil) {
        JSONModelKeyMapper *keyMapper = [self.class modelKeyMapper];
        if (keyMapper != nil) {
            objc_setAssociatedObject(self.class, &kAssociatedMapperKey, keyMapper, OBJC_ASSOCIATION_RETAIN);
        }
    }
}

- (void)_setupPropertyMap{
    if (objc_getAssociatedObject(self.class, &kAssociatedPropertiesKey) == nil) {
        
        NSMutableDictionary *propertyMap = [NSMutableDictionary dictionary];
        
        Class class = [self class];
        
        while (class != [JSONModel class]) {
            unsigned int propertyCount;
            objc_property_t *properties = class_copyPropertyList(class, &propertyCount);
            for (unsigned int i = 0; i < propertyCount; i++) {
                
                objc_property_t property = properties[i];
                const char *propertyName = property_getName(property);
                NSString *name = [NSString stringWithUTF8String:propertyName];
                //属性的相关属性都在propertyAttrs中，包括其类型，protocol，存取修饰符等信息
                const char *propertyAttrs = property_getAttributes(property);
                NSString *typeString = [NSString stringWithUTF8String:propertyAttrs];
                JSONModelProperty *modelProperty = [[JSONModelProperty alloc] initWithName:name typeString:typeString];
                if (!modelProperty.isReadonly) {
                    [propertyMap setValue:modelProperty forKey:modelProperty.name];
                }
            }
            free(properties);
            
            class = [class superclass];
        }
        objc_setAssociatedObject(self.class, &kAssociatedPropertiesKey, propertyMap, OBJC_ASSOCIATION_RETAIN);
    }
}


//根据对应的属性类型，将value进行转换成合适的值
- (id)valueForProperty:(JSONModelProperty *)property withJSONValue:(id)value{
    id resultValue = value;
    if (value == nil || [value isKindOfClass:[NSNull class]]) {
        resultValue = nil;
    }else{
        if (property.valueType != ClassPropertyTypeObject) {
            /*当属性为原始数据类型而对应的json dict中的value的类型为字符串对象的时候
             则对字符串进行相应的转换*/
            if ([value isKindOfClass:[NSString class]]) {
                if (property.valueType == ClassPropertyTypeInt ||
                    property.valueType == ClassPropertyTypeUnsignedInt||
                    property.valueType == ClassPropertyTypeShort||
                    property.valueType == ClassPropertyTypeUnsignedShort) {
                    resultValue = [NSNumber numberWithInt:[(NSString *)value intValue]];
                }
                if (property.valueType == ClassPropertyTypeLong ||
                    property.valueType == ClassPropertyTypeUnsignedLong ||
                    property.valueType == ClassPropertyTypeLongLong ||
                    property.valueType == ClassPropertyTypeUnsignedLongLong){
                    resultValue = [NSNumber numberWithLongLong:[(NSString *)value longLongValue]];
                }
                if (property.valueType == ClassPropertyTypeFloat) {
                    resultValue = [NSNumber numberWithFloat:[(NSString *)value floatValue]];
                }
                if (property.valueType == ClassPropertyTypeDouble) {
                    resultValue = [NSNumber numberWithDouble:[(NSString *)value doubleValue]];
                }
                if (property.valueType == ClassPropertyTypeChar) {
                    //对于BOOL而言，@encode(BOOL) 为 c 也就是signed char
                    resultValue = [NSNumber numberWithBool:[(NSString *)value boolValue]];
                }
            }
        }else{
            Class valueClass = property.objectClass;
            //当当前属性为TBJSONModel类型
            if ([valueClass isSubclassOfClass:[JSONModel class]] &&
                [value isKindOfClass:[NSDictionary class]]) {
                resultValue = [[valueClass alloc] initWithJSONDictionary:value];
            }
            
            //当当前属性为NSString类型，而对应的json的value为非NSString对象，自动进行转换
            if ([valueClass isSubclassOfClass:[NSString class]] &&
                ![value isKindOfClass:[NSString class]]) {
                resultValue = [NSString stringWithFormat:@"%@",value];
            }
            
            //当当前属性为NSNumber类型，而对应的json的value为NSString的时候
            if ([valueClass isSubclassOfClass:[NSNumber class]] &&
                [value isKindOfClass:[NSString class]]) {
                NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                resultValue = [numberFormatter numberFromString:value];
            }
            
            NSString *valueProtocol = [property.objectProtocols lastObject];
            if ([valueProtocol isKindOfClass:[NSString class]]) {
                Class valueProtocolClass = NSClassFromString(valueProtocol);
                if (valueProtocolClass != nil) {
                    if ([valueProtocolClass isSubclassOfClass:[JSONModel class]]) {
                        //array of models
                        if ([value isKindOfClass:[NSArray class]]) {
                            resultValue = [(NSArray *)value modelArrayWithClass:valueProtocolClass];
                        }
                        //dictionary of models
                        if ([value isKindOfClass:[NSDictionary class]]) {
                            resultValue = [(NSDictionary *)value modelDictionaryWithClass:valueProtocolClass];
                        }
                    }
                }
            }
        }
    }
    return resultValue;
}

#pragma mark -
#pragma mark Class Method
+ (id)modelWithJSONDictionary:(NSDictionary *)dict{
    return [self modelWithJSONDictionary:dict error:NULL];
}

+ (id)modelWithJSONDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)error{
    return [[self alloc] initWithJSONDictionary:dict error:error];
}

#pragma mark -
#pragma mark Init
- (id)init{
    self = [super init];
    if (self != nil) {
        [self _setupKeyMapper];
        [self _setupPropertyMap];
    }
    return self;
}

- (id)initWithJSONDictionary:(NSDictionary *)dict{
    return [self initWithJSONDictionary:dict error:NULL];
}

- (id)initWithJSONDictionary:(NSDictionary *)dict error:(NSError *__autoreleasing *)error{
    
    if (!dict) {
        if (error) {
            *error = [JSONModelError errorNilInput];
        }
        return nil;
    }
    
    if (![dict isKindOfClass:[NSDictionary class]]) {
        if (error) {
            *error = [JSONModelError errorDataInvalidWithDescription:@"输入参数类型数错，应该为NSDictionary"];
        }
        return nil;
    }
    
    self = [self init];
    if (self != nil) {
        NSDictionary *propertyMap = objc_getAssociatedObject(self.class, &kAssociatedPropertiesKey);
        JSONModelKeyMapper *keyMapper = objc_getAssociatedObject(self.class, &kAssociatedMapperKey);
        
        //对所有属性进行遍历，到dict中找到对应的值，分别进行设置
        for (JSONModelProperty *modelProperty in [propertyMap allValues]) {
            NSString *jsonKey = modelProperty.name;
            if (keyMapper != nil) {
                jsonKey = [keyMapper jsonKeyMappedFromModelKey:jsonKey];
            }
            
            id jsonValue = [dict objectForKey:jsonKey];
            id propertyValue = [self valueForProperty:modelProperty withJSONValue:jsonValue];
            if (propertyValue != nil) {
                [self setValue:propertyValue forKey:modelProperty.name];
            }
        }
    }
    return self;
}

- (NSDictionary *)toJSONDictionary{
    NSDictionary *propertyMap = objc_getAssociatedObject(self.class, &kAssociatedPropertiesKey);
    if (propertyMap!= nil && [propertyMap count] > 0) {
        NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionaryWithCapacity:[propertyMap count]];
        JSONModelKeyMapper *keyMapper = objc_getAssociatedObject(self.class, &kAssociatedMapperKey);
        
        for (JSONModelProperty *property in [propertyMap allValues]) {
            NSString *dictKey = property.name;
            id val = [self valueForKeyPath:dictKey];
            
            if ([val isKindOfClass:[JSONModel class]]) {
                val = [(JSONModel *)val toJSONDictionary];
            }else if([val isKindOfClass:[NSArray class]]){
                val = [(NSArray *)val toJSONArray];
            }else if([val isKindOfClass:[NSDictionary class]]){
                val = [(NSDictionary *)val toJSONDictionary];
            }
            
            if (keyMapper != nil) {
                NSString *mappedKey = [keyMapper jsonKeyMappedFromModelKey:dictKey];
                if (mappedKey != nil) {
                    dictKey = mappedKey;
                }
            }
            
            if (val != nil && dictKey != nil) {
                if (property.valueType == ClassPropertyTypeChar) {
                    if (_treatBoolAsStringWhenModelToJSON &&
                        [val isKindOfClass:[NSNumber class]]) {
                        NSString *booleanString = nil;
                        if ([val boolValue]) {
                            booleanString = JSONModelBoolStringTrue;
                        }else{
                            booleanString = JSONModelBoolStringFalse;
                        }
                        [jsonDictionary setObject:booleanString forKey:dictKey];
                    }else{
                        [jsonDictionary setObject:val forKey:dictKey];
                    }
                }else{
                    [jsonDictionary setObject:val forKey:dictKey];
                }
            }
        }
        return jsonDictionary;
    }
    return nil;
}

- (void)setTreatBoolAsStringWhenModelToJSON:(BOOL)treatBoolAsStringWhenModelToJSON{
    _treatBoolAsStringWhenModelToJSON = treatBoolAsStringWhenModelToJSON;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self.class allocWithZone:zone] initWithJSONDictionary:[self toJSONDictionary] error:NULL];
}

#pragma mark -
#pragma mark Key-Value Coding

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"WARNING: [%@] Set value:%@ for undefiend key: %@",NSStringFromClass(self.class) ,value, key);
}

- (id)valueForUndefinedKey:(NSString *)key {
    NSLog(@"WARNING: [%@] Get value for undefiend key %@", self, key);
    return nil;
}

- (void)setNilValueForKey:(NSString *)key{
    NSLog(@"WARNING: set nil value for key %@", key);
}

- (NSString *)description{
    return [NSString stringWithFormat:@"%@",[self toJSONDictionary]];
}

+ (JSONModelKeyMapper *)modelKeyMapper{
    return nil;
}
@end


@implementation NSArray(JSONModel)

- (NSArray *)modelArrayWithClass:(Class)modelClass{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (id object in self) {
        if ([object isKindOfClass:[NSArray class]]) {
            [modelArray addObject:[object modelArrayWithClass:modelClass]];
        }else if ([object isKindOfClass:[NSDictionary class]]){
            [modelArray addObject:[[modelClass alloc] initWithJSONDictionary:object]];
        }else{
            [modelArray addObject:object];
        }
    }
    return modelArray;
}


- (NSArray *)toJSONArray{
    NSMutableArray *jsonArray = [NSMutableArray array];
    
    for (id object in self) {
        if ([object isKindOfClass:[JSONModel class]]) {
            NSDictionary *objectDict = [(JSONModel *)object toJSONDictionary];
            [jsonArray addObject:objectDict];
        }else if ([object isKindOfClass:[NSArray class]]){
            [jsonArray addObject:[object toJSONArray]];
        }else{
            [jsonArray addObject:object];
        }
    }
    
    return jsonArray;
}

@end


@implementation NSDictionary(JSONModel)

- (NSDictionary *)modelDictionaryWithClass:(Class)modelClass{
    NSMutableDictionary *modelDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSDictionary class]]) {
            [modelDictionary setObject:[[modelClass alloc] initWithJSONDictionary:object] forKey:key];
        }else if ([object isKindOfClass:[NSArray class]]){
            [modelDictionary setObject:[object modelArrayWithClass:modelClass] forKey:key];
        }else{
            [modelDictionary setObject:object forKey:key];
        }
    }
    return modelDictionary;
}

- (NSDictionary *)toJSONDictionary{
    NSMutableDictionary *jsonDictionary = [NSMutableDictionary dictionary];
    for (NSString *key in self) {
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[JSONModel class]]) {
            [jsonDictionary setObject:[(JSONModel *)object toJSONDictionary] forKey:key];
        }else if ([object isKindOfClass:[NSArray class]]){
            [jsonDictionary setObject:[(NSArray *)object toJSONArray] forKey:key];
        }else{
            [jsonDictionary setObject:object forKey:key];
        }
    }
    return jsonDictionary;
}

@end




