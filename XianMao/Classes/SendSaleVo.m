//
//  SendSaleVo.m
//  XianMao
//
//  Created by apple on 17/2/28.
//  Copyright © 2017年 XianMao. All rights reserved.
//




#import "SendSaleVo.h"
#import "PictureItem.h"

@implementation SendSaleVo

+ (instancetype)createWithDict:(NSDictionary*)dict {
    return [[self alloc] initWithDict:dict];
}

- (instancetype)initWithDict:(NSDictionary*)dict {
    self = [super init];
    if (self && [dict isKindOfClass:[NSDictionary class]]) {
        
        self.ID = [dict integerValueForKey:@"id"];
        self.createtime = [dict integerValueForKey:@"createtime"];
        self.updatetime = [dict integerValueForKey:@"updatetime"];
        self.consigmentSn = [dict stringValueForKey:@"consigmentSn"];
        self.userId = [dict integerValueForKey:@"userId"];
        self.categoryId = [dict integerValueForKey:@"categoryId"];
        self.brandId = [dict integerValueForKey:@"brandId"];
        self.gradeLevel = [dict integerValueForKey:@"gradeLevel"];
        self.goodsDesc = [dict stringValueForKey:@"goodsDesc"];
        self.title = [dict stringValueForKey:@"title"];
        self.returnAddress = [dict stringValueForKey:@"returnAddress"];
        NSArray * array = [dict arrayValueForKey:@"attachment"];
        NSMutableArray * attachment = [[NSMutableArray alloc] init];
        if (array.count > 0 && array) {
            for (NSDictionary * dict in array) {
                PictureItem * picItem = [PictureItem createWithDict:dict];
                [attachment addObject:picItem];
            }
        }
        self.attachment = attachment;
        self.userHopePrice = [dict doubleValueForKey:@"userHopePrice"];
        self.status = [dict integerValueForKey:@"status"];
        self.addressId = [dict integerValueForKey:@"addressId"];
        self.logistical = [dict stringValueForKey:@"logistical"];
        self.logisticalNum = [dict stringValueForKey:@"logisticalNum"];
        self.returnLogistical = [dict stringValueForKey:@"returnLogistical"];
        self.returnLogisticalNum = [dict stringValueForKey:@"returnLogisticalNum"];
        self.phone = [dict stringValueForKey:@"phone"];
        self.statusDesc = [dict stringValueForKey:@"statusDesc"];
        self.sdesc = [dict stringValueForKey:@"sdesc"];
        self.themeName = [dict stringValueForKey:@"themeName"];
        self.themeAvatar = [dict stringValueForKey:@"themeAvatar"];
        self.userName = [dict stringValueForKey:@"userName"];
        self.labelNum = [dict intValueForKey:@"labelNum"];
        self.onlineTime = [dict longLongValueForKey:@"onlineTime"];
        self.outLineTime = [dict longLongValueForKey:@"outLineTime"];
        self.dealTime = [dict longLongValueForKey:@"dealTime"];
        self.estimatorId = [dict integerValueForKey:@"estimatorId"];
        self.goodsSn = [dict stringValueForKey:@"goodsSn"];
    }
    return self;
}


- (NSMutableArray *)returnActionsButtons{
    NSMutableArray * btns = [[NSMutableArray alloc] init];
    
    NSArray * arr = @[
                      @{@"status":@(TO_CONSIGMENT),     @"title":@"发货给寄卖中心"},
                      @{@"status":@(SEE_LOGISTICS),     @"title":@"查看物流"},
                      @{@"status":@(CONTACT_APPRAISER), @"title":@"联系寄卖部"},
                      @{@"status":@(SEE_GOODS_DETAIL),  @"title":@"查看商品详情"},
                      @{@"status":@(CONFIRM_RECEIPT),   @"title":@"确认收货"},
                      @{@"status":@(CONFIRM_DELLETE),   @"title":@"取消寄卖"},
                      ];
    
    for (int i = 0; i < arr.count; i++) {
        NSDictionary * dict = [arr objectAtIndex:i];
        NSInteger statue = (NSInteger)[[dict objectForKey:@"status"] integerValue];
        if ((self.labelNum & statue) == statue) {
            [btns addObject:dict];
        }
    }

    return btns;
}
@end
