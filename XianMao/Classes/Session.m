//
//  Session.m
//  XianMao
//
//  Created by simon on 11/24/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "Session.h"
#import "SynthesizeSingleton.h"
#import "NSMutableArray+WeakReferences.h"
#import "NSDictionary+Additions.h"
#import "AESCrypt.h"

#import "AFNetworking.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "User.h"
#import "EMIMHelper.h"

#import "CoordinatingController.h"
#import "MyNavigationController.h"
#import "LoginViewController.h"

#import "CoordinatingController.h"

#import "GoodsInfo.h"
#import "GoodsMemCache.h"

#import "ShoppingCartItem.h"

#import "AppDirs.h"
#import "SendSaleVo.h"
#import "NSObject+PerformBlock.h"

#import "EMSession.h"

#import "MsgCountManager.h"

#import "AdviserPage.h"
#import "FMDeviceManager.h"

@interface NSLockGuard : NSObject
+ (instancetype)createWithLock:(NSLock*)lock;
@property(nonatomic,strong) NSLock *lock;
@end

@implementation NSLockGuard
+ (instancetype)createWithLock:(NSLock*)lock {
    NSLockGuard *guard = [[self alloc] init];
    guard.lock = lock;
    [guard.lock lock];
    return guard;
}

- (void)dealloc {
    [_lock unlock];
}
@end

@interface Session () <AuthorizeChangedReceiver,UserAddressChangedReceiver>

@property(nonatomic,copy,readwrite) NSString *token;
@property(nonatomic,readwrite) BOOL isLoggedIn;
@property(nonatomic,strong,readwrite) User *user;
@property(nonatomic,strong,readwrite) EMAccount *emAccount;

@property(nonatomic,readwrite) NSInteger consignOrdersNum;

@property(nonatomic,readwrite) NSInteger shoppingCartNum;
@property(nonatomic,strong) NSMutableArray *shoppingCartItemList;

@property(nonatomic,strong) AddressInfo *defaultAddress;


@property(nonatomic,strong) NSTimer *timer;
@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,strong) HTTPRequest *syncShoppingCartRequest;
@property(nonatomic,assign) BOOL needSyncShoppingCart;

@property(nonatomic,strong) HTTPRequest *syncUserInfoRequest;
@property(nonatomic,assign) BOOL needSyncUserInfo;

@property(nonatomic,strong) NSLock *lock;

@property(nonatomic,readwrite) BOOL modify_username_enable;

@end

@implementation Session {
    
}

+ (instancetype)sharedInstance {
    static id sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

-(void)setViewCode:(NSInteger)viewCode{
    _viewCode = viewCode;
}

-(void)client:(NSInteger)resionCode data:(NSDictionary *)data{
    NSLog(@"%ld, %ld", (long)resionCode, (long)self.viewCode);
    if (self.viewCode != 0) {
        [ClientReportObject clientReportObjectWithViewCode:self.viewCode regionCode:resionCode referPageCode:resionCode andData:data];
    }
}

-(void)clientReport:(RedirectInfo *)redirectInfo data:(NSDictionary *)data{
    ClientReport *report = [[ClientReport alloc] init];
    report.viewCode = redirectInfo.viewCode;
    report.regionCode = redirectInfo.regionCode;
    report.referPageCode = redirectInfo.referPageCode;
    if (!data) {
        data = [NSDictionary dictionary];
    }
    //埋点
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] clientReport:report data:data completion:^(NSDictionary *dict) {
        
    } failure:^(XMError *error) {
        
    }]];
}

-(NSString *)getFMDeviceBlackBox{
    // 获取设备管理器实例
    FMDeviceManager_t *manager = [FMDeviceManager sharedManager];
    
    // 获取设备指纹黑盒数据，请确保在应用开启时已经对SDK进行初始化，切勿在get的时候才初始化
    NSString *blackBox = manager->getDeviceInfo();
    return blackBox?blackBox:@"";
}

- (void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleTokenDidExpireNotification:)
                                                 name:kTokenDidExpireNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleReachabilityChanged:)
                                                 name:AFNetworkingReachabilityDidChangeNotification
                                               object:nil];

    
    [[MBGlobalFacade instance] unsubscribeNotification:self];
    [[MBGlobalFacade instance] subscribeNotification:self];
    
    _needSyncShoppingCart = NO;
    _needSyncUserInfo = NO;
    
    _lock = [[NSLock alloc] init];
    
    _token = nil;
    _isLoggedIn = NO;
    _user = nil;
    
    _consignOrdersNum = 0;
    
    _shoppingCartNum = 0;
    _shoppingCartItemList = nil;

    _debugServerUrl = APIBaseURLString;
    
    [self loadAccountData];
    //如果_token不为空假定已登陆
    if (_token && [_token length]>0) {
        _isLoggedIn = YES;
    }
    
    ///
    if (_isLoggedIn) {
        _needSyncUserInfo = YES;
        _needSyncShoppingCart = YES;
        
        NSInteger goodsNum = 0;
        _shoppingCartItemList = [self loadShoppingCartItems:&goodsNum];
        _shoppingCartNum = goodsNum;
        
        [self syncDataFromServer];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.viewCode = 0;
}

- (BOOL)isLoggedIn {
    return _isLoggedIn&&_token&&[_token length]>0&&_user&&_user.userId>0;
}

- (User*)currentUser {
    return _user;
}

- (NSUInteger)currentUserId {
    return _user?_user.userId:0;
}

- (NSArray*)shoppingCartItems {
    return _shoppingCartItemList;
}

- (void)setUserInfoWithDictAndPhoneNumber:(NSDictionary*)data phoneNumber:(NSString*)phoneNumber
{
    [self setUserInfoWithDict:data];
    _user.phoneNumber = phoneNumber;
}

- (void)setUserInfoWithDict:(NSDictionary*)data
{
    _token = [data stringValueForKey:@"token"];
    _shoppingCartNum = [data integerValueForKey:@"cart_goods_num" defaultValue:0];
    _consignOrdersNum = [data integerValueForKey:@"consign_order_num" defaultValue:0];
    
    if ([[data objectForKey:@"emuser"] isKindOfClass:[User class]]) {
        _emAccount = (EMAccount*)[data objectForKey:@"emuser"];
    } else if ([[data objectForKey:@"emuser"] isKindOfClass:[NSDictionary class]]) {
        _emAccount = [EMAccount createWithDict:[data objectForKey:@"emuser"]];
    }

    if ([[data objectForKey:@"user"] isKindOfClass:[User class]]) {
        _user = (User*)[data objectForKey:@"user"];
    } else if ([[data objectForKey:@"user"] isKindOfClass:[NSDictionary class]]) {
        _user = [User createWithDict:[data dictionaryValueForKey:@"user"]];
    }
    
    _modify_username_enable = [data integerValueForKey:@"modify_username_enable" defaultValue:1]>0?YES:NO;
}

#define AESCryptKey @"AbcdEfgHijkLmnOpqRstUvWXYz!23$56&890"

- (void)loadAccountData
{
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:[AppDirs currentAccountCacheFile] isDirectory:&isDirectory]
        && !isDirectory) {
        NSDictionary *dict = [self loadFromCacheFile:@"account" cacheFile:[AppDirs currentAccountCacheFile]];
        if ([dict stringValueForKey:@"token"]) {
            _token = [AESCrypt decrypt:[dict stringValueForKey:@"token"] password:AESCryptKey];
        }
        _user = (User*)[dict objectForKey:@"user"];
        _emAccount = (EMAccount*)[dict objectForKey:@"emuser"];
        _emKEFUAccount = (EMAccount *)[dict objectForKey:@"emkefuAccount"];
        _shoppingCartNum = [dict integerValueForKey:@"cart_goods_num" defaultValue:0];
        _consignOrdersNum = [dict integerValueForKey:@"consign_orders_num" defaultValue:0];
        _modify_username_enable = [dict boolValueForKey:@"modify_username_enable"];
    }
}

- (void)saveAccountData
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSString *token = [AESCrypt encrypt:_token?_token:@"" password:AESCryptKey];
    [dict setObject:token forKey:@"token"];
    [dict setObject:[NSNumber numberWithInteger:_shoppingCartNum] forKey:@"cart_goods_num"]; //别处保存
    [dict setObject:[NSNumber numberWithInteger:_consignOrdersNum] forKey:@"consign_orders_num"];
    if (_user) {
        [dict setObject:_user forKey:@"user"];
    }
    if (_emAccount) {
        [dict setObject:_emAccount forKey:@"emuser"];
    }
    if (_emKEFUAccount) {
        [dict setObject:_emKEFUAccount forKey:@"emkefuAccount"];
    }
    [dict setObject:[NSNumber numberWithBool:_modify_username_enable] forKey:@"modify_username_enable"];
    [self saveToCacheFile:@"account" cacheFile:[AppDirs currentAccountCacheFile] dict:dict];
}

- (NSMutableArray*)loadShoppingCartItems:(NSInteger*)toalNum
{
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:[AppDirs shoppingCartItemsCacheFile] isDirectory:&isDirectory]
        && !isDirectory) {
        NSDictionary *dict = [self loadFromCacheFile:@"shoppingCart" cacheFile:[AppDirs shoppingCartItemsCacheFile]];
        if (toalNum && [dict objectForKey:@"totalNum"]) {
            *toalNum = [dict integerValueForKey:@"totalNum" defaultValue:0];
        }
        return [[NSMutableArray alloc] initWithArray:[dict arrayValueForKey:@"items"]];
    }
    return nil;
}

