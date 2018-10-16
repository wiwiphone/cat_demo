//
//  Share.h
//  XianMao
//
//  Created by WJH on 16/12/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface Share : JSONModel

@property (nonatomic, assign) NSInteger height;
@property (nonatomic, copy) NSString * image_url;
@property (nonatomic, copy) NSString * redirect_uri;
@property (nonatomic, copy) NSString * source;
@property (nonatomic, copy) NSString * subtitle;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, assign) NSInteger width;

@end
