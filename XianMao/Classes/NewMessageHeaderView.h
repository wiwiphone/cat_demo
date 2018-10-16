//
//  NewMessageHeaderView.h
//  XianMao
//
//  Created by 阿杜 on 16/3/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewMessageHeaderView : UIView

@property (nonatomic, strong) NSArray *dataArr;

- (instancetype)initWithArr:(NSArray *)arr;

- (void)updateWithArr:(NSArray *)arr;

@end

