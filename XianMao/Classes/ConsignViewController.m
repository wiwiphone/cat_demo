//
//  ConsignViewController.m
//  XianMao
//
//  Created by simon on 12/2/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ConsignViewController.h"
#import "MyNavigationController.h"

#import "UIView+FirstResponder.h"
#import "UIScrollView+KeyboardCtrl.h"

#import "WebViewController.h"

#import "CoordinatingController.h"

#import "DataSources.h"
#import "Session.h"
#import "NetworkAPI.h"

#import "Command.h"
#import "UIActionSheet+Blocks.h"
#import "URLScheme.h"

@interface ConsignViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *topView;
@property(nonatomic,strong) UIView *bottomView;

@property(nonatomic,strong) ConsignSubmitPicsViewController *submitPicsViewController;
@property(nonatomic,strong) ConsignSubmitedViewController *submitedViewController;

@end

@implementation ConsignViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"卖东西"];
    //[super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    // [super setupTopBarRightButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:_scrollView];
    
    CGRect frame = self.topView.frame;
    frame.origin.y = 0;
    self.topView.frame = frame;
    [_scrollView addSubview:self.topView];
    
    frame = self.bottomView.frame;
    frame.origin.y = self.topView.bounds.size.height;
    self.bottomView.frame = frame;
    [_scrollView addSubview:self.bottomView];
    
    if (_scrollView.bounds.size.height<self.topView.bounds.size.height+self.bottomView.bounds.size.height) {
        _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, self.topView.bounds.size.height+self.bottomView.bounds.size.height);
    }
    
    CALayer *bgLayer = [CALayer layer];
    bgLayer.backgroundColor = [UIColor colorWithHexString:@"523437"].CGColor;
    bgLayer.frame = CGRectMake(0, -_scrollView.bounds.size.height, _scrollView.bounds.size.width, _scrollView.bounds.size.height);
    [_scrollView.layer addSublayer:bgLayer];
    
    [super bringTopBarToTop];
}

- (void)dealloc
{
    
}

- (UIView*)topView
{
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        _topView.backgroundColor = [UIColor colorWithHexString:@"523437"];
        
        CGFloat marginTop = 0.f;
        UIView *stepView = [[UIView alloc] initWithFrame:CGRectMake(0, marginTop, _topView.bounds.size.width, 45.f)];
        stepView.backgroundColor = [UIColor colorWithHexString:@"392426"];
        [_topView addSubview:stepView];
        marginTop += stepView.bounds.size.height;
        
        {
            UIImage *rightArrowImage = [UIImage imageNamed:@"consign_right_arrow.png"];
            CALayer *rightArrowLayer = [CALayer layer];
            rightArrowLayer.contents = (id)[rightArrowImage CGImage];
            rightArrowLayer.frame = CGRectMake((stepView.bounds.size.width-rightArrowImage.size.width)/2, 0, rightArrowImage.size.width, rightArrowImage.size.height);
            [stepView.layer addSublayer:rightArrowLayer];
            
            UIImage *step1Image = [UIImage imageNamed:@"consign_step1.png"];
            CALayer *step1ImageLayer = [CALayer layer];
            step1ImageLayer.contents = (id)[step1Image CGImage];
            step1ImageLayer.frame = CGRectMake(15.f, (stepView.bounds.size.height-step1Image.size.height)/2, step1Image.size.width, step1Image.size.height);
            [stepView.layer addSublayer:step1ImageLayer];
            
            CGFloat step1TextLblY = step1ImageLayer.frame.origin.x+step1ImageLayer.bounds.size.width+10.f;
            UILabel *step1TextLbl = [[UILabel alloc] initWithFrame:CGRectNull];
            step1TextLbl.textColor = [UIColor colorWithHexString:@"8A7577"];
            step1TextLbl.text = @"上传商品照片";
            step1TextLbl.font = [UIFont systemFontOfSize:13.f];
            [step1TextLbl sizeToFit];
            step1TextLbl.frame = CGRectMake(step1TextLblY, (stepView.bounds.size.height-step1TextLbl.bounds.size.height)/2, step1TextLbl.bounds.size.width, step1TextLbl.bounds.size.height);
            [stepView addSubview:step1TextLbl];
            
            CGFloat step2ImageLayerX = rightArrowLayer.frame.origin.x+rightArrowLayer.bounds.size.width+23.5f;
            UIImage *step2Image = [UIImage imageNamed:@"consign_step2.png"];
            CALayer *step2ImageLayer = [CALayer layer];
            step2ImageLayer.contents = (id)[step2Image CGImage];
            step2ImageLayer.frame = CGRectMake(step2ImageLayerX, (stepView.bounds.size.height-step2Image.size.height)/2, step2Image.size.width, step2Image.size.height);
            [stepView.layer addSublayer:step2ImageLayer];
            
            CGFloat step2TextLblY = step2ImageLayer.frame.origin.x+step2ImageLayer.bounds.size.width+10.f;
            UILabel *step2TextLbl = [[UILabel alloc] initWithFrame:CGRectNull];
            step2TextLbl.textColor = [UIColor colorWithHexString:@"8A7577"];
            step2TextLbl.text = @"寄出商品";
            step2TextLbl.font = [UIFont systemFontOfSize:13.f];
            [step2TextLbl sizeToFit];
            step2TextLbl.frame = CGRectMake(step2TextLblY, (stepView.bounds.size.height-step2TextLbl.bounds.size.height)/2, step2TextLbl.bounds.size.width, step2TextLbl.bounds.size.height);
            [stepView addSubview:step2TextLbl];
        }
        
        marginTop += 24.f;
        
        UILabel *stepDescLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        stepDescLbl.font = [UIFont systemFontOfSize:13.f];
        stepDescLbl.text = @"只要两步轻松寄卖商品";
        stepDescLbl.textColor = [UIColor colorWithHexString:@"917376"];
        [stepDescLbl sizeToFit];
        stepDescLbl.frame = CGRectMake((_topView.bounds.size.width-stepDescLbl.bounds.size.width)/2, marginTop, stepDescLbl.bounds.size.width, stepDescLbl.bounds.size.height);
        [_topView addSubview:stepDescLbl];
        
        marginTop += stepDescLbl.bounds.size.height;
        marginTop += 26.f;
        
        CommandButton *consignBtn = [[CommandButton alloc] initWithFrame:CGRectMake((_topView.bounds.size.width-220)/2, marginTop, 220, 55)];
        [consignBtn setTitle:@"我要寄卖" forState:UIControlStateNormal];
        [consignBtn setTitleColor:[UIColor colorWithHexString:@"523437"] forState:UIControlStateNormal];
        consignBtn.backgroundColor = [DataSources globalButtonColor];//[UIColor colorWithHexString:@"fff"];//@"D0B87F"];
        consignBtn.titleLabel.font = [UIFont systemFontOfSize:19.f];
        consignBtn.layer.masksToBounds = YES;
        consignBtn.layer.cornerRadius = 15.f;
        [_topView addSubview:consignBtn];
        
        marginTop += consignBtn.bounds.size.height;
        marginTop += 28.5f;
        
        _topView.frame = CGRectMake(0, marginTop, self.view.bounds.size.width, marginTop);
        
        WEAKSELF;
        consignBtn.handleClickBlock = ^(CommandButton *sender) {
            [MobClick event:@"click_consignment"];
            ConsignSubmitPicsViewController *viewController = [[ConsignSubmitPicsViewController alloc] init];
            [[CoordinatingController sharedInstance] presentViewController:viewController animated:YES completion:^{
            }];
//            weakSelf.submitPicsViewController = viewController;
//            
//            viewController.view.hidden = NO;
//            viewController.view.frame = CGRectMake(0, weakSelf.view.height, weakSelf.view.width, weakSelf.view.height);
//            viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//            viewController.view.tag = 100;
//            [weakSelf.view addSubview:viewController.view];
//            
////            CGRect endFrame = viewController.view.bounds;
////            [UIView animateWithDuration:0.3f animations:^{
////                viewController.view.frame = endFrame;
////            } completion:^(BOOL finished) {
////                viewController.view.frame = endFrame;
////            }];
//            
//            CGRect endFrame = viewController.view.bounds;
//            [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//                viewController.view.frame = endFrame;
//            } completion:^(BOOL finished) {
//                viewController.view.frame = endFrame;
//            }];
        };
    }
    return _topView;
}

