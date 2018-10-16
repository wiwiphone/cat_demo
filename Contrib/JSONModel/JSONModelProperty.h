//
//  JSONModelProperty.h
//  CC
//
//  Created by simon cai on 24/4/15.
//  Copyright (c) 2015 simon cai. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 相关知识请参见Runtime文档
 Type Encodings https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html#//apple_ref/doc/uid/TP40008048-CH100-SW1
 Property Type String https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW6
 */
typedef NS_ENUM(NSInteger, JSONModelPropertyValueType) {
    ClassPropertyValueTypeNone = 0,
    ClassPropertyTypeChar,
    ClassPropertyTypeInt,
    ClassPropertyTypeShort,
    ClassPropertyTypeLong,
    ClassPropertyTypeLongLong,
    ClassPropertyTypeUnsignedChar,
    ClassPropertyTypeUnsignedInt,
    ClassPropertyTypeUnsignedShort,
    ClassPropertyTypeUnsignedLong,
    ClassPropertyTypeUnsignedLongLong,
    ClassPropertyTypeFloat,
    ClassPropertyTypeDouble,
    ClassPropertyTypeBool,
    ClassPropertyTypeVoid,
    ClassPropertyTypeCharString,
    ClassPropertyTypeObject,
    ClassPropertyTypeClassObject,
    ClassPropertyTypeSelector,
    ClassPropertyTypeArray,
    ClassPropertyTypeStruct,
    ClassPropertyTypeUnion,
    ClassPropertyTypeBitField,
    ClassPropertyTypePointer,
    ClassPropertyTypeUnknow
};

@interface JSONModelProperty : NSObject
@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) JSONModelPropertyValueType valueType;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, assign) Class objectClass;
@property (nonatomic, retain) NSArray *objectProtocols;
@property (nonatomic, assign) BOOL isReadonly;

- (id)initWithName:(NSString *)name typeString:(NSString *)typeString;

@end


