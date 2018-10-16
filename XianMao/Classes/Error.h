//
//  XMError.h
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ErrorDefs.h"

typedef NSInteger XMErrorType;

@interface XMError : NSObject

@property(nonatomic,assign) XMErrorType errorCode;
@property(nonatomic,copy) NSString *errorMsg;
@property(nonatomic,strong) id responseObject;


+ (instancetype)errorWithCode:(XMErrorType)errorCode;

+ (instancetype)errorWithCode:(XMErrorType)errorCode
                       errorMsg:(NSString *)errorMsg;

+ (instancetype)errorWithCode:(XMErrorType)errorCode
                     errorMsg:(NSString *)errorMsg
               responseObject:(id)responseObject;

+ (instancetype)errorWithNSError:(NSError *)error;

@end


extern NSString *FormatErrorMessage(NSInteger errCode);
