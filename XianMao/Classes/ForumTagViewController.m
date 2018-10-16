//
//  ForumTagViewController.m
//  XianMao
//
//  Created by apple on 16/1/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "ForumTagViewController.h"
#import "DataListLogic.h"
#import "JSONModel.h"
#import "JSONModelProperty.h"
#import "JSONKit.h"
#import "NSString+URLEncoding.h"
#import "ForumPostTableViewCell.h"
#import "Error.h"

#import "ForumService.h"

@interface ForumTagViewController ()

@property (nonatomic, strong) NSMutableArray *tagPostArr;
@property (nonatomic, strong) ForumPostVO *postVO;

@end

@implementation ForumTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topBarRightButton.hidden = YES;
    WEAKSELF;
    if ([weakSelf.dataSources count]>0) {
        NSDictionary *dict = [weakSelf.dataSources objectAtIndex:0];
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
    }
    
    [ForumService getPostTagData:self.tagText completion:^(NSMutableArray *topic) {
        
        self.tagPostArr = topic;
        [self.tableView reloadData];
//        for (ForumPostVO *post in topic) {
//            NSLog(@"%@", post);
        
            NSString *paramsJsonData = [[self.tagText JSONString] URLEncodedString];//self.selectedFilterVO?[[self.selectedFilterVO toJSONDictionary] JSONString]:@"";
            self.dataListLogic = [[DataListLogic alloc] initWithModulePath:@"forum" path:@"post_list_by_label" pageSize:20];
            self.dataListLogic.parameters = @{@"params":paramsJsonData};//,@"topic_id":[NSNumber numberWithInteger:self.topic_id]
            self.dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
//        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (weakSelf.dataListLogic) {
                [weakSelf.dataListLogic reloadDataListByForce];
            } else {
                [weakSelf initDataListLogic];
            }
        });
    } failure:^(XMError *error) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
            [weakSelf loadData];
        };
    }];
}

-(void)initDataListLogicSetBlock{
    
    [super initDataListLogicSetBlock];
    WEAKSELF;
    
    self.dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        [weakSelf.dataSources removeAllObjects];
        [weakSelf.tableView reloadData];
        NSMutableArray *newList = weakSelf.dataSources;
        
        //        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        if ([weakSelf.topicVO.head_text length]>0) {
            [newList addObject:[ForumTopicDescTableViewCell buildCellDict:weakSelf.topicVO.head_text]];
        }
        [newList addObject:[ForumPostSearchTableCell buildCellDict]];
        
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [weakSelf.tagPostArr objectAtIndex:i];
            if ([dict isKindOfClass:[NSDictionary class]]) {
                ForumPostVO *postVO = [[ForumPostVO alloc] initWithJSONDictionary:dict];
                if ([postVO.content length]>0 || [postVO.attachments count]>0) {
                    [newList addObject:[ForumPostCatHouseTableViewCell buildCellDict:postVO]];
                    [newList addObject:[ForumPostTableSepCell buildCellDict]];
                }
            }
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    };
    
    self.dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *dataSources = weakSelf.dataSources;
        if ([dataSources count]==0) {
            if ([weakSelf.topicVO.head_text length]>0) {
                [dataSources addObject:[ForumTopicDescTableViewCell buildCellDict:weakSelf.topicVO.head_text]];
            }
            //            [dataSources addObject:[ForumPostSearchTableCell buildCellDict]];
        }
        for (int i=0;i<[addedItems count];i++) {
            NSDictionary *dict = [weakSelf.tagPostArr objectAtIndex:i];
            
            ForumPostVO *postVO = [[ForumPostVO alloc] initWithJSONDictionary:dict];
            if ([postVO.content length]>0 || [postVO.attachments count]>0) {
                [dataSources addObject:[ForumPostCatHouseTableViewCell buildCellDict:postVO]];
                [dataSources addObject:[ForumPostTableSepCell buildCellDict]];
            }
        }
        [weakSelf.tableView reloadData];
    };
}

-(void)initDataListLogic{
    
    
    [self initDataListLogicSetBlock];
}

-(void)loadData{
    if (self.dataSources.count == 0) {
        [super loadData];
    }
}


@end
