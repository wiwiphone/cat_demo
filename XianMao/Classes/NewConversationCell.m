//
//  NewConversationCell.m
//  XianMao
//
//  Created by 阿杜 on 16/8/29.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "NewConversationCell.h"
#import "NSDate+Category.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "Session.h"
#import "MsgCountManager.h"

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface NewConversationCell()
{
    UILabel *_timeLabel;
    UILabel *_detailLabel;
}
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *detailMsg;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong)  UIView *lineView;
@property (nonatomic, strong) UILabel * adviser;

@end

@implementation NewConversationCell

+ (CGFloat)rowHeightForPortrait:(NSString *)title{
    CGFloat height = 70.f;
    return height;
}

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([NewConversationCell class]);
    });
    return __reuseIdentifier;
}

+ (NSMutableDictionary*)buildCellDict:(EMConversation *)conversation userId:(NSInteger)userId
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[NewConversationCell class]];
    if (conversation) {
        [dict setObject:conversation forKey:[self cellForConversationkey]];
    }
    
    if (userId) {
        [dict setObject:[NSNumber numberWithInteger:userId] forKey:@"userId"];
    }
    
    return dict;
}

+(NSString *)cellForConversationkey
{
    NSString * conversation = @"conversation";
    return conversation;
}

- (void)updateCellWithDict:(NSDictionary *)dict;
{
    EMConversation * conversation = [dict objectForKey:[NewConversationCell cellForConversationkey]];
    
    if (conversation.type == EMConversationTypeChat) {
        EMMessage *message = conversation.latestMessage;
        NSDictionary *extMessage = message.ext;
        NSString *imageUrl = nil;
        if ([message.from isEqualToString:[Session sharedInstance].emAccount.emUserName]) {
            if (![[extMessage objectForKey:@"toHeaderImg"] isEqual:[NSNull null]]) {
                imageUrl = [extMessage objectForKey:@"toHeaderImg"];
            }
            if (![[extMessage objectForKey:@"toNickname"] isEqual:[NSNull null]]) {
                self.name = [extMessage objectForKey:@"toNickname"];
            } else {
                self.name = @"未知";//toNickName==NULL
            }
        } else {
            if (![extMessage objectForKey:@"fromHeaderImg"] && ![extMessage objectForKey:@"fromNickname"]) {
                imageUrl = [Session sharedInstance].emKEFUAccount.avatar;
                self.name = [Session sharedInstance].emKEFUAccount.username;
            } else {
                if (![[extMessage objectForKey:@"fromHeaderImg"] isEqual:[NSNull null]]) {
                    imageUrl = [extMessage objectForKey:@"fromHeaderImg"];
                }
                if (![[extMessage objectForKey:@"fromNickname"] isEqual:[NSNull null]]){
                    self.name = [extMessage objectForKey:@"fromNickname"];
                } else {
                    self.name = @"未知";//取不到formNickName
                }
            }
        }
        
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"chatListCellHead"]];
        
    }
    else{
        NSString *imageName = @"groupPublicHeader";
        NSArray *groupArray = [[EMClient sharedClient].chatManager loadAllConversationsFromDB];//[[EaseMob sharedInstance].chatManager groupList];
        for (EMGroup *group in groupArray) {
            if ([group.groupId isEqualToString:conversation.conversationId]) {
                self.name = group.subject;
                imageName = group.isPublic ? @"groupPublicHeader" : @"groupPrivateHeader";
                break;
            }
        }
        self.placeholderImage = [UIImage imageNamed:imageName];
    }
    if ([self subTitleMessageByConversation:conversation]) {
        self.detailMsg = [self subTitleMessageByConversation:conversation];
    }
    
    if ([self lastMessageTimeByConversation:conversation]) {
        self.time = [self lastMessageTimeByConversation:conversation];
    }
    
    if ([self unreadMessageCountByConversation:conversation] > 0) {
        self.unreadCount = [self unreadMessageCountByConversation:conversation];
        self.unreadLabel.hidden = NO;
        if (_unreadCount < 9) {
            self.unreadLabel.font = [UIFont systemFontOfSize:13];
        }else if(_unreadCount > 9 && _unreadCount < 99){
            self.unreadLabel.font = [UIFont systemFontOfSize:12];
        }else{
            self.unreadLabel.font = [UIFont systemFontOfSize:10];
        }
        [self.contentView bringSubviewToFront:self.unreadLabel];
        self.unreadLabel.text = [NSString stringWithFormat:@"%ld",(long)self.unreadCount];
    }else{
        self.unreadLabel.hidden = YES;
    }
    
    self.lineView.hidden = NO;
    
    NSInteger userID = [[[NSUserDefaults standardUserDefaults] objectForKey:@"userID"] integerValue];
    if ([dict[@"userId"] integerValue] && [dict[@"userId"] integerValue] == userID) {
        self.adviser.hidden = NO;
    }else{
        self.adviser.hidden = YES;
    }
}

