//
//  NetworkManager.m
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "NetworkManager.h"
#import "SynthesizeSingleton.h"
#import "NSMutableArray+WeakReferences.h"
#import "NSDictionary+Additions.h"
#import "AFNetworking.h"

#import "Error.h"
#import "Session.h"

#import "Version.h"
#import "DeviceUtil.h"
#import "AppDelegate.h"

#import "JSONModel.h"
#import "NSString+URLEncoding.h"
#import "JSONKit.h"
#import "AFNetworking.h"
#import <AdSupport/AdSupport.h>

@interface NetworkManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager *requestOperationManager;
@property (nonatomic, strong) AFHTTPRequestSerializer *jsonRequestSerializer;
@property (nonatomic, strong) AFHTTPRequestSerializer *requestSerializer;
@property (nonatomic, strong) AFHTTPResponseSerializer *responseSerializer;
@property (nonatomic, strong) NSMutableArray *httpRequests;


- (HTTPRequest*)addRequest:(HTTPRequest*)request;
- (void)removeRequest:(HTTPRequest*)request;


@end

@interface HTTPRequest ()

@property(nonatomic, strong) AFHTTPRequestOperation *operation;

@property (nonatomic, strong) AFHTTPSessionManager *manager;

+ (instancetype)createWithOperation:(AFHTTPRequestOperation*)operation;

+ (instancetype)createWithManager:(AFHTTPSessionManager*)manager;
@end

@implementation HTTPRequest

+ (instancetype)createWithOperation:(AFHTTPRequestOperation*)operation {
    HTTPRequest *request = [[self alloc] init];
    request.operation = operation;
    return request;
}

+(instancetype)createWithManager:(AFHTTPSessionManager *)manager{
    HTTPRequest *request = [[self alloc] init];
    request.manager = manager;
    return request;
}

- (void)cancel {
    [_operation setCompletionBlockWithSuccess:nil failure:nil];
    [_operation cancel];
    [[NetworkManager sharedInstance] removeRequest:self];
}

- (BOOL)isFinished {
    return _operation?[_operation isFinished]:YES;
}

- (BOOL)isRunning {
    return _operation?!([_operation isFinished]||[_operation isCancelled]):NO;
}

- (void)dealloc {
    [self cancel];
}

@end

@implementation NetworkManager

SYNTHESIZE_SINGLETON_FOR_CLASS(NetworkManager, sharedInstance);

- (void)initialize
{
    _jsonRequestSerializer = [AFJSONRequestSerializer serializer];
    _requestSerializer = [AFHTTPRequestSerializer serializer];
    _responseSerializer = [AFJSONResponseSerializer serializer];
    
    _requestOperationManager = [self startMonitoring];
    
    _httpRequests = [NSMutableArray array];
    
    _dynamicServerUrl = APIBaseURLString;
}


- (HTTPRequest*)clientReport:(ClientReport *)clientReport
                        data:(NSDictionary *)data
                  completion:(void (^)())completion
                     failure:(void (^)(XMError *error))failure {
    NSString *iPhoneVersion = [[UIDevice currentDevice] systemVersion];
    NSInteger userId = [Session sharedInstance].currentUserId;
    NSString *identifierForAdvertising = [[[UIDevice currentDevice] identifierForVendor] UUIDString];//[[ASIdentifierManager sharedManager].advertisingIdentifier UUIDString];
    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    //获取当前时间 时间戳格式
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    long long currentTime = [dat timeIntervalSince1970]*1000;
    
    NSDictionary *parameters = @{@"clientVersion":[NSString stringWithFormat:@"version-%@", iPhoneVersion], @"userId":[NSNumber numberWithInteger:userId], @"prefix":@"iOS", @"clientId":identifierForAdvertising, @"clickTimestamp":[NSNumber numberWithLongLong:currentTime], @"referPageCode":[NSNumber numberWithInteger:clientReport.referPageCode], @"regionCode":[NSNumber numberWithInteger:clientReport.regionCode], @"viewCode":[NSNumber numberWithInteger:clientReport.viewCode], @"data":data};
    NSDictionary *dict = [parameters toJSONDictionary];
    NSArray *paramerJsonArr = [NSArray arrayWithObject:dict];
//    NSMutableArray *paramArr = [NSMutableArray arrayWithObject:parameters];
//    NSString *paramsJsonData = [[paramArr toJSONArray] JSONString];
//    NSDictionary *dict = @{@"param":paramsJsonData};
    NSLog(@"%@", paramerJsonArr);
    return [[NetworkManager sharedInstance] requestWithMethodPOST:@"collection" path:@"client_report" parameters:paramerJsonArr completionBlock:^(NSDictionary *data) {
        if (completion)completion(data);
    } failure:^(XMError *error) {
        if (failure)failure(error);
    } queue:nil];
}

