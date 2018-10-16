//
//  PublishChooseGradeViewController.h
//  yuncangcat
//
//  Created by apple on 16/7/29.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseViewController.h"
#import "GradeDescInfo.h"

@protocol PublishChooseGradeViewControllerDelegate <NSObject>

@optional
-(void)getGrade:(NSString *)grade andDescInfo:(GradeDescInfo *)descInfo;

@end

@interface PublishChooseGradeViewController : BaseViewController

@property (nonatomic, weak) id<PublishChooseGradeViewControllerDelegate> gradeDelegate;
@property (nonatomic, assign) NSInteger cateId;
@property (nonatomic, copy) NSString *grade;
@property (nonatomic, copy) NSString *cateName;

@end
