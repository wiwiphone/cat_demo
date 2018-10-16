//
//  SkinIconManager.m
//  XianMao
//
//  Created by apple on 17/1/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SkinIconManager.h"
#import "NetworkManager.h"
#import "AFNetworking.h"
#import "Session.h"
#import "AppDirs.h"
#import "NetworkAPI.h"

#define DocumentsPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)

static int baseInt = 1;

@implementation SkinIconManager

+ (instancetype)manager{
    static id manager;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

-(void)setPath:(NSString *)path{
    [[NSUserDefaults standardUserDefaults] setObject:path forKey:@"pathName"];
}

-(NSString *)getPath{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"pathName"];
}

-(NSString *)getPicturePath:(NSInteger )str{
    NSArray *paths = DocumentsPath;
    NSString *path = [paths objectAtIndex:0];
    return [NSString stringWithFormat:@"%@/%@/%@", path, [self getPath],[self skin:[NSString stringWithFormat:@"%@%ld", SKIN, (long)str]]];
}

-(BOOL)getTabbarType{
    NSDictionary *dict = [[Session sharedInstance] loadSkinIconData];
    NSString *type = [dict stringValueForKey:@"Type"];
    
    return [type isEqualToString:@"1"] ? YES : NO;
}

-(BOOL)isValidWithPath:(NSInteger)PicturePath{
    BOOL isValid = NO;
    NSString * picPath = [[SkinIconManager manager] getPicturePath:PicturePath];
    if (picPath && picPath.length > 0) {

        NSFileManager* fm = [NSFileManager defaultManager];
        BOOL isDir = NO;
        NSString * path = [NSString stringWithFormat:@"%@.png",picPath];
        if ([fm fileExistsAtPath:path isDirectory:&isDir] == YES) {
            isValid = YES;
        }else{
            isValid = NO;
        }
    }
    
    
    return isValid;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadView" object:nil];
}

-(void)loadSkinIcon{
    
    [[NetworkAPI sharedInstance] downloadSkinIconCompletion:^(NSMutableArray *data) {
        NSMutableArray *skin = data;//[data objectForKey:@"skinIcon"];
        NSMutableDictionary *skinIcon = [[NSMutableDictionary alloc] init];
            
        for (int i = 0; i < skin.count; i++) {
            NSDictionary *dict = skin[i];
            if (i == 0) {
                NSNumber *version = [NSNumber numberWithDouble:[dict doubleValueForKey:@"VERSION"]];
                [skinIcon setObject:version forKey:@"VERSION"];
                continue;
            }
            if (i == 1) {
                NSString *type = [dict stringValueForKey:@"Type"];
                [skinIcon setObject:type forKey:@"Type"];
                continue;
            }
            NSString *skinUrl = [dict stringValueForKey:[NSString stringWithFormat:@"%@%d", SKIN, i-baseInt]];
            NSURL *url = [NSURL URLWithString:skinUrl];
            
            if ([skinUrl rangeOfString:@"http://"].location !=NSNotFound || [skinUrl rangeOfString:@"https://"].location !=NSNotFound) {
                [[SDWebImageManager sharedManager] downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    //处理下载进度
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

                    if (image) {
                        //图片下载完成  在这里进行相关操作，如加到数组里 或者显示在imageView上
                        [skinIcon setObject:image forKey:[NSString stringWithFormat:@"%@%d", SKIN, i-baseInt]];
                    }
                }];
            } else {
                [skinIcon setObject:skinUrl forKey:[NSString stringWithFormat:@"%@%d", SKIN, i-baseInt]];
            }
            if (i == skin.count - 1) {
                [[Session sharedInstance] setSkinIcon:skinIcon];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadView" object:nil];
            }
        }
        
    } failure:^(XMError *error) {
        
    }];
    
}

-(NSString *)getValue:(NSInteger)keyNum{
    NSDictionary *dict = [[Session sharedInstance] loadSkinIconData];
    NSString *returnText;
    if (dict) {
        returnText = [dict stringValueForKey:[NSString stringWithFormat:@"%@%ld", SKIN, (long)keyNum]];
    } else {
        returnText = nil;
    }
    return returnText.length > 0 ? returnText : nil;
}

-(NSString *)skin:(NSString *)str{
    NSDictionary *dict = [[Session sharedInstance] loadSkinIconData];
    NSString *returnText;
    if (dict) {
        returnText = [dict stringValueForKey:str];
    } else {
        returnText = nil;
    }
    return returnText.length > 0 ? returnText : nil;
}

//- (BOOL)isValidUrl:(NSString *)str
//{
//    NSString *regex =@"[a-zA-z]+://[^\\s]*";
//    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"%@ %@", str,regex];
//    return [urlTest evaluateWithObject:self];
//}

@end




