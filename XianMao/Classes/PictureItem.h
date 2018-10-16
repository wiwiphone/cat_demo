//
//  PictureItem.h
//  XianMao
//
//  Created by simon cai on 29/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureItem : NSObject<NSCoding>

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;
- (NSDictionary*)toDictionary;

@property(nonatomic,assign) NSInteger picId;
@property(nonatomic,copy) NSString *picUrl;
@property(nonatomic,copy) NSString *picDescription;
@property(nonatomic,assign) NSInteger width;
@property(nonatomic,assign) NSInteger height;

@property(nonatomic,assign) BOOL isCer;

@end

#define kPictureItemLocalPicId -10101  //判断发布商品的图片是否缓存在本地沙河目录