- (void)saveShoppingCartItems:(NSArray*)items totalNum:(NSInteger)totalNum
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:[NSNumber numberWithInteger:totalNum] forKey:@"totalNum"];
    if (items)
        [dict setObject:items forKey:@"items"];
    [self saveToCacheFile:@"shoppingCart" cacheFile:[AppDirs shoppingCartItemsCacheFile] dict:dict];
}

- (BOOL)isBindingPhoneNumber {
    return _user!=nil&&[_user.phoneNumber length]>0;
}
- (void)bindingPhone:(NSString*)phoneNumber {
    _isLoggedIn = YES;
    _user.phoneNumber = phoneNumber;
    [self saveAccountData];
    
    SEL selector = @selector($$handleBindinghoneDidFinishNotification:);
    MBGlobalSendNotificationForSEL(selector);
}

- (void)setRegisterInfo:(NSString*)phoneNumber data:(NSDictionary*)data
{
    _isLoggedIn = YES;
    _needSyncShoppingCart = NO;
    [self setUserInfoWithDictAndPhoneNumber:data phoneNumber:phoneNumber];
    [self saveAccountData];
    
    SEL selector = @selector($$handleRegisterDidFinishNotification:);
    MBGlobalSendNotificationForSEL(selector);
}

- (void)setLoginInfo:(NSString*)phoneNumber data:(NSDictionary*)data
{
    _isLoggedIn = YES;
    _needSyncShoppingCart = YES;
    
    NSInteger goodsNum = 0;
    _shoppingCartItemList = [self loadShoppingCartItems:&goodsNum];
    _shoppingCartNum = goodsNum;
    
    [self setUserInfoWithDictAndPhoneNumber:data phoneNumber:phoneNumber];
    [self saveAccountData];
    
    SEL selector = @selector($$handleLoginDidFinishNotification:);
    MBGlobalSendNotificationForSEL(selector);
}

- (void)setLogoutState
{
    _isLoggedIn = NO;
    _needSyncShoppingCart = NO;
    _token = nil;
    _emAccount = nil;
    [self saveAccountData];
    
    SEL selector = @selector($$handleLogoutDidFinishNotification:);
    MBGlobalSendNotificationForSEL(selector);
}

- (void)setConsignOrdersNum:(NSInteger)count {
    if (_consignOrdersNum!=count) {
        _consignOrdersNum = count;
    }
    SEL selector = @selector($$handleConsignOrdersNumChangedNotification:);
    MBGlobalSendNotificationForSEL(selector);
}

- (void)setDebugServerUrl:(NSString *)debugServerUrl
{
    _debugServerUrl = debugServerUrl;
}

- (void)setShoppingCartGoods:(NSInteger)totalNum addedItem:(ShoppingCartItem*)addedItem
{
    if (addedItem) {
        
        if (!_shoppingCartItemList)
            _shoppingCartItemList = [[NSMutableArray alloc] init];
        
        [_shoppingCartItemList insertObject:addedItem atIndex:0];
        _shoppingCartNum = totalNum;
        
        if (_shoppingCartNum!=[_shoppingCartItemList count]) {
            _needSyncShoppingCart = YES;
            [self syncSyncShoppingCartFromServer];
        }
        
        [self saveShoppingCartItems:_shoppingCartItemList totalNum:_shoppingCartNum];
        
        MBGlobalShoppingCartGoodsAddedNotification(addedItem);
    }
}

- (void)setShoppingCartGoods:(NSInteger)totalNum removedGoodsIds:(NSArray*)removedGoodsIds
{
    for (NSString *goodsId in removedGoodsIds) {
        for (ShoppingCartItem *item in _shoppingCartItemList) {
            if ([item.goodsId isEqualToString:goodsId]) {
                [_shoppingCartItemList removeObject:item];
                break;
            }
        }
    }
    
    _shoppingCartNum = totalNum;

    if (_shoppingCartNum!=[_shoppingCartItemList count]) {
        _needSyncShoppingCart = YES;
        [self syncSyncShoppingCartFromServer];
    }

    [self saveShoppingCartItems:_shoppingCartItemList totalNum:_shoppingCartNum];
    MBGlobalShoppingCartGoodsRemovedNotification(removedGoodsIds);
}

- (void)setShoppingCartItems:(NSArray*)items
{
    [self performBlockOnMainThread:^{
        _shoppingCartItemList = [[NSMutableArray alloc] initWithArray:items];
        _shoppingCartNum = [items count];
        
        [self saveShoppingCartItems:_shoppingCartItemList totalNum:_shoppingCartNum];
        
        MBGlobalShoppingCartSyncFinishedNotification();
        
    } waitUntilDone:NO];
}

- (BOOL)isExistInShoppingCart:(NSString*)goodsId
{
    if (_shoppingCartItemList && [_shoppingCartItemList count]>0) {
        for (ShoppingCartItem *item in _shoppingCartItemList) {
            if ([item.goodsId isEqualToString:goodsId]) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)setUserInfo:(User*)userInfo
{
    if (userInfo.userId == self.currentUserId){
        [self.currentUser updateWithUserInfo:userInfo];
        [self saveAccountData];
        MBGlobalSendUserInfoChangedNotification(self.currentUserId);
    }
}

- (void)setUserLikesNum:(NSInteger)likesNum
{
    self.currentUser.likesNum = likesNum<0?0:likesNum;
    [self saveAccountData];
    
    MBGlobalSendUserInfoChangedNotification(self.currentUserId);
}

- (void)setUserFollowingsNum:(NSInteger)followingsNum
{
    self.currentUser.followingsNum = followingsNum;
    [self saveAccountData];
    
    MBGlobalSendUserInfoChangedNotification(self.currentUserId);
}

- (void)setFansNum:(NSInteger)fansNum
{
    self.currentUser.fansNum = fansNum;
    [self saveAccountData];
    
    MBGlobalSendUserInfoChangedNotification(self.currentUserId);
}

- (void)setUserAvatar:(NSString*)avatarUrl
{
    self.currentUser.avatarUrl = avatarUrl;
    [self saveAccountData];
    MBGlobalSendAvatarChangedNotification(self.currentUserId);
}

- (void)setUserFront:(NSString*)frontUrl
{
    self.currentUser.frontUrl = frontUrl;
    [self saveAccountData];
    SEL selector = @selector($$handleUserFrontChangedNotification:userId:);
    MBGlobalSendNotificationForSELWithBody(selector,[NSNumber numberWithInteger:self.currentUserId]);
}

- (void)setUserUserName:(NSString*)userName
{
    self.currentUser.userName = userName;
    self.modify_username_enable = NO;
    [self saveAccountData];
    SEL selector = @selector($$handleUserNameChangedNotification:userId:);
    MBGlobalSendNotificationForSELWithBody(selector,[NSNumber numberWithInteger:self.currentUserId]);
}

- (void)setUserweixinId:(NSString *)weixinId
{
    self.currentUser.weixinId = weixinId;
    [self saveAccountData];
    SEL selector = @selector($$handleUserProfileChangedNotification:userId:);
    MBGlobalSendNotificationForSELWithBody(selector,[NSNumber numberWithInteger:self.currentUserId]);
}

- (void)setUserGender:(NSInteger)gender
{
    self.currentUser.gender = gender;
    [self saveAccountData];
    SEL selector = @selector($$handleUserProfileChangedNotification:userId:);
    MBGlobalSendNotificationForSELWithBody(selector,[NSNumber numberWithInteger:self.currentUserId]);
}

- (void)setUserBirthday:(long long)birthday
{
    self.currentUser.birthday = birthday;
    [self saveAccountData];
    SEL selector = @selector($$handleUserProfileChangedNotification:userId:);
    MBGlobalSendNotificationForSELWithBody(selector,[NSNumber numberWithInteger:self.currentUserId]);
}

- (void)setUserSummary:(NSString*)summary
{
    self.currentUser.summary = summary;
    [self saveAccountData];
    SEL selector = @selector($$handleUserProfileChangedNotification:userId:);
    MBGlobalSendNotificationForSELWithBody(selector,[NSNumber numberWithInteger:self.currentUserId]);
}

- (void)setUserEMAccount:(EMAccount*)emAccount
{
    if (!self.emAccount) {
        self.emAccount = [[EMAccount alloc] init];
    }
    [self.emAccount updateWithEMAccount:emAccount];
    
    [self saveAccountData];
}

- (void)reloadSendSaleData:(SendSaleVo *)sendVo{
    SEL selector = @selector($$handleSendSaleGoodsChangedNotification:sendSaleVo:);
    MBGlobalSendNotificationForSELWithBody(selector,sendVo);
}

- (void)setUserKEFUEMAccount:(EMAccount*)emAccount
{
    if (!self.emKEFUAccount) {
        self.emKEFUAccount = [[EMAccount alloc] init];
    }
    [self.emKEFUAccount updateWithEMAccount:emAccount];
    
    [self saveAccountData];
}

- (BOOL)setUserCount:(MsgCount*)msgCount
{
    BOOL isDataChanged = [self.currentUser updateByMsgCount:msgCount];
    if (isDataChanged) {
        [self saveAccountData];
        MBGlobalSendUserInfoChangedNotification(self.currentUserId);
    }
    return isDataChanged;
}

- (void)setDefaultUserAddress:(AddressInfo*)addressInfo {
    if (addressInfo) {
        _defaultAddress = addressInfo;
        [self saveToCacheFile:@"defaultAddress" cacheFile:[AppDirs defaultAddressCacheFile] dict:[_defaultAddress toDict]];
        MBGlobalSendUserDefaultAddressChangedNotification(addressInfo);
    }
}

- (AddressInfo*)defaultUserAddress {
    if (!_defaultAddress) {
        NSDictionary *dict = [self loadFromCacheFile:@"defaultAddress" cacheFile:[AppDirs defaultAddressCacheFile]];
        if (dict) {
            _defaultAddress = [AddressInfo createWithDict:dict];
        }
    }
    return _defaultAddress;
}

//- (BOOL )removeDefualtUserAddress:(AddressInfo *)addressInfo
//{
//    if (addressInfo) {
//        
//    }
//}
- (void)saveDefaultUserAddress:(AddressInfo*)addressInfo
{
    if (addressInfo) {
        _defaultAddress = addressInfo;
        [self saveToCacheFile:@"defaultAddress" cacheFile:[AppDirs defaultAddressCacheFile] dict:[_defaultAddress toDict]];
    }
}

///
- (void)handleTokenDidExpireNotification:(NSNotification*)notifi
{   
    _isLoggedIn = NO;
    _needSyncShoppingCart = NO;
    _token = nil;
    _emAccount = nil;
    [self saveAccountData];
    
    SEL selector = @selector($$handleTokenDidExpireNotification:);
    MBGlobalSendNotificationForSEL(selector);
}

- (void)handleReachabilityChanged:(NSNotification*)notifi
{
    if ([[NetworkManager sharedInstance] isReachable])  {
        [self syncDataFromServer];
    } else {
        [[self class] cancelPreviousPerformRequestsWithTarget:self];
    }
}

///
- (void)syncAliasPushIdToUMessage {
    if (self.isLoggedIn && [self.token length]>0) {
        NSMutableString *admPushId = [NSMutableString stringWithFormat:@"%ld",(unsigned long)self.currentUserId];
        if ([admPushId length]<6) {
            NSInteger count = 6-[admPushId length];
            for (int i=0;i<count;i++) {
                [admPushId insertString:@"0" atIndex:0];
            }
        }
        [admPushId insertString:@"adm_" atIndex:0];
        [UMessage addAlias:admPushId type:@"ADM" response:^(id responseObject, NSError *error) {
            NSLog(@"%@",responseObject);
        }];
    }
}

- (void)removeAliasPushIdToUMessage {
    NSMutableString *admPushId = [NSMutableString stringWithFormat:@"%ld",(unsigned long)self.currentUserId];
    if ([admPushId length]<6) {
        NSInteger count = 6-[admPushId length];
        for (int i=0;i<count;i++) {
            [admPushId insertString:@"0" atIndex:0];
        }
    }
    [admPushId insertString:@"adm_" atIndex:0];
    [UMessage removeAlias:admPushId type:@"ADM" response:^(id responseObject, NSError *error) {
        NSLog(@"%@",responseObject);
    }];
}

- (void)$$handleRegisterDidFinishNotification:(id<MBNotification>)notifi
{
    _needSyncUserInfo = NO;
    _syncUserInfoRequest = nil;
    
    [self syncAliasPushIdToUMessage];
}

- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    _needSyncUserInfo = NO;
    _syncUserInfoRequest = nil;
    
    [self syncDataFromServer];
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
    
    [self syncAliasPushIdToUMessage];
}

- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi
{
    _needSyncShoppingCart = NO;
    _syncShoppingCartRequest = nil;
    
    _needSyncUserInfo = NO;
    _syncUserInfoRequest = nil;
    
    [[EMSession sharedInstance] logout];
    [self removeAliasPushIdToUMessage];
    
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    _needSyncShoppingCart = NO;
    _syncShoppingCartRequest = nil;
    
    _needSyncUserInfo = NO;
    _syncUserInfoRequest = nil;
    
    [[EMSession sharedInstance] logout];
    [self removeAliasPushIdToUMessage];
    
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

///

- (void)$$handleFetchAddressListDidFinishNotification:(id<MBNotification>)notifi addressList:(NSArray*)addressList
{
    
}

- (void)$$handleUserDefaultAddressChangedNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    [self saveDefaultUserAddress:addressInfo];
}

- (void)$$handleAddAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    
}

