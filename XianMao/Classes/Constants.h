//
//  Constants.h
//  XianMao
//
//  Created by darren on 15/1/30.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#ifndef XianMao_Constants_h
#define XianMao_Constants_h

#define CHAT_GOODS_PREFIX @"XM_GOODS_"
#define APPSTORE_URL @"https://itunes.apple.com/us/app/ai-ding-mao/id939116402?ls=1&mt=8"


#ifdef XIANMAOPRO

#define UmengAppkey @"57d3b7ade0f55a355a001f74"

#else

#define UmengAppkey @"5486e9e6fd98c55164000243"

#endif


//微信
#define WXAppId    @"wx093f3eb21ceb7937"
#define WXAppSecret @"2ca5a9ff94541ef772d4100da5b2734e"


//// QQ
//#define kQQAPPID @"1103702751"
//#define kQQAPPKEY @"rZBWZq9iGhNlhC8E"
#define kQQAPPID @"1104300138"
#define kQQAPPKEY @"5Tyv3zGvyYi4xiDs"

// sina weibo
#define kWeiboAPPKEY @"1754891286"
#define kWeiboAppSecret @"2a9ed32cf745aa1d7eb11dd53d35271c"



#if DEBUG

#define EaseMobApnsCerName @"adm_dev1703081"
#define EaseMobAppKey @"aidingmao#xianmao"

#else

#define EaseMobApnsCerName @"admPush170308"
#define EaseMobAppKey @"aidingmao#aidingmao"

#endif




#endif


