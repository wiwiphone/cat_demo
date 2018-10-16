//
//  PBCommon.h
//  XianMao
//
//  Created by simon cai on 11/16/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#if !defined(SYSTEM_VERSION_EQUAL_TO)
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#endif
#if !defined(SYSTEM_VERSION_GREATER_THAN)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#endif
#if !defined(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#endif
#if !defined(SYSTEM_VERSION_LESS_THAN)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#endif
#if !defined(SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
#endif