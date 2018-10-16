//
//  LogisticsMessageView.m
//  XianMao
//
//  Created by WJH on 16/10/31.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "LogisticsMessageView.h"
#import "Command.h"
#import "GoodsInfo.h"
#import "Session.h"

@interface LogisticsMessageView()

@property (nonatomic ,strong) UILabel * mailSN;
@property (nonatomic, strong) UILabel * mailCOM;
@property (nonatomic, strong) MailInfo * mailInfo;
@property (nonatomic, strong) OrderInfo * orderInfo;
@property (nonatomic, strong) CommandButton * reviseMailSNBtn;

@end

@implementation LogisticsMessageView


-(UILabel *)mailSN
{
    if (!_mailSN) {
        _mailSN = [[UILabel alloc] init];
        _mailSN.text = @"运单编号";
        _mailSN.textColor = [UIColor colorWithHexString:@"434342"];
        _mailSN.font = [UIFont systemFontOfSize:14];
        [_mailSN sizeToFit];
    }
    return _mailSN;
}

-(UILabel *)mailCOM
{
    if (!_mailCOM) {
        _mailCOM = [[UILabel alloc] init];
        _mailCOM.text = @"物流公司";
        _mailCOM.textColor = [UIColor colorWithHexString:@"434342"];
        _mailCOM.font = [UIFont systemFontOfSize:14];
        [_mailCOM sizeToFit];
    }
    return _mailCOM;
}

-(CommandButton *)reviseMailSNBtn
{
    if (!_reviseMailSNBtn) {
        _reviseMailSNBtn = [[CommandButton alloc] init];
        [_reviseMailSNBtn setImage:[UIImage imageNamed:@"compile"] forState:UIControlStateNormal];
        _reviseMailSNBtn.hidden = YES;
    }
    return _reviseMailSNBtn;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

        
        [self addSubview:self.mailSN];
        [self addSubview:self.mailCOM];
        [self addSubview:self.reviseMailSNBtn];
        
        WEAKSELF;
        self.reviseMailSNBtn.handleClickBlock = ^(CommandButton * sender){
            if (weakSelf.handleReviseMailSnBlack) {
                weakSelf.handleReviseMailSnBlack();
            };
        };
        
    }
    return self;
}

-(void)layoutSubviews
{
    [self.mailSN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.top.equalTo(self.mas_top).offset(12);
    }];
    
    [self.mailCOM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(14);
        make.bottom.equalTo(self.mas_bottom).offset(-12);
    }];
    
    [self.reviseMailSNBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-30);
        make.size.mas_equalTo(CGSizeMake(50, 50));
    }];
}

- (void)getMainInfo:(MailInfo *)mailInfo orderInfo:(OrderInfo *)orderInfo
{
    _mailInfo = mailInfo;
    _orderInfo = orderInfo;
    if (mailInfo.mailSN && mailInfo.mailSN.length > 0) {
        self.mailSN.text = [NSString stringWithFormat:@"运单编号:  %@",mailInfo.mailSN];
    }
    if (mailInfo.mailCOM && mailInfo.mailCOM.length > 0) {
        self.mailCOM.text = [NSString stringWithFormat:@"物流公司:  %@",mailInfo.mailCOM];
    }
    
    NSArray * goodsList = orderInfo.goodsList;
    
    NSInteger sellerId = 0;
    for (GoodsInfo * goodsInfo in goodsList) {
        sellerId = goodsInfo.seller.userId;
    }
    
    if (orderInfo.tradeType == 4) {
        self.reviseMailSNBtn.hidden = NO;
    }else{
        if (orderInfo.orderStatus == 1 || sellerId != [Session sharedInstance].currentUserId) {
            self.reviseMailSNBtn.hidden = YES;
        }else{
            self.reviseMailSNBtn.hidden = NO;
        }
    }
}

- (void)updataAfterRevise:(NSString *)mailCOM mainSN:(NSString *)mainSN
{
    if (mailCOM.length > 0) {
        self.mailCOM.text = [NSString stringWithFormat:@"物流公司:  %@",mailCOM];
    }
    
    if (mainSN.length > 0) {
        self.mailSN.text = [NSString stringWithFormat:@"运单编号:  %@",mainSN];
    }
}

@end
