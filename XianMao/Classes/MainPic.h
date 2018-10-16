//
//  MainPic.h
//  XianMao
//
//  Created by apple on 16/1/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface MainPic : JSONModel

@property (nonatomic, assign) NSInteger pic_id;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@end
