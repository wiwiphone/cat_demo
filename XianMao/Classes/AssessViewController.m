//
//  AssessViewController.m
//  XianMao
//
//  Created by WJH on 17/1/20.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "AssessViewController.h"
#import "AssessPhotographView.h"
#import "UIActionSheet+Blocks.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Resize.h"
#import "AssessLoadingView.h"
#import "LoginViewController.h"
#import "AssessResultView.h"
#import "CategoryService.h"
#import "EvaluationVo.h"
#import "WebViewController.h"


@interface AssessViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, strong) UIImageView * backgroundImage;
@property (nonatomic, strong) AssessPhotographView * photographView;
@property (nonatomic, strong) AssessLoadingView * loadingView;
@property (nonatomic, strong) AssessResultView * resultView;
@property (nonatomic,strong) HTTPRequest * request;

@end

@implementation AssessViewController

-(AssessPhotographView *)photographView{
    if (!_photographView) {
        _photographView = [[AssessPhotographView alloc] init];
    }
    return _photographView;
}

- (AssessLoadingView *)loadingView{
    if (!_loadingView) {
        _loadingView = [[AssessLoadingView alloc] init];
    }
    return _loadingView;
}

-(AssessResultView *)resultView{
    if (!_resultView) {
        _resultView = [[AssessResultView alloc] init];
    }
    return _resultView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarTitle:@"估价"];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton:[UIImage imageNamed:@"Share_New_MF_T"] imgPressed:[UIImage imageNamed:@"Share_New_MF_T"]];
    
    [self.view addSubview:self.photographView];
    [self.view addSubview:self.loadingView];
    
    self.photographView.hidden = NO;
    self.loadingView.hidden  = YES;

    WEAKSELF;
    self.resultView.handAssessAgainBlcok =^(){
        weakSelf.photographView.hidden = NO;
        weakSelf.loadingView.hidden  = YES;
        weakSelf.resultView.hidden = YES;
        [weakSelf.resultView removeFromSuperview];
    };

    self.resultView.handSaleActionBlock = ^(){
        WebViewController *viewController = [[WebViewController alloc] init];
        viewController.url = SENDPUBLISH;
        [weakSelf pushViewController:viewController animated:YES];
    };
    
    
    self.photographView.handlePhotographBtnBlock = ^(){
        [UIActionSheet showInView:weakSelf.view withTitle:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"相机拍照",@"相册选择"] tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
            switch (buttonIndex) {
                case 0:{
                    [weakSelf photoFromCamera];
                    break;
                }
                case 1:{
                    [weakSelf photoFromAlbum];
                    break;
                }
                default:
                    break;
            }
        }];
    };

    [self layoutViews];
    
}


- (void)photoFromCamera{
    
    WEAKSELF
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        //拍照
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                NSUInteger sourceType = UIImagePickerControllerSourceTypeCamera;
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = weakSelf;
                imagePicker.allowsEditing = NO;
                imagePicker.sourceType = sourceType;
                imagePicker.videoQuality = UIImagePickerControllerQualityTypeHigh;
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                imagePicker.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
                imagePicker.showsCameraControls = YES;
                [weakSelf presentViewController:imagePicker animated:YES completion:^{
                }];
            }];
        }
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
                                                             message:@"请在iPhone的\"设置-隐私-相机\"选项中,允许爱丁猫访问你的相机"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}



- (void)photoFromAlbum{
    
    WEAKSELF
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            UIImagePickerController *imagePicker =  [UIImagePickerController new];
            imagePicker.delegate = weakSelf;
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            
            imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
            imagePicker.allowsEditing = NO;//显示正方形的框 设置YES
            
            [weakSelf presentViewController:imagePicker animated:YES completion:^{
            }];
        }];
        
    } else {
        UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
                                                             message:@"请在iPhone的\"设置-隐私-相片\"选项中,允许爱丁猫访问你的相册"
                                                            delegate:self
                                                   cancelButtonTitle:nil
                                                   otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    WEAKSELF;
    UIImage *image= info[UIImagePickerControllerEditedImage] ? info[UIImagePickerControllerEditedImage]:info[UIImagePickerControllerOriginalImage];
    if (image) {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            
            UIImage *newImage = [image resizedImage:CGSizeMake(400, 400) interpolationQuality:kCGInterpolationHigh];
            [AppDirs cleanupAssessImageDir];
            NSString *filePath = [AppDirs saveImage:newImage  dir:[AppDirs assessImageDir] fileName:@"assess.jpg" fileExtention:@""];;

            NSArray * uploadsfile = @[filePath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.photographView.hidden = YES;
                weakSelf.loadingView.hidden  = NO;
                weakSelf.resultView.hidden = YES;
            });
            
            weakSelf.request = [[NetworkAPI sharedInstance] getEvaluationPrice:uploadsfile category:0 completion:^(NSDictionary *data) {

                EvaluationVo * evaluation = [[EvaluationVo alloc] initWithJSONDictionary:data];
                [self.view addSubview:self.resultView];
                weakSelf.resultView.frame = CGRectMake(0, 65, kScreenWidth, kScreenHeight-65);
                weakSelf.resultView.isNotFound = evaluation.evaluation_price > 0 ? NO:YES;
                weakSelf.photographView.hidden = YES;
                weakSelf.loadingView.hidden  = YES;
                weakSelf.resultView.hidden = NO;

                [weakSelf.resultView getAssessResultInfo:evaluation image:newImage];
                
                [NetworkManager sharedInstance].dynamicServerUrl = APIBaseURLString;
            } failure:^(XMError *error) {
                [NetworkManager sharedInstance].dynamicServerUrl = APIBaseURLString;
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2 forView:[UIApplication sharedApplication].keyWindow];
            }];
        });
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)layoutViews {
    
    [self.photographView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(65);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(65);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
//    [self.resultView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view.mas_top).offset(65);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
}



@end
