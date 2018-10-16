//
//  ClientVersionService.h
//  XianMao
//
//  Created by darren on 15/1/31.
//  Copyright (c) 2015年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClientVersionService : NSObject<UIAlertViewDelegate>

@property (nonatomic, assign) NSInteger original;
@property (nonatomic, strong)  UIAlertView *alertView;

- (void)checkVersionWithCompletionHandler:(void (^)())completion;


@end
