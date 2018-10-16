//
//  AssessResultView.h
//  XianMao
//
//  Created by apple on 17/1/20.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationVo.h"

@interface AssessResultView : UIView

@property (nonatomic, copy) void(^handSaleActionBlock)();
@property (nonatomic, copy) void(^handAssessAgainBlcok)();
@property (nonatomic, assign) BOOL isNotFound;

- (void)getAssessResultInfo:(EvaluationVo *)evaluationVo image:(UIImage *)image;

@end
