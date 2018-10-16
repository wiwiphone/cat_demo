//
//  Cities.h
//  XianMao
//
//  Created by simon on 12/5/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Province)

- (NSString*)provinceID;
- (NSString*)provinceName;
- (NSArray*) cityList;

@end

@interface NSDictionary (City)

- (NSString*)cityID;
- (NSString*)cityName;
- (NSArray*) districtList;

@end

@interface NSDictionary (District)

- (NSString*)districtID;
- (NSString*)district;

@end


