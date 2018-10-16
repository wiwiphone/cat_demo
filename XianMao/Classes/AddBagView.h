//
//  AddBagView.h
//  XianMao
//
//  Created by apple on 16/5/6.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PushShopBag)();

@interface AddBagView : UIView

@property (nonatomic, copy) PushShopBag pushShopBag;

@end
