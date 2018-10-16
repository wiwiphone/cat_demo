//
//  GuideView.m
//  XianMao
//
//  Created by simon cai on 13/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "GuideView.h"
#import "BaseTableViewCell.h"
#import "RecommendInfo.h"

NSString *const kHAHA = @"kText";
NSString *const mineNewViewctroller = @"mineNewViewctroller";

@interface GuideView ()

@property (nonatomic, assign) NSInteger addGuite;

@end

@implementation GuideView
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

+ (BOOL)isNeedShowText {
    BOOL isFirstStart = NO;
    NSString *firstStart =  [[NSUserDefaults standardUserDefaults] objectForKey:kHAHA];
    if (firstStart == nil || [firstStart isEqualToString:@""] ) {
        isFirstStart = YES;
    }
    return isFirstStart;
}

+ (BOOL)isNeedShowWaitItGuideView {
    BOOL isFirstStart = NO;
    NSString *firstStart =  [[NSUserDefaults standardUserDefaults] objectForKey:kGuideGoodsDetailWant];
    if (firstStart == nil || [firstStart isEqualToString:@""] ) {
        isFirstStart = YES;
    }
    return isFirstStart;
}

+ (BOOL)isNeedShowGuideViewInMineViewCtroller {
    BOOL isFirstStart = NO;
    NSString *firstStart =  [[NSUserDefaults standardUserDefaults] objectForKey:mineNewViewctroller];
    if (firstStart == nil || [firstStart isEqualToString:@""] ) {
        isFirstStart = YES;
    }
    return isFirstStart;
}

+ (void)showWaitItGuideView:(UIView*)fromView {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kGuideGoodsDetailWant];
    
    GuideView *view = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wantit_guide1136"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    
    CGPoint pt = [view convertPoint:CGPointMake(0, 0) fromView:fromView];
    
    CGRect frame = imageView.frame;
    frame.origin.y = (pt.y+fromView.height-imageView.height);
    frame.origin.x = view.width-imageView.width-5;
    imageView.frame = frame;
    
    view.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [view removeFromSuperview];
    };
}

+ (void)showNewUserGuideViewInMineViewController:(UIView*)fromView
{
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:mineNewViewctroller];
    
    GuideView *view = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_3"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    
    CGRect frame = imageView.frame;
    imageView.frame = CGRectMake(kScreenWidth-frame.size.width-10, 155+84, frame.size.width, frame.size.height);
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [path appendPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(kScreenWidth - kScreenWidth/375*83, 155+5, kScreenWidth/375*70, kScreenWidth/375*70)] bezierPathByReversingPath]];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [view.layer setMask:shapeLayer];
    
    view.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [view removeFromSuperview];
    };

}

+ (void)showMainRedGuideView:(UIView*)fromView {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kGuideGoodsDetailWant];
    
    GuideView *view = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Recover_TwoQi_NewPage_MF"]];
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.userInteractionEnabled = YES;
    UIView *redView = [[UIView alloc] init];
    [view addSubview:redView];
    
    CGPoint pt = [view convertPoint:CGPointMake(0, 0) fromView:fromView];
    
    CGRect frame = redView.frame;
    if (kScreenWidth == 414) {
        frame.origin.y = (pt.y+fromView.height/2 + 2);
        frame.origin.x = view.centerX - redView.width / 2 - 3;//view.width-imageView.width-5;
    } else if (kScreenWidth < 330) {
        frame.origin.y = (pt.y+fromView.height/2 + 10);
        frame.origin.x = view.centerX - redView.width / 2 - 3;//view.width-imageView.width-5;
    } else {
        frame.origin.y = (pt.y+fromView.height/2);
        frame.origin.x = view.centerX - redView.width / 2 - 3;//view.width-imageView.width-5;
    }
    redView.frame = frame;
    
    view.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [view removeFromSuperview];
    };
}

+ (void)showMainGuideView:(UIView*)fromView {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kGuideGoodsDetailWant];
    
    GuideView *view = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sendPublishGuide"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    
    CGPoint pt = [view convertPoint:CGPointMake(0, 0) fromView:fromView];
    
    CGRect frame = imageView.frame;
    if (kScreenWidth == 414) {
        frame.origin.y = (pt.y+fromView.height/2 - 160);
        frame.origin.x = kScreenWidth/4/2/2;//view.centerX - imageView.width / 2;//view.width-imageView.width-5;
    } else if (kScreenWidth < 330) {
        frame.origin.y = (pt.y+fromView.height/2 - 90);
        frame.origin.x = kScreenWidth/4/2/2;//view.centerX - imageView.width / 2;//view.width-imageView.width-5;
    } else {
        frame.origin.y = (pt.y+fromView.height/2-140);
        frame.origin.x = kScreenWidth/4/2/2;//view.centerX - imageView.width / 2;//view.width-imageView.width-5;
    }
    imageView.frame = frame;
    
    view.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [view removeFromSuperview];
    };
}

