//
//  Command.m
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "Command.h"
#import <objc/runtime.h>


@implementation Command

- (void) execute {
    // should throw an exception.
}

- (void) undo {
    // do nothing
    // subclasses need to override this
    // method to perform actual undo.
}

- (void) dealloc {
    self.userInfo = nil;
}

@end


@implementation Action

+ (Action*)create:(id (^)(id parameters))action; {
    Action *a =[[Action alloc] init];
    a.action = action;
    return a;
}

- (id)execute {
    return [self execute:nil];
}

- (id)execute:(id)parameters {
    if (_action) {
        return _action(parameters);
    }
    return nil;
}

- (void)dealloc {
    self.action = NULL;
}

@end

static NSString * const ActionBlockKey = @"ActionBlockKey";

@implementation NSMutableDictionary (ActionBlock)

- (NSMutableDictionary*)setObjectReturnSelf:(id)anObject forKey:(id <NSCopying>)aKey {
    [self setObject:anObject forKey:aKey];
    return self;
}

- (NSMutableDictionary*)fillAction:(void (^)())action {
    [self fillActionWithParametersAndReturn:^id(id parameters) {if (action) action();return nil;} withKey:@"actionBlock"];
    return self;
}

- (NSMutableDictionary*)fillAction:(void (^)())action withKey:(NSString*)withKey {
    [self fillActionWithParametersAndReturn:^id(id parameters) {if (action) action();return nil;} withKey:withKey];
    return self;
}

- (NSMutableDictionary*)fillActionAndReturn:(id (^)())action {
    [self fillActionWithParametersAndReturn:^id(id parameters) {if (action) return action();return nil;} withKey:@"actionBlock"];
    return self;
}

- (NSMutableDictionary*)fillActionAndReturn:(id (^)())action withKey:(NSString*)withKey {
    [self fillActionWithParametersAndReturn:^id(id parameters) {if (action) return action();return nil;} withKey:withKey];
    return self;
}

- (NSMutableDictionary*)fillActionWithParameters:(void (^)(id parameters))action {
    [self fillActionWithParametersAndReturn:^id(id parameters) {if (action)action(parameters);return nil;} withKey:@"actionBlock"];
    return self;
}

- (NSMutableDictionary*)fillActionWithParameters:(void (^)(id parameters))action withKey:(NSString*)withKey {
    [self fillActionWithParametersAndReturn:^id(id parameters) {if (action)action(parameters);return nil;} withKey:withKey];
    return self;
}

- (NSMutableDictionary*)fillActionWithParametersAndReturn:(void (^)(id parameters))action {
    [self fillActionWithParametersAndReturn:^id(id parameters) {if (action)action(parameters);return nil;} withKey:@"actionBlock"];
    return self;
}

- (NSMutableDictionary*)fillActionWithParametersAndReturn:(id (^)(id parameters))action withKey:(NSString*)withKey {
    [self setObject:[Action create:action] forKey:withKey];
    return self;
}

- (id)doAction {
    return [self doActionWithParameters:nil withKey:@"actionBlock"];
}

- (id)doAction:(NSString*)withKey {
    return [self doActionWithParameters:nil withKey:withKey];
}

- (id)doActionWithParameters:(id)parameters {
    return [self doActionWithParameters:parameters withKey:@"actionBlock"];
}

- (id)doActionWithParameters:(id)parameters withKey:(NSString*)withKey {
    Action *a = [self objectForKey:withKey];
    if ([a isKindOfClass:[Action class]]) {
        return [a execute:parameters];
    }
    return nil;
}

@end


@implementation NSDictionary (ActionBlock)

- (id)doAction {
    return [self doActionWithParameters:nil withKey:@"actionBlock"];
}

- (id)doAction:(NSString*)withKey {
    return [self doActionWithParameters:nil withKey:withKey];
}

- (id)doActionWithParameters:(id)parameters {
    return [self doActionWithParameters:parameters withKey:@"actionBlock"];
}

- (id)doActionWithParameters:(id)parameters withKey:(NSString*)withKey {
    Action *a = [self objectForKey:withKey];
    if ([a isKindOfClass:[Action class]]) {
        return [a execute:parameters];
    }
    return nil;
}
@end



@implementation CommandButton

- (void)dealloc {
    _handleClickBlock = nil;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)click:(UIButton*)sender
{
    if (_handleClickBlock) {
        _handleClickBlock(self);
    }
}

@end



