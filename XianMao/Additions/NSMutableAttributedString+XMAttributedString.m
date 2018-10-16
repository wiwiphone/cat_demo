//
//  NSMutableAttributedString+XMAttributedString.m
//  XianMao
//
//  Created by Marvin on 2017/5/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "NSMutableAttributedString+XMAttributedString.h"

@implementation NSMutableAttributedString (XMAttributedString)

+ (NSAttributedString *)AttributedStringWith:(NSString *)string RangeOfString:(NSString *)rangeOfString UIcolor:(UIColor *)color{
    NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc]initWithString:string];
    NSRange range = [[hintString string] rangeOfString:rangeOfString];
    [hintString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return hintString;
}

@end
