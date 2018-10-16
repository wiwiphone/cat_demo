//
//  TagListModel.h
//  XianMao
//
//  Created by 阿杜 on 16/9/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "RecommendInfo.h"


@interface TagListModel : JSONModel

@property (nonatomic, copy) NSString * title;
@property (nonatomic, copy) NSString * logoUrl;
@property (nonatomic, copy) NSString * selectedLogoUrl;
@property (nonatomic, copy) NSString * sort;
@property (nonatomic, strong) NSArray * fqParams;
@property (nonatomic, strong) RecommendInfo * recomendInfo;
@end
