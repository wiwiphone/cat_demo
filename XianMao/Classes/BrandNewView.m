//
//  BrandNewView.m
//  XianMao
//
//  Created by apple on 16/9/21.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "BrandNewView.h"
#import "PullRefreshTableView.h"
#import "LoadingView.h"
#import "NetworkManager.h"
#import "BrandInfo.h"
#import "NSString+Addtions.h"
#import "BaseTableViewCell.h"
#import "CateBrandBrandCell.h"
#import "URLScheme.h"
#import "SearchViewController.h"
#import "BrandVO.h"
#import "CateBrandHeaderView.h"

@interface BrandNewView ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate>

@property(nonatomic, strong) NSMutableDictionary *sections;
@property(nonatomic,assign) NSInteger numOfColumns;
@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic,copy) NSString *params;
@property (nonatomic, strong) CateBrandHeaderView *headerView;

@end

@implementation BrandNewView

-(CateBrandHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[CateBrandHeaderView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        WEAKSELF;
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"search_recommend_brand" parameters:nil completionBlock:^(NSDictionary *data) {
            
            CGFloat headerViewHeight = 0;
            CGFloat count;
            NSArray *list = data[@"list"];
            if (list.count%3 == 0) {
                count = list.count/3;
            } else {
                count = list.count/3+1;
            }
            headerViewHeight = ((kScreenWidth/3)*count)+12+60;
            
            _numOfColumns = 4;
            weakSelf.sections = [[NSMutableDictionary alloc] init];
            
            PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
            [weakSelf addSubview:tableView];
            weakSelf.tableView = tableView;
            weakSelf.tableView.backgroundColor = [UIColor colorWithHexString:@"f7f7f7"];
            weakSelf.tableView.pullDelegate = self;
            weakSelf.tableView.enableRefreshing = NO;
            weakSelf.tableView.enableLoadingMore = NO;
            weakSelf.tableView.delegate = weakSelf;
            weakSelf.tableView.dataSource = weakSelf;
            weakSelf.tableView.backgroundColor = [UIColor whiteColor];
            weakSelf.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
            weakSelf.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            weakSelf.tableView.contentMarginTop = 0;//kTopBarHeight-2;
            weakSelf.tableView.sectionIndexColor = [UIColor colorWithHexString:@"666666"];//
            weakSelf.headerView.frame = CGRectMake(0, 0, kScreenWidth, headerViewHeight);
            [weakSelf.headerView getBrandVoList:list];
            weakSelf.tableView.tableHeaderView = weakSelf.headerView;
            
            if ([weakSelf.tableView respondsToSelector:@selector(setSectionIndexBackgroundColor)]) {
                [weakSelf.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
            }
            
            [weakSelf loadData];
            
        } failure:^(XMError *error) {
            [[CoordinatingController sharedInstance] showHUD:[error errorMsg] hideAfterDelay:0.8];
        } queue:nil]];
    }
    return self;
}

