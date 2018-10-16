//
//  InsureViewController.h
//  XianMao
//
//  Created by apple on 16/1/25.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"

@interface InsureViewController : BaseViewController

-(void)getGoodsID:(NSString *)goodsID;

@property (nonatomic, copy) NSString *goodsID;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, assign) NSInteger index;
//@property (nonatomic, assign) BOOL tagYes;

@end
