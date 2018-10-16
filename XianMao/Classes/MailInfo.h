//
//  MailInfo.h
//  XianMao
//
//  Created by WJH on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MailInfo : NSObject

@property(nonatomic,copy) NSString *mailCOM;
@property(nonatomic,copy) NSString *mailSN;

+ (instancetype)createWithDict:(NSDictionary*)dict;
- (instancetype)initWithDict:(NSDictionary*)dict;

@end
