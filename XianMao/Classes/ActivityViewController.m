//
//  ActivityViewController.m
//  XianMao
//
//  Created by simon on 2/14/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "ActivityViewController.h"

@interface ActivityViewController ()

@end

@implementation ActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    return [self.dataSources count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
//    
//    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
//    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
//    
//    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
//    if (tableViewCell == nil) {
//        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
//        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
//        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
//    }
//    [tableViewCell updateCellWithDict:dict];
//    
//    return tableViewCell;
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
//    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
//    return [ClsTableViewCell rowHeightForPortrait:dict];
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//}

@end



