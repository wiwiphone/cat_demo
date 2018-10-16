//
//  SkinIconManager.h
//  XianMao
//
//  Created by apple on 17/1/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger const KTabbar1_N = 1;
static NSInteger const KTabbar1_S = 2;
static NSInteger const KTabbar2_N = 3;
static NSInteger const KTabbar2_S = 4;
static NSInteger const KTabbar3_N = 5;
static NSInteger const KTabbar3_S = 6;
static NSInteger const KTabbar4_N = 7;
static NSInteger const KTabbar4_S = 8;
static NSInteger const KTabbar5_N = 9;
static NSInteger const KTabbar5_S = 10;
static NSInteger const KTabbar1_Text = 11;
static NSInteger const KTabbar2_Text = 12;
static NSInteger const KTabbar3_Text = 13;
static NSInteger const KTabbar4_Text = 14;
static NSInteger const KTabbar5_Text = 15;
static NSInteger const KTabbar_TextColor_N = 16;
static NSInteger const KTabbar_TextColor_S = 17;
static NSInteger const KTabbar_Backgroud = 18;
static NSInteger const KTopbar_Backgroud = 19;
static NSInteger const KTopbar_RightImg_Black = 20;
static NSInteger const KTopbar_LeftImg_Black = 21;
static NSInteger const KTopbar_RightImg_White = 22;
static NSInteger const KTopbar_LeftImg_White = 23;
static NSInteger const KMine_Purse = 24;
static NSInteger const KMine_Consultant = 25;
static NSInteger const KMine_Ticket = 26;
static NSInteger const KMine_Heart = 27;
static NSInteger const KTabbar_BackgroudImg = 28;
static NSInteger const KTopbar_BackgroudImg = 29;
static NSInteger const KTopbar_TitleColor = 30;
static NSInteger const KIdle_SiftTitleColor_N = 31;
static NSInteger const KIdle_SiftTitleColor_S = 32;
static NSInteger const KIdle_SiftBottomLineColor = 33;
static NSInteger const KIdle_TopBarLeftImg = 34;
static NSInteger const KIdle_TopBarRightImg = 35;
static NSInteger const KMessage_TopBarRightImg = 36;
static NSInteger const KMine_TopBarRightImg = 37;
static NSInteger const KMine_TopBarLeftImg = 38;

@interface SkinIconManager : NSObject

+ (instancetype)manager;
-(void)loadSkinIcon;

-(void)setPath:(NSString *)path;
-(NSString *)getPath;

-(BOOL)getTabbarType;
-(NSString *)getPicturePath:(NSInteger )str;
-(NSString *)getValue:(NSInteger)keyNum;
-(NSString *)skin:(NSString *)str;
-(BOOL)isValidWithPath:(NSInteger)PicturePath;

@end
