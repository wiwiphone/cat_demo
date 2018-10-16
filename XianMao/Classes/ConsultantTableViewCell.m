//
//  ConsultantTableViewCell.m
//  XianMao
//
//  Created by apple on 16/3/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ConsultantTableViewCell.h"
#import "Masonry.h"
#import "WCAlertView.h"

#import "SDWebImageManager.h"

@interface ConsultantTableViewCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *contentLbl;
@property (nonatomic, strong) UILabel *typeLbl;
@property (nonatomic, strong) UIButton *consultBtn;
@property (nonatomic, strong) UIButton *WChatBtn;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) AdviserPage *adviserPage;

@end

@implementation ConsultantTableViewCell

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    }
    return _lineView;
}

-(UIImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 20;
        _iconImageView.backgroundColor = [UIColor lightGrayColor];
    }
    return _iconImageView;
}

-(UILabel *)userName{
    if (!_userName) {
        _userName = [[UILabel alloc] initWithFrame:CGRectZero];
        _userName.font = [UIFont systemFontOfSize:15.f];
        _userName.textColor = [UIColor colorWithHexString:@"595757"];
        [_userName sizeToFit];
    }
    return _userName;
}

-(UILabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _contentLbl.font = [UIFont systemFontOfSize:13.f];
        _contentLbl.textColor = [UIColor colorWithHexString:@"9fa0a0"];
//        _contentLbl.numberOfLines = 0;
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UILabel *)typeLbl{
    if (!_typeLbl) {
        _typeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _typeLbl.font = [UIFont systemFontOfSize:15.f];
        _typeLbl.textColor = [UIColor colorWithHexString:@"595757"];
        [_typeLbl sizeToFit];
    }
    return _typeLbl;
}

-(UIButton *)consultBtn{
    if (!_consultBtn) {
        _consultBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_consultBtn setTitle:@"咨询" forState:UIControlStateNormal];
        _consultBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        _consultBtn.layer.masksToBounds = YES;
        _consultBtn.layer.cornerRadius = 3;
        [_consultBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
        _consultBtn.layer.borderColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
        _consultBtn.layer.borderWidth = 1.0f;
        [_consultBtn sizeToFit];
    }
    return _consultBtn;
}

-(UIButton *)WChatBtn{
    if (!_WChatBtn) {
        _WChatBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _WChatBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_WChatBtn setTitle:@"复制微信号" forState:UIControlStateNormal];
        _WChatBtn.titleLabel.font = [UIFont systemFontOfSize:10.f];
        _WChatBtn.layer.masksToBounds = YES;
        _WChatBtn.layer.cornerRadius = 3;
        [_WChatBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        [_WChatBtn setBackgroundColor:[UIColor colorWithHexString:@"c2a79d"]];
        [_WChatBtn sizeToFit];
//        _WChatBtn.layer.borderColor = [UIColor colorWithHexString:@"ac7e33"].CGColor;
//        _WChatBtn.layer.borderWidth = 1.0f;
    }
    return _WChatBtn;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([ConsultantTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 71;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict:(AdviserPage*)adviserPage {
    
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[ConsultantTableViewCell class]];
    if (adviserPage)[dict setObject:adviserPage forKey:[self cellDictKeyForAdviserPage]];
    
    return dict;
}

+(NSString *)cellDictKeyForAdviserPage{
    return @"adviserPage";
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.iconImageView];
        [self.contentView addSubview:self.userName];
        [self.contentView addSubview:self.contentLbl];
        [self.contentView addSubview:self.typeLbl];
        [self.contentView addSubview:self.consultBtn];
        [self.contentView addSubview:self.WChatBtn];
        
        [self.contentView addSubview:self.lineView];
        
        [self.WChatBtn addTarget:self action:@selector(copy:) forControlEvents:UIControlEventTouchUpInside];
        [self.consultBtn addTarget:self action:@selector(clickConsultBtn) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)upDataWithDict:(NSDictionary *)dict{
    AdviserPage *adviserPage = dict[@"adviserPage"];
    self.adviserPage = adviserPage;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:adviserPage.avatar] placeholderImage:nil];
    self.userName.text = adviserPage.username;
    self.contentLbl.text = adviserPage.summary;
    self.typeLbl.text = adviserPage.categoryName;
}

-(void)clickConsultBtn{
    WEAKSELF;
    if (self.pushChatViewController) {
        self.pushChatViewController(self.adviserPage.userId, weakSelf.adviserPage);
    }
    
}

- (void)copy:(UIButton *)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:self.adviserPage.weixinId];
    [WCAlertView showAlertWithTitle:@"复制成功" message:[NSString stringWithFormat:@"腕表顾问 [%@] 微信号 (%@) 复制成功，是否打开微信粘贴查找？", self.adviserPage.username, self.adviserPage.weixinId] customizationBlock:^(WCAlertView *alertView) {
        
    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
        if (buttonIndex == 1) {
            NSDictionary *data = @{@"weixinId":self.adviserPage.weixinId};
            [ClientReportObject clientReportObjectWithViewCode:MineConsultantViewCode regionCode:CopyWChatNumRegionCode referPageCode:CopyWChatNumRegionCode andData:data];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"weixin://dl/"]]];
        } else {
            
        }
    } cancelButtonTitle:@"稍后添加" otherButtonTitles:@"去添加", nil];
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
    }];
    
    [self.userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImageView.mas_right).offset(12);
        make.top.equalTo(self.iconImageView.mas_top);
    }];
    
    [self.typeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-21);
        make.top.equalTo(self.userName.mas_top);
    }];
    
    [self.WChatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.typeLbl.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-13);
        make.width.equalTo(@62);
        make.height.equalTo(@20);
    }];
    
    [self.consultBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.WChatBtn.mas_left).offset(-6);
        make.bottom.equalTo(self.WChatBtn.mas_bottom);
        make.width.equalTo(@41);
        make.height.equalTo(@20);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left);
        make.right.equalTo(self.contentView.mas_right);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userName.mas_left);
        make.bottom.equalTo(self.iconImageView.mas_bottom);
        make.right.equalTo(self.consultBtn.mas_left).offset(-10);
    }];
}

@end
