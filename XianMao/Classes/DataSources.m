//
//  DataSources.m
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "DataSources.h"
#import "UIColor+Expanded.h"


#define DataSourcesThemeColorWithHexString(methodName,colorHexString) \
         + (UIColor*)methodName { \
             static UIColor *color = nil; \
             if (!color) { \
                color = [UIColor colorWithHexString:colorHexString]; \
             } \
             return color; \
         }

#define DataSourcesThemeColorWithObject(methodName,object) \
         + (UIColor*)methodName { \
             static UIColor *color = nil; \
             if (!color) { \
                color = object; \
             } \
             return color; \
         }
#define DataSourcesThemeImage(methodName,imageName) \
         + (UIImage*)methodName { \
             static UIImage *img = nil; \
             if (!img) { \
                img = [UIImage imageNamed:imageName]; \
             } \
             return img; \
         }

#define DataSourcesThemeFontWithSize(methodName,fontSize) \
         + (UIFont*)methodName { \
            static UIFont *font = nil; \
            if (!font) { \
               font = [UIFont systemFontOfSize:fontSize]; \
            } \
            return font; \
         }

@implementation DataSources

//======================================================

DataSourcesThemeColorWithHexString(globalThemeColor,@"523437");
DataSourcesThemeColorWithHexString(globalThemeTextColor,@"c2a79d");//@"D0B87F");//E2BB66
DataSourcesThemeColorWithHexString(globalThemeBackgroundColor,@"F7F7F7");
DataSourcesThemeColorWithHexString(globalThemeBlackColor,@"333333");
DataSourcesThemeColorWithHexString(globalButtonColor,@"efd8a4");
DataSourcesThemeColorWithObject(globalClearColor,[UIColor clearColor]);
DataSourcesThemeColorWithObject(globalWhiteColor,[UIColor whiteColor]);



//======================================================

DataSourcesThemeColorWithHexString(globalPlaceholderBackgroundColor,@"E6E6E6");
DataSourcesThemeImage(globalPlaceHolderLikesAvatar,@"placeholder_likes_avatar.png");
DataSourcesThemeImage(globalPlaceHolderSeller,@"placeholder_seller.png");
DataSourcesThemeImage(globalPlaceHolderFeedImage,@"placeholder_img.png");
DataSourcesThemeImage(globalPlaceHolderFeedSmall,@"placeHolder_feed_small.png");

//======================================================

DataSourcesThemeColorWithHexString(goodsShopPriceTextColor,@"c2a79d");
DataSourcesThemeFontWithSize(goodsShopPriceTextFont,20.f);
DataSourcesThemeColorWithHexString(goodsMarketPriceTextColor,@"666666");
DataSourcesThemeFontWithSize(goodsMarketPriceTextFont,14.f);

//======================================================
DataSourcesThemeImage(goodsTagDanIcon,@"goods_tag_dan.png");
DataSourcesThemeImage(goodsTagConsignIcon,@"goods_tag_consign.png");
DataSourcesThemeImage(goodsTagCertIconReal,@"goods_tag_cert_real.png");
DataSourcesThemeImage(goodsTagGradeIconN,@"goods_tag_gradeN.png");
DataSourcesThemeImage(goodsTagGradeIconA,@"goods_tag_gradeA.png");
DataSourcesThemeImage(goodsTagGradeIconB,@"goods_tag_gradeB.png");
DataSourcesThemeImage(goodsTagGradeIconC,@"goods_tag_gradeC.png");
DataSourcesThemeImage(goodsTagGradeIconS,@"goods_tag_gradeS.png");
DataSourcesThemeImage(goodsTagPaymentIconAlipay,@"goods_tag_payment_alipay.png");
DataSourcesThemeImage(goodsTagPromiseIconBack,@"goods_tag_promise_back.png");
DataSourcesThemeFontWithSize(goodsTagTextFont,11.f);

//======================================================

DataSourcesThemeImage(rightArrowImage,@"right_arrow.png");



//======================================================


+ (UIColor*)colorff5858 {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"ff5858"];
    }
    return color;
}
+ (UIColor*)color181818 {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"181818"];
    }
    return color;
}
+ (UIColor*)color333333 {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"333333"];
    }
    return color;
}

+ (UIColor*)color99999 {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"999999"];
    }
    return color;
}

+ (UIColor*)color666666 {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"666666"];
    }
    return color;
}

+ (UIColor *)colorf9384c{
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"f9384c"];
    }
    return color;
}

+ (UIColor *)colorb2b2b2{
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"b2b2b2"];
    }
    return color;
}

+ (UIColor*)globalPinkColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"ff5858"];
    }
    return color;
}

