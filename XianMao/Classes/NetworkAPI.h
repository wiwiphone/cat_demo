//
//  NetworkAPI.h
//  XianMao
//
//  Created by simon on 11/26/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "NetworkManager.h"
#import "WXApi.h"
#import "PayZhaoHangReg.h"
#import "AccountCard.h"
#import "ShoppingCartItem.h"

@class UserDetailInfo;
@class User;
@class Error;
@class Wallet;

///===================================================================================
@protocol NetworkAPIBase <NSObject>
@required
@end

///===================================================================================
typedef enum : NSInteger {
    CaptchaTypeRegistry = 1,
    CaptchaTypeResetPassword = 2,
    CaptchaTypeWithdrawCash = 3,
    CaptchaTypeBindPhone = 4,
    CaptchaTypeAddBank = 5,
    CaptchaTypeModifyBank = 6,
    CaptchaTypeVerifyPhoneNum = 7,
    CaptchaTypeAddAlipy = 8,
    CaptchaTypeAlterPhoneNum = 11,
} CaptchaType;

@protocol NetworkAPIAuthorize <NetworkAPIBase>

- (void)downloadSkinIconCompletion:(void (^)(NSMutableArray *data))completion failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getCaptchaCode:(NSString *)phoneNumber
                          type:(CaptchaType)type
                    completion:(void (^)())completion
                       failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)addAndupdateBank:(NSDictionary *)parameters
                      completion:(void (^)())completion
                         failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)addPpdateAlipay:(NSDictionary *)parameters
                     completion:(void (^)())completion
                        failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getCaptchaCodeEncrypt:(NSString *)phoneNumber
                                 type:(CaptchaType)type
                             sms_type:(NSInteger)sms_type
                           completion:(void (^)())completion
                              failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)verifyCaptchaCode:(NSString *)phoneNumber
                      captchaCode:(NSString *)captchaCode
                             type:(NSInteger)type
                       completion:(void (^)())completion
                          failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)registerNewAccount:(NSString *)phoneNumber
                       captchaCode:(NSString *)captchaCode
                          userName:(NSString*)userName
                          password:(NSString *)password
                    avatarFilePath:(NSString*)avatarFilePath
                    invitationCode:(NSString *)invitationCode
                        completion:(void (^)(NSDictionary *data))completion
                           failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)registerNewAccount:(NSString *)phoneNumber
                       captchaCode:(NSString *)captchaCode
                          userName:(NSString*)userName
                          password:(NSString *)password
                        completion:(void (^)(NSDictionary *data))completion
                           failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)login:(NSString *)phoneNumber
             password:(NSString *)password
           completion:(void (^)(NSDictionary *data))completion
              failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)resetPassword:(NSString *)phoneNumber
                     password:(NSString *)password
                     authcode:(NSString *)authCode
                   completion:(void (^)())completion
                      failure:(void (^)(XMError *error))failure;



- (HTTPRequest*)logout:(void (^)())completion
               failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)logout:(void (^)())completion
               failure:(void (^)(XMError *error))failure;

@end

@protocol NetworkAPIChat <NetworkAPIBase>

- (HTTPRequest*)getEMAccounts:(NSArray*)userIds
                   completion:(void (^)(NSArray* accountDicts))completion
                      failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)chatBalance:(NSString*)goodsId
                 completion:(void (^)(NSDictionary* accountDict))completion
                    failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getchatTabReplylist:(NSInteger)adviserid
                 completion:(void (^)(NSArray* replyTablist))completion
                    failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getchatReplydetail:(NSInteger)tabid
                         completion:(void (^)(NSDictionary* data))completion
                            failure:(void (^)(XMError *error))failure;

@end

///===================================================================================

@protocol NetworkAPIUser <NetworkAPIBase>

