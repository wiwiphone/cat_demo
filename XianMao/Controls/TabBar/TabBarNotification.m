//
//  TabBarNotification.m
//  VoPai
//
//  Created by simon cai on 10/15/13.
//  Copyright (c) 2013 taobao.com. All rights reserved.
//

#import "TabBarNotification.h"

@interface TabBarNotification ()

@property(nonatomic,assign) NSInteger notificationCount;
@property(nonatomic,retain) UILabel *notifiNumLbl;
@end

@implementation TabBarNotification

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _notificationCount = 0;
    }
    return self;
}

-(NSInteger)notificationCount {
    return _notificationCount;
}

-(void)addNumOfNotifications:(NSInteger)n {
    if (n > 0) {
        _notificationCount += n;
    }
    [self updateNotifiNumLbl];
}

-(void)removeNumOfNotifications:(NSInteger)n {
    if (n > 0) {
        _notificationCount -= n;
    }
    if (_notificationCount < 0) _notificationCount = 0;
    [self updateNotifiNumLbl];
}

- (void)updateNotifiNumLbl
{
    if (_notificationCount == 0 && _notifiNumLbl)
    {
        [_notifiNumLbl removeFromSuperview];
        _notifiNumLbl = nil;
    }
    else if (_notifiNumLbl > 0)
    {
        if (_notifiNumLbl == nil)
        {
            
        }
    }
}

- (void)dealloc
{
    self.notifiNumLbl = nil;
}

@end
