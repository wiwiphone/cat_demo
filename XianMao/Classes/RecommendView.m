//
//  RecommendView.m
//  XianMao
//
//  Created by apple on 16/3/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecommendView.h"
#import "GoodsService.h"

#import "Session.h"
#import "specifiedUser.h"

#import "Error.h"
#import "Masonry.h"
#import "XMWebImageView.h"

@interface RecommendView ()

@property (nonatomic, strong) UIView *topGanyView;
@property (nonatomic, strong) UIView *bottomGanyView;
@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) UILabel *subLbl;
@property (nonatomic, strong) XMWebImageView *userImageView;
@property (nonatomic, strong) UIScrollView *userIconView;
@property (nonatomic, strong) NSArray *speArr;

@end

@implementation RecommendView

-(UIScrollView *)userIconView{
    if (!_userIconView) {
        _userIconView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _userIconView.showsHorizontalScrollIndicator = NO;
    }
    return _userIconView;
}

-(UILabel *)subLbl{
    if (!_subLbl) {
        _subLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _subLbl.font = [UIFont systemFontOfSize:13.f];
        _subLbl.textColor = [UIColor colorWithHexString:@"595757"];
        _subLbl.text = @"回收 估价";
        [_subLbl sizeToFit];
    }
    return _subLbl;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:13.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"595757"];
        _titleLbl.text = @"我们只收奢侈品";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(UIView *)topGanyView{
    if (!_topGanyView) {
        _topGanyView = [[UIView alloc] initWithFrame:CGRectZero];
        _topGanyView.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];
    }
    return _topGanyView;
}

-(UIView *)bottomGanyView{
    if (!_bottomGanyView) {
        _bottomGanyView = [[UIView alloc] initWithFrame:CGRectZero];
        _bottomGanyView.backgroundColor = [UIColor colorWithHexString:@"dbdcdc"];
    }
    return _bottomGanyView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleLbl];
        [self addSubview:self.subLbl];
        
        [self addSubview:self.topGanyView];
        [self addSubview:self.bottomGanyView];
        [self addSubview:self.userIconView];
        [GoodsService getSpecifiedUser:^(NSDictionary *dict) {
            NSArray *speArr = dict[@"get_specified_user"];
            self.speArr = speArr;
            
            if ((self.speArr.count * 45) + (self.speArr.count + 1) * 15 > kScreenWidth) {
                [self.userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.subLbl.mas_bottom).offset(8);
                    make.bottom.equalTo(self.mas_bottom).offset(-5);
                    make.centerX.equalTo(self.mas_centerX);
                    make.width.equalTo(@(kScreenWidth));
                }];
                self.userIconView.contentSize = CGSizeMake((self.speArr.count + 5) * 45 + (self.speArr.count + 1 + 5) * 15, self.userIconView.height);
            } else {
                [self.userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.subLbl.mas_bottom).offset(8);
                    make.bottom.equalTo(self.bottomGanyView.mas_top).offset(-5);
                    make.centerX.equalTo(self.mas_centerX);
                    make.width.equalTo(@((self.speArr.count * 45) + (self.speArr.count + 1) * 15));
                }];
            }
            
            for (int i = 0; i < speArr.count; i++) {
                specifiedUser *speUser = [[specifiedUser alloc] initWithJSONDictionary:speArr[i]];
                XMWebImageView *userImageView = [[XMWebImageView alloc] initWithFrame:CGRectMake(15 * (i + 1) + (45 * i), (self.userIconView.height - 45)/2, 45, 45)];
                userImageView.layer.masksToBounds = YES;
                userImageView.layer.cornerRadius = 45/2.f;
                [userImageView sd_setImageWithURL:[NSURL URLWithString:speUser.avatar] placeholderImage:nil];
                userImageView.backgroundColor = [UIColor grayColor];
                [self.userIconView addSubview:userImageView];
                userImageView.frame = CGRectMake(15 * (i + 1) + (45 * i), 5, 45, 45);
                userImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
                    [UserSingletonCommand chatWithUserFirst:speUser.userId msg:[NSString stringWithFormat:@"Hi,我是回收达人%@，现在可以把你想让我回收的奢品图片或链接发来我看看哈~(有时咨询比较多，回复不及时亲见谅噢)", speUser.username]];
                };
                
            }
            
        } failure:^(XMError *error) {
            
        }];
        
        
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.topGanyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@9);
    }];
    
    [self.bottomGanyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@9);
    }];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.topGanyView.mas_bottom).offset(10);
    }];
    
    [self.subLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.titleLbl.mas_bottom).offset(8);
    }];
}

@end