-(void)setName:(NSString *)name{
    _name = name;
    self.textLabel.text = name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}

-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    if (![_unreadLabel isHidden]) {
        _unreadLabel.backgroundColor = [UIColor redColor];
    }
}


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 80 -15, 23, 80, 16)];
        _timeLabel.font = [UIFont systemFontOfSize:10];
        _timeLabel.textColor = [UIColor lightGrayColor];
        _timeLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        
        _unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 8, 17, 17)];
        _unreadLabel.backgroundColor = [UIColor redColor];
        _unreadLabel.textColor = [UIColor whiteColor];
        
        _unreadLabel.textAlignment = NSTextAlignmentCenter;
        _unreadLabel.font = [UIFont systemFontOfSize:11];
        _unreadLabel.layer.cornerRadius = 17/2;
        _unreadLabel.clipsToBounds = YES;
        _unreadLabel.hidden = YES;
        [self.contentView addSubview:_unreadLabel];
        
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 42, 175, 20)];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.font = [UIFont systemFontOfSize:14];
        _detailLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_detailLabel];
        
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:15.f];
        
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 0, kScreenWidth, 0.5)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _lineView.hidden = NO;
        [self.contentView addSubview:_lineView];
        
        _adviser = [[UILabel alloc] init];
        _adviser.text = @"官方";
        _adviser.textColor = [UIColor redColor];
        _adviser.layer.borderColor = [UIColor redColor].CGColor;
        _adviser.layer.borderWidth = 1;
        _adviser.layer.masksToBounds = YES;
        _adviser.layer.cornerRadius = 8;
        _adviser.font = [UIFont systemFontOfSize:12];
        _adviser.textAlignment = NSTextAlignmentCenter;
        _adviser.hidden = YES;
        [self.contentView addSubview:self.adviser];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    CGRect frame = self.imageView.frame;
    self.imageView.frame = CGRectMake(12, 10, 50, 50);
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = self.imageView.frame.size.width / 2.f;
    self.imageView.clipsToBounds = YES;
    
    self.textLabel.text = _name;
    [self.textLabel sizeToFit];

    self.textLabel.frame = CGRectMake(CGRectGetMaxX(self.imageView.frame)+10, 10, self.textLabel.width, self.textLabel.height);
    
    _detailLabel.text = _detailMsg;
    _timeLabel.text = _time;
    [_timeLabel sizeToFit];

    _timeLabel.frame = CGRectMake(kScreenWidth - 14 -_timeLabel.width, 10, _timeLabel.width, _timeLabel.height);
    
    frame = _lineView.frame;
    frame.origin.y = self.contentView.frame.size.height - 0.5;
    _lineView.frame = frame;
    

    self.adviser.frame = CGRectMake(CGRectGetMaxX(self.textLabel.frame)+10, 10, 30, self.textLabel.height);
}


// 得到最后消息时间
-(NSString *)lastMessageTimeByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];;
    if (lastMessage) {
        ret = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    return ret;
}

// 得到未读消息条数
- (NSInteger)unreadMessageCountByConversation:(EMConversation *)conversation
{
    NSInteger ret = 0;
    ret = conversation.unreadMessagesCount;
    [[MsgCountManager sharedInstance] syncNoticeCount];
    
    return  ret;
}

// 得到最后消息文字或者类型
-(NSString *)subTitleMessageByConversation:(EMConversation *)conversation
{
    NSString *ret = @"";
    EMMessage *lastMessage = [conversation latestMessage];
    if (lastMessage) {
        EMMessageBody *messageBody = lastMessage.body;
        switch (messageBody.type) {
            case EMMessageBodyTypeImage:{
                ret = @"[图片]";
            } break;
            case EMMessageBodyTypeText:{
                
                // 表情映射。
                NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                            convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
                ret = didReceiveText;
            } break;
            case EMMessageBodyTypeVoice:{
                ret = @"[语音]";
            } break;
            case EMMessageBodyTypeLocation: {
                ret = @"[位置]";
            } break;
            case EMMessageBodyTypeVideo: {
                ret = @"[视频]";
            } break;
            default: {
            } break;
        }
    }
    
    return ret;
}





@end
