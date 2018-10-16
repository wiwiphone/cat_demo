//
//  AddBandCardViewController.h
//  yuncangcat
//
//  Created by 阿杜 on 16/8/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "WithdrawalsAccountVo.h"


@interface AddBandCardViewController : BaseViewController

@property (nonatomic, strong) WithdrawalsAccountVo * withdrawalsVo;
@property (nonatomic, assign) BOOL isFirst;

@end



@interface liebetweenTextField : UITextField

-(void)setPlaceholder:(NSString *)placeholderString;
@end
