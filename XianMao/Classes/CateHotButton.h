//
//  CateButton.h
//  XianMao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CateHotButton : UIButton

@property (nonatomic, assign) NSInteger cateId;
@property (nonatomic, copy) NSString *cateName;
@property (nonatomic, copy) NSString *redirect_uri;

@end
