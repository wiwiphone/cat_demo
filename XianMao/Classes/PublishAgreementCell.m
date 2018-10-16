//
//  PublishAgreementCell.m
//  XianMao
//
//  Created by Marvin on 17/3/24.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "PublishAgreementCell.h"
#import "TTTAttributedLabel.h"
#import "WebViewController.h"

@interface PublishAgreementCell()<TTTAttributedLabelDelegate>

@property (nonatomic, strong) TTTAttributedLabel * title;
@property (nonatomic, strong) UIButton * circleBtn;

@end

@implementation PublishAgreementCell

-(UIButton *)circleBtn
{
    if (!_circleBtn) {
        _circleBtn = [[UIButton alloc] init];
        _circleBtn.selected = YES;
        [_circleBtn setImage:[UIImage imageNamed:@"login_check_new.png"] forState:UIControlStateNormal];
        [_circleBtn setImage:[UIImage imageNamed:@"login_checked_new.png"] forState:UIControlStateSelected];
    }
    return _circleBtn;
}

-(TTTAttributedLabel *)title
{
    if (!_title) {
        _title = [[TTTAttributedLabel alloc] init];
        _title.font = [UIFont systemFontOfSize:10];
        _title.textColor = [UIColor colorWithHexString:@"434342"];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.linkAttributes = nil;
        _title.delegate = self;
        [_title setText:@"已阅读并同意《爱丁猫商品售卖协议》" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
            NSRange stringRange = NSMakeRange(mutableAttributedString.length-11,11);
            [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor redColor] CGColor] range:stringRange];//b28132
            return mutableAttributedString;
        }] ;
        
        [_title addLinkToURL:[NSURL URLWithString:@"http://activity.aidingmao.com/share/page/63"] withRange:NSMakeRange([_title.text length]-11,11)];
        [_title sizeToFit];
    
    }
    return _title;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([PublishAgreementCell class]);
    });
    return __reuseIdentifier;
}


+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    
    CGFloat rowHeight = 50;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[PublishAgreementCell class]];
    return dict;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {

        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        [self.contentView addSubview:self.title];
        [self.contentView addSubview:self.circleBtn];
        [self.circleBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)layoutSubviews{
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.centerX.equalTo(self.contentView.mas_centerX).offset(20);
    }];
    
    [self.circleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.title.mas_centerY);
        make.right.equalTo(self.title.mas_left).offset(-5);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
}

- (void)attributedLabel:(TTTAttributedLabel *)label
   didSelectLinkWithURL:(NSURL *)url
{
    WebViewController * webview = [[WebViewController alloc] init];
    webview.url = [url absoluteString];
    [[CoordinatingController sharedInstance] pushViewController:webview animated:YES];
}

-(void)buttonClick:(UIButton *)btn
{
    if (btn.selected == YES) {
        btn.selected = NO;
    }else{
        btn.selected  = YES;
    }
    
    if (self.handleCircleBtnClickBlock) {
        self.handleCircleBtnClickBlock(self.circleBtn.selected);
    }
}

- (void)updateCellWithDict:(NSDictionary*)dict{

}

@end
