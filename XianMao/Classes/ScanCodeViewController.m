//
//  ScanCodeViewController.m
//  XianMao
//
//  Created by WJH on 16/12/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ScanCodeViewController.h"
#import "WCAlertView.h"
#import "ScanCodePaymentViewController.h"
#import "NSString+AES.h"
#import "NSString+URLEncoding.h"
#import "URLScheme.h"

#define KEY_VALUE @"AbcdEfgHijkLmnOp"

#if DEBUG
#define HASPREfIXSTRING @"http://m.aidingmao.com/store/paycode"
#else
#define HASPREfIXSTRING @"http://m.aidingmao.com/store/paycode"

#endif

@interface ScanCodeViewController ()

@property (nonatomic, strong) UIButton * backButton;
@property (nonatomic, strong) UIButton * albumButton;
@property (nonatomic, strong) UILabel * topTitle;
@property (nonatomic, strong) UILabel * descLabel;
@end

@implementation ScanCodeViewController

-(UIButton *)backButton{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(12, 30, 32, 32)];
        [_backButton setImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        _backButton.userInteractionEnabled = YES;
    }
    return _backButton;
}

-(UIButton *)albumButton{
    if (!_albumButton) {
        _albumButton = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth-15-40, 30, 40, 40)];
        [_albumButton setTitle:@"相册" forState:UIControlStateNormal];
        [_albumButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _albumButton.titleLabel.font = [UIFont systemFontOfSize:15];
    }
    return _albumButton;
}

-(UILabel *)topTitle{
    if (!_topTitle) {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, kScreenWidth, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 150);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.qRScanView.frame)/2, 88+50);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将二维码放入框内";
        _topTitle.textColor = [UIColor lightGrayColor];
    }
    return _topTitle;
}

-(UILabel *)descLabel{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 400, kScreenWidth, 60)];
        _descLabel.textColor = [UIColor yellowColor];
        _descLabel.font = [UIFont systemFontOfSize:14];
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.text = @"扫描店家的收款二维码";
    }
    return _descLabel;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self.view addSubview:self.topTitle];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.albumButton];
    [self.view addSubview:self.descLabel];
    [self.view bringSubviewToFront:self.descLabel];
    [self.view bringSubviewToFront:self.topTitle];
    [self.view bringSubviewToFront:self.backButton];
    [self.view bringSubviewToFront:self.albumButton];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"dissMissScanCodeViewCtrl" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.isNeedScanImage = YES;
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    

    
    [self.backButton addTarget:self action:@selector(backButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.albumButton addTarget:self action:@selector(albumButtonClick) forControlEvents:UIControlEventTouchUpInside];

    [self customUI];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dissMissScanCodeViewCtrl:) name:@"dissMissScanCodeViewCtrl" object:nil];
}

- (void)dissMissScanCodeViewCtrl:(NSNotification *)n{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customUI{
    int XRetangleLeft = self.style.xScanRetangleOffset;
    CGSize sizeRetangle = CGSizeMake(self.view.frame.size.width - XRetangleLeft*2, self.view.frame.size.width - XRetangleLeft*2);
    CGFloat YMinRetangle = self.view.frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
    CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
    //扫码区域Y轴最小坐标

    self.descLabel.frame = CGRectMake(0, YMaxRetangle, kScreenWidth, 60);
    self.topTitle.frame = CGRectMake(0, YMinRetangle - 70, kScreenWidth, 60);
}


- (void)backButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)albumButtonClick {
    if ([LBXScanWrapper isGetPhotoPermission]){
        [self openLocalPhoto];
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


- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //声音提醒
    [LBXScanWrapper systemSound];
    [self showNextVCWithScanResult:scanResult];
}


- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{
    //NSLog(@"扫描出来的字符串%@",strResult.strScanned);
    //NSLog(@"扫描出来的图片%@",strResult.imgScanned);

    if ([strResult.strScanned hasPrefix:HASPREfIXSTRING]) {
        NSURL * url = [NSURL URLWithString:strResult.strScanned];
        NSString *query = url.query;
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        for (NSString *param in [query componentsSeparatedByString:@"&"]) {
            NSArray *elts = [param componentsSeparatedByString:@"="];
            if([elts count] < 2) continue;
            [params setObject:[elts objectAtIndex:1] forKey:[elts objectAtIndex:0]];
        }
        
        NSString * userId = [params valueForKey:@"user_id"];
        NSString * title = [[params valueForKey:@"title"]  URLDecodedString];
        
        ScanCodePaymentViewController * viewCtrl = [[ScanCodePaymentViewController alloc] init];
        viewCtrl.userId = userId.integerValue;
        viewCtrl.topBarTitle = title;
        [self.navigationController pushViewController:viewCtrl animated:YES];
        
    }else{
        [URLScheme locateWithRedirectUriImpl:strResult.strScanned andIsShare:NO isScanCode:YES];
    }
    
    
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    [WCAlertView showAlertWithTitle:@"扫码内容" message:strResult customizationBlock:^(WCAlertView *alertView) {
        
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        if (buttonIndex == 0) {
            
        }else{
            [weakSelf reStartDevice];
        }
    } cancelButtonTitle:@"取消" otherButtonTitles:@"继续扫码", nil];
}



@end