- (HTTPRequest*)WithdrawPasswrd:(NSString *)password
                     completion:(void (^)(NSDictionary* data))completion
                        failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)withdrawDeposit:(NSDictionary *)parameters
                     completion:(void (^)())completion
                        failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getUserInfo:(NSInteger)userId
                 completion:(void (^)(User *user))completion
                    failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getUserDetail:(NSInteger)userId
                   completion:(void (^)(UserDetailInfo *userDetailInfo))completion
                      failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)setAvatar:(NSString*)filePath
               completion:(void (^)(NSString *avatarUrl))completion
                  failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)setFrontImage:(NSString*)filePath
                   completion:(void (^)(NSString *frontUrl))completion
                      failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)setProfile:(NSDictionary*)parameters
                completion:(void (^)(NSDictionary *dict))completion
                   failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)setUserName:(NSString*)newUserName
                completion:(void (^)())completion
                   failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)bindingWecat:(NSString*)wecatId
                  completion:(void (^)(NSDictionary *dict))completion
                     failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)setGender:(NSInteger)gender
                 completion:(void (^)(NSDictionary *dict))completion
                    failure:(void (^)(XMError *error))failure;//1 男 2女 0未知
- (HTTPRequest*)setBirthday:(long long)birthday
                 completion:(void (^)(NSDictionary *dict))completion
                    failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)setSummary:(NSString*)summary
                completion:(void (^)(NSDictionary *dict))completion
                   failure:(void (^)(XMError *error))failure;
- (void)setGallery:(NSArray*)gallery
                completion:(void (^)())completion
                   failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getWallet:(void (^)(Wallet *wallet))completion
                  failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)withdraw:(NSString*)account
             accountName:(NSString*)accountName
                    type:(NSInteger)type
                  amount:(NSString*)amount
                authCode:(NSString*)authCode
              completion:(void (^)(NSInteger result, NSString *message, Wallet *wallet))completion
                 failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getMsgCount:(void (^)(NSDictionary* data))completion
                    failure:(void (^)(XMError *error))failure
                      queue:(dispatch_queue_t)queue;

- (HTTPRequest*)getNoticeCount:(void (^)(NSDictionary* data))completion
                       failure:(void (^)(XMError *error))failure
                         queue:(dispatch_queue_t)queue;

@end

@class AddressInfo;
@protocol NetworkAPIAddress <NetworkAPIBase>

- (HTTPRequest*)getUserAddressList:(NSInteger)userId
                        completion:(void (^)(NSArray *addressDictList))completion
                           failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)getUserAddressList:(NSInteger)userId
                              type:(NSInteger)type
                        completion:(void (^)(NSArray *addressDictList))completion
                           failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)addUserAddress:(NSInteger)userId
                   addressInfo:(AddressInfo*)addressInfo
                    completion:(void (^)(NSInteger totalNum, AddressInfo *addedAddressInfo))completion
                       failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)addUserAddress:(NSInteger)userId
                          type:(NSInteger)type
                   addressInfo:(AddressInfo*)addressInfo
                    completion:(void (^)(NSInteger totalNum, AddressInfo *addedAddressInfo))completion
                       failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)modifyUserAddress:(NSInteger)userId
                      addressInfo:(AddressInfo*)addressInfo
                       completion:(void (^)())completion
                          failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)modifyUserAddress:(NSInteger)userId
                             type:(NSInteger)type
                      addressInfo:(AddressInfo*)addressInfo
                       completion:(void (^)())completion
                          failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)delUserAddress:(NSInteger)userId
                     addressId:(NSInteger)addressId
                    completion:(void (^)())completion
                       failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)delUserAddress:(NSInteger)userId
                          type:(NSInteger)type
                     addressId:(NSInteger)addressId
                    completion:(void (^)())completion
                       failure:(void (^)(XMError *error))failure;
@end

@class AddressInfo;
@protocol NetworkAPIConsignment <NetworkAPIBase>

- (HTTPRequest*)applyOrder:(NSArray*)fullPathArray
                completion:(void (^)(NSInteger totalNum))completion
                   failure:(void (^)(XMError *error))failure;;

