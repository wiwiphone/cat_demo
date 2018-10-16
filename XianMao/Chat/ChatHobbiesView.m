//
//  ChatHobbiesView.m
//  XianMao
//
//  Created by Marvin on 17/3/28.
//  Copyright © 2017年 XianMao. All rights reserved.
//

#import "ChatHobbiesView.h"


@interface ChatHobbiesView()

@property (nonatomic, strong) UILabel * title;
@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation ChatHobbiesView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        
        CGFloat marginLeft = 15;
        _title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 57, self.height)];
        _title.textColor = [UIColor colorWithHexString:@"666666"];
        _title.font = [UIFont systemFontOfSize:15];
        _title.text = @"您想要:";
        [self addSubview:self.title];
        marginLeft += self.title.width;
        marginLeft += 10;
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(marginLeft, 0, kScreenWidth-marginLeft, self.height)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        CALayer * bottomLine = [[CALayer alloc] init];
        bottomLine.frame = CGRectMake(0, self.height-0.5, self.width, 0.5);
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"].CGColor;
        [self.layer addSublayer:bottomLine];
    }
    return self;
}

- (void)getchatTabReplyData:(NSArray *)data{
    
    CGFloat margin = 0;
    if (data && data.count > 0) {
        for (ChatTabReplyVo * chatTabReplyVo in data) {
            ChatTabReplyButton * button = [[ChatTabReplyButton alloc] init];
            [button setTitle:chatTabReplyVo.tabTitle forState:UIControlStateNormal];
            button.frame = CGRectMake(0, 0, 100, 0);
            [button sizeToFit];
            button.frame = CGRectMake(margin, (self.height-button.height)/2, button.width+9, 28);
            button.chatTapReplyVo = chatTabReplyVo;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:button];

            margin += button.width+9;
            
        }
        _scrollView.contentSize = CGSizeMake(margin, self.height);
    }
}

- (void)buttonClick:(ChatTabReplyButton *)button{
    if (button.chatTapReplyVo) {
        if (self.handleChatTabReplyBlock) {
            self.handleChatTabReplyBlock(button.chatTapReplyVo);
        }
    }
}

@end

@implementation ChatTabReplyButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setTitleColor:[UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.layer.borderColor = [UIColor colorWithHexString:@"666666"].CGColor;
        self.layer.borderWidth = 1;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 6;
    }
    return self;
}

@end