- (void)$$handleRemoveAddressDidFinishNotification:(id<MBNotification>)notifi addressId:(NSNumber*)addressId
{
    
}

- (void)$$handleModifyAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo
{
    
}

///

- (void)syncDataFromServer
{
    if ([[NetworkManager sharedInstance] isReachable]) {
        if (_needSyncShoppingCart) {
            [self performSelector:@selector(syncSyncShoppingCartFromServer) withObject:nil afterDelay:5.f];
        }
        if (_needSyncUserInfo) {
            [self performSelector:@selector(syncUserInfoFromServer) withObject:nil afterDelay:3.f];
        }
    }
}

- (void)syncSyncShoppingCartFromServer {
    WEAKSELF;
    if ([[NetworkManager sharedInstance] isReachable]) {
        if (_needSyncShoppingCart) {
            if (!_syncShoppingCartRequest) {
                _syncShoppingCartRequest = [[NetworkAPI sharedInstance] getShoppingCartGoods:^(NSArray *goodsList) {
                    NSMutableArray *items = [[NSMutableArray alloc] init];
                    for (NSDictionary *dict in goodsList) {
                        if ([dict isKindOfClass:[NSDictionary class]]) {
                            [items addObject:[ShoppingCartItem createWithDict:dict]];
                        }
                    }
                    
                    weakSelf.needSyncShoppingCart = NO;
                    weakSelf.syncShoppingCartRequest = nil;
                    
                    [self setShoppingCartItems:items];
                } failure:^(XMError *error) {
                    weakSelf.syncShoppingCartRequest = nil;
                    if ([[NetworkManager sharedInstance] isReachable]
                        && [Session sharedInstance].isLoggedIn
                        && [Session sharedInstance].currentUserId>0) {
                        [self performSelector:@selector(syncSyncShoppingCartFromServer) withObject:nil afterDelay:10.f];
                    }
                }];
            }
        }
    }
}

- (void)syncUserInfoFromServer {
    WEAKSELF;
    if ([[NetworkManager sharedInstance] isReachable]) {
        if (_needSyncUserInfo) {
            if (!_syncUserInfoRequest) {
                _syncUserInfoRequest = [[NetworkAPI sharedInstance] getUserInfo:self.currentUserId completion:^(User *user) {
                    [[Session sharedInstance].currentUser updateWithUserInfo:user];
                    
                    weakSelf.needSyncUserInfo = NO;
                    weakSelf.syncUserInfoRequest = nil;
                    
                    MBGlobalSendUserInfoChangedNotification(self.currentUserId);
                    
                } failure:^(XMError *error) {
                    _syncUserInfoRequest = nil;
                    if ([[NetworkManager sharedInstance] isReachable]
                        && [Session sharedInstance].isLoggedIn
                        && [Session sharedInstance].currentUserId>0) {
                        [self performSelector:@selector(syncUserInfoFromServer) withObject:nil afterDelay:8.f];
                    }
                }];
            }
        }
    }
}


- (void)savePublishGoodsToDraft:(GoodsEditableInfo *)editableInfo
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (editableInfo) {
        [dict setObject:editableInfo forKey:@"editableInfo"];
    }
    [self saveToCacheFile:@"draftEditableInfo" cacheFile:[AppDirs publishGoodsCacheFile] dict:dict];
}

- (GoodsEditableInfo *)loadPublishGoodsFromDraft
{
    NSDictionary * dict = [self loadFromCacheFile:@"draftEditableInfo" cacheFile:[AppDirs publishGoodsCacheFile]];
    GoodsEditableInfo * editableInfo = dict[@"editableInfo"];
    return editableInfo;
}

- (NSDictionary*)loadFromCacheFile:(NSString *)key cacheFile:(NSString*)cacheFile
{
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:cacheFile isDirectory:&isDirectory]
        && !isDirectory) {
        NSData *data = [NSData dataWithContentsOfFile:cacheFile];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *dict = [unarchiver decodeObjectForKey:key];
        [unarchiver finishDecoding];
        return dict;
    }
    return nil;
}

-(void)setSkinIcon:(NSDictionary *)skinIcon{
    [self saveToCacheFile:@"skinIcon" cacheFile:[AppDirs currentSkinIconCacheFile] dict:skinIcon];
}

- (NSDictionary *)loadSkinIconData
{
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm && [fm fileExistsAtPath:[AppDirs currentSkinIconCacheFile] isDirectory:&isDirectory]
        && !isDirectory) {
        NSDictionary *dict = [self loadFromCacheFile:@"skinIcon" cacheFile:[AppDirs currentSkinIconCacheFile]];
        return dict;
    }
    return nil;
}

- (void)saveToCacheFile:(NSString *)key cacheFile:(NSString*)cacheFile dict:(NSDictionary*)dict
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:dict forKey:key];
    [archiver finishEncoding];
    [data writeToFile:cacheFile atomically:YES];
}

- (BOOL)isNeedShowRedPoint {
    BOOL isFirstStart = NO;
    NSString *firstStart =  [[NSUserDefaults standardUserDefaults] objectForKey:kRedPoint];
    if (firstStart == nil || [firstStart isEqualToString:@""] ) {
        isFirstStart = YES;
    }
    return isFirstStart;
}

