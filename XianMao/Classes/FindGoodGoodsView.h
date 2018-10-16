//
//  FindGoodGoodsView.h
//  XianMao
//
//  Created by 黄崇国 on 2017/3/6.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedirectInfo.h"

@interface FindGoodGoodsView : UIView

@property (nonatomic, copy) void(^touchFindGoodsView)(RedirectInfo *info);
-(void)getRedirectInfo:(RedirectInfo *)redirectInfo;

@end
