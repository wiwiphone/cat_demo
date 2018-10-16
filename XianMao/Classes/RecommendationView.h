//
//  RecommendationView.h
//  XianMao
//
//  Created by 阿杜 on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecommendationView : UIView

@property (nonatomic, copy) void(^didSelectCollectionViewCell)(NSString * goodId);

-(instancetype)initWithFrame:(CGRect)frame adviserModel:(NSMutableArray *)adviser;


@end
