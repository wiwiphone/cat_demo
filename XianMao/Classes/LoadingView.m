//
//  LoadingView.m
//  XianMao
//
//  Created by simon on 1/23/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "LoadingView.h"
#import "Command.h"

#import "NetworkAPI.h"

#define kLoadingViewTagActivityIndicator 100
#define kLoadingViewTagContentView       200
#define KAnimationDuration 1
#define kcycleLayerWidth 65

@interface LoadingView()

@property (nonatomic, strong) CAShapeLayer * cycleLayer;
@property (nonatomic, strong) CALayer * loadingBorder;
@property (nonatomic, strong) CALayer * iconLayer;

@end

@implementation LoadingView {
    
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)dealloc
{
    _handleRetryBtnClicked = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *contentView = [self viewWithTag:kLoadingViewTagContentView];
    contentView.frame = CGRectMake(0, (self.height-contentView.height)/2-10, self.width, contentView.height);
}

- (void)removeAllSubviews {
    NSArray *subviews = [self subviews];
    for (UIView *view in subviews) {
        [view removeFromSuperview];
    }
}

- (void)showLoadingView
{
    [self removeAllSubviews];
    
    CGPoint loadingViewPoint = self.center;
    CGPoint point = CGPointMake(loadingViewPoint.x, loadingViewPoint.y-50);
    
    CALayer * loadingBorder = [[CALayer alloc] init];
    loadingBorder.frame = CGRectMake(100, 100, kScreenWidth/375*80, kScreenWidth/375*80);
    loadingBorder.masksToBounds = YES;
    loadingBorder.cornerRadius = 5;
    loadingBorder.borderWidth = 0.1;
    loadingBorder.borderColor = [UIColor lightGrayColor].CGColor;
    loadingBorder.backgroundColor = [UIColor whiteColor].CGColor;
    loadingBorder.position = point;
    _loadingBorder = loadingBorder;
    
    CAShapeLayer * cycleLayer = [[CAShapeLayer alloc] init];
    cycleLayer.masksToBounds = YES;
    cycleLayer.cornerRadius = (kScreenWidth/375*kcycleLayerWidth)/2;
    cycleLayer.frame = CGRectMake(0, 0, kScreenWidth/375*kcycleLayerWidth, kScreenWidth/375*kcycleLayerWidth);
    cycleLayer.position = point;
    cycleLayer.fillColor = [UIColor clearColor].CGColor;
    cycleLayer.lineWidth = 3.0f;
    cycleLayer.strokeColor = [UIColor redColor].CGColor;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, kScreenWidth/375*kcycleLayerWidth, kScreenWidth/375*kcycleLayerWidth)];
    cycleLayer.path = circlePath.CGPath;
    
    CALayer * iconLayer = [[CALayer alloc] init];
    iconLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"loadingImage"].CGImage);
    iconLayer.frame = CGRectMake(0, 0, kScreenWidth/375*(kcycleLayerWidth-2), kScreenWidth/375*(kcycleLayerWidth-2));
    iconLayer.masksToBounds = YES;
    iconLayer.cornerRadius = (kScreenWidth/375*(kcycleLayerWidth-1))/2;
    iconLayer.position = point;
    _iconLayer = iconLayer;
    
    [self.layer addSublayer:loadingBorder];
    [self.layer addSublayer:cycleLayer];
    [self.layer addSublayer:iconLayer];

    CABasicAnimation * strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.fromValue = @(-1);
    strokeStartAnimation.toValue = @(1);
    
    CABasicAnimation * strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.fromValue = @(0);
    strokeEndAnimation.toValue = @(1);
    
    CAAnimationGroup * animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.duration = KAnimationDuration;
    animationGroup.repeatCount = HUGE_VALF;
    animationGroup.animations = @[strokeStartAnimation, strokeEndAnimation];
    [cycleLayer addAnimation:animationGroup forKey:@"animationGroup"];
    
    CABasicAnimation * rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotateAnimation.fromValue = 0;
    rotateAnimation.toValue = @(M_PI * 2);
    rotateAnimation.repeatCount = HUGE_VALF;
    rotateAnimation.duration = KAnimationDuration * 4;
    [cycleLayer addAnimation:rotateAnimation forKey:@"rotateAnimation"];

}

- (void)hideLoadingView
{
    [self.loadingBorder removeFromSuperlayer];
    [self.cycleLayer removeFromSuperlayer];
    [self.iconLayer removeFromSuperlayer];
}

