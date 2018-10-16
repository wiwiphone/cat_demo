//
//  PublishTakePhotoViewController.m
//  XianMao
//
//  Created by simon cai on 5/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "SCRecorder.h"
#import "Command.h"

#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

#import "AppDirs.h"
#import "CategoryService.h"

#import "Error.h"

@interface TakePhotoAssistView : UIView
@property(nonatomic,weak) XMWebImageView *imageView;
@property(nonatomic,weak) UILabel *indicatorLbl;
@property(nonatomic,weak) UILabel *textLbl;
@property(nonatomic,assign) NSInteger totoalNum;
@end

@implementation TakePhotoAssistView

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 55+20)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        XMWebImageView *imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(self.width-self.height+10, 10, self.height-20, self.height-20)];
        imageView.backgroundColor = [UIColor colorWithHexString:@"333333"];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 3.f;
        [self addSubview:imageView];
        _imageView = imageView;
        
        UILabel *indicatorLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        indicatorLbl.font = [UIFont systemFontOfSize:12.f];
        indicatorLbl.textColor = [UIColor whiteColor];
        [self addSubview:indicatorLbl];
        _indicatorLbl = indicatorLbl;
        
        UILabel *textLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        textLbl.font = [UIFont systemFontOfSize:13.f];
        textLbl.textColor = [UIColor whiteColor];
        textLbl.text = @"";
        textLbl.numberOfLines = 0;
        [self addSubview:textLbl];
        _textLbl = textLbl;
        
        _totoalNum = 9;
        
        [self updateWithCateSampleVo:nil currentIndex:0];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = CGRectMake(self.width-self.height+10, 10, self.height-20, self.height-20);
    
    [_indicatorLbl sizeToFit];
    _indicatorLbl.frame = CGRectMake(10, 10+4, _indicatorLbl.width, _indicatorLbl.height);
    
    _textLbl.frame = CGRectMake(10, 10, _imageView.left-10-10, 0);
    [_textLbl sizeToFit];
    _textLbl.frame = CGRectMake(10, _imageView.bottom-_textLbl.height-4, _imageView.left-10-10, _textLbl.height);
}

- (void)updateWithCateSampleVo:(CateSampleVo*)sampleVo currentIndex:(NSInteger)currentIndex {
    
   
    
    if (sampleVo) {
        _indicatorLbl.hidden = NO;
        _imageView.hidden = NO;
        
        NSString *strCurrentIndex = [NSString stringWithFormat:@"%ld",(long)currentIndex+1];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %ld",strCurrentIndex,(long)_totoalNum]];
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"c2a79d"] range:NSMakeRange(0, strCurrentIndex.length)];
        [attrString addAttribute:NSFontAttributeName
                           value:[UIFont systemFontOfSize:13.f]
                           range:NSMakeRange(0, 1)];
        _indicatorLbl.attributedText = attrString;
        _textLbl.text = sampleVo.explain;
        
        [_imageView setImageWithURL:sampleVo.picUrl placeholderImage:nil size:CGSizeMake(_imageView.width*2, _imageView.height*2) progressBlock:nil succeedBlock:nil failedBlock:nil];
    } else {
        _indicatorLbl.hidden = YES;
        _imageView.hidden = YES;
        _textLbl.text = @"更多细节";
    }
    
    [self setNeedsLayout];
}
@end


@interface TakePhotoUIImagePickerController : UIImagePickerController
@property(nonatomic,assign) NSInteger userData;
@end
@implementation TakePhotoUIImagePickerController
@end


#import <MobileCoreServices/UTCoreTypes.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import "UIImage+Resize.h"
#import "WCAlertView.h"

@interface TakePhotoViewController () <SCRecorderDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,PreviewControllerDelegate>
@property(nonatomic,weak) UIView *previewView;
@property(nonatomic,weak) TakePhotoAssistView *assistView;
@property(nonatomic,weak) CommandButton *takePhotoBtn;
@property(nonatomic,weak) CommandButton *gallerBtn;
@property(nonatomic,weak) CommandButton *finishBtn;
@end