- (HTTPRequest*)getConsignOrders:(NSUInteger)userId
                      completion:(void (^)(NSArray *orderDictList))completion
                         failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)requestConsignment:(NSUInteger)userId
                           cateIds:(NSArray*)cateIds
                       addressInfo:(AddressInfo*)addressInfo
                        completion:(void (^)(NSInteger totalOrdersNum))completion
                           failure:(void (^)(XMError *error))failure;
@end

@class ShoppingCartItem;
@protocol NetworkAPIShoppingCart <NetworkAPIBase>

- (HTTPRequest*)addToShoppingCart:(NSString*)goodsId
                       completion:(void (^)(NSInteger totalNum, ShoppingCartItem* addedItem))completion
                          failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)getShoppingCartGoods:(void (^)(NSArray* itemList))completion
                             failure:(void (^)(XMError *error))failure;
- (HTTPRequest*)removeFromShoppingCart:(NSArray*)goodsIds
                            completion:(void (^)(NSInteger totalNum))completion
                               failure:(void (^)(XMError *error))failure;
@end

@protocol NetworkAPIFolow <NetworkAPIBase>

- (HTTPRequest*)followUser:(NSInteger)followingUserId
                  isFollow:(BOOL)isFollow
                completion:(void (^)(NSInteger totalNum))completion
                   failure:(void (^)(XMError *error))failure;

@end

@protocol NetworkAPIBrand <NetworkAPIBase>

- (HTTPRequest*)getBrandRedirectList:(void (^)(NSDictionary *data))completion
                             failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getBrandList:(NSInteger)cateId
                  completion:(void (^)(NSDictionary *data))completion
                     failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getRecoverGoodsDetail:(NSString *)goods_sn
                           completion:(void (^)(NSDictionary *dict))completion
                              failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getRecommenUser:(NSString *)goods_sn
                     completion:(void (^)(NSDictionary *data))completion
                        failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getBidPage:(NSString *)goods_sn
                completion:(void (^)(NSDictionary *data))completion
                   failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getBidDetail:(NSString *)goods_sn
                  completion:(void (^)(NSDictionary *data))completion
                     failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getBid:(NSString *)goods_sn andbid_price:(CGFloat)bid_price
            completion:(void (^)(NSDictionary *data))completion
               failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getAuthBid:(NSString *)goods_sn andUserID:(NSInteger)userid
                completion:(void (^)(NSDictionary *data))completion
                   failure:(void (^)(XMError *error))failure;
@end

@class GoodsPublishResultInfo;
@class GoodsEditableInfo;
@class GoodsDetailInfo;

@protocol NetworkAPIGoods <NetworkAPIBase>

- (HTTPRequest*)getGoodsDetail:(NSString*)goodsId
                    completion:(void (^)(GoodsDetailInfo *goodsInfo))completion
                       failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)likeGoods:(NSString*)goodsId
                   isLike:(BOOL)isLike
               completion:(void (^)(NSInteger likeNum, User *likedUser))completion
                  failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)reportGoodsShared:(NSString*)goodsId
                       completion:(void (^)(NSInteger shareNum))completion
                          failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)tryOffsale:(NSString*)goodsId
                completion:(void (^)(NSInteger result, NSString *message))completion
                   failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)apllyOffsale:(NSString*)goodsId
             completion:(void (^)())completion
                failure:(void (^)(XMError *error))failure;


- (HTTPRequest*)queryGoodsStatus:(NSArray*)goodsIds
                      completion:(void (^)(NSArray *goodsStatusArray))completion
                         failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)publishGoods:(GoodsEditableInfo*)editableInfo
                publish_type:(NSInteger )publish_type
                  completion:(void (^)(GoodsPublishResultInfo *resultInfo))completion
                     failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getEditableInfo:(NSString*)goodsId
                           type:(NSInteger)type
                     completion:(void (^)(NSDictionary *editableInfoDict))completion
                        failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getGoodsPublish:(void (^)(NSDictionary *data))completion
                        failure:(void (^)(XMError *error))failure;

