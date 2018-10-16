//
//  ImageDescDO.h
//  XianMao
//
//  Created by simon cai on 19/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PictureItem.h"

@interface ImageDescDO : NSObject

@property(nonatomic,strong) PictureItem *picItem;
@property(nonatomic,copy) NSString *redirectUri;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

@interface ImageDescGroup : NSObject

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *iconUrl;
@property(nonatomic,assign) BOOL isExpandable; //是否可以展开
@property(nonatomic,assign) BOOL isExpanded;   //默认是否展开
@property(nonatomic,strong) NSArray *items; //ImageDescDO(s)

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end

/*
 
 ImageDescDO
 {
    PictureItem
    redirectUri //跳转
 }
 
 ImageDescGroup
 title;
 iconUrl;
 isExpandable; //是否可以展开
 isExpanded;   //默认是否展开
 items; //ImageDescDO(s)
 
 brand: main_pic_width main_pic_height
 
 ImageDescGroups
 
 */

