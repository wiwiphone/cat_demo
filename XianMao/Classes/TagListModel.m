//
//  TagListModel.m
//  XianMao
//
//  Created by 阿杜 on 16/9/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "TagListModel.h"
#import "FqParamsModel.h"

@implementation TagListModel


-(id)initWithJSONDictionary:(NSDictionary *)dict{
    self = [super initWithJSONDictionary:dict];
    if (self) {
        
        NSMutableArray *dataArray = [[NSMutableArray alloc] init];
        NSArray *dictArray = [dict arrayValueForKey:@"fqParams"];
        if ([dictArray isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dictTmp in dictArray) {
                if ([dictTmp isKindOfClass:[NSDictionary class]]) {
                    FqParamsModel * model = [FqParamsModel createWithDict:dictTmp];
                    [dataArray addObject:model];
                }
            }
        }
        _fqParams = dataArray;
        NSDictionary * recommendDict = dict[@"recommendVo"];
        if (recommendDict && [recommendDict isKindOfClass:[NSDictionary class]]) {
            self.recomendInfo = [RecommendInfo createWithDict:recommendDict];
        }
        
    }
    return self;
}

@end