@end

///===================================================================================
//

//- (void)$$handleFetchAddressListDidFinishNotification:(id<MBNotification>)notifi addressList:(NSArray*)addressList;
//- (void)$$handleUserDefaultAddressChangedNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo;
//- (void)$$handleAddAddressDidFinishNotification:(id<MBNotification>)notifi addressInfo:(AddressInfo*)addressInfo;
//- (void)$$handleRemoveAddressDidFinishNotification:(id<MBNotification>)notifi addressId:(NSInteger)addressId;
//- (void)$$handleModifyAddressDidFinishNotification:(id<MBNotification>)notifi addressId:(NSInteger)addressId;

void MBGlobalSendFetchAddressListDidFinishNotification(NSArray *addressList)
{
    SEL selector = @selector($$handleFetchAddressListDidFinishNotification:addressList:);
    MBGlobalSendNotificationForSELWithBody(selector, addressList);
}

void MBGlobalSendUserDefaultAddressChangedNotification(AddressInfo *addressInfo)
{
    SEL selector = @selector($$handleUserDefaultAddressChangedNotification:addressInfo:);
    MBGlobalSendNotificationForSELWithBody(selector, addressInfo);
}

void MBGlobalSendAddAddressDidFinishNotification(AddressInfo *addressInfo)
{
    SEL selector = @selector($$handleAddAddressDidFinishNotification:addressInfo:);
    MBGlobalSendNotificationForSELWithBody(selector, addressInfo);
}

void MBGlobalSendRemoveAddressDidFinishNotification(NSInteger addressId)
{
    SEL selector = @selector($$handleRemoveAddressDidFinishNotification:addressId:);
    MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:addressId]);
}

void MBGlobalSendModifyAddressDidFinishNotification(AddressInfo *addressInfo)
{
    SEL selector = @selector($$handleModifyAddressDidFinishNotification:addressInfo:);
    MBGlobalSendNotificationForSELWithBody(selector, addressInfo);
}

///

void MBGlobalSendUserInfoChangedNotification(NSInteger userId)
{
    SEL selector = @selector($$handleUserInfoChangedNotification:userId:);
    MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:userId]);
}

void MBGlobalSendAvatarChangedNotification(NSInteger userId)
{
    SEL selector = @selector($$handleAvatarChangedNotification:userId:);
    MBGlobalSendNotificationForSELWithBody(selector,[NSNumber numberWithInteger:userId]);
}

void MBGlobalSendFollowUserNotification(NSInteger userId)
{
    SEL selector = @selector($$handleFollowUserNotification:userId:);
    MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:userId]);
}

void MBGlobalSendUnFollowUserNotification(NSInteger userId)
{
    SEL selector = @selector($$handleUnFollowUserNotification:userId:);
    MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:userId]);
}

///===================================================================================
//
void MBGlobalSendConsignDidFinishNotification(NSInteger ordersNum)
{
    SEL selector = @selector($$handleConsignDidFinishNotification:ordersNum:);
    MBGlobalSendNotificationForSELWithBody(selector, [NSNumber numberWithInteger:ordersNum]);
}

void MBGlobalSendConsignContinueNotification()
{
    SEL selector = @selector($$handleConsignContinueNotification:);
    MBGlobalSendNotificationForSEL(selector);
}

void MBGlobalSendConsignCloseNotification()
{
    SEL selector = @selector($$handleConsignCloseNotification:);
    MBGlobalSendNotificationForSEL(selector);
}

void MBGlobalSendGoodsInfoListChangedNotification(NSUInteger key, NSArray* goodsIds)
{
    if ([goodsIds count]>0) {
        SEL selector = @selector($$handleGoodsInfoChanged:goodsIds:);
        NSString *notificationName = NSStringFromSelector(selector);
        MBGlobalSendMBNotification([MBDefaultNotification objectWithName:notificationName key:key body:goodsIds]);
    }
}

void MBGlobalSendGoodsInfoChangedNotification(NSUInteger key, NSString* goodsId)
{
    NSArray *goodsIds = [NSArray arrayWithObjects:goodsId, nil];
    SEL selector = @selector($$handleGoodsInfoChanged:goodsIds:);
    NSString *notificationName = NSStringFromSelector(selector);
    MBGlobalSendMBNotification([MBDefaultNotification objectWithName:notificationName key:key body:goodsIds]);
}

extern void MBGlobalSendGoodsInfoUpdatedNotification(GoodsInfo* goodsInfo)
{
    SEL selector = @selector($$handleGoodsInfoUpdated:goodsInfo:);
    MBGlobalSendNotificationForSELWithBody(selector, goodsInfo);
}

extern void MBGlobalSendGoodsStatusUpdatedNotification(NSArray* goodStatusArray) {
    SEL selector = @selector($$handleGoodsStatusUpdated:goodStatusArray:);
    MBGlobalSendNotificationForSELWithBody(selector, goodStatusArray);
}

///===================================================================================
//

void MBGlobalSendImagePickerFinishNotification(UIImage *image)
{
    SEL selector = @selector($$imagePickerFinishNotification:image:);
    MBGlobalSendNotificationForSELWithBody(selector, image);
}

void MBGlobalShoppingCartGoodsAddedNotification(ShoppingCartItem* item)
{
    SEL selector = @selector($$handleShoppingCartGoodsChangedNotification:addedItem:);
    MBGlobalSendNotificationForSELWithBody(selector, item);
}

void MBGlobalShoppingCartGoodsRemovedNotification(NSArray* goodsIds)
{
    SEL selector = @selector($$handleShoppingCartGoodsChangedNotification:removedGoodsIds:);
    MBGlobalSendNotificationForSELWithBody(selector,goodsIds);
}

extern void MBGlobalShoppingCartSyncFinishedNotification()
{
    SEL selector = @selector($$handleShoppingCartSyncFinishedNotification:);
    MBGlobalSendNotificationForSEL(selector);
}

///===================================================================================
//

#import "ChatViewController.h"

@interface UserSingletonCommand ()
@property(nonatomic,strong) HTTPRequest *request;
@end

@implementation UserSingletonCommand {
    
}

///

//- (void)$$handleFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
//{
//    self.user.followingsNum = self.user.followingsNum+1;
//    [self saveAccountData];
//    MBGlobalSendUserInfoChangedNotification(self.currentUserId);
//}
//
//- (void)$$handleUnFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
//{
//    self.user.followingsNum = self.user.followingsNum-1<0?0:self.user.followingsNum-1;
//    [self saveAccountData];
//    MBGlobalSendUserInfoChangedNotification(self.currentUserId);
//}


- (void)followUser:(NSInteger)userId isFollow:(BOOL)isFollow
{
    if (!_request || [_request isFinished]) {
        _$showProcessingHUD(nil);
        _request = [[NetworkAPI sharedInstance] followUser:userId isFollow:isFollow completion:^(NSInteger totalNum) {
            _$hideHUD();
            dispatch_async(dispatch_get_main_queue(), ^{
                if (isFollow) {
                    MBGlobalSendFollowUserNotification(userId);
                } else {
                    MBGlobalSendUnFollowUserNotification(userId);
                }
                [[Session sharedInstance] setUserFollowingsNum:totalNum];
            });
        } failure:^(XMError *error) {
            _$showHUD([error errorMsg], 0.8f);
        }];
    }
}

//在线客服
- (void)$$touchChatButtonGroup:(id<MBNotification>)notification chatWithUserDO:(ChatWithUserDO*)chatWithUserDO {
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [[EMIMHelper defaultHelper] loginEasemobSDK];
//        NSString *cname = [[EMIMHelper defaultHelper] cname];
//        ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:cname Customer:chatWithUserDO.groupName];
//        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
//
//    });
    
    dispatch_async(dispatch_get_main_queue(), ^{
        ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatWithUserDO.emAccount.emUserName
                                                                              sellerName:chatWithUserDO.emAccount.username
                                                                            sellerHeader:chatWithUserDO.emAccount.avatar
                                                                            sellerUserId:chatWithUserDO.emAccount.userId
                                                                                 message:nil];
        viewController.isKefu = chatWithUserDO.isKefu;
        viewController.isConsultant = chatWithUserDO.isConsultant;
        viewController.consultantStr = chatWithUserDO.consultantStr;
        
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    });
    
}

- (void)$$touchChatButton:(id<MBNotification>)notification chatWithUserDO:(ChatWithUserDO*)chatWithUserDO {
    
    [self $$touchChatButton:notification userId:[NSNumber numberWithInteger:chatWithUserDO.userId] msg:chatWithUserDO.msg isYes:chatWithUserDO.isYes goodsVO:chatWithUserDO.goodsVO bidVO:chatWithUserDO.bidVO chatWithUserDO:(ChatWithUserDO*)chatWithUserDO isGuwen:chatWithUserDO.isGuwen];
}

