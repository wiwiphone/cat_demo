
/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import "EMChatViewCell.h"
#import "UIResponder+Router.h"
#import "EMChatGoodsBubbleView.h"

NSString *const kResendButtonTapEventName = @"kResendButtonTapEventName";
NSString *const kShouldResendCell = @"kShouldResendCell";

@interface EMChatViewCell ()

@property (nonatomic, strong) UILabel *timeLbl;

@end

@implementation EMChatViewCell

-(UILabel *)timeLbl{
    if (!_timeLbl) {
        _timeLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLbl.font = [UIFont systemFontOfSize:10.f];
        _timeLbl.textColor = [UIColor blackColor];
        [_timeLbl sizeToFit];
    }
    return _timeLbl;
}

- (id)initWithMessageModel:(EaseMessageModel *)model reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithMessageModel:model reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.headImageView.clipsToBounds = YES;
        
        self.headImageView.layer.masksToBounds=YES;
        self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2.0;
        [self.headImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headImageViewDidClick:)]];
        
        [self.contentView addSubview:self.timeLbl];
    }
    return self;
}

-(void)setTimeStr:(NSString *)timeStr{
    _timeStr = timeStr;
    self.timeLbl.text = timeStr;
}

-(void)headImageViewDidClick:(id *)sender
{
    if ( self.userId != 0) {
        [[CoordinatingController sharedInstance] gotoUserHomeViewController:self.userId animated:YES];
    }
}


