//
//  EMChatGoodsCell.h
//  XianMao
//
//  Created by apple on 16/3/7.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoodsInfo.h"

typedef void (^sendGoodsMessage)();
typedef void(^gotoBoughtViewController)(BaseViewController *payViewController);

@interface EMChatGoodsCell : UITableViewCell

@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property (nonatomic, copy) sendGoodsMessage sendGoodsMessage;
@property (nonatomic, copy) gotoBoughtViewController gotoBoughtViewController;

@end
