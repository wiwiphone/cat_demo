//
//  AppDirs.m
//  XianMao
//
//  Created by simon cai on 11/4/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "AppDirs.h"
#import "Session.h"

@implementation AppDirs

+ (NSString*)uniqueFileName:(NSString*)dir fileExtention:(NSString*)fileExtention
{
    //这里需要同步，后面再调整，
    @synchronized (self) {
        NSInteger index = 1;
        while (true) {
            NSString *fileName = [NSString stringWithFormat:@"%ld.%@",(long)index,fileExtention];
            if(![[NSFileManager defaultManager] fileExistsAtPath:[dir stringByAppendingPathComponent:fileName]]) {
                return fileName;
            }
            index++;
        }
        return nil;
    }
}

+ (UIImage*)image:(NSString*)fileName dir:(NSString*)dir
{
    NSString *fileFullPath = nil;
    if (fileName != nil && [fileName length] > 0) {
        fileFullPath = [dir stringByAppendingPathComponent:fileName];
        return [self image:fileFullPath];
    }
    return nil;
}

+ (UIImage*)image:(NSString*)fileFullPath
{
    BOOL isDir = NO;
    if ([[NSFileManager defaultManager] fileExistsAtPath:fileFullPath isDirectory:&isDir]) {
        return [UIImage imageWithContentsOfFile:fileFullPath];
    }
    return nil;
}

+ (NSString*)saveImage:(UIImage*)image
                   dir:(NSString*)dir
              fileName:(NSString*)fileName
         fileExtention:(NSString*)fileExtention
{
    if (image) {
        if (fileName==nil||fileName.length==0) {
            fileName = [self uniqueFileName:dir fileExtention:fileExtention];
        }
        NSString *filePath = [dir stringByAppendingPathComponent:fileName];
        float initCompress = 90.f;
//        CGSize sized = image.size;
//        size_t t = CGImageGetBitsPerPixel(image.CGImage);
//        float size = image.size.width * image.size.height * CGImageGetBitsPerPixel(image.CGImage)/(8.f*1024.f);
//        if (size > 300) {
//            initCompress = 10;
//        } else if (size > 260) {
//            initCompress = 20;
//        } else if (size > 220) {
//            initCompress = 30;
//        } else if (size > 180) {
//            initCompress = 40;
//        } else if (size > 140) {
//            initCompress = 50;
//        } else if (size >= 110) {
//            initCompress = 60;
//        } else if (size >= 100) {
//            initCompress = 65;
//        } else if (size >= 90) {
//            initCompress = 70;
//        } else if (size >= 80) {
//            initCompress = 75;
//        } else if (size >= 70) {
//            initCompress = 80;
//        } else if (size >= 60) {
//            initCompress = 85;
//        } else if (size >= 50) {
//            initCompress = 90;
//        }
        
        BOOL ret = [UIImageJPEGRepresentation(image,initCompress/100.f) writeToFile:filePath atomically:YES];
        return filePath;
    }
    return nil;
}

+ (NSString*)saveConsignsPicture:(UIImage*)image fileName:(NSString*)fileName
{
    return [self saveImage:image  dir:[AppDirs consignsDir] fileName:fileName fileExtention:@"jpg" ];
}

+ (NSString*)savefeedBackPicture:(UIImage*)image fileName:(NSString*)fileName
{
    return [self saveImage:image  dir:[AppDirs feedBackCacheFilePath] fileName:fileName fileExtention:@"jpg" ];
}

+ (NSString*)saveConsignmentPicture:(UIImage*)image fileName:(NSString*)fileName
{
    return [self saveImage:image  dir:[AppDirs ConsignmentCacheFilePath] fileName:fileName fileExtention:@"jpg" ];
}

+ (NSString*)saveSeekPicture:(UIImage*)image fileName:(NSString*)fileName
{
    return [self saveImage:image  dir:[AppDirs SeekCacheFilePath] fileName:fileName fileExtention:@"jpg" ];
}

