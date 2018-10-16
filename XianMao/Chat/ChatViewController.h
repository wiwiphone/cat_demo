//
//  ChatViewController.h
//  XianMao
//
//  Created by simon cai on 11/13/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "User.h"
#import "RecoveryGoodsVo.h"
#import "HighestBidVo.h"
#import "AdviserPage.h"



@interface ChatViewController : BaseViewController

@property (nonatomic, assign) BOOL isKefu;
@property (nonatomic, assign) BOOL isConsultant;
@property (nonatomic, copy) NSString *consultantStr;
@property (nonatomic, strong) AdviserPage *adviserPage;

@property (nonatomic, assign) BOOL isGuwen;
@property (nonatomic, assign) BOOL isJimai;
@property (nonatomic, assign) BOOL isYes;
@property (nonatomic, strong) EMAccount *account;

-(void)getGoodsVO:(RecoveryGoodsVo *)goodsVO andBidVO:(HighestBidVo *)bidVO;

-(instancetype) initWithChatter:(NSString *)chatter Customer:(NSString *)groupName;

- (instancetype)initWithChatter:(NSString *)chatter;

- (instancetype)initWithChatter:(NSString *)chatter
                     sellerName:(NSString*)sellerName
                   sellerHeader:(NSString *)headerImg
                   sellerUserId:(NSInteger )userId
                        message:(NSString *)message;

- (instancetype)initWithChatter:(NSString *)chatter
                     sellerName:(NSString*)sellerName
                   sellerHeader:(NSString *)headerImg
                   sellerUserId:(NSInteger )userId
                        goodsId:(NSString *)goodsId;

@end