+ (UIColor*)globalBlackColor{
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"181818"];
    }
    return color;
}




+ (UIColor*)feedsItemSepColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"F7F7F7"];
    }
    return color;
}
+ (UIColor*)feedsUserNickNameTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"181818"];
    }
    return color;
}
+ (UIFont*) feedsUserNickNameTextFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:14.f];
    }
    return font;
}
+ (UIColor*)feedsUserStatTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"aaaaaa"];
    }
    return color;
}
+ (UIFont*) feedsUserStatTextFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:12.f];
    }
    return font;
}
+ (UIImage*)goodsOnSaleTimeImg {
    static UIImage *img = nil;
    if (!img) {
        img = [UIImage imageNamed:@"goods_on_sale_time"];
    }
    return img;
}
+ (UIColor*)goodsOnSaleTimeTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"aaaaaa"];
    }
    return color;
}
+ (UIFont*) goodsOnSaleTimeTextFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:10.f];
    }
    return font;
}
+ (UIFont*) goodsNameTextFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:14.f];
    }
    return font;
}
+ (UIColor*)goodsNameTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"181818"];
    }
    return color;
}
+ (UIFont*) goodsSummaryTextFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:12.f];
    }
    return font;
}
+ (UIColor*)goodsSummaryTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"666666"];
    }
    return color;
}



+ (UIColor*)goodsActionButtonSepLineColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"F2F2F2"];
    }
    return color;
}

+ (UIColor*)goodsActionButtonTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"aaaaaa"];
    }
    return color;
}
+ (UIFont*)goodsActionButtonTextFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:12.f];
    }
    return font;
}

+ (UIImage*)goodsShareImg {
    static UIImage *img = nil;
    if (!img) {
        img = [UIImage imageNamed:@"share"];
    }
    return img;
}
+ (UIImage*)goodsCommentImg {
    static UIImage *img = nil;
    if (!img) {
        img = [UIImage imageNamed:@"comment"];
    }
    return img;
}
+ (UIImage*)goodsLikedImg {
    static UIImage *img = nil;
    if (!img) {
        img = [UIImage imageNamed:@"liked"];
    }
    return img;
}
+ (UIImage*)goodsLikeImg {
    static UIImage *img = nil;
    if (!img) {
        img = [UIImage imageNamed:@"like"];
    }
    return img;
}

+ (UIImage*)goodsLikesHeadBgImg {
    static UIImage *img = nil;
    if (!img) {
        img = [UIImage imageNamed:@"goods_likes_head_bg"];
    }
    return img;
}
+ (UIImage*)goodsLikesNumBgImg {
    static UIImage *img = nil;
    if (!img) {
        img = [UIImage imageNamed:@"goods_likes_num_bg"];
    }
    return img;
}
+ (UIFont*) goodsLikesNumFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:10.f];
    }
    return font;
}
+ (UIColor*)goodsLikesNumTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor whiteColor];
    }
    return color;
}
+ (UIColor*)goodsLikesNumBackgroundColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"e3e3e3"];
    }
    return color;
}




+ (UIColor*)goodsGallayDescTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"333333"];
    }
    return color;
}

+ (UIFont*) goodsGallayDescFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:11.f];
    }
    return font;
}

+ (UIFont*) commentNickNameFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:14.f];
    }
    return font;
}
+ (UIColor*)commentNickNameTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"181818"];
    }
    return color;
}
+ (UIFont*) commentContentFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:12.f];
    }
    return font;
}
+ (UIColor*)commentContentTextColor  {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"333333"];
    }
    return color;
}



+ (UIColor*)conversationBottomLineColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"f3f3f3"];
    }
    return color;
}

+ (UIColor*)conversationNickNameTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"181818"];
    }
    return color;
}

+ (UIFont*) conversationNickNameTextFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:14.f];
    }
    return font;
}

+ (UIColor*)conversationMessageTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"aaaaaa"];
    }
    return color;
}

+ (UIFont*) conversationMessageTextFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:12.f];
    }
    return font;
}

+ (UIColor*)noticeBottomLineColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"f3f3f3"];
    }
    return color;
}

+ (UIColor*)noticeUnreadTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"181818"];
    }
    return color;
}

+ (UIColor*)noticeTextColor {
    static UIColor *color = nil;
    if (!color) {
        color = [UIColor colorWithHexString:@"999999"];
    }
    return color;
}

+ (UIFont*) noticeNameTextFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:13.f];
    }
    return font;
}

+ (UIFont*) noticeTextFont {
    static UIFont *font = nil;
    if (!font) {
        font = [UIFont systemFontOfSize:13.f];
    }
    return font;
}




@end