- (HTTPRequest *)getGlobalSeekDetail:(void (^)(NSDictionary *data))completion
                             failure:(void (^)(XMError *error))failure;

@end

@protocol NetworkAPICategory <NetworkAPIBase>

- (HTTPRequest*)getCateList:(void (^)(NSDictionary *data))completion
                    failure:(void (^)(XMError *error))failure;

@end

typedef enum : NSInteger {
    PayWayAlipay = 0,
    PayWayWxpay = 1,
    PayWayUpay = 2,
    PayWayOffline = 100,
    PayWayFenQiLe = 50,
    PayWayZhaoH = 3,
    PayWayAdmMoney = 10,
    PayWayPartial = 20,
    PayWayTransfer = 15,
} PayWayType;

@protocol NetworkAPITrade <NetworkAPIBase>


- (HTTPRequest*)followUsers:(NSInteger)followingUserId
                   isFollow:(BOOL)isFollow
                 completion:(void (^)(User *user))completion
                    failure:(void (^)(XMError *error))failure;

+ (NSDictionary*) addOrderGoodsListItemTwo:(NSString*)goodsId
                                  price:(float)price
                              priceCent:(NSInteger)priceCent;

+ (NSDictionary*) addOrderGoodsListItem:(NSString*)goodsId
                                  price:(float)price
                              priceCent:(NSInteger)priceCent
                   receive_service_gift:(NSInteger)receive_service_gift
                       shoppingCartItem:(ShoppingCartItem *)item;

- (HTTPRequest*)payGoods:(NSArray*)goodsList
                 address:(NSInteger)addressId
                 message:(NSString*)message
                  payWay:(PayWayType)payWay
                   bonus:(NSString*)bonusId
             accountCard:(AccountCard *)accoundCard
       is_need_appraisal:(NSInteger)is_need_appraisal
       is_used_adm_money:(BOOL)is_used_adm_money
    is_used_reward_money:(BOOL)is_used_reward_money
          is_partial_pay:(NSInteger)is_partial_pay
      partial_pay_amount:(CGFloat )partial_pay_amount
              completion:(void (^)(NSString *payUrl,PayReq *payReq,NSString *upPayTn, PayZhaoHangReg *payZHReg))completion
                 failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)payOrder:(NSString*)orderId
                  payWay:(PayWayType)payWay
              completion:(void (^)(NSString *payUrl,PayReq *payReq,NSString *upPayTn))completion
                 failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)payOrderList:(NSArray*)orderIds
                      payWay:(PayWayType)payWay
                       bonus:(NSString*)bonusId
                 accountCard:(AccountCard *)accountCard
                  deterIndex:(NSInteger)deterIndex
        is_used_reward_money:(BOOL)is_used_reward_money
           is_used_adm_money:(BOOL)is_used_adm_money
              is_partial_pay:(NSInteger)is_partial_pay
          partial_pay_amount:(CGFloat )partial_pay_amount
                  completion:(void (^)(NSString *payUrl,PayReq *payReq,NSString *upPayTn, PayZhaoHangReg *payZHReg))completion
                     failure:(void (^)(XMError *error))failure ;

- (HTTPRequest*)getOrderDetail:(NSString*)orderId
                    completion:(void (^)(NSDictionary *data))completion
                       failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)getOrderDetailList:(NSArray*)orderIds
                        completion:(void (^)(NSArray *orderDetails))completion
                           failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)tryDelayReceipt:(NSString*)orderId
                     completion:(void (^)(NSInteger result, NSString *message))completion
                        failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)delayReceipt:(NSString*)orderId
                  completion:(void (^)(NSInteger delayDays))completion
                     failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)confirmReceived:(NSString*)orderId
                     completion:(void (^)(NSDictionary *statusInfo))completion
                        failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)logistics:(NSString*)orderId
               completion:(void (^)(NSString *html5Url))completion
                  failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)shareGoodsWith:(NSString*)goodsId
                    completion:(void (^)(int statusInfo))completion
                       failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)deleteConsignGoods:(NSInteger)consignId
                    completion:(void (^)())completion
                           failure:(void (^)(XMError *error))failure;

