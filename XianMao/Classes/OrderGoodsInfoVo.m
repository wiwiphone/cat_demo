//
//  OrderGoodsInfoVo.m
//  XianMao
//
//  Created by apple on 16/5/3.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "OrderGoodsInfoVo.h"

@implementation OrderGoodsInfoVo


- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.myGoodsUp = [[decoder decodeObjectForKey:@"myGoodsUp"] integerValue];
        self.myGoodsDown = [[decoder decodeObjectForKey:@"myGoodsDown"] integerValue];
        self.myGoodsValid = [[decoder decodeObjectForKey:@"myGoodsValid"] integerValue];
        self.mySellNotSend = [[decoder decodeObjectForKey:@"mySellNotSend"] integerValue];
        self.mySellFinish = [[decoder decodeObjectForKey:@"mySellFinish"] integerValue];
        self.mySellReceiving = [[decoder decodeObjectForKey:@"mySellReceiving"] integerValue];
        self.mySellCancel = [[decoder decodeObjectForKey:@"mySellCancel"] integerValue];
        self.mySellAppraise = [[decoder decodeObjectForKey:@"mySellAppraise"] integerValue];
        self.myOrderNotSend = [[decoder decodeObjectForKey:@"myOrderNotSend"] integerValue];
        self.myOrderSend = [[decoder decodeObjectForKey:@"myOrderSend"] integerValue];
        self.myOrderFinish = [[decoder decodeObjectForKey:@"myOrderFinish"] integerValue];
        self.myOrderReceiving = [[decoder decodeObjectForKey:@"myOrderReceiving"] integerValue];
        self.mySellCancel = [[decoder decodeObjectForKey:@"mySellCancel"] integerValue];
        self.myOrderAppraise = [[decoder decodeObjectForKey:@"myOrderAppraise"] integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:[NSNumber numberWithInteger:self.myGoodsUp]  forKey:@"myGoodsUp"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.myGoodsDown] forKey:@"myGoodsDown"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.myGoodsValid] forKey:@"myGoodsValid"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.mySellNotSend] forKey:@"mySellNotSend"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.mySellFinish] forKey:@"mySellFinish"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.mySellReceiving] forKey:@"mySellReceiving"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.mySellCancel] forKey:@"mySellCancel"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.mySellAppraise] forKey:@"mySellAppraise"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.myOrderNotSend] forKey:@"myOrderNotSend"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.myOrderSend] forKey:@"myOrderSend"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.myOrderFinish] forKey:@"myOrderFinish"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.myOrderReceiving] forKey:@"myOrderReceiving"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.myOrderCancel] forKey:@"myOrderCancel"];
    [encoder encodeObject:[NSNumber numberWithInteger:self.myOrderAppraise] forKey:@"myOrderAppraise"];
}

@end
