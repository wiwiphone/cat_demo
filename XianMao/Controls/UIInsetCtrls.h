//
//  UIInsetCtrls.h
//  XianMao
//
//  Created by simon cai on 11/16/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIInsetLabel : UILabel

@property(nonatomic) UIEdgeInsets insets;

- (id)initWithFrame:(CGRect)frame andInsets:(UIEdgeInsets) insets;
- (id)initWithInsets:(UIEdgeInsets) insets;

@end

@interface UIInsetTextField : UITextField

@property(nonatomic,assign) NSInteger maxLength;
@property(nonatomic,assign) BOOL unCopyable;

- (id)initWithFrame:(CGRect)frame rectInsetDX:(CGFloat)rectInsetDX rectInsetDY:(CGFloat)rectInsetDY rectInsetDXRight:(CGFloat)rectInsetDXRight;
- (id)initWithFrame:(CGRect)frame rectInsetDX:(CGFloat)rectInsetDX rectInsetDY:(CGFloat)rectInsetDY;

@end

