//
//  AppDirs.h
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppDirs : NSObject

+ (NSString*)cacheDirWith:(NSString*)subDir usingUserPrivateDir:(BOOL)usingUserPrivateDir;

+ (void)cleanupDir:(NSString*)dir;
+ (void)removeFile:(NSString*)filePath;
+ (void)cleanupFeedBackDir;
+ (void)cleanupTempDir;
+ (NSString*)tempDir;

+ (UIImage*)image:(NSString*)fileFullPath;
+ (NSString*)saveImage:(UIImage*)image
                   dir:(NSString*)dir
              fileName:(NSString*)fileName
         fileExtention:(NSString*)fileExtention;

+ (void)clearupSeekDir;
+ (void)cleanupConsignsDir;
+ (void)cleanupAssessImageDir;
+ (void)clearupConsignmentDir;
+ (NSString*)consignsDir;
+ (NSString*)saveConsignsPicture:(UIImage*)image fileName:(NSString*)fileName;
+ (NSString*)savePublishGoodsPicture:(UIImage*)image fileName:(NSString*)fileName;
+ (NSString*)saveConsignmentPicture:(UIImage*)image fileName:(NSString*)fileName;
+ (NSString*)savefeedBackPicture:(UIImage*)image fileName:(NSString*)fileName;
+ (NSString*)saveSeekPicture:(UIImage*)image fileName:(NSString*)fileName;
+ (NSInteger)fileSize:(NSString*)filePath;
+ (float)fileSizeK:(NSString*)filePath;


//cache file
+ (NSString*)currentAccountCacheFile;
+ (NSString*)emLoginInfoCacheFile;
+ (NSString*)publishGoodsCacheFile;
+ (NSString*)shoppingCartItemsCacheFile;
+ (NSString*)defaultAddressCacheFile;
+ (NSString *)assessImageDir;
+ (NSString*)newNoticeCacheFile;
+ (NSString*)noticeListCacheFile;
+ (NSString*)feedListCacheFile;
+ (NSString*)followingsCacheFile;
+ (NSString*)recommendListCacheFile;
+ (NSString*)publishInfoListCacheFile;
+ (NSString*)feedBackCacheFilePath;
+ (NSString*)recommendLaunchCacheFile;
+ (NSString*)ConsignmentCacheFilePath;
+ (NSString*)easeMobCacheFile;

+ (NSString*)exploreCacheFilePath;

+ (NSString*)publishGoodsCacheFilePath;

+ (NSString*)hotWordsCacheFile; //热门搜索词
+ (NSString*)searchHistoryCacheFile;

+ (NSString*)launchPageDir;
+ (NSString*)launchPageDataFile;

+ (NSString*)chatNoticeCacheFilePath;

+ (NSString*)sensitiveWordsCacheFilePath;

+ (NSString*)currentSkinIconCacheFile;
@end


#define kAppCachesDir [NSString stringWithFormat:@"%@/aidingmao",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]]

//



