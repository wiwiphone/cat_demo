//
//  LeaveMessageCell.h
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "HPGrowingTextView.h"


typedef void(^leaveMessage)(NSString *message);

@interface LeaveMessageCell : BaseTableViewCell<HPGrowingTextViewDelegate>


@property (nonatomic,strong) HPGrowingTextView * leaveMessage;
@property (nonatomic,copy) leaveMessage  message;

+ (NSString *)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict;
@end
