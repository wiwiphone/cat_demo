//
//  SSWDirectionalPanGestureRecognizer.m
//
//  Created by Arkadiusz Holko http://holko.pl on 01-06-14.
//

#import "SSWDirectionalPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

@interface SSWDirectionalPanGestureRecognizer()
@property (nonatomic) BOOL dragging;
@end

@implementation SSWDirectionalPanGestureRecognizer

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    _isAllowPan = NO;
    
    UITouch *touch = [touches anyObject];
    NSUInteger tapCount = touch.tapCount;
    if (tapCount == 1) {
        CGPoint touchPos = [touch locationInView:self.view];
        if (touchPos.x<60) {
            _isAllowPan = YES;
        }
    }
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];

    if (self.state == UIGestureRecognizerStateFailed) return;

    CGPoint velocity = [self velocityInView:self.view];

    // check direction only on the first move
    if (!self.dragging) {
        NSDictionary *velocities = @{
                                     @(SSWPanDirectionRight) : @(velocity.x),
                                     @(SSWPanDirectionDown) : @(velocity.y),
                                     @(SSWPanDirectionLeft) : @(-velocity.x),
                                     @(SSWPanDirectionUp) : @(-velocity.y)
                                     };
        NSArray *keysSorted = [velocities keysSortedByValueUsingSelector:@selector(compare:)];

        // Fails the gesture if the highest velocity isn't in the same direction as `direction` property.
        if ([[keysSorted lastObject] integerValue] != self.direction) {
            self.state = UIGestureRecognizerStateFailed;
        }

        self.dragging = YES;
    }
}

- (void)reset
{
    [super reset];

    self.dragging = NO;
}

@end
