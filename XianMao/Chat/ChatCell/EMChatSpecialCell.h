//
//  EMChatSpecialCell.h
//  XianMao
//
//  Created by Marvin on 2017/3/30.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMessageModel.h"


extern NSString *const KtabReplyDictKEY;

@interface EMChatSpecialCell : UITableViewCell
@property (nonatomic, strong) EaseMessageModel *messageModel;

+ (NSString *)cellIdentifierForEMChatSpecialCell;
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(EaseMessageModel *)model;
@end
