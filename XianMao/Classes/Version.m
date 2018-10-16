//
//  Version.m
//  XianMao
//
//  Created by simon on 11/25/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "Version.h"

@implementation Version

@end




/*
 
 
 接口1：banner, 
     请求：param:业务字符串 (feed)
       {[img_url:"", redirect_url:"h5"],[]}
 
 
 接口1：activty
      请求：要多少个  列表一样的逻辑
      {goods_info:{}, activity_price, start_time,end_time, remain_time:{int 精确到秒}， is_finished}
 
 接口1：
   
      {
        cate_info:{cate_id: cate_name: cate_summary: cate_image: cate_logo: },
        {module:"search", path:"list" param:""} 分页逻辑都一样
      }
      {
        {module:"category", path:"list" param:"cate_id=1111"} 分页逻辑都一样
      }
 
 
 */


