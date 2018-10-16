//
//  NSString+jakf.m
//  XianMao
//
//  Created by jakf_17 on 15/12/25.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import "NSString+jakf.h"

@implementation NSString (jakf)

// 获取对象的字符串类型
- (NSString *)stringWithNoEmpty {
    NSString *str = self;
    
    if (str == nil) {
        str = @"";
    }
    
    if (str == NULL) {
        str = @"";
    }
    
    if ([str isKindOfClass:[NSNull class]]) {
        str = @"";
    }
    
    str = [NSString stringWithFormat:@"%@",str];
    return str;
}

- (BOOL)isNotEmptyCtg {
    if (!self) {
        return NO;
    }
    
    if (self == NULL) {
        return NO;
    }
    
    if ([NSNull null] == (id)self) {
        return NO;
    }
    
    NSString *curStr = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([curStr isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
}

- (BOOL)isNotEmptyWithSpace {
    if (!self) {
        return NO;
    }
    if ([self isEqualToString:@""]) {
        return NO;
    }
    
    return YES;
    
}

- (NSString*)stringByDeleteSignForm:(NSString *)aLeftSign
                       andRightSign:(NSString *)aRightSign {
    return  [self stringByReplacingSignForm:aLeftSign andRightSign:aRightSign andReplacingStr:@""];
}

- (NSString*)stringByReplacingSignForm:(NSString *)aLeftSign
                          andRightSign:(NSString *)aRightSign
                       andReplacingStr:(NSString*)aReplacingStr {
    
    NSString *curStr   = self;
    
    NSRange rangeLeft  = [curStr rangeOfString:aLeftSign];
    NSRange rangeRight = [curStr rangeOfString:aRightSign];
    
    while (rangeLeft.location!=NSNotFound&&rangeRight.location!=NSNotFound&&rangeRight.location>rangeLeft.location) {
        
        NSRange cutRange = NSMakeRange(rangeLeft.location, rangeRight.location-rangeLeft.location+1);
        curStr           =[curStr stringByReplacingCharactersInRange:cutRange withString:aReplacingStr];
        rangeLeft        =[curStr rangeOfString:aLeftSign];
        rangeRight       =[curStr rangeOfString:aRightSign];
    }
    
    return curStr;
}
@end
