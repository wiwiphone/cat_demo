//
//  ActionSheet.h
//  XianMao
//
//  Created by simon on 12/13/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ActionSheetButtonClickedBlock)();
typedef void (^ActionSheetOtherButtonClickedBlock)(NSInteger index);

@interface ADMActionSheet : UIActionSheet

/**
 *  初始化方法
 *
 *  @param title                  标题
 *  @param cancelButtonTitle      取消按钮标题
 *  @param destructiveButtonTitle 危险按钮标题
 *  @param otherButtonTitlesArray 其他按钮标题
 *  @param cancelBlock            取消按钮响应block
 *  @param destructiveBlock       危险按钮响应block
 *  @param otherBlock             其他按钮响应block
 *
 *  @return 实例
 */
- (id)initWithTitle:(NSString *)title
  cancelButtonTitle:(NSString *)cancelButtonTitle
destructiveButtonTitle:(NSString *)destructiveButtonTitle
  otherButtonTitles:(NSArray *)otherButtonTitlesArray
        cancelBlock:(ActionSheetButtonClickedBlock)cancelBlock
   destructiveBlock:(ActionSheetButtonClickedBlock)destructiveBlock
         otherBlock:(ActionSheetOtherButtonClickedBlock)otherBlock
       tapMaskBlock:(ActionSheetButtonClickedBlock)tapMaskBlock;


/**
 *  显示
 *
 *  @param view 若view为空，则显示在rootViewController.view
 */
- (void)showInView:(UIView *)view;

@end




