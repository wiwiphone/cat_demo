//
//  KeyboardInputBarView.h
//  XianMao
//
//  Created by simon cai on 11/13/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceHolderTextView.h"

@protocol KeyboardInputBarDelegate;
@interface KeyboardInputBar : UIView

@property (nonatomic, weak) id <KeyboardInputBarDelegate> delegate;
@property (nonatomic, weak, readonly) PlaceHolderTextView *textView;

@end

@protocol KeyboardInputBarDelegate <NSObject>

@end