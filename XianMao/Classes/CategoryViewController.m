//
//  CategoryViewController.m
//  XianMao
//
//  Created by simon cai on 11/12/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"

#import "GoodsListViewController.h"

#import "CoordinatingController.h"

#import "Command.h"

@interface CategoryViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain) UITableView *tableView;
@property(nonatomic,retain) NSMutableArray *dataSources;

@end

@implementation CategoryViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setupTopBarBackButton:[UIImage imageNamed:@"category_normal"]
                      imgPressed:[UIImage imageNamed:@"category_pressed"]];
    
//    UIImage *imgNormal = [UIImage imageNamed:@"category_normal"];
//    UIImage *imgPressed = [UIImage imageNamed:@"category_pressed"];
    CGFloat height = kTopBarHeight-kTopBarContentMarginTop;
//    CGFloat width = height;
//    CGFloat X = 15-(imgNormal!=nil?(width-imgNormal.size.width)/2:0);
//    UIButton *cateBtn = [[UIButton alloc] initWithFrame:CGRectMake(X, kTopBarContentMarginTop, width, height)];
//    cateBtn.backgroundColor = [UIColor clearColor];
//    [cateBtn addTarget:self action:@selector(handleCateButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [cateBtn setImage:imgNormal forState:UIControlStateHighlighted];
//    [cateBtn setImage:imgPressed forState:UIControlStateNormal];
//    [self.view addSubview:cateBtn];
//    cateBtn.selected = YES;
    
    
    CGFloat cateLblX = 14.f;//cateBtn.frame.origin.x+cateBtn.bounds.size.width+(15-(imgNormal!=nil?(width-imgNormal.size.width)/2:0));
    UILabel *cateLbl = [[UILabel alloc] initWithFrame:CGRectNull];
    cateLbl.text = @"商品分类";
    cateLbl.font = [UIFont systemFontOfSize:16.f];
    cateLbl.textColor = [UIColor colorWithHexString:@"181818"];
    [cateLbl sizeToFit];
    cateLbl.frame = CGRectMake(cateLblX, kTopBarContentMarginTop, cateLbl.bounds.size.width, height);
    [self.view addSubview:cateLbl];
    
    
    
    self.dataSources = [NSMutableArray arrayWithObjects:
                        [[CategoryTableViewCell buildCellDict:@"cate_clothes" title:@"服饰"] fillAction:^{
        GoodsListViewController *viewController = [[GoodsListViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }],
                        [[CategoryTableViewCell buildCellDict:@"cate_bag" title:@"箱包"] fillAction:^{
        GoodsListViewController *viewController = [[GoodsListViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }],
                        [[CategoryTableViewCell buildCellDict:@"cate_necklace" title:@"配饰"] fillAction:^{
        GoodsListViewController *viewController = [[GoodsListViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }],
                        [[CategoryTableViewCell buildCellDict:@"cate_cosmetic" title:@"美妆"] fillAction:^{
        GoodsListViewController *viewController = [[GoodsListViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }],
                        [[CategoryTableViewCell buildCellDict:@"cate_shoes" title:@"鞋子"] fillAction:^{
        GoodsListViewController *viewController = [[GoodsListViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }],
                        nil];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, kTopBarHeight, self.view.bounds.size.width, self.view.bounds.size.height-kTopBarHeight)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    self.tableView = nil;
    self.dataSources = nil;
}

- (void)handleCateButtonClicked:(UIButton*)sender
{
    [[CoordinatingController sharedInstance] closeSideMenu];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    [dict doAction];
}

@end


