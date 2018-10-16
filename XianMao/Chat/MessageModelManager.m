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

#import "MessageModelManager.h"
#import "ConvertToCommonEmoticonsHelper.h"
#import "EaseMessageModel.h"
//#import "EaseMob.h"

@implementation MessageModelManager

+ (id)firstModelWithMessage:(EMMessage *)message
{
    EMMessageBody * messageBody = message.body;
//    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
//    NSString *login = [userInfo objectForKey:kSDKUsername];
    BOOL isSender = [[EMClient sharedClient].currentUsername isEqualToString:message.from] ? YES : NO;
    
    EaseMessageModel *model = [[EaseMessageModel alloc] init];
//    model.isMessageRead = message.isRead;
//    model.message.body = messageBody;
//    model.message1 = message;
////    model.bodyType = messageBody.messageBodyType;
//    model.messageId = message.messageId;
//    model.isSender = NO;
//    model.isPlaying = NO;
//    model.messageType = message.messageType;
//    if (model.messageType != eMessageTypeChat) {
//        model.username = message.groupSenderName;
//    }
//    else{
//        model.username = message.from;
//    }
//    
//    //    if (isSender) {
//    //        model.headImageURL = nil;
//    //        model.status = message.deliveryState;
//    //    }
//    //    else{
//    //        model.headImageURL = nil;
//    //        model.status = eMessageDeliveryState_Delivered;
//    //    }
//    
//    switch (messageBody.type) {
//        case EMMessageBodyTypeText:
//        {
//            
//            // 表情映射。
//            NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
//                                        convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
//            model.content = didReceiveText;
//        }
//            break;
//        case eMessageBodyType_Image:
//        {
//            EMImageMessageBody *imgMessageBody = (EMImageMessageBody*)messageBody;
//            model.thumbnailSize = imgMessageBody.thumbnailSize;
//            model.size = imgMessageBody.size;
//            model.localPath = imgMessageBody.localPath;
//            model.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
//            if (isSender)
//            {
//                model.image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
//            }else {
//                model.imageRemoteURL = [NSURL URLWithString:imgMessageBody.remotePath];
//            }
//        }
//            break;
//        case eMessageBodyType_Location:
//        {
//            model.address = ((EMLocationMessageBody *)messageBody).address;
//            model.latitude = ((EMLocationMessageBody *)messageBody).latitude;
//            model.longitude = ((EMLocationMessageBody *)messageBody).longitude;
//        }
//            break;
//        case eMessageBodyType_Voice:
//        {
//            model.time = ((EMVoiceMessageBody *)messageBody).duration;
//            model.chatVoice = (EMChatVoice *)((EMVoiceMessageBody *)messageBody).chatObject;
//            if (message.ext) {
//                NSDictionary *dict = message.ext;
//                BOOL isPlayed = [[dict objectForKey:@"isPlayed"] boolValue];
//                model.isPlayed = isPlayed;
//            }else {
//                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@NO,@"isPlayed", nil];
//                message.ext = dict;
//                [message updateMessageExtToDB];
//            }
//            // 本地音频路径
//            model.localPath = ((EMVoiceMessageBody *)messageBody).localPath;
//            model.remotePath = ((EMVoiceMessageBody *)messageBody).remotePath;
//        }
//            break;
//        default:
//            break;
//    }
    
    return model;
}

+ (id)modelWithMessage:(EMMessage *)message
{
    EMMessageBody *messageBody = message.body;
//    NSDictionary *userInfo = [[EaseMob sharedInstance].chatManager loginInfo];
//    NSString *login = [userInfo objectForKey:kSDKUsername];
    BOOL isSender = [[EMClient sharedClient].currentUsername isEqualToString:message.from] ? YES : NO;
    
    EaseMessageModel *model = [[EaseMessageModel alloc] init];
    model.isMessageRead = message.isRead;
    model.message1 = message;
    model.bodyType = messageBody.type;
    model.messageId = message.messageId;
    model.isSender = isSender;
    model.isMediaPlaying = NO;
    model.messageType = message.chatType;
    if (model.messageType != EMChatTypeChat) {
        model.username = message.from;
    }
    else{
        model.username = message.from;
    }
    
//    if (isSender) {
//        model.headImageURL = nil;
//        model.status = message.deliveryState;
//    }
//    else{
//        model.headImageURL = nil;
//        model.status = eMessageDeliveryState_Delivered;
//    }
    
    switch (messageBody.type) {
        case EMMessageBodyTypeText:
        {

            // 表情映射。
            NSString *didReceiveText = [ConvertToCommonEmoticonsHelper
                                        convertToSystemEmoticons:((EMTextMessageBody *)messageBody).text];
            model.text = didReceiveText;
        }
            break;
        case EMMessageBodyTypeImage:
        {
            EMImageMessageBody *imgMessageBody = (EMImageMessageBody*)messageBody;
            model.thumbnailImageSize = imgMessageBody.thumbnailSize;
            model.imageSize = imgMessageBody.size;
            model.localPath = imgMessageBody.localPath;
            model.thumbnailImage = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            if (isSender)
            {
                model.image = [UIImage imageWithContentsOfFile:imgMessageBody.thumbnailLocalPath];
            }else {
                model.imageRemoteURL = [NSURL URLWithString:imgMessageBody.remotePath];
            }
        }
            break;
        case EMMessageBodyTypeLocation:
        {
            model.address = ((EMLocationMessageBody *)messageBody).address;
            model.latitude = ((EMLocationMessageBody *)messageBody).latitude;
            model.longitude = ((EMLocationMessageBody *)messageBody).longitude;
        }
            break;
        case EMMessageBodyTypeVoice:
        {
            model.message.localTime = ((EMVoiceMessageBody *)messageBody).duration;
//            model.chatVoice = (EMChatVoice *)((EMVoiceMessageBody *)messageBody).chatObject;
            if (message.ext) {
                NSDictionary *dict = message.ext;
                BOOL isPlayed = [[dict objectForKey:@"isPlayed"] boolValue];
                model.isMediaPlaying = isPlayed;
            }else {
                NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@NO,@"isPlayed", nil];
                message.ext = dict;
//                [message updateMessageExtToDB];
            }
            // 本地音频路径
            model.localPath = ((EMVoiceMessageBody *)messageBody).localPath;
            model.remotePath = ((EMVoiceMessageBody *)messageBody).remotePath;
            
        }
            break;
        default:
            break;
    }
    
    return model;
}

@end