- (void)$$touchChatButton:(id<MBNotification>)notification userId:(NSNumber*)userId msg:(NSString*)msg isYes:(NSInteger)isYes goodsVO:(RecoveryGoodsVo *)goodsVO bidVO:(HighestBidVo *)bidVO chatWithUserDO:(ChatWithUserDO*)chatWithUserDO isGuwen:(BOOL)isGuwen{
    
    _$showProcessingHUD(nil);
    EMAccount *emAccount = [Session sharedInstance].emAccount;
    
    if (emAccount && [emAccount.emUserName length] > 0 && [emAccount.emPassword length] > 0) {
        if ([EMSession sharedInstance].isLoggedIn) {
            NSArray *userIds = [NSArray arrayWithObjects:userId, nil];
            _request = [[NetworkAPI sharedInstance] getEMAccounts:userIds completion:^(NSArray *accountDicts) {
                _$hideHUD();
                NSMutableArray *accounts = [[NSMutableArray alloc] init];;
                for (NSDictionary *dict in accountDicts) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        [accounts addObject:[EMAccount createWithDict:dict]];
                    }
                }
                
                EMAccount *chatToEMAccount = nil;
                for (NSInteger i=0;i< [accountDicts count]; i++) {
                    NSDictionary *dict = [accountDicts objectAtIndex:i];
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        EMAccount *emAccount = [EMAccount createWithDict:dict];
                        if (emAccount.userId == [userId integerValue]) {
                            chatToEMAccount = emAccount;
                            break;
                        }
                    }
                }
                
                if (chatToEMAccount) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if (isYes == 2) {
                            ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName sellerName:chatToEMAccount.username sellerHeader:chatToEMAccount.avatar sellerUserId:chatToEMAccount.userId goodsId:goodsVO.goodsSn];
                            
                            viewController.adviserPage = chatWithUserDO.adviser;
                            viewController.isGuwen = chatWithUserDO.isGuwen;
                            viewController.isConsultant = chatWithUserDO.isConsultant;
                            viewController.isKefu = chatWithUserDO.isKefu;
                            viewController.isJimai = chatWithUserDO.isJimai;
                            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                            
                        } else if (isYes == 1) {
                            
                            ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                                  sellerName:chatToEMAccount.username
                                                                                                sellerHeader:chatToEMAccount.avatar
                                                                                                sellerUserId:chatToEMAccount.userId
                                                                                                     message:msg];
                            viewController.adviserPage = chatWithUserDO.adviser;
                            viewController.isGuwen = chatWithUserDO.isGuwen;
                            viewController.isConsultant = chatWithUserDO.isConsultant;
                            viewController.isKefu = chatWithUserDO.isKefu;
                            viewController.isYes = YES;
                            viewController.isJimai = chatWithUserDO.isJimai;
                            [viewController getGoodsVO:goodsVO andBidVO:bidVO];
                            
                            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                        } else if (isYes == 3) {
                            
                            if (chatWithUserDO.goodsId) {
                                ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName sellerName:chatToEMAccount.username sellerHeader:chatToEMAccount.avatar sellerUserId:chatToEMAccount.userId goodsId:chatWithUserDO.goodsId];
                                
                                viewController.isGuwen = chatWithUserDO.isGuwen;
                                viewController.isConsultant = chatWithUserDO.isConsultant;
                                viewController.isKefu = chatWithUserDO.isKefu;
                                viewController.consultantStr = chatWithUserDO.consultantStr;
                                viewController.adviserPage = chatWithUserDO.adviser;
                                viewController.isJimai = chatWithUserDO.isJimai;
                                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                            } else {
                                ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                                      sellerName:chatToEMAccount.username
                                                                                                    sellerHeader:chatToEMAccount.avatar
                                                                                                    sellerUserId:chatToEMAccount.userId
                                                                                                         message:msg];
                                
                                viewController.isGuwen = chatWithUserDO.isGuwen;
                                viewController.isConsultant = chatWithUserDO.isConsultant;
                                viewController.isKefu = chatWithUserDO.isKefu;
                                viewController.consultantStr = chatWithUserDO.consultantStr;
                                viewController.adviserPage = chatWithUserDO.adviser;
                                viewController.isJimai = chatWithUserDO.isJimai;
                                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                            }
                            
                        } else {
                            ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                                  sellerName:chatToEMAccount.username
                                                                                                sellerHeader:chatToEMAccount.avatar
                                                                                                sellerUserId:chatToEMAccount.userId
                                                                                                     message:msg];
                            viewController.adviserPage = chatWithUserDO.adviser;
                            viewController.isGuwen = chatWithUserDO.isGuwen;
                            viewController.isConsultant = chatWithUserDO.isConsultant;
                            viewController.isKefu = chatWithUserDO.isKefu;
                            viewController.isJimai = chatWithUserDO.isJimai;
                            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                        }
                        
                    });
                }
                _$hideHUD();
            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            }];

        } else {
            [[EMSession sharedInstance] loginWithUsername:emAccount.emUserName password:emAccount.emPassword completion:^{
                
                NSArray *userIds = [NSArray arrayWithObjects:userId, nil];
                _request = [[NetworkAPI sharedInstance] getEMAccounts:userIds completion:^(NSArray *accountDicts) {
                    NSMutableArray *accounts = [[NSMutableArray alloc] init];;
                    for (NSDictionary *dict in accountDicts) {
                        if ([dict isKindOfClass:[NSDictionary class]]) {
                            [accounts addObject:[EMAccount createWithDict:dict]];
                        }
                    }
                    
                    EMAccount *chatToEMAccount = nil;
                    for (NSInteger i=0;i< [accountDicts count]; i++) {
                        NSDictionary *dict = [accountDicts objectAtIndex:i];
                        if ([dict isKindOfClass:[NSDictionary class]]) {
                            EMAccount *emAccount = [EMAccount createWithDict:dict];
                            if (emAccount.userId == [userId integerValue]) {
                                chatToEMAccount = emAccount;
                                break;
                            }
                        }
                    }
                    
                    if (chatToEMAccount) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            if (isYes == 2) {
                                ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName sellerName:chatToEMAccount.username sellerHeader:chatToEMAccount.avatar sellerUserId:chatToEMAccount.userId goodsId:goodsVO.goodsSn];
                                
                                viewController.adviserPage = chatWithUserDO.adviser;
                                viewController.isGuwen = chatWithUserDO.isGuwen;
                                viewController.isConsultant = chatWithUserDO.isConsultant;
                                viewController.isKefu = chatWithUserDO.isKefu;
                                viewController.isJimai = chatWithUserDO.isJimai;
                                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                                
                            } else if (isYes == 1) {
                                
                                ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                                      sellerName:chatToEMAccount.username
                                                                                                    sellerHeader:chatToEMAccount.avatar
                                                                                                    sellerUserId:chatToEMAccount.userId
                                                                                                         message:msg];
                                viewController.adviserPage = chatWithUserDO.adviser;
                                viewController.isGuwen = chatWithUserDO.isGuwen;
                                viewController.isConsultant = chatWithUserDO.isConsultant;
                                viewController.isKefu = chatWithUserDO.isKefu;
                                viewController.isYes = YES;
                                viewController.isJimai = chatWithUserDO.isJimai;
                                [viewController getGoodsVO:goodsVO andBidVO:bidVO];
                                
                                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                            } else {
                                ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                                      sellerName:chatToEMAccount.username
                                                                                                    sellerHeader:chatToEMAccount.avatar
                                                                                                    sellerUserId:chatToEMAccount.userId
                                                                                                         message:msg];
                                viewController.adviserPage = chatWithUserDO.adviser;
                                viewController.isGuwen = chatWithUserDO.isGuwen;
                                viewController.isConsultant = chatWithUserDO.isConsultant;
                                viewController.isKefu = chatWithUserDO.isKefu;
                                viewController.isJimai = chatWithUserDO.isJimai;
                                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                            }

                        });
                    }
                    _$hideHUD();
                } failure:^(XMError *error) {
                     _$showHUD(@"对方暂忙，请稍候重试", 0.8f);
                }];
            } failure:^(XMError *error) {
                NSLog(@"%@",error);
                _$showHUD([NSString stringWithFormat:@"注册聊天服务失败，请重试%@",error], 0.8f);
            }];
        }
        
    } else {
        NSArray *userIds = [NSArray arrayWithObjects:[NSNumber numberWithInteger:[Session sharedInstance].currentUserId], nil];
        _request = [[NetworkAPI sharedInstance] getEMAccounts:userIds completion:^(NSArray *accountDicts) {
            
            NSMutableArray *accounts = [[NSMutableArray alloc] init];;
            for (NSDictionary *dict in accountDicts) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [accounts addObject:[EMAccount createWithDict:dict]];
                }
            }
            
            EMAccount *currentUserEMAccount = nil;
            for (NSInteger i=0;i< [accountDicts count]; i++) {
                NSDictionary *dict = [accountDicts objectAtIndex:i];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    EMAccount *emAccount = [EMAccount createWithDict:dict];
                    if (emAccount.userId == [Session sharedInstance].currentUserId) {
                        currentUserEMAccount = emAccount;
                        break;
                    }
                }
            }
            
            if (currentUserEMAccount) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    
                    if (isYes == 2) {
                        ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:currentUserEMAccount.emUserName sellerName:currentUserEMAccount.username sellerHeader:currentUserEMAccount.avatar sellerUserId:currentUserEMAccount.userId goodsId:goodsVO.goodsSn];
                        
                        viewController.adviserPage = chatWithUserDO.adviser;
                        viewController.isGuwen = chatWithUserDO.isGuwen;
                        viewController.isConsultant = chatWithUserDO.isConsultant;
                        viewController.isKefu = chatWithUserDO.isKefu;
                        viewController.isJimai = chatWithUserDO.isJimai;
                        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                        
                    } else if (isYes == 1) {
                        
                        ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:currentUserEMAccount.emUserName
                                                                                              sellerName:currentUserEMAccount.username
                                                                                            sellerHeader:currentUserEMAccount.avatar
                                                                                            sellerUserId:currentUserEMAccount.userId
                                                                                                 message:msg];
                        
                        viewController.adviserPage = chatWithUserDO.adviser;
                        viewController.isGuwen = chatWithUserDO.isGuwen;
                        viewController.isConsultant = chatWithUserDO.isConsultant;
                        viewController.isKefu = chatWithUserDO.isKefu;
                        viewController.isYes = YES;
                        viewController.isJimai = chatWithUserDO.isJimai;
                        [viewController getGoodsVO:goodsVO andBidVO:bidVO];
                        
                        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                    } else {
                        ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:currentUserEMAccount.emUserName
                                                                                              sellerName:currentUserEMAccount.username
                                                                                            sellerHeader:currentUserEMAccount.avatar
                                                                                            sellerUserId:currentUserEMAccount.userId
                                                                                                 message:msg];
                        
                        viewController.adviserPage = chatWithUserDO.adviser;
                        viewController.isGuwen = chatWithUserDO.isGuwen;
                        viewController.isConsultant = chatWithUserDO.isConsultant;
                        viewController.isKefu = chatWithUserDO.isKefu;
                        viewController.isJimai = chatWithUserDO.isJimai;
                        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                    }

                });

            } else {
                _$showHUD(@"注册聊天服务失败，请重试", 0.8f);
            }
        } failure:^(XMError *error) {
            _$showHUD([error errorMsg], 0.8f);
        }];
    }
    
}
- (void)$$touchChatWithoutGoodsId:(id<MBNotification>)notification goodsId:(NSString*)goodsId {
    WEAKSELF;
    EMAccount *emAccount = [Session sharedInstance].emAccount;
    if ((emAccount && [emAccount.emUserName length]>0 && [emAccount.emPassword length]>0)) {
        _$showProcessingHUD(nil);
        
        if ([EMSession sharedInstance].isLoggedIn) {
            _request = [[NetworkAPI sharedInstance] chatBalance:goodsId completion:^(NSDictionary *accountDict) {
                EMAccount *chatToEMAccount = [EMAccount createWithDict:accountDict];
                
                //                if ([chatToEMAccount.emUserName isEqualToString:[Session sharedInstance].emAccount.emUserName] ) {
                //                    _$showHUD(@"对不起,聊天功能暂不支持自问自答 ", 1.0f);
                //                    return;
                //                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _$hideHUD();
                    
                    ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                          sellerName:chatToEMAccount.username
                                                                                        sellerHeader:chatToEMAccount.avatar
                                                                                        sellerUserId:chatToEMAccount.userId
                                                                                             goodsId:nil];
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                });
                
            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            }];
        } else {
            [[EMSession sharedInstance] loginWithUsername:emAccount.emUserName password:emAccount.emPassword completion:^{
                
                weakSelf.request = [[NetworkAPI sharedInstance] chatBalance:goodsId completion:^(NSDictionary *accountDict) {
                    
                    EMAccount *chatToEMAccount = [EMAccount createWithDict:accountDict];
                    //                    if ([chatToEMAccount.emUserName isEqualToString:[Session sharedInstance].emAccount.emUserName] ) {
                    //                        _$showHUD(@"对不起,聊天功能暂不支持自问自答 ", 1.0f);
                    //                        return;
                    //                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                              sellerName:chatToEMAccount.username
                                                                                            sellerHeader:chatToEMAccount.avatar
                                                                                            sellerUserId:chatToEMAccount.userId
                                                                                                 goodsId:nil];
                        
                        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                    });
                    _$hideHUD();
                } failure:^(XMError *error) {
                    _$showHUD([error errorMsg], 0.8f);
                }];
                
            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            }];
        }
    }
    else {
        _$showProcessingHUD(nil);
        NSArray *userIds = [NSArray arrayWithObjects:[NSNumber numberWithInteger:[Session sharedInstance].currentUserId], nil];
        _request = [[NetworkAPI sharedInstance] getEMAccounts:userIds completion:^(NSArray *accountDicts) {
            
            NSMutableArray *accounts = [[NSMutableArray alloc] init];;
            for (NSDictionary *dict in accountDicts) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [accounts addObject:[EMAccount createWithDict:dict]];
                }
            }
            
            EMAccount *currentUserEMAccount = nil;
            for (NSInteger i=0;i< [accountDicts count]; i++) {
                NSDictionary *dict = [accountDicts objectAtIndex:i];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    EMAccount *emAccount = [EMAccount createWithDict:dict];
                    if (emAccount.userId == [Session sharedInstance].currentUserId) {
                        currentUserEMAccount = emAccount;
                        break;
                    }
                }
            }
            
            if (currentUserEMAccount) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[Session sharedInstance] setUserEMAccount:emAccount];
                    [[EMSession sharedInstance] loginWithUsername:currentUserEMAccount.emUserName password:currentUserEMAccount.emPassword completion:^{
                        
                        weakSelf.request = [[NetworkAPI sharedInstance] chatBalance:goodsId completion:^(NSDictionary *accountDict) {
                            
                            EMAccount *chatToEMAccount = [EMAccount createWithDict:accountDict];
                            //                            if ([chatToEMAccount.emUserName isEqualToString:[Session sharedInstance].emAccount.emUserName] ) {
                            //                                _$showHUD(@"对不起,聊天功能暂不支持自问自答 ", 1.0f);
                            //                                return;
                            //                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                                      sellerName:chatToEMAccount.username
                                                                                                    sellerHeader:chatToEMAccount.avatar
                                                                                                    sellerUserId:chatToEMAccount.userId
                                                                                                         goodsId:nil] ;
                                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                            });
                            _$hideHUD();
                        } failure:^(XMError *error) {
                            _$showHUD([error errorMsg], 0.8f);
                        }];
                        
                    } failure:^(XMError *error) {
                        _$showHUD([error errorMsg], 0.8f);
                    }];
                });
            } else {
                _$showHUD(@"注册聊天服务失败，请重试", 0.8f);
            }
        } failure:^(XMError *error) {
            _$showHUD([error errorMsg], 0.8f);
        }];
    }

}

