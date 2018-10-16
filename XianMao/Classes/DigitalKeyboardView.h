//
//  DigitalKeyboardView.h
//  XianMao
//
//  Created by simon cai on 3/11/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NSMutableArray+WeakReferences.h"


@interface DigitalInputContainerView : UIImageView

@end


@interface DigitalKeyboardView : UIView

@property (nonatomic,assign) NSArray *textFieldArray;
@property (nonatomic,assign) DigitalInputContainerView *inputContainerView;

+ (void)showInView:(UIView*)view
inputContainerView:(DigitalInputContainerView*)inputContainerView
    textFieldArray:(NSArray*)textFieldArray
        completion:(void (^)(DigitalInputContainerView *inputContainerView))completion;

+ (void)showInViewFromPublish:(UIView*)view
           inputContainerView:(DigitalInputContainerView*)inputContainerView
               textFieldArray:(NSArray*)textFieldArray
                   completion:(void (^)(DigitalInputContainerView *inputContainerView))completion;

+ (void)showInViewMF:(UIView*)view
inputContainerView:(DigitalInputContainerView*)inputContainerView
    textFieldArray:(NSArray*)textFieldArray
        completion:(void (^)(DigitalInputContainerView *inputContainerView))completion;

+ (void)showInViewBought:(UIView*)view
  inputContainerView:(DigitalInputContainerView*)inputContainerView
      textFieldArray:(NSArray*)textFieldArray
          completion:(void (^)(DigitalInputContainerView *inputContainerView))completion;
@end


//
@interface DigitalPriceInputView : DigitalInputContainerView

@property (nonatomic, strong) UITextField *priceTextField;
@property (nonatomic, strong) UITextField *marketPriceTextField;

@property(nonatomic,assign) NSInteger shopPriceCent;
@property(nonatomic,assign) NSInteger marketPriceCent;

@end