- (AFHTTPRequestOperationManager*)startMonitoring
{
    NSURL *baseURL = [NSURL URLWithString:_dynamicServerUrl];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
    
    NSOperationQueue *operationQueue = manager.operationQueue;
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                [operationQueue setSuspended:NO];
                break;
            case AFNetworkReachabilityStatusNotReachable:
            default:
                [operationQueue setSuspended:YES];
                break;
        }
    }];
    [manager.reachabilityManager startMonitoring];
    return manager;
}


- (BOOL)isReachable
{
    if (self.requestOperationManager) {
        return [self.requestOperationManager.reachabilityManager isReachable];
    }
    return NO;
}

- (BOOL)isReachableViaWiFi
{
    if (self.requestOperationManager) {
        return [self.requestOperationManager.reachabilityManager isReachableViaWiFi];
    }
    return NO;
}

- (AFSecurityPolicy*)customSecurityPolicy {
    // /先导入证书
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:ADMHttpsCer ofType:@"cer"];//证书的路径
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
//    NSSet *cerSet = [NSSet setWithObjects:certData, nil];
    
    // AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    // allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    // 如果是需要验证自建证书，需要设置为YES
    [securityPolicy setAllowInvalidCertificates:NO];
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    [securityPolicy setValidatesDomainName:YES];
    [securityPolicy setPinnedCertificates:@[certData]];
    [securityPolicy setValidatesCertificateChain:NO];
    
    return securityPolicy;
}

