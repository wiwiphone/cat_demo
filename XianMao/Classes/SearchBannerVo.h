//
//  SearchBannerVo.h
//  XianMao
//
//  Created by apple on 16/9/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface SearchBannerVo : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, copy) NSString *image_url;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, copy) NSString *redirect_uri;
@property (nonatomic, copy) NSString *source;

@end
