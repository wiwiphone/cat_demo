//
//  XMNetworkManager.h
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMError;
///============================================================
@protocol XMNetworkManagerDelegateBase <NSObject>
@optional

@end


///============================================================

@protocol XMNetworkManagerDelegate;
@protocol XMNetworkManagerBase <NSObject>
@required

- (void)addDelegate:(id<XMNetworkManagerDelegate>)delegate delegateQueue:(dispatch_queue_t)queue;
- (void)removeDelegate:(id<XMNetworkManagerDelegate>)delegate;

@end

///============================================================

@protocol XMNetworkManagerLoginDelegate <XMNetworkManagerDelegateBase>

@optional

- (void)didLoginWithInfo:(NSDictionary *)loginInfo error:(XMError*)error;
- (void)didLogoutWithError:(XMError*)error;
- (void)didRegisterNewAccount:(NSString *)username password:(NSString *)password error:(XMError *)error;

@end

@protocol XMNetworkManagerLogin <XMNetworkManagerBase>
@required

- (void)getAuthCode:(NSString *)phoneNumber
         completion:(void (^)(XMError *error))completion
              queue:(dispatch_queue_t)queue;

- (void)registerNewAccount:(NSString *)username
                  password:(NSString *)password
               phoneNumber:(NSString *)phoneNumber
                completion:(void (^)(NSString *username,
                                     NSString *password,
                                     XMError *error))completion
                     queue:(dispatch_queue_t)queue;

- (void)login:(NSString *)username
     password:(NSString *)password
   completion:(void (^)(NSDictionary *loginInfo, XMError *error))completion
        queue:(dispatch_queue_t)queue;

- (void)logout:(void (^)(NSDictionary *info, XMError *error))completion
         queue:(dispatch_queue_t)queue;


- (void)resetPassword;
- (void)modifyPhoneNumber;

@end


//登陆注册
//用户

@protocol XMNetworkManagerUser <XMNetworkManagerBase>
@required

- (void)setAvatar:(NSString*)userId avatar:(UIImage*)avatar;
- (void)setFrontImage:(NSString*)userId front:(UIImage*)front;
- (void)setProfile:(NSString*)userId;

- (void)getUserAddressList:(NSString*)userId;
- (void)addUserAddress:(NSString*)userId;
- (void)modidfyUserAddress:(NSString*)userId isDefaultAddress:(BOOL)isDefaultAddress;

- (void)getUserInfo:(NSString*)userId;

- (void)getUserFollowings:(NSString*)userId;
- (void)getUserFollowers:(NSString*)userId;

- (void)followUser:(NSString*)userId;


//提现到支付宝

@end

@protocol XMNetworkManagerGoods <XMNetworkManagerBase>
@required

- (void)getGoodsDetail:(NSString*)goodsId;
- (void)getGoodsLikedUsers:(NSString*)goodsId;

- (void)getOnSaleGoodsByUserId:(NSString*)userId;
- (void)getBoughtGoodsByUserId:(NSString*)userId;
- (void)getSoldGoodsByUserId:(NSString*)userId;
- (void)getLikedGoodsByUserId:(NSString*)userId;

- (void)likeGoods:(NSArray*)goodsIds liked:(BOOL)liked;
- (void)reportSharedGoods:(NSString*)goodsId;

- (void)modifyGoodsInfo:(NSString*)goodsId dict:(NSDictionary*)dict;


//我的里面：（是不是得改下，类似淘宝的？待上架，在售，）
//获取宝贝详情
//编辑宝贝（一次性提交）
//喜欢，删除喜欢（这个可否改为收藏，参考下淘宝）
//卖家：修改，上架，下架，
//买家：加入购物车，从购物车删除，付款
//增加评论，获取宝贝的评论

@end


@protocol XMNetworkManagerShoppingCart <XMNetworkManagerBase>
@required

//加入购物车,从购物车删除，获取购物车中的宝贝
- (void)addToShoppingCart:(NSString*)shoppingCartId goodsIds:(NSArray*)goodsIds;
- (void)removeFromShoppingCart:(NSString*)shoppingCartId goodsIds:(NSArray*)goodsIds;
- (void)getShoppingCartGoods:(NSString*)shoppingCartId;
- (void)pay; //对购物车中的宝贝进行付款，如果有实效商品返回。

@end


@protocol XMNetworkManagerComment <XMNetworkManagerBase>
@required

- (void)addComment:(NSString*)content goodsId:(NSString*)goodsId;
- (void)removeComment:(NSString*)commentId;
- (void)getCommentsByGoodsId:(NSString*)goodsId;
- (void)getCommentsByUserId:(NSString*)userId;

@end


@protocol XMNetworkManagerOrder <XMNetworkManagerBase>
@required

//延长收货（？），查看物流，确认收货，提醒发货
//申请退货。。。。。

- (void)getOrderDetail:(NSString*)orderId;


@end

@protocol XMNetworkManagerSale <XMNetworkManagerBase>
@required

- (void)bookingSaleOrder:(NSString*)address;
- (void)getSaleOrderDetail:(NSString*)saleOrderId;

@end


@protocol XMNetworkManagerPlatform <XMNetworkManagerBase>
@required

- (void)getFeedsByUserId:(NSString*)userId;
- (void)getNoticesByUserId:(NSString*)userId;

- (void)getCategoryList;
- (void)getGoodsByCategory;

- (void)getExplorePageData;
- (void)getGoodsByExploreTag;

- (void)getLatestVersion;

- (void)chatToUser:(NSString*)userId;

@end

///============================================================

@protocol XMNetworkManagerDelegate <XMNetworkManagerLoginDelegate>
@optional

@end


///============================================================

@interface XMNetworkManager : NSObject <XMNetworkManagerLogin>

+ (XMNetworkManager*)sharedInstance;

- (BOOL)isReachable;
- (BOOL)isReachableViaWiFi;

@property (nonatomic, strong, readonly) NSDictionary *loginInfo;
@property (nonatomic, readonly) BOOL isLoggedIn;

@end




