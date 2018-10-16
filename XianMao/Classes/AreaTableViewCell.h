//
//  AreaTableViewCell.h
//  XianMao
//
//  Created by simon on 12/5/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

typedef enum {
    AreaTableTypeUnknown = -1,
    AreaTableTypeProvince = 0,
    AreaTableTypeCity = 1,
    AreaTableTypeDistrict = 2,
} AreaTableType;

@interface AreaTableViewCell : BaseTableViewCell

+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(NSDictionary*)areaData AreaTableType:(AreaTableType)type;
- (void)updateCellWithDict:(NSDictionary*)dict;

@end

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

