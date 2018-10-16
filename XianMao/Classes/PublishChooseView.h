//
//  PublishChooseView.h
//  yuncangcat
//
//  Created by WJH on 16/10/10.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PublishChooseView : UIImageView

@property (nonatomic, copy) void(^handlePublishNewGoods)();
@property (nonatomic, copy) void(^handleSaveDraft)();

@end