- (void)$$touchChatButtonHasUser:(id<MBNotification>)notification goodsId:(NSString*)goodsId {
    
    WEAKSELF;
    EMAccount *emAccount = [Session sharedInstance].emAccount;
    if ((emAccount && [emAccount.emUserName length]>0 && [emAccount.emPassword length]>0)) {
        _$showProcessingHUD(nil);
        
        if ([EMSession sharedInstance].isLoggedIn) {
            NSInteger userId = [Session sharedInstance].currentUserId;
            _request=[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"bind_adviser" parameters:@{@"user_id":[NSNumber numberWithInteger:userId]} completionBlock:^(NSDictionary *data) {
                
                AdviserPage *adviser = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
//                [UserSingletonCommand chatWithUserFirst:adviser.userId msg:adviser.greetings];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _$hideHUD();
                    
                    ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:emAccount.emUserName
                                                                                          sellerName:adviser.username
                                                                                        sellerHeader:adviser.avatar
                                                                                        sellerUserId:adviser.userId
                                                                                             goodsId:goodsId] ;
//                    viewController.adviser = adviser;
                    viewController.adviserPage = adviser;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                });

            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            } queue:nil];

        } else {
            [[EMSession sharedInstance] loginWithUsername:emAccount.emUserName password:emAccount.emPassword completion:^{
                
            _request=[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"bind_adviser" parameters:@{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUserId]} completionBlock:^(NSDictionary *data) {
                
                AdviserPage *adviser = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
//                [UserSingletonCommand chatWithUserFirst:adviser.userId msg:adviser.greetings];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    _$hideHUD();
                    
                    ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:emAccount.emUserName
                                                                                          sellerName:adviser.username
                                                                                        sellerHeader:adviser.avatar
                                                                                        sellerUserId:adviser.userId
                                                                                             goodsId:goodsId] ;
                    viewController.adviserPage = adviser;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                });
                
            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            } queue:nil];
                
            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            }];
        }
    }
    else {
        _$showProcessingHUD(nil);
    _request=[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"bind_adviser" parameters:@{@"user_id":[NSNumber numberWithInteger:[Session sharedInstance].currentUserId]} completionBlock:^(NSDictionary *data) {
        
        AdviserPage *adviser = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
//        [UserSingletonCommand chatWithUserFirst:adviser.userId msg:adviser.greetings];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _$hideHUD();
            NSArray *userIds = [NSArray arrayWithObjects:[NSNumber numberWithInteger:[Session sharedInstance].currentUserId], nil];
            _request = [[NetworkAPI sharedInstance] getEMAccounts:userIds completion:^(NSArray *accountDicts) {
                
                NSMutableArray *accounts = [[NSMutableArray alloc] init];;
                for (NSDictionary *dict in accountDicts) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        [accounts addObject:[EMAccount createWithDict:dict]];
                    }
                }
                
                EMAccount *currentUserEMAccount = nil;
                for (NSInteger i=0;i< [accountDicts count]; i++) {
                    NSDictionary *dict = [accountDicts objectAtIndex:i];
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        EMAccount *emAccount = [EMAccount createWithDict:dict];
                        if (emAccount.userId == [Session sharedInstance].currentUserId) {
                            currentUserEMAccount = emAccount;
                            break;
                        }
                    }
                }
                
                if (currentUserEMAccount) {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[Session sharedInstance] setUserEMAccount:emAccount];
                        [[EMSession sharedInstance] loginWithUsername:currentUserEMAccount.emUserName password:currentUserEMAccount.emPassword completion:^{
                            
                            weakSelf.request = [[NetworkAPI sharedInstance] chatBalance:goodsId completion:^(NSDictionary *accountDict) {
                                
                                EMAccount *chatToEMAccount = [EMAccount createWithDict:accountDict];
                                //                            if ([chatToEMAccount.emUserName isEqualToString:[Session sharedInstance].emAccount.emUserName] ) {
                                //                                _$showHUD(@"对不起,聊天功能暂不支持自问自答 ", 1.0f);
                                //                                return;
                                //                            }
                                dispatch_async(dispatch_get_main_queue(), ^{
                                    ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:emAccount.emUserName
                                                                                                          sellerName:adviser.username
                                                                                                        sellerHeader:adviser.avatar
                                                                                                        sellerUserId:adviser.userId
                                                                                                             goodsId:goodsId] ;
                                    viewController.adviserPage = adviser;
                                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                                });
                                _$hideHUD();
                            } failure:^(XMError *error) {
                                _$showHUD([error errorMsg], 0.8f);
                            }];
                            
                        } failure:^(XMError *error) {
                            _$showHUD([error errorMsg], 0.8f);
                        }];
                    });
                } else {
                    _$showHUD(@"注册聊天服务失败，请重试", 0.8f);
                }
            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            }];
            
        });
        
    } failure:^(XMError *error) {
        _$showHUD([error errorMsg], 0.8f);
    } queue:nil];
        
    }
}

