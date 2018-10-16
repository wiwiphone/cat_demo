//
//  TagsExplanView.m
//  XianMao
//
//  Created by apple on 16/9/12.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "TagsExplanView.h"
#import "ApproveTagInfo.h"
#import "TagsExplainCell.h"
#import "GoodsDetailInfo.h"

@interface TagsExplanView ()

@property (nonatomic, strong) UILabel *titleLbl;

@end

@implementation TagsExplanView

-(UILabel *)titleLbl{
    if (!_titleLbl) {
        _titleLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleLbl.font = [UIFont systemFontOfSize:15.f];
        _titleLbl.textColor = [UIColor colorWithHexString:@"333333"];
        _titleLbl.text = @"服务说明";
        [_titleLbl sizeToFit];
    }
    return _titleLbl;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self addSubview:self.titleLbl];
        
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    [self.titleLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).offset(21);
    }];
    
}

-(void)getTagsArr:(NSArray *)tags{
    
    for (TagsExplainCell *cell in self.subviews) {
        if ([cell isKindOfClass:[TagsExplainCell class]]) {
            [cell removeFromSuperview];
        }
    }
    
    CGFloat margin = 0;
    for (int i = 0; i < tags.count; i++) {
        ApproveTagInfo *tagInfo = [[ApproveTagInfo alloc] init];
        
        if ([tags[i] isKindOfClass:[PromiseVo class]]) {
            PromiseVo * promise = (PromiseVo *)tags[i];
            tagInfo.iconUrl = promise.url;
            tagInfo.value = promise.describe;
            tagInfo.name = promise.entry;
        }else{
            tagInfo = tags[i];
        }
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectZero];
        lbl.font = [UIFont systemFontOfSize:12.f];
        lbl.numberOfLines = 0;
        [lbl sizeToFit];
        lbl.text = tagInfo.value;
        CGSize size = [lbl sizeThatFits:CGSizeMake(kScreenWidth-24, CGFLOAT_MAX)];
        TagsExplainCell *explainCell = [[TagsExplainCell alloc] initWithFrame:CGRectMake(0, 44+margin, kScreenWidth, (35+18+size.height))];
        margin += 35+18+size.height;
        [explainCell getApproveTagInfo:tagInfo];
        [self addSubview:explainCell];
        
        if (i == tags.count-1) {
            return;
        }
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(12, 44+margin, kScreenWidth-24, 1)];
        lineView.backgroundColor = [UIColor colorWithHexString:@"eeeeee"];
        [self addSubview:lineView];
        margin += 1;
    }
    
}

@end
