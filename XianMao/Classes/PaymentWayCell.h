//
//  PaymentWayCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"

@protocol PaymentWayCellDelegate <NSObject>

-(void)showPaymentWay:(UISwitch *)sw;
-(void)dismissPaymentWay:(UISwitch *)sw;

@end

@interface PaymentWayCell : BaseTableViewCell

@property (nonatomic,strong) UILabel * paymentWayLbl; //是否报价到付
@property (nonatomic,strong) UISwitch * sw; //选择开关
@property (nonatomic,weak) id<PaymentWayCellDelegate> delegate;
//@property (nonatomic, strong) HPGrowingTextView *textF;

+(NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary *)buildCellDict;
-(void)updateCellWithDict:(NSDictionary *)dict;
@end
