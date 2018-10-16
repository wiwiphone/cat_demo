//
//  UnCopyableTextField.m
//  XianMao
//
//  Created by simon cai on 28/4/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "UnCopyableTextField.h"

@implementation UnCopyableTextField

//- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
//{
//    if (action == @selector(paste:))
//        return NO;
//    if (action == @selector(select:))
//        return NO;
//    if (action == @selector(selectAll:))
//        return NO;
//    return [super canPerformAction:action withSender:sender];
//}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
