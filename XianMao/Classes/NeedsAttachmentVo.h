//
//  NeedsAttachmentVo.h
//  XianMao
//
//  Created by apple on 17/2/10.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface NeedsAttachmentVo : JSONModel

@property (nonatomic, copy) NSString *pic_desc;
@property (nonatomic, copy) NSString *pic_url;
@property (nonatomic, assign) NSInteger height;
@property (nonatomic, assign) NSInteger width;

@end