- (HTTPRequest*)requestWithCompletionBlock:(NSString*)method
                                      module:(NSString*)module
                                        path:(NSString*)path
                                  parameters:(id)parameters
                             completionBlock:(void (^)(id responseObject))completionBlock
                                     failure:(void (^)(XMError *error))failure
                                       queue:(dispatch_queue_t)queue {
    
    
    if ([parameters isKindOfClass:[NSDictionary class]]
        || [parameters isKindOfClass:[NSArray class]] || parameters == nil) {
//        NSString *str = @"http://192.168.1.88:8000";
        NSString *requestURL = [NSString stringWithFormat:@"%@/%@/%@",_dynamicServerUrl,module,path];//_dynamicServerUrl
        if ([[requestURL substringFromIndex:requestURL.length-1] isEqualToString:@"/"]) {
            requestURL = [requestURL substringToIndex:[requestURL length]-1];
        }
        NSError *error = nil;
        
        NSLog(@"(networkmanage 141)path:%@", requestURL);
        
        if (!parameters) {
            parameters = [[NSDictionary alloc] init];
        }
        
        AFHTTPRequestSerializer *requestSerializer = [method isEqualToString:@"GET"]?self.requestSerializer:self.jsonRequestSerializer;
        
        NSMutableURLRequest *request = [requestSerializer requestWithMethod:method
                                                                  URLString:requestURL
                                                                 parameters:parameters
                                                                      error:&error];
        
        NSString *url = [request.URL absoluteString];
//        NSLog(@"-------->front%@", url);
        //适配首页商品池链接  调整底层逻辑
        NSArray *array = [url componentsSeparatedByString:@"?"];
        if (array.count >= 2) {
            NSString *urlStr1 = array[0];
            NSString *urlStr = array[1];
            NSString *urlNewStr = [urlStr stringByReplacingOccurrencesOfString:@"/" withString:@""];
//            NSLog(@"======%@", urlNewStr);
            NSString *newUrl = [NSString stringWithFormat:@"%@?%@", urlStr1, urlNewStr];
//            NSLog(@"----> ------>%@", newUrl);
            url = newUrl;
        }
        NSLog(@"-------->%@",url);
        
        
        
        
//        适配iOS10 ipv6  修改网络请求   2016.9.24
//        [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
//        [request setTimeoutInterval:12];
//        Content-Type: application/json;charset=UTF-8
//        [request addValue:[Session sharedInstance].token?[Session sharedInstance].token:@"" forHTTPHeaderField:@"X-Auth-Token"];
//        [request addValue:APP_VERSION forHTTPHeaderField:@"X-App-Version"];
//        [request addValue:API_VERSION forHTTPHeaderField:@"X-Api-Version"];
//        [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
//        NSLog(@"Content-Type: %@", [request valueForHTTPHeaderField:@"X-Api-Version"]);
//********************************************************************************************//
        
//        NSString *body = [[NSString alloc] initWithData:[request HTTPBody] encoding:NSUTF8StringEncoding];
//        NSLog(@"%@",body);
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
        
//        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//            [weakSelf removeRequestByOperation:operation];
//            
//            if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                NSInteger code = [((NSDictionary*)responseObject) code];
//                if (XM_RESULT_IS_SUCCESS(code)) {
//                    if (completionBlock) completionBlock([((NSDictionary*)responseObject) data]);
//                } else {
//                    NSString *errorMsg = FormatErrorMessage([((NSDictionary*)responseObject) code]);
//                    if (failure) failure([XMError errorWithCode:[((NSDictionary*)responseObject) code] errorMsg:errorMsg?errorMsg:[((NSDictionary*)responseObject) msg] responseObject:responseObject]);
//                    if (XMTokenInvalidError == code) {
//                        //过滤下get_msgcount,get_goods_list
//                        [[NSNotificationCenter defaultCenter] postNotificationName:kTokenDidExpireNotification object:nil];
//                    }
//                }
//            } else {
//                NSLog(@"服务器返回数据错误:%@",responseObject);
//            }
//            
//        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//            [weakSelf removeRequestByOperation:operation];
//            if (error!=nil&&[error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
//                if (failure) failure([XMError errorWithCode:XMResponseSerializationError]);
//            } else if (error!=nil&&error.code==-1003 && ![weakSelf.dynamicServerUrl isEqualToString:APIBaseURLStringIP]) {
//                //Code=-1003 未能找到指定使用主机名的服务器
//                //切换到ip访问
//                weakSelf.dynamicServerUrl = APIBaseURLStringIP;
//                [weakSelf requestWithCompletionBlock:(NSString*)method
//                                              module:module
//                                                path:path
//                                          parameters:parameters
//                                     completionBlock:completionBlock
//                                             failure:failure
//                                               queue:queue];
//            }
//            else {
//                
//                if (failure) failure([XMError errorWithCode: error.code==-999?-999:XMNetworkError errorMsg:[NetworkManager sharedInstance].isReachable?error.localizedDescription:@"请检查网络连接"]);
//            }
//        }];
//        [operation start];
        
//*********************************************************************************************//
        
        
        WEAKSELF;
        
        NSString *userAgent = [NSString stringWithFormat:@"iOS|%@|%@|aidingmao|%@|(%@;%@)",APP_VERSION, [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],[[[UIDevice currentDevice] identifierForVendor] UUIDString],[DeviceUtil getDeviceModelName],[DeviceUtil getCurrentDeviceModel]];
        //[NSString stringWithFormat:@"iOS|%@|aidingmao|%@|(%@,%@)",APP_VERSION,
                               //[[[UIDevice currentDevice] identifierForVendor] UUIDString],
                               //[DeviceUtil getOsAndVersion],
                               //[DeviceUtil getCurrentDeviceModel]];

        
//        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//        configuration.HTTPMaximumConnectionsPerHost = 10;
        AFHTTPSessionManager *operation = [AFHTTPSessionManager manager];
        operation.requestSerializer = requestSerializer;
        [operation.requestSerializer setValue:[Session sharedInstance].token?[Session sharedInstance].token:@""  forHTTPHeaderField:@"X-Auth-Token"];
        [operation.requestSerializer setValue:APP_VERSION  forHTTPHeaderField:@"X-App-Version"];
        [operation.requestSerializer setValue:API_VERSION  forHTTPHeaderField:@"X-Api-Version"];
        [operation.requestSerializer setValue:userAgent  forHTTPHeaderField:@"User-Agent"];
        [operation.requestSerializer setValue:@"0"  forHTTPHeaderField:@"App-Type"];
        operation.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        operation.requestSerializer.timeoutInterval = 12;
        
        //typeof(NSString*) __weak weak_module = module;
        typeof(NSString*) __weak weak_path = path;
        
        operation.completionQueue = queue;
        [operation setResponseSerializer:self.responseSerializer];
        
        //https
        if(ADMopenHttpsSSL) {
            [operation setSecurityPolicy:[self customSecurityPolicy]];
        }
        
        if ([method isEqualToString:@"GET"]) {
            [operation GET:requestURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSInteger code = [((NSDictionary*)responseObject) code];
                    if (XM_RESULT_IS_SUCCESS(code)) {
                        if (completionBlock) completionBlock([((NSDictionary*)responseObject) data]);
                    } else {
                        NSString *errorMsg = FormatErrorMessage([((NSDictionary*)responseObject) code]);
                        if (failure) failure([XMError errorWithCode:[((NSDictionary*)responseObject) code] errorMsg:errorMsg?errorMsg:[((NSDictionary*)responseObject) msg] responseObject:responseObject]);
                        if (XMTokenInvalidError == code) {
                            //过滤下get_msgcount,get_goods_list
                            [[NSNotificationCenter defaultCenter] postNotificationName:kTokenDidExpireNotification object:nil];
                        }
                    }
                } else {
                    NSLog(@"服务器返回数据错误:%@",responseObject);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [weakSelf removeRequestSesstionByOperation:operation];
                if (error!=nil&&[error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
                    if (failure) failure([XMError errorWithCode:XMResponseSerializationError]);
                } else if (error!=nil&&error.code==-1003 && ![weakSelf.dynamicServerUrl isEqualToString:APIBaseURLStringIP]) {
                    //Code=-1003 未能找到指定使用主机名的服务器
                    //切换到ip访问
                    weakSelf.dynamicServerUrl = APIBaseURLStringIP;
                    [weakSelf requestWithCompletionBlock:(NSString*)method
                                                  module:module
                                                    path:path
                                              parameters:parameters
                                         completionBlock:completionBlock
                                                 failure:failure
                                                   queue:queue];
                }
                else {
                    if (failure) failure([XMError errorWithCode: error.code==-999?-999:XMNetworkError errorMsg:[NetworkManager sharedInstance].isReachable?error.localizedDescription:@"请检查网络连接"]);
                }
            }];
        } else if ([method isEqualToString:@"POST"]) {
            
            [operation POST:requestURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSInteger code = [((NSDictionary*)responseObject) code];
                    if (XM_RESULT_IS_SUCCESS(code)) {
                        if (completionBlock) completionBlock([((NSDictionary*)responseObject) data]);
                    } else {
                        NSString *errorMsg = FormatErrorMessage([((NSDictionary*)responseObject) code]);
                        if (failure) failure([XMError errorWithCode:[((NSDictionary*)responseObject) code] errorMsg:errorMsg?errorMsg:[((NSDictionary*)responseObject) msg] responseObject:responseObject]);
                        if (XMTokenInvalidError == code) {
                            //过滤下get_msgcount,get_goods_list
                            [[NSNotificationCenter defaultCenter] postNotificationName:kTokenDidExpireNotification object:nil];
                        }
                    }
                } else {
                    NSLog(@"服务器返回数据错误:%@",responseObject);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [weakSelf removeRequestSesstionByOperation:operation];
                if (error!=nil&&[error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
                    if (failure) failure([XMError errorWithCode:XMResponseSerializationError]);
                } else if (error!=nil&&error.code==-1003 && ![weakSelf.dynamicServerUrl isEqualToString:APIBaseURLStringIP]) {
                    //Code=-1003 未能找到指定使用主机名的服务器
                    //切换到ip访问
                    weakSelf.dynamicServerUrl = APIBaseURLStringIP;
                    [weakSelf requestWithCompletionBlock:(NSString*)method
                                                  module:module
                                                    path:path
                                              parameters:parameters
                                         completionBlock:completionBlock
                                                 failure:failure
                                                   queue:queue];
                }
                else {
                    if (failure) failure([XMError errorWithCode: error.code==-999?-999:XMNetworkError errorMsg:[NetworkManager sharedInstance].isReachable?error.localizedDescription:@"请检查网络连接"]);
                }
            }];
            
//            [operation POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//                
//            } success:^(NSURLSessionDataTask *task, id responseObject) {
//                if ([responseObject isKindOfClass:[NSDictionary class]]) {
//                    NSInteger code = [((NSDictionary*)responseObject) code];
//                    if (XM_RESULT_IS_SUCCESS(code)) {
//                        if (completionBlock) completionBlock([((NSDictionary*)responseObject) data]);
//                    } else {
//                        NSString *errorMsg = FormatErrorMessage([((NSDictionary*)responseObject) code]);
//                        if (failure) failure([XMError errorWithCode:[((NSDictionary*)responseObject) code] errorMsg:errorMsg?errorMsg:[((NSDictionary*)responseObject) msg] responseObject:responseObject]);
//                        if (XMTokenInvalidError == code) {
//                            //过滤下get_msgcount,get_goods_list
//                            [[NSNotificationCenter defaultCenter] postNotificationName:kTokenDidExpireNotification object:nil];
//                        }
//                    }
//                } else {
//                    NSLog(@"服务器返回数据错误:%@",responseObject);
//                }
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                [weakSelf removeRequestSesstionByOperation:operation];
//                if (error!=nil&&[error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
//                    if (failure) failure([XMError errorWithCode:XMResponseSerializationError]);
//                } else if (error!=nil&&error.code==-1003 && ![weakSelf.dynamicServerUrl isEqualToString:APIBaseURLStringIP]) {
//                    //Code=-1003 未能找到指定使用主机名的服务器
//                    //切换到ip访问
//                    weakSelf.dynamicServerUrl = APIBaseURLStringIP;
//                    [weakSelf requestWithCompletionBlock:(NSString*)method
//                                                  module:module
//                                                    path:path
//                                              parameters:parameters
//                                         completionBlock:completionBlock
//                                                 failure:failure
//                                                   queue:queue];
//                }
//                else {
//                    if (failure) failure([XMError errorWithCode: error.code==-999?-999:XMNetworkError errorMsg:[NetworkManager sharedInstance].isReachable?error.localizedDescription:@"请检查网络连接"]);
//                }
//            }];
        } else if ([method isEqualToString:@"PUT"]) {
            [operation PUT:requestURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSInteger code = [((NSDictionary*)responseObject) code];
                    if (XM_RESULT_IS_SUCCESS(code)) {
                        if (completionBlock) completionBlock([((NSDictionary*)responseObject) data]);
                    } else {
                        NSString *errorMsg = FormatErrorMessage([((NSDictionary*)responseObject) code]);
                        if (failure) failure([XMError errorWithCode:[((NSDictionary*)responseObject) code] errorMsg:errorMsg?errorMsg:[((NSDictionary*)responseObject) msg] responseObject:responseObject]);
                        if (XMTokenInvalidError == code) {
                            //过滤下get_msgcount,get_goods_list
                            [[NSNotificationCenter defaultCenter] postNotificationName:kTokenDidExpireNotification object:nil];
                        }
                    }
                } else {
                    NSLog(@"服务器返回数据错误:%@",responseObject);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [weakSelf removeRequestSesstionByOperation:operation];
                if (error!=nil&&[error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
                    if (failure) failure([XMError errorWithCode:XMResponseSerializationError]);
                } else if (error!=nil&&error.code==-1003 && ![weakSelf.dynamicServerUrl isEqualToString:APIBaseURLStringIP]) {
                    //Code=-1003 未能找到指定使用主机名的服务器
                    //切换到ip访问
                    weakSelf.dynamicServerUrl = APIBaseURLStringIP;
                    [weakSelf requestWithCompletionBlock:(NSString*)method
                                                  module:module
                                                    path:path
                                              parameters:parameters
                                         completionBlock:completionBlock
                                                 failure:failure
                                                   queue:queue];
                }
                else {
                    if (failure) failure([XMError errorWithCode: error.code==-999?-999:XMNetworkError errorMsg:[NetworkManager sharedInstance].isReachable?error.localizedDescription:@"请检查网络连接"]);
                }
            }];
        } else if ([method isEqualToString:@"DELETE"]) {
            [operation DELETE:requestURL parameters:parameters success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject isKindOfClass:[NSDictionary class]]) {
                    NSInteger code = [((NSDictionary*)responseObject) code];
                    if (XM_RESULT_IS_SUCCESS(code)) {
                        if (completionBlock) completionBlock([((NSDictionary*)responseObject) data]);
                    } else {
                        NSString *errorMsg = FormatErrorMessage([((NSDictionary*)responseObject) code]);
                        if (failure) failure([XMError errorWithCode:[((NSDictionary*)responseObject) code] errorMsg:errorMsg?errorMsg:[((NSDictionary*)responseObject) msg] responseObject:responseObject]);
                        if (XMTokenInvalidError == code) {
                            //过滤下get_msgcount,get_goods_list
                            [[NSNotificationCenter defaultCenter] postNotificationName:kTokenDidExpireNotification object:nil];
                        }
                    }
                } else {
                    NSLog(@"服务器返回数据错误:%@",responseObject);
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [weakSelf removeRequestSesstionByOperation:operation];
                if (error!=nil&&[error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
                    if (failure) failure([XMError errorWithCode:XMResponseSerializationError]);
                } else if (error!=nil&&error.code==-1003 && ![weakSelf.dynamicServerUrl isEqualToString:APIBaseURLStringIP]) {
                    //Code=-1003 未能找到指定使用主机名的服务器
                    //切换到ip访问
                    weakSelf.dynamicServerUrl = APIBaseURLStringIP;
                    [weakSelf requestWithCompletionBlock:(NSString*)method
                                                  module:module
                                                    path:path
                                              parameters:parameters
                                         completionBlock:completionBlock
                                                 failure:failure
                                                   queue:queue];
                }
                else {
                    if (failure) failure([XMError errorWithCode: error.code==-999?-999:XMNetworkError errorMsg:[NetworkManager sharedInstance].isReachable?error.localizedDescription:@"请检查网络连接"]);
                }
            }];
        }

        return [HTTPRequest createWithManager:operation];
//        //return [self addRequest:[HTTPRequest createWithOperation:operation]];
    }
    return nil;
}

