//
//  RentalSubView.m
//  XianMao
//
//  Created by WJH on 16/12/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RentalSubView.h"
#import "BonusInfo.h"


NSString *const deductibleAmountNotification = @"deductibleAmountNotification";

@interface RentalSubView()

@property (nonatomic, strong) BonusInfo * bonusInfo;
@property (nonatomic, assign) double totalPrice;
@property (nonatomic, assign) double deductiblePrice;

@end

@implementation RentalSubView

-(instancetype)initWithFrame:(CGRect)frame title:(NSString *)title{
    if (self = [super initWithFrame:frame title:title]) {
        
        self.tf.tag = 1230;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deductibleAmountNotification:) name:deductibleAmountNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(totalPriceChange:) name:@"totalPriceChange" object:nil];
    }
    return self;
}

- (void)deductibleAmountNotification:(NSNotification *)n{
    
    self.bonusInfo = n.object;
    NSDictionary * dict = n.userInfo;
    
    self.totalPrice = [[dict objectForKey:@"total_price"] doubleValue];
    self.deductiblePrice = [[dict objectForKey:@"deductible_amount"] doubleValue];
  
}

- (void)totalPriceChange:(NSNotification *)n{
    UITextField * tf = n.object;
    if (tf.tag == 1229) {
        self.tf.text = @"";
        NSMutableAttributedString *hintString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",self.tf.text]];
        NSRange range = [[hintString string] rangeOfString:[NSString stringWithFormat:@"¥"]];
        [hintString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"f4433e"] range:range];
        self.tf.attributedText = hintString;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSArray * array = [[textField.text stringByAppendingString:string] componentsSeparatedByString:@"¥"];
    NSString * deductible = [array componentsJoinedByString:@""];
    

    if (self.bonusInfo.canUse) {
        
        
        //优惠券把消费金额全部抵掉的情况
        if (self.totalPrice <= self.self.bonusInfo.amount) {
            return NO;
        }else{
            
            //消费金额大于优惠券抵扣的情况
            if (deductible.doubleValue > (self.totalPrice - self.bonusInfo.amount)) {
                return  NO;
            }else{
                return  YES;
            }
 
        }
  
    }else{
        
        //没优惠券的情况
        if (deductible.doubleValue > self.totalPrice) {
            return  NO;
        }else{
            return  YES;
        }
        
    }

    return YES;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:deductibleAmountNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"totalPriceChange" object:nil];
}

@end
