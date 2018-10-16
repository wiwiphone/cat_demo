//
//  MBDefaultPage.m
//  XianMao
//
//  Created by simon on 12/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <objc/message.h>
#import "MBDefaultPage.h"
#import "MBUtil.h"

@implementation MBDefaultPage

- (id)initWithFrame:(CGRect)frame withViewDO:(id)viewDO {
    self = [self initWithFrame:frame];
    if (self) {
        SEL selector = @selector(setViewDO:);
        if ([self respondsToSelector:selector]) {
            objc_msgSend(self, selector, viewDO);
        }
        [self loadView];
        [self autoBindingKeyPath];
    }
    return self;
}

- (void)loadView {
    
}

//自动扫描keyBinding
- (void)autoBindingKeyPath {
    MBAutoBindingKeyPath(self);
}

@end

