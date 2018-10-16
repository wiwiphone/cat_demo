//
//  DataSources.h
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSources : NSObject

+ (UIColor*)globalThemeColor;
+ (UIColor*)globalThemeTextColor;
+ (UIColor*)globalThemeBackgroundColor;
+ (UIColor*)globalThemeBlackColor;
+ (UIColor*)globalClearColor;
+ (UIColor*)globalWhiteColor;
+ (UIColor*)globalButtonColor;

+ (UIColor*)globalPlaceholderBackgroundColor;
+ (UIImage*)globalPlaceHolderLikesAvatar;
+ (UIImage*)globalPlaceHolderSeller;
//+ (UIImage*)globalPlaceHolderFeedImage;
//+ (UIImage*)globalPlaceHolderFeedSmall;


+ (UIColor*)goodsShopPriceTextColor;
+ (UIFont*) goodsShopPriceTextFont;
+ (UIColor*)goodsMarketPriceTextColor;
+ (UIFont*) goodsMarketPriceTextFont;

+ (UIImage*)goodsTagDanIcon;
+ (UIImage*)goodsTagConsignIcon;
+ (UIImage*)goodsTagCertIconReal;
+ (UIImage*)goodsTagGradeIconN;
+ (UIImage*)goodsTagGradeIconA;
+ (UIImage*)goodsTagGradeIconB;
+ (UIImage*)goodsTagGradeIconC;
+ (UIImage*)goodsTagGradeIconS;
+ (UIImage*)goodsTagPaymentIconAlipay;
+ (UIImage*)goodsTagPromiseIconBack;
+ (UIFont*) goodsTagTextFont;


+ (UIImage*)rightArrowImage;


+ (UIColor*)colorff5858;
+ (UIColor*)color181818;
+ (UIColor*)color99999;
+ (UIColor*)color333333;
+ (UIColor*)color666666;
+ (UIColor *)colorf9384c;
+ (UIColor *)colorb2b2b2;
+ (UIColor*)globalPinkColor;
+ (UIColor*)globalBlackColor;


+ (UIColor*)feedsItemSepColor;

+ (UIColor*)feedsUserNickNameTextColor;
+ (UIFont*) feedsUserNickNameTextFont;
+ (UIColor*)feedsUserStatTextColor;
+ (UIFont*) feedsUserStatTextFont;

+ (UIImage*)goodsOnSaleTimeImg;
+ (UIColor*)goodsOnSaleTimeTextColor;
+ (UIFont*) goodsOnSaleTimeTextFont;

+ (UIFont*) goodsNameTextFont;
+ (UIColor*)goodsNameTextColor;
+ (UIFont*) goodsSummaryTextFont;
+ (UIColor*)goodsSummaryTextColor;

+ (UIColor*)goodsActionButtonSepLineColor;
+ (UIColor*)goodsActionButtonTextColor;
+ (UIFont*) goodsActionButtonTextFont;
+ (UIImage*)goodsShareImg;
+ (UIImage*)goodsCommentImg;
+ (UIImage*)goodsLikedImg;
+ (UIImage*)goodsLikeImg;
+ (UIImage*)goodsLikesHeadBgImg;
+ (UIImage*)goodsLikesNumBgImg;
+ (UIFont*) goodsLikesNumFont;
+ (UIColor*)goodsLikesNumTextColor;
+ (UIColor*)goodsLikesNumBackgroundColor;


+ (UIColor*)goodsGallayDescTextColor;
+ (UIFont*) goodsGallayDescFont;

+ (UIFont*) commentNickNameFont;
+ (UIColor*)commentNickNameTextColor;
+ (UIFont*) commentContentFont;
+ (UIColor*)commentContentTextColor;
//+ (UIColor*)exploreTextColor;


+ (UIColor*)conversationBottomLineColor;
+ (UIColor*)conversationNickNameTextColor;
+ (UIFont*) conversationNickNameTextFont;
+ (UIColor*)conversationMessageTextColor;
+ (UIFont*) conversationMessageTextFont;

+ (UIColor*)noticeBottomLineColor;
+ (UIColor*)noticeUnreadTextColor;
+ (UIColor*)noticeTextColor;
+ (UIFont*) noticeNameTextFont;
+ (UIFont*) noticeTextFont;


@end
