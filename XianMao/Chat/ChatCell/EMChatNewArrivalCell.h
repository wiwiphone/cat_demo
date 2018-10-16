//
//  EMChatNewArrivalCell.h
//  XianMao
//
//  Created by Marvin on 2017/3/30.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EaseMessageModel.h"

@interface EMChatNewArrivalCell : UITableViewCell
@property (nonatomic, strong) EaseMessageModel *messageModel;

+ (NSString *)cellIdentifierForEMChatNewArrivalCell;
+ (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath withObject:(EaseMessageModel *)model;

@end
