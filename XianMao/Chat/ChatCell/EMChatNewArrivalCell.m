//
//  EMChatNewArrivalCell.m
//  XianMao
//
//  Created by Marvin on 2017/3/30.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "EMChatNewArrivalCell.h"
#import "EMChatSpecialCell.h"
#import "ReplyVo.h"
#import "WebViewController.h"
#import "URLScheme.h"
#import "Command.h"

#define MARGIN 10

@interface EMChatNewArrivalCell()

@property (nonatomic, strong) UIView * contentbgView;
@property (nonatomic, strong) ReplyVo * replyVo;

@end

@implementation EMChatNewArrivalCell

- (void)setMessageModel:(EaseMessageModel *)messageModel{
    if (messageModel) {
        for (UIView * view in self.contentbgView.subviews) {
            [view removeFromSuperview];
        }
        
        _messageModel = messageModel;
        NSDictionary * dict = [messageModel.message.ext objectForKey:KtabReplyDictKEY];
        ReplyVo * replyVo = [ReplyVo createWithDict:dict];
        _replyVo = replyVo;
        if (replyVo.data.count  > 0) {
            CGFloat maigin = MARGIN;
            CGFloat itemWidth = (kScreenWidth-30-maigin*4)/3;
            
            for (int i = 0; i < replyVo.data.count; i++) {
                RedirectInfo * info = (RedirectInfo *)[replyVo.data objectAtIndex:i];
                
                XMWebImageView * imageView = [[XMWebImageView alloc] initWithFrame:CGRectMake((i%3)*(itemWidth+maigin)+maigin, (i/3)*(itemWidth+maigin)+maigin, itemWidth, itemWidth)];
                [imageView setImageWithURL:info.imageUrl XMWebImageScaleType:XMWebImageScaleNone];
                [self.contentbgView addSubview:imageView];
                imageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch) {
                    [URLScheme locateWithRedirectUri:info.redirectUri andIsShare:YES];
                };
            }
        }
        
        TapDetectingLabel * lbl = [[TapDetectingLabel alloc] init];
        lbl.text = [NSString stringWithFormat:@"  %@",replyVo.title];
        lbl.font = [UIFont systemFontOfSize:15];
        lbl.textColor = [UIColor whiteColor];
        lbl.backgroundColor = [UIColor colorWithHexString:@"797e8c"];
        lbl.handleSingleTapDetected = ^(TapDetectingLabel *view, UIGestureRecognizer *recognizer) {
            [URLScheme locateWithRedirectUri:self.replyVo.redirectUrl andIsShare:YES];
        };
        [self.contentbgView addSubview:lbl];
        
        UILabel * rightLbl = [[UILabel alloc] init];
        rightLbl.text = @">";
        rightLbl.textColor = [UIColor whiteColor];
        rightLbl.font = [UIFont systemFontOfSize:15];
        rightLbl.backgroundColor = [UIColor clearColor];
        [rightLbl sizeToFit];
        [self.contentbgView addSubview:rightLbl];
        
        [lbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentbgView.mas_bottom).offset(-10);
            make.left.equalTo(self.contentbgView.mas_left).offset(10);
            make.right.equalTo(self.contentbgView.mas_right).offset(-10);
            make.height.mas_equalTo(@40);
        }];
        
        [rightLbl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentbgView.mas_bottom).offset(-10);
            make.right.equalTo(self.contentbgView.mas_right).offset(-25);
            make.height.mas_equalTo(@40);
        }];
    }
}

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(EaseMessageModel *)model{
    NSDictionary * dict = [model.message.ext objectForKey:KtabReplyDictKEY];
    ReplyVo * replyVo = [ReplyVo createWithDict:dict];
    CGFloat height = 20;
    NSInteger row;
    NSInteger count = replyVo.data.count;
    if (count > 3*(count/3)) {
        row = count/3+1;
    }else{
        row = count/3;
    }
    CGFloat itemWidth = (kScreenWidth-30-MARGIN*4)/3+MARGIN;
    height += itemWidth*row;
    height += 60;
    return height;
}

- (UIView *)contentbgView{
    if (!_contentbgView) {
        _contentbgView = [[UIView alloc] initWithFrame:CGRectZero];
        _contentbgView.backgroundColor = [UIColor whiteColor];
        _contentbgView.layer.cornerRadius = 6;
        _contentbgView.layer.masksToBounds = YES;
        _contentbgView.userInteractionEnabled = YES;
    }
    return _contentbgView;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         [self.contentView addSubview:self.contentbgView];
     
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.contentbgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(10, 15, 10, 15));
    }];

}

+ (NSString *)cellIdentifierForEMChatNewArrivalCell{
    return @"EMChatNewArrivalCell";
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
