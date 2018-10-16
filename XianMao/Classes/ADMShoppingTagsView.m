//
//  ADMShoppingTagsView.m
//  XianMao
//
//  Created by apple on 16/9/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ADMShoppingTagsView.h"
#import "PromiseVo.h"
#import "ServerTag.h"
#import "BlackView.h"
#import "TagsExplanView.h"

@interface ADMShoppingTagsView ()

@property (nonatomic, assign) NSInteger itemNum;
@property (nonatomic, strong) CommandButton *moreBtn;

@property (nonatomic, strong) AutotrophyVo *autotrophyVo;
@end

@implementation ADMShoppingTagsView



-(CommandButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_moreBtn setImage:[UIImage imageNamed:@"omit"] forState:UIControlStateNormal];
        _moreBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [_moreBtn sizeToFit];
    }
    return _moreBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        WEAKSELF;
        [self addSubview:self.moreBtn];
        self.moreBtn.handleClickBlock = ^(CommandButton *sender){
            [[NSNotificationCenter defaultCenter] postNotificationName:@"showTagsExplainView" object:weakSelf.autotrophyVo];
        };
        
    }
    return self;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutSubviews{
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
    }];
    
}



-(void)getTags:(AutotrophyVo *)autotrophyVo{
    self.autotrophyVo = autotrophyVo;
    if (autotrophyVo) {
        CGFloat X = 15;
        CGFloat Y = 5;
        for (int i = 0; i < autotrophyVo.promiseList.count; i++) {
            PromiseVo *promiseVo = autotrophyVo.promiseList[i];
            ServerTag *serverView = [[ServerTag alloc] initWithFrame:CGRectZero title:promiseVo.entry imageUrl:promiseVo.url];
            serverView.frame = CGRectMake(X, Y, serverView.width, serverView.height);
            [serverView sizeToFit];
            X += 70;
            X += 10;
            if (X > kScreenWidth-30) {
                Y += serverView.height;
                Y += 5;
                serverView.frame = CGRectMake(X, Y, serverView.width, serverView.height);
            }
            [self addSubview:serverView];
        }
    }
    
}

@end
