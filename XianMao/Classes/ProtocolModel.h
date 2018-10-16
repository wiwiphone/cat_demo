//
//  ProtocolModel.h
//  XianMao
//
//  Created by 阿杜 on 16/7/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface ProtocolModel : JSONModel

@property(nonatomic,copy) NSString * type;
@property(nonatomic,copy) NSString * title;
@property(nonatomic,copy) NSArray * items;

@end
