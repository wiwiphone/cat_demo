//
//  RedirectInfo.m
//  XianMao
//
//  Created by simon cai on 29/3/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "RedirectInfo.h"

@implementation RedirectInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        _imageUrl = [dict stringValueForKey:@"image_url"];
        _redirectUri = [dict stringValueForKey:@"redirect_uri"];
        _width = [dict floatValueForKey:@"width" defaultValue:0];
        _height = [dict floatValueForKey:@"height" defaultValue:0];
        _title = [dict stringValueForKey:@"title"];
        _subTitle = [dict stringValueForKey:@"subtitle"];
        _source = [dict stringValueForKey:@"source"];
        _url = [dict stringValueForKey:@"url"];
        _viewCode = [dict integerValueForKey:@"viewCode"];
        _regionCode = [dict integerValueForKey:@"regionCode"];
        _referPageCode = [dict integerValueForKey:@"referPageCode"];
    }
    return self;
}

-(BOOL)isNewComposition{
    if (self.width == 0) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark -
#pragma mark NSCoding

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        _imageUrl = [decoder decodeObjectForKey:@"imageUrl"];
        _redirectUri = [decoder decodeObjectForKey:@"redirectUri"];
        _width = [[decoder decodeObjectForKey:@"width"] floatValue];
        _height = [[decoder decodeObjectForKey:@"height"] floatValue];
        _title = [decoder decodeObjectForKey:@"title"];
        _subTitle = [decoder decodeObjectForKey:@"subTitle"];
        _source = [decoder decodeObjectForKey:@"source"];
        _url = [decoder decodeObjectForKey:@"url"];
        _viewCode = [decoder decodeIntegerForKey:@"viewCode"];
        _regionCode = [decoder decodeIntegerForKey:@"regionCode"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:_imageUrl?_imageUrl:@"" forKey:@"imageUrl"];
    [encoder encodeObject:_redirectUri?_redirectUri:@"" forKey:@"redirectUri"];
    [encoder encodeObject:[NSNumber numberWithFloat:_width] forKey:@"width"];
    [encoder encodeObject:[NSNumber numberWithFloat:_height] forKey:@"height"];
    [encoder encodeObject:_title?_title:@"" forKey:@"title"];
    [encoder encodeObject:_subTitle?_subTitle:@"" forKey:@"subTitle"];
    [encoder encodeObject:_source?_source:@"" forKey:@"source"];
    [encoder encodeObject:_url?_url:@"" forKey:@"url"];
    [encoder encodeInteger:_viewCode forKey:@"viewCode"];
    [encoder encodeInteger:_regionCode forKey:@"regionCode"];
}

- (void)redirect
{
    
}

- (NSDictionary*)toDictionary
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:_imageUrl?_imageUrl:@"" forKey:@"image_url"];
    [dict setObject:_redirectUri?_redirectUri:@"" forKey:@"redirect_uri"];
    [dict setObject:[NSNumber numberWithInteger:_width] forKey:@"width"];
    [dict setObject:[NSNumber numberWithInteger:_height] forKey:@"height"];
    [dict setObject:_title?_title:@"" forKey:@"title"];
    [dict setObject:_subTitle?_subTitle:@"" forKey:@"subtitle"];
    [dict setObject:_source?_source:@"" forKey:@"source"];
    [dict setObject:_url?_url:@"" forKey:@"url"];
    [dict setObject:@(_viewCode) forKey:@"viewCode"];
    [dict setObject:@(_regionCode) forKey:@"regionCode"];
    [dict setObject:@(_referPageCode) forKey:@"referPageCode"];
    return dict;
}

- (CGFloat)scaledWidth {
    return [[self class] width:self];
}
- (CGFloat)scaledHeight {
    return [[self class] height:self];
}

//宽度以320为基准
+ (CGFloat)width:(RedirectInfo*)redirectInfo
{
    CGFloat width = 0;
    CGFloat ratio = 0.f;
    if (redirectInfo.width == 0) {
        ratio = 1.f;
    } else if (redirectInfo.width <= 1){
        ratio = redirectInfo.width;
    } else {
        ratio = (redirectInfo.width>320.f?320.f:redirectInfo.width)/320.f;
    }
    
    NSInteger ratioN = ratio*10000;
    width = kScreenWidth*ratioN;
    return width/10000.f;
}

+ (CGFloat)height:(RedirectInfo*)redirectInfo
{
    CGFloat height = kScreenWidth*redirectInfo.height/320;
    NSInteger heightN = height*10000.f;
    return heightN/10000.f;
}

@end