+ (void)showIssueGuideView:(UIView*)fromView {
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kGuideGoodsDetailWant];
    
    GuideView *view = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [[[UIApplication sharedApplication] keyWindow] addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"issue_goude_MF"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    
    CGPoint pt = [view convertPoint:CGPointMake(0, 0) fromView:fromView];
    
    CGRect frame = imageView.frame;
    if (kScreenWidth == 414) {
        frame.origin.y = (pt.y+fromView.height-imageView.height - 18);
        frame.origin.x = view.centerX - imageView.width / 2;//view.width-imageView.width-5;
    } else {
        frame.origin.y = (pt.y+fromView.height-imageView.height - 10);
        frame.origin.x = view.centerX - imageView.width / 2;//view.width-imageView.width-5;
    }
    imageView.frame = frame;
    imageView.frame = CGRectMake(frame.origin.x, (kScreenHeight - imageView.height) / 2., frame.size.width, frame.size.height);
    
    
    view.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [view removeFromSuperview];
    };
}

- (void)showNewUserGuideView:(NSMutableArray *)dateSources guideView:(GuideView *)guideView reOffset:(CGFloat)reOffset addGuite:(NSInteger)addGuite
{
    
    CGFloat height = 0;
    for (NSDictionary * dict in dateSources) {
        RecommendInfo * recommendInfo = [dict objectForKey:@"recommendInfo"];
        Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        if (recommendInfo.type == kRecommendTypeWaterFollow) {
            break;
        }else{
            height += [clsTableViewCell rowHeightForPortrait:dict];
        }
    }
    NSLog(@"%.2f------%.2f------%.2f", height, height-reOffset, kScreenHeight-225);
    if ((height > kScreenHeight-255 && height - reOffset > 200)) {
        [guideView removeFromSuperview];
        return;
    }
    
    if (addGuite == 1) {
        GuideView *view = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
        [self addSubview:view];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"welcomeToAdm"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        imageView.userInteractionEnabled = YES;
        [view addSubview:imageView];
        
        CGRect frame = imageView.frame;
        imageView.frame = frame;
        imageView.frame = CGRectMake((kScreenWidth-frame.size.width)/2, height - frame.size.height-reOffset-60, frame.size.width, frame.size.height);
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        //    if (IS_IPHONE_6P) {
        [path appendPath:[[UIBezierPath bezierPathWithOvalInRect:CGRectMake(kScreenWidth/2-kScreenWidth/375*86/2, height+10-reOffset-60, kScreenWidth/375*80, kScreenWidth/375*80)] bezierPathByReversingPath]];
        //    }
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.path = path.CGPath;
        [self.layer setMask:shapeLayer];
        view.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [view removeFromSuperview];
            [guideView removeFromSuperview];
//            [self showNewUserSeconGuideView:dateSources reOffset:reOffset];
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kGuideGoodsDetailWant];
        };
    } else {
        [guideView removeFromSuperview];
    }
    
}

- (void)showNewUserSeconGuideView:(NSMutableArray *)dateSources reOffset:(CGFloat)reOffset
{
    CGFloat height = 0;
    for (NSDictionary * dict in dateSources) {
        RecommendInfo * recommendInfo = [dict objectForKey:@"recommendInfo"];
        Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
        height += [clsTableViewCell rowHeightForPortrait:dict];
        if (recommendInfo.type == kRecommendTypeWaterFollow) {
            break;
        }
    }
    
    GuideView *view = [[GuideView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    [self addSubview:view];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide_2"]];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    imageView.userInteractionEnabled = YES;
    [view addSubview:imageView];
    
    CGRect frame = imageView.frame;
    imageView.frame = frame;
    imageView.frame = CGRectMake((kScreenWidth-frame.size.width)/2, height-77-10 - reOffset-50+100, frame.size.width, frame.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [path appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(10, height-77-10 - reOffset-50, kScreenWidth-20, 77) byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(77, 77)] bezierPathByReversingPath]];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    [self.layer setMask:shapeLayer];
    WEAKSELF;
    view.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:kGuideGoodsDetailWant];
        [view removeFromSuperview];
        [weakSelf removeFromSuperview];
    };
    
}

@end


NSString *const kGuideGoodsDetailWant = @"kGuideGoodsDetailWant";


