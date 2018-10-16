//
//  ShareView.m
//  XianMao
//
//  Created by apple on 16/4/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ShareView.h"
#import "Command.h"

@interface ShareView ()

@property (nonatomic, strong) NSMutableArray *shareToSnsNames;

@end

@implementation ShareView

-(NSMutableArray *)shareToSnsNames{
    if (!_shareToSnsNames) {
        _shareToSnsNames = [NSMutableArray array];
    }
    return _shareToSnsNames;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"eeeeea"];
        
    }
    return self;
}

-(void)getShareDatas:(NSMutableArray *)shareToSnsNames{
//    [shareToSnsNames removeLastObject];
    [shareToSnsNames addObject:@"ShareCopy"];
    self.shareToSnsNames = shareToSnsNames;
    
    CGFloat margin = 25 - (25+((kScreenWidth-160)/3));
    for (int i = 0; i < shareToSnsNames.count; i++) {
        if (i % 3 == 0) {
            margin += (25+((kScreenWidth-160)/3));
        }
        CGFloat index = 0;
        index = 40 + (i % 3) * (((kScreenWidth-160)/3) + 40);
        NSString *name = [[NSString alloc] init];
        if ([self.shareToSnsNames[i] isEqualToString:@"wxsession"]) {
            name = @"微信好友";
        } else if ([self.shareToSnsNames[i] isEqualToString:@"wxtimeline"]) {
            name = @"朋友圈";
        } else if ([self.shareToSnsNames[i] isEqualToString:@"qq"]) {
            name = @"qq好友";
        } else if ([self.shareToSnsNames[i] isEqualToString:@"ShareCopy"]){
            name = @"复制链接";
        } else if ([self.shareToSnsNames[i] isEqualToString:@"sina"]) {
            name = @"新浪微博";
        } if ([self.shareToSnsNames[i] isEqualToString:@"goodsDetail"]){
            name = @"获取图文";
        }
        
        VerticalCommandButton *shareBtn = [[VerticalCommandButton alloc] initWithFrame:CGRectMake(index, margin, (kScreenWidth-160)/3, (kScreenWidth-160)/3)];
//        shareBtn.layer.masksToBounds = YES;
//        shareBtn.layer.cornerRadius = (kScreenWidth-160)/3/2;
        shareBtn.tag = i;
        shareBtn.contentAlignmentCenter = YES;
        shareBtn.imageTextSepHeight = 6;
        [shareBtn setImage:[UIImage imageNamed:self.shareToSnsNames[i]] forState:UIControlStateNormal];
        [shareBtn setTitle:name forState:UIControlStateNormal];
        [shareBtn setTitleColor:[UIColor colorWithHexString:@"a4a7a8"] forState:UIControlStateNormal];
        shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:shareBtn];
        WEAKSELF;
        shareBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.shareBegin) {
                weakSelf.shareBegin(self.shareToSnsNames[sender.tag]);
            }
        };
    }
}

@end
