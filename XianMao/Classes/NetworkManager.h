//
//  NetworkManager.h
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFURLRequestSerialization.h"
#import "ClientReport.h"

#if DEBUG
/* 开发版 */
//NSString * const APIBaseURLString = @"http://121.43.227.144:8090";

#define APIBaseURLString @"https://app-server-test.aidingmao.com"
#define APIBaseURLStringIP @"https://121.43.227.144:8000"

//#define APIBaseURLString @"http://192.168.2.39:8000"
//#define APIBaseURLStringIP @"http://192.168.2.39:8000"

////NSString * const APIBaseURLString = @"http://192.168.2.136:8000";
#else
/**
 *  正式环境
 */
#define APIBaseURLString @"https://app-server.aidingmao.com"
//#define APIBaseURLStringIP @"http://app-server.aidingmao.com"
#define APIBaseURLStringIP @"https://121.40.191.239"

#endif

@class XMError;
@class HTTPRequest;


@protocol NetworkManagerBase <NSObject>

@end


@interface NetworkManager : NSObject

@property (nonatomic, assign) NSString *dynamicServerUrl;

+ (NetworkManager*)sharedInstance;

- (BOOL)isReachable;
- (BOOL)isReachableViaWiFi;



- (HTTPRequest*)clientReport:(ClientReport *)clientReport
                        data:(NSDictionary *)data
                  completion:(void (^)())completion
                     failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)requestWithCompletionBlock:(NSString*)method
                                      module:(NSString*)module
                                        path:(NSString*)path
                                  parameters:(id)parameters
                             completionBlock:(void (^)(id responseObject))completionBlock
                                     failure:(void (^)(XMError *error))failure
                                       queue:(dispatch_queue_t)queue;

- (HTTPRequest*)requestWithMethodGET:(NSString*)module
                                  path:(NSString*)path
                            parameters:(id)parameters
                       completionBlock:(void (^)(NSDictionary *data))completionBlock
                               failure:(void (^)(XMError *error))failure
                                 queue:(dispatch_queue_t)queue;

- (HTTPRequest*)requestWithMethodPOST:(NSString*)module
                                   path:(NSString*)path
                             parameters:(id)parameters
                        completionBlock:(void (^)(NSDictionary *data))completionBlock
                                failure:(void (^)(XMError *error))failure
                                  queue:(dispatch_queue_t)queue;

- (HTTPRequest*)requestWithMethodPUT:(NSString*)module
                                  path:(NSString*)path
                            parameters:(id)parameters
                       completionBlock:(void (^)(NSDictionary *data))completionBlock
                               failure:(void (^)(XMError *error))failure
                                 queue:(dispatch_queue_t)queue;

- (HTTPRequest*)requestWithMethodDELETE:(NSString*)module
                                    path:(NSString*)path
                              parameters:(id)parameters
                         completionBlock:(void (^)(NSDictionary *data))completionBlock
                                 failure:(void (^)(XMError *error))failure
                                   queue:(dispatch_queue_t)queue;


- (HTTPRequest*)requestWithMethodPOST:(NSString*)module
                                   path:(NSString*)path
                             parameters:(id)parameters
                               fileName:(NSString*)fileName
                               filePath:(NSString*)filePath
                        completionBlock:(void (^)(NSDictionary *data))completionBlock
                                failure:(void (^)(XMError *error))failure
                                  queue:(dispatch_queue_t)queue;

- (HTTPRequest*)requestWithMethodPOST:(NSString*)module
                                   path:(NSString*)path
                             parameters:(id)parameters
                               fileName:(NSString*)fileName
                               filePathArray:(NSArray*)filePathArray
                        completionBlock:(void (^)(NSDictionary *data))completionBlock
                                failure:(void (^)(XMError *error))failure
                                  queue:(dispatch_queue_t)queue;

- (HTTPRequest*)requestWithMethodPOST:(NSString*)module
                                 path:(NSString*)path
                           parameters:(id)parameters
                             fileName:(NSString*)fileName
                        filePathArray:(NSArray*)filePathArray
            constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))constructingFormData
                      completionBlock:(void (^)(NSDictionary *data))completionBlock
                              failure:(void (^)(XMError *error))failure
                                queue:(dispatch_queue_t)queue;

- (HTTPRequest*)addRequest:(HTTPRequest*)request;

@end

@interface HTTPRequest : NSObject

- (void)cancel;
- (BOOL)isFinished;
- (BOOL)isRunning;

@end


@interface NSMutableDictionary (NetoworkResponseData)

- (NSInteger)code;
- (NSString*)msg;
- (NSDictionary*)data;

@end

@interface NSDictionary (NetoworkResponseData)

- (NSInteger)code;
- (NSString*)msg;
- (NSDictionary*)data;

@end


//
extern NSString *const kTokenDidExpireNotification;