- (HTTPRequest*)requestWithMethodPOST:(NSString*)module
                                   path:(NSString*)path
                             parameters:(id)parameters
                               fileName:(NSString*)fileName
                               filePath:(NSString*)filePath
                        completionBlock:(void (^)(NSDictionary *data))completionBlock
                                failure:(void (^)(XMError *error))failure
                                  queue:(dispatch_queue_t)queue {

    return [self requestWithMethodPOST:module path:path parameters:parameters fileName:fileName filePathArray:[NSArray arrayWithObjects:filePath, nil] constructingBodyWithBlock:nil completionBlock:completionBlock failure:failure queue:queue];
}

- (HTTPRequest*)requestWithMethodPOST:(NSString*)module
                                 path:(NSString*)path
                           parameters:(id)parameters
                             fileName:(NSString*)fileName
                        filePathArray:(NSArray*)filePathArray
                      completionBlock:(void (^)(NSDictionary *data))completionBlock
                              failure:(void (^)(XMError *error))failure
                                queue:(dispatch_queue_t)queue {
    return [self requestWithMethodPOST:module path:path parameters:parameters fileName:fileName filePathArray:filePathArray constructingBodyWithBlock:nil completionBlock:completionBlock failure:failure queue:queue];
}

- (HTTPRequest*)requestWithMethodPOST:(NSString*)module
                                   path:(NSString*)path
                             parameters:(id)parameters
                               fileName:(NSString*)fileName
                          filePathArray:(NSArray*)filePathArray
            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingFormData
                        completionBlock:(void (^)(NSDictionary *data))completionBlock
                                failure:(void (^)(XMError *error))failure
                                  queue:(dispatch_queue_t)queue {
    
    if ([parameters isKindOfClass:[NSDictionary class]]
        || [parameters isKindOfClass:[NSArray class]] || parameters == nil) {
        
        if (!parameters) {
            parameters = [[NSDictionary alloc] init];
        }
        
        NSString *requestURL = [NSString stringWithFormat:@"%@/%@/%@",_dynamicServerUrl,module,path];
        
        NSError *error = nil;
        AFHTTPRequestSerializer *requestSerializer = self.requestSerializer;
        NSMutableURLRequest *request = [requestSerializer multipartFormRequestWithMethod:@"POST" URLString:requestURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if ([fileName length]>0 && [filePathArray count]>0) {
                for (NSString *filePath in filePathArray) {
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:fileName error:nil];
                }
            }
//            NSLog(@"formData:%@", formData);
            if (constructingFormData) {
                constructingFormData(formData);
            }
//            [request setTimeoutInterval:20];
        } error:&error];
        
        
