//
//  SuccessGoodsView.m
//  XianMao
//
//  Created by apple on 16/11/11.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "SuccessGoodsView.h"
#import "Command.h"
#import "GoodsDetailViewController.h"
#import "WXApi.h"
#import "UMSocialData.h"
#import "UMSocialDataService.h"
#import "URLScheme.h"

@interface SuccessGoodsView ()

@property (nonatomic, strong) UILabel *titleLbl;
@property (nonatomic, strong) XMWebImageView *mainPicImageView;
@property (nonatomic, strong) UILabel *goodsNameLbl;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) CommandButton *goodsDetailBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) VerticalCommandButton *weixinShareBtn;
@property (nonatomic, strong) VerticalCommandButton *timeLineShareBtn;


@property (nonatomic, strong) GoodsEditableInfo *editInfo;
@end

@implementation SuccessGoodsView

-(VerticalCommandButton *)timeLineShareBtn{
    if (!_timeLineShareBtn) {
        _timeLineShareBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        [_timeLineShareBtn setImage:[UIImage imageNamed:@"wxtimeline"] forState:UIControlStateNormal];
        [_timeLineShareBtn setImage:[UIImage imageNamed:@"wxtimeline_noclick"] forState:UIControlStateSelected];
        [_timeLineShareBtn setTitle:@"微信朋友圈" forState:UIControlStateNormal];
        [_timeLineShareBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _timeLineShareBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    }
    return _timeLineShareBtn;
}

-(VerticalCommandButton *)weixinShareBtn{
    if (!_weixinShareBtn) {
        _weixinShareBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectZero];
        [_weixinShareBtn setImage:[UIImage imageNamed:@"wxsession"] forState:UIControlStateNormal];
        [_weixinShareBtn setImage:[UIImage imageNamed:@"wxsession_noclick"] forState:UIControlStateSelected];
        [_weixinShareBtn setTitle:@"微信好友" forState:UIControlStateNormal];
        [_weixinShareBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _weixinShareBtn.titleLabel.font = [UIFont systemFontOfSize:11.f];
    }
    return _weixinShareBtn;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _lineView;
}

-(CommandButton *)goodsDetailBtn{
    if (!_goodsDetailBtn) {
        _goodsDetailBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_goodsDetailBtn setTitle:@"查看商品" forState:UIControlStateNormal];
        [_goodsDetailBtn setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateNormal];
        _goodsDetailBtn.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
        _goodsDetailBtn.layer.borderWidth = 1.f;
        _goodsDetailBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _goodsDetailBtn;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:13.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"666666"];
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UILabel *)goodsNameLbl{
    if (!_goodsNameLbl) {
        _goodsNameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _goodsNameLbl.font = [UIFont boldSystemFontOfSize:13.f];
        _goodsNameLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        [_goodsNameLbl sizeToFit];
    }
    return _goodsNameLbl;
}

-(XMWebImageView *)mainPicImageView{
    if (!_mainPicImageView) {
        _mainPicImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _mainPicImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
    }
    return _mainPicImageView;
}

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:17.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        [_titleLbl sizeToFit];
        _titleLbl.text = @"发布成功";
    }
    return _titleLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        [self addSubview:self.titleLbl];
        [self addSubview:self.mainPicImageView];
        [self addSubview:self.goodsNameLbl];
        [self addSubview:self.contentLbl];
        [self addSubview:self.goodsDetailBtn];
        [self addSubview:self.lineView];
        
        [self addSubview:self.weixinShareBtn];
        [self addSubview:self.timeLineShareBtn];
        
        if ([WXApi isWXAppInstalled]) {
            self.weixinShareBtn.selected = NO;
            self.timeLineShareBtn.selected = NO;
            self.weixinShareBtn.userInteractionEnabled = YES;
            self.timeLineShareBtn.userInteractionEnabled = YES;
            self.weixinShareBtn.handleClickBlock = ^(CommandButton *sender){
                [weakSelf share:kURLGoodsDetailFormat(weakSelf.editInfo.goodsId) shareName:@"wxsession" content:weakSelf.editInfo.goodsName image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.editInfo.mainPicItem.picUrl]]]];
            };
            
            self.timeLineShareBtn.handleClickBlock = ^(CommandButton *sender){
                [weakSelf share:kURLGoodsDetailFormat(weakSelf.editInfo.goodsId) shareName:@"wxtimeline" content:weakSelf.editInfo.goodsName image:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:weakSelf.editInfo.mainPicItem.picUrl]]]];
            };
        } else {
            self.weixinShareBtn.userInteractionEnabled = NO;
            self.timeLineShareBtn.userInteractionEnabled = NO;
            self.weixinShareBtn.selected = YES;
            self.timeLineShareBtn.selected = YES;
        }
    }
    return self;
}

