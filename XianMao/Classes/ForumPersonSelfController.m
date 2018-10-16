//
//  ForumPersonSelfController.m
//  XianMao
//
//  Created by apple on 16/1/2.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ForumPersonSelfController.h"
#import "PullRefreshTableView.h"
#import "ForumPostTableViewCell.h"

#import "Masonry.h"

@interface ForumPersonSelfController () <UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *listArr;
@property (nonatomic, weak) PullRefreshTableView *tableView;

@end

@implementation ForumPersonSelfController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat topBarHeight = [super setupTopBar];
    
    [super setupTopBarBackButton];
    
    
    [self setupTopBarTitle:@"测试个人主页"];
//    UIView *keepOutView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 50, 0, 50, self.topBar.height)];
//    keepOutView.backgroundColor = [UIColor whiteColor];
//    [self.topBar addSubview:keepOutView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setDataList:) name:@"setData" object:nil];
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, kScreenWidth, kScreenHeight - topBarHeight) style:UITableViewStylePlain];
    
    tableView.dataSource = self;
    
//    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topBar.mas_bottom);
//        make.left.equalTo(self.view.mas_left);
//        make.right.equalTo(self.view.mas_right);
//        make.bottom.equalTo(self.view.mas_bottom);
//    }];
    [self.view addSubview:tableView];
    
}

-(void)setDataList:(NSNotification *)notify{
    NSMutableArray *listArr = notify.object;
    self.listArr = [NSMutableArray arrayWithArray:listArr];
    NSLog(@"%@", self.listArr);
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.listArr.count;
}

//-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    static NSString *ID = @"PullRefreshTableViewCell";
//    ForumOneSelfTableViewCell *cell = [[ForumOneSelfTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
//    
//    ForumPostList *postList = self.listArr[indexPath.row];
//    [cell setSubsDataWithList:postList];
//    
//    return cell;
//}



@end

