//
//  RecoverCateView.h
//  XianMao
//
//  Created by apple on 16/3/10.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASScroll.h"
#import "RecoveryItem.h"
#import "RecoveryPreference.h"

typedef void(^setCateData)(NSMutableArray *arr);

@protocol RecoverCateViewDelegate <NSObject>

@optional
-(void)setSuccess:(NSMutableArray *)cateArr;

@end

@interface RecoverCateView : UIScrollView

-(void)getInJsonArr:(NSArray *)arr;
-(void)getRecoverPreference:(RecoveryPreference *)preference;
-(void)getRecoverArr:(NSMutableArray *)arr;
@property (nonatomic, copy) setCateData setCateData;
@property (nonatomic, weak) id <RecoverCateViewDelegate> cateDelegate;
@property (nonatomic, strong) RecoveryPreference *preference;

@end

@interface CateButton : UIButton

@property (nonatomic, strong) RecoveryItem *item;
@property (nonatomic, strong) RecoveryPreference *preferenceItem;
@property (nonatomic, copy) NSString *parenceQueryKey;

@end