@implementation TakePhotoViewController {
    SCRecorder *_recorder;
}

- (void)dealloc {
    _recorder.previewView = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"181818"];
    
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    self.topBar.image = nil;
    self.topBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    self.topBar.frame = CGRectMake(0, 0, self.view.width, 65);
    topBarHeight = 65;
    
    
    [super setupTopBarTitle:[self.title length]>0?self.title:@""];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton:[UIImage imageNamed:@"shot_flash_on"] imgPressed:nil];
    self.topBarTitleLbl.textColor = [UIColor whiteColor];
    self.topBarTitleLbl.frame = CGRectMake(55, 0, self.topBar.bounds.size.width-110, self.topBar.bounds.size.height);
    self.topBarBackButton.frame = CGRectMake(self.topBarBackButton.left, (self.topBar.height-self.topBarBackButton.height)/2, self.topBarBackButton.width, self.topBarBackButton.height);
    self.topBarRightButton.frame = CGRectMake(self.topBarRightButton.left, (self.topBar.height-self.topBarRightButton.height)/2, self.topBarRightButton.width, self.topBarRightButton.height);
//    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    
    
    TakePhotoAssistView *assistView = [[TakePhotoAssistView alloc] init];
    
    UIView *previewView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.width+self.topBar.height)];
    previewView.backgroundColor = [UIColor colorWithHexString:@"282828"];
    [self.view addSubview:previewView];
    _previewView = previewView;
    
    if (IS_IPHONE_4_OR_LESS) {
        previewView.frame = CGRectMake(0, 0, self.view.width, self.view.width+self.topBar.height);
    } else {
        previewView.frame = CGRectMake(0, 0, self.view.width, self.view.width+self.topBar.height+assistView.height);
    }
    
    assistView.frame = CGRectMake(0, previewView.bottom-assistView.height, assistView.width, assistView.height);
    [self.view addSubview:assistView];
    assistView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
    _assistView = assistView;
    
    CommandButton *takePhotoBtn = [[CommandButton alloc] initWithFrame:CGRectMake((self.view.width-66)/2, self.view.height-25-66, 66, 66)];
    takePhotoBtn.backgroundColor = [UIColor clearColor];
    [takePhotoBtn setImage:[UIImage imageNamed:@"shot_btn"] forState:UIControlStateNormal];
    [takePhotoBtn setImage:[UIImage imageNamed:@"shot_btn_press"] forState:UIControlStateNormal];
    [self.view addSubview:takePhotoBtn];
    _takePhotoBtn = takePhotoBtn;
    
    CommandButton *gallerBtn = [[CommandButton alloc] initWithFrame:CGRectMake(10, takePhotoBtn.top, takePhotoBtn.height, takePhotoBtn.height)];
    gallerBtn.backgroundColor = [UIColor clearColor];
    [gallerBtn setTitle:@"相册" forState:UIControlStateNormal];
    [gallerBtn setTitleColor:[UIColor colorWithHexString:@"FFE8B0"] forState:UIControlStateNormal];
    gallerBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:gallerBtn];
    _gallerBtn = gallerBtn;
    
    CommandButton *finishBtn = [[CommandButton alloc] initWithFrame:CGRectMake(self.view.width-10-takePhotoBtn.height, takePhotoBtn.top, takePhotoBtn.height, takePhotoBtn.height)];
    finishBtn.backgroundColor = [UIColor clearColor];
    [finishBtn setTitle:@"完成" forState:UIControlStateNormal];
    [finishBtn setTitleColor:[UIColor colorWithHexString:@"FFE8B0"] forState:UIControlStateNormal];
    finishBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    [self.view addSubview:finishBtn];