- (void)$$touchChatButton:(id<MBNotification>)notification goodsId:(NSString*)goodsId {
    
    WEAKSELF;
    EMAccount *emAccount = [Session sharedInstance].emAccount;
    if ((emAccount && [emAccount.emUserName length]>0 && [emAccount.emPassword length]>0)) {
        _$showProcessingHUD(nil);
        
        if ([EMSession sharedInstance].isLoggedIn) {
            _request = [[NetworkAPI sharedInstance] chatBalance:goodsId completion:^(NSDictionary *accountDict) {
                EMAccount *chatToEMAccount = [EMAccount createWithDict:accountDict];
                
//                if ([chatToEMAccount.emUserName isEqualToString:[Session sharedInstance].emAccount.emUserName] ) {
//                    _$showHUD(@"对不起,聊天功能暂不支持自问自答 ", 1.0f);
//                    return;
//                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                    _$hideHUD();
                    
                    ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                          sellerName:chatToEMAccount.username
                                                                                        sellerHeader:chatToEMAccount.avatar
                                                                                        sellerUserId:chatToEMAccount.userId
                                                                                           goodsId:goodsId] ;
                    [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                });
                
            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            }];
        } else {
            [[EMSession sharedInstance] loginWithUsername:emAccount.emUserName password:emAccount.emPassword completion:^{
                
                weakSelf.request = [[NetworkAPI sharedInstance] chatBalance:goodsId completion:^(NSDictionary *accountDict) {
                    
                    EMAccount *chatToEMAccount = [EMAccount createWithDict:accountDict];
//                    if ([chatToEMAccount.emUserName isEqualToString:[Session sharedInstance].emAccount.emUserName] ) {
//                        _$showHUD(@"对不起,聊天功能暂不支持自问自答 ", 1.0f);
//                        return;
//                    }
                    dispatch_async(dispatch_get_main_queue(), ^{

                        ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                              sellerName:chatToEMAccount.username
                                                                                            sellerHeader:chatToEMAccount.avatar
                                                                                            sellerUserId:chatToEMAccount.userId
                                                                                                 goodsId:goodsId];
                        
                        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                    });
                    _$hideHUD();
                } failure:^(XMError *error) {
                    _$showHUD([error errorMsg], 0.8f);
                }];
                
            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            }];
        }
    }
    else {
        _$showProcessingHUD(nil);
        NSArray *userIds = [NSArray arrayWithObjects:[NSNumber numberWithInteger:[Session sharedInstance].currentUserId], nil];
        _request = [[NetworkAPI sharedInstance] getEMAccounts:userIds completion:^(NSArray *accountDicts) {
            
            NSMutableArray *accounts = [[NSMutableArray alloc] init];;
            for (NSDictionary *dict in accountDicts) {
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    [accounts addObject:[EMAccount createWithDict:dict]];
                }
            }
            
            EMAccount *currentUserEMAccount = nil;
            for (NSInteger i=0;i< [accountDicts count]; i++) {
                NSDictionary *dict = [accountDicts objectAtIndex:i];
                if ([dict isKindOfClass:[NSDictionary class]]) {
                    EMAccount *emAccount = [EMAccount createWithDict:dict];
                    if (emAccount.userId == [Session sharedInstance].currentUserId) {
                        currentUserEMAccount = emAccount;
                        break;
                    }
                }
            }
            
            if (currentUserEMAccount) {
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[Session sharedInstance] setUserEMAccount:emAccount];
                    [[EMSession sharedInstance] loginWithUsername:currentUserEMAccount.emUserName password:currentUserEMAccount.emPassword completion:^{
                        
                        weakSelf.request = [[NetworkAPI sharedInstance] chatBalance:goodsId completion:^(NSDictionary *accountDict) {
                            
                            EMAccount *chatToEMAccount = [EMAccount createWithDict:accountDict];
//                            if ([chatToEMAccount.emUserName isEqualToString:[Session sharedInstance].emAccount.emUserName] ) {
//                                _$showHUD(@"对不起,聊天功能暂不支持自问自答 ", 1.0f);
//                                return;
//                            }
                            dispatch_async(dispatch_get_main_queue(), ^{
                                ChatViewController *viewController = [[ChatViewController alloc] initWithChatter:chatToEMAccount.emUserName
                                                                                                      sellerName:chatToEMAccount.username
                                                                                                    sellerHeader:chatToEMAccount.avatar
                                                                                                    sellerUserId:chatToEMAccount.userId
                                                                                                         goodsId:goodsId] ;
                                [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
                            });
                            _$hideHUD();
                        } failure:^(XMError *error) {
                            _$showHUD([error errorMsg], 0.8f);
                        }];
                        
                    } failure:^(XMError *error) {
                        _$showHUD([error errorMsg], 0.8f);
                    }];
                });
            } else {
                _$showHUD(@"注册聊天服务失败，请重试", 0.8f);
            }
        } failure:^(XMError *error) {
            _$showHUD([error errorMsg], 0.8f);
        }];
    }
}

- (void)$$touchFollowButton:(id<MBNotification>)notification userId:(NSNumber*)userId {
    [self followUser:[userId integerValue] isFollow:YES];
}

- (void)$$touchUnFollowButton:(id<MBNotification>)notification userId:(NSNumber*)userId {
    [self followUser:[userId integerValue] isFollow:NO];
}

- (void)$$cancelUserCommand:(id<MBNotification>)notification {
    
}

+ (void)followUser:(NSInteger)userId {
    MBGlobalSendNotificationForSELWithBody(@selector($$touchFollowButton:userId:), [NSNumber numberWithInteger:userId]);
}
+ (void)unfollowUser:(NSInteger)userId {
    MBGlobalSendNotificationForSELWithBody(@selector($$touchUnFollowButton:userId:), [NSNumber numberWithInteger:userId]);
}

+ (void)chatRecoverWithUser:(NSInteger)userId andIsYes:(NSInteger)isYes andGoodsVO:(RecoveryGoodsVo *)goodsVO andBidVO:(HighestBidVo *)bidVO{
    ChatWithUserDO *chatWithUserDO = [[ChatWithUserDO alloc] init];
    chatWithUserDO.userId = userId;
    chatWithUserDO.msg = @"";
    chatWithUserDO.isYes = isYes;
    chatWithUserDO.goodsVO = goodsVO;
    chatWithUserDO.bidVO = bidVO;
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButton:chatWithUserDO:),chatWithUserDO);
}

//在线客服
+ (void)chatWithGroup:(EMAccount *)emAccount isShowDownTime:(BOOL)isShow message:(NSString *)msg isKefu:(BOOL)isKefu{
    ChatWithUserDO *chatWithUserDO = [[ChatWithUserDO alloc] init];
    chatWithUserDO.emAccount = emAccount;
    chatWithUserDO.isConsultant = isShow;
    chatWithUserDO.consultantStr = msg;
    chatWithUserDO.isKefu = isKefu;
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButtonGroup:chatWithUserDO:),chatWithUserDO);
}

+ (void)chatWithGuwen:(NSInteger)userId isGuwen:(BOOL)isGuwen{
    ChatWithUserDO *chatWithUserDO = [[ChatWithUserDO alloc] init];
    chatWithUserDO.isGuwen = isGuwen;
    chatWithUserDO.userId = userId;
    chatWithUserDO.msg = @"";
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButton:chatWithUserDO:),chatWithUserDO);
}

+ (void)chatWithUser:(NSInteger)userId {
    ChatWithUserDO *chatWithUserDO = [[ChatWithUserDO alloc] init];
    chatWithUserDO.userId = userId;
    chatWithUserDO.msg = @"";
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButton:chatWithUserDO:),chatWithUserDO);
}
+ (void)chatWithUser:(NSInteger)userId msg:(NSString*)msg {
    ChatWithUserDO *chatWithUserDO = [[ChatWithUserDO alloc] init];
    chatWithUserDO.userId = userId;
    chatWithUserDO.msg = msg;
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButton:chatWithUserDO:),chatWithUserDO);
}

