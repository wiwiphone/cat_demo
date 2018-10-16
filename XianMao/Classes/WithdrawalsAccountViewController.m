//
//  WithdrawalsAccountViewController.m
//  XianMao
//
//  Created by WJH on 16/11/18.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "WithdrawalsAccountViewController.h"
#import "PullRefreshTableView.h"
#import "BandcardTableViewCell.h"
#import "SepTableViewCell.h"
#import "WCAlertView.h"
#import "URLScheme.h"


@interface WithdrawalsAccountViewController()
@property (nonatomic, strong) NSMutableArray * dataSources;
@property (nonatomic, strong) PullRefreshTableView * tableView;
@property (nonatomic, strong) UILabel * footLabel;
@property (nonatomic, strong) UIView * contentView;

@end

@interface WithdrawalsAccountViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation WithdrawalsAccountViewController

-(UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _contentView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    }
    return _contentView;
}

-(UILabel *)footLabel
{
    if (!_footLabel) {
        _footLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth-14, 20)];
        _footLabel.textColor = [UIColor colorWithHexString:@"b2b2b2"];
        _footLabel.font = [UIFont systemFontOfSize:12];
        _footLabel.textAlignment = NSTextAlignmentRight;
        _footLabel.text = @"周一至周五09:00 - 18:00";
    }
    return _footLabel;
}

-(NSMutableArray *)dataSources
{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PullRefreshTableView *)tableView
{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 65.5, kScreenWidth, kScreenHeight-65.5) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
        _tableView.separatorStyle = UITableViewCellEditingStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.pullTableIsLoadingMore = NO;
    }
    return _tableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [super setupTopBar];
    if (self.withdrawalsVo.type == 0) {
        [super setupTopBarTitle:@"管理支付宝"];
    }else if (self.withdrawalsVo.type == 1){
        [super setupTopBarTitle:@"管理银行卡"];
    }
    [super setupTopBarBackButton];
    [self.view addSubview:self.tableView];
    [self.contentView addSubview:self.footLabel];
    self.tableView.tableFooterView = self.contentView;
    [self loadData];
}

- (void)loadData {
   
    [self.dataSources addObject:[SepTableViewCell buildCellDict]];
    if (self.withdrawalsVo.type == 0) {
        [self.dataSources addObject:[alipayAccountCell buildCellDict:self.withdrawalsVo]];
    }else if (self.withdrawalsVo.type == 1){
        [self.dataSources addObject:[BandcardTableViewCell buildCellDict:self.withdrawalsVo]];
    }
    [self.dataSources addObject:[SepTableViewCell buildCellDict]];
    [self.dataSources addObject:[ServerTelCell buildCellDict]];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    
    if (ClsTableViewCell == [ServerTelCell class]) {
        [WCAlertView showAlertWithTitle:@"联系客服" message:kCustomServicePhoneDisplay customizationBlock:^(WCAlertView *alertView) {
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex == 0) {
                
            }else{
                NSString * phoneNumber = [@"tel://" stringByAppendingString:kCustomServicePhone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSources.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [clsTableViewCell rowHeightForPortrait:dict];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary * dict = [self.dataSources objectAtIndex:indexPath.row];
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString * reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell * Cell = (BaseTableViewCell *)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (Cell == nil) {
        Cell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        Cell.backgroundColor = [UIColor whiteColor];
        Cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    
    [Cell updateCellWithDict:dict];
    return Cell;
}

@end
