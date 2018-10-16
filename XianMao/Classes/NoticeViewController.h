//
//  NoticeViewController.h
//  XianMao
//
//  Created by simon on 1/2/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface NoticeViewController : BaseViewControllerHandleMemoryWarning

@property(nonatomic, strong) NSString *titleStr;
@property(nonatomic, assign) NSInteger noticeType;
@property (nonatomic, assign) NSInteger notice_count;

@end


@interface NoticeViewControllerPresented : NoticeViewController

@end