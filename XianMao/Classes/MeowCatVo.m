//
//  MeowCatVo.m
//  XianMao
//
//  Created by WJH on 17/1/9.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "MeowCatVo.h"

@implementation MeowCatVo


-(NSString *)buttonTitle{
    ////操作类型 0，领养新猫 ；1，立即喂食 2，明天再喂 3，开始补喂
    NSInteger status = self.operateType;
    NSString *title;
    switch (status) {
        case 0:{
            title = @"立即查看  >";
            break;
        }
        case 1:{
            title = @"立即喂食  >";
            break;
        }
        case 2:{
            title = @"立即查看  >";
            break;
        }
        case 3:{
            title = @"快去看看  >";
            break;
        }
            
        default:{
            title = @"";
            break;
        }
    }
    
    return title;
}

-(BOOL)isNeedRemind{
    return self.isRemind == 1?YES:NO;
}

@end
