//
//  Version.h
//  XianMao
//
//  Created by simon on 11/25/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef XIANMAOPRO
#define APP_VERSION @"1.9"
#else
#define APP_VERSION @"3.9.4"
#endif

#define API_VERSION @"v30"

#define APP_ITUNES_URL @"https://itunes.apple.com/us/app/ai-ding-mao/id939116402?ls=1&mt=8"

////#发现
//#define NEWS_URL @"http://activity.aidingmao.com/app/news.html"
//
////#发现专题里的详情页面
//#define DETAIL_URL @"http://activity.aidingmao.com/app/news_detail.html"
//
////#爱丁猫规则
//#define RULES_URL @"http://activity.aidingmao.com/app/rules.html"
//
////#爱丁猫协议
//#define AGREEMENT_URL @"http://activity.aidingmao.com/app/agreement.html"
//
////#faq页面
//#define FAQ_URL @"http://activity.aidingmao.com/app/faq.html"



@interface Version : NSObject

@end



//v 1.1.1
//click_recommand_feeds,点击/切换到精选tab,0
//click_favor_feeds,点击/切换到关注tab,0
//click_just_in_feeds,点击/切换到最新tab,0
//click_flash_sold_feeds,点击限时降价,0

//click_item_from_recommand_feeds,精选商品feeds流点击单品,0
//click_want_from_recommand_feeds,精选商品feeds流点击想要,0
//click_item_from_favor_feeds,关注商品feeds流点击单品,0
//click_want_from_favor_feeds,关注商品feeds流点击想要,0
//click_item_from_just_in_feeds,最新商品feeds流点击单品,0
//click_want_from_just_in_feeds,最新商品feeds流点击想要,0

//click_share_from_detail,商品详情页点击分享,0
//click_follow_from_detail,商品详情页点击关注卖家,0
//click_want_from_detail,商品详情页点击想要,0
//click_seller_from_detail,商品详情页点击卖家,0

//click_sell_tab,点击发布商品tab,0
//click_sell_button,点击发布商品按钮,0
//click_my_belongs_from_mine,我的点击我买的商品,0
//click_on_sell_from_mine,我的点击我卖的商品,0
//click_coupon_from_mine,我的点击优惠券,0


