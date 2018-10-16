//
//  GoodsCommentsViewController.h
//  XianMao
//
//  Created by simon cai on 13/10/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentVo.h"

@interface GoodsCommentsViewController : BaseViewControllerHandleMemoryWarning
@property(nonatomic,copy) NSString *goodsId;
@end


@interface GoodsCommentVoWrapper : NSObject
@property(nonatomic,strong) CommentVo *comment;
@property(nonatomic,copy) NSString *goodsId;
@end