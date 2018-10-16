//
//  ConversationViewController.h
//  XianMao
//
//  Created by simon on 1/2/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface ConversationViewController : BaseViewControllerHandleMemoryWarning

- (void)refreshDataSource;
- (void)isConnect:(BOOL)isConnect;
- (void)networkChanged:(EMConnectionState)connectionState;

@end