//    finishBtn.hidden = YES;
    _finishBtn = finishBtn;
    
    [self.view bringSubviewToFront:self.topBar];

    assistView.totoalNum = 9;
    if ([self.sampleList count]>0) {
        assistView.totoalNum = [self.sampleList count];
        if (self.userData>=0&&self.userData<[self.sampleList count]) {
            [assistView updateWithCateSampleVo:[self.sampleList objectAtIndex:self.userData] currentIndex:self.userData];
        } else {
            [assistView updateWithCateSampleVo:nil currentIndex:self.userData];
        }
    } else {
        if (self.cateId>0) {
            WEAKSELF;
            [weakSelf showProcessingHUD:nil];
            [CategoryService getCateSample:self.cateId completion:^(NSArray *sampleList) {
                [weakSelf hideHUD];
                weakSelf.sampleList = sampleList;
                weakSelf.assistView.totoalNum = [weakSelf.sampleList count];
                if (weakSelf.userData>=0&&weakSelf.userData<[weakSelf.sampleList count]) {
                    [weakSelf.assistView updateWithCateSampleVo:[weakSelf.sampleList objectAtIndex:weakSelf.userData] currentIndex:weakSelf.userData];
                }
                if (weakSelf.handleSampleListFetchedBlock) {
                    weakSelf.handleSampleListFetchedBlock(weakSelf.cateId, sampleList);
                }
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                [weakSelf.assistView updateWithCateSampleVo:nil currentIndex:self.userData];
            }];
        }
    }
    
    takePhotoBtn.frame = CGRectMake((self.view.width-66)/2, assistView.bottom+(self.view.height-assistView.bottom-66)/2, 66, 66);
    gallerBtn.frame = CGRectMake(10, takePhotoBtn.top, takePhotoBtn.height, takePhotoBtn.height);
    finishBtn.frame = CGRectMake(self.view.width-10-takePhotoBtn.height, takePhotoBtn.top, takePhotoBtn.height, takePhotoBtn.height);
    
    _recorder = [SCRecorder recorder];
