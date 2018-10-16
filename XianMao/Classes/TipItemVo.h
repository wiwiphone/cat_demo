//
//  TipItemVo.h
//  yuncangcat
//
//  Created by apple on 16/8/2.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "JSONModel.h"

@interface TipItemVo : JSONModel

@property (nonatomic, copy) NSString *tip;
@property (nonatomic, strong) NSArray *picGuide;


+(instancetype)modelWithJSONDictionary:(NSDictionary *)dict;
-(id)initWithJSONDictionary:(NSDictionary *)dict;

@end
