//
//  Cities.m
//  XianMao
//
//  Created by simon on 12/5/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "Cities.h"
#import "NSDictionary+Additions.h"

@implementation NSDictionary (Province)

- (NSString*)provinceID {
    return [self stringValueForKey:@"provinceID"];
}
- (NSString*)provinceName {
    return [self stringValueForKey:@"provinceName"];
}
- (NSArray*) cityList {
    return [self arrayValueForKey:@"cityList"];
}

@end

@implementation NSDictionary (City)

- (NSString*)cityID {
    return [self stringValueForKey:@"cityID"];
}
- (NSString*)cityName {
    return [self stringValueForKey:@"cityName"];
}
- (NSArray*) districtList {
    return [self arrayValueForKey:@"districtList"];
}

@end

@implementation NSDictionary (District)

- (NSString*)districtID {
    return [self stringValueForKey:@"districtID"];
}
- (NSString*)district {
    return [self stringValueForKey:@"district"];
}

@end