- (BOOL)canBecomeFirstResponder
{
    return YES;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGRect bubbleFrame = _bubbleView.frame;
    bubbleFrame.origin.y = self.headImageView.frame.origin.y;
    
    if (self.messageModel.isSender) {
        bubbleFrame.origin.y = self.headImageView.frame.origin.y;
        // 菊花状态 （因不确定菊花具体位置，要在子类中实现位置的修改）
        _hasRead.hidden = YES;
        switch (self.messageModel.messageStatus) {
            case EMMessageStatusDelivering:
            {
                [_activityView setHidden:NO];
                [_retryButton setHidden:YES];
                [_activtiy setHidden:NO];
                [_activtiy startAnimating];
            }
                break;
            case EMMessageStatusSuccessed:
            {
                [_activtiy stopAnimating];
                [_retryButton setHidden:YES];
                if (self.messageModel.message.isReadAcked)
                {
                    _activityView.hidden = NO;
                    //_hasRead.hidden = NO;
                }
                else
                {
                    [_activityView setHidden:YES];
                }
            }
                break;
            case EMMessageStatusPending:
            case EMMessageStatusFailed:
            {
                [_activityView setHidden:NO];
                [_activtiy stopAnimating];
                [_activtiy setHidden:YES];
                [_retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
        
        bubbleFrame.origin.x = self.headImageView.frame.origin.x - bubbleFrame.size.width - HEAD_PADDING;
        _bubbleView.frame = bubbleFrame;
        
        CGRect frame = self.activityView.frame;
        if (_hasRead.hidden)
        {
            frame.size.width = SEND_STATUS_SIZE;
        }
        else
        {
            frame.size.width = _hasRead.frame.size.width;
        }
        frame.origin.x = bubbleFrame.origin.x - frame.size.width - ACTIVTIYVIEW_BUBBLE_PADDING;
        frame.origin.y = _bubbleView.center.y - frame.size.height / 2;
        self.activityView.frame = frame;
    }
    else{
        bubbleFrame.origin.x = HEAD_PADDING * 2 + HEAD_SIZE;
        if (self.messageModel.messageType != EMChatTypeChat) {
            bubbleFrame.origin.y = NAME_LABEL_HEIGHT + NAME_LABEL_PADDING;
        }
        _bubbleView.frame = bubbleFrame;
    }
    
    [self.timeLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bubbleView.mas_top);
        make.right.equalTo(_bubbleView.mas_left).offset(-3);
    }];
}

- (void)setMessageModel:(EaseMessageModel *)model
{
    [super setMessageModel:model];
    
    if (model.messageType != EMChatTypeChat) {
        _nameLabel.text = model.nickname;
        _nameLabel.hidden = model.isSender;
    }
    
    _bubbleView.model = model;
    [_bubbleView sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

#pragma mark - action

// 重发按钮事件
-(void)retryButtonPressed:(UIButton *)sender
{
    [self routerEventWithName:kResendButtonTapEventName
                     userInfo:@{kShouldResendCell:self}];
}

#pragma mark - private

- (void)setupSubviewsForMessageModel:(EaseMessageModel *)messageModel
{
    [super setupSubviewsForMessageModel:messageModel];
    
    if (messageModel.isSender) {
        // 发送进度显示view
        _activityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        [_activityView setHidden:YES];
        [self.contentView addSubview:_activityView];
        
        // 重发按钮
        _retryButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _retryButton.frame = CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE);
        [_retryButton addTarget:self action:@selector(retryButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        //        [_retryButton setImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        [_retryButton setBackgroundImage:[UIImage imageNamed:@"messageSendFail.png"] forState:UIControlStateNormal];
        //[_retryButton setBackgroundColor:[UIColor redColor]];
        [_activityView addSubview:_retryButton];
        
        // 菊花
        _activtiy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activtiy.backgroundColor = [UIColor clearColor];
        [_activityView addSubview:_activtiy];
        
        //已读
        _hasRead = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SEND_STATUS_SIZE, SEND_STATUS_SIZE)];
        _hasRead.text = NSLocalizedString(@"hasRead", @"Read");
        _hasRead.textAlignment = NSTextAlignmentCenter;
        _hasRead.font = [UIFont systemFontOfSize:12];
        [_hasRead sizeToFit];
        [_activityView addSubview:_hasRead];
    }
    
    _bubbleView = [self bubbleViewForMessageModel:messageModel];
    [self.contentView addSubview:_bubbleView];
}

- (EMChatBaseBubbleView *)bubbleViewForMessageModel:(EaseMessageModel *)messageModel
{
    switch (messageModel.bodyType) {
        case EMMessageBodyTypeText:
        {
            if ([messageModel.message.ext objectForKey:@"type"]!=nil &&
                [messageModel.message.ext integerValueForKey:@"type"] == 1) {
                return [[EMChatGoodsBubbleView alloc] init];
                break;
            }
            
            return [[EMChatTextBubbleView alloc] init];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            return [[EMChatImageBubbleView alloc] init];
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            return [[EMChatAudioBubbleView alloc] init];
        }
            break;
//        case eMessageBodyType_Location:
//        {
//            return [[EMChatLocationBubbleView alloc] init];
//        }
//            break;
//        case eMessageBodyType_Video:
//        {
//            return [[EMChatVideoBubbleView alloc] init];
//        }
//            break;
        default:
            break;
    }
    
    return nil;
}

+ (CGFloat)bubbleViewHeightForMessageModel:(EaseMessageModel *)messageModel
{
    switch (messageModel.bodyType) {
        case EMMessageBodyTypeText:
        {
            
            if ([messageModel.message.ext objectForKey:@"type"]!=nil &&
                [messageModel.message.ext integerValueForKey:@"type"] == 1) {
                return [EMChatGoodsBubbleView heightForBubbleWithObject:messageModel];
                break;
            }
            
            return [EMChatTextBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case EMMessageBodyTypeImage:
        {
            return [EMChatImageBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            return [EMChatAudioBubbleView heightForBubbleWithObject:messageModel];
        }
            break;
//        case eMessageBodyType_Location:
//        {
//            return [EMChatLocationBubbleView heightForBubbleWithObject:messageModel];
//        }
//            break;
//        case eMessageBodyType_Video:
//        {
//            return [EMChatVideoBubbleView heightForBubbleWithObject:messageModel];
//        }
//            break;
        default:
            break;
    }
    
    return HEAD_SIZE;
}

#pragma mark - public

+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(EaseMessageModel *)model
{
    NSInteger bubbleHeight = [self bubbleViewHeightForMessageModel:model];
    NSInteger headHeight = HEAD_PADDING * 2 + HEAD_SIZE;
    if ((model.messageType != EMChatTypeChat) && !model.isSender) {
        headHeight += NAME_LABEL_HEIGHT;
    }
    return MAX(headHeight, bubbleHeight + NAME_LABEL_HEIGHT + NAME_LABEL_PADDING) + CELLPADDING;
}


@end
