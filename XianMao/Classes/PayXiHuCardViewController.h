//
//  PayXiHuCardViewController.h
//  XianMao
//
//  Created by apple on 16/10/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "AccountCard.h"

@class PayXiHuCardViewController;

typedef void(^selectedAccountCard)(PayXiHuCardViewController *controller, AccountCard *accountCard);

@interface PayXiHuCardViewController : BaseViewController

@property (nonatomic, strong) NSArray *xiHuCardArray;
@property (nonatomic, strong) AccountCard *selectAccountCard;

@property (nonatomic, strong) selectedAccountCard selectedAccountCard;
@end
