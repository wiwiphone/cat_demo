//
//  UserLikesViewController.h
//  XianMao
//
//  Created by simon cai on 11/11/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface UserLikesViewController : BaseViewController

@property(nonatomic,assign) NSInteger userId;
@property (nonatomic, assign) BOOL isHaveTopbar;
@property (nonatomic, copy) NSString *sellerName;
@property (nonatomic, copy) NSString *sellerHeaderImg;
@property (nonatomic, assign) NSInteger sellerId;
@property (nonatomic, assign) BOOL isChatGroup;
@property (nonatomic, copy) NSString *chatter;

@end
