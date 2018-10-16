//
//  PublishViewController.h
//  yuncangcat
//
//  Created by apple on 16/7/22.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "PictureItemsEditView.h"
#import "PhotoTableViewCell.h"

@interface PublishViewController : BaseViewController

@property (nonatomic, copy) NSString *goodsId;
@property (nonatomic, copy) NSString *orderId;
@property(nonatomic,copy) void(^handlePublishGoodsFinished)(GoodsEditableInfo *goodsEditableInfo);
@property(nonatomic,assign) BOOL isEditGoods;
@property (nonatomic, assign) BOOL isResell;
@property (nonatomic, assign) BOOL isFromDraft;

@end
