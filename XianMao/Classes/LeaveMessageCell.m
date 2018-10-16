//
//  LeaveMessageCell.m
//  XianMao
//
//  Created by 阿杜 on 16/7/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "LeaveMessageCell.h"

@implementation LeaveMessageCell

+(NSString *)reuseIdentifier
{
    static NSString * __reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([LeaveMessageCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait
{
    CGFloat height = 87;
    return height;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[LeaveMessageCell class]];
    return dict;
}

-(HPGrowingTextView *)leaveMessage
{
    if (!_leaveMessage) {
        _leaveMessage = [[HPGrowingTextView alloc] initWithFrame:CGRectZero];
        _leaveMessage.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _leaveMessage.placeholder = @"给卖家留言 (250字以内)";
        _leaveMessage.delegate = self;
    }
    return _leaveMessage;
}


- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView
{
    if (self.leaveMessage) {
        self.message(growingTextView.text);
    }
}



-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.leaveMessage];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.leaveMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(0, 14, 14, 14));
    }];
}



@end