//*******************************************************************************************************************************************//
        
//        Content-Type: multipart/form-data;
//        [request addValue:[Session sharedInstance].token?[Session sharedInstance].token:@"" forHTTPHeaderField:@"X-Auth-Token"];
//        [request addValue:APP_VERSION forHTTPHeaderField:@"X-App-Version"];
//        [request addValue:API_VERSION forHTTPHeaderField:@"X-Api-Version"];
//        [request addValue:userAgent forHTTPHeaderField:@"User-Agent"];
//        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
//**********************************************************************************************************************************************//
        
        
        WEAKSELF;
        NSString *userAgent = [NSString stringWithFormat:@"iOS|%@|%@|aidingmao|%@|(%@;%@)",APP_VERSION, [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString],[[[UIDevice currentDevice] identifierForVendor] UUIDString],[DeviceUtil getDeviceModelName],[DeviceUtil getCurrentDeviceModel]];
        AFHTTPSessionManager *operation = [AFHTTPSessionManager manager];
        operation.requestSerializer = requestSerializer;
        [operation.requestSerializer setValue:[Session sharedInstance].token?[Session sharedInstance].token:@""  forHTTPHeaderField:@"X-Auth-Token"];
        [operation.requestSerializer setValue:APP_VERSION  forHTTPHeaderField:@"X-App-Version"];
        [operation.requestSerializer setValue:API_VERSION  forHTTPHeaderField:@"X-Api-Version"];
        [operation.requestSerializer setValue:userAgent  forHTTPHeaderField:@"User-Agent"];
        [operation.requestSerializer setValue:@"0"  forHTTPHeaderField:@"App-Type"];
        operation.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        operation.requestSerializer.timeoutInterval = 12;
        operation.completionQueue = queue;
        [operation setResponseSerializer:self.responseSerializer];
        
        //https
        if(ADMopenHttpsSSL) {
            [operation setSecurityPolicy:[self customSecurityPolicy]];
        }
        
        [operation POST:requestURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            if ([fileName length]>0 && [filePathArray count]>0) {
                for (NSString *filePath in filePathArray) {
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:fileName error:nil];
                }
            }
            if (constructingFormData) {
                constructingFormData(formData);
            }
        } success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                NSInteger code = [((NSDictionary*)responseObject) code];
                if (XM_RESULT_IS_SUCCESS(code)) {
                    if (completionBlock) completionBlock([((NSDictionary*)responseObject) data]);
                } else {
                    NSString *errorMsg = FormatErrorMessage([((NSDictionary*)responseObject) code]);
                    if (failure) failure([XMError errorWithCode:[((NSDictionary*)responseObject) code] errorMsg:errorMsg?errorMsg:[((NSDictionary*)responseObject) msg] responseObject:responseObject]);
                    if (XMTokenInvalidError == code) {
                        //过滤下get_msgcount,get_goods_list
                        [[NSNotificationCenter defaultCenter] postNotificationName:kTokenDidExpireNotification object:nil];
                    }
                }
            } else {
                NSLog(@"服务器返回数据错误:%@",responseObject);
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            [weakSelf removeRequestSesstionByOperation:operation];
            if (error!=nil&&[error.domain isEqualToString:AFURLResponseSerializationErrorDomain]) {
                if (failure) failure([XMError errorWithCode:XMResponseSerializationError]);
            } else if (error!=nil&&error.code==-1003 && ![weakSelf.dynamicServerUrl isEqualToString:APIBaseURLStringIP]) {
                //Code=-1003 未能找到指定使用主机名的服务器
                //切换到ip访问
                weakSelf.dynamicServerUrl = APIBaseURLStringIP;
                [weakSelf requestWithCompletionBlock:@"POST"
                                              module:module
                                                path:path
                                          parameters:parameters
                                     completionBlock:completionBlock
                                             failure:failure
                                               queue:queue];
            }
            else {
                if (failure) failure([XMError errorWithCode: error.code==-999?-999:XMNetworkError errorMsg:[NetworkManager sharedInstance].isReachable?error.localizedDescription:@"请检查网络连接"]);
            }
        }];
        return [HTTPRequest createWithManager:operation];
    }
    return nil;
}