//    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.captureSessionPreset = AVCaptureSessionPresetPhoto;
    _recorder.audioConfiguration.enabled = NO;
    _recorder.videoConfiguration.enabled = YES;
    _recorder.photoConfiguration.enabled = YES;
    _recorder.flashMode = SCFlashModeOff;
    _recorder.maxRecordDuration = CMTimeMake(10, 1);
    _recorder.fastRecordMethodEnabled = NO;
    
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = NO;
    
    _recorder.previewView = previewView;

    _recorder.initializeSessionLazily = NO;
    
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
    
    self.topBarRightButton.selected = NO;
    if (self.topBarRightButton.isSelected) {
        [self.topBarRightButton setImage:[UIImage imageNamed:@"shot_flash_on"] forState:UIControlStateNormal];
    } else {
        [self.topBarRightButton setImage:[UIImage imageNamed:@"shot_flash_off"] forState:UIControlStateNormal];
    }
    
    self.hidesStatusBarWhenPresented = YES;
    
    WEAKSELF;
    _takePhotoBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf capturePhoto:nil];
    };
    _gallerBtn.hidden = YES;
    _gallerBtn.handleClickBlock = ^(CommandButton *sender) {
        ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
        if (status == ALAuthorizationStatusAuthorized || status == ALAuthorizationStatusNotDetermined) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                UIImagePickerController *imagePicker =  [UIImagePickerController new];
                imagePicker.delegate = weakSelf;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                
                imagePicker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
                imagePicker.allowsEditing = NO;
                
                [weakSelf presentViewController:imagePicker animated:YES completion:^{
                }];
            }];
            
        } else {
            UIAlertView *alertView = [[UIAlertView alloc ] initWithTitle:@""
                                                                 message:@"请在iPhone的\"设置-隐私-相片\"选项中,允许爱丁猫访问你的相册"
                                                                delegate:weakSelf
                                                       cancelButtonTitle:nil
                                                       otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    };
    
    _finishBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf dismiss];
    };
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusAuthorized || authStatus == AVAuthorizationStatusNotDetermined) {
        
    } else {
        [WCAlertView showAlertWithTitle:@""
                                message:@"请在iPhone的\"设置-隐私-相机\"选项中,允许爱丁猫访问你的相机"
                     customizationBlock:^(WCAlertView *alertView) {
                         alertView.style = WCAlertViewStyleWhite;
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         //[weakSelf dismiss];
                     } cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    }
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    self.topBarRightButton.selected = !self.topBarRightButton.isSelected;
    if (self.topBarRightButton.isSelected) {
        [self.topBarRightButton setImage:[UIImage imageNamed:@"shot_flash_on"] forState:UIControlStateNormal];
        _recorder.flashMode = SCFlashModeOn;
    } else {
        [self.topBarRightButton setImage:[UIImage imageNamed:@"shot_flash_off"] forState:UIControlStateNormal];
        _recorder.flashMode = SCFlashModeOff;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self prepareSession];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    [_recorder previewViewFrameChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [_recorder startRunning];
    _takePhotoBtn.enabled = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    _takePhotoBtn.enabled = NO;
    [_recorder stopRunning];
}

- (void)prepareSession {
    if (_recorder.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeQuickTimeMovie;
        
        _recorder.session = session;
    }
    
//    [self updateTimeRecordedLabel];
//    [self updateGhostImage];
}

- (void)capturePhoto:(id)sender {
    WEAKSELF;
    _takePhotoBtn.enabled = NO;
    [_recorder capturePhoto:^(NSError *error, UIImage *image) {
        if (image != nil) {
            [self showPhoto:image];
        } else {
            [self showAlertViewWithTitle:@"拍照失败" message:error.localizedDescription];
        }
        weakSelf.takePhotoBtn.enabled = YES;
    }];
}

- (void)switchFlash:(id)sender {
    NSString *flashModeString = nil;
    if ([_recorder.captureSessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) {
        switch (_recorder.flashMode) {
            case SCFlashModeAuto:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeOn;
                break;
            case SCFlashModeOn:
                flashModeString = @"Flash : Light";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Auto";
                _recorder.flashMode = SCFlashModeAuto;
                break;
            default:
                break;
        }
    } else {
        switch (_recorder.flashMode) {
            case SCFlashModeOff:
                flashModeString = @"Flash : On";
                _recorder.flashMode = SCFlashModeLight;
                break;
            case SCFlashModeLight:
                flashModeString = @"Flash : Off";
                _recorder.flashMode = SCFlashModeOff;
                break;
            default:
                break;
        }
    }
    
    //[self.flashModeButton setTitle:flashModeString forState:UIControlStateNormal];
}


- (void)showAlertViewWithTitle:(NSString*)title message:(NSString*) message {
    UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)showPhoto:(UIImage *)photo {
    PhotoPreviewController *viewController = [[PhotoPreviewController alloc] init];
    viewController.photo = photo;
    viewController.title = self.title;
    viewController.delegate = self;
    viewController.userData = self.userData;
    viewController.sampleList = self.sampleList;
    [self pushViewController:viewController animated:YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:NO completion:nil];
    UIImage *photo= info[UIImagePickerControllerEditedImage] ? info[UIImagePickerControllerEditedImage]:info[UIImagePickerControllerOriginalImage];
    if (photo) {
        WEAKSELF;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            PhotoPreviewController *viewController = [[PhotoPreviewController alloc] init];
            viewController.photo = photo;
            viewController.title = weakSelf.title;
            viewController.delegate = weakSelf;
            viewController.userData = weakSelf.userData;
            viewController.sampleList = weakSelf.sampleList;
            [weakSelf pushViewController:viewController animated:YES];
        });
//        dispatch_async(dispatch_get_main_queue(), ^{
//            PhotoPreviewController *viewController = [[PhotoPreviewController alloc] init];
//            viewController.photo = photo;
//            viewController.title = weakSelf.title;
//            viewController.delegate = weakSelf;
//            viewController.userData = weakSelf.userData;
//            viewController.sampleList = weakSelf.sampleList;
//            [weakSelf pushViewController:viewController animated:YES];
//        });
    }
}

