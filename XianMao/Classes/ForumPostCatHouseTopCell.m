//
//  ForumPostCatHouseTopCell.m
//  XianMao
//
//  Created by apple on 15/12/29.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import "ForumPostCatHouseTopCell.h"

@interface ForumPostCatHouseTopCell ()



@end

@implementation ForumPostCatHouseTopCell

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        label.font = [UIFont systemFontOfSize:16];
        label.textAlignment = NSTextAlignmentCenter;
//        label.userInteractionEnabled = YES;
        self.label = label;
        [self addSubview:label];
    }
    return self;
}

-(void)setTopicGroup:(ForumTopicVO *)topicGroup{
    _topicGroup = topicGroup;
    self.label.text = topicGroup.title;
}

@end
