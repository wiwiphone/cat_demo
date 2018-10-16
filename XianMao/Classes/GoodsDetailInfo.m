//
//  GoodsDetailInfo.m
//  XianMao
//
//  Created by simon cai on 11/13/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "GoodsDetailInfo.h"
#import "NSDictionary+Additions.h"
#import "GoodsEditableInfo.h"
#import "URLScheme.h"

//=========================================================================
@implementation GoodsDetailInfo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        if ([dict dictionaryValueForKey:@"goods_info"]) {
            self.goodsInfo = [GoodsInfo createWithDict:[dict dictionaryValueForKey:@"goods_info"]];
        }
        
        if ([dict arrayValueForKey:@"tag_list"]) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            NSArray *tagDictArray = [dict arrayValueForKey:@"tag_list"];
            for (NSDictionary *tagDict in tagDictArray) {
                if ([tagDict isKindOfClass:[NSDictionary class]]) {
                    TagVo *tag = [TagVo createWithDict:tagDict];
                    [array addObject:tag];
                }
            }
            self.tagList = array;
        }
        
        NSMutableArray *detailPicItems = [[NSMutableArray alloc] init];
        NSArray *gallaryItemDicts = [dict arrayValueForKey:@"detail_pics"];
        if ([gallaryItemDicts isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in gallaryItemDicts) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [detailPicItems addObject:[GoodsDetailPicItem createWithDict:dict]];
                }
            }
        }
        self.detailPicItems = detailPicItems;
        
        
        NSMutableArray *gallaryItems = [[NSMutableArray alloc] init];
        NSArray *detailPicItemDicts = [dict arrayValueForKey:@"gallary"];
        if ([detailPicItemDicts isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in detailPicItemDicts) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [gallaryItems addObject:[GoodsGallaryItem createWithDict:dict]];
                }
            }
        }
        self.gallaryItems = gallaryItems;
        
        NSDictionary *brandDict = [dict dictionaryValueForKey:@"brand_info"];
        if (brandDict) {
            self.brandInfo = [BrandInfo createWithDict:brandDict];
        }
        
        NSMutableArray *attrItems = [[NSMutableArray alloc] init];
        if (self.brandInfo) {
            GoodsAttributeItem *attrItem = [[GoodsAttributeItem alloc] init];
            attrItem.attrName = @"品牌";
            if ([self.brandInfo.brandEnName length]>0 && [self.brandInfo.brandName length]>0) {
                attrItem.attrValue = [NSString stringWithFormat:@"%@/%@",self.brandInfo.brandEnName,self.brandInfo.brandName];;
            } else if ([self.brandInfo.brandEnName length]>0) {
                attrItem.attrValue = self.brandInfo.brandEnName;
            } else if ([self.brandInfo.brandName length]>0) {
                attrItem.attrValue = self.brandInfo.brandName;
            }
            [attrItems addObject:attrItem];
        }
        if (self.goodsInfo)
        {
            GoodsAttributeItem *attrItem = [[GoodsAttributeItem alloc] init];
            attrItem.attrName = @"适用人群";
            if (self.goodsInfo.fitPeople==1) {
                attrItem.attrValue = @"男";
            } else if (self.goodsInfo.fitPeople==2) {
                attrItem.attrValue = @"女";
            } else {
                attrItem.attrValue = @"所有人";
            }
            [attrItems addObject:attrItem];
        }
        if (self.goodsInfo)
        {
            GoodsGradeTag *gradeInfo = self.goodsInfo.gradeTag;
            if (gradeInfo) {
                GoodsAttributeItemWithHelpURL *attrItem = [[GoodsAttributeItemWithHelpURL alloc] init];
                attrItem.attrName = @"成色";
                attrItem.attrValue = [NSString stringWithFormat:@"%@",gradeInfo.name];
                attrItem.helpURL = kURLGradeIntro;
                [attrItems addObject:attrItem];
            }
        }
        NSArray *attrItemDicts = [dict arrayValueForKey:@"attrs"];
        if ([attrItemDicts isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in attrItemDicts) {
                [attrItems addObject:[GoodsAttributeItem createWithDict:dict]];
            }
        }
        self.attrItems = attrItems;
        
        
        NSMutableArray *imageDescGroupItems = [[NSMutableArray alloc] init];
        NSArray *imageDescItemsDict = [dict arrayValueForKey:@"imagedesc_items"];
        if ([imageDescItemsDict isKindOfClass:[NSArray class]]) {
            for (NSDictionary *imageDescDict in imageDescItemsDict) {
                if ([imageDescDict isKindOfClass:[NSDictionary class]]) {
                    [imageDescGroupItems addObject:[ImageDescGroup createWithDict:imageDescDict]];
                }
            }
        }
        _imageDescGroupItems = imageDescGroupItems;
        
        if ([dict dictionaryValueForKey:@"lock_info"]) {
            _orderLockInfo = [OrderLockInfo createWithDict:[dict dictionaryValueForKey:@"lock_info"]];
        }
        
        self.comment_num = [dict integerValueForKey:@"comment_num" defaultValue:0];
        self.contactType = [dict integerValueForKey:@"contactType"];
    }
    return self;
}

@end


//=========================================================================
@implementation GoodsDetailPicItem

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    return [super initWithDict:dict];
}

@end

//=========================================================================
@implementation GoodsAttributeItem

+ (GoodsAttributeItem*)allocWithNameAndValue:(NSString*)name value:(NSString*)value {
    GoodsAttributeItem *item = [[GoodsAttributeItem alloc] init];
    item.attrName = name;
    item.attrValue = value;
    return item;
}

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        self.attrId = [dict integerValueForKey:@"tagId" defaultValue:0];
        self.attrName = [dict stringValueForKey:@"name"];
        self.attrValue = [dict stringValueForKey:@"value"];
    }
    return self;
}

@end


@implementation GoodsAttributeItemWithHelpURL

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[super alloc] initWithDict:dict];
}

@end


