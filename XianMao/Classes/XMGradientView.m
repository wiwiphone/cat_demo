//
//  XMGradientView.m
//  XianMao
//
//  Created by darren on 15/1/21.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "XMGradientView.h"

@implementation XMGradientView


+ (Class)layerClass {
    return [CAGradientLayer class];
}
- (CAGradientLayer *) _gradientLayer{
    return (CAGradientLayer *)self.layer;
}



- (NSArray *) colors{
    NSArray *cgColors = [self _gradientLayer].colors;
    
    if (cgColors == nil) return nil;
    
    
    NSMutableArray *uiColors = [NSMutableArray arrayWithCapacity:[cgColors count]];
    
    for (id cgColor in cgColors)
        [uiColors addObject:[UIColor colorWithCGColor:(__bridge CGColorRef)cgColor]];
    
    return [NSArray arrayWithArray:uiColors];
}
- (void)setColors:(NSArray *)newColors {
    NSMutableArray *newCGColors = nil;
    
    if (newColors != nil) {
        newCGColors = [NSMutableArray arrayWithCapacity:[newColors count]];
        for (id color in newColors) {
            
            if ([color isKindOfClass:[UIColor class]])
                [newCGColors addObject:(id)[color CGColor]];
            else
                [newCGColors addObject:color];
        }
    }
    
    [self _gradientLayer].colors = newCGColors;
}


- (NSArray *)locations {
    return [self _gradientLayer].locations;
}
- (void) setLocations:(NSArray *)newLocations {
    [self _gradientLayer].locations = newLocations;
}

- (CGPoint) startPoint{
    return [self _gradientLayer].startPoint;
}
- (void) setStartPoint:(CGPoint)newStartPoint {
    [self _gradientLayer].startPoint = newStartPoint;
}

- (CGPoint) endPoint{
    return [self _gradientLayer].endPoint;
}
- (void) setEndPoint:(CGPoint)newEndPoint {
    [self _gradientLayer].endPoint = newEndPoint;
}

- (NSString *) type{
    return [self _gradientLayer].type;
}
- (void) setType:(NSString *)newType {
    [self _gradientLayer].type = newType;
}


@end



