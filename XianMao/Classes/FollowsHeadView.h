//
//  FollowsHeadView.h
//  XianMao
//
//  Created by 阿杜 on 16/8/27.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FollowsHeadView : UIView

@property (nonatomic,copy) void (^SearchFunsOrFollows)(NSString * title);

-(void)getPlaceholderString:(BOOL)isFans;

@end
