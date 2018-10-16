//
//  MyQRCodeViewController.m
//  XianMao
//
//  Created by WJH on 16/12/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "MyQRCodeViewController.h"
#import "LBXScanWrapper.h"
#import "UIImageView+CornerRadius.h"
#import "WCAlertView.h"
#import "Session.h"
#import "NSString+AES.h"
#import "NSString+URLEncoding.h"

#define LOGOSIZE CGSizeMake(30, 30)
//#define KEY_VALUE @"AbcdEfgHijkLmnOp"


#if DEBUG
#define QRCODESTRING [NSString stringWithFormat:@"http://m.aidingmao.com/store/paycode?user_id=%lu&title=%@",(unsigned long)[Session sharedInstance].currentUserId,[[Session sharedInstance].currentUser.userName URLEncodedString]]
#else
#define QRCODESTRING [NSString stringWithFormat:@"http://m.aidingmao.com/store/paycode?user_id=%lu&title=%@",(unsigned long)[Session sharedInstance].currentUserId,[[Session sharedInstance].currentUser.userName URLEncodedString]]

#endif


@interface MyQRCodeViewController ()
@property (nonatomic ,strong) UIImageView * QRCodeImageView;
@property (nonatomic, strong) UIImageView * bgImageView;
@property (nonatomic, strong) UIButton * downLoadBtn;
@property (nonatomic, strong) UIImageView * containerView;
@property (nonatomic ,copy) NSString * codeStr;


@end


@implementation MyQRCodeViewController

- (UIImageView *)bgImageView{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] init];
        _bgImageView.image = [UIImage imageNamed:@"qrBgImg"];
        _bgImageView.userInteractionEnabled = YES;
    }
    return _bgImageView;
}

-(UIImageView *)containerView{
    if (!_containerView) {
        _containerView = [[UIImageView alloc] init];
        _containerView.image = [UIImage imageNamed:@"container_img"];
    }
    return _containerView;
}


-(UIImageView *)QRCodeImageView{
    if (!_QRCodeImageView) {
        _QRCodeImageView = [[UIImageView alloc] init];
    }
    return _QRCodeImageView;
}

-(UIButton *)downLoadBtn{
    if (!_downLoadBtn) {
        _downLoadBtn = [[UIButton alloc] init];
        [_downLoadBtn setTitle:@"下载二维码" forState:UIControlStateNormal];
        [_downLoadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _downLoadBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_downLoadBtn setBackgroundColor:[UIColor colorWithHexString:@"f4433e"]];
        _downLoadBtn.layer.cornerRadius = 15;
        _downLoadBtn.layer.masksToBounds = YES;
    }
    return _downLoadBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    
    [super setupTopBarTitle:@"收款二维码"];
    [super setupTopBarBackButton];
    self.view.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    
    [self.view addSubview:self.bgImageView];
    
    [self.bgImageView addSubview:self.downLoadBtn];
    [self.bgImageView addSubview:self.containerView];
    [self.containerView addSubview:self.QRCodeImageView];
    
    self.QRCodeImageView.size = CGSizeMake(kScreenWidth/375*177, kScreenWidth/375*177);
    [self createMyQRCode];
    
    [self.downLoadBtn addTarget:self action:@selector(downLoadBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self layoutViews];
    

    NSMutableString *outputStr = [NSMutableString stringWithString:[[[NSString stringWithFormat:@"%lu",(unsigned long)[Session sharedInstance].currentUserId] AES128EncryptWithKey:KEY_VALUE] URLEncodedString]];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@"%20"
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0,
                                                      [outputStr length])];
    NSLog(@"outputStr === %@",outputStr);
    
    
    
    
    
}


- (void)downLoadBtnClick:(UIButton *)button{
    
    
    if ([LBXScanWrapper isGetPhotoPermission]){
        UIImage * image = [LBXScanWrapper addImageLogo:self.QRCodeImageView.image centerLogoImage:[UIImage imageNamed:@"qrIcon"] logoSize:LOGOSIZE];
        [self saveImageToPhotos:image];
    }else{
        
        [WCAlertView showAlertWithTitle:nil message:@"请到设置->隐私中开启本程序相册权限" customizationBlock:^(WCAlertView *alertView) {
            alertView.style = WCAlertViewStyleWhite;
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex == 0) {
                
            }else{
                NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                [[UIApplication sharedApplication] openURL:url];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }


}

- (void)saveImageToPhotos:(UIImage*)savedImage{
    UIImageWriteToSavedPhotosAlbum(savedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        [self showHUD:@"下载成功" hideAfterDelay:0.8];
    }else{
        [self showHUD:@"下载失败" hideAfterDelay:0.8];
    }
}


- (void)createMyQRCode{
    _QRCodeImageView.image = [LBXScanWrapper createQRWithString:QRCODESTRING size:self.QRCodeImageView.frame.size];
    
    CGSize logoSize=LOGOSIZE;
    UIImageView* imageView = [self roundCornerWithImage:[UIImage imageNamed:@"qrIcon"] size:logoSize];
    [LBXScanWrapper addImageViewLogo:_QRCodeImageView centerLogoImageView:imageView logoSize:logoSize];
}

- (UIImageView*)roundCornerWithImage:(UIImage*)logoImg size:(CGSize)size
{
    //logo圆角
    UIImageView *backImage = [[UIImageView alloc] initWithCornerRadiusAdvance:6.0f rectCornerType:UIRectCornerAllCorners];
    backImage.frame = CGRectMake(0, 0, size.width, size.height);
    backImage.backgroundColor = [UIColor whiteColor];
    UIImageView *logImage = [[UIImageView alloc] initWithCornerRadiusAdvance:6.0f rectCornerType:UIRectCornerAllCorners];
    logImage.image =logoImg;
    CGFloat diff  =2;
    logImage.frame = CGRectMake(diff, diff, size.width - 2 * diff, size.height - 2 * diff);
    [backImage addSubview:logImage];

    return backImage;
}

- (void)layoutViews {
   [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.view.mas_top).offset(134);
       make.centerX.equalTo(self.view.mas_centerX);
   }];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImageView.mas_top);
        make.left.equalTo(self.bgImageView.mas_left).offset(7);
        make.right.equalTo(self.bgImageView.mas_right).offset(-7);
    }];
    
    [self.QRCodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.containerView);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*177, kScreenWidth/375*177));
    }];
    
    [self.downLoadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bgImageView.mas_bottom).offset(-50);
        make.centerX.equalTo(self.bgImageView.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*100, 30));
    }];
    
}


@end
