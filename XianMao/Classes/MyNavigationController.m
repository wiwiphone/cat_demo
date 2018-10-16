//
//  MyNavigationController.m
//  XianMao
//
//  Created by simon cai on 11/3/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "MyNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+Snapshot.h"

#import "UIView+Snapshot.h"
#import "SloppySwiper.h"

#import "BaseViewController.h"

@interface MyNavigationController () <UIGestureRecognizerDelegate>
//{
//    CGPoint startTouch;//拖动时的开始坐标
//    BOOL isMoving;//是否在拖动中
//    UIView *blackMask;//那层黑面罩
//    
//    UIImageView *lastScreenShotView;//截图
//}

//@property (nonatomic,retain) UIView *backgroundView;//背景
//@property (nonatomic,retain) NSMutableArray *screenShotsList;//存截图
//
@property(nonatomic,strong) SloppySwiper *swiper;

@end

@implementation MyNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        // 只少2个 头一个肯定是顶级的界面
       // self.screenShotsList = [[NSMutableArray alloc]initWithCapacity:2];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    //拖动手势
//    UIPanGestureRecognizer *panGesture=[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
//    //添加手势
//    panGesture.delegate = self;
//    [self.view addGestureRecognizer:panGesture];
//    
//    //是否开始拖动
//    isMoving = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismissViewControllerAnimated: (BOOL)flag completion: (void (^)(void))completion {
    
    BOOL shouldToDismiss = YES;
    if (self.myNaigationDelegate && [self.myNaigationDelegate respondsToSelector:@selector(willDismissNavigationController:)]) {
        shouldToDismiss = [self.myNaigationDelegate willDismissNavigationController:self];
    }
    
    if (shouldToDismiss) {
        [super dismissViewControllerAnimated:YES completion:completion];
    }
}

- (void)dismissModalViewControllerAnimated:(BOOL)animated {
    
    BOOL shouldToDismiss = YES;
    if (self.myNaigationDelegate && [self.myNaigationDelegate respondsToSelector:@selector(willDismissNavigationController:)]) {
        shouldToDismiss = [self.myNaigationDelegate willDismissNavigationController:self];
    }
    if (shouldToDismiss) {
        [super dismissModalViewControllerAnimated:animated];
    }
}


#define CAN_ROTATE  0

#pragma mark -------------rotate---------------
//<iOS6
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
#if CAN_ROTATE
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
#else
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
#endif
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
//iOS6+
- (BOOL)shouldAutorotate
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationOrientationChange object:nil];
#if CAN_ROTATE
    return YES;
#else
    return NO;
#endif
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //    return [UIApplication sharedApplication].statusBarOrientation;
	return UIInterfaceOrientationPortrait;
}
#endif

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    if ([self.viewControllers count]>0) {
        NSInteger index = [self.viewControllers count] - 1;
        UIViewController *viewController = [self.viewControllers objectAtIndex:index];
        if ([viewController isKindOfClass:[BaseViewController class]]) {
            [((BaseViewController*)viewController) handleSwipBackGuesture];
        }
    }
    return [super popViewControllerAnimated:animated];
}


