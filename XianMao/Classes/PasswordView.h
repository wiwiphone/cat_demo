//
//  PasswordView.h
//  yuncangcat
//
//  Created by 阿杜 on 16/8/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordView : UIView
/**
 *  页面标题
 */
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL stop;
@property (nonatomic, copy) void(^textFileDidEndedit)(NSString * password);

-(void)show;
- (void)dismiss;
@end
