//
//  CommentView.m
//  XianMao
//
//  Created by apple on 16/9/9.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "CommentView.h"
#import "NSDate+Category.h"
#import "MLEmojiLabel.h"
#import "ForumPostTableViewCell.h"

@interface CommentView ()

@property (nonatomic, strong) XMWebImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLbl;
@property (nonatomic, strong) TapDetectingMLEmojiLabel *contentLbl;
@property (nonatomic, strong) UILabel *timeLbl;
@property (nonatomic, strong) UIButton *sellerTagBtn;
@property (nonatomic, strong) UIView *lineView;

@end

@implementation CommentView

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _lineView;
}

-(UIButton *)sellerTagBtn{
    if (!_sellerTagBtn) {
        _sellerTagBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_sellerTagBtn setImage:[UIImage imageNamed:@"Goods_Seller_Tag"] forState:UIControlStateNormal];
        [_sellerTagBtn sizeToFit];
    }
    return _sellerTagBtn;
}

-(UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.font = [UIFont systemFontOfSize:11.f];
        _timeLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        [_timeLbl sizeToFit];
    }
    return _timeLbl;
}

-(TapDetectingMLEmojiLabel *)contentLbl{
    if (!_contentLbl) {
        _contentLbl = [ForumPostReplyTableCell createReplyLbl];
        _contentLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _contentLbl.font = [UIFont systemFontOfSize:11.f];
        _contentLbl.numberOfLines = 0;
        [_contentLbl sizeToFit];
    }
    return _contentLbl;
}

-(UILabel *)nameLbl{
    if (!_nameLbl) {
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLbl.font = [UIFont systemFontOfSize:12.f];
        _nameLbl.textColor = [UIColor colorWithHexString:@"434342"];
        [_nameLbl sizeToFit];
    }
    return _nameLbl;
}

-(XMWebImageView *)iconImageView{
    if (!_iconImageView) {
        _iconImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        _iconImageView.layer.masksToBounds = YES;
        _iconImageView.layer.cornerRadius = 15;
    }
    return _iconImageView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.iconImageView];
        [self addSubview:self.nameLbl];
        [self addSubview:self.contentLbl];
        [self addSubview:self.timeLbl];
        [self addSubview:self.sellerTagBtn];
        [self addSubview:self.lineView];
        self.contentLbl.userInteractionEnabled = NO;
    }
    return self;
}

-(void)setI:(int)i{
    _i = i;
}

-(void)setSellerId:(NSInteger )sellerId{
    _sellerId = sellerId;
}

-(void)setCommentVo:(CommentVo *)commentVo{
    _commentVo = commentVo;
    
    [self.iconImageView setImageWithURL:commentVo.avatar_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
    self.nameLbl.text = commentVo.username;
    if (commentVo.reply_user_id == 0) {
        [self.contentLbl setEmojiText:commentVo.content];
    } else {
        [self.contentLbl setEmojiText:[NSString stringWithFormat:@"回复:%@ %@", commentVo.reply_username,commentVo.content]];
    }
    
    if (commentVo.user_id == self.sellerId) {
        self.sellerTagBtn.hidden = NO;
    } else {
        self.sellerTagBtn.hidden = YES;
    }
    
    if (self.i == 1) {
        self.lineView.hidden = YES;
    } else {
        self.lineView.hidden = NO;
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:commentVo.create_time/1000];
    self.timeLbl.text = [NSString stringWithFormat:@"%@", [date timeIntervalDescription]];
    
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"replayUserComment" object:_commentVo];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(15);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    [self.nameLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.iconImageView.mas_centerY).offset(-5);
        make.left.equalTo(self.iconImageView.mas_right).offset(8);
    }];
    
    [self.sellerTagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLbl.mas_centerY);
        make.left.equalTo(self.nameLbl.mas_right).offset(5);
    }];
    
    [self.contentLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLbl.mas_bottom).offset(10);
        make.left.equalTo(self.nameLbl.mas_left);
        make.right.equalTo(self.mas_right).offset(-60);
    }];
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-12);
        make.centerY.equalTo(self.nameLbl.mas_centerY);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-1);
        make.left.equalTo(self.mas_left).offset(12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@1);
    }];
}

@end
