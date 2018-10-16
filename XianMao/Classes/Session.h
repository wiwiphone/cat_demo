//
//  Session.h
//  XianMao
//
//  Created by simon on 11/24/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Error.h"
#import "NetworkManager.h"
#import "User.h"
#import "AddressInfo.h"
#import "RecoveryGoodsVo.h"
#import "HighestBidVo.h"
#import "RedirectInfo.h"
#import "AdviserPage.h"
#import "GoodsEditableInfo.h"

@class ShoppingCartItem;
@class User;
@class EMAccount;
@class MsgCount;
@class AddressInfo;
@class GoodsInfo;
@class SendSaleVo;

///===================================================================================

@interface Session : MBDefaultMessageReceiver

@property (nonatomic, assign) NSInteger viewCode;
-(void)client:(NSInteger)resionCode data:(NSDictionary *)data;

+ (Session*)sharedInstance;

- (void)initialize;

@property (nonatomic, strong) EMAccount *emKEFUAccount;
@property(nonatomic,copy,readonly) NSString *token;
@property(nonatomic,readonly) BOOL isLoggedIn;
@property(nonatomic,readonly) BOOL isBindingPhoneNumber;
@property(nonatomic,readonly) User *currentUser;
@property(nonatomic,readonly) EMAccount *emAccount;
@property(nonatomic,readonly) NSUInteger currentUserId;

@property(nonatomic,readonly) NSInteger consignOrdersNum;

@property(nonatomic,readonly) NSInteger shoppingCartNum;
@property(nonatomic,readonly) NSArray*  shoppingCartItems;

@property(nonatomic,readonly) NSString *debugServerUrl;

@property(nonatomic,readonly) BOOL modify_username_enable;

//埋点
//名称	   viewCode	    regionCode	  data
//搜索	    10000	    10010	   搜索关键词
//购物车	    10000	    10020
//商品池	    10000	    10030	   商品goodsid
//精选关注	50000	    10101	   商品goodsid,卖家的ID
//精选分享	60000	    10102	   商品goodsid,分享的渠道如微信,微博等
//精选图片详情	10000	    10103	   商品goodsid
//精选商品详情	10000	    10104	   商品goodsid
//精选点赞	10000	    10105	   商品goodsid
//首页	    10000	    10001
//喵窝	    20000	    20001
//发布商品	30000	    30001
//消息	    40000	    40001
//我的	    80000	    80001
//精选	    50000	    50101
//我的关注	70000	    70101


-(NSString *)getFMDeviceBlackBox;

-(void)clientReport:(RedirectInfo *)redirectInfo data:(NSDictionary *)data;

- (void)bindingPhone:(NSString*)phoneNumber;
- (void)setRegisterInfo:(NSString*)phoneNumber data:(NSDictionary*)data;
- (void)setLoginInfo:(NSString*)phoneNumber data:(NSDictionary*)data;
- (void)setLogoutState;

- (void)setConsignOrdersNum:(NSInteger)count;

- (void)setShoppingCartGoods:(NSInteger)totalNum addedItem:(ShoppingCartItem*)addedItem;
- (void)setShoppingCartGoods:(NSInteger)totalNum removedGoodsIds:(NSArray*)removedGoodsIds;
- (void)setShoppingCartItems:(NSArray*)items;
- (BOOL)isExistInShoppingCart:(NSString*)goodsId;

- (void)setUserInfo:(User*)userInfo;
- (void)setUserLikesNum:(NSInteger)likesNum;
- (void)setUserFollowingsNum:(NSInteger)followingsNum;
- (void)setFansNum:(NSInteger)fansNum;
- (void)setUserAvatar:(NSString*)avatarUrl;
- (void)setUserFront:(NSString*)frontUrl;
- (void)setUserUserName:(NSString*)userName;
- (void)setUserGender:(NSInteger)gender;
- (void)setUserBirthday:(long long)birthday;
- (void)setUserSummary:(NSString*)summary;
- (void)setUserEMAccount:(EMAccount*)emAccount;
- (void)setUserKEFUEMAccount:(EMAccount*)emAccount;
- (BOOL)setUserCount:(MsgCount*)msgCount;
- (void)setUserweixinId:(NSString *)weixinId;
- (void)setDebugServerUrl:(NSString *)debugServerUrl;
- (void)reloadSendSaleData:(SendSaleVo *)sendVo;
-(void)setSkinIcon:(NSDictionary *)skinIcon;
- (NSDictionary *)loadSkinIconData;

- (AddressInfo*)defaultUserAddress;
- (void)savePublishGoodsToDraft:(GoodsEditableInfo *)editableInfo;
- (GoodsEditableInfo *)loadPublishGoodsFromDraft;
- (void)syncAliasPushIdToUMessage;