//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    CGPoint translation=[gestureRecognizer locationInView:WINDOW];
//    
//    if (translation.x>0 && translation.x < kScreenWidth / 3.f) {
//        return YES;
//    }
//    
//    return NO;
//}
//
////拖动手势
//-(void)handlePanGesture:(UIGestureRecognizer*)sender{
//    
//    //如果是顶级viewcontroller，结束
//    if (self.viewControllers.count <= 1) return;
//    
//    //得到触摸中在window上拖动的过程中的xy坐标
//    CGPoint translation=[sender locationInView:WINDOW];
//    //状态结束，保存数据
//    if(sender.state == UIGestureRecognizerStateEnded){
//        //NSLog(@"结束%f,%f",translation.x,translation.y);
//        isMoving = NO;
//        
//        self.backgroundView.hidden = NO;
//        //如果结束坐标大于开始坐标50像素就动画效果移动
//        if (translation.x - startTouch.x > kScreenWidth / 3.f) {
//            [UIView animateWithDuration:0.3 animations:^{
//                //动画效果，移动
//                [self moveViewWithX:kScreenWidth];
//            } completion:^(BOOL finished) {
//                //返回上一层
//                [self popViewControllerAnimated:NO];
//                //并且还原坐标
//                CGRect frame = self.view.frame;
//                frame.origin.x = 0;
//                self.view.frame = frame;
//            }];
//            
//        }else{
//            //不大于50时就移动原位
//            [UIView animateWithDuration:0.3 animations:^{
//                //动画效果
//                [self moveViewWithX:0];
//            } completion:^(BOOL finished) {
//                //背景隐藏
//                self.backgroundView.hidden = YES;
//            }];
//        }
//        return;
//        
//    }else if(sender.state == UIGestureRecognizerStateBegan){
//        //NSLog(@"开始%f,%f",translation.x,translation.y);
//        //开始坐标
//        startTouch = translation;
//        //是否开始移动
//        isMoving = YES;
//        if (!self.backgroundView)
//        {
//            //添加背景
//            CGRect frame = self.view.frame;
//            self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
//            //把backgroundView插入到Window视图上，并below低于self.view层
//            [WINDOW insertSubview:self.backgroundView belowSubview:self.view];
//            
//            //在backgroundView添加黑色的面罩
//            blackMask = [[UIView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width , frame.size.height)];
//            blackMask.backgroundColor = [UIColor clearColor];
//            [self.backgroundView addSubview:blackMask];
//        }
//        self.backgroundView.hidden = NO;
//        
//        if (lastScreenShotView) [lastScreenShotView removeFromSuperview];
//        
//        //数组中最后截图
//        UIImage *lastScreenShot = [self.screenShotsList lastObject];
//        //并把截图插入到backgroundView上，并黑色的背景下面
//        lastScreenShotView = [[UIImageView alloc]initWithImage:lastScreenShot];
//        [self.backgroundView insertSubview:lastScreenShotView belowSubview:blackMask];
//        
//    }
//    
//    if (isMoving) {
//        [self moveViewWithX:translation.x - startTouch.x];
//        
//    }
//}
//- (void)moveViewWithX:(float)x
//{
//    
//    //NSLog(@"Move to:%f",x);
////    x = x>320?320:x;
//    x = x<0?0:x;
//    
//    CGRect frame = self.view.frame;
//    frame.origin.x = x;
//    self.view.frame = frame;
//    
//    float scale = 1;//(x/6400)+0.95;//缩放大小
//    float alpha = 0.4 - (x/800);//透明值
//    
//    //缩放scale
//    lastScreenShotView.transform = CGAffineTransformMakeScale(scale, scale);
//    //背景颜色透明值
//    blackMask.alpha = alpha;
//    
//}
////把UIView转化成UIImage，实现截屏
//- (UIImage *)ViewRenderImage
//{
////    Class class = [self.view class];
////    return [self.view toImage];
////    return [UIImage imageNamed:@"consign_edincat"];
////    NSLog(@"%@",NSStringFromCGRect(self.view.bounds));
//    //创建基于位图的图形上下文 Creates a bitmap-based graphics context with the specified options.:UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale),size大小，opaque是否透明，不透明（YES），scale比例缩放
//    
//    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
//
//    //当前层渲染到上下文
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    //[self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
//    
//    //上下文形成图片
//    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();
//    //结束并删除当前基于位图的图形上下文。
//    UIGraphicsEndImageContext();
//    
//    //反回图片
//    return img;
//}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

//#pragma Navagation 覆盖方法
//-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    //图像数组中存放一个当前的界面图像，然后再push
//    [self.screenShotsList addObject:[self ViewRenderImage]];
//    //[self.screenShotsList addObject:[self.view getSnapshot]];
//    [super pushViewController:viewController animated:animated];
//}
//
//-(UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    //移除最后一个
//    [self.screenShotsList removeLastObject];
//    return [super popViewControllerAnimated:animated];
//}

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {
    MyNavigationController *navController = [super initWithRootViewController:rootViewController];
    self.swiper = [[SloppySwiper alloc] initWithNavigationController:navController];
    navController.delegate = self.swiper;
    return navController;
}

@end



