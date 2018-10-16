//
//  UT.h
//  XianMao
//
//  Created by simon cai on 9/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>


//enter
@interface UT : NSObject

//+(void) setKey:(NSString*)appKey;
+(void) preInit;
+(void) init;
+(void) uninit;
+(void) pageEnter:(NSString*)source page:(NSObject*)page data:(NSDictionary *) data;
+(void) pageLeave:(NSObject*)source page:(NSObject*)page;
+(void) track:(NSString*)source page:(NSString*)page action:(NSString*)action data:(NSDictionary*)data;

@end

//
//home,discover,message,mine
//
//userHome
//shoppingCart
//favor
//following
//followers
//order[买家]
//goodsDetail
//pay
//search
//webview

/*
 
 UT(source,action,page,data)
//DeviceId,userId

 UT("miaosha","enter","webview","",); //h5
 UT("miaosha","enter","goodsDetail","");
 UT("miaosha","enter","shoppingCart","");
 UT("miaosha","enter","pay","");
 UT("miaosha","enter","order","orderid");
 UT("miaosha","exit","order","orderid");
 UT("miaosha","pay","order","orderid");
 //...
 UT("miaosha","exit","webview","",); //h5
 
 
 
*/