- (UIView*)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        CGFloat marginTop = 0.f;
        marginTop += 50.f;
        
        NSArray *consignFaqLbls = [self consignFaqLbls];
        for (int i=0;i<[consignFaqLbls count];i++) {
            NSDictionary *dict = [consignFaqLbls objectAtIndex:i];
            UIButton *faqBtnLbl = [self createFaqLbl:[dict objectForKey:@"icon"]
                                               title:[dict objectForKey:@"title"]
                                          titleColor:[UIColor colorWithHexString:@"917376"]
                                                font:[UIFont systemFontOfSize:14.f]];
            [faqBtnLbl sizeToFit];
            faqBtnLbl.frame = CGRectMake(38, marginTop, _bottomView.bounds.size.width, faqBtnLbl.bounds.size.height);
            [_bottomView addSubview:faqBtnLbl];
            marginTop += faqBtnLbl.bounds.size.height;
            marginTop += 18.f;
        }
        
        marginTop += 11.5f;
        
        float faqBtnHeight = IS_IPHONE_6P ? 45 : 30;
        CommandButton *faqBtn = [[CommandButton alloc] initWithFrame:CGRectMake((_bottomView.bounds.size.width-225)/2, marginTop, 225, faqBtnHeight)];
        [faqBtn setTitle:@"查看更多寄卖FAQ" forState:UIControlStateNormal];
        [faqBtn setTitleColor:[UIColor colorWithHexString:@"D0B87F"] forState:UIControlStateNormal];
        faqBtn.backgroundColor = [UIColor whiteColor];
        faqBtn.titleLabel.font = [UIFont systemFontOfSize:IS_IPHONE_6P?14.0f:11.5f];
        faqBtn.layer.borderWidth = 1.f;
        faqBtn.layer.borderColor = [UIColor colorWithHexString:@"D0B87F"].CGColor;
        faqBtn.layer.masksToBounds=YES;
        faqBtn.layer.cornerRadius=15;
        [_bottomView addSubview:faqBtn];
        
        marginTop += faqBtn.bounds.size.height;
        marginTop += 40.f;
        
        _bottomView.frame = CGRectMake(0, 0, self.view.bounds.size.width, marginTop);
        
        WEAKSELF;
        faqBtn.handleClickBlock = ^(CommandButton *sender) {
            WebViewController *viewController = [[WebViewController alloc] init];
            viewController.url = kURLFaq;
            viewController.title = @"寄卖FAQ";
            [weakSelf pushViewController:viewController animated:YES];
            
//            UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
//            
//            [weakSelf presentViewController:navController animated:YES completion:^{
//            }];
        };
    }
    
    return _bottomView;
}

- (NSArray*)consignFaqLbls {
    UIImage *iconYes = [UIImage imageNamed:@"sale_faq_icon_yes.png"];
    UIImage *iconNo = [UIImage imageNamed:@"sale_faq_icon_no.png"];
    NSMutableArray *faqs = [[NSMutableArray alloc] init];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"箱包、腕表、手饰、服装、配饰",@"title",iconYes,@"icon",nil]];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"商品无瑕疵，看起来几乎全新",@"title",iconYes,@"icon",nil]];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"干净没有异味的商品",@"title",iconYes,@"icon",nil]];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"过去5年之内的款式",@"title",iconYes,@"icon",nil]];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"脏的、损坏了的或者破旧的商品",@"title",iconNo,@"icon",nil]];
    [faqs addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"其他任何类目的商品",@"title",iconNo,@"icon",nil]];
    return faqs;
}

- (UIButton*)createFaqLbl:(UIImage*)icon title:(NSString*)title titleColor:(UIColor*)titleColor font:(UIFont*)font {
    UIButton *faqLbl = [[UIButton alloc] initWithFrame:CGRectNull];
    [faqLbl setImage:icon forState:UIControlStateDisabled];
    [faqLbl setTitle:title forState:UIControlStateDisabled];
    [faqLbl setTitleEdgeInsets: UIEdgeInsetsMake(0, 19, 0, 0)];
    faqLbl.titleLabel.font = font;
    [faqLbl setTitleColor:titleColor forState:UIControlStateNormal];
    faqLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    faqLbl.enabled = NO;
    return faqLbl;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)$$handleConsignCloseNotification:(id<MBNotification>)notifi
{
//    [self dismiss];
}

- (void)$$handleConsignDidFinishNotification:(id<MBNotification>)notifi ordersNum:(NSInteger)ordersNum
{
//    WEAKSELF;
//    ConsignSubmitedViewController *viewController = [[ConsignSubmitedViewController alloc] init];
//    weakSelf.submitedViewController = viewController;
//    
//    viewController.view.hidden = NO;
//    viewController.view.frame = CGRectMake(0, weakSelf.view.height, weakSelf.view.width, weakSelf.view.height);
//    viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    viewController.view.tag = 200;
//    [weakSelf.view addSubview:viewController.view];
//    
//    CGRect endFrame = viewController.view.bounds;
//    [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
//        viewController.view.frame = endFrame;
//    } completion:^(BOOL finished) {
//        viewController.view.frame = endFrame;
//    }];
}

- (void)$$handleConsignContinueNotification:(id<MBNotification>)notifi
{
//    WEAKSELF;
//    CGRect endFrame = CGRectMake(0, weakSelf.view.height, weakSelf.view.width, weakSelf.view.height);
//    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
//        weakSelf.submitedViewController.view.frame = endFrame;
//    } completion:^(BOOL finished) {
//        [weakSelf.submitedViewController.view removeFromSuperview];
//        weakSelf.submitedViewController = nil;
//    }];
}

//- (void)handleTopBarBackButtonClicked:(UIButton *)sender
//{
//
//}

@end


#import "ActionSheet.h"
#import "UIImage+Resize.h"
#import "AppDirs.h"

#import "AssetPickerController.h"

#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>


@interface ConsignImagePickerController : UIImagePickerController

@property(nonatomic,assign) NSInteger userData;

@end
@implementation ConsignImagePickerController

@end

@interface ConsignAssetPickerController : AssetPickerController

@property(nonatomic,assign) NSInteger userData;

@end
@implementation ConsignAssetPickerController

@end

@interface ConsignSubmitPicsViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate,AssetPickerControllerDelegate,ConsignOrdersChangedReceiver>


@property(nonatomic,strong) UIView *picsView;
@property(nonatomic,strong) ADMActionSheet *actionSheet;
@property(nonatomic,strong) NSMutableDictionary *picFilePathDicts;

@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,strong) ConsignSubmitedViewController *submitedViewController;


@end

@implementation ConsignSubmitPicsViewController

- (void)dealloc
{
    self.submitedViewController = nil;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [DataSources globalThemeColor];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"寄卖服务"];
    [super setupTopBarBackButton:[UIImage imageNamed:@"close.png"] imgPressed:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    [self.view addSubview:_scrollView];
    
    CGFloat marginTop = 0.f;
    
    marginTop += 22.f;
    
    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
    titleLbl.text = @"请提供1-4张寄卖商品的图片";
    titleLbl.textColor = [DataSources globalThemeTextColor];
    titleLbl.font = [UIFont systemFontOfSize:13.f];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [titleLbl sizeToFit];
    titleLbl.frame = CGRectMake(0, marginTop, _scrollView.bounds.size.width, titleLbl.bounds.size.height);
    [_scrollView addSubview:titleLbl];
    
    marginTop += titleLbl.bounds.size.height;
    marginTop += 22;
    
    _picsView = [[UIView alloc] initWithFrame:CGRectMake(15, marginTop, _scrollView.bounds.size.width-30, _scrollView.bounds.size.width-30)];
    [_scrollView addSubview:_picsView];
    {
        CGFloat btnWidth = (_picsView.bounds.size.width-10)/2;
        CGFloat btnHeight = btnWidth;
        
        UIButton *addBtn = [self crateAddBtn:CGRectMake(0, 0, btnWidth, btnHeight) tag:0];
        [_picsView addSubview:addBtn];
        addBtn = [self crateAddBtn:CGRectMake(btnWidth+10, 0, btnWidth, btnHeight) tag:1];
        [_picsView addSubview:addBtn];

        addBtn = [self crateAddBtn:CGRectMake(0, btnHeight+10, btnWidth, btnHeight) tag:2];
        [_picsView addSubview: addBtn];
        addBtn = [self crateAddBtn:CGRectMake(btnWidth+10, btnHeight+10, btnWidth, btnHeight) tag:3];
        [_picsView addSubview:addBtn];
    }
    
    marginTop += _picsView.bounds.size.height;
    marginTop += 40.f;
    
    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake((_scrollView.bounds.size.width-200)/2, marginTop, 200, 40)];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[DataSources globalThemeColor] forState:UIControlStateNormal];
    [submitBtn setBackgroundColor:[DataSources globalThemeTextColor]];
    submitBtn.layer.masksToBounds=YES;
    submitBtn.layer.cornerRadius=15;
    [_scrollView addSubview:submitBtn];
    
    marginTop += submitBtn.bounds.size.height;
    marginTop += 40.f;
    
    _scrollView.contentSize = CGSizeMake(_scrollView.bounds.size.width, marginTop);
    _scrollView.alwaysBounceVertical = YES;
    
    self.marginTop = marginTop;
    
    [super bringTopBarToTop];
    
    [AppDirs cleanupConsignsDir];
}