-(void)share:(NSString *)url shareName:(NSString *)shareName content:(NSString *)content image:(UIImage *)image{
    /*设置微信好友*/
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"来自爱丁猫的分享";
    [UMSocialData defaultData].extConfig.wechatSessionData.url = url;
    [UMSocialData defaultData].extConfig.wechatSessionData.wxMessageType = UMSocialWXMessageTypeWeb;
    
    /*设置微信朋友圈*/
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = content;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = url;
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
    
    UMSocialUrlResource *urlResource = [[UMSocialUrlResource alloc] initWithSnsResourceType:UMSocialUrlResourceTypeImage url:url];
    
    //            NSMutableArray *arr = [NSMutableArray arrayWithArray:shareToSnsNames];
    //            [arr removeObject:@"ShareCopy"];
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[shareName] content:content image:image location:nil urlResource:urlResource presentedController:[CoordinatingController sharedInstance].visibleController completion:^(UMSocialResponseEntity *shareResponse){
        if (shareResponse.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(15);
    }];
    
    [self.mainPicImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLbl.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@(self.width-40));
    }];
    
    [self.goodsNameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mainPicImageView.mas_bottom).offset(15);
        make.left.equalTo(self.mainPicImageView.mas_left);
        make.right.equalTo(self.mainPicImageView.mas_right);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsNameLbl.mas_bottom).offset(7);
        make.left.equalTo(self.mainPicImageView.mas_left);
        make.right.equalTo(self.mainPicImageView.mas_right);
    }];
    
    [self.goodsDetailBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.contentLbl.mas_bottom).offset(40);
        make.left.equalTo(self.mas_left).offset(60);
        make.right.equalTo(self.mas_right).offset(-60);
        make.height.equalTo(@30);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsDetailBtn.mas_bottom).offset(12);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@12);
    }];
    
//    if ([WXApi isWXAppInstalled]) {
        [self.weixinShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(10);
            make.right.equalTo(self.mas_centerX).offset(-22);
            make.width.equalTo(@64);
            make.height.equalTo(@64);
        }];
        
        [self.timeLineShareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.lineView.mas_bottom).offset(10);
            make.left.equalTo(self.mas_centerX).offset(22);
            make.width.equalTo(@64);
            make.height.equalTo(@64);
        }];
//    }
}

-(void)getGoodsEditInfo:(GoodsEditableInfo *)editInfo{
    WEAKSELF;
    self.editInfo = editInfo;
    [self.mainPicImageView setImageWithURL:editInfo.mainPicItem.picUrl XMWebImageScaleType:XMWebImageScale480x480];
    self.goodsNameLbl.text = editInfo.goodsName;
    self.contentLbl.text = editInfo.summary;
    
    self.goodsDetailBtn.handleClickBlock = ^(CommandButton *sender){
        if (editInfo.goodsId) {
            GoodsDetailViewControllerContainer *viewController = [[GoodsDetailViewControllerContainer alloc] init];
            viewController.goodsId = editInfo.goodsId;
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
            if (weakSelf.disSuccessGoodsView) {
                weakSelf.disSuccessGoodsView();
            }
        } else {
            [[CoordinatingController sharedInstance] showHUD:@"商品待审核中" hideAfterDelay:1.2 forView:weakSelf];
        }
    };
}

@end
