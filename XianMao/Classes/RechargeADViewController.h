//
//  RechargeADViewController.h
//  XianMao
//
//  Created by 阿杜 on 16/4/13.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseViewController.h"
#import "PayWayDO.h"
#import "Command.h"

@interface RechargeADViewController : BaseViewController

@end

@interface SelectView : UIView

@property(nonatomic, strong) UIImageView *photoImageView;
@property(nonatomic, strong) UILabel *titleLB;
@property(nonatomic, strong) CommandButton *flgBtn;
@property (nonatomic, strong) PayWayDO *payWayDO;

- (instancetype)initWithFrame:(CGRect)frame andImage:(UIImage *)image andTitle:(NSString *)title;

@end
