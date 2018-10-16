//
//  AboutViewController.h
//  XianMao
//
//  Created by simon on 1/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "WebViewController.h"

@interface AboutViewController : BaseViewController

@end


@interface AboutHeaderView : UIView

+ (CGFloat)heightForOrientationPortrait;

//- (void)updateHeaderView;

@end

@interface AboutFooterView : UIView

+ (CGFloat)heightForOrientationPortrait;

//- (void)updateHeaderView;

@end


@interface FeedbackViewController : BaseViewController

@end




