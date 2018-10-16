//
//  XMGradientView.h
//  XianMao
//
//  Created by darren on 15/1/21.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

@import UIKit;
@import QuartzCore;

@interface XMGradientView : UIView


///----------------------------
/// @name Gradient Style Properties
///----------------------------

/** An array of `UIColor` objects defining the color of each gradient stop. */
@property (nonatomic,strong) NSArray *colors;

/** An optional array of NSNumber objects defining the location of each gradient stop. */
@property (nonatomic,strong) NSArray *locations;


/**
 The start point corresponds to the first stop of the gradient. The point is defined in the unit coordinate space and is then mapped to the layer’s bounds rectangle when drawn.
 Default value is (0.5,0.0).
 */
@property (nonatomic,assign) CGPoint startPoint;


/** The end point of the gradient when drawn in the layer’s coordinate space. */
@property (nonatomic,assign) CGPoint endPoint;

/** Style of gradient drawn by the layer. */
@property (nonatomic,copy) NSString *type;

@end
