//
//  ShareView.h
//  XianMao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^shareBegin)(NSString *shareName);

@interface ShareView : UIView

-(void)getShareDatas:(NSMutableArray *)shareToSnsNames;
@property (nonatomic, copy) shareBegin shareBegin;

@end
