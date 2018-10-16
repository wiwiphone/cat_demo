//
//  NewMessageHeaderView.m
//  XianMao
//
//  Created by 阿杜 on 16/3/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "NewMessageHeaderView.h"
#import "HeaderCellView.h"


#define kCellHeight 68
#define kBaseCellTag 1000

@implementation NewMessageHeaderView
//@synthesize dataArr;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.dataArr = [NSArray array];
    }
    return self;
}

- (instancetype)initWithArr:(NSArray *)arr {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, kScreenWidth, arr.count * kCellHeight + 9);
//        self.dataArr = [NSArray array];
        self.dataArr = [arr copy];
        [self getCellWithArr:arr];
    }
    return self;
}

- (void)getCellWithArr:(NSArray *)arr {
    for (int i = 0; i < arr.count; i++) {
        HeaderCellView *cellView = [[HeaderCellView alloc] initWithFrame:CGRectMake(0, kCellHeight * i, kScreenWidth, kCellHeight)];
        if (1) {
            cellView.numLB.hidden = NO;
        }
        [cellView updateWithDic:arr[i]];
        cellView.tag = kBaseCellTag + i;
        [self addSubview:cellView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [cellView addGestureRecognizer:tap];
        
    }
    if (arr.count > 0) {
        UIView *grayView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellHeight * self.dataArr.count, kScreenWidth, 9)];
        grayView.backgroundColor = [UIColor colorWithHexString:@"dcdddd"];
        [self addSubview:grayView];
    }
}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    HeaderCellView *cell = (HeaderCellView *)tap.view;
    cell.numLB.text = @"0";
    cell.numLB.hidden = YES;
    
//    cell.dic
}

- (void)updateWithArr:(NSArray *)arr {
    self.dataArr = [arr copy];
    [self getCellWithArr:arr];
}

- (NSArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [NSArray array];
    }
    return _dataArr;
}

@end

