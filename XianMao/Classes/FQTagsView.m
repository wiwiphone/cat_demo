//
//  FQTagsView.m
//  XianMao
//
//  Created by apple on 16/9/19.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "FQTagsView.h"
#import "NetworkManager.h"
#import "Error.h"
#import "TagScrollView.h"

@interface FQTagsView () <SGTopTitleViewDelegate>

@property (nonatomic, strong) TagScrollView *tagScrollView;
@property (nonatomic, strong) NSArray *tagList;

@end

@implementation FQTagsView

-(NSArray *)tagList{
    if (!_tagList) {
        _tagList = [[NSArray alloc] init];
    }
    return _tagList;
}

-(TagScrollView *)tagScrollView{
    if (!_tagScrollView) {
        _tagScrollView = [[TagScrollView alloc] initWithFrame:CGRectZero];
        _tagScrollView.delegate_SG = self;
        _tagScrollView.bounces = YES;
    }
    return _tagScrollView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        [[CoordinatingController sharedInstance] showProcessingHUD:nil];
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"fq_tag_list" parameters:@{@"page":@1} completionBlock:^(NSDictionary *data) {
            
            NSLog(@"%@", data);
            [[CoordinatingController sharedInstance] hideHUD];
            NSArray *tagList = data[@"result"];
            weakSelf.tagList = tagList;
            [weakSelf addSubview:weakSelf.tagScrollView];
            weakSelf.tagScrollView.frame = CGRectMake(0, 0, kScreenWidth, 44+42+7-51-1);
            weakSelf.tagScrollView.scrollTitleArr = tagList;
            
            
        } failure:^(XMError *error) {
            [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
        
    }
    return self;
}

-(void)SGTopTitleView:(TagScrollView *)topTitleView didSelectTitleAtIndex:(NSInteger)index{
    
    TagListModel *listModel = [[TagListModel alloc] initWithJSONDictionary:self.tagList[index]];
    if (self.serveTagTable) {
        self.serveTagTable(listModel, index, self.tagList);
    }
    
}

@end
