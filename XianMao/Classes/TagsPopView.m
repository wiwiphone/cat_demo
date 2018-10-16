//
//  TagsPopView.m
//  XianMao
//
//  Created by 阿杜 on 16/3/7.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "TagsPopView.h"
#import "User.h"

@interface TagsPopView () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation TagsPopView {
    UIButton *closeBtn;
}

- (instancetype)initWithFrame:(CGRect)frame tagsArr:(NSMutableArray *)tagsArr {
    self = [super initWithFrame:frame];
    if (self) {
        self.authArr = tagsArr;
        
        self.layer.cornerRadius = 8;
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
        self.headLB.frame = CGRectMake(0, 0, frame.size.width, 40);
        [self addSubview:self.headLB];
        
        self.tableView.frame = CGRectMake(0, CGRectGetMaxY(self.headLB.frame), frame.size.width, 55 * tagsArr.count);
//        self.tableView.frame = self.bounds;
        [self addSubview:self.tableView];
        
        
        self.footerView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), frame.size.width, 15);
        [self addSubview:self.footerView];
        
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(frame.size.width - 40, 3, 35, 35);
        closeBtn.contentMode = UIViewContentModeScaleToFill;
        //        closeBtn.backgroundColor = [UIColor grayColor];
        [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //        [closeBtn setTitle:@"test" forState:UIControlStateNormal];
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [self addSubview:closeBtn];
        [self bringSubviewToFront:closeBtn];
        
    }
    return self;
}

- (void)closeBtnAction:(UIButton *)btn {
    NSLog(@"close");
    //    [self removeFromSuperview];
    //    self.superview
    if (self.delegate) {
        [self.delegate dissmiss];
    }
    //    self = nil;
}

- (UIView *)footerView {
    if (!_footerView) {
        _footerView = [[UIView alloc] init];
        _footerView.backgroundColor = [UIColor clearColor];
    }
    return _footerView;
}

- (UILabel *)headLB {
    if (!_headLB) {
        _headLB = [[UILabel alloc] init];
        _headLB.textAlignment = NSTextAlignmentCenter;
        _headLB.font = [UIFont systemFontOfSize:17];
        _headLB.textColor = [UIColor whiteColor];
        _headLB.text = @"标签说明";
        _headLB.backgroundColor = [UIColor colorWithRed:0.401 green:0.529 blue:1.000 alpha:1.000];
        
        //        closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        ////        closeBtn.frame = CGRectMake(self.headLB.size.width - 50, 3, 35, 35);
        //        closeBtn.contentMode = UIViewContentModeScaleToFill;
        //        closeBtn.backgroundColor = [UIColor grayColor];
        //        [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        //        [closeBtn setTitle:@"test" forState:UIControlStateNormal];
        //        [closeBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        //        closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        //        [_headLB addSubview:closeBtn];
        
        
    }
    return _headLB;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor clearColor];
//        [_tableView registerClass:[TagsPopCell class] forCellReuseIdentifier:@"popcell"];
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.authArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserTagInfo *tag = self.authArr[indexPath.row];
    TagsPopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"popcell"];
    if (!cell) {
        cell = [[TagsPopCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"popcell"];
    }
    [cell updataWithTag:tag];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

@end

@implementation TagsPopCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.myImageView.frame = CGRectMake(10, 15, 24, 24);
        [self.contentView addSubview:self.myImageView];
        self.myLabel.frame = CGRectMake(self.myImageView.right + 10, 0, kScreenWidth - 40 - 30 - 24, 55);
        //        self.myLabel.backgroundColor = [UIColor orangeColor];
        [self.contentView addSubview:self.myLabel];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)updataWithTag:(UserTagInfo *)tag {
    self.myImageView.image = tag.icon;
    //    self.myLabel.text = tag.name;
    NSString *textStr = [NSString stringWithFormat:@""];
    NSLog(@"tag.name:%@", tag.name);
    if ([tag.name isEqualToString:@"实名认证"]) {
        textStr = @"实名认证: 已向爱丁猫平台提交个人信息,经爱丁猫平台核实的用户.";
    }
    if ([tag.name isEqualToString:@"诚信卖家"]) {
        textStr = @"诚信卖家: 在以往的交易记录中,经爱丁猫平台核实,拥有良好的服务的实名认证卖家.";
    }
    if ([tag.name isEqualToString:@"保证金"]) {
        textStr = @"保证金: 已向爱丁猫平台缴纳保证金的诚信卖家,如遇问题,可先行赔付.";
    }
    if ([tag.name isEqualToString:@"金牌卖家"]) {
        textStr = @"金牌卖家: 经爱丁猫平台选拔,在爱丁猫平台实力十足的,缴纳保证金的诚信卖家.";
    }
    if ([tag.name isEqualToString:@"回收卖家"]) {
        textStr = @"回收卖家: 在爱丁猫回收版块,提供回收服务的实名认证卖家.";
    }
    if ([tag.name isEqualToString:@"闪电发货"]) {
        textStr = @"闪电发货: 不需要经过爱丁猫平台鉴定,即刻发货的交纳保证金的诚信卖家.";
    }
    NSLog(@"textStr:%@", textStr);
    self.myLabel.text = textStr;
    
}

- (UIImageView *)myImageView {
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] init];
        _myImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _myImageView;
}

- (UILabel *)myLabel {
    if (!_myLabel) {
        _myLabel = [[UILabel alloc] init];
        _myLabel.font = [UIFont systemFontOfSize:12];
        _myLabel.numberOfLines = 0;
        [_myLabel sizeToFit];
    }
    return _myLabel;
}

@end
