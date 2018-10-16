//
//  RecommendVo.h
//  XianMao
//
//  Created by apple on 16/11/30.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "JSONModel.h"
#import "RedirectInfo.h"

@interface RecommendVo : JSONModel

@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *iconUrl;
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,strong) RedirectInfo *moreInfo;
@property(nonatomic,strong) NSMutableArray *list;
@property(nonatomic,assign) long long createTime;

@end
