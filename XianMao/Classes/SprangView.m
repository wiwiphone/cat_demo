//
//  SprangView.m
//  XianMao
//
//  Created by apple on 16/4/16.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SprangView.h"
#import "Command.h"
#import "Masonry.h"
#import "Session.h"

@interface SprangView ()

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) VerticalCommandButton *releaseNofm;
@property (nonatomic, strong) VerticalCommandButton *releaseRecovery;
@property (nonatomic, strong) VerticalCommandButton *draftPublish;
@property (nonatomic, strong) UILabel *releaseLbl;
@property (nonatomic, strong) UILabel *recoveryLbl;
@property (nonatomic, strong) UILabel *draftLbl;
@property (nonatomic, strong) UIView *centerSView;
@property (nonatomic, strong) UIView *centerSView1;
@property (nonatomic, strong) UIImageView *sharpImageView;

@end

@implementation SprangView

-(UILabel *)draftLbl{
    if (!_draftLbl) {
        _draftLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _draftLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _draftLbl.font = [UIFont systemFontOfSize:11.f];
        _draftLbl.adjustsFontSizeToFitWidth = YES;
        _draftLbl.textAlignment = NSTextAlignmentCenter;
        [_draftLbl sizeToFit];
        _draftLbl.text = @"上次未发布的";
    }
    return _draftLbl;
}

-(UILabel *)recoveryLbl{
    if (!_recoveryLbl) {
        _recoveryLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _recoveryLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _recoveryLbl.font = [UIFont systemFontOfSize:11.f];
        _recoveryLbl.adjustsFontSizeToFitWidth = YES;
        _recoveryLbl.textAlignment = NSTextAlignmentCenter;
        [_recoveryLbl sizeToFit];
        _recoveryLbl.text = @"定价自由、更自主";
    }
    return _recoveryLbl;
}

-(UILabel *)releaseLbl{
    if (!_releaseLbl) {
        _releaseLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _releaseLbl.textColor = [UIColor colorWithHexString:@"999999"];
        _releaseLbl.font = [UIFont systemFontOfSize:11.f];
        _releaseLbl.adjustsFontSizeToFitWidth = YES;
        _releaseLbl.textAlignment = NSTextAlignmentCenter;
        [_releaseLbl sizeToFit];
        _releaseLbl.text = @"更多曝光、更省心";
    }
    return _releaseLbl;
}

-(VerticalCommandButton *)draftPublish{
    if (!_draftPublish) {
        _draftPublish = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _draftPublish.contentAlignmentCenter = YES;
        _draftPublish.imageTextSepHeight = 6;
        [_draftPublish setImage:[UIImage imageNamed:@"draft_publish"] forState:UIControlStateNormal];
        [_draftPublish setTitle:@"草稿箱" forState:UIControlStateNormal];
        [_draftPublish setTitleColor:[UIColor colorWithHexString:@"636363"] forState:UIControlStateNormal];
        _draftPublish.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _draftPublish;
}

-(UIImageView *)sharpImageView{
    if (!_sharpImageView) {
        _sharpImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _sharpImageView.image = [UIImage imageNamed:@"Sharp_New_MF"];
    }
    return _sharpImageView;
}

-(UIView *)centerSView{
    if (!_centerSView) {
        _centerSView = [[UIView alloc] initWithFrame:CGRectZero];
        _centerSView.backgroundColor = [UIColor colorWithHexString:@"898989"];
    }
    return _centerSView;
}

-(UIView *)centerSView1{
    if (!_centerSView1) {
        _centerSView1 = [[UIView alloc] initWithFrame:CGRectZero];
        _centerSView1.backgroundColor = [UIColor colorWithHexString:@"898989"];
    }
    return _centerSView1;
}

-(UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectZero];
        _bgView.backgroundColor = [UIColor whiteColor];
    }
    return _bgView;
}

