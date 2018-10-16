//
//  BankAffiliationView.m
//  XianMao
//
//  Created by WJH on 16/11/15.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BankAffiliationView.h"


@interface BankAffiliationView()

@property (nonatomic, strong) UILabel * title;

@end

@implementation BankAffiliationView

-(instancetype)init
{
    if (self = [super init]) {
        _title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        _title.font = [UIFont systemFontOfSize:15];
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.title];
    }
    return self;
}

-(void)setAreaString:(NSString *)areaString
{
    _areaString = areaString;
    
    self.title.text = areaString;
}

@end