//trade/delay  [POST]  参数：order_id

@end

@protocol NetworkAPIBonus <NetworkAPIBase>

- (HTTPRequest*)listAvailableBonusByOrderList:(NSArray*)orderIds
                                   completion:(void (^)(NSArray *itemList))completion
                                      failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)listXiHuCardByOrderList:(NSArray*)orderIds
                                bonusId:(NSString *)bonusId
                       isUseRewardMoney:(NSInteger)isUseRewardMoney
                             completion:(void (^)(NSArray *itemList))completion
                                failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)listAvailableBonusByGoodsList:(NSArray*)goodsIds
                                   completion:(void (^)(NSArray *itemList))completion
                                      failure:(void (^)(XMError *error))failure;

- (HTTPRequest*)listXiHuCardByGoodsList:(NSArray*)goodsIds
                                brandId:(NSString *)bonusId
                       isUseRewardMoney:(NSInteger)isUseRewardMoney
                             completion:(void (^)(NSArray *itemList))completion
                                failure:(void (^)(XMError *error))failure;
@end

///===================================================================================

@protocol NetworkAPIFile <NSObject>

- (void)updaloadPics:(NSArray*)picFilePaths
          completion:(void (^)(NSArray *picUrlArray))completion
             failure:(void (^)(XMError *error))failure;
@end

@protocol NetworkAPIPlatform <NetworkAPIBase>
@required

- (HTTPRequest*)checkUpdate:(NSString*)version
         completion:(void (^)(NSDictionary *versionInfo))completion
            failure:(void (^)(XMError *error))failure;

- (void)statForGoods:(NSString*)goodsId completion:(void (^)())completion
             failure:(void (^)(XMError *error))failure;

@end

@protocol NetworkAPISearch <NetworkAPIBase>

- (HTTPRequest *)getFilterInfoList:(NSString*)keywords
                            params:(NSString*)params
                          sellerId:(NSInteger)sellerId
                        completion:(void (^)(NSInteger totalNum, NSString *queryKey, NSString *standardWords, NSArray *filterInfoArray,long long timestamp))completion
                           failure:(void (^)(XMError *error))failure;

///search/hot_words
- (HTTPRequest*)getHotWords:(void (^)(NSDictionary *data))completion
                    failure:(void (^)(XMError *error))failure;

@end

@protocol NetworkAPIAssess <NetworkAPIBase>

- (HTTPRequest *)getEvaluationPrice:(NSArray *)picUrl
                           category:(NSInteger)category
                         completion:(void(^)(NSDictionary *data))completion
                            failure:(void (^)(XMError *error))failure;

@end

///===================================================================================

@interface NetworkAPI : NSObject <NetworkAPIAuthorize,
       NetworkAPIUser,
       NetworkAPIChat,
       NetworkAPIAddress,
       NetworkAPIConsignment,
       NetworkAPIShoppingCart,
       NetworkAPIFolow,
       NetworkAPIBrand,
       NetworkAPIGoods,
       NetworkAPICategory,
       NetworkAPITrade,
       NetworkAPIBonus,
       NetworkAPIFile,
       NetworkAPIPlatform,
       NetworkAPISearch,
       NetworkAPIAssess
     >

+ (NetworkAPI*)sharedInstance;


@end


//[]

/*
 
 */


/*
 
 {id, user_id, operation[0新增,1修改,2，删除], type, id_value -> primary key}
 
 12, goods_id:108， 2  { goods_info:..... } []
 11, goods_id:108， 1  { goods_info:..... }
 10, goods_id:108， 0  { goods_info:..... }
 
 //1.新增宝贝｛上架｝
 //2.修改宝贝｛价格，描述，置顶｝
 //3.删除宝贝｛下架,售出｝
 
 
 */





