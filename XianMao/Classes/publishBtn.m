//
//  publishBtn.m
//  yuncangcat
//
//  Created by 阿杜 on 16/8/18.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "publishBtn.h"
#import "Command.h"


@interface publishBtn()



@end

@implementation publishBtn

-(CommandButton *)publishBtn{
    if (!_publishBtn) {
        _publishBtn = [[CommandButton alloc] init];
        _publishBtn.backgroundColor = [DataSources colorf9384c];
        _publishBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_publishBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_publishBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _publishBtn.layer.masksToBounds = YES;
        _publishBtn.layer.cornerRadius = 6;
    }
    return _publishBtn;
}

-(instancetype)init
{
    if (self = [super init]) {

        [self addSubview:self.publishBtn];

        WEAKSELF
        self.publishBtn.handleClickBlock = ^(CommandButton *sender){
            if (weakSelf.buttonClick) {
                weakSelf.buttonClick();
            }
        };

    }
    return self;
}




-(void)layoutSubviews{
    [super layoutSubviews];

    
    [self.publishBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(12);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
    }];
}


@end
