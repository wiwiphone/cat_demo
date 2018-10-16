//
//  SideSlipRedirectInfoView.m
//  XianMao
//
//  Created by WJH on 16/11/22.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SideSlipRedirectInfoCell.h"
#import "RecommendTableViewCell.h"


@interface SideSlipRedirectInfoCell()

@property (nonatomic, strong) SideSlipRedirectInfoView * view;
@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation SideSlipRedirectInfoCell

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:16.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(SideSlipRedirectInfoView *)view
{
    if (!_view) {
        _view = [[SideSlipRedirectInfoView alloc] initWithFrame:self.bounds];
    }
    return _view;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self.contentView addSubview:self.view];
        [self.contentView addSubview:self.titleLbl];
    }
    return self;
}


-(void)update:(RedirectInfo *)redirectInfo{
    
    if ([redirectInfo isNewComposition]) {
        self.titleLbl.hidden = NO;
        self.titleLbl.text = redirectInfo.title;
        self.view.frame = CGRectMake(0, 0, self.width, self.height-kisNewCompositionHeight);
        [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_bottom).offset(14);
            make.centerX.equalTo(self.contentView.mas_centerX);
        }];
    } else {
        self.titleLbl.hidden = YES;
        self.view.frame = self.bounds;
    }
    
    if (redirectInfo.width > 0 && redirectInfo.height > 0) {
        [self.view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake(kScreenWidth/320*redirectInfo.width, kScreenWidth/320*redirectInfo.height)];
    } else {
        [self.view updateWithRedirectInfo:redirectInfo imageSize:CGSizeMake(147, 90)];
    }
    
    
}

@end