- (BOOL)isNeedShowRedPoint;
@end


///===================================================================================

@protocol AuthorizeChangedReceiver <NSObject>

@optional
- (void)$$handleRegisterDidFinishNotification:(id<MBNotification>)notifi;
- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi;
- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi;
- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi;
- (void)$$handleBindinghoneDidFinishNotification:(id<MBNotification>)notifi;
@end

///===================================================================================

@protocol ConsignOrdersChangedReceiver <NSObject>

@optional

- (void)$$handleConsignOrdersNumChangedNotification:(id<MBNotification>)notifi;
- (void)$$handleConsignDidFinishNotification:(id<MBNotification>)notifi ordersNum:(NSInteger)ordersNum;
- (void)$$handleConsignContinueNotification:(id<MBNotification>)notifi;
- (void)$$handleConsignCloseNotification:(id<MBNotification>)notifi;

@end

extern void MBGlobalSendConsignDidFinishNotification(NSInteger ordersNum);
extern void MBGlobalSendConsignContinueNotification();
extern void MBGlobalSendConsignContinueNotification();
extern void MBGlobalSendConsignCloseNotification();

///===================================================================================

@protocol ShoppingCartGoodChangedReceiver <NSObject>

@optional

- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi addedItem:(ShoppingCartItem*)item;
- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi removedGoodsIds:(NSArray*)goodsIds;
- (void)$$handleShoppingCartSyncFinishedNotification:(id<MBNotification>)notifi;
@end

extern void MBGlobalShoppingCartGoodsAddedNotification(ShoppingCartItem* item);
extern void MBGlobalShoppingCartGoodsRemovedNotification(NSArray* goodsIds);
extern void MBGlobalShoppingCartSyncFinishedNotification();

///===================================================================================

@protocol UserAddressChangedReceiver <NSObject>

@optional
- (void)$$handleFetchAddressListDidFinishNotification:(id<MBNotification>)notifi addressList:(NSArray*)addressList;
- (void)$$handleUserDefaultAddressChangedNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo;
- (void)$$handleAddAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo;
- (void)$$handleRemoveAddressDidFinishNotification:(id<MBNotification>)notifi addressId:(NSNumber*)addressId;
- (void)$$handleModifyAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo;
@end

void MBGlobalSendFetchAddressListDidFinishNotification(NSArray *addressList);
void MBGlobalSendUserDefaultAddressChangedNotification(AddressInfo *addressInfo);
void MBGlobalSendAddAddressDidFinishNotification(AddressInfo *addressInfo);
void MBGlobalSendRemoveAddressDidFinishNotification(NSInteger addressId);
void MBGlobalSendModifyAddressDidFinishNotification(AddressInfo *addressInfo);

@protocol UserProfileChangedReceiver <NSObject>
@optional
//目前只支持自己的UserProfileChange通知，用户信息还未做缓存
- (void)$$handleUserProfileChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId;
- (void)$$handleUserNameChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId;
- (void)$$handleAvatarChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId;
- (void)$$handleUserFrontChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId;
@end

@protocol UserInfoChangedReceiver <NSObject>
@optional
//目前只支持自己的UserInfoChange通知，用户信息还未做缓存
- (void)$$handleUserInfoChangedNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId;
@end

@protocol UserFollowChangedReceiver <NSObject>
@optional
- (void)$$handleFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId;
- (void)$$handleUnFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId;
@end


void MBGlobalSendUserInfoChangedNotification(NSInteger userId);
void MBGlobalSendAvatarChangedNotification(NSInteger userId);
void MBGlobalSendFollowUserNotification(NSInteger userId);
void MBGlobalSendUnFollowUserNotification(NSInteger userId);

///===================================================================================

@protocol GoodsInfoChangedReceiver <NSObject>
@optional
- (void)$$handleGoodsInfoChanged:(id<MBNotification>)notifi goodsIds:(NSArray*)goodsIds;
- (void)$$handleGoodsInfoUpdated:(id<MBNotification>)notifi goodsInfo:(GoodsInfo*)goodsInfo;
- (void)$$handleGoodsStatusUpdated:(id<MBNotification>)notifi goodStatusArray:(NSArray*)goodStatusArray;
- (void)$$handleGoodsLiked:(id<MBNotification>)notifi goodsId:(NSString*)goodsId;
- (void)$$handleGoodsUnLiked:(id<MBNotification>)notifi goodsId:(NSString*)goodsId;
- (void)$$handleSendSaleGoodsChangedNotification:(id<MBNotification>)notifi sendSaleVo:(SendSaleVo *)sendVo;
@end