- (void)previewUseThePhoto:(PhotoPreviewController*)viewController photo:(UIImage*)photo
{
    [photo rotatedByDegrees:90.f];
    UIImage *image = photo;
    UIImage *originalImage = photo;
    CGSize originalSize = originalImage.size;
    if (originalSize.width == kADMPublishGoodsImageSize && originalSize.height== kADMPublishGoodsImageSize) {
        //... originalImage
    } else {
        if (originalSize.width == originalSize.height) {
            if (originalSize.width>kADMPublishGoodsImageSize) {
                CGSize size = CGSizeMake(kADMPublishGoodsImageSize, kADMPublishGoodsImageSize);
                UIImage *scaledImage = [originalImage resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationDefault];
                image = scaledImage;
            } else {
                //... originalImage
            }
        } else {
            if (originalSize.width < kADMPublishGoodsImageSize && originalSize.height<kADMPublishGoodsImageSize) {
                //... originalImage
            } else {
                
                CGSize size = CGSizeMake(kADMPublishGoodsImageSize, kADMPublishGoodsImageSize);
                UIImage *scaledImage = [image resizedImageWithContentMode:UIViewContentModeScaleAspectFill bounds:size interpolationQuality:kCGInterpolationDefault];
                
                CGRect cropFrame = CGRectZero;
                CGSize scaledSize = scaledImage.size;
                if (scaledSize.width>scaledSize.height) {
                    cropFrame = CGRectMake((scaledSize.width-scaledSize.height)/2,0,scaledSize.height,scaledSize.height);
                } else {
                    cropFrame = CGRectMake(0,(scaledSize.height-scaledSize.width)/2,scaledSize.width,scaledSize.width);
                }
                
                UIImage *croppedImage = [scaledImage croppedImage:cropFrame];
                image = croppedImage;
            }
        }
    }
    
    WEAKSELF;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *filePath = [AppDirs savePublishGoodsPicture:image fileName:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf && weakSelf.handleImagePicked) {
                weakSelf.handleImagePicked(weakSelf.userData, image, filePath);
                weakSelf.userData +=1;
                
                if (weakSelf.userData>=0&&weakSelf.userData<[weakSelf.sampleList count]) {
                    [weakSelf.assistView updateWithCateSampleVo:[weakSelf.sampleList objectAtIndex:weakSelf.userData] currentIndex:weakSelf.userData];
//                    weakSelf.finishBtn.hidden = YES;
                } else {
                     [weakSelf.assistView updateWithCateSampleVo:nil currentIndex:weakSelf.userData];
                    weakSelf.finishBtn.hidden = NO;
                }
            }
        });
    });
}

@end

@interface PhotoPreviewController ()
@property(nonatomic,strong) TapDetectingImageView *previewView;
@property(nonatomic,weak) TakePhotoAssistView *assistView;
@end

@implementation PhotoPreviewController

