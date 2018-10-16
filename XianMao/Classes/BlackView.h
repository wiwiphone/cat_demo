//
//  BlackView.h
//  XianMao
//
//  Created by apple on 16/1/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^dissMissBlackView)();

@interface BlackView : UIView

@property (nonatomic, copy) dissMissBlackView dissMissBlackView;

@end
