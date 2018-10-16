//
//  NewMessageViewController.m
//  XianMao
//
//  Created by 阿杜 on 16/3/28.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "NewMessageViewController.h"
#import "Masonry.h"
#import "NetworkManager.h"
#import "Session.h"

#import "MyNavigationController.h"
#import "NoticeViewController.h"

#import "MJDIYHeader.h"
#import "MsgCountManager.h"
#import "NSDate+Category.h"


#define kNumLBW (17 / 2.)
#define kNewMessageIdentifier @"newMessageCell"
@interface NewMessageViewController () {
    NSInteger lastNotice_count;
}

@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation NewMessageViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[NewInformationCell class] forCellReuseIdentifier:kNewMessageIdentifier];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"dcdddd"];
        
        MJDIYHeader *header = [MJDIYHeader headerWithRefreshingBlock:^{
            [self loadData];
        }];
        _tableView.mj_header = header;
        
    }
    return _tableView;
}

- (NSMutableArray *)dataArr {
    if (!_dataArr) {
        _dataArr = [@[] mutableCopy];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"dcdddd"];
    [self.view addSubview:self.tableView];
    
    
    [self setupUI];
    
    [self loadData];
    
    
//    lastNotice_count = [[MsgCountManager sharedInstance] noticeCount];
}

- (void)loadData {
    NSString *URLstr = @"/notification/get_notice_types";
    
//    [self showLoadingView];
    WEAKSELF;
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:URLstr path:@"" parameters:nil completionBlock:^(NSDictionary *data) {
        [weakSelf.tableView.mj_header endRefreshing];
//        [weakSelf hideLoadingView];
//        NSLog(@"data:%@", data);
        NSArray *arr = [data objectForKey:@"get_notices_types"];
//        NSLog(@"arr:%@", arr);
        weakSelf.dataArr = [arr mutableCopy];
        
        
        [weakSelf.tableView reloadData];
    } failure:^(XMError *error) {
//        [weakSelf hideLoadingView];
        [weakSelf showHUD:error.errorMsg hideAfterDelay:0.8];
    } queue:nil]];
    
    
}

- (void) setupUI {
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewInformationCell *cell = [tableView dequeueReusableCellWithIdentifier:kNewMessageIdentifier];
    if (!cell) {
        cell = [[NewInformationCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kNewMessageIdentifier];
    }
    NSDictionary *dic = self.dataArr[indexPath.row];
    [cell updateWithDic:dic];
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%ld, %ld", (long)indexPath.section, (long)indexPath.row);
    
    NewInformationCell *cell = (NewInformationCell *)[tableView cellForRowAtIndexPath:indexPath];
    cell.numLB.text = @"0";
    cell.numLB.hidden = YES;
    NoticeViewController *notiVC = [[NoticeViewController alloc] init];
    NSString *titleStr = [self.dataArr[indexPath.row] objectForKey:@"name"];
    notiVC.titleStr = titleStr;
    notiVC.noticeType = [[self.dataArr[indexPath.row] objectForKey:@"type"] integerValue];
    notiVC.notice_count = [[self.dataArr[indexPath.row] objectForKey:@"new_notice_count"] integerValue];
    if (lastNotice_count) {
        lastNotice_count -= [[self.dataArr[indexPath.row] objectForKey:@"new_notice_count"] integerValue];
    }
    NSDictionary *data = @{@"type":@(indexPath.row)};
    [ClientReportObject clientReportObjectWithViewCode:MessageNavNotifyTypeViewCode regionCode:MessageNavNotifyViewCode referPageCode:MessageNavNotifyViewCode andData:data];
    [self pushViewController:notiVC animated:YES];
 
}

//handleNoticeCountDidFinishNotification
- (void)$$handleNoticeCountDidFinishNotification:(id<MBNotification>)notifi noticeCount:(NSNumber*)noticeCount
{
    if (lastNotice_count != [noticeCount integerValue]) {
//        [self.tableView.mj_header beginRefreshing];
        [self loadData];
        [self.tableView reloadData];
        lastNotice_count = [noticeCount integerValue];
    }
}


- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

@end


@interface NewInformationCell ()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSDictionary *dic;

@end

@implementation NewInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addSubview:self.lineView];
        [self addSubview:self.myImageView];
        [self addSubview:self.myTitleLB];
        [self addSubview:self.mySubTitleLB];
        [self addSubview:self.timeLB];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //add code
        [self.myImageView addSubview:self.numLB];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void) updateWithDic:(NSDictionary *)dic {
    self.dic = [dic copy];
    
    [self.myImageView sd_setImageWithURL:[dic objectForKey:@"icon_url"]];
    
    self.myTitleLB.text = [dic objectForKey:@"name"];
    
    
    if ([dic objectForKey:@"new_notice"] == [NSNull null]) {
        self.mySubTitleLB.text = [NSString stringWithFormat:@"暂无%@", [dic objectForKey:@"name"]];
    } else {
        self.mySubTitleLB.text = [[dic objectForKey:@"new_notice"] objectForKey:@"brief"];
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"dd日 HH:MM"];
        NSString *dateStr = [[dic objectForKey:@"new_notice"] objectForKey:@"sendtime"];
        NSDate *date = [NSDate dateFromLongLongSince1970:[dateStr longLongValue]];
        
        NSString *finnalTime = [date minuteDescription];
        self.timeLB.text = finnalTime;
        
    }
    
    if ([[dic objectForKey:@"new_notice_count"] integerValue] > 0) {
        self.numLB.hidden = NO;
        self.numLB.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"new_notice_count"]];
    }
    
    
    
    
}

