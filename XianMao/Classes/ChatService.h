//
//  ChatService.h
//  XianMao
//
//  Created by simon cai on 14/5/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseService.h"

@interface ChatService : BaseService

+ (void)chatNotice:(NSInteger)userId isAdd:(BOOL)isAdd;

@end


