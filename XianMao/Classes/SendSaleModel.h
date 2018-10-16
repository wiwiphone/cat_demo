//
//  SendSaleModel.h
//  XianMao
//
//  Created by apple on 16/5/26.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"

@interface SendSaleModel : JSONModel

@property (nonatomic, assign) NSInteger auditing;
@property (nonatomic, assign) NSInteger auditPass;
@property (nonatomic, assign) NSInteger closed;
@property (nonatomic, assign) NSInteger comeBack;
@property (nonatomic, assign) NSInteger consignment;
@property (nonatomic, assign) NSInteger deleted;
@property (nonatomic, assign) NSInteger noAudit;
@property (nonatomic, assign) NSInteger removed;
@property (nonatomic, assign) NSInteger sellOut;
@property (nonatomic, assign) NSInteger waitFor;

@end