- (void)layoutSubviews {
    [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.width.equalTo(@47);
        make.height.equalTo(@47);
        
    }];
    
    [self.myTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.myImageView.mas_right).offset(14);
        make.top.equalTo(self.contentView.mas_top).offset(17);
    }];

    [self.mySubTitleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.myTitleLB.mas_bottom).offset(6);
        make.left.equalTo(self.myTitleLB.mas_left);
        make.width.equalTo(@(kScreenWidth - 77 - 100));
    }];

    [self.timeLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_left).offset(kScreenWidth - 19);
        make.top.equalTo(self.myTitleLB.mas_top);
    }];
    
    if (!self.numLB.hidden) {
        [self.numLB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.myImageView.mas_top).offset(3);
            make.left.equalTo(self.myImageView.mas_left).offset(35);
            make.width.equalTo(@17);
            make.height.equalTo(@17);
        }];
    }
}

- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5f)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    }
    return _lineView;
}

- (UIImageView *)myImageView {
    if (!_myImageView) {
        _myImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _myImageView.contentMode = UIViewContentModeScaleAspectFit;
        _myImageView.layer.cornerRadius = 47 / 2.f;
//        _myImageView.clipsToBounds = YES;
    }
    return _myImageView;
}

- (UILabel *)myTitleLB {
    if (!_myTitleLB) {
        _myTitleLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _myTitleLB.font = [UIFont systemFontOfSize:15.f];
        _myTitleLB.textColor = [UIColor colorWithHexString:@"595757"];
        [_myTitleLB sizeToFit];
    }
    return _myTitleLB;
}

- (UILabel *)mySubTitleLB {
    if (!_mySubTitleLB) {
        _mySubTitleLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _mySubTitleLB.font = [UIFont systemFontOfSize:13.0f];
        _mySubTitleLB.textColor = [UIColor colorWithHexString:@"898989"];
//        [_mySubTitleLB sizeToFit];
    }
    return _mySubTitleLB;
}

- (UILabel *)numLB {
    if (!_numLB) {
        _numLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _numLB.layer.cornerRadius = kNumLBW;
        _numLB.backgroundColor = [UIColor colorWithHexString:@"e83828"];
        _numLB.font = [UIFont systemFontOfSize:11.f];
        _numLB.textColor = [UIColor colorWithHexString:@"ffffff"];
        _numLB.textAlignment = NSTextAlignmentCenter;
        _numLB.clipsToBounds = YES;
        _numLB.hidden = YES;
        
    }
    return _numLB;
}

- (UILabel *)timeLB {
    if (!_timeLB) {
        _timeLB = [[UILabel alloc] initWithFrame:CGRectZero];
        _timeLB.font = [UIFont systemFontOfSize:9.f];
        _timeLB.textColor = [UIColor colorWithHexString:@"898989"];
    }
    return _timeLB;
}

@end