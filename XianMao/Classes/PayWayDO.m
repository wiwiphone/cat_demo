//
//  PayWayDO.m
//  XianMao
//
//  Created by simon cai on 7/8/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "PayWayDO.h"
#import "NetworkAPI.h"

@implementation PayWayDO

- (NSString*)localIconName {
    if (self.pay_way==PayWayWxpay) {
        return @"wxpay";
    }
    if (self.pay_way==PayWayAlipay) {
        return @"payicon_ali";
    }
    if (self.pay_way==PayWayUpay) {
        return @"pay_icon_cup";
    }
    if (self.pay_way==PayWayOffline) {
        return @"pay_icon_offline";
    }
    if (self.pay_way==PayWayFenQiLe) {
        return @"pay_icon_fenqile";
    }
    return nil;
}
@end