/**
 
 VERSION: plist版本 0代表使用默认皮肤
 type: tabbar点击样式 1放大  0默认
 
 SKIN1: tabbar左起图片 1 N
 SKIN2: tabbar左起图片 1 S
 SKIN3: tabbar左起图片 2 N
 SKIN4: tabbar左起图片 2 S
 SKIN5: tabbar左起图片 3 N
 SKIN6: tabbar左起图片 3 S
 SKIN7: tabbar左起图片 4 N
 SKIN8: tabbar左起图片 4 S
 SKIN9: tabbar左起图片 5 N
 SKIN10: tabbar左起图片 5 S
 SKIN11: tabbar左起文字 1
 SKIN12: tabbar左起文字 2
 SKIN13: tabbar左起文字 3
 SKIN14: tabbar左起文字 4
 SKIN15: tabbar左起文字 5
 SKIN16: tabbar文字颜色 N
 SKIN17: tabbar文字颜色 S
 SKIN18: tabbar背景颜色
 
 SKIN19: topbar背景颜色
 SKIN20: 主页topbar右图 B
 SKIN21: 主页topbar左图 B
 SKIN22: 主页topbar右图 W
 SKIN23: 主页topbar左图 W
 
 SKIN24: 个人中心 钱包
 SKIN25: 个人中心 顾问
 SKIN26: 个人中心 卡券
 SKIN27: 个人中心 心动
 
 SKIN28: tabbar 背景
 SKIN29: topbar 背景
 SKIN30: topbar 标题颜色
 
 SKIN31: 个人闲置 筛选标题颜色 N
 SKIN32: 个人闲置 筛选标题颜色 S
 SKIN33: 个人闲置 筛选下划线颜色
 SKIN34: 个人闲置 topbar 左图标
 SKIN35: 个人闲置 topbar 右图标

 SKIN36: 消息 topbar 右图标
 
 SKIN37: 个人中心 topbar 右图标
 SKIN38: 个人中心 topbar 左图标
 */






















/******************************************************一点都不华丽的分割线**********************************************/
/*************************************************************** **************************************************/
/************************************************************* *** **************************************************/
/*********************************************************** ******* **************************************************/
/********************************************************** *** ** ** *************************************************/
/*********************************************************** ******* **************************************************/

//解压
//- (void)downloadZipFiles
//
//{
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        NSURL *url = [NSURL URLWithString:@"https://github.com/MrtFeng/MFNetworking/archive/master.zip"];
//        NSError *error = nil;
//        // 2
//        NSData *data = [NSData dataWithContentsOfURL:url options:0 error:&error];
//        if(!error){
//            // 3
//            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//            NSString *path = [paths objectAtIndex:0];
//            NSString *zipPath = [path stringByAppendingPathComponent:@"zipfile.zip"];
//            self.path = path;
//            self.zipPath = zipPath;
//            [data writeToFile:zipPath options:0 error:&error];
//            [self releaseZipFiles];
//            if(!error){
//                // TODO: Unzip
//            }else{
//                NSLog(@"Error saving file %@",error);
//            }
//        }else{
//            NSLog(@"Error downloading zip file: %@", error);
//        }
//    });
//}
//
//- (void)releaseZipFiles
//
//{
//    
//    ZipArchive *zip = [[ZipArchive alloc]init];
//    
//    //1.在内存中解压缩文件,
//    
//    if([zip UnzipOpenFile:self.zipPath])
//        
//    {
//        
//        //2.将解压缩的内容写到缓存目录中
//        
//        BOOL ret = [zip UnzipFileTo:self.path overWrite:YES];
//        
//        if(NO== ret) {
//            
//            [zip UnzipCloseFile];
//            
//        }
//        
//        //3.使用解压缩后的文件
//        
//        NSString*plistFilePath = [self.path stringByAppendingPathComponent:@"Skin.plist"];
//        
//        
//        //4.更新UI
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //            _headImageView.image= image;
//            //            _IntroduceLabel.text= string;
//        });
//        
//        //        //压缩zip文件,压缩文件名
//        //
//        //        NSString*createZipPath = [self.path stringByAppendingPathComponent:@"myFile.zip"];
//        //
//        //        //判断文件是否存在，如果存在则删除文件
//        //
//        //        NSFileManager * fileManager = [NSFileManager defaultManager];
//        //
//        //        @try
//        //
//        //        {
//        //
//        //            if([fileManager fileExistsAtPath:createZipPath])
//        //
//        //            {
//        //
//        //                if(![fileManager removeItemAtPath:createZipPath error:nil])
//        //
//        //                {
//        //
//        //                    NSLog(@"Delete zip file failure.");
//        //
//        //                }
//        //
//        //            }
//        //
//        //        }
//        //
//        //        @catch(NSException * exception) {
//        //
//        //            NSLog(@"%@",exception);
//        //
//        //        }
//        //
//        //        //判断需要压缩的文件是否为空
//        //
//        //        if(string.length<1)
//        //
//        //        {
//        //
//        //            NSLog(@"The files want zip is nil.");
//        //            
//        //            return ;
//        //            
//        //        }
//        //        
//        //        [zip CreateZipFile2:createZipPath];
//        //        
//        //        //解压缩文件名
//        //        
//        //        [zip addFileToZip:textPath newname:@"Words.txt"];
//        //        
//        //        [zip CloseZipFile2];
//        
//    }
//    
//}



//            NSArray *skinNameArr = [skinUrl componentsSeparatedByString:@"/"];
//            NSString *skinName = [skinNameArr lastObject];


//            AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
//            NSURLRequest *request = [NSURLRequest requestWithURL:url];

//            NSDictionary *skinDict = [[Session sharedInstance] loadSkinIconData];
//            NSLog(@"%@", [NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], skinName]);
//            if ([skinDict objectForKey:[NSString stringWithFormat:@"SKIN%d", i]]) {
//                NSMutableDictionary *skinIcon = [[NSMutableDictionary alloc] init];
//                [skinIcon setObject:[NSString stringWithFormat:@"%@/%@",[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0], skinName] forKey:[NSString stringWithFormat:@"SKIN%d", i]];
//                [[Session sharedInstance] setSkinIcon:skinIcon];
//            } else {


//                NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//                    //监听下载进度
//                    //completedUnitCount 已经下载的数据大小
//                    //totalUnitCount     文件数据的中大小
//                    NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
//                    NSLog(@"targetPath:%@",targetPath);
//                    NSLog(@"fullPath:%@",fullPath);
//
//                    return [NSURL fileURLWithPath:fullPath];
//                } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//                    NSLog(@"%@",filePath);
//                }];
//                //3.执行Task
//                [download resume];
//            }
