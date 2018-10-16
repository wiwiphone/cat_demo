//
//  AddressInfo.h
//  XianMao
//
//  Created by simon on 12/5/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddressInfo : NSObject

@property(nonatomic,assign) NSInteger addressId;
@property(nonatomic,copy)   NSString *areaCode;
@property(nonatomic,copy)   NSString *areaDetail;
@property(nonatomic,copy)   NSString *receiver;
@property(nonatomic,copy)   NSString *phoneNumber;
@property(nonatomic,copy)   NSString *address;
@property(nonatomic,copy)   NSString *zipcode;
@property(nonatomic,assign) BOOL isDefault;


+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;
- (NSMutableDictionary*)toDict;

@end
