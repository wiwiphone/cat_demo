//
//  PublishPromptView.h
//  yuncangcat
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^disPublishPrompt)();

@interface PublishPromptView : UIView

@property (nonatomic, copy) disPublishPrompt disPublishPrompt;

@end
