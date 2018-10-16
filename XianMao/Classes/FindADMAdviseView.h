//
//  FindADMAdviseView.h
//  XianMao
//
//  Created by 阿杜 on 16/9/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^successBack)();

@interface FindADMAdviseView : UIView

@property (nonatomic, strong) NSString *searchKey;
@property (nonatomic, copy) successBack successBack;

@end
