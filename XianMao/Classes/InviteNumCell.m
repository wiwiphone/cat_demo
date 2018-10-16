//
//  InviteNumCell.m
//  XianMao
//
//  Created by apple on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "InviteNumCell.h"
#import "Command.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"


@interface InviteNumCell ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) NSString *inviteString;
@property (nonatomic, strong) CommandButton *fuzhiBtn;
@property (nonatomic, strong) CommandButton * QQBtn;
@property (nonatomic, strong) CommandButton * wecatBtn;
@property (nonatomic, strong) CommandButton * moreBtn;

@property (nonatomic, strong) UILabel * fuzhiLbl;
@property (nonatomic, strong) UILabel * qqLbl;
@property (nonatomic, strong) UILabel * wecatLbl;
@property (nonatomic, strong) UILabel * moreLbl;

@end

@implementation InviteNumCell


-(UILabel *)fuzhiLbl
{
    if (!_fuzhiLbl) {
        _fuzhiLbl = [[UILabel alloc] init];
        _fuzhiLbl.font = [UIFont systemFontOfSize:12];
        _fuzhiLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _fuzhiLbl.text = @"复制邀请码";
        [_fuzhiLbl sizeToFit];
    }
    return _fuzhiLbl;
}

-(UILabel *)qqLbl
{
    if (!_qqLbl) {
        _qqLbl = [[UILabel alloc] init];
        _qqLbl.font = [UIFont systemFontOfSize:12];
        _qqLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _qqLbl.text = @"邀请QQ好友";
        [_qqLbl sizeToFit];
    }
    return _qqLbl;
}

-(UILabel *)wecatLbl
{
    if (!_wecatLbl) {
        _wecatLbl = [[UILabel alloc] init];
        _wecatLbl.font = [UIFont systemFontOfSize:12];
        _wecatLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _wecatLbl.text = @"邀请微信好友";
        [_wecatLbl sizeToFit];
    }
    return _wecatLbl;
}

-(UILabel *)moreLbl
{
    if (!_moreLbl) {
        _moreLbl = [[UILabel alloc] init];
        _moreLbl.font = [UIFont systemFontOfSize:12];
        _moreLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _moreLbl.text = @"更多邀请方式";
        [_moreLbl sizeToFit];
    }
    return _moreLbl;
}

-(CommandButton *)fuzhiBtn{
    if (!_fuzhiBtn) {
        _fuzhiBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_fuzhiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _fuzhiBtn.backgroundColor = [UIColor colorWithHexString:@"333333"];
        _fuzhiBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _fuzhiBtn.layer.masksToBounds = YES;
        _fuzhiBtn.layer.cornerRadius = (kScreenWidth/375*55)/2;
    }
    return _fuzhiBtn;
}
-(CommandButton *)QQBtn{
    if (!_QQBtn) {
        _QQBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _QQBtn.layer.masksToBounds = YES;
        _QQBtn.layer.cornerRadius = (kScreenWidth/375*55)/2;
        
    }
    return _QQBtn;
}

-(CommandButton *)wecatBtn{
    if (!_wecatBtn) {
        _wecatBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _wecatBtn.layer.masksToBounds = YES;
        _wecatBtn.layer.cornerRadius = (kScreenWidth/375*55)/2;
        
    }
    return _wecatBtn;
}

-(CommandButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _moreBtn.layer.masksToBounds = YES;
        _moreBtn.layer.cornerRadius = (kScreenWidth/375*55)/2;
        [_moreBtn setImage:[UIImage imageNamed:@"mordShare"] forState:UIControlStateNormal];
    }
    return _moreBtn;
}



