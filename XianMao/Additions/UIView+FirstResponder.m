//
//  UIView+FirstResponder.m
//  VoPai
//
//  Created by simon cai on 11/18/13.
//  Copyright (c) 2013 taobao.com. All rights reserved.
//

#import "UIView+FirstResponder.h"

@implementation UIView (FirstResponder)

- (UIView *)findFirstResponder
{
    if ([self isFirstResponder])
        return self;
    
    for (UIView * subView in self.subviews)
    {
        UIView * fr = [subView findFirstResponder];
        if (fr != nil)
            return fr;
    }
    
    return nil;
}

@end