- (id)init {
    self = [super init];
    if (self) {
        self.userData = 0;
        self.sampleList = nil;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"181818"];
    
    // Do any additional setup after loading the view.
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    self.topBar.image = nil;
    self.topBar.backgroundColor = [UIColor colorWithHexString:@"282828"];
    self.topBar.frame = CGRectMake(0, 0, self.view.width, 65);
    topBarHeight = 65;
    
    [super setupTopBarTitle:[self.title length]>0?self.title:@""];
    [super setupTopBarBackButton];
    self.topBarTitleLbl.textColor = [UIColor whiteColor];
    self.topBarTitleLbl.frame = CGRectMake(55, 0, self.topBar.bounds.size.width-110, self.topBar.bounds.size.height);
    self.topBarBackButton.frame = CGRectMake(self.topBarBackButton.left, (self.topBar.height-self.topBarBackButton.height)/2, self.topBarBackButton.width, self.topBarBackButton.height);
    
    CGFloat marginTop = topBarHeight;
    
    TapDetectingImageView *previewView = [[TapDetectingImageView alloc] initWithFrame:CGRectMake(0, marginTop, self.view.width, self.view.width)];
    previewView.backgroundColor = [UIColor colorWithHexString:@"282828"];
    [self.view addSubview:previewView];
    _previewView = previewView;
    
    _previewView.clipsToBounds = YES;
    _previewView.contentMode = UIViewContentModeScaleAspectFill;
    _previewView.image = self.photo;
    
    
    TakePhotoAssistView *assistView = [[TakePhotoAssistView alloc] init];
    assistView.frame = CGRectMake(0, previewView.bottom, assistView.width, assistView.height);
    [self.view addSubview:assistView];
    assistView.backgroundColor = [UIColor colorWithHexString:@"282828"];
    _assistView = assistView;
    
    if (self.userData>=0&&self.userData<[self.sampleList count]) {
        assistView.totoalNum = [self.sampleList count];
        [assistView updateWithCateSampleVo:[self.sampleList objectAtIndex:self.userData] currentIndex:self.userData];
    } else {
        [assistView updateWithCateSampleVo:nil currentIndex:self.userData];
    }
    
    
    if (IS_IPHONE_4_OR_LESS) {
        assistView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6f];
        assistView.frame = CGRectMake(0, previewView.bottom-assistView.height, assistView.width, assistView.height);
    }
    
    VerticalCommandButton *reshotBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectMake(55, _assistView.bottom+(self.view.height-_assistView.bottom-66)/2, 66, 66)];
    reshotBtn.backgroundColor = [UIColor clearColor];
    [reshotBtn setImage:[UIImage imageNamed:@"shot_retake"] forState:UIControlStateNormal];
    [reshotBtn setTitle:@"重拍" forState:UIControlStateNormal];
    [reshotBtn setTitleColor:[UIColor colorWithHexString:@"FFE8B0"] forState:UIControlStateNormal];
    reshotBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    reshotBtn.contentAlignmentCenter = YES;
    reshotBtn.imageTextSepHeight = 6.f;
    [self.view addSubview:reshotBtn];
    
    VerticalCommandButton *okBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectMake(self.view.width-55-66, _assistView.bottom+(self.view.height-_assistView.bottom-66)/2, 66, 66)];
    okBtn.backgroundColor = [UIColor clearColor];
    [okBtn setImage:[UIImage imageNamed:@"shot_use"] forState:UIControlStateNormal];
    [okBtn setTitle:@"使用" forState:UIControlStateNormal];
    [okBtn setTitleColor:[UIColor colorWithHexString:@"FFE8B0"] forState:UIControlStateNormal];
    okBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
    okBtn.contentAlignmentCenter = YES;
    okBtn.imageTextSepHeight = 6.f;
    [self.view addSubview:okBtn];
    
    self.hidesStatusBarWhenPresented = YES;
    
    WEAKSELF;
    reshotBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf dismiss];
    };
    okBtn.handleClickBlock = ^(CommandButton *sender) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(previewUseThePhoto:photo:)]) {
            [weakSelf.delegate previewUseThePhoto:weakSelf photo:weakSelf.photo];
        }
        [weakSelf dismiss];
    };
    
    previewView.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer) {
//        NSMutableArray *photos = [[NSMutableArray alloc] init];;
//        MJPhoto *photo = [[MJPhoto alloc] init];
//        photo.image = weakSelf.photo;
//        photo.srcImageView = weakSelf.previewView;
//        [photos addObject:photo];
//        
//        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
//        browser.photos = photos; // 设置所有的图片
//        browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
//        [browser show];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end