- (void)loadData {
    WEAKSELF;
    if ([weakSelf.sections count]==0) {
        [weakSelf showLoadingView];
        
        NSDictionary *params = @{@"params":[self.params length]>0?self.params:@""};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"brand" path:@"get_list" parameters:params completionBlock:^(NSDictionary *data) {
            [weakSelf hideLoadingView];
            weakSelf.tableView.pullTableIsRefreshing = NO;
            NSMutableDictionary *sections = [[NSMutableDictionary alloc] init];
            NSArray *dictArray = [data arrayValueForKey:@"list"];
            if ([dictArray isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in dictArray) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        BrandInfo *brandInfo = [BrandInfo createWithDict:dict];
                        if ([brandInfo brandName].trim.length>0 && [brandInfo iconUrl].trim.length>0) {
                            NSString *firstLetter = [brandInfo getFirstNameEn];
                            BOOL found = NO;
                            for (NSString *str in [sections allKeys]) {
                                if ([str isEqualToString:[firstLetter uppercaseString]]) {
                                    found = YES;
                                    NSMutableArray *brandsList = (NSMutableArray*)[sections objectForKey:[firstLetter uppercaseString]];
                                    [brandsList addObject:brandInfo];
                                    break;
                                }
                            }
                            if (!found) {
                                NSMutableArray *brandsList = [[NSMutableArray alloc] init];
                                [brandsList addObject:brandInfo];
                                [sections setValue:brandsList forKey:[firstLetter uppercaseString]];
                            }
                        }
                    }
                }
            }
            // Sort each section array
            for (NSString* key in [sections allKeys]) {
                [[sections objectForKey:key] sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"brandEnName" ascending:YES]]];
            }
            
            //            NSMutableDictionary *numSections = [[NSMutableDictionary alloc] init];
            //            NSMutableDictionary *tmpSections = [[NSMutableDictionary alloc] initWithDictionary:sections];
            //            for (NSString* key in [sections allKeys]) {
            //                if ([key isNumeric]) {
            //                    [numSections setObject:[sections objectForKey:key] forKey:key];
            //                }
            //            }
            //
            //            for (NSString* key in [numSections allKeys]) {
            //                [tmpSections removeObjectForKey:key];
            //            }
            //
            //            for (NSString* key in [numSections allKeys]) {
            //                [tmpSections setObject:[numSections objectForKey:key]  forKey:key];
            //            }
            //
            //            sections = tmpSections;
            
            NSMutableDictionary *sectionsDataSoures = [[NSMutableDictionary alloc] init];
            for (NSString* key in [sections allKeys]) {
                NSMutableArray *brandsList = (NSMutableArray*)[sections objectForKey:key];
                NSMutableArray *dataSources = [[NSMutableArray alloc] init];
                NSMutableArray *groupBrands = nil;
                for (NSInteger i=0;i<[brandsList count];i++) {
                    if (!groupBrands) {
                        groupBrands = [[NSMutableArray alloc] init];
                    }
                    [groupBrands addObject:[brandsList objectAtIndex:i]];
//                    if ([groupBrands count]>=weakSelf.numOfColumns) {
//                        [dataSources addObject:[ExploreBrandTableViewCell buildCellDict:groupBrands numOfColums:weakSelf.numOfColumns marginLeft:weakSelf.numOfColumns==3?62:0]];
//                        groupBrands = nil;
//                    }
//                    for (int i = 0; i < groupBrands.count; i++) {
//                        [dataSources addObject:[CateBrandBrandCell buildCellDict:groupBrands[i]]];
//                    }
                }
//                if (groupBrands && [groupBrands count]>0) {
//                    [dataSources addObject:[ExploreBrandTableViewCell buildCellDict:groupBrands numOfColums:weakSelf.numOfColumns marginLeft:weakSelf.numOfColumns==3?62:0]];
                    for (int i = 0; i < groupBrands.count; i++) {
                        [dataSources addObject:[CateBrandBrandCell buildCellDict:groupBrands[i]]];
                    }
//                }
                if (dataSources && [dataSources count]>0) {
                    [sectionsDataSoures setObject:dataSources forKey:key];
                }
            }
            
            weakSelf.sections = sectionsDataSoures;
            
            [weakSelf.tableView reloadData];
        } failure:^(XMError *error) {
//            [weakSelf  loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf loadData];
//                });
//            };
        } queue:nil]];
    } else {
        //        weakSelf.tableView.pullTableIsRefreshing = YES;
        [weakSelf.tableView reloadData];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [self loadData];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_sections count];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 30)];
    [sectionView setBackgroundColor:[UIColor whiteColor]];
     
    UIView *blackView = [[UIView alloc] initWithFrame:CGRectMake(10, 0, tableView.bounds.size.width-41, 30)];
    blackView.backgroundColor = [UIColor colorWithHexString:@"333333"];
    [sectionView addSubview:blackView];
    
    CGFloat marginLeft = 0;//self.numOfColumns==3?62:0;
    marginLeft += 20;
    
    NSString* title = [[[self.sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:section];
    
    //增加UILabel
    UILabel *text = [[UILabel alloc] initWithFrame:CGRectMake(marginLeft, 0, self.width-marginLeft, sectionView.height)];
    [text setTextColor:[UIColor colorWithHexString:@"ffffff"]];
    [text setBackgroundColor:[UIColor clearColor]];
    [text setText:title];
    [text setFont:[UIFont boldSystemFontOfSize:12.0]];
    [sectionView addSubview:text];
    return sectionView;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString* title = [[[self.sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:section];
//    return title;
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sections valueForKey:
             [[[self.sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)] objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = nil;
    NSArray *keyArray = [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    dict = [[_sections valueForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [tableViewCell updateCellWithDict:dict];
    
    return tableViewCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = nil;
    NSArray *keyArray = [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    dict = [[_sections valueForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    if (ClsTableViewCell == [CateBrandBrandCell class]) {
        BrandInfo *brandInfo = dict[@"brandInfo"];
        if (brandInfo.redirect_uri != nil) {
            [URLScheme locateWithRedirectUri:brandInfo.redirect_uri andIsShare:NO];
        } else {
            SearchViewController *searchVC = [[SearchViewController alloc] init];
            searchVC.searchKeywords = brandInfo.brandName;
            [[CoordinatingController sharedInstance] pushViewController:searchVC animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keyArray = [[_sections allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSDictionary *dict = [[_sections valueForKey:[keyArray objectAtIndex:indexPath.section]] objectAtIndex:indexPath.row];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}


- (LoadingView*)showLoadingView {
    LoadingView *view = [LoadingView showLoadingView:self];
    view.frame = CGRectMake(0, 0, self.width, self.height);
    view.backgroundColor = [UIColor whiteColor];
    return view;
}

- (void)hideLoadingView {
    [LoadingView hideLoadingView:self];
}

@end
