//
//  IdleListViewController.h
//  XianMao
//
//  Created by Marvin on 2017/4/5.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface IdleListViewController : BaseViewController

@property(nonatomic,copy) NSString *params;


- (void)initDataListLogic:(NSInteger)index title:(NSString *)title;
@end