- (UIButton*)crateAddBtn:(CGRect)frame tag:(NSInteger)tag {
    UIButton *addBtn = [[UIButton alloc] initWithFrame:frame];
    [addBtn addTarget:self action:@selector(addPics:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn setImage:[UIImage imageNamed:@"consign_add.png"] forState:UIControlStateNormal];
    addBtn.backgroundColor = [UIColor colorWithHexString:@"5E3C3F"];
    addBtn.tag = tag;
    addBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    CAShapeLayer *border = [CAShapeLayer layer];
    border.frame = addBtn.bounds;
    border.path = [UIBezierPath bezierPathWithRect:addBtn.bounds].CGPath;
    border.strokeColor = [UIColor colorWithHexString:@"977478"].CGColor;
    border.fillColor = nil;
    border.lineDashPattern = @[@3, @3];
    [addBtn.layer addSublayer:border];
    return addBtn;
}

- (void)addPics:(UIButton*)sender
{
    NSInteger tag = sender.tag;
    WEAKSELF;
//    self.actionSheet = [[ADMActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSArray arrayWithObjects:@"从手机相册选择", @"拍照",nil] cancelBlock:^{
//        
//    } destructiveBlock:nil otherBlock:^(NSInteger index) {
//        if (index == 0) {
//            ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
//            if (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined) {
//                //从手机相册选择
//                ConsignAssetPickerController * imagePicker =  [[ConsignAssetPickerController alloc] init];
//                imagePicker.userData = tag;
//                imagePicker.minimumNumberOfSelection = 1;
//                imagePicker.maximumNumberOfSelection = 4;
//                imagePicker.delegate = weakSelf;
//                imagePicker.assetsFilter = [ALAssetsFilter allPhotos];
//                imagePicker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
//                    if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
//                        return NO;
//                    } else {
//                        return YES;
//                    }
//                }];
//                [weakSelf presentViewController:imagePicker animated:YES completion:^{
//                }];
//            } else {
//                UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"提示"
//                                                                     message:@"请在iPhone的\"设置-隐私-相片\"选项中,允许爱丁猫访问你的相册"
//                                                                    delegate:self
//                                                           cancelButtonTitle:nil
//                                                           otherButtonTitles:@"确定", nil];
//                [alertView show];
//            }
//            
//        } else if (index==1) {
//            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//            if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
//                //拍照
//                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
//                    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//                        NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
//                        ConsignImagePickerController *imagePicker = [[ConsignImagePickerController alloc] init];
//                        imagePicker.userData = tag;
//                        imagePicker.delegate = weakSelf;
//                        imagePicker.allowsEditing = YES;
//                        imagePicker.sourceType = sourceType;
//                        imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
//                        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
//                        imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
//                        imagePicker.showsCameraControls = YES;
//                        [weakSelf presentViewController:imagePicker animated:YES completion:^{
//                        }];
//                    }];
//                }
//            }
//            else {
//                UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
//                                                                     message:@"请在iPhone的\"设置-隐私-相机\"选项中,允许爱丁猫访问你的相机"
//                                                                    delegate:self
//                                                           cancelButtonTitle:nil
//                                                           otherButtonTitles:@"确定", nil];
//                [alertView show];
//            }
//        }
//    } tapMaskBlock:nil];
//    [self.actionSheet showInView:self.view];
    [UIActionSheet showInView:weakSelf.view
                    withTitle:nil
            cancelButtonTitle:@"取消"
       destructiveButtonTitle:nil
            otherButtonTitles:[NSArray arrayWithObjects:@"从手机相册选择", @"拍照",nil]
                     tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                         if (buttonIndex == 0 ) {
                             ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
                             if (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined) {
                                 //从手机相册选择
                                 ConsignAssetPickerController * imagePicker =  [[ConsignAssetPickerController alloc] init];
                                 imagePicker.userData = tag;
                                 imagePicker.minimumNumberOfSelection = 1;
                                 imagePicker.maximumNumberOfSelection = 4;
                                 imagePicker.delegate = weakSelf;
                                 imagePicker.assetsFilter = [ALAssetsFilter allPhotos];
                                 imagePicker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                                     if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                                         return NO;
                                     } else {
                                         return YES;
                                     }
                                 }];
                                 [weakSelf presentViewController:imagePicker animated:YES completion:^{
                                 }];
                             } else {
                                 UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@"提示"
                                                                                      message:@"请在iPhone的\"设置-隐私-相片\"选项中,允许爱丁猫访问你的相册"
                                                                                     delegate:self
                                                                            cancelButtonTitle:nil
                                                                            otherButtonTitles:@"确定", nil];
                                 [alertView show];
                             }
                         } else if (buttonIndex==1) {
                             AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
                             if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
                                 //拍照
                                 if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                                     [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                                         NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
                                         ConsignImagePickerController *imagePicker = [[ConsignImagePickerController alloc] init];
                                         imagePicker.userData = tag;
                                         imagePicker.delegate = weakSelf;
                                         imagePicker.allowsEditing = YES;
                                         imagePicker.sourceType = sourceType;
                                         imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
                                         imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                                         imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
                                         imagePicker.showsCameraControls = YES;
                                         [weakSelf presentViewController:imagePicker animated:YES completion:^{
                                         }];
                                     }];
                                 }
                             }
                             else {
                                 UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
                                                                                      message:@"请在iPhone的\"设置-隐私-相机\"选项中,允许爱丁猫访问你的相机"
                                                                                     delegate:self
                                                                            cancelButtonTitle:nil
                                                                            otherButtonTitles:@"确定", nil];
                                 [alertView show];
                             }
                         }
                         
                     }];

}

- (void)handleImagePicked:(NSInteger)userData image:(UIImage*)image filePath:(NSString*)filePath {
    if (!_picFilePathDicts) {
        _picFilePathDicts = [[NSMutableDictionary alloc] initWithCapacity:4];
    }
    NSArray *subviews = [self.picsView subviews];
    NSInteger index = userData<[subviews count]?userData:userData-[subviews count];
    if (index>=0&&index<[subviews count]) {
        UIButton *btn = (UIButton*)[subviews objectAtIndex:index];
        [btn setImage:image forState:UIControlStateNormal];
        [_picFilePathDicts setObject:filePath forKey:[NSNumber numberWithInteger:btn.tag]];
    }
}

- (void)handleImagePicked:(UIImage*)image filePath:(NSString*)filePath {
    UIButton *btn = (UIButton*)[[self.picsView subviews] objectAtIndex:0];
    [btn setImage:image forState:UIControlStateNormal];
//    
//    NSArray *array = [NSArray arrayWithObjects:filePath, nil];
//    
//    _request = [[NetworkAPI sharedInstance] applyOrder:[Session sharedInstance].currentUserId fullPathArray:array];
}

//#pragma mark - Processing the status bar
//-(void)navigationController:(UINavigationController *)navigationController
//     willShowViewController:(UIViewController *)viewController
//                   animated:(BOOL)animated
//{
//    [[UIApplication sharedApplication] setStatusBarHidden:YES];
//}
//
//-(BOOL)prefersStatusBarHidden   // iOS8 definitely needs this one. checked.
//{
//    return YES;
//}
//
//-(UIViewController *)childViewControllerForStatusBarHidden
//{
//    return nil;
//}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSInteger userData = -1;
    if ([picker isKindOfClass:[ConsignImagePickerController class]]) {
        userData = ((ConsignImagePickerController*)picker).userData;
    }
    WEAKSELF;
    UIImage *originalImage= info[UIImagePickerControllerEditedImage] ? info[UIImagePickerControllerEditedImage] : info[UIImagePickerControllerOriginalImage];
    if (originalImage) {
        
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            UIImage *image = originalImage;
            
            {
                CGSize originalSize = originalImage.size;
                CGRect cropFrame = CGRectZero;
                if (originalSize.width>originalSize.height) {
                    cropFrame = CGRectMake((originalSize.width-originalSize.height)/2,0,originalSize.height,originalSize.height);
                    image = [originalImage croppedImage:cropFrame];
                } else if (originalSize.width<originalSize.height) {
                    cropFrame = CGRectMake(0,(originalSize.height-originalSize.width)/2,originalSize.width,originalSize.width);
                    image = [originalImage croppedImage:cropFrame];
                }
            }
            
            CGSize originalSize = originalImage.size;
            if (originalSize.width == kADMConsignImageSize && originalSize.height== kADMConsignImageSize) {
                //... originalImage
            } else {
                if (originalSize.width == originalSize.height) {
                    if (originalSize.width>kADMConsignImageSize) {
                        CGSize size = CGSizeMake(kADMConsignImageSize, kADMConsignImageSize);
                        UIImage *scaledImage = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationMedium];
                        image = scaledImage;
                    } else {
                        //... originalImage
                    }
                } else {
                    if (originalSize.width < kADMConsignImageSize && originalSize.height<kADMConsignImageSize) {
                        //... originalImage
                    } else {
                        CGRect cropFrame = CGRectZero;
                        if (originalSize.width>originalSize.height) {
                            cropFrame = CGRectMake((originalSize.width-originalSize.height)/2,0,originalSize.height,originalSize.height);
                        } else {
                            cropFrame = CGRectMake(0,(originalSize.height-originalSize.width)/2,originalSize.width,originalSize.width);
                        }
                        UIImage *croppedImage = [originalImage croppedImage:cropFrame];
                        CGSize size = CGSizeMake(kADMConsignImageSize, kADMConsignImageSize);
                        UIImage *scaledImage = [croppedImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationMedium];
                        image = scaledImage;
                    }
                }
            }
            
            NSString *filePath = [AppDirs saveConsignsPicture:image fileName:nil];
            //float fileSize =  [AppDirs fileSizeK:filePath];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [weakSelf handleImagePicked:userData image:image filePath:filePath];
            });
        });
    }

    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}


