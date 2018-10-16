//
//  SignatureView.m
//  XianMao
//
//  Created by WJH on 17/3/2.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "SignatureView.h"

@interface SignatureView()

@property (nonatomic, strong) UILabel * summaryLbl;

@end

@implementation SignatureView


- (UILabel *)summaryLbl{
    if (!_summaryLbl) {
        _summaryLbl = [[UILabel alloc] init];
        _summaryLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _summaryLbl.font = [UIFont systemFontOfSize:14];
        _summaryLbl.numberOfLines = 0;
        [_summaryLbl sizeToFit];
    }
    return _summaryLbl;
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.summaryLbl];
    }
    return self;
}

- (void)getSignatureText:(NSString *)signature{
    _summaryLbl.text = signature.length > 0 ? signature : @"这家伙很懒，什么都没有留下～";
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.summaryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(5);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
}

@end
