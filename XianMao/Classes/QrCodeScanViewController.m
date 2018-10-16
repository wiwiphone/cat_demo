//
//  ReaderSampleViewController.m
//  XianMao
//
//  Created by darren on 15/2/4.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import "QrCodeScanViewController.h"
#import "ZBarSDK.h"
#import "WCAlertView.h"
#import "URLScheme.h"
#import "AssetPickerController.h"
#import <AVFoundation/AVFoundation.h>
@interface QrCodeScanViewController () <ZBarReaderDelegate,ZBarReaderViewDelegate >

@property (nonatomic, retain) UIView *overlayView;
@property (nonatomic, retain) UIView *scanView;

@end

@implementation QrCodeScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"扫描二维码"];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    [super.topBarRightButton setTitle:@"相册" forState:UIControlStateNormal];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    
    
    ZBarReaderView *reader = [ZBarReaderView new];
    ZBarImageScanner * scanner = [ZBarImageScanner new];
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    reader = [reader initWithImageScanner:scanner];
    reader.readerDelegate = self;
    reader.tracksSymbols = NO;
    reader.frame = CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight);
//    NSLog(@"%@",NSStringFromCGRect(reader.frame));
    reader.torchMode = 0;

    float scanViewWidth = reader.frameWidth - 100;
    float scanViewHeight = scanViewWidth;
    float px = 50;
    float py = topBarHeight + 17;
    
    _scanView = [[UIView alloc] initWithFrame:CGRectMake(px, py,scanViewWidth,scanViewHeight)];
    _scanView.layer.borderColor = [UIColor colorWithHexString:@"ffe8b0"].CGColor;//[UIColor grayColor].CGColor;
    _scanView.layer.borderWidth = 1.0f;
    
    reader.scanCrop = _scanView.frame;

    CGFloat x,y,width,height;
    x = _scanView.frameY / reader.frame.size.height;
    y = 1 - (_scanView.frameX + _scanView.frameWidth) / reader.frame.size.width;
    width = (_scanView.frameHeight + _scanView.frameY)/ reader.frame.size.height;
    height = 1 - _scanView.frameX / reader.frame.size.width;
    
    reader.scanCrop = CGRectMake(x, y, width, height);
    [reader addSubview:_scanView];
    dispatch_async(dispatch_get_main_queue(), ^{[reader start];});
    
    [self.view addSubview:reader];
    
    
    self.overlayView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds),
                                                                CGRectGetHeight(self.view.bounds)-topBarHeight)];
    self.overlayView.alpha = .5f;
    self.overlayView.backgroundColor = [UIColor blackColor];
    self.overlayView.userInteractionEnabled = NO;
    self.overlayView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view insertSubview:self.overlayView aboveSubview:reader];
    
    UILabel *promotLabel = [[UILabel alloc] initWithFrame:CGRectMake(_scanView.frameX - 10, _scanView.frameY + _scanView.frameHeight + 80,
                                                                     _scanView.frameWidth+20,13.f)];
    promotLabel.textAlignment = NSTextAlignmentCenter;
    promotLabel.text = @"将二维码/条形码放入框内，即可自动扫描";
    promotLabel.textColor = [UIColor greenColor ];
    promotLabel.font = [UIFont systemFontOfSize:13.0f];
    
    [self.view addSubview:promotLabel];
    
    [self overlayClipping];
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus != AVAuthorizationStatusAuthorized && authStatus != AVAuthorizationStatusNotDetermined) {
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"请在iPhone的\"设置-隐私-相片\"选项中,允许爱丁猫访问你的相册"
                     customizationBlock:^(WCAlertView *alertView) {
                         
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         
                     } cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    }
}