-(void)assetPickerController:(AssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if (assets.count == 0) return;
    
    __block NSInteger userData = -1;
    if ([picker isKindOfClass:[ConsignAssetPickerController class]]) {
        userData = ((ConsignAssetPickerController*)picker).userData;
    }
    
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (int i=0; i<assets.count; i++) {
            ALAsset *asset=assets[i];
            UIImage *originalImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            
            UIImage *image = originalImage;
            
            {
                CGSize originalSize = originalImage.size;
                CGRect cropFrame = CGRectZero;
                if (originalSize.width>originalSize.height) {
                    cropFrame = CGRectMake((originalSize.width-originalSize.height)/2,0,originalSize.height,originalSize.height);
                    image = [originalImage croppedImage:cropFrame];
                } else if (originalSize.width<originalSize.height) {
                    cropFrame = CGRectMake(0,(originalSize.height-originalSize.width)/2,originalSize.width,originalSize.width);
                    image = [originalImage croppedImage:cropFrame];
                }
            }
            
            CGSize originalSize = originalImage.size;
            if (originalSize.width == kADMConsignImageSize && originalSize.height== kADMConsignImageSize) {
                //... originalImage
            } else {
                if (originalSize.width == originalSize.height) {
                    if (originalSize.width>kADMConsignImageSize) {
                        CGSize size = CGSizeMake(kADMConsignImageSize, kADMConsignImageSize);
                        UIImage *scaledImage = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationMedium];
                        image = scaledImage;
                    } else {
                        //... originalImage
                    }
                } else {
                    if (originalSize.width < kADMConsignImageSize && originalSize.height<kADMConsignImageSize) {
                        //... originalImage
                    } else {
                        CGSize scaledSize = CGSizeZero;
                        if (originalSize.width>originalSize.height) {
                            CGFloat scaledHeight = originalSize.height<kADMConsignImageSize?originalSize.height:kADMConsignImageSize;
                            scaledSize = CGSizeMake(originalSize.width*scaledHeight/originalSize.height, scaledHeight);
                        } else {
                            CGFloat scaledWidth = originalSize.width<kADMConsignImageSize?originalSize.width:kADMConsignImageSize;
                            scaledSize = CGSizeMake(scaledWidth, originalSize.height*scaledWidth/originalSize.width);
                        }
                        UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:scaledSize interpolationQuality:kCGInterpolationMedium];
                        image = scaledImage;
                        
//                        CGRect cropFrame = CGRectZero;
//                        if (originalSize.width>originalSize.height) {
//                            cropFrame = CGRectMake((originalSize.width-originalSize.height)/2,0,originalSize.height,originalSize.height);
//                        } else {
//                            cropFrame = CGRectMake(0,(originalSize.height-originalSize.width)/2,originalSize.width,originalSize.width);
//                        }
//                        UIImage *croppedImage = [originalImage croppedImage:cropFrame];
//                        CGSize size = CGSizeMake(kADMConsignImageSize, kADMConsignImageSize);
//                        UIImage *scaledImage = [croppedImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationMedium];
//                        image = scaledImage;
                    }
                }
            }
            
            
            NSString *filePath = [AppDirs saveConsignsPicture:image fileName:nil];
            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [weakSelf handleImagePicked:userData image:image filePath:filePath];
                userData += 1;
            });
        }
    });
    
    //double fileSize =  [AppDirs fileSizeK:filePath];
}

-(void)assetPickerControllerDidCancel:(AssetPickerController *)picker {
    
}

-(void)assetPickerController:(AssetPickerController *)picker didSelectAsset:(ALAsset*)asset {
    
}

-(void)assetPickerController:(AssetPickerController *)picker didDeselectAsset:(ALAsset*)asset {
    
}

-(void)assetPickerControllerDidMaximum:(AssetPickerController *)picker {
    
    [super showHUD:@"最多只能选4张图片" hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
}

-(void)assetPickerControllerDidMinimum:(AssetPickerController *)picker {
    
}

- (void)submit:(UIButton*)sender
{
    if (!_picFilePathDicts || [_picFilePathDicts count]==0) {
        [super showHUD:@"请选择至少1张图片" hideAfterDelay:0.8f forView:self.scrollView];
    } else {
        [MobClick event:@"click_submit_cosignment"];
        NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:4];
        for (NSInteger i=0;i<[_picsView subviews].count;i++) {
            if ([_picFilePathDicts objectForKey:[NSNumber numberWithInteger:i]]) {
                NSString *filePath = [_picFilePathDicts objectForKey:[NSNumber numberWithInteger:i]];
                [array addObject:filePath];
            }
        }
        MBGlobalSendNotificationForSELWithBody(@selector($$touchConsignButton:filePaths:), array);
    }
    
//    MBGlobalSendNotificationForSELWithBody(@selector($$handleConsignDidFinishNotification:ordersNum:), nil);
}

- (void)$$handleConsignDidFinishNotification:(id<MBNotification>)notifi ordersNum:(NSInteger)ordersNum
{
        WEAKSELF;
        ConsignSubmitedViewController *viewController = [[ConsignSubmitedViewController alloc] init];
        weakSelf.submitedViewController = viewController;
    
        viewController.view.hidden = NO;
        viewController.view.frame = CGRectMake(0, weakSelf.view.height, weakSelf.view.width, weakSelf.view.height);
        viewController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        viewController.view.tag = 200;
        [weakSelf.view addSubview:viewController.view];
    
        CGRect endFrame = viewController.view.bounds;
        [UIView animateWithDuration:0.3f delay:0 options:UIViewAnimationOptionTransitionCurlUp animations:^{
            viewController.view.frame = endFrame;
        } completion:^(BOOL finished) {
            viewController.view.frame = endFrame;
        }];
}

- (void)handleTopBarBackButtonClicked:(UIButton *)sender
{
//    MBGlobalSendConsignCloseNotification();
    [self dismiss];
}

- (void)$$handleConsignContinueNotification:(id<MBNotification>)notifi
{
    for (NSInteger i=0;i<[_picsView subviews].count;i++) {
        UIButton *btn = (UIButton*)[[_picsView subviews] objectAtIndex:i];
        [btn setImage:[UIImage imageNamed:@"consign_add.png"] forState:UIControlStateNormal];
    }
    
    [_picFilePathDicts removeAllObjects];
    
    WEAKSELF;
    CGRect endFrame = CGRectMake(0, weakSelf.view.height, weakSelf.view.width, weakSelf.view.height);
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionTransitionCurlDown animations:^{
        weakSelf.submitedViewController.view.frame = endFrame;
    } completion:^(BOOL finished) {
        [weakSelf.submitedViewController.view removeFromSuperview];
        weakSelf.submitedViewController = nil;
    }];
}

- (void)$$handleConsignCloseNotification:(id<MBNotification>)notifi
{
    [self dismiss];
}

@end


@interface ConsignSubmitedViewController ()

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;

@end

@implementation ConsignSubmitedViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [DataSources globalThemeColor];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"寄卖服务"];
    [super setupTopBarBackButton:[UIImage imageNamed:@"close.png"] imgPressed:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollView.alwaysBounceVertical  =YES;
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"523437"];
    [self.view addSubview:_scrollView];
    
    CGRect frame = self.contentView.frame;
    frame.origin.y = _scrollView.bounds.size.height/8;
    self.contentView.frame = frame;
    [_scrollView addSubview:self.contentView];
    
    [super bringTopBarToTop];
}

