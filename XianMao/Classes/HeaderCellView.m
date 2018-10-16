//
//  HeaderCellView.m
//  XianMao
//
//  Created by 阿杜 on 16/3/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "HeaderCellView.h"
#import "Masonry.h"

#define kNumLBW (17 / 2.)

@implementation HeaderCellView

- (NSDictionary *)dic {
    if (!_dic) {
        _dic = [NSDictionary dictionary];
    }
    return _dic;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.lineView];
        [self addSubview:self.myImageView];
        [self addSubview:self.myTitleLB];
        [self addSubview:self.mySubTitleLB];
        [self addSubview:self.timeLB];
        
        [self.myImageView addSubview:self.numLB];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.lineView];
        [self addSubview:self.myImageView];
        [self addSubview:self.myTitleLB];
        [self addSubview:self.mySubTitleLB];
        [self addSubview:self.timeLB];
        
//        [self.myImageView addSubview:self.numLB];
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) updateWithDic:(NSDictionary *)dic {
    
    self.dic = [dic copy];
    if (!self.numLB.hidden) {
        [self.myImageView addSubview:self.numLB];
    }
    self.myTitleLB.text = @"系统通知";
    self.mySubTitleLB.text = @"hello 爱丁猫hello 爱丁猫hello 爱丁猫hello 爱丁猫hello 爱丁猫";
    self.timeLB.text = @"20:20";
    self.myImageView.image = [UIImage imageNamed:@"newMessage_01"];
    self.numLB.text = @"1";
    
}

- (void)layoutSubviews {
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(15);
        make.top.equalTo(self.mas_top).offset(10);
        make.width.equalTo(@47);
        make.height.equalTo(@47);
        
    }];
    
    [self.myTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImageView.mas_right).offset(14);
        make.top.equalTo(self.mas_top).offset(17);
    }];
    
    [self.mySubTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTitleLB.mas_bottom).offset(6);
        make.left.equalTo(self.myTitleLB.mas_left);
        make.width.equalTo(@(kScreenWidth - 77 - 100));
    }];
    
    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).offset(kScreenWidth - 19);
        make.top.equalTo(self.myTitleLB.mas_top);
    }];
    
    if (!self.numLB.hidden) {
        [self.numLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.myImageView.mas_top).offset(3);
            make.left.equalTo(self.myImageView.mas_left).offset(35);
            make.width.equalTo(@17);
            make.height.equalTo(@17);
        }];
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    }
    return _lineView;
}

- (UIImageView *)myImageView {
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _myImageView.contentMode = UIViewContentModeScaleAspectFit;
        _myImageView.layer.cornerRadius = 47 / 2.f;
//        _myImageView.clipsToBounds = YES;
    }
    return _myImageView;
}

- (UILabel *)myTitleLB {
    if (!_myTitleLB) {
        _myTitleLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _myTitleLB.font = [UIFont systemFontOfSize:15.f];
        _myTitleLB.textColor = [UIColor colorWithHexString:@"595757"];
        [_myTitleLB sizeToFit];
    }
    return _myTitleLB;
}

- (UILabel *)mySubTitleLB {
    if (!_mySubTitleLB) {
        _mySubTitleLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _mySubTitleLB.font = [UIFont systemFontOfSize:13.0f];
        _mySubTitleLB.textColor = [UIColor colorWithHexString:@"898989"];
        //        [_mySubTitleLB sizeToFit];
    }
    return _mySubTitleLB;
}

- (UILabel *)numLB {
    if (!_numLB) {
        _numLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _numLB.layer.cornerRadius = kNumLBW;
        _numLB.backgroundColor = [UIColor colorWithHexString:@"e83828"];
        _numLB.font = [UIFont systemFontOfSize:11.f];
        _numLB.textColor = [UIColor colorWithHexString:@"ffffff"];
        _numLB.textAlignment = NSTextAlignmentCenter;
        _numLB.clipsToBounds = YES;
        
    }
    return _numLB;
}

- (UILabel *)timeLB {
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLB.font = [UIFont systemFontOfSize:9.f];
        _timeLB.textColor = [UIColor colorWithHexString:@"898989"];
    }
    return _timeLB;
}

@end