- (HTTPRequest*)requestWithMethodGET:(NSString*)module
                                  path:(NSString*)path
                            parameters:(id)parameters
                       completionBlock:(void (^)(NSDictionary *data))completionBlock
                               failure:(void (^)(XMError *error))failure
                                 queue:(dispatch_queue_t)queue
{
    return [self requestWithCompletionBlock:@"GET"
                              module:module
                                path:path
                          parameters:parameters
                     completionBlock:completionBlock
                             failure:failure
                               queue:queue];
}

- (HTTPRequest*)requestWithMethodPOST:(NSString*)module
                                   path:(NSString*)path
                             parameters:(id)parameters
                        completionBlock:(void (^)(NSDictionary *data))completionBlock
                                failure:(void (^)(XMError *error))failure
                                  queue:(dispatch_queue_t)queue
{
    return [self requestWithCompletionBlock:@"POST"
                                     module:module
                                       path:path
                                 parameters:parameters
                            completionBlock:completionBlock
                                    failure:failure
                                      queue:queue];
}

- (HTTPRequest*)requestWithMethodPUT:(NSString*)module
                                  path:(NSString*)path
                            parameters:(id)parameters
                       completionBlock:(void (^)(NSDictionary *data))completionBlock
                               failure:(void (^)(XMError *error))failure
                                 queue:(dispatch_queue_t)queue {
    
    return [self requestWithCompletionBlock:@"PUT"
                                     module:module
                                       path:path
                                 parameters:parameters
                            completionBlock:completionBlock
                                    failure:failure
                                      queue:queue];
}

