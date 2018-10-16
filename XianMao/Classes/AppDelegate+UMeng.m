//
//  AppDelegate+UMeng.m
//  XianMao
//
//  Created by darren on 6/27/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "AppDelegate+UMeng.h"

#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMSocialSinaHandler.h"
#import "Version.h"

//for mac
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//for idfa
#import <ADSupport/AdSupport.h>
#import <AdSupport/ASIdentifierManager.h>
#import "OpenUDID.h"

@interface AppDelegate ()<UMSocialUIDelegate>

@end

@implementation AppDelegate (UMeng)


- (void)umengApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self umessageInit:launchOptions];
    [self umSocialInit];
    [self umengTrack];
    
    [self setupNotifiers];
    
    // 友盟渠道统计
    NSString * appKey = UmengAppkey;//@"5486e9e6fd98c55164000243";
    NSString * deviceName = [[[UIDevice currentDevice] name] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString * mac = [self macString];
    NSString * idfa = [self idfaString];
    NSString * idfv = [self idfvString];
    NSString * urlString = [NSString stringWithFormat:@"http://log.umtrack.com/ping/%@/?devicename=%@&mac=%@&idfa=%@&idfv=%@", appKey, deviceName, mac, idfa, idfv];
    [NSURLConnection connectionWithRequest:[NSURLRequest requestWithURL: [NSURL URLWithString:urlString]] delegate:nil];
    
    //kenengbeijujue
    [self requestTrackWithAppkey:appKey];
}

// 监听系统生命周期回调，以便将需要的事件传给SDK
- (void)setupNotifiers{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appDidBecomeActiveNotifUMeng:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    
 
}

-(void)requestTrackWithAppkey:(NSString *)appkey
{
    if (!appkey || ![appkey length])
    {
        return;
    }
    
    ASIdentifierManager *asIM = [[ASIdentifierManager alloc] init];
    NSString *idfa = [asIM.advertisingIdentifier UUIDString];
    NSString *idfv = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NSString *openudid = [OpenUDID value];
    NSString *mac = [self macString];
    // NSString *utdid = [UTDevice utdid];
    
    size_t size;
    // Set 'oldp' parameter to NULL to get the size of the data
    // returned so we can allocate appropriate amount of space
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    // Allocate the space to store name
    char *name = malloc(size);
    // Get the platform name
    sysctlbyname("hw.machine", name, &size, NULL, 0);
    // Place name into a string
    NSString *machine = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
    // Done with this
    free(name);
    machine=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                  (CFStringRef)machine,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8));
    mac=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                              (CFStringRef)mac,
                                                                              NULL,
                                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                              kCFStringEncodingUTF8));
    NSString *requestURL = [[NSString alloc] initWithFormat:@"https://ar.umeng.com/stat.htm?ak=%@&device_name=%@&idfa=%@&openudid=%@&idfv=%@&mac=%@",appkey,machine,idfa,openudid,idfv,mac];
    
    NSError *error = nil;
    NSHTTPURLResponse *response = nil;
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if (responseData)
    {
        //
        // NSLog(@"ok");
    }
    
}

-(void)appDidBecomeActiveNotifUMeng:(NSNotification*)notif
{
    [UMSocialSnsService  applicationDidBecomeActive];
}


- (void)umengTrack {
    //    Class cls = NSClassFromString(@"UMANUtil");
    //    SEL deviceIDSelector = @selector(openUDIDString);
    //    NSString *deviceID = nil;
    //    if(cls && [cls respondsToSelector:deviceIDSelector]){
    //        deviceID = [cls performSelector:deviceIDSelector];
    //    }
    //    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
    //                                                       options:NSJSONWritingPrettyPrinted
    //                                                         error:nil];
    //
    //    NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
    
//        [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    //[MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    [MobClick setAppVersion:APP_VERSION]; //参数为NSString * 类型,自定义app版本信息，如果不设置，默认从CFBundleVersion里取
    //
    UMConfigInstance.appKey = UmengAppkey;
    UMConfigInstance.ePolicy = (ReportPolicy) REALTIME;
    UMConfigInstance.channelId = @"";
    [MobClick startWithConfigure:UMConfigInstance];
//    [MobClick startWithAppkey:UmengAppkey reportPolicy:(ReportPolicy) REALTIME channelId:@""];
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //      [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
//    [MobClick updateOnlineConfig];  //在线参数配置
}

- (void)umSocialInit
{
    //设置友盟社会化组件appkey
    [UMSocialData setAppKey:UmengAppkey];
#if DEBUG
    //打开调试log的开关
    [UMSocialData openLog:YES];
#endif
    //如果你要支持不同的屏幕方向，需要这样设置，否则在iPhone只支持一个竖屏方向
    [UMSocialConfig setSupportedInterfaceOrientations:UIInterfaceOrientationMaskAll];
    
    //设置微信AppId，设置分享url，默认使用友盟的网址
    [UMSocialWechatHandler setWXAppId:WXAppId appSecret:WXAppSecret url:@"http://www.aidingmao.com/"];
    
    //打开新浪微博的SSO开关
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    
    //    //设置分享到QQ空间的应用Id，和分享url 链接
    [UMSocialQQHandler setQQWithAppId:kQQAPPID appKey:kQQAPPKEY url:@"http://www.aidingmao.com"];
    //    //设置支持没有客户端情况下使用SSO授权
    [UMSocialQQHandler setSupportWebView:YES];
}


#define UMSYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define _IPHONE80_ 80000

- (void)umessageInit:(NSDictionary *)launchOptions {
    //set AppKey and LaunchOptions
    [UMessage startWithAppkey:UmengAppkey launchOptions:launchOptions];
    
    //自动清空角标，默认YES
    [UMessage setBadgeClear:NO];
    //前台运行收到Push时弹出Alert，默认YES
    [UMessage setAutoAlert:NO];
#if DEBUG
    [UMessage setLogEnabled:YES];
#endif
}

#pragma mark - private method

- (NSString * )macString{
    int mib[6];
    size_t len;
    char *buf;
    unsigned char *ptr;
    struct if_msghdr *ifm;
    struct sockaddr_dl *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *macString = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return macString;
}

- (NSString *)idfaString {
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return @"";
    }
    else{
        
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if(asIdentifierMClass == nil){
            return @"";
        }
        else{
            
            //for no arc
            //ASIdentifierManager *asIM = [[[asIdentifierMClass alloc] init] autorelease];
            //for arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return @"";
            }
            else{
                
                if(asIM.advertisingTrackingEnabled){
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else{
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)idfvString
{
    if([[UIDevice currentDevice] respondsToSelector:@selector( identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return @"";
}

#pragma mark -

- (void)loginWithThridParty:(UIViewController*)presentingController platformName:(NSString*)platformName
                 completion:(void (^)(UMSocialAccountEntity *snsAccount))completion {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platformName];
    [UMSocialControllerService defaultControllerService].socialUIDelegate = self;
    snsPlatform.loginClickHandler(presentingController,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //获取用户名、uid、token等
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:platformName];
            NSLog(@"username is %@, uid is %@, token is %@ iconUrl is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            if (completion) {
                completion(snsAccount);
            }
        } else if (response.responseCode == UMSResponseCodeCancel) {
//            [((BaseViewController*)presentingController) showHUD:@"取消登陆" hideAfterDelay:1.2];
        } else {
            if ([presentingController isKindOfClass:[BaseViewController class]]) {
                [((BaseViewController*)presentingController) showHUD:@"登陆失败" hideAfterDelay:1.2];
            }
        }
    });
}

@end
