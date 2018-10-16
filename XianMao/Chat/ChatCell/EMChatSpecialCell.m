//
//  EMChatSpecialCell.m
//  XianMao
//
//  Created by Marvin on 2017/3/30.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "EMChatSpecialCell.h"
#import "ReplyVo.h"
#import "WebViewController.h"
#import "URLScheme.h"
#import "Command.h"
#import "URLScheme.h"

NSString *const KtabReplyDictKEY = @"tabReplyDict";

@interface EMChatSpecialCell()

@property (nonatomic, strong) UIView * contentbgView;
@property (nonatomic, strong) XMWebImageView * specialPic;
@property (nonatomic, strong) TapDetectingLabel * title;
@property (nonatomic, strong) UIView * titleLblBg;
@property (nonatomic, strong) UILabel * rightLbl;
@end

@implementation EMChatSpecialCell

- (void)setMessageModel:(EaseMessageModel *)messageModel{
    if (messageModel) {
        _messageModel = messageModel;
        if ([messageModel.message.ext objectForKey:KtabReplyDictKEY]) {
            NSDictionary * dict = [messageModel.message.ext objectForKey:KtabReplyDictKEY];
            ReplyVo * replyVo = [ReplyVo createWithDict:dict];
            self.title.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
                [URLScheme locateWithRedirectUri:replyVo.redirectUrl andIsShare:YES];
            };
            if (replyVo.data.count  > 0) {
                RedirectInfo * info = [replyVo.data objectAtIndex:0];
                [_specialPic setImageWithURL:info.imageUrl XMWebImageScaleType:XMWebImageScaleNone];
                _title.text = [NSString stringWithFormat:@"  %@",info.title];
                
                _specialPic.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
                    [URLScheme locateWithRedirectUri:info.redirectUri andIsShare:YES];
                };
            }
        }
    }
}


- (UIView *)contentbgView{
    if (!_contentbgView) {
        _contentbgView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentbgView.backgroundColor = [UIColor whiteColor];
        _contentbgView.layer.cornerRadius = 6;
        _contentbgView.layer.masksToBounds = YES;
    }
    return _contentbgView;
}

- (UIView *)titleLblBg{
    if (!_titleLblBg) {
        _titleLblBg = [[UIView alloc] initWithFrame:CGRectNull];
        _titleLblBg.backgroundColor = [UIColor blackColor];
        _titleLblBg.alpha = 0.7;
    }
    return _titleLblBg;
}

- (XMWebImageView *)specialPic{
    if (!_specialPic) {
        _specialPic = [[XMWebImageView alloc] initWithFrame:CGRectZero];
    }
    return _specialPic;
}

- (TapDetectingLabel *)title{
    if (!_title) {
        _title = [[TapDetectingLabel alloc] init];
        _title.backgroundColor = [UIColor clearColor];
        _title.textColor = [UIColor whiteColor];
        _title.font = [UIFont systemFontOfSize:15];
    }
    return _title;
}

- (UILabel *)rightLbl{
    if (!_rightLbl) {
        _rightLbl = [[UILabel alloc] init];
        _rightLbl.text = @">";
        _rightLbl.textColor = [UIColor whiteColor];
        _rightLbl.font = [UIFont systemFontOfSize:15];
        _rightLbl.backgroundColor = [UIColor clearColor];
        [_rightLbl sizeToFit];
    }
    return _rightLbl;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.contentbgView];
        [self.contentbgView addSubview:self.specialPic];
        [self.contentbgView addSubview:self.titleLblBg];
        [self.contentbgView addSubview:self.title];
        [self.contentbgView addSubview:self.rightLbl];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];
    
    [self.specialPic mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentbgView).with.insets(UIEdgeInsetsMake(10, 10, 10, 10));
    }];
    
    [self.titleLblBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.specialPic.mas_bottom);
        make.left.equalTo(self.specialPic.mas_left);
        make.right.equalTo(self.specialPic.mas_right);
        make.height.mas_equalTo(@40);
    }];
    
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.specialPic.mas_bottom);
        make.left.equalTo(self.specialPic.mas_left);
        make.right.equalTo(self.specialPic.mas_right);
        make.height.mas_equalTo(@40);
    }];
    
    [self.rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.specialPic.mas_bottom);
        make.right.equalTo(self.specialPic.mas_right).offset(-15);
        make.height.mas_equalTo(@40);
    }];
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(EaseMessageModel *)model{
    NSDictionary * dict = [model.message.ext objectForKey:KtabReplyDictKEY];
    ReplyVo * replyVo = [ReplyVo createWithDict:dict];
    RedirectInfo * info = [replyVo.data objectAtIndex:0];
    CGFloat height = kScreenWidth*info.height/kScreenHeight;
    height += 20;
    return height;
}

+ (NSString *)cellIdentifierForEMChatSpecialCell{
    return @"EMChatSpecialCell";
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