- (void)loadEndWithNoContent:(NSString*)title image:(UIImage*)noContentImage withRetryButton:(BOOL)withRetryButton {
    [self removeAllSubviews];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    contentView.tag = kLoadingViewTagContentView;
    [self addSubview:contentView];
    
    CGFloat marginTop = 0.f;
    
    if (noContentImage) {
        UIImageView *imgView = [[UIImageView alloc] initWithImage:noContentImage];
        imgView.frame = CGRectMake((contentView.width-imgView.width)/2, marginTop, imgView.width, imgView.height);
        [contentView addSubview:imgView];
        marginTop += imgView.height;
        marginTop +=35.f;
    }
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.width, 0)];
    lbl.text = title;
    lbl.textColor = [UIColor colorWithHexString:@"B2B2B2"];
    lbl.font = [UIFont systemFontOfSize:15.f];
    lbl.textAlignment = NSTextAlignmentCenter;
    [lbl sizeToFit];
    lbl.frame = CGRectMake((contentView.width-lbl.width)/2, marginTop, lbl.width, lbl.height);
    [contentView addSubview:lbl];
    
    marginTop += lbl.height;
    marginTop += 25.f;

    if (withRetryButton) {
        WEAKSELF;
        CommandButton *retyBtn = [[CommandButton alloc] initWithFrame:CGRectMake((contentView.width-150)/2,marginTop, 150, 36)];
        retyBtn.layer.masksToBounds = YES;
        retyBtn.layer.borderWidth = 0.5f;
        retyBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
        retyBtn.backgroundColor  = [UIColor clearColor];
        [retyBtn setTitleColor:[UIColor colorWithHexString:@"1A1A1A"] forState:UIControlStateNormal];
        [retyBtn setTitle:@"重新加载" forState:UIControlStateNormal];
        retyBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [retyBtn sizeToFit];
        retyBtn.frame = CGRectMake((contentView.width-retyBtn.width-20)/2,marginTop, retyBtn.width+20, 36);
        retyBtn.layer.cornerRadius = 36/2;
        retyBtn.layer.masksToBounds = YES;
        retyBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.handleRetryBtnClicked) {
                weakSelf.handleRetryBtnClicked(weakSelf);
            }
        };
        [contentView addSubview:retyBtn];
        marginTop += retyBtn.height;
    }
    marginTop += 30;
    contentView.frame = CGRectMake(0, (self.height-marginTop)/2, self.width, marginTop);
}

- (void)loadEndWithError:(NSString*)title {
    [self removeAllSubviews];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    contentView.tag = kLoadingViewTagContentView;
    [self addSubview:contentView];
    
    CGFloat marginTop = 0.f;
    
    UIImage *img = [[NetworkManager sharedInstance] isReachable]?[UIImage imageNamed:@"load_failed_icon_new"]:[UIImage imageNamed:@"net_noreachable_icon_new"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake((contentView.width-imgView.width)/2, marginTop, imgView.width, imgView.height);
    [contentView addSubview:imgView];
    
    marginTop += imgView.height;
    marginTop +=35.f;
    
    if (title && [title length]>0) {
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.width, 0)];
        lbl.text = title;
        lbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        lbl.font = [UIFont systemFontOfSize:15.f];
        lbl.textAlignment = NSTextAlignmentCenter;
        [lbl sizeToFit];
        lbl.frame = CGRectMake((contentView.width-lbl.width)/2, marginTop, lbl.width, lbl.height);
        [contentView addSubview:lbl];
        
        marginTop += lbl.height;
        marginTop += 25.f;
    }
    
    WEAKSELF;
    CommandButton *retyBtn = [[CommandButton alloc] initWithFrame:CGRectMake((contentView.width-150)/2,marginTop, 150, 36)];
    retyBtn.layer.masksToBounds = YES;
    retyBtn.layer.borderWidth = .5f;
    retyBtn.layer.borderColor = [UIColor colorWithHexString:@"b2b2b2"].CGColor;
    retyBtn.layer.cornerRadius = 36/2;
    retyBtn.layer.masksToBounds = YES;
    retyBtn.backgroundColor  = [UIColor clearColor];
    [retyBtn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
    [retyBtn setTitle:@"重新加载" forState:UIControlStateNormal];
    retyBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [retyBtn sizeToFit];
    retyBtn.frame = CGRectMake((contentView.width-retyBtn.width-20)/2,marginTop, retyBtn.width+20, 36);
    retyBtn.handleClickBlock = ^(CommandButton *sender) {
        if (weakSelf.handleRetryBtnClicked) {
            weakSelf.handleRetryBtnClicked(weakSelf);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf showLoadingView];
            });
        }
    };
    [contentView addSubview:retyBtn];
    
    marginTop += retyBtn.height;
    marginTop += 30.f;
    contentView.frame = CGRectMake(0, (self.height-marginTop)/2, self.width, marginTop);
}