-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"272727"];
        _titleLbl.text = @"我的专属邀请码";
    }
    return _titleLbl;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([InviteNumCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 140;
    
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(InvitationVo *)invationVo
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[InviteNumCell class]];
    if (invationVo)[dict setObject:invationVo forKey:@"invationVo"];
    
    return dict;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        WEAKSELF;

        [self.contentView addSubview:self.fuzhiBtn];
        [self.contentView addSubview:self.QQBtn];
        [self.contentView addSubview:self.wecatBtn];
        [self.contentView addSubview:self.moreBtn];
        [self.contentView addSubview:self.fuzhiLbl];
        [self.contentView addSubview:self.qqLbl];
        [self.contentView addSubview:self.wecatLbl];
        [self.contentView addSubview:self.moreLbl];
        
        if ([WXApi isWXAppInstalled]) {
            [_wecatBtn setBackgroundImage:[UIImage imageNamed:@"wecatShare"] forState:UIControlStateNormal];
            _wecatBtn.enabled = YES;
            _wecatBtn.userInteractionEnabled = YES;
        }else{
            [_wecatBtn setBackgroundImage:[UIImage imageNamed:@"unwecatShare"] forState:UIControlStateNormal];
            _wecatBtn.enabled = NO;
            _wecatBtn.userInteractionEnabled = NO;
        }
        
        
        if ([TencentOAuth iphoneQQInstalled]) {
            [_QQBtn setBackgroundImage:[UIImage imageNamed:@"QQShare"] forState:UIControlStateNormal];
            _QQBtn.enabled = YES;
            _QQBtn.userInteractionEnabled = YES;
        }else{
            [_QQBtn setBackgroundImage:[UIImage imageNamed:@"unQQShare"] forState:UIControlStateNormal];
            _QQBtn.enabled = NO;
            _QQBtn.userInteractionEnabled = NO;
        }
        
        self.QQBtn.handleClickBlock = ^(CommandButton * sender){
            
            if (weakSelf.handleQQshareBlock) {
                weakSelf.handleQQshareBlock();
            }
            
        };
        
        self.wecatBtn.handleClickBlock = ^(CommandButton * sender){
            if (weakSelf.handlewecatShareBlock) {
                weakSelf.handlewecatShareBlock();
            }
        };
        
        
        self.moreBtn.handleClickBlock = ^(CommandButton * sender){
            if (weakSelf.handlemoreShareBlock) {
                weakSelf.handlemoreShareBlock();
            }
        };
        
        
        self.fuzhiBtn.handleClickBlock = ^(CommandButton *sender){
            if (weakSelf.inviteString && weakSelf.inviteString.length > 0) {
                UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = weakSelf.inviteString;
                [[CoordinatingController sharedInstance] showHUD:@"复制成功" hideAfterDelay:0.8];
            } else {
                [[CoordinatingController sharedInstance] showHUD:@"没有可复制的邀请码" hideAfterDelay:0.8];
            }
        };
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];

    CGFloat margin = kScreenWidth/375*25;
    CGFloat padding = kScreenWidth/375*35;
    [self.fuzhiBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(32);
        make.left.equalTo(self.contentView.mas_left).offset(margin);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*55, kScreenWidth/375*55));
    }];
    
    [self.QQBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(32);
        make.left.equalTo(self.fuzhiBtn.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*55, kScreenWidth/375*55));
    }];
    
    [self.wecatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(32);
        make.left.equalTo(self.QQBtn.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*55, kScreenWidth/375*55));
    }];
    
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(32);
        make.left.equalTo(self.wecatBtn.mas_right).offset(padding);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*55, kScreenWidth/375*55));
    }];
    
    [self.fuzhiLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.fuzhiBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.fuzhiBtn.mas_centerX);
    }];
    
    [self.qqLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.QQBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.QQBtn.mas_centerX);
    }];
    
    [self.wecatLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.wecatBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.wecatBtn.mas_centerX);
    }];
    
    [self.moreLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.moreBtn.mas_bottom).offset(10);
        make.centerX.equalTo(self.moreBtn.mas_centerX);
    }];
}

-(void)updateCellWithDict:(NSDictionary *)dict{
    InvitationVo *invationVo = dict[@"invationVo"];
    self.inviteString = invationVo.invitationCode;
    [self.fuzhiBtn setTitle:invationVo.invitationCode forState:UIControlStateNormal];
}

@end
