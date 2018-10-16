//
//  PriceNumberKeyboardView.h
//  XianMao
//
//  Created by Marvin on 17/3/24.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^inputPrice)(NSString *yuanPrice, NSString *jianyiPrice);
typedef void(^dissmissKeyboard)();

@interface PriceNumberKeyboardView : UIView

@property (nonatomic, copy) inputPrice inputPrice;
@property (nonatomic, copy) dissmissKeyboard dissmissKeyboard;
@property (nonatomic, strong) UITextField * yuanjiaTf;
@property (nonatomic, strong) UITextField * jianyiTf;

- (void)showInView:(UIView *)contentView;

@end