@implementation VerticalCommandButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _imageTextSepHeight = 0.f;
        _contentAlignmentCenter = NO;
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    // Center image
    CGPoint center = self.imageView.center;
    center.x = self.frame.size.width/2;
    center.y = self.imageView.frame.size.height/2;
    self.imageView.center = center;
    
    if (_contentAlignmentCenter) {
        CGFloat totalHeight = self.imageView.frame.size.height+_imageTextSepHeight+[self titleLabel].frame.size.height;
        CGFloat Y = (self.frame.size.height-totalHeight)/2;
        CGRect frame = self.imageView.frame;
        frame.origin.y = Y;
        self.imageView.frame = frame;
    }
    
    // _contentMarginTop
    CGRect frame = self.imageView.frame;
    frame.origin.y = frame.origin.y+_contentMarginTop;
    self.imageView.frame = frame;
    
    //Center text
    CGRect newFrame = [self titleLabel].frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.imageView.frame.size.height + _imageTextSepHeight+self.imageView.frame.origin.y;
    newFrame.size.width = self.frame.size.width;
    
    self.titleLabel.frame = newFrame;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)setImageTextSepHeight:(CGFloat)imageTextSepHeight {
    if (_imageTextSepHeight!=imageTextSepHeight) {
        _imageTextSepHeight = imageTextSepHeight;
        [self setNeedsLayout];
    }
}

- (void)setContentMarginTop:(CGFloat)contentMarginTop {
    if (_contentMarginTop != contentMarginTop) {
        _contentMarginTop = contentMarginTop;
        [self setNeedsLayout];
    }
}

- (void)setContentAlignmentCenter:(BOOL)contentAlignmentCenter {
    if (_contentAlignmentCenter != contentAlignmentCenter) {
        _contentAlignmentCenter = contentAlignmentCenter;
        [self setNeedsLayout];
    }
}

@end

@implementation TapDetectingLabel {
    
}

- (void)dealloc
{
    _handleSingleTapDetected = nil;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_handleSingleTapDetected) {
        return YES;
    }
    return NO;
}

- (void)handleTapFrom:(UIGestureRecognizer *)recognizer
{
    if (_handleSingleTapDetected) {
        _handleSingleTapDetected(self,recognizer);
    }
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        tapRecognizer.delegate = self;
        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}

@end


@implementation TapDetectingView

- (void)dealloc {
    _handleSingleTapDetected = nil;

    _tapRecognizer = nil;
    
}

- (id)init {
    if ((self = [super init])) {
        self.userInteractionEnabled = YES;
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        [self addGestureRecognizer:_tapRecognizer];
        _tapRecognizer.delegate = self;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_handleSingleTapDetected) {
        return YES;
    }
    return NO;
}

- (void)handleTapFrom:(UIGestureRecognizer *)recognizer
{
    if (_handleSingleTapDetected) {
        _handleSingleTapDetected(self,recognizer);
    }
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        [self addGestureRecognizer:_tapRecognizer];
        _tapRecognizer.delegate = self;
    }
    return self;
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    NSUInteger tapCount = touch.tapCount;
//    switch (tapCount) {
//        case 1:
//            if (_handleSingleTapDetected) {
//                _handleSingleTapDetected(self,touch);
//            }
//            break;
//        case 2:
//            if (_handleDoubleTapDetected) {
//                _handleDoubleTapDetected(self,touch);
//            }
//            break;
//        case 3:
//            if (_handleTripleTapDetected) {
//                _handleTripleTapDetected(self,touch);
//            }
//            break;
//        default:
//            break;
//    }
//    [[self nextResponder] touchesEnded:touches withEvent:event];
//}

@end


@implementation TapDetectingImageView

- (void)dealloc {
    _handleSingleTapDetected = nil;
    _tapRecognizer = nil;
}

- (id)init {
    if ((self = [super init])) {
        self.userInteractionEnabled = YES;
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        [self addGestureRecognizer:_tapRecognizer];
        _tapRecognizer.delegate = self;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.userInteractionEnabled = YES;
        _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        [self addGestureRecognizer:_tapRecognizer];
        _tapRecognizer.delegate = self;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (_handleSingleTapDetected) {
        return YES;
    }
    return NO;
}

- (void)handleTapFrom:(UIGestureRecognizer *)recognizer
{
    if (_handleSingleTapDetected) {
        _handleSingleTapDetected(self,recognizer);
    }
}

//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    UITouch *touch = [touches anyObject];
//    NSUInteger tapCount = touch.tapCount;
//    switch (tapCount) {
//        case 1:
//            if (_handleSingleTapDetected) {
//                _handleSingleTapDetected(self,touch);
//            }
//            break;
//        case 2:
//            if (_handleDoubleTapDetected) {
//                _handleDoubleTapDetected(self,touch);
//            }
//            break;
//        case 3:
//            if (_handleTripleTapDetected) {
//                _handleTripleTapDetected(self,touch);
//            }
//            break;
//        default:
//            break;
//    }
//    [[self nextResponder] touchesEnded:touches withEvent:event];
//}

@end


