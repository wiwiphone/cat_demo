//
//  AttrListInfo.h
//  yuncangcat
//
//  Created by apple on 16/8/9.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JSONModel.h"

@interface AttrListInfo : JSONModel

@property (nonatomic, copy) NSString *aliasName;
@property (nonatomic, assign) NSInteger attributeId;
@property (nonatomic, copy) NSString *attributeName;
@property (nonatomic, assign) NSInteger subAttributeId;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger valueId;
@property (nonatomic, copy) NSString *valueName;
@property (nonatomic, copy) NSString *logoUrl;

@end
