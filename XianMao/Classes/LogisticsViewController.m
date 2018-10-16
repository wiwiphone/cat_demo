//
//  LogisticsViewController.m
//  XianMao
//
//  Created by WJH on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "LogisticsViewController.h"
#import "LogisticsMessageView.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "MyWebView.h"
#import "NetworkAPI.h"
#import "TradeService.h"
#import "Session.h"
#import "SoldViewController.h"
#import "UserAddressViewController.h"
#import "WCAlertView.h"
#import "AddressInfo.h"
#import "Error.h"



@interface LogisticsViewController ()<UIWebViewDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) LogisticsMessageView * logMsgView;
@property (nonatomic, strong) MyWebView *webView;
@property (nonatomic, assign) CGFloat headerHeight;
@property (nonatomic, strong) NSArray *mailTypeList;
@property(nonatomic,strong) AddressInfo *addressInfo;

@end

@implementation LogisticsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    [super setupTopBarTitle:@"物流信息"];
    [super setupTopBarBackButton];
 
    _logMsgView = [[LogisticsMessageView alloc] initWithFrame:CGRectMake(0, self.topBar.height, kScreenWidth, 64)];
    _logMsgView.backgroundColor = [UIColor whiteColor];
    self.headerHeight = _logMsgView.height;
    if (self.mailInfo) {
        [self.logMsgView getMainInfo:self.mailInfo orderInfo:self.orderInfo];
    }
    
    WEAKSELF;
    _logMsgView.handleReviseMailSnBlack = ^(){
        [weakSelf handleReviseMailSn:weakSelf.orderInfo.orderId];
    };
    
    [self.view addSubview:self.logMsgView];
    
    
    _webView = [[MyWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    _webView.backgroundColor = [UIColor clearColor];
    _webView.scrollView.showsVerticalScrollIndicator = NO;
    _webView.scrollView.showsHorizontalScrollIndicator = NO;
    _webView.delegate = self;


    if ([self.url hasPrefix:@"www."]) {
        [self.webView firstLoadURLString:[NSString stringWithFormat:@"http://%@",self.url]];
    } else {
        [self.webView firstLoadURLString:self.url];
    }
   
    [self.view addSubview:self.webView];
    
    UIScrollView * sc = (UIScrollView *)[_webView subviews][0];
    sc.delegate = self;
    sc.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    sc.contentInset = UIEdgeInsetsMake(_headerHeight+65.5, 0, 0, 0);
    
    
    [self.view insertSubview:self.logMsgView aboveSubview:self.webView];
    [self bringTopBarToTop];

}


- (void)handleReviseMailSn:(NSString*)orderId
{
    WEAKSELF;
    [weakSelf showProcessingHUD:nil];
    [[NetworkManager sharedInstance] addRequest:[[NetworkAPI sharedInstance] getUserAddressList:[Session sharedInstance].currentUserId type:1 completion:^(NSArray *addressDictList) {
        
        if ([addressDictList count]>0) {
            if (weakSelf.mailTypeList == nil || [weakSelf.mailTypeList count]==0) {
                [TradeService listAllExpress:orderId completion:^(NSArray *mailTypeList, AddressInfo *addressInfo) {
                    [weakSelf hideHUD];
                    weakSelf.mailTypeList = mailTypeList;
                    
                    [DeliverInfoEditView showInViewWithAdress:weakSelf.view.superview.superview isSecuredTrade:YES mailTypeList:mailTypeList addressInfo:addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                        
                        if ([mailSN length]>0 && [mailType length]>0) {
                            [TradeService reviseOrderId:orderId mainSN:mailSN mailType:mailType completion:^{
                               
                                for (MailTypeDO * mainTypeDo in mailTypeList) {
                                    if ([mainTypeDo.mailType isEqualToString:mailType]) {
                                        [_logMsgView updataAfterRevise:mainTypeDo.mailCom mainSN:mailSN];
                                        break;
                                    }
                                }
                                
                                
                            } failure:^(XMError *error) {
                                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                                
                                
                            }];
                            return YES;
                        } else {
                            if ([mailSN length]==0) {
                                [weakSelf showHUD:@"请填写快递单号" hideAfterDelay:0.8f];
                            }
                            else if ([mailType length]==0) {
                                [weakSelf showHUD:@"请选择快递公司" hideAfterDelay:0.8f];
                            }
                            else {
                                [weakSelf showHUD:@"请填写完成的快递信息" hideAfterDelay:0.8f];
                            }
                            return NO;
                        }
                    }];
                    
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            } else {
                [weakSelf hideHUD];

                [DeliverInfoEditView showInViewWithAdress:weakSelf.view.superview.superview isSecuredTrade:YES mailTypeList:_mailTypeList addressInfo:_addressInfo completionBlock:^BOOL(NSString *mailSN, NSString *mailType) {
                    
                    if ([mailSN length]>0 && [mailType length]>0) {
                        [TradeService reviseOrderId:orderId mainSN:mailSN mailType:mailType completion:^{
                            
                            for (MailTypeDO * mainTypeDo in self.mailTypeList) {
                                if ([mainTypeDo.mailType isEqualToString:mailType]) {
                                    [_logMsgView updataAfterRevise:mainTypeDo.mailCom mainSN:mailSN];
                                    break;
                                }
                            }
                            
                        } failure:^(XMError *error) {
                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                        }];
                        return YES;
                    } else {
                        if ([mailSN length]==0) {
                            [weakSelf showHUD:@"请填写快递单号" hideAfterDelay:0.8f];
                        }
                        else if ([mailType length]==0) {
                            [weakSelf showHUD:@"请选择快递公司" hideAfterDelay:0.8f];
                        }
                        else {
                            [weakSelf showHUD:@"请填写完成的快递信息" hideAfterDelay:0.8f];
                        }
                        return NO;
                    }
                }];
            }
        } else {
            [weakSelf hideHUD];
            [WCAlertView showAlertWithTitle:@""
                                    message:@"请添加退货地址"
                         customizationBlock:^(WCAlertView *alertView) {
                             alertView.style = WCAlertViewStyleWhite;
                         } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                             if (buttonIndex == 0) {
                                 
                             } else {
                                 UserAddressViewController *viewController = [[UserAddressViewControllerReturn alloc] init];
                                 [weakSelf pushViewController:viewController animated:YES];
                             }
                         } cancelButtonTitle:@"取消" otherButtonTitles:@"好", nil];
        }
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
    }]];
}




#pragma mark - delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGRect frame = _logMsgView.frame;
    frame.origin.y = -scrollView.contentOffset.y - _headerHeight;
    _logMsgView.frame = frame;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    [self showLoadingView];
    UIApplication *app = [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = YES;
    return YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingView];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self hideLoadingView];
    UIApplication *app =   [UIApplication sharedApplication];
    app.networkActivityIndicatorVisible = NO;
}


-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"Load webView error:%@", [error localizedDescription]);
    //一个页面没有被完全加载之前收到下一个请求，此时迅速会出现此error,error=-999
    //此时可能已经加载完成，则忽略此error，继续进行加载。
    if([error code] == NSURLErrorCancelled)  {
        return;
    }
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self hideLoadingView];
    [self loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
        [self.webView firstLoadURLString:self.url];
    };
    
    [self showHUD:[NetworkManager sharedInstance].isReachable?@"数据加载失败":@"请检查网络连接" hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
}

@end
