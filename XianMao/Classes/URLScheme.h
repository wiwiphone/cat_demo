//
//  URLScheme.h
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Session.h"

#import "SearchFilterInfo.h"

@interface URLScheme : NSObject

+ (BOOL)locateWithRedirectUri:(NSString*)redirectUri andIsShare:(BOOL)share;
+ (BOOL)locateWithRedirectUriImpl:(NSString*)redirectUri andIsShare:(BOOL)share;
+ (BOOL)locateWithHtml5Url:(NSString*)urlString andIsShare:(BOOL)share;
+ (BOOL)locateWithRedirectUriImpl:(NSString*)redirectUri
                       andIsShare:(BOOL)share
                       isScanCode:(BOOL)isScanCode;
+ (BOOL)locate:(NSString*)url;
+ (NSDictionary*)locatorMap;

@end

#define kURLSchemeUserHome(userId) [NSString stringWithFormat:@"aidingmao://user/home/?userid=%d",userId]
#define kURLSchemeUserFans(userId) [NSString stringWithFormat:@"aidingmao://user/fans/?userid=%d",userId]
#define kURLSchemeUserFollowings(userId) [NSString stringWithFormat:@"aidingmao://user/followings/?userid=%d",userId]

#define kURLSchemeUserQuan(code) [NSString stringWithFormat:@"aidingmao://bonus/quan/?code=%@",code]

#define kURLSchemeGoodsDetail(goodsId) [NSString stringWithFormat:@"aidingmao://goods/detail/?goodsid=%@",goodsId]
#define kURLSchemeGoodsList(module,path) [NSString stringWithFormat:@"aidingmao://goods/list/?module=%@&path=%@&title=%@",module,path,title]

#define kURLSchemeSearch(title,queryKey,queryValue) [NSString stringWithFormat:@"aidingmao://search/list/?title=%@&query_key=%@&query_value=%@",title?title:@"",queryKey?queryKey:@"",queryValue?queryValue:@""]


#define kURLSchemeCallPhone(phoneNumber) [NSString stringWithFormat:@"aidingmao://app/call/?phonenumber=%@",phoneNumber]
#define kURLSchemeShare(title,desc,url) [NSString stringWithFormat:@"aidingmao://app/share/?params=%@",phoneNumber] {title, desc, url, } url encode

//发现页面
//#define kURLExplore @"http://activitytest.aidingmao.com/share/page/38"
#define kURLExplore @"https://activity.aidingmao.com/app/discovery.html"
//#define kURLExplore @"http://activitytest.aidingmao.com/app/discovery.html"

//爱丁猫规则
#define kURLRules @"https://activity.aidingmao.com/app/rules.html"

//爱丁猫协议
#define kURLAgreement @"https://activity.aidingmao.com/app/agreement.html"
#define kURLRecharge @"https://activity.aidingmao.com/share/page/1061"
#define kUrlAgreeDingDan @"http://activity.aidingmao.com/share/page/926"

#define kURLSale @"https://activity.aidingmao.com/share/page/63" //售卖的

#define kURLGradeIntro @"https://activity.aidingmao.com/share/page/66" //成色url

//faq页面
#define kURLFaq @"https://activity.aidingmao.com/app/faq.html"

//版权信息页面
#define kURLCopyright @"https://activity.aidingmao.com/app/copyright.html"

//物流信息查看页
#define kURLLogisticsFormat(orderId) [NSString stringWithFormat:@"http://activity.aidingmao.com/app/logistics.html?order_id=%@",orderId]

//分享商品详情页面
#define kURLGoodsDetailFormat(goodsId) [NSString stringWithFormat:@"http://activity.aidingmao.com/share/goods/detail/%@.html",goodsId]

//个人页
#define kURLUserHomePrefix @"https://m.aidingmao.com/seller/index?user_id="
#define kURLUserHome(userId) [NSString stringWithFormat:@"http://m.aidingmao.com/seller/index?user_id=%ld",(long)userId]
#define kURLAdmUserHome(userId) [NSString stringWithFormat:@"http://m.aidingmao.com/admmarket/market/%ld",(long)userId]


#define kCustomServicePhone @"4009976876"
#define kCustomServicePhoneDisplay @"400-997-6876"

#define kAppShareUrl @"https://activity.aidingmao.com/app/download.html"

#define kSendBackUrl [NSString stringWithFormat:@"https://activity.aidingmao.com/act/repurchase/getAccess?user_id=%ld",(long)[Session sharedInstance].currentUserId]

#define kURLSchemeHttpURL @"https://activity.aidingmao.com/"
#define kURLSchemeHttpsURL @"https://activity.aidingmao.com/"
#define kURLSchemeAidingmao @"aidingmao://"


//http://activity.aidingmao.com/share/goods/detail/03144524161407500135.html
#define kURLSchemeHttpURLShared @"https://activity.aidingmao.com/share/goods/detail/"

//http://m.aidingmao.com/goods/detail/03144524161407500135.html
#define kURLSchemeHttpURLM @"https://m.aidingmao.com/goods/detail/"







