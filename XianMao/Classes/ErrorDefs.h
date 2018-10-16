//
//  ErrorDefs.h
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#ifndef ErrorDefs_h_
#define ErrorDefs_h_

#define XM_RESULT_IS_SUCCESS(errCode) (errCode==XMSuccess?YES:NO)
#define XM_ERROR_MESSAGE(errCode) FormatErrorMessage(errCode)


#if !defined(XM_ERROR_MESSAGE_DEFINE)
#  define XM_ERROR_MESSAGE_DEFINE(T,errCode,errMsg) T=errCode,
#  define XM_ERROR_DEFINE_ENUM_BEGIN enum  {
#  define XM_ERROR_DEFINE_ENUM_END };
#else
#  define XM_ERROR_DEFINE_ENUM_BEGIN
#  define XM_ERROR_DEFINE_ENUM_END
#endif

XM_ERROR_DEFINE_ENUM_BEGIN

    XM_ERROR_MESSAGE_DEFINE(XMSuccess, 0, @"本次操作成功")
    
    XM_ERROR_MESSAGE_DEFINE(XMRequestFailedNotFound, 404, @"Request failed: not found (404)")
    
    //local //@"返回数据序列化错误"
    XM_ERROR_MESSAGE_DEFINE(XMNetworkError, 1000, @"网络错误")
    XM_ERROR_MESSAGE_DEFINE(XMResponseSerializationError, 1001, @"服务器找不到客户端了！") //@"返回数据序列化错误"
    XM_ERROR_MESSAGE_DEFINE(XMSeverDataListLogicExceptionError, 1002, @"服务器返回数据异常")
    
    //server
//    XM_ERROR_MESSAGE_DEFINE(XMUserNotFoundError, 40000, @"用户不存在")
//    XM_ERROR_MESSAGE_DEFINE(XMPhoneHasBeenRegedError, 40001, @"手机号已注册")
//    XM_ERROR_MESSAGE_DEFINE(XMCaptchaCodeInvalidError, 40002, @"验证码不正确")
//    XM_ERROR_MESSAGE_DEFINE(XMPasswordInvalidError, 40003, @"密码错误")
    XM_ERROR_MESSAGE_DEFINE(XMTokenInvalidError, 40004, @"请重新登录") //@"token实效"
//    XM_ERROR_MESSAGE_DEFINE(XMCaptchaCodeTimeoutError, 40005, @"验证码失效")
//    XM_ERROR_MESSAGE_DEFINE(XMUserNameAlreayExistError, 40006, @"⽤户名已存在")
//
//    XM_ERROR_MESSAGE_DEFINE(XMCurStatusCanNotBeDeletedError, 40010, @"状态已不允许被删除")
//    XM_ERROR_MESSAGE_DEFINE(XMGoodsStatusChangedError, 40011, @"商品状态已改变")
//    
//    XM_ERROR_MESSAGE_DEFINE(XMOrderGoodsLockedError, 40012, @"商品已被锁定")
//    XM_ERROR_MESSAGE_DEFINE(XMOrderGoodsAlreadySoldError, 40014, @"商品已卖出")
//    XM_ERROR_MESSAGE_DEFINE(XMOrderGoodsOffShelveError, 40013, @"商品已下架")
//    XM_ERROR_MESSAGE_DEFINE(XMOrderGoodsPriceChangedError, 40017, @"价格信息发生变动")

    //1: 商品已被锁定，返回错误码和异常商品列表 code: 40012
    //2: 商品已卖出   code: 40014
    //3 :商品已下架  code : 40013
    //4:价格信息发生变动，返回错误码（价格发生变动）和发生价格变动的goods_list  code : 40017

   // XM_ERROR_MESSAGE_DEFINE(XMSeverExceptionOcurredError, 50000, @"服务器异常")

XM_ERROR_DEFINE_ENUM_END


#endif//ErrorDefs_h_





