//
//  AddressInfo.m
//  XianMao
//
//  Created by simon on 12/5/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "AddressInfo.h"
#import "NSDictionary+Additions.h"

@implementation AddressInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.addressId = [dict integerValueForKey:@"address_id" defaultValue:0];
        self.receiver = [dict stringValueForKey:@"receiver"];
        self.phoneNumber = [dict stringValueForKey:@"phone"];
        self.areaCode = [dict stringValueForKey:@"area_code"];
        self.areaDetail = [dict stringValueForKey:@"area_detail"];
        self.zipcode = [dict stringValueForKey:@"zipcode"];
        self.address = [dict stringValueForKey:@"address" defaultValue:@""];
        self.isDefault = [dict boolValueForKey:@"isdefault" defaultValue:NO];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        self.addressId = 0;
        self.isDefault = NO;
    }
    return self;
}

- (NSMutableDictionary*)toDict {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInteger:self.addressId] forKey:@"address_id"];
    [dict setObject:self.receiver?self.receiver:[NSNull null] forKey:@"receiver"];
    [dict setObject:self.phoneNumber?self.phoneNumber:[NSNull null] forKey:@"phone"];
    [dict setObject:self.areaCode?self.areaCode:[NSNull null] forKey:@"area_code"];
    [dict setObject:self.areaDetail?self.areaDetail:[NSNull null] forKey:@"area_detail"];
    [dict setObject:self.zipcode?self.zipcode:[NSNull null] forKey:@"zipcode"];
    [dict setObject:self.address?self.address:[NSNull null] forKey:@"address"];
    [dict setObject:[NSNumber numberWithInteger:self.isDefault?1:0] forKey:@"isdefault"];
    return dict;
}


#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        //        self.userId = [[decoder decodeObjectForKey:@"userId"] integerValue];
        //        self.userName = [decoder decodeObjectForKey:@"userName"];
        //        self.avatarUrl = [decoder decodeObjectForKey:@"avatarUrl"];
        //        self.phoneNumber = [decoder decodeObjectForKey:@"phoneNumber"];
        //        self.birthday = [decoder decodeObjectForKey:@"birthday"];
        //        self.gender = [[decoder decodeObjectForKey:@"gender"] integerValue];
        //        self.status = [[decoder decodeObjectForKey:@"status"] integerValue];
        //
        //        self.goodsNum = [[decoder decodeObjectForKey:@"goodsNum"] integerValue];
        //        self.soldNum = [[decoder decodeObjectForKey:@"soldNum"] integerValue];
        //        self.likesNum = [[decoder decodeObjectForKey:@"likesNum"] integerValue];
        //        self.followingsNum = [[decoder decodeObjectForKey:@"followingsNum"] integerValue];
        //        self.fansNum = [[decoder decodeObjectForKey:@"fansNum"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    //    [encoder encodeObject:[NSNumber numberWithInteger:self.userId]  forKey:@"userId"];
    //    [encoder encodeObject:self.userName forKey:@"userName"];
    //    [encoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    //    [encoder encodeObject:self.phoneNumber forKey:@"phoneNumber"];
    //    [encoder encodeObject:self.birthday forKey:@"birthday"];
    //    [encoder encodeObject:[NSNumber numberWithInteger:self.gender] forKey:@"gender"];
    //    [encoder encodeObject:[NSNumber numberWithInteger:self.status] forKey:@"status"];
    //
    //    [encoder encodeObject:[NSNumber numberWithInteger:self.goodsNum] forKey:@"goodsNum"];
    //    [encoder encodeObject:[NSNumber numberWithInteger:self.soldNum] forKey:@"soldNum"];
    //    [encoder encodeObject:[NSNumber numberWithInteger:self.likesNum] forKey:@"likesNum"];
    //    [encoder encodeObject:[NSNumber numberWithInteger:self.followingsNum] forKey:@"followingsNum"];
    //    [encoder encodeObject:[NSNumber numberWithInteger:self.fansNum] forKey:@"fansNum"];
}

@end
