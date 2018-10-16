//
//  ConsignOrder.m
//  XianMao
//
//  Created by simon on 12/2/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ConsignOrder.h"
#import "NSDictionary+Additions.h"

@implementation ConsignOrder

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.consignId = [dict stringValueForKey:@"consign_id"];
        self.createTime = [dict longLongValueForKey:@"create_time"];
        self.picList = [dict arrayValueForKey:@"pic_list"];
        self.status = [dict integerValueForKey:@"status"];
        self.statusIems = [dict arrayValueForKey:@"status_list"];
    }
    return self;
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
}

@end


@implementation NSDictionary (ConsignOrderStatus)

- (NSInteger)consignOrderStatus {
    return [self integerValueForKey:@"status" defaultValue:0];
}
- (NSString*)consignOrderSummary {
    return [self stringValueForKey:@"summary" defaultValue:@""];
}
- (NSString*)consignOrderContent {
    return [self stringValueForKey:@"content" defaultValue:@""];
}

@end




