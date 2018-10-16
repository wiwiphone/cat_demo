//
//  ChatTabReplyVo.h
//  XianMao
//
//  Created by Marvin on 2017/3/30.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface ChatTabReplyVo : JSONModel

@property (nonatomic, assign) NSInteger adviserId;
@property (nonatomic, assign) NSInteger id;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString * tabTitle;

@end
