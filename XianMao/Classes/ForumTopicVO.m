//
//  ForumTopicVO.m
//  XianMao
//
//  Created by simon cai on 26/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ForumTopicVO.h"
#import "JSONKit.h"


//@implementation ForumPostList
//
//
//
//@end
//
//
//@implementation ForumPostHome
//
//+(BOOL)propertyIsOptional:(NSString *)propertyName{
//    return YES;
//}
//
//- (id)initWithJSONDictionary:(NSDictionary *)dict {
//    self = [super initWithJSONDictionary:dict];
//    if (self) {
//        NSMutableArray *list = [[NSMutableArray alloc] init];
//        NSArray *dictArray = [dict arrayValueForKey:@"list"];
//        if ([dictArray isKindOfClass:[NSArray class]]) {
//            for (NSDictionary *dictTmp in dictArray) {
//                ForumPostList *filterVO =[[ForumPostList alloc] initWithJSONDictionary:dictTmp];
//                [list addObject:filterVO];
//            }
//        }
//        _list = list;
//    }
//    return self;
//}
//
//@end



@implementation ForumTopicIsLike
+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end


@implementation ForumCatHouseTopData

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation ForumTopicAvatar

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end


@implementation ForumTopicGroup

+(BOOL)propertyIsOptional:(NSString *)propertyName{
    return YES;
}

@end

@implementation ForumTopicVO

- (id)initWithJSONDictionary:(NSDictionary *)dict {
    self = [super initWithJSONDictionary:dict];
    if (self) {
        NSMutableArray *filterList = [[NSMutableArray alloc] init];
        NSArray *dictArray = [dict arrayValueForKey:@"filter_list"];
        if ([dictArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictTmp in dictArray) {
                ForumTopicFilterVO *filterVO =[[ForumTopicFilterVO alloc] initWithJSONDictionary:dictTmp];
                [filterList addObject:filterVO];
            }
        }
        _filterList = filterList;
        
        NSMutableArray *statusVoList = [[NSMutableArray alloc] init];
        NSArray *dictArray2 = [dict arrayValueForKey:@"statusVos"];
        if ([dictArray2 isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictTmp in dictArray2) {
                ForumPostStatusVo *statusVO =[[ForumPostStatusVo alloc] initWithJSONDictionary:dictTmp];
                [statusVoList addObject:statusVO];
            }
        }
        _statusVoList = statusVoList;
    }
    return self;
}

@end

@implementation ForumTopicFilterVO

@end

@implementation ForumPostVO

- (id)initWithJSONDictionary:(NSDictionary *)dict {
    self = [super initWithJSONDictionary:dict];
    if (self) {
        NSMutableArray *topReplies = [[NSMutableArray alloc] init];
        NSArray *dictArray = [dict arrayValueForKey:@"topReplies"];
        if ([dictArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictTmp in dictArray) {
                if ([dictTmp isKindOfClass:[NSDictionary class]]) {
                    ForumPostReplyVO *replyVO =[[ForumPostReplyVO alloc] initWithJSONDictionary:dictTmp];
                    [topReplies addObject:replyVO];
                }
            }
        }
        _topReplies = topReplies;
        
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

- (BOOL)isFinshed {
    return _status==1;
}

- (void)assignWithOther:(ForumPostVO*)postVO {
    self.post_id = postVO.post_id;
    self.content = postVO.content;
    self.user_id = postVO.user_id;
    self.status = postVO.status;
    self.reply_num = postVO.reply_num;
    self.is_myself = postVO.is_myself;
    self.timestamp = postVO.timestamp;
    self.topReplies = postVO.topReplies;
}

@end

@implementation ForumPostReplyVO

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

@implementation ForumPostStatusVo

- (BOOL)isFinsh {
    return _status;
}

@end

@implementation ForumAttachItemVO


@end

@implementation ForumAttachItemGoodsVO

@end

@implementation ForumAttachItemPicsVO

@end

@implementation ForumAttachmentVO

- (id)initWithJSONDictionary:(NSDictionary *)dict {
    self = [super initWithJSONDictionary:dict];
    if (self) {
        
        NSDictionary *itemDict = [dict dictionaryValueForKey:@"item"];
        _item = [[self class] createAttachItemWithType:_type dict:itemDict];
    }
    return self;
}

- (BOOL)isNeedRemindUpgrade {
    return _item==nil?YES:NO;
}

+ (ForumAttachItemVO*)createAttachItemWithType:(NSInteger)type dict:(NSDictionary*)dict {
    ForumAttachItemVO *itemVO = nil;
    if (type==ForumAttachTypeGoods&&dict) {
        itemVO = [[ForumAttachItemGoodsVO alloc] initWithJSONDictionary:dict];
    }
    else if (type==ForumAttachTypePics&&dict) {
        itemVO = [[ForumAttachItemPicsVO alloc] initWithJSONDictionary:dict];
    }
    else {
        itemVO = [[ForumAttachItemRemindUpgradeVO alloc] initWithJSONDictionary:dict];
    }
    return itemVO;
}

+ (NSMutableArray*)createAttachmentsWithDictArray:(NSArray*)dictArray {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in dictArray) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            [array addObject:[[ForumAttachmentVO alloc] initWithJSONDictionary:dict]];
        }
    }
    return array;
}

@end

@implementation ForumAttachItemRemindUpgradeVO


@end

@implementation ForumAttachRedirectInfo

+ (ForumAttachRedirectInfo*)allocWithData:(NSRange)range redirectUri:(NSString*)redirectUri {
    ForumAttachRedirectInfo *redirectInfo = [[ForumAttachRedirectInfo alloc] init];
    redirectInfo.redirectUri = redirectUri;
    redirectInfo.range = range;
    return redirectInfo;
}

@end