- (HTTPRequest*)requestWithMethodDELETE:(NSString*)module
                                    path:(NSString*)path
                              parameters:(id)parameters
                         completionBlock:(void (^)(NSDictionary *data))completionBlock
                                 failure:(void (^)(XMError *error))failure
                                   queue:(dispatch_queue_t)queue
{
    return [self requestWithCompletionBlock:@"DELETE"
                                     module:module
                                       path:path
                                 parameters:parameters
                            completionBlock:completionBlock
                                    failure:failure
                                      queue:queue];
}

- (HTTPRequest*)addRequest:(HTTPRequest*)request {
    @synchronized(_httpRequests) {
        if (![_httpRequests containsObject:request]) {
            [_httpRequests addObject:request];
        }
    }
    return request;
}

- (void)removeRequest:(HTTPRequest*)request {
    @synchronized(_httpRequests) {
        [_httpRequests removeObject:request];
    }
}

- (void)removeRequestSesstionByOperation:(AFHTTPSessionManager *)operation {
    @synchronized(_httpRequests) {
        for (HTTPRequest *request in _httpRequests) {
            if (request.manager == operation) {
                [_httpRequests removeObject:request];
                break;
            }
        }
    }
}

- (void)removeRequestByOperation:(AFHTTPRequestOperation *)operation {
    @synchronized(_httpRequests) {
        for (HTTPRequest *request in _httpRequests) {
            if (request.operation == operation) {
                [_httpRequests removeObject:request];
                break;
            }
        }
    }
}



@end


@implementation NSMutableDictionary (NetoworkResponseData)

- (NSInteger)code {
    return [self integerValueForKey:@"code"];
}

- (NSString*)msg {
    return [self stringValueForKey:@"msg"];
}

- (NSDictionary*)data {
    return [self dictionaryValueForKey:@"data"];
}

@end

@implementation NSDictionary (NetoworkResponseData)

- (NSInteger)code {
    return [self integerValueForKey:@"code"];
}

- (NSString*)msg {
    return [self stringValueForKey:@"msg"];
}

- (NSDictionary*)data {
    return [self dictionaryValueForKey:@"data"];
}

@end


NSString *const kTokenDidExpireNotification = @"kTokenDidExpireNotification";


