//
//  TabBarNotification.h
//  VoPai
//
//  Created by simon cai on 10/15/13.
//  Copyright (c) 2013 taobao.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabBarNotification : UIImageView

-(NSInteger)notificationCount;
-(void)addNumOfNotifications:(NSInteger)n;
-(void)removeNumOfNotifications:(NSInteger)n;

@end
