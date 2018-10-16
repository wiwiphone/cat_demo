//
//  SuccessGoodsView.h
//  XianMao
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsEditableInfo.h"

typedef void(^dismissSuccessGoodsView)();

@interface SuccessGoodsView : UIView

-(void)getGoodsEditInfo:(GoodsEditableInfo *)editInfo;

@property (nonatomic, copy) dismissSuccessGoodsView disSuccessGoodsView;

@end