+ (NSString*)savePublishGoodsPicture:(UIImage*)image fileName:(NSString*)fileName
{
    return [self saveImage:image  dir:[AppDirs publishGoodsCacheFilePath] fileName:fileName fileExtention:@"jpg" ];
}

+ (void)cleanupTempDir
{
    NSString *dir = [self tempDir];
    [self cleanupDir:dir];
}
+ (NSString*)tempDir
{
    return [[self class] makeCacheDir:@"temp" usingUserPrivateDir:NO];
}

+ (void)cleanupFeedBackDir
{
    NSString * dir = [self feedBackCacheFilePath];
    [self cleanupDir:dir];
}

+ (void)cleanupAssessImageDir{
    NSString * dir = [self assessImageDir];
    [self cleanupDir:dir];
}

+ (void)clearupConsignmentDir{
    NSString * dir = [self ConsignmentCacheFilePath];
    [self cleanupDir:dir];
}

+ (void)clearupSeekDir{
    NSString * dir = [self SeekCacheFilePath];
    [self cleanupDir:dir];
}

+ (void)cleanupConsignsDir
{
    NSString *dir = [self consignsDir];
    [self cleanupDir:dir];
}
+ (NSString*)consignsDir
{
    return [[self class] makeCacheDir:@"consign" usingUserPrivateDir:NO];
}

+ (NSString*)cacheDirWith:(NSString*)subDir usingUserPrivateDir:(BOOL)usingUserPrivateDir
{
    return [[self class] makeCacheDir:subDir usingUserPrivateDir:usingUserPrivateDir];
}

+ (NSString*)cacheFile:(NSString*)fileName usingUserPrivateDir:(BOOL)usingUserPrivateDir
{
    NSMutableString *dir = [self makeCacheDir:nil usingUserPrivateDir:usingUserPrivateDir];
    if (usingUserPrivateDir
        && [Session sharedInstance].currentUserId>0) {
        [dir appendString:@"/"];
        [dir appendString:[NSString stringWithFormat:@"%ld",
                           (long)[Session sharedInstance].currentUserId]];
    }
    [dir appendString:@"/"];
    [dir appendString:fileName];
    return dir;
    
}

+ (BOOL)isValidFilePth:(NSString *)filepath{
    BOOL isValid = NO;
    if (filepath && filepath.length > 0) {
        NSFileManager* fm = [NSFileManager defaultManager];
        BOOL isDir = NO;
        NSString * path = [NSString stringWithFormat:@"%@",filepath];
        if ([fm fileExistsAtPath:path isDirectory:&isDir] == YES) {
            isValid = YES;
        }else{
            isValid = NO;
        }
    }
    
    return isValid;
}

+ (NSMutableString*)makeCacheDir:(NSString*)dirName usingUserPrivateDir:(BOOL)usingUserPrivateDir
{
    NSMutableString *dir = [[NSMutableString alloc] initWithString:kAppCachesDir];
    
    if (usingUserPrivateDir
        && [Session sharedInstance].currentUserId>0) {
        [dir appendString:@"/"];
        [dir appendString:[NSString stringWithFormat:@"%ld",
                           (long)[Session sharedInstance].currentUserId]];
    }
    
    if (dirName && [dirName length]>0) {
        [dir appendString:@"/"];
        [dir appendString:dirName];
    }
    
    NSFileManager* fm = [NSFileManager defaultManager];
    BOOL isDir = NO;
    BOOL exists = [fm fileExistsAtPath:dir isDirectory:&isDir];
    if (!exists || !isDir) {
        [fm createDirectoryAtPath: dir
      withIntermediateDirectories: YES
                       attributes: nil
                            error: nil];
    }
    return dir;
}

