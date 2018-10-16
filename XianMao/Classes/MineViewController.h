//
//  MineViewController.h
//  XianMao
//
//  Created by simon on 12/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "Command.h"

@interface MineViewController : BaseViewControllerHandleMemoryWarning

@end


@interface MineHeaderView : UIView

+ (CGFloat)heightForOrientationPortrait;
@property(nonatomic,copy) void(^handleSingleTapDetected)(MineHeaderView *view);
- (void)updateHeaderView;

@end

@interface UserStatTextButton : CommandButton

- (id)initWithFrame:(CGRect)frame topText:(NSString*)topText bottomText:(NSString*)bottomText sepHeight:(CGFloat)sepHeight;
- (void)setTopText:(NSString*)topText;
- (void)setBottomText:(NSString*)bottomText;

@end


