//
//  FooterView.m
//  XianMao
//
//  Created by apple on 16/1/23.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FooterView.h"
#import "TTTAttributedLabel.h"
#import "Masonry.h"
#import "GoodsEditableInfo.h"
#import "WebViewController.h"

#import "NetworkAPI.h"

//爱丁猫协议
#define kURLAgreement @"http://activity.aidingmao.com/share/page/632"

@interface FooterView () <TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel *label;
@property (nonatomic, strong) UIButton *agreeBtn;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, assign) BOOL isSeleted;

@property (nonatomic, strong) GoodsEditableInfo *editInfo;

@end

@implementation FooterView
{
    HTTPRequest *_request;
}
-(TTTAttributedLabel *)label{
    if (!_label) {
        _label = [[TTTAttributedLabel alloc] init];
        _label.font = [UIFont systemFontOfSize:11.f];
        _label.textColor = [UIColor colorWithHexString:@"282828"];
        _label.lineBreakMode = NSLineBreakByWordWrapping;
        _label.userInteractionEnabled = YES;
        _label.linkAttributes = nil;
        _label.highlightedTextColor = [UIColor colorWithHexString:@"c2a79d"];
        [_label setText:@"已阅读并同意《爱丁猫回收协议》" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange stringRange = NSMakeRange(mutableAttributedString.length-9,9);
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"c2a79d"] CGColor] range:stringRange];
            return mutableAttributedString;
        }];
        [_label addLinkToURL:[NSURL URLWithString:kURLAgreement] withRange:NSMakeRange([_label.text length]-9,9)];
        [_label sizeToFit];
    }
    return _label;
}

-(UIButton *)agreeBtn{
    if (!_agreeBtn) {
        _agreeBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_agreeBtn setImage:[UIImage imageNamed:@"login_check"] forState:UIControlStateNormal];
        [_agreeBtn setImage:[UIImage imageNamed:@"login_checked"] forState:UIControlStateSelected];
//        _agreeBtn.backgroundColor = [UIColor redColor];
    }
    return _agreeBtn;
}

-(UIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _sendBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
        [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
        [_sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sendBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    }
    return _sendBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.label];
        [self addSubview:self.agreeBtn];
        [self addSubview:self.sendBtn];
        
        self.label.delegate = self;
        
        self.agreeBtn.selected = YES;
        
        
        [self.agreeBtn addTarget:self action:@selector(clickAgreeBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.sendBtn addTarget:self action:@selector(doneBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)doneBtn{
    if (!self.isSeleted == NO) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请您仔细阅读并同意爱丁猫平台回收协议" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    } else {
        if ([self.footDelegate respondsToSelector:@selector(releaseBtnClick)]) {
            [self.footDelegate releaseBtnClick];
        }
    }
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    //    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
    if ([[url absoluteString] length]>0) {
        WebViewController *viewController = [[WebViewController alloc] init];
        viewController.title = @"平台回收协议";
        viewController.url = [url absoluteString];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"aidingmaoPush" object:viewController];
    }
}

//_request = [[NetworkAPI sharedInstance] publishGoods:self.editInfo completion:^(GoodsPublishResultInfo *resultInfo) {
//    
//} failure:^(XMError *error) {
//    
//}];

-(void)clickAgreeBtn{
    if (self.isSeleted) {
        self.agreeBtn.selected = YES;
        self.isSeleted = NO;
    } else {
        self.agreeBtn.selected = NO;
        self.isSeleted = YES;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    if (self.isEdit == 1) {
        [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    } else {
        [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];//给回收商等待报价
    }
    
    [self.agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(10);
        make.left.equalTo(self.mas_centerX).offset(-97);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.agreeBtn.mas_centerY).offset(1);
        make.left.equalTo(self.agreeBtn.mas_right);
    }];
    
    [self.sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.agreeBtn.mas_bottom).offset(15);
        make.left.equalTo(self.mas_left).offset(15);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@38);
    }];
}


@end