+(void)chatWithUserHasWXNum:(NSInteger)userId msg:(NSString *)msg adviser:(AdviserPage *)adviser nadGoodsId:(NSString *)goodsId{
    ChatWithUserDO *chatWithUserDO = [[ChatWithUserDO alloc] init];
    chatWithUserDO.userId = userId;
    chatWithUserDO.isYes = 3;
    chatWithUserDO.isConsultant = YES;
    chatWithUserDO.consultantStr = msg;
    chatWithUserDO.adviser = adviser;
    chatWithUserDO.goodsId = goodsId;
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButton:chatWithUserDO:),chatWithUserDO);
}

+ (void)chatWithUserFirst:(NSInteger)userId msg:(NSString*)msg {
    ChatWithUserDO *chatWithUserDO = [[ChatWithUserDO alloc] init];
    chatWithUserDO.userId = userId;
    chatWithUserDO.isYes = 3;
    chatWithUserDO.isConsultant = YES;
    chatWithUserDO.consultantStr = msg;
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButton:chatWithUserDO:),chatWithUserDO);
}

+ (void)chatWithUserJimai:(NSInteger)userId msg:(NSString*)msg isJimai:(BOOL)isJimai{
    ChatWithUserDO *chatWithUserDO = [[ChatWithUserDO alloc] init];
    chatWithUserDO.userId = userId;
    chatWithUserDO.isYes = 3;
    chatWithUserDO.consultantStr = msg;
    chatWithUserDO.isJimai = isJimai;
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButton:chatWithUserDO:),chatWithUserDO);
}

+ (void)chatWithUserFirstHasGoods:(NSInteger)userId msg:(NSString*)msg goodsId:(NSString *)goodsId{
    ChatWithUserDO *chatWithUserDO = [[ChatWithUserDO alloc] init];
    chatWithUserDO.userId = userId;
    chatWithUserDO.isYes = 3;
    chatWithUserDO.isConsultant = YES;
    chatWithUserDO.consultantStr = msg;
    chatWithUserDO.goodsId = goodsId;
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButton:chatWithUserDO:),chatWithUserDO);
}

+ (void)chatBalanceHasUser:(NSString*)goodsId {
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButtonHasUser:goodsId:), goodsId);
}
+ (void)chatBalance:(NSString*)goodsId {
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatButton:goodsId:), goodsId);
}
+ (void)chatWithoutGoodsId:(NSString*)goodsId {
    MBGlobalSendNotificationForSELWithBody(@selector($$touchChatWithoutGoodsId:goodsId:), goodsId);
}

@end


@implementation ChatWithUserDO
@end

@implementation GoodsSingletonCommand {
    HTTPRequest *_request;
}

- (void)likeGoods:(NSString*)goodsId isLike:(BOOL)isLike
{
    if (!_request || [_request isFinished]) {
        if ([goodsId length]>0) {
            _$showProcessingHUD(nil);
            _request = [[NetworkAPI sharedInstance] likeGoods:goodsId isLike:isLike completion:^(NSInteger likeNum,User *likedUser) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:goodsId];
                    if (goodsInfo) {
                        [goodsInfo setIsLiked:isLike];
                        [goodsInfo.stat setLikeNum:likeNum];
                        
                        if (isLike) {
                            [goodsInfo addLikedUser:likedUser];
                        } else {
                            [goodsInfo removeUser:[Session sharedInstance].currentUserId];
                        }
                        
                        MBGlobalSendGoodsInfoChangedNotification(0,goodsId);
                    }
                    
                    if (isLike) {
                         MBGlobalSendMBNotification([MBDefaultNotification objectWithName:NSStringFromSelector(@selector($$handleGoodsLiked:goodsId:)) key:0 body:goodsId]);
                    } else {
                         MBGlobalSendMBNotification([MBDefaultNotification objectWithName:NSStringFromSelector(@selector($$handleGoodsUnLiked:goodsId:)) key:0 body:goodsId]);
                    }
                    
                    NSInteger curUserLikesNum = [Session sharedInstance].currentUser.likesNum;
                    [[Session sharedInstance] setUserLikesNum:isLike?curUserLikesNum+1:curUserLikesNum-1];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"clickLike" object:@(isLike)];
                });
                _$hideHUD();
            } failure:^(XMError *error) {
                _$showHUD([error errorMsg], 0.8f);
            }];
        }
    }
}

- (void)$$touchGoodsLikeButton:(id<MBNotification>)notification goodsId:(NSString *)goodsId
{
    [self likeGoods:goodsId isLike:YES];
}

- (void)$$touchGoodsUnLikeButton:(id<MBNotification>)notification goodsId:(NSString *)goodsId
{
    [self likeGoods:goodsId isLike:NO];
}

- (void)$$cancelGoodsCommand:(id<MBNotification>)notification
{
    [_request cancel];
    _request = nil;
}

+ (void)likeGoods:(NSString*)goodsId
{
    MBGlobalSendNotificationForSELWithBody(@selector($$touchGoodsLikeButton:goodsId:), goodsId);
}

+ (void)unlikeGoods:(NSString*)goodsId
{
    MBGlobalSendNotificationForSELWithBody(@selector($$touchGoodsUnLikeButton:goodsId:), goodsId);
}

@end



@implementation ConsignSingletonCommand {
    HTTPRequest *_request;
}

- (void)$$touchConsignButton:(id<MBNotification>)notification filePaths:(NSArray*)filePaths {
    _$showProcessingHUD(nil);
    _request = [[NetworkAPI sharedInstance] applyOrder:filePaths completion:^(NSInteger totalNum) {
        _$showHUD(@"你的寄售订单已提交成功", 0.8f);
        dispatch_async(dispatch_get_main_queue(), ^{
            [Session sharedInstance].consignOrdersNum = totalNum;
            [AppDirs cleanupConsignsDir];
            MBGlobalSendConsignDidFinishNotification(totalNum);
        });
        _$hideHUD();
    } failure:^(XMError *error) {
        _$showHUD([error errorMsg], 0.8f);
    }];
}

- (void)$$cancelConsignCommand:(id<MBNotification>)notification {
    
}

@end

@implementation ChatSingletonCommand {
    HTTPRequest *_request;
}

- (void)$$touchChatToUserButton:(id<MBNotification>)notification userId:(NSString*)userId
{
    
}

- (void)$$cancelChatCommand:(id<MBNotification>)notification
{
    
}

@end

@implementation LogInCommandInterceptor {
    NSMutableArray *_commandClassArray;
}

- (void)addCommandClass:(Class)commandClass {
    @synchronized(self) {
        if (commandClass && MBClassHasProtocol(commandClass, @protocol(MBCommand))) {
            if (_commandClassArray == nil)
                _commandClassArray = [[NSMutableArray alloc] init];
            [_commandClassArray addObject:commandClass];
        }
    }
}

- (void)removeCommandClass:(Class)commandClass {
    @synchronized(self) {
        [_commandClassArray removeObject:commandClass];
    }
}

- (id)intercept:(id <MBCommandInvocation>)invocation {
    BOOL isLoggedIn = [Session sharedInstance].isLoggedIn;
    if ([_commandClassArray containsObject:invocation.commandClass] && !isLoggedIn) {
        dispatch_async(dispatch_get_main_queue(), ^{
            LoginViewController *presenedViewController = [[LoginViewController alloc] init];
//            CheckPhoneViewController *presenedViewController = [[CheckPhoneViewController alloc] init];
            UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:presenedViewController];
            [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:nil];
        });
    } else {
        id ret = [invocation invoke];
        return ret;
    }
    return 0 ;
}

@end

#define COMMAND_QUEUE (dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0))

void systemInitCommands() {
    [MBDefaultFacade setCommandQueue:COMMAND_QUEUE];
    
    LogInCommandInterceptor *logInCommandInterceptor = [[LogInCommandInterceptor alloc] init];
    [logInCommandInterceptor addCommandClass:[GoodsSingletonCommand class]];
    [logInCommandInterceptor addCommandClass:[ConsignSingletonCommand class]];
    [logInCommandInterceptor addCommandClass:[UserSingletonCommand class]];
    
    [[MBGlobalFacade instance] setInterceptors:[NSArray arrayWithObjects:logInCommandInterceptor, nil]];
    
    [[MBGlobalFacade instance] registerCommand:[GoodsSingletonCommand class]];
    //[[MBGlobalFacade instance] registerCommand:[GoodsShareCommand class]];
    [[MBGlobalFacade instance] registerCommand:[ConsignSingletonCommand class]];
    [[MBGlobalFacade instance] registerCommand:[UserSingletonCommand class]];
}


void _$showHUD(NSString* message, CGFloat hideAfterDelay) {
    if ([NSThread currentThread].isMainThread) {
        [[CoordinatingController sharedInstance] showHUD:message hideAfterDelay:hideAfterDelay];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[CoordinatingController sharedInstance] showHUD:message hideAfterDelay:hideAfterDelay];
        });
    }
    
}
void _$showProcessingHUD(NSString* message) {
    if ([NSThread currentThread].isMainThread) {
        [[CoordinatingController sharedInstance] showProcessingHUD:message];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[CoordinatingController sharedInstance] showProcessingHUD:message];
        });
    }
}

void _$hideHUD() {
    if ([NSThread currentThread].isMainThread) {
        [[CoordinatingController sharedInstance] hideHUD];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [[CoordinatingController sharedInstance] hideHUD];
        });
    }
}


