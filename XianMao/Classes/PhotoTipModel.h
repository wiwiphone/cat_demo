//
//  PhotoTipModel.h
//  yuncangcat
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JSONModel.h"

@interface PhotoTipModel : JSONModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSArray *categoryPhotoTipList;

@end