- (void)showRemindLoginView {
    [self removeAllSubviews];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
    contentView.tag = kLoadingViewTagContentView;
    [self addSubview:contentView];
    
    CGFloat marginTop = 0.f;
    
    UIImage *img = [UIImage imageNamed:@"remind_login_icon.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithImage:img];
    imgView.frame = CGRectMake((contentView.width-imgView.width)/2, marginTop, imgView.width, imgView.height);
    [contentView addSubview:imgView];
    
    marginTop += imgView.height;
    marginTop +=15.f;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, contentView.width, 0)];
    lbl.text = @"请登录爱丁猫";
    lbl.textColor = [UIColor colorWithHexString:@"333333"];
    lbl.font = [UIFont systemFontOfSize:15.f];
    lbl.textAlignment = NSTextAlignmentCenter;
    [lbl sizeToFit];
    lbl.frame = CGRectMake((contentView.width-lbl.width)/2, marginTop, lbl.width, lbl.height);
    [contentView addSubview:lbl];
    
    marginTop += lbl.height;
    marginTop += 15.f;
    
    WEAKSELF;
    CommandButton *retyBtn = [[CommandButton alloc] initWithFrame:CGRectMake((contentView.width-150)/2,marginTop, 150, 40)];
    retyBtn.layer.masksToBounds = YES;
    retyBtn.layer.borderWidth = 1.0f;
    retyBtn.layer.cornerRadius = 20;
    retyBtn.layer.borderColor = [UIColor colorWithHexString:@"D0b87F"].CGColor;
    retyBtn.backgroundColor  = [UIColor clearColor];
    [retyBtn setTitleColor:[UIColor colorWithHexString:@"C0A870"] forState:UIControlStateNormal];
    [retyBtn setTitle:@"登录" forState:UIControlStateNormal];
    retyBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [retyBtn sizeToFit];
    retyBtn.frame = CGRectMake((contentView.width-retyBtn.width-20)/2,marginTop, retyBtn.width+20, 40);
    retyBtn.handleClickBlock = ^(CommandButton *sender) {
        if (weakSelf.handleRetryBtnClicked) {
            weakSelf.handleRetryBtnClicked(weakSelf);
        }
    };
    [contentView addSubview:retyBtn];
    
    marginTop += retyBtn.height;
    
    contentView.frame = CGRectMake(0, (self.height-marginTop)/2, self.width, marginTop);
}

+ (LoadingView*)createLoadingView:(UIView*)forView {
    LoadingView *loadingView = [[LoadingView alloc] initWithFrame:forView.bounds];
    loadingView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    [forView addSubview:loadingView];
    return loadingView;
}

+ (LoadingView*)loadingView:(UIView*)forView {
    NSArray *subviews = [forView subviews];
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[LoadingView class]]) {
            return (LoadingView*)view;
        }
    }
    return nil;
}

+ (void)removeLoadingView:(UIView*)forView {
    NSArray *subviews = [forView subviews];
    for (UIView *view in subviews) {
        if ([view isKindOfClass:[LoadingView class]]) {
            [view removeFromSuperview];
        }
    }
}

+ (LoadingView*)showRemindLoginView:(UIView*)forView {
    [self removeLoadingView:forView];
    LoadingView *loadingView = [self createLoadingView:forView];
    [loadingView showRemindLoginView];
    return loadingView;
}

+ (LoadingView*)showLoadingView:(UIView*)forView {
    [self removeLoadingView:forView];
    LoadingView *loadingView = [self createLoadingView:forView];
    [loadingView showLoadingView];
    return loadingView;
}

+ (void)hideLoadingView:(UIView*)forView {
    [self removeLoadingView:forView];
}

+ (LoadingView*)loadEndWithNoContent:(UIView*)forView title:(NSString*)title {
    [self removeLoadingView:forView];
    LoadingView *loadingView = [self createLoadingView:forView];
    [loadingView loadEndWithNoContent:title image:[UIImage imageNamed:@"no_content_icon_new"] withRetryButton:NO];
    return loadingView;
}

+ (LoadingView*)loadEndWithNoContentWithRetryButton:(UIView*)forView title:(NSString*)title {
    [self removeLoadingView:forView];
    LoadingView *loadingView = [self createLoadingView:forView];
    [loadingView loadEndWithNoContent:title image:[UIImage imageNamed:@"no_content_icon_new"] withRetryButton:YES];
    return loadingView;
}

+ (LoadingView*)loadEndWithNoContent:(UIView*)forView title:(NSString*)title image:(UIImage*)noContentImage {
    [self removeLoadingView:forView];
    LoadingView *loadingView = [self createLoadingView:forView];
    [loadingView loadEndWithNoContent:title image:noContentImage withRetryButton:NO];
    return loadingView;
}

+ (LoadingView*)loadEndWithError:(UIView*)forView title:(NSString*)title {
    [self removeLoadingView:forView];
    LoadingView *loadingView = [self createLoadingView:forView];
    [loadingView loadEndWithError:title];
    return loadingView;
}

@end



//case XMEmptyViewImageNone:
//str = @"Cat_nonepage";
//break;
//case XMEmptyViewImageWrong:
//str = @"Cat_wrong";
//break;
//case XMEmptyViewImageNetError:
//str = @"net_wrong";
//break;
//default:
//str = @"star";
//break;
//}
//



