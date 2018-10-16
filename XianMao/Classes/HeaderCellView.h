//
//  HeaderCellView.h
//  XianMao
//
//  Created by 阿杜 on 16/3/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCellView : UIView

@property (nonatomic, strong) UIImageView *myImageView;
@property (nonatomic, strong) UILabel *myTitleLB;
@property (nonatomic, strong) UILabel *mySubTitleLB;
@property (nonatomic, strong) UILabel *timeLB;

@property (nonatomic, strong) UILabel *numLB;
@property(nonatomic, strong) UIView *lineView;


@property (nonatomic, strong) NSDictionary *dic;

- (void)updateWithDic:(NSDictionary *)dic;

@end
