//
//  NSString+jakf.h
//  XianMao
//
//  Created by jakf_17 on 15/12/25.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (jakf)

- (BOOL)isNotEmptyCtg;

- (BOOL)isNotEmptyWithSpace;


- (NSString*)stringByDeleteSignForm:(NSString *)aLeftSign
                       andRightSign:(NSString *)aRightSign;


- (NSString*)stringByReplacingSignForm:(NSString *)aLeftSign
                          andRightSign:(NSString *)aRightSign
                       andReplacingStr:(NSString*)aReplacingStr;

@end