- (UIView*)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
        
        CGFloat marginTop = 0.f;
        
        UIImage *edinCatImage = [UIImage imageNamed:@"consign_edincat.png"];
        UIImageView *edinCatView = [[UIImageView alloc] initWithFrame:CGRectMake((_contentView.bounds.size.width-edinCatImage.size.width)/2, marginTop, edinCatImage.size.width, edinCatImage.size.height)];
        edinCatView.image = edinCatImage;
        [_contentView addSubview:edinCatView];
        
        marginTop += edinCatView.bounds.size.height;
        marginTop += 37;
        
        UILabel *successLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        successLbl.text = @"提交成功！";
        successLbl.textColor = [UIColor colorWithHexString:@"D0B87F"];
        successLbl.backgroundColor = [UIColor clearColor];
        successLbl.font = [UIFont systemFontOfSize:17.5f];
        [successLbl sizeToFit];
        successLbl.frame = CGRectMake((_contentView.bounds.size.width-successLbl.bounds.size.width)/2+5, marginTop, successLbl.bounds.size.width, successLbl.bounds.size.height);
        [_contentView addSubview:successLbl];
        
        marginTop += successLbl.bounds.size.height;
        marginTop += 15.f;
        
        UILabel *serviceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        serviceLbl.backgroundColor = [UIColor clearColor];
        serviceLbl.textColor = [UIColor colorWithHexString:@"977478"];
        serviceLbl.font = [UIFont systemFontOfSize:12.5f];
        serviceLbl.numberOfLines = 0;
        serviceLbl.textAlignment = NSTextAlignmentCenter;
        NSString *labelText = @"      我们将在24小时内与你联系，\n你可以在”我的“中看到你的寄卖状态";
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:4];//调整行间距
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
        serviceLbl.attributedText = attributedString;
        [serviceLbl sizeToFit];
        serviceLbl.frame = CGRectMake((_contentView.bounds.size.width-serviceLbl.bounds.size.width)/2, marginTop, serviceLbl.bounds.size.width, serviceLbl.bounds.size.height);
        [_contentView addSubview:serviceLbl];
        
        marginTop += serviceLbl.bounds.size.height;
        
        marginTop += 17;
        
        CommandButton *continueBtn = [[CommandButton alloc] initWithFrame:CGRectMake((_contentView.bounds.size.width-200)/2, marginTop, 200, 40)];
        continueBtn.backgroundColor = [DataSources globalButtonColor];//[UIColor colorWithHexString:@"D0B87F"];
        continueBtn.layer.masksToBounds = YES;
        continueBtn.layer.cornerRadius = 15.f;
        [continueBtn setTitle:@"继续寄卖" forState:UIControlStateNormal];
        [continueBtn setTitleColor:[UIColor colorWithHexString:@"523437"] forState:UIControlStateNormal];
        continueBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_contentView addSubview:continueBtn];
        
        marginTop += continueBtn.bounds.size.height;
        
        _contentView.frame = CGRectMake(0, 0, self.view.bounds.size.width, marginTop);
        
        continueBtn.handleClickBlock = ^(CommandButton *sender) {
            MBGlobalSendConsignContinueNotification();
        };
    }
    return _contentView;
}

- (void)handleTopBarBackButtonClicked:(UIButton *)sender
{
    MBGlobalSendConsignCloseNotification();
}

@end



#import "SepTableViewCell.h"
#import "ConsignOrderTableViewCell.h"
#import "ConsignOrder.h"
#import "DataListLogic.h"

#import "PullRefreshTableView.h"
#import "NSDictionary+Additions.h"

@interface ConsignOrderListViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property(nonatomic,strong) PullRefreshTableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSources;

@property(nonatomic,strong) DataListLogic *dataListLogic;
@property(nonatomic,strong) HTTPRequest *request;

@end

@implementation ConsignOrderListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"我的寄卖"];
    [super setupTopBarBackButton];
    
    self.tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    [self initDataListLogic];
    
    [self.tableView reloadData];
}

- (void)dealloc {
    [_request cancel];
}

- (void)handleReachabilityChanged:(id)notificationObject {
    //self.tableView.enableLoadingMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
}

- (void)initDataListLogic {
    WEAKSELF;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"consignment" path:@"get_orders" pageSize:10];
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        if (needReloadList) {
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
            for (int i=0;i<[addedItems count];i++) {
                if (i>0) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                [newList addObject:[ConsignOrderTableViewCell buildCellDict:[ConsignOrder createWithDict:[addedItems objectAtIndex:i]]]];
            }
            weakSelf.dataSources = newList;
            [weakSelf.tableView reloadData];
        } else {
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
            for (int i=0;i<[addedItems count];i++) {
                if (i>0) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                [newList addObject:[ConsignOrderTableViewCell buildCellDict:[ConsignOrder createWithDict:[addedItems objectAtIndex:i]]]];
            }
            
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0  && [newList count]>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[newList count]];
            for (int i=0;i<[newList count];i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [indexPaths addObject:indexPath];
                [dataSources insertObject:[newList objectAtIndex:i] atIndex:i];
            }
            
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
        }
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            if (i>0) {
                [newList addObject:[SepTableViewCell buildCellDict]];
            }
            [newList addObject:[ConsignOrderTableViewCell buildCellDict:[ConsignOrder createWithDict:[addedItems objectAtIndex:i]]]];
        }
        if ([newList count]>0) {
            NSInteger count = [weakSelf.dataSources count];
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                [newList insertObject:[SepTableViewCell buildCellDict] atIndex:0];
            }
            [dataSources addObjectsFromArray:newList];
            
           
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[newList count]];
            for (int i=0;i<[newList count];i++) {
                 NSInteger index = count+i;
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [indexPaths addObject:indexPath];
            }
            
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView beginUpdates];
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
            [weakSelf.tableView endUpdates];
        }
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContent:@"无寄售商品"];
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic firstLoadFromCache];
    
    [weakSelf showLoadingView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [_dataListLogic reloadDataList];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [_dataListLogic nextPage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ConsignOrder *consignOrder = [[_dataSources objectAtIndex:[indexPath row]] objectForKey:[ConsignOrderTableViewCell cellDictKeyForConsignOrder]];
    if (consignOrder) {
        ConsignOrderDetailViewController *viewController = [[ConsignOrderDetailViewController alloc] init];
        viewController.consignOrder = consignOrder;
        [self.navigationController pushViewController:viewController animated:YES];
    }
}

@end

#import "TTTAttributedLabel.h"
#import "URLScheme.h"

@interface ConsignOrderDetailViewController () <TTTAttributedLabelDelegate>

@property(nonatomic,strong) UIScrollView *scrollView;
@property(nonatomic,strong) UIView *contentView;

@end

@implementation ConsignOrderDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"寄卖订单详情"];
    [super setupTopBarBackButton];
    //    [super setupTopBarRightButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
    _scrollView.alwaysBounceVertical  =YES;
    _scrollView.backgroundColor = [UIColor colorWithHexString:@"523437"];
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:self.contentView];
    
    [super bringTopBarToTop];
}

- (UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
        
        CGFloat marginTop = 0.f;
        
        CALayer *sideLine = [CALayer layer];
        sideLine.backgroundColor = [UIColor colorWithHexString:@"392426"].CGColor;
        sideLine.frame = CGRectMake(40, marginTop, 2, 8);
        [_contentView.layer addSublayer:sideLine];
        marginTop += 8;
        
        for (NSInteger i=0; i<[_consignOrder.statusIems count];i++) {
            NSDictionary *dict = [_consignOrder.statusIems objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                UIView *view = [self createItemView:dict currentStatus:_consignOrder.status isLastOne:i==[_consignOrder.statusIems count]-1?YES:NO];
                CGRect frame = view.frame;
                frame.origin.y = marginTop;
                view.frame = frame;
                [_contentView addSubview:view];
                
                marginTop += view.height;
            }
        }
        
        _contentView.frame = CGRectMake(0, 0, self.view.width, marginTop);
    }
    return _contentView;
}

- (UIView*)createItemView:(NSDictionary*)statusDict currentStatus:(NSInteger)currentStatus isLastOne:(BOOL)isLastOne;
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0)];
    
    CGFloat marginTop = 0.f;
    marginTop += 21.5f;
    
    UIColor *textColor = [UIColor whiteColor];
    NSInteger status = [statusDict consignOrderStatus];
    if (status<currentStatus)
        textColor = [UIColor whiteColor];
    else if (status>currentStatus)
        textColor = [UIColor colorWithHexString:@"977478"];
    else
        textColor = [UIColor colorWithHexString:@"DBC492"];
    
    TTTAttributedLabel *textLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(80,marginTop, self.view.width-80-30, 0)];
    textLbl.linkAttributes = nil;
    textLbl.font = [UIFont systemFontOfSize:13.f];
    textLbl.delegate = self;
    textLbl.numberOfLines = 0;
    textLbl.textColor = textColor;
    
    NSString *statusString = [statusDict consignOrderContent];
    NSRange rangePhoneDisplay = [statusString rangeOfString:kCustomServicePhoneDisplay];
    NSRange rangePhone = [statusString rangeOfString:kCustomServicePhone];
    
    [textLbl setText:statusString afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *attrString) {
        if (rangePhoneDisplay.length>0) {
            [attrString addAttribute:(NSString*)kCTForegroundColorAttributeName
                               value:(id)[UIColor colorWithHexString:@"C7AF7A"].CGColor
                               range:rangePhoneDisplay];
        }
        if (rangePhone.length>0) {
            [attrString addAttribute:(NSString*)kCTForegroundColorAttributeName
                               value:(id)[UIColor colorWithHexString:@"C7AF7A"].CGColor
                               range:rangePhone];
        }
        return attrString;
    }];
    if (rangePhoneDisplay.length>0) {
        [textLbl addLinkToURL:nil withRange:rangePhoneDisplay];
    }
    if (rangePhone.length>0) {
        [textLbl addLinkToURL:nil withRange:rangePhone];
    }
    
    [textLbl sizeToFit];
    textLbl.frame = CGRectMake(80, marginTop, self.view.width-80-30, textLbl.height);
    [view addSubview:textLbl];
    
    marginTop += textLbl.height;
    
    marginTop += 23.f;
    
    if (!isLastOne) {
        CALayer *bottomLine = [CALayer layer];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"4A2F31"].CGColor;
        bottomLine.frame = CGRectMake(80, marginTop, self.view.width-80, 1);
        [view.layer addSublayer:bottomLine];
        marginTop += bottomLine.bounds.size.height;
    }
    
    
    CALayer *sideLine = [CALayer layer];
    sideLine.backgroundColor = [UIColor colorWithHexString:@"392426"].CGColor;
    if (isLastOne)
        sideLine.frame = CGRectMake(40, 0, 2, marginTop/2);
    else
        sideLine.frame = CGRectMake(40, 0, 2, marginTop);
    [view.layer addSublayer:sideLine];
    
    CALayer *circlelayer = [CALayer layer];
    circlelayer.masksToBounds = YES;
    circlelayer.cornerRadius = 10.f;
    circlelayer.backgroundColor = [UIColor colorWithHexString:@"392426"].CGColor;
    circlelayer.frame = CGRectMake(sideLine.frame.origin.x-(20-2)/2, (marginTop-20)/2, 20, 20);
    [view.layer addSublayer:circlelayer];
    
    
    CALayer *sublayer = [CALayer layer];
    sublayer.masksToBounds = YES;
    sublayer.cornerRadius = 6.f;
    if (status<=currentStatus)
        sublayer.backgroundColor = [UIColor colorWithHexString:@"C7AF7A"].CGColor;
    else
        sublayer.backgroundColor = [UIColor colorWithHexString:@"523437"].CGColor;
    sublayer.frame = CGRectMake(sideLine.frame.origin.x-(12-2)/2, (marginTop-12)/2, 12, 12);
    [view.layer addSublayer:sublayer];
    
    //977478
    
    view.frame = CGRectMake(0, 0, self.view.width, marginTop);
    return view;
}