extern void MBGlobalSendGoodsInfoListChangedNotification(NSUInteger key, NSArray* goodsIds);
extern void MBGlobalSendGoodsInfoChangedNotification(NSUInteger key, NSString* goodsId);
extern void MBGlobalSendGoodsInfoUpdatedNotification(GoodsInfo* goodsInfo);
extern void MBGlobalSendGoodsStatusUpdatedNotification(NSArray* goodStatusArray);

///===================================================================================

@protocol MyWebViewImagePickerReciever <NSObject>

@optional
- (void)$$imagePickerFinishNotification:(id<MBNotification>)notifi image:(UIImage *)image;
@end

void MBGlobalSendImagePickerFinishNotification(UIImage *image);

@interface UserSingletonCommand : MBSimpleSingletonCommand

- (void)$$cancelUserCommand:(id<MBNotification>)notification;

+ (void)followUser:(NSInteger)userId;
+ (void)unfollowUser:(NSInteger)userId;
//在线客服
+ (void)chatWithGroup:(EMAccount *)emAccount isShowDownTime:(BOOL)isShow message:(NSString *)msg isKefu:(BOOL)isKefu;
+ (void)chatWithUser:(NSInteger)userId;
+ (void)chatWithGuwen:(NSInteger)userId isGuwen:(BOOL)isGuwen;
+ (void)chatRecoverWithUser:(NSInteger)userId andIsYes:(NSInteger)isYes andGoodsVO:(RecoveryGoodsVo *)goodsVO andBidVO:(HighestBidVo *)bidVO;
+ (void)chatWithUser:(NSInteger)userId msg:(NSString*)msg;
+ (void)chatWithUserFirst:(NSInteger)userId msg:(NSString*)msg;
+ (void)chatWithUserHasWXNum:(NSInteger)userId msg:(NSString*)msg adviser:(AdviserPage *)adviser nadGoodsId:(NSString *)goodsId;
+ (void)chatWithUserFirstHasGoods:(NSInteger)userId msg:(NSString*)msg goodsId:(NSString *)goodsId;
+ (void)chatBalance:(NSString*)goodsId;
+ (void)chatBalanceHasUser:(NSString*)goodsId;
+ (void)chatWithoutGoodsId:(NSString*)goodsId;
+ (void)chatWithUserJimai:(NSInteger)userId msg:(NSString*)msg isJimai:(BOOL)isJimai;

@end

@interface ChatWithUserDO : NSObject
@property(nonatomic,assign) NSInteger userId;
@property(nonatomic,copy) NSString *msg;
@property (nonatomic, assign) NSInteger isYes;
@property (nonatomic, strong) RecoveryGoodsVo *goodsVO;
@property (nonatomic, strong) HighestBidVo *bidVO;
@property (nonatomic, strong) NSString *goodsId;
@property (nonatomic, strong) AdviserPage *adviser;
@property (nonatomic, assign) BOOL isJimai;
@property (nonatomic, assign) BOOL isGuwen;
@property (nonatomic, assign) BOOL isConsultant;
@property (nonatomic, copy) NSString *consultantStr;
@property (nonatomic, strong) EMAccount *emAccount;
@property (nonatomic, copy) NSString *groupName;

@property (nonatomic, assign) BOOL isKefu;
@end


@interface GoodsSingletonCommand : MBSimpleSingletonCommand

- (void)$$touchGoodsLikeButton:(id<MBNotification>)notification goodsId:(NSString *)goodsId;
- (void)$$touchGoodsUnLikeButton:(id<MBNotification>)notification goodsId:(NSString *)goodsId;
- (void)$$cancelGoodsCommand:(id<MBNotification>)notification;

+ (void)likeGoods:(NSString*)goodsId;
+ (void)unlikeGoods:(NSString*)goodsId;

@end


@interface OrderSingletonCommand : MBSimpleSingletonCommand

- (void)$$cancelOrderCommand:(id<MBNotification>)notification;

@end

@interface ConsignSingletonCommand : MBSimpleSingletonCommand

- (void)$$touchConsignButton:(id<MBNotification>)notification filePaths:(NSArray*)filePaths;
- (void)$$cancelConsignCommand:(id<MBNotification>)notification;

@end

@interface ChatSingletonCommand : MBSimpleSingletonCommand

- (void)$$touchChatToUserButton:(id<MBNotification>)notification userId:(NSString*)userId;
- (void)$$cancelChatCommand:(id<MBNotification>)notification;
@end

@interface LogInCommandInterceptor : NSObject <MBCommandInterceptor>

- (void)addCommandClass:(Class)commandClass;
- (void)removeCommandClass:(Class)commandClass;

@end


extern void systemInitCommands();

extern void _$showHUD(NSString* message, CGFloat hideAfterDelay);
extern void _$showProcessingHUD(NSString* message);
extern void _$hideHUD();


