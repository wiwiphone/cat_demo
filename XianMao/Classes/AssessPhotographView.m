//
//  AssessPhotographView.m
//  XianMao
//
//  Created by WJH on 17/1/20.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "AssessPhotographView.h"
#import "Command.h"

@interface AssessPhotographView()

@property (nonatomic, strong) CommandButton * photographBtn;

@end

@implementation AssessPhotographView

- (CommandButton *)photographBtn{
    if (!_photographBtn) {
        _photographBtn = [[CommandButton alloc] init];
    }
    return _photographBtn;
}

- (instancetype)init{
    if (self = [super init]) {
        
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Assess_bg"]];
        [self addSubview:self.photographBtn];
        
        WEAKSELF
        self.photographBtn.handleClickBlock = ^(CommandButton * sender){
            
            if (weakSelf.handlePhotographBtnBlock) {
                weakSelf.handlePhotographBtnBlock();
            }
            
        };
        
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.photographBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(300, 300));
    }];
}

@end