-(VerticalCommandButton *)releaseNofm{
    if (!_releaseNofm) {
        _releaseNofm = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _releaseNofm.contentAlignmentCenter = YES;
        _releaseNofm.imageTextSepHeight = 6;
        [_releaseNofm setImage:[UIImage imageNamed:@"send_sold_publish"] forState:UIControlStateNormal];
        [_releaseNofm setTitle:@"寄卖" forState:UIControlStateNormal];
        [_releaseNofm setTitleColor:[UIColor colorWithHexString:@"636363"] forState:UIControlStateNormal];
        _releaseNofm.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _releaseNofm;
}

-(VerticalCommandButton *)releaseRecovery{
    if (!_releaseRecovery) {
        _releaseRecovery = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        _releaseRecovery.contentAlignmentCenter = YES;
        _releaseRecovery.imageTextSepHeight = 6;
        [_releaseRecovery setImage:[UIImage imageNamed:@"sold_self_publish"] forState:UIControlStateNormal];
        [_releaseRecovery setTitle:@"自己卖" forState:UIControlStateNormal];
        [_releaseRecovery setTitleColor:[UIColor colorWithHexString:@"636363"] forState:UIControlStateNormal];
        _releaseRecovery.titleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _releaseRecovery;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.bgView];
        [self.bgView addSubview:self.releaseNofm];
        [self.bgView addSubview:self.releaseRecovery];
        [self.bgView addSubview:self.draftPublish];
        [self.bgView addSubview:self.centerSView];
        [self.bgView addSubview:self.centerSView1];
        
        [self.bgView addSubview:self.releaseLbl];
        [self.bgView addSubview:self.recoveryLbl];
        [self.bgView addSubview:self.draftLbl];
        [self addSubview:self.sharpImageView];
        
        WEAKSELF;
        self.releaseNofm.handleClickBlock = ^(CommandButton *sender) {
            if ([weakSelf.sprangDelegate respondsToSelector:@selector(pushPublishNofm)]) {
                [weakSelf.sprangDelegate pushPublishNofm];
            }
        };
        
        self.releaseRecovery.handleClickBlock = ^(CommandButton *sender) {
            if ([weakSelf.sprangDelegate respondsToSelector:@selector(pushPublishRecovery)]) {
                [weakSelf.sprangDelegate pushPublishRecovery];
            }
        };
        
        self.draftPublish.handleClickBlock = ^(CommandButton *sender){
            if ([weakSelf.sprangDelegate respondsToSelector:@selector(pushPublishDraft)]) {
                [weakSelf.sprangDelegate pushPublishDraft];
            }
        };
        
        [self setUpUI];
    }
    return self;
}

-(void)setUpUI{
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom).offset(-10);
    }];
    
    GoodsEditableInfo *editableInfo = [[Session sharedInstance] loadPublishGoodsFromDraft];
    if (editableInfo) {
        
        [self.releaseNofm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_top);
            make.left.equalTo(self.bgView.mas_left);
            make.width.equalTo(@((kScreenWidth-30)/3));
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        }];
        
        [self.releaseLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.releaseNofm.mas_centerX);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
            make.width.equalTo(@((kScreenWidth-30-20)/3));
        }];
        
        [self.draftPublish mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_top);
            make.right.equalTo(self.bgView.mas_right);
            make.width.equalTo(@((kScreenWidth-30)/3));
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        }];
        
        [self.draftLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.draftPublish.mas_centerX);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
            make.width.equalTo(@((kScreenWidth-30-20)/3));
        }];
        
        [self.releaseRecovery mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_top);
            make.right.equalTo(self.draftPublish.mas_left).offset(-0.5);
            make.left.equalTo(self.releaseNofm.mas_right).offset(0.5);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        }];
        
        [self.recoveryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.releaseRecovery.mas_centerX);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
            make.width.equalTo(@((kScreenWidth-30-20)/3));
        }];
        
        [self.centerSView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_top).offset(31);
            make.width.equalTo(@1);
            make.right.equalTo(self.releaseRecovery.mas_left);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-27);
        }];
        
        [self.centerSView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_top).offset(31);
            make.left.equalTo(self.releaseRecovery.mas_right);
            make.width.equalTo(@1);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-27);
        }];
        
    } else {
        [self.releaseNofm mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_top);
            make.left.equalTo(self.bgView.mas_left);
            make.right.equalTo(self.bgView.mas_centerX).offset(-0.5);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        }];
        
        [self.releaseLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.releaseNofm.mas_centerX);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
            make.width.equalTo(@((kScreenWidth-30)/2));
        }];
        
        [self.releaseRecovery mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_top);
            make.right.equalTo(self.bgView.mas_right);
            make.left.equalTo(self.bgView.mas_centerX).offset(0.5);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-20);
        }];
        
        [self.recoveryLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.releaseRecovery.mas_centerX);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-15);
            make.width.equalTo(@((kScreenWidth-30)/2));
        }];
        
        [self.centerSView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.bgView.mas_top).offset(31);
            make.left.equalTo(self.releaseNofm.mas_right);
            make.right.equalTo(self.releaseRecovery.mas_left);
            make.bottom.equalTo(self.bgView.mas_bottom).offset(-27);
        }];
    }
    
    [self.sharpImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom);
        make.centerX.equalTo(self.bgView.mas_centerX);
    }];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

@end
