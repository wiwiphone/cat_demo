//
//  XMError.h
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

//
//======================================================================================
//
#define XM_ERROR_MESSAGE_FORMAT_BEGINE(errCode) switch (errCode) {
#define XM_ERROR_MESSAGE_FORMAT_END }
#define XM_ERROR_MESSAGE_DEFINE(T,errCode,errMsg) case errCode: return errMsg;

NSString *FormatErrorMessage(NSInteger errCode) {
    XM_ERROR_MESSAGE_FORMAT_BEGINE(errCode);
#import "ErrorDefs.h"
    XM_ERROR_MESSAGE_FORMAT_END;
    return nil;
}


//
//======================================================================================
//
#import "Error.h"

@implementation XMError

+ (instancetype)errorWithCode:(XMErrorType)errorCode {
    XMError *newError = [[self alloc] init];
    if (newError){
        newError.errorCode = errorCode;
        newError.errorMsg = XM_ERROR_MESSAGE(errorCode);
    }
    return newError;
}

+ (instancetype)errorWithCode:(XMErrorType)errorCode
                     errorMsg:(NSString *)errorMsg {
    XMError *newError = [[self alloc] init];
    if (newError){
        newError.errorCode = errorCode;
        newError.errorMsg = errorMsg;
    }
    return newError;
}

+ (instancetype)errorWithCode:(XMErrorType)errorCode
                     errorMsg:(NSString *)errorMsg
               responseObject:(id)responseObject {
    XMError *newError = [[self alloc] init];
    if (newError){
        newError.errorCode = errorCode;
        newError.errorMsg = errorMsg;
        newError.responseObject = responseObject;
    }
    return newError;
}

+ (instancetype)errorWithNSError:(NSError *)error {
    XMError *newError = [[self alloc] init];
    if (newError){
        newError.errorCode = error.code;
        newError.errorMsg = error.localizedDescription;
    }
    return newError;
}

@end