+ (void)cleanupDir:(NSString*)dir
{
    NSFileManager* fm = [NSFileManager defaultManager];
    NSArray* tempArray = [fm contentsOfDirectoryAtPath:dir error:nil];
    for (NSString* fileName in tempArray) {
        NSString* filePath = [dir stringByAppendingPathComponent:fileName];
        BOOL isDir = NO;
        BOOL exists = [fm fileExistsAtPath:filePath isDirectory:&isDir];
        if (exists && !isDir) {
            [fm removeItemAtPath:filePath error:nil];
        } else {
            if (isDir) {
                [[self class] cleanupDir:filePath];
            }
        }
    }
}

+ (void)removeFile:(NSString*)filePath
{
    NSFileManager* fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:filePath]) {
        [fm removeItemAtPath:filePath error:nil];
    }
}


+ (NSInteger)fileSize:(NSString*)filePath {
     NSFileManager * fm = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    if([fm fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        NSDictionary * attributes = [fm attributesOfItemAtPath:filePath error:nil];
        NSNumber *theFileSize =  [attributes objectForKey:NSFileSize];
        return [theFileSize integerValue];
    }
    return 0;
}

+ (float)fileSizeK:(NSString*)filePath {
    float fileSize = [self fileSize:filePath];
    return fileSize/(1024.f);
}

+ (NSString*)currentSkinIconCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:NO],[[SkinIconManager manager] getPath]];
}

+ (NSString*)currentAccountCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:NO],@"account.data"];
}

+ (NSString*)emLoginInfoCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:NO],@"emlogininfo.data"];
}

+ (NSString*)shoppingCartItemsCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:YES],@"shoppingcart.data"];
}

+ (NSString*)defaultAddressCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:YES],@"defaultAddress.data"];
}

+ (NSString*)newNoticeCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:YES],@"notice.data"];
}

+ (NSString*)noticeListCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:YES],@"noticeList.data"];
}

+ (NSString*)feedListCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:NO],@"feedListCaceFile.data"];
}

+ (NSString*)followingsCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:NO],@"followingsCaceFile.data"];
}

+ (NSString*)recommendListCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:NO],@"recommendListCaceFile.data"];
}

+ (NSString*)publishInfoListCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:NO],@"publishInfoListCacheFile.data"];
}

+ (NSString*)recommendLaunchCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:YES],@"recommendLaunchCacheFile.data"];
}

+ (NSString*)easeMobCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:NO],@"easeMobCacheFile.data"];
}

+ (NSString*)exploreCacheFilePath {
    return [self makeCacheDir:@"explore" usingUserPrivateDir:NO];
}

+ (NSString*)publishGoodsCacheFilePath {
    return [self makeCacheDir:@"publishGoods" usingUserPrivateDir:NO];
}

+ (NSString*)feedBackCacheFilePath {
    return [self makeCacheDir:@"feedBack" usingUserPrivateDir:NO];
}

+ (NSString*)ConsignmentCacheFilePath {
    return [self makeCacheDir:@"consignment" usingUserPrivateDir:NO];
}

+ (NSString*)SeekCacheFilePath {
    return [self makeCacheDir:@"seek" usingUserPrivateDir:NO];
}

+ (NSString *)assessImageDir{
    return [self makeCacheDir:@"assesscache" usingUserPrivateDir:NO];
}

+ (NSString*)hotWordsCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:NO],@"hotWords.data"];
}
+ (NSString*)searchHistoryCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:NO],@"searchHistory.data"];
}

+ (NSString*)publishGoodsCacheFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:nil usingUserPrivateDir:YES],@"publishgoods.data"];
}

+ (NSString*)launchPageDir {
    return [self makeCacheDir:@"launch_page" usingUserPrivateDir:NO];
}

+ (NSString*)launchPageDataFile {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:@"launch_page" usingUserPrivateDir:NO],@"list.data"];
}

+ (NSString*)chatNoticeCacheFilePath {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:@"chat" usingUserPrivateDir:NO],@"notice.data"];
}

+ (NSString*)sensitiveWordsCacheFilePath {
    return [NSString stringWithFormat:@"%@/%@",[self makeCacheDir:@"platform" usingUserPrivateDir:NO],@"sensitiveWords.data"];
}

@end



