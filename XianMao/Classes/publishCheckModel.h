//
//  publishCheckModel.h
//  XianMao
//
//  Created by 阿杜 on 16/8/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface publishCheckModel : JSONModel

@property (nonatomic,assign) NSInteger pop;
@property (nonatomic,copy) NSString * msg;
@property (nonatomic,assign) NSInteger qualification;
@property (nonatomic,copy) NSString * buttonUrl;
@property (nonatomic,copy) NSString * buttonTxt;

-(instancetype)initWithDict:(NSDictionary *)dict;
+(publishCheckModel *)createWithDict:(NSDictionary *)dict;

@end
