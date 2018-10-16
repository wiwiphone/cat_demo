//
//  ApproveTagInfo.h
//  XianMao
//
//  Created by simon cai on 29/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApproveTagInfo : NSObject<NSCoding>

@property(nonatomic,assign) NSInteger tagId;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *value;
@property(nonatomic,copy) NSString *iconUrl;
@property(nonatomic,copy) NSString *desc;

+ (NSMutableArray*)createWithDictArray:(NSArray*)dicts;
+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

- (UIImage*)localTagIcon;

@end

