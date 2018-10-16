//
//  AreaViewController.m
//  XianMao
//
//  Created by simon on 12/5/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "AreaViewController.h"
#import "JSONKit.h"

#import "AreaTableViewCell.h"

@interface AreaViewController () <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray *dataSources;

@end

@implementation AreaViewController

- (id)init {
    self = [super init];
    if (self) {
        _areaTableType = AreaTableTypeUnknown;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:self.title&&[self.title length]>0?self.title:@"地区"];
    //[super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    if (self.navigationController) {
        if (self.navigationController.viewControllers.count == 1) {
            [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
        } else {
            [super setupTopBarBackButton];
        }
    } else {
        [super setupTopBarBackButton:[UIImage imageNamed:@"close"] imgPressed:nil];
    }
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight)];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.alwaysBounceVertical = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    
    _dataSources = [[NSMutableArray alloc] init];
    
    if (_areaTableType == AreaTableTypeUnknown) {
        
    }
    if (!_areaItems || _areaTableType == AreaTableTypeUnknown) {
        _areaTableType = AreaTableTypeProvince;
        
        NSString* filePath =[[NSBundle mainBundle] pathForResource:@"cities" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
        NSError *error = nil;
        JSONDecoder *parser = [JSONDecoder decoder];
        id result = [parser mutableObjectWithData:jsonData error:&error];
        if ([result isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict = result;
            NSArray *list = [dict arrayValueForKey:@"list"];
            for (int i=0;i<[list count];i++) {
                if ([[list objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                    [_dataSources addObject:[AreaTableViewCell buildCellDict:[list objectAtIndex:i] AreaTableType:_areaTableType]];
                }
            }
        }
    } else {
        for (int i=0;i<[_areaItems count];i++) {
            if ([[_areaItems objectAtIndex:i] isKindOfClass:[NSDictionary class]]) {
                [_dataSources addObject:[AreaTableViewCell buildCellDict:[_areaItems objectAtIndex:i] AreaTableType:_areaTableType]];
            }
        }
        [_tableView reloadData];
    }
    
    [self bringTopBarToTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
    NSDictionary *dict = [[_dataSources objectAtIndex:[indexPath row]] objectForKey:@"areaData"];
    if (_areaTableType == AreaTableTypeProvince) {
        AreaViewController *viewController = [[AreaViewController alloc] init];
        viewController.areaTableType = AreaTableTypeCity;
        viewController.areaItems = [dict cityList];
        viewController.areaName = [dict provinceName];
        viewController.title = [dict provinceName];
        viewController.delegate = self.delegate;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (_areaTableType == AreaTableTypeCity) {
        AreaViewController *viewController = [[AreaViewController alloc] init];
        viewController.areaTableType = AreaTableTypeDistrict;
        viewController.areaItems = [dict districtList];
        viewController.areaName = [NSString stringWithFormat:@"%@%@",self.areaName,[dict cityName]];
        viewController.title = [dict cityName];
        viewController.delegate = self.delegate;
        [self.navigationController pushViewController:viewController animated:YES];
    }
    else if (_areaTableType == AreaTableTypeDistrict) {
        NSString *districtID = [dict districtID];
        NSString *areaName = [NSString stringWithFormat:@"%@%@",self.areaName,[dict district]];
        if (self.delegate && [self.delegate respondsToSelector:@selector(areaDidSelected:districtID:areaName:)]) {
            [self.delegate areaDidSelected:self districtID:districtID areaName:areaName];
        }
        
        if ([self.delegate isKindOfClass:[UIViewController class]]) {
            [self.navigationController popToViewController:(UIViewController *)(self.delegate) animated:YES];
            
//            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
//        self.navigationController pop
        
    }
}

@end



