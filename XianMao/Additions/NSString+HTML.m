//
//  NSString+HTML.m
//  XianMao
//
//  Created by darren on 4/1/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)


+ (NSString *)transformString:(NSString *)originalStr
{
    NSString *text = originalStr;
    
    //解析表情
    NSString *regex_emoji = @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5]+\\]";//表情的正则表达式
    NSArray *array_emoji = [text componentsMatchedByRegex:regex_emoji];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"faceMap_ch" ofType:@"plist"];
    NSDictionary *m_EmojiDic = [[NSDictionary alloc] initWithContentsOfFile:filePath];
    
    if ([array_emoji count]) {
        for (NSString *str in array_emoji) {
            NSRange range = [text rangeOfString:str];
            NSString *i_transCharacter = [m_EmojiDic objectForKey:str];
            if (i_transCharacter) {
                // 把单个表情的表达式转为单个字符
                NSString *imageHtml = [NSString stringWithFormat:@"[爱]"];
                text = [text stringByReplacingCharactersInRange:NSMakeRange(range.location, [str length]) withString:imageHtml];
            }
        }
    }
    
    //返回转义后的字符串
    return text;
}


@end