- (void)overlayClipping
{
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    // Left side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.scanView.frame.origin.x,
                                        self.overlayView.frame.size.height));
    // Right side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(
                                        self.scanView.frame.origin.x + self.scanView.frame.size.width,
                                        0,
                                        self.overlayView.frame.size.width - self.scanView.frame.origin.x - self.scanView.frame.size.width,
                                        self.overlayView.frame.size.height));
    // Top side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0, 0,
                                        self.overlayView.frame.size.width,
                                        self.scanView.frame.origin.y));
    // Bottom side of the ratio view
    CGPathAddRect(path, nil, CGRectMake(0,
                                        self.scanView.frame.origin.y + self.scanView.frame.size.height,
                                        self.overlayView.frame.size.width,
                                        self.overlayView.frame.size.height - self.scanView.frame.origin.y + self.scanView.frame.size.height));
    
    maskLayer.path = path;
    self.overlayView.layer.mask = maskLayer;
    
    CGPathRelease(path);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) readerView: (ZBarReaderView*) readerView
     didReadSymbols: (ZBarSymbolSet*) symbols
          fromImage: (UIImage*) image
{
    for(ZBarSymbol *sym in symbols) {
        
        [self processScanResults:sym];
        
    }
    
}

// 选取相册
-(void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    ALAuthorizationStatus photoAuthorStatus = [ALAssetsLibrary authorizationStatus];
    if (photoAuthorStatus == ALAuthorizationStatusAuthorized || photoAuthorStatus == ALAuthorizationStatusNotDetermined) {
        ZBarReaderController *reader = [ZBarReaderController new];
        reader.showsHelpOnFail = NO;
        reader.readerDelegate = self;
        reader.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [reader.scanner setSymbology: ZBAR_I25 config: ZBAR_CFG_ENABLE to: 0];
        
        [self.navigationController presentViewController:reader animated:YES completion:nil];
    } else {
        [WCAlertView showAlertWithTitle:@"提示"
                                message:@"请在iPhone的\"设置-隐私-相片\"选项中,允许爱丁猫访问你的相册"
                     customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil,nil];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    if ( results ) {
        ZBarSymbol *symbol = nil;
        for (symbol in results) break;

        [picker dismissViewControllerAnimated:YES completion:^{
                [self processScanResults:symbol];
        }];
    } else {
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage] ? [info objectForKey:UIImagePickerControllerEditedImage] : [info objectForKey:UIImagePickerControllerOriginalImage];
        [self scanImage:image];
    }
}

- (void)scanImage:(UIImage*)image {
    ZBarImage *zImage = [[ZBarImage alloc] initWithCGImage:image.CGImage];
    ZBarImageScanner *scanner = [[ZBarImageScanner alloc] init];
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    [scanner scanImage:zImage];
    ZBarSymbolSet *set = [scanner results];
    
    for (ZBarSymbol *symbol in set) {
        [self processScanResults:symbol];
    }
}

- (void)processScanResults:(ZBarSymbol *)symbol
{
    WEAKSELF;
    NSRange range = [symbol.data rangeOfString:kURLSchemeAidingmao];
    NSRange httpRange = [symbol.data rangeOfString:kURLSchemeHttpURL];
    if (range.length>0 || httpRange.length > 0) {
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(processScanResults:url:)]) {
            [weakSelf.delegate processScanResults:weakSelf url:symbol.data];
        } else {
            [URLScheme locateWithRedirectUri:symbol.data andIsShare:NO];
        }
    } else {
        [WCAlertView showAlertWithTitle:@"扫描结果"
                                message:symbol.data
                     customizationBlock:^(WCAlertView *alertView) {
                         [WCAlertView setDefaultStyle:WCAlertViewStyleDefault];
                     } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                         if (buttonIndex == 1) {
                             if ([symbol.data rangeOfString:@"http"].length>0 || [symbol.data rangeOfString:@"www."].length>0) {
                                 if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(processScanResults:data:)]) {
                                     [weakSelf.delegate processScanResults:weakSelf url:symbol.data];
                                 }
                             }
                             else if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(processScanResults:data:)]) {
                                 [weakSelf.delegate processScanResults:weakSelf data:symbol.data];
                             }
                         }
                     } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }

}

- (void)readerControllerDidFailToRead:(ZBarReaderController *)reader withRetry:(BOOL)retry
{
    [reader dismissViewControllerAnimated:YES completion:^{
        
        [WCAlertView showAlertWithTitle:@"扫描结果" message:@"图片中未发现二维码" customizationBlock:^(WCAlertView *alertView) {
            [WCAlertView setDefaultStyle:WCAlertViewStyleDefault];
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            
        } cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
    }];

}

- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return(YES);
}

@end
