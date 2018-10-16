//
//  CommentVo.m
//  XianMao
//
//  Created by simon cai on 13/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "CommentVo.h"
#import "JSONKit.h"

@implementation CommentVo

- (id)initWithJSONDictionary:(NSDictionary *)dict {
    self = [super initWithJSONDictionary:dict];
    if (self) {
        NSString *jsonData = [dict stringValueForKey:@"attachment"];
        NSError *error = nil;
        JSONDecoder *parser = [JSONDecoder decoder];
        id result = [parser mutableObjectWithData:[jsonData dataUsingEncoding: NSUTF8StringEncoding] error:&error];
        if ([result isKindOfClass:[NSArray class]]) {
            _attachments = [ForumAttachmentVO createAttachmentsWithDictArray:result];
        }
    }
    return self;
}

@end