- (void)attributedLabel:(TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    WEAKSELF;
    ADMActionSheet *actionSheet = [[ADMActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:[NSArray arrayWithObjects:@"拨打客服电话", nil] cancelBlock:^{
        
    } destructiveBlock:nil otherBlock:^(NSInteger index) {
        if (index == 0) {
            NSString *phoneNumber = [@"tel://" stringByAppendingString:kCustomServicePhone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
    } tapMaskBlock:nil];
    
    [actionSheet showInView:weakSelf.view];
}

@end


/*
 
 1,2,3->10
 
6
 
 [
    1:"",2:"",3"",6:"",8:""
 ]
 
 */

//@interface ConsignServiceViewController ()
//
//@end
//
//@implementation ConsignServiceViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.view.backgroundColor = [UIColor orangeColor];
//    
//    CGFloat topBarHeight = [super setupTopBar];
//    [super setupTopBarTitle:@"寄卖服务"];
//    [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
//    //    [super setupTopBarRightButton:[UIImage imageNamed:@"close"] imgPressed:nil];
//    
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
//    scrollView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
//    scrollView.userInteractionEnabled = YES;
//    scrollView.alwaysBounceVertical = YES;
//    [self.view addSubview:scrollView];
//    
//    UIImageView *edinCatView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sale_edincat"]];
//    CGRect frame = edinCatView.bounds;
//    frame.origin.y = 75.f;
//    frame.origin.x = (scrollView.bounds.size.width-edinCatView.bounds.size.width)/2;
//    edinCatView.frame = frame;
//    [scrollView addSubview:edinCatView];
//    
//    CGFloat marginTop = edinCatView.frame.origin.y+edinCatView.bounds.size.height;
//    
//    marginTop += 40.f;
//    
//    UIFont *addressLblFont = [UIFont systemFontOfSize:12.f];
//    UILabel *addressTitleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
//    addressTitleLbl.font = addressLblFont;
//    addressTitleLbl.numberOfLines = 0;
//    addressTitleLbl.textColor = [UIColor colorWithHexString:@"181818"];
//    addressTitleLbl.textAlignment = NSTextAlignmentCenter;
//    addressTitleLbl.text = @"我们的地址是:";
//    CGSize addressTitleLbllSize = [addressTitleLbl.text sizeWithFont:addressLblFont
//                                                   constrainedToSize:CGSizeMake(scrollView.bounds.size.width,MAXFLOAT)
//                                                       lineBreakMode:NSLineBreakByWordWrapping];
//    addressTitleLbl.frame = CGRectMake(0, marginTop, scrollView.bounds.size.width, addressTitleLbllSize.height);
//    [scrollView addSubview:addressTitleLbl];
//    
//    marginTop += addressTitleLbllSize.height;
//    marginTop += 5;
//    
//    UILabel *addressLbl = [[UILabel alloc] initWithFrame:CGRectNull];
//    addressLbl.font = addressLblFont;
//    addressLbl.numberOfLines = 0;
//    addressLbl.textColor = [UIColor colorWithHexString:@"181818"];
//    addressLbl.textAlignment = NSTextAlignmentCenter;
//    addressLbl.text = @"浙江省杭州市西湖区公元里3幢405A";
//    CGSize addressLblSize = [addressLbl.text sizeWithFont:addressLblFont
//                                        constrainedToSize:CGSizeMake(scrollView.bounds.size.width,MAXFLOAT)
//                                            lineBreakMode:NSLineBreakByWordWrapping];
//    addressLbl.frame = CGRectMake(0, marginTop, scrollView.bounds.size.width, addressLblSize.height);
//    [scrollView addSubview:addressLbl];
//    
//    marginTop += addressLblSize.height;
//    
//    marginTop += 30;
//    UIButton *callBtn = [[UIButton alloc] initWithFrame:CGRectMake((scrollView.bounds.size.width-170)/2, marginTop, 170, 40)];
//    callBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
//    callBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [callBtn setTitle:@"呼叫快递" forState:UIControlStateNormal];
//    [callBtn setTitleColor:[UIColor colorWithHexString:@"ff5858"] forState:UIControlStateNormal];
//    [callBtn addTarget:self action:@selector(callBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
//    callBtn.layer.borderWidth = 1.f;
//    callBtn.layer.borderColor = [UIColor colorWithHexString:@"ff5858"].CGColor;
//    callBtn.layer.masksToBounds=YES;
//    callBtn.layer.cornerRadius=5;
//    [scrollView addSubview:callBtn];
//}
//
//- (void)handleTopBarRightButtonClicked:(UIButton *)sender
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
//}
//
//- (void)callBtnClicked:(UIButton*)sender
//{
//    
//}
//
//@end
//

//#import "ConsignCateTableViewCell.h"
//#import "NSDictionary+Additions.h"
//#import "JSONKit.h"
//#import "Command.h"
//#import "Cate.h"
//
//@interface ConsignCateViewController () <UITableViewDataSource,UITableViewDelegate>
//
//@property(nonatomic,strong) UITableView *tableView;
//@property(nonatomic,strong) NSMutableArray *dataSources;
//
//@end
//
//@implementation ConsignCateViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.view.backgroundColor = [UIColor orangeColor];
//    
//    CGFloat topBarHeight = [super setupTopBar];
//    [super setupTopBarTitle:@"卖东西"];
//    [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
//    
//    
//    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
//    self.tableView.dataSource = self;
//    self.tableView.delegate = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    self.tableView.alwaysBounceVertical = YES;
//    self.tableView.showsVerticalScrollIndicator = NO;
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
//    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
//    [self.view addSubview:self.tableView];
//    
//    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 45)];
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, headerView.bounds.size.width-40, headerView.bounds.size.height)];
//    titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
//    titleLbl.font = [UIFont systemFontOfSize:17.f];
//    titleLbl.text = @"我要卖的是:";
//    [headerView addSubview:titleLbl];
//    self.tableView.tableHeaderView = headerView;
//    
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tableView.bounds.size.width, 40+40+25)];
//    UIButton *nextBtn  = [[UIButton alloc] initWithFrame:CGRectMake((footerView.bounds.size.width-170)/2, 25, 170, 40)];
//    [nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
//    [nextBtn setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
//    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
//    nextBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//    nextBtn.layer.borderWidth = 1.f;
//    nextBtn.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
//    nextBtn.layer.masksToBounds=YES;
//    nextBtn.layer.cornerRadius=5;
//    nextBtn.tag = 100;
//    nextBtn.enabled = NO;
//    [footerView addSubview:nextBtn];
//    self.tableView.tableFooterView = footerView;
//    
//    self.dataSources = [[NSMutableArray alloc] init];
//    
//    NSString* filePath =[[NSBundle mainBundle] pathForResource:@"consign_cates" ofType:@"json"];
//    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
//    NSError *error = nil;
//    JSONDecoder *parser = [JSONDecoder decoder];
//    id result = [parser mutableObjectWithData:jsonData error:&error];
//    if ([result isKindOfClass:[NSDictionary class]]) {
//        NSDictionary *dict = result;
//        NSArray *list = [dict arrayValueForKey:@"cate_list"];;
//        for (int i=0;i<[list count];i++) {
//            if ([[list objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
//                [self.dataSources addObject:[[ConsignCateTableViewCell buildCellDict:[Cate createWithDict:[list objectAtIndex:i]] selected:NO] fillActionWithParameters:^(id parameters) {
//                    
//                }]];
//            }
//        }
//    }
//    [self.tableView reloadData];
//}
//
//- (void)next:(UIButton*)sender
//{
//    NSMutableArray *cateIds = [[NSMutableArray alloc] init];
//    for (NSDictionary *dict in _dataSources) {
//        if ([[dict objectForKey:@"selected"] boolValue]) {
//            Cate *cate = (Cate*)[dict objectForKey:@"cate"];
//            [cateIds addObject:[NSNumber numberWithInteger:cate.cateId]];
//        }
//    }
//    ConsignWayViewController *viewController = [[ConsignWayViewController alloc] init];
//    viewController.cateIds = cateIds;
//    MyNavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
//    [super presentViewController:navController animated:YES completion:^{
//    }];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [_dataSources count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
//    
//    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
//    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
//    
//    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    if (tableViewCell == nil) {
//        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
//        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
//        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
//    [tableViewCell updateCellWithDict:dict];
//    
//    return tableViewCell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
//    
//    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
//    return [ClsTableViewCell rowHeightForPortrait];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSMutableDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
//    [dict setObject:[NSNumber numberWithBool:![[dict objectForKey:@"selected"] boolValue]] forKey:@"selected"];
//    
//    [tableView beginUpdates];
//    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//    [tableView endUpdates];
//    
//    BOOL hasSelected = NO;
//    for (NSDictionary *dict in _dataSources) {
//        if ([[dict objectForKey:@"selected"] boolValue]) {
//            hasSelected = YES;
//            break;
//        }
//    }
//    UIButton *nextBtn = (UIButton*)[tableView.tableFooterView viewWithTag:100];
//    nextBtn.enabled = hasSelected;
//    if ([nextBtn isEnabled]) {
//        [nextBtn setTitleColor:[UIColor colorWithHexString:@"ff5858"] forState:UIControlStateNormal];
//        nextBtn.layer.borderColor = [UIColor colorWithHexString:@"ff5858"].CGColor;
//    } else {
//        [nextBtn setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
//        nextBtn.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
//    }
//}
//
//@end
//
//@interface ConsignWayViewController ()
//
//@end
//
//@implementation ConsignWayViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.view.backgroundColor = [UIColor orangeColor];
//    
//    CGFloat topBarHeight = [super setupTopBar];
//    [super setupTopBarTitle:@"寄售订单列表"];
//    [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
// 
//    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-topBarHeight)];
//    scrollView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
//    scrollView.userInteractionEnabled = YES;
//    [self.view addSubview:scrollView];
//    
//    UIFont *titleLblFont = [UIFont systemFontOfSize:13.f];
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
//    titleLbl.font = [UIFont systemFontOfSize:13.f];
//    titleLbl.textColor = [UIColor colorWithHexString:@"181818"];
//    titleLbl.numberOfLines = 0;
//    titleLbl.text = @"我们为卖家提供最贴心的服务，您只要填写好你的地址，我们的小二将与您预约好时间，上门收货。";
//    CGSize titleLblSize = [titleLbl.text sizeWithFont:titleLblFont
//                                    constrainedToSize:CGSizeMake(scrollView.bounds.size.width-69,MAXFLOAT)
//                                        lineBreakMode:NSLineBreakByWordWrapping];
//    
//    titleLbl.frame = CGRectMake((scrollView.bounds.size.width-titleLblSize.width)/2, 32, titleLblSize.width, titleLblSize.height);
//    [scrollView addSubview:titleLbl];
//    
//    CGFloat btnWidth = 240.f;
//    CGFloat btnHeight = 60.f;
//    
//    CGFloat marginTop = (scrollView.bounds.size.height-2*btnHeight-20)/2;
//    
//    UIImage *saleBtnBg = [UIImage imageNamed:@"sale_btn_bg"];
//    UIButton *reserveBtn = [[UIButton alloc] initWithFrame:CGRectMake((scrollView.bounds.size.width-btnWidth)/2, marginTop, btnWidth, btnHeight)];
//    [reserveBtn addTarget:self action:@selector(reserveBtnCicked:) forControlEvents:UIControlEventTouchUpInside];
//    [reserveBtn setTitle:@"预约上门收货（当前仅\n支持杭州）" forState:UIControlStateNormal];
//    [reserveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [reserveBtn setBackgroundImage:[saleBtnBg stretchableImageWithLeftCapWidth:saleBtnBg.size.width/2 topCapHeight:saleBtnBg.size.height/2] forState:UIControlStateNormal];
//    reserveBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
//    reserveBtn.titleLabel.numberOfLines = 0;
//    reserveBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [scrollView addSubview:reserveBtn];
//    
//    marginTop += btnHeight;
//    marginTop += 20.f;
//    
//    UIButton *adressBtn = [[UIButton alloc] initWithFrame:CGRectMake((scrollView.bounds.size.width-btnWidth)/2, marginTop, btnWidth, btnHeight)];
//    adressBtn.titleLabel.font = [UIFont systemFontOfSize:12.f];
//    adressBtn.titleLabel.numberOfLines = 0;
//    adressBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [adressBtn setTitle:@"告诉我地址，\n我直接把商品寄给你们" forState:UIControlStateNormal];
//    [adressBtn setTitleColor:[UIColor colorWithHexString:@"ff5858"] forState:UIControlStateNormal];
//    [adressBtn addTarget:self action:@selector(adressBtnCicked:) forControlEvents:UIControlEventTouchUpInside];
//    adressBtn.layer.borderWidth = 1.f;
//    adressBtn.layer.borderColor = [UIColor colorWithHexString:@"ff5858"].CGColor;
//    adressBtn.layer.masksToBounds=YES;
//    adressBtn.layer.cornerRadius=5;
//    [scrollView addSubview:adressBtn];
//    
//    scrollView.alwaysBounceVertical = YES;
//}
//
//
//- (void)handleTopBarRightButtonClicked:(UIButton *)sender
//{
//    [self dismissViewControllerAnimated:YES completion:^{
//    }];
//}
//
//- (void)reserveBtnCicked:(UIButton*)sender
//{
//    ConsignSubmitAddressViewController *viewController = [[ConsignSubmitAddressViewController alloc] init];
//    viewController.cateIds = self.cateIds;
//    MyNavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
//    [super presentViewController:navController animated:YES completion:^{
//    }];
//    
//}
//
//- (void)adressBtnCicked:(UIButton*)sender
//{
//    ConsignServiceViewController *viewController = [[ConsignServiceViewController alloc] init];
//    MyNavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
//    [super presentViewController:navController animated:YES completion:^{
//    }];
//}
//
//@end
//
//#import "UserAddressViewController.h"
//#import "AddressInfo.h"
//#import "AreaViewController.h"
//#import "NSString+Addtions.h"
//#import "NSString+Validation.h"
//#import "PlaceHolderTextView.h"
//
//#import "LoginViewController.h"
//
//@interface ConsignSubmitAddressViewController () <UITextFieldDelegate,AreaViewControllerDelegate>
//
//@property(nonatomic,strong) UIScrollView *scrollView;
//@property(nonatomic,strong) UITextField *receiverTextFiled;
//@property(nonatomic,strong) UITextField *phoneNumberTextFiled;
//@property(nonatomic,strong) UITextField *zipcodeTextFiled;
//@property(nonatomic,strong) UITextField *areaDetailTextFiled;
//@property(nonatomic,strong) PlaceHolderTextView *addressTextView;
//
//@property(nonatomic,copy) NSString *areaName;
//@property(nonatomic,copy) NSString *districtID;
//
//@property(nonatomic,strong) NSMutableArray *addressList;
//
//@property(nonatomic,strong) HTTPRequest *request;
//
//@end
//
//@implementation ConsignSubmitAddressViewController
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
//    
//    CGFloat topBarHeight = [super setupTopBar];
//    [super setupTopBarTitle:@"上门收货地址"];
//    [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
//    
//    
//    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.bounds.size.width, self.view.bounds.size.height)];
//    _scrollView.alwaysBounceVertical  =YES;
//    [self.view addSubview:_scrollView];
//    
//    CGFloat marginTop = [self setupEditAddressView];
//    
//    marginTop += 40;
//    
//    UIButton *submitBtn = [[UIButton alloc] initWithFrame:CGRectMake((_scrollView.bounds.size.width-170)/2, marginTop, 170, 40)];
//    [submitBtn addTarget:self action:@selector(sumbitAddress:) forControlEvents:UIControlEventTouchUpInside];
//    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
//    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    submitBtn.backgroundColor = [UIColor colorWithHexString:@"ff5858"];
//    submitBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
//    submitBtn.titleLabel.numberOfLines = 0;
//    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    submitBtn.layer.masksToBounds=YES;
//    submitBtn.layer.cornerRadius=5;
//    [_scrollView addSubview:submitBtn];
//    
//    marginTop += submitBtn.bounds.size.height;
//    marginTop += 40;
//    
//    
//    _addressList = [[NSMutableArray alloc] init];
//    
//    [self loadUserAddressList];
//    
//}
//
//- (void)loadUserAddressList
//{
//    if ([Session sharedInstance].isLoggedIn) {
//        WEAKSELF;
//        _request = [[NetworkAPI sharedInstance] getUserAddressList:[Session sharedInstance].currentUserId completion:^(NSArray *addressDictList) {
//            if (addressDictList && [addressDictList count] > 0) {
//                for (NSDictionary *dict in addressDictList) {
//                    [weakSelf.addressList addObject:[AddressInfo createWithDict:dict]];
//                }
//                
//                for (AddressInfo *address in _addressList) {
//                    if ([address isDefault]) {
//                        [weakSelf updateWithAddressInfo:address];
//                        break;
//                    }
//                }
//                
//                UserAddressViewController *viewController = [[UserAddressViewController alloc] init];
//                viewController.title = @"上门收货地址";
//                viewController.addressList = weakSelf.addressList;
//                [weakSelf.navigationController pushViewController:viewController animated:YES];
//            }
//        } failure:^(XMError *error) {
//            
//        }];
//    }
//}
//
//- (void)updateWithAddressInfo:(AddressInfo*)address {
//    _receiverTextFiled.text = address.receiver;
//    _phoneNumberTextFiled.text = address.phoneNumber;
//    _areaDetailTextFiled.text = address.areaDetail;
//    _zipcodeTextFiled.text = address.zipcode;
//    _addressTextView.text = address.address;
//}
//
//- (void)dealloc {
//    [_request cancel];
//}
//
//- (UIView*)createEditAddressItemView:(NSString*)text frame:(CGRect)frame{
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor whiteColor];
//    
//    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, view.bounds.size.width-40, 44)];
//    nameLbl.text = text;
//    nameLbl.textColor = [UIColor colorWithHexString:@"cccccc"];
//    nameLbl.font = [UIFont systemFontOfSize:14.f];
//    nameLbl.userInteractionEnabled = YES;
//    [view addSubview:nameLbl];
//    
//    UITextField *textFiled = [[UITextField alloc] initWithFrame:CGRectMake(95, 0, view.bounds.size.width-115, nameLbl.bounds.size.height)];
//    textFiled.font = [UIFont systemFontOfSize:14.f];
//    textFiled.text = @"";
//    textFiled.textColor = [UIColor colorWithHexString:@"181818"];
//    textFiled.delegate = self;
//    textFiled.tag = 100;
//    [view addSubview:textFiled];
//    
//    CALayer *bottomLine = [CALayer layer];
//    bottomLine.frame = CGRectMake(20, view.bounds.size.height-1, view.bounds.size.width-40, 1);
//    bottomLine.backgroundColor = [UIColor colorWithHexString:@"eeeeee"].CGColor;
//    [view.layer addSublayer:bottomLine];
//    return view;
//}
//- (UIView*)createEditAddressDetailView:(NSString*)text frame:(CGRect)frame{
//    UIView *view = [[UIView alloc] initWithFrame:frame];
//    view.backgroundColor = [UIColor whiteColor];
//    
//    UILabel *nameLbl = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, _scrollView.bounds.size.width-40, 44)];
//    nameLbl.text = text;
//    nameLbl.textColor = [UIColor colorWithHexString:@"cccccc"];
//    nameLbl.font = [UIFont systemFontOfSize:14.f];
//    nameLbl.userInteractionEnabled = YES;
//    [view addSubview:nameLbl];
//    
//    PlaceHolderTextView *textView = [[PlaceHolderTextView alloc] initWithFrame:CGRectMake(90, 5, view.bounds.size.width-110, view.bounds.size.height-5)];
//    textView.font = [UIFont systemFontOfSize:14.f];
//    textView.text = @"";
//    textView.textColor = [UIColor colorWithHexString:@"181818"];
//    textView.tag = 100;
//    [view addSubview:textView];
//    
//    return view;
//}
//
//- (CGFloat)setupEditAddressView {
//    
//    CGFloat marginTop = 0.f;
//    marginTop += 10.f;
//
//    UIView *view = [self createEditAddressItemView:@"收件人" frame:CGRectMake(0, marginTop, _scrollView.bounds.size.width, 44)];
//    _receiverTextFiled = (UITextField*)[view viewWithTag:100];
//    _receiverTextFiled.text = [Session sharedInstance].currentUser.userName;
//    [_scrollView addSubview:view];
//    marginTop += 44;
//    
//    view = [self createEditAddressItemView:@"电话号码" frame:CGRectMake(0, marginTop, _scrollView.bounds.size.width, 44)];
//    _phoneNumberTextFiled = (UITextField*)[view viewWithTag:100];
//    _phoneNumberTextFiled.text = [Session sharedInstance].currentUser.phoneNumber;
//    [_scrollView addSubview:view];
//    marginTop += 44;
//    
//    view = [self createEditAddressItemView:@"所在地区" frame:CGRectMake(0, marginTop, _scrollView.bounds.size.width, 44)];
//    _areaDetailTextFiled = (UITextField*)[view viewWithTag:100];
//    _areaDetailTextFiled.tag = 200;
//    [_scrollView addSubview:view];
//    marginTop += 44;
//    
//    view = [self createEditAddressItemView:@"邮编" frame:CGRectMake(0, marginTop, _scrollView.bounds.size.width, 44)];
//    _zipcodeTextFiled = (UITextField*)[view viewWithTag:100];
//    [_scrollView addSubview:view];
//    marginTop += 44;
//    
//    view = [self createEditAddressDetailView:@"详细地址" frame:CGRectMake(0, marginTop, _scrollView.bounds.size.width, 68)];
//    _addressTextView = (PlaceHolderTextView*)[view viewWithTag:100];
//    [_scrollView addSubview:view];
//    marginTop += 68;
//    
//    return marginTop;
//}
//
//- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    if (textField.tag == 200) {
//        AreaViewController *viewController = [[AreaViewController alloc] init];
//        viewController.delegate = self;
//        [self.navigationController pushViewController:viewController animated:YES];
//        return NO;
//    }
//    return YES;
//}
//
//- (void)sumbitAddress:(UIButton*)sender
//{
//    if (![Session sharedInstance].isLoggedIn) {
//        LoginViewController *viewController = [[LoginViewController alloc] init];
//        viewController.title = @"登陆";
//        MyNavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
//        [super presentViewController:navController animated:YES completion:^{
//        }];
//        return;
//    }
//    NSString *receiver = [_receiverTextFiled.text trim];
//    NSString *phoneNumber = [_phoneNumberTextFiled.text trim];
//    NSString *zipcode = [_zipcodeTextFiled.text trim];
//    NSString *areaDetail = [_areaDetailTextFiled.text trim];
//    NSString *address = _addressTextView.text;
//    
//    BOOL isValidInput = YES;
//    
//    if ([receiver length] == 0) {
//        _receiverTextFiled.text = @"";
//        _receiverTextFiled.placeholder = @"请输入联系人";
//        [_receiverTextFiled setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//        isValidInput = NO;
//    }
//    if ([phoneNumber length] == 0 || ![phoneNumber isValidMobilePhoneNumber]) {
//        _phoneNumberTextFiled.text = @"";
//        _phoneNumberTextFiled.placeholder = @"请输电话号码";
//        [_phoneNumberTextFiled setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//        isValidInput = NO;
//    }
//    if ([areaDetail length] == 0) {
//        _areaDetailTextFiled.text = @"";
//        _areaDetailTextFiled.placeholder = @"请选择地址";
//        [_areaDetailTextFiled setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//        isValidInput = NO;
//    }
//    if ([zipcode length]>0 && ![zipcode isValidPostalCode]) {
//        _zipcodeTextFiled.text = @"";
//        _zipcodeTextFiled.placeholder = @"请输入正确邮编";
//        [_zipcodeTextFiled setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
//        isValidInput = NO;
//    }
//    if ([address length] == 0) {
//        _addressTextView.text = @"";
//        _addressTextView.placeHolder = @"请输入纤细地址";
//        _addressTextView.placeHolderTextColor = [UIColor redColor];
//        isValidInput = NO;
//    }
//    
//    if (isValidInput) {
//        AddressInfo *addressInfo = [[AddressInfo alloc] init];
//        addressInfo.address = address;
//        addressInfo.areaCode = self.districtID;
//        addressInfo.areaDetail = self.areaName;
//        addressInfo.receiver = receiver;
//        addressInfo.zipcode = zipcode;
//        addressInfo.isDefault = [_addressList count]==0?YES:NO;
//        WEAKSELF;
//        [super showProcessingHUD:nil forView:_scrollView];
//        _request = [[NetworkAPI sharedInstance] requestConsignment:[Session sharedInstance].currentUserId cateIds:self.cateIds addressInfo:addressInfo completion:^(NSInteger totalOrdersNum) {
//            [weakSelf hideHUD];
//            [weakSelf dismiss];
//        } failure:^(XMError *error) {
//            [weakSelf showHUD:error.errorMsg hideAfterDelay:0.8f forView:weakSelf.scrollView];
//        }];
//    }
//}
//
//- (void)areaDidSelected:(AreaViewController*)viewController districtID:(NSString*)districtID areaName:(NSString*)areaName {
//    self.districtID = districtID;
//    self.areaName = areaName;
//    _areaDetailTextFiled.text = areaName;
//}
//
//- (void)handleLoginDidFinishNotification:(NSNotification*)notifi {
//    _receiverTextFiled.text = [Session sharedInstance].currentUser.userName;
//    _phoneNumberTextFiled.text = [Session sharedInstance].currentUser.phoneNumber;
//    
//    [self loadUserAddressList];
//}
//
//@end




