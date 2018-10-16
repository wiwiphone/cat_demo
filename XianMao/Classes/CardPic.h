//
//  CardPic.h
//  XianMao
//
//  Created by WJH on 16/10/20.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface CardPic : JSONModel

@property (nonatomic, assign) NSInteger pic_id;
@property (nonatomic, copy) NSString * pic_url;
@property (nonatomic, copy) NSString * pic_desc;
@property (nonatomic, assign) NSInteger width;
@property (nonatomic, assign) NSInteger height;

@end
