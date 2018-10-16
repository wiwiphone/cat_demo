//
//  XMEmptyView.h
//  XianMao
//
//  Created by darren on 15/1/21.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

@import UIKit;
@import QuartzCore;
#import "XMGradientView.h"

/**
 The glyph that appears with the empty view.
 */
typedef NS_ENUM(NSInteger, XMEmptyViewImage) {
    XMEmptyViewImageNone,
    XMEmptyViewImageWrong,
    XMEmptyViewImageNetError
};


@interface XMEmptyView : XMGradientView

- (instancetype) initWithFrame:(CGRect)frame
                          mask:(UIImage*)image
                         title:(NSString*)titleString
                      subtitle:(NSString*)subtitleString NS_DESIGNATED_INITIALIZER;

- (instancetype) initWithFrame:(CGRect)frame
                emptyViewImage:(XMEmptyViewImage)image
                         title:(NSString*)titleString
                      subtitle:(NSString*)subtitleString;

///-------------------------
/// @name Properties
///-------------------------

/** The image view for the empty content. */
@property (nonatomic,strong) UIImageView *imageView;

/** The title message. */
@property (nonatomic,strong) UILabel *titleLabel;

/** The secondary message. */
@property (nonatomic,strong) UILabel *subtitleLabel;



- (void) setImage:(UIImage*)image;

- (void) setEmptyImage:(XMEmptyViewImage)image;

- (UIImage*)predefinedImage:(XMEmptyViewImage)img;

@end



