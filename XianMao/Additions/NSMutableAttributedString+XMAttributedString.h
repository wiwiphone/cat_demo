//
//  NSMutableAttributedString+XMAttributedString.h
//  XianMao
//
//  Created by Marvin on 2017/5/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (XMAttributedString)

/**
 XMAttributedString

 @param string 字符串
 @param rangeOfString 需要改变颜色的字符串
 @param color 颜色
 @return NSAttributedString
 */
+ (NSAttributedString *)AttributedStringWith:(NSString *)string RangeOfString:(NSString *)rangeOfString UIcolor:(UIColor *)color;
@end
