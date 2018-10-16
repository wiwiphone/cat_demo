//
//  RecommendViewController.m
//  XianMao
//
//  Created by simon on 2/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "DiscoveryViewController.h"
#import "CoordinatingController.h"
#import "PullRefreshTableView.h"
#import "GoodsDetailViewController.h"
#import "GoodsTableViewCell.h"
#import "SepTableViewCell.h"
#import "PhotoBroswerVC.h"
#import "SearchViewController.h"
#import "GoodsDetailViewController.h"
#import "ForumPostDetailViewController.h"
#import "GoodsCommentsViewController.h"

#import "DataListLogic.h"
#import "NetworkManager.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "Session.h"
#import "ForumOneSelfController.h"
#import "FeedsItem.h"
#import "GoodsInfo.h"
#import "GoodsMemCache.h"

#import "DataSources.h"

#import "AppDirs.h"
#import "ForumPostListViewController.h"
#import "RecommendTableViewCell.h"
#import "RecommendInfo.h"
#import "ActivityInfo.h"

#import "QrCodeScanViewController.h"
#import "NSString+Addtions.h"

#import "ShoppingCartViewController.h"

#import "RecommendService.h"
#import "URLScheme.h"
#import "JSONKit.h"
#import "UserHomeViewController.h"
#import "GuideView.h"
#import "SearchCateBrandViewController.h"
#import "SearchCateBrandButton.h"
@interface TopBarRightNewButton ()


@end

@implementation TopBarRightNewButton

- (id)init {
    self = [super init];
    if (self) {
        _isInEditing = NO;
    }
    return self;
}

- (void)setIsInEditing:(BOOL)isInEditing {
    if (_isInEditing!=isInEditing) {
        _isInEditing = isInEditing;
        
        if (isInEditing) {
            [self setImage:nil forState:UIControlStateNormal];
            [self setTitle:@"取消" forState:UIControlStateNormal];
            [self addSubviewWithZoomInAnimation:self duration:0.2f option:UIViewAnimationOptionCurveLinear];
        } else {
            [self setImage:[UIImage imageNamed:@"qrcode_scan"] forState:UIControlStateNormal];
            [self setTitle:nil forState:UIControlStateNormal];
            [self addSubviewWithZoomInAnimation:self duration:0.2f option:UIViewAnimationOptionCurveLinear];
        }
    }
}

- (void) addSubviewWithZoomInAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option {
    view.transform = CGAffineTransformIdentity;
    CGAffineTransform trans = CGAffineTransformScale(view.transform, 0.01, 0.01);
    
    view.transform = trans; // do it instantly, no animation
    if (view!=self)[self addSubview:view];
    // now return the view to normal dimension, animating this tranformation
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         view.transform = CGAffineTransformScale(view.transform, 100.0, 100.0);
                     }
                     completion:^(BOOL finished) {
                         //NSLog(@"done");
                     } ];
}


- (void) removeSubviewWithZoomOutAnimation:(UIView*)view duration:(float)secs option:(UIViewAnimationOptions)option {
    view.transform = CGAffineTransformIdentity;
    // now return the view to normal dimension, animating this tranformation
    WEAKSELF;
    [UIView animateWithDuration:secs delay:0.0 options:option
                     animations:^{
                         view.transform = CGAffineTransformScale(view.transform, 0.01, 0.01);
                     }
                     completion:^(BOOL finished) {
                         if (view!=weakSelf)[view removeFromSuperview];
                     }];
}

@end



@interface HomeRecommendNewViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, PhotoModelDelegate>

@property (nonatomic, strong) NSMutableArray *niceArray;
@property (nonatomic, strong) NSMutableArray *followArray;
@property (nonatomic, strong) NSArray *tempDataSource;
@property (nonatomic, weak) RecommendFloatBoxCell *floatCell;
@property (nonatomic, weak) UIView *container;
@property (nonatomic, weak) SelectButton *niceButton;
@property (nonatomic, weak) SelectButton *followButton;
@property (nonatomic, weak) CALayer *scrollLayer;
@property (nonatomic, assign) BOOL isMyFollow;
@property (nonatomic, strong) RecommendInfo *sectionInfo;
@property (nonatomic, strong) NSString *niceUrl;
@property (nonatomic, strong) NSString *followUrl;
@property (nonatomic, assign) NSInteger nicePage;
@property (nonatomic, assign) NSInteger followPage;
@property (nonatomic, assign) BOOL isfollowOver;
@property (nonatomic, assign) BOOL isniceOver;

@property (nonatomic, strong) RecommendForumCell *cell;

@end

@implementation HomeRecommendNewViewController

-(NSMutableArray *)niceArray{
    if (!_niceArray) {
        _niceArray = [[NSMutableArray alloc] init];
    }
    return _niceArray;
}

- (void)initDataListLogic {
    
    WEAKSELF;
    
    [weakSelf showLoadingView];
    
    DataListCacheArray *dataListCacheArray = [[DataListCacheArray alloc] init];
    [dataListCacheArray loadFromFile:[AppDirs recommendListCacheFile]];
    
    self.dataListLogic = [[DataListLogic alloc] initWithModulePath:self.urlStr path:@"" pageSize:1000 fetchSize:1000];
    self.dataListLogic.cacheStrategy = dataListCacheArray;
    self.dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0 ) {
            weakSelf.nicePage = 2;
            weakSelf.followPage = 2;
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    self.dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            RecommendInfo *recommendInfo = [RecommendInfo createWithDict:[addedItems objectAtIndex:i]];
            if (recommendInfo.type == 107) {
                weakSelf.sectionInfo = recommendInfo;
            }
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
                
                if ([recommendInfo recommendCellCls]==[RecommendGoodsWithCoverCell class]) {
                    [newList addObject:[RecommendGoodsWithCoverCell buildCellDict:recommendInfo isShowGoodsCover:YES isShowFollowBtn:NO pageIndex:0]];
                } else {
                    [newList addObject:[RecommendTableViewCell buildCellDict:recommendInfo]];
                }
                
            }
        }
        weakSelf.dataSources = [NSMutableArray arrayWithArray:newList];
        weakSelf.tempDataSource = newList;
        
        
        if (_sectionInfo.type == 107 && _sectionInfo.list.count >0) {
            RedirectInfo *redirInfo = weakSelf.sectionInfo.list[0];
            RedirectInfo *redirInfo1 = weakSelf.sectionInfo.list[1];
            weakSelf.niceUrl = redirInfo.url;
            weakSelf.followUrl = redirInfo1.url;
            NSDictionary *params = @{@"page":@(1), @"size":@(15), @"reqtype":@(0)};
            
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:redirInfo.url path:@"" parameters:params completionBlock:^(NSDictionary *data) {
                NSString *str = [data JSONString];
                NSLog(@"%@", str);
                NSArray *array = data[@"list"];
                weakSelf.niceArray = [NSMutableArray arrayWithArray:array];
                
                [weakSelf.tableView reloadData];
            } failure:nil queue:nil]];
            NSDictionary *paramss = @{@"page":@(1), @"size":@(15), @"reqtype":@(0)};
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:redirInfo1.url path:@"" parameters:paramss completionBlock:^(NSDictionary *data) {
                weakSelf.followArray = [NSMutableArray arrayWithArray:data[@"list"]];
            } failure:nil queue:nil]];
        }
        
        [weakSelf.tableView reloadData];
        
        [weakSelf.dataListLogic.cacheStrategy saveToFile:[AppDirs recommendListCacheFile] maxCount:50];
    }; //jakftodo
    self.dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    self.dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            
            RecommendInfo *recommendInfo = [RecommendInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
                if ([recommendInfo isRecommendTypeGoodsWithCover]
                    && [recommendInfo.list count]>0) {
                    for (NSInteger i=0;i<recommendInfo.list.count;i++) {
                        GoodsInfo *goodsInfo = recommendInfo.list[i];
                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                            GoodsInfo *goodsInfoTmp = [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                            [recommendInfo.list replaceObjectAtIndex:i withObject:goodsInfoTmp];
                        }
                    }
                }
                
                if ([recommendInfo recommendCellCls]==[RecommendGoodsWithCoverCell class]) {
                    [newList addObject:[RecommendGoodsWithCoverCell buildCellDict:recommendInfo isShowGoodsCover:YES isShowFollowBtn:NO pageIndex:0]];
                } else {
                    [newList addObject:[RecommendTableViewCell buildCellDict:recommendInfo]];
                }
            }
        }
        if ([newList count]>0) {
            //NSInteger count = [weakSelf.dataSources count];
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            [dataSources addObjectsFromArray:newList];
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    self.dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        //        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    self.dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton].handleRetryBtnClicked =^(LoadingView *view) {
            if ([weakSelf.dataSources count]==0 ) {
                [weakSelf showLoadingView];
            }
            [weakSelf.dataListLogic reloadDataListByForce];
        };
    };
    self.dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    [self.dataListLogic firstLoadFromCache];
}

- (void)loadMoreData
{
    
    WEAKSELF;
    if (_isMyFollow) {
        if (self.isfollowOver) {
            return;
        }
        NSDictionary *paramss = @{@"page":@(self.followPage), @"size":@(15), @"reqtype":@(0)};
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.followUrl path:@"" parameters:paramss completionBlock:^(NSDictionary *data) {
            weakSelf.followPage++;
            NSArray *array  = [data arrayValueForKey:@"list"];
            [weakSelf.followArray addObjectsFromArray: array];
            NSNumber *hasnext = data[@"hasNextPage"];
            if (hasnext.integerValue == 0) {
                self.isfollowOver = YES;
            }
            [weakSelf.tableView reloadData];
        } failure:nil queue:nil]];
    } else {
        if (self.isniceOver) {
            return;
        }
        NSDictionary *params = @{@"page":@(self.nicePage), @"size":@(15), @"reqtype":@(0)};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.niceUrl path:@"" parameters:params completionBlock:^(NSDictionary *data) {
            weakSelf.nicePage++;
            NSString *str = [data JSONString];
            NSLog(@"%@", str);
            NSArray *array = data[@"list"];
            [weakSelf.niceArray addObjectsFromArray:array];
            NSNumber *hasnext = data[@"hasNextPage"];
            if (hasnext.integerValue == 0) {
                self.isniceOver = YES;
            }
            [weakSelf.tableView reloadData];
        } failure:nil queue:nil]];
    }
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WEAKSELF;
    self.isMyFollow = NO;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    if ([NetworkManager sharedInstance].isReachableViaWiFi) {
        WEAKSELF;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf loadRecommendLauchImage];
        });
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPageImage) name:@"showPageImage" object:nil];
}

-(void)showPageImage{
    //    if ([GuideView isNeedShowWaitItGuideView]) {
    //        [GuideView showMainGuideView:self.view];
    //    }
}

- (void)loadRecommendLauchImage {
    
    if (![[NetworkManager sharedInstance] isReachableViaWiFi]) return;
    
    WEAKSELF;
    [RecommendService launch_list:^(NSArray *list) {
        if (list && [list count]>0) {
            
            NSString *filePath = [AppDirs recommendLaunchCacheFile];
            
            NSMutableArray *hasDisplayedList = nil;
            BOOL isDirectory = NO;
            NSFileManager *fm = [NSFileManager defaultManager];
            if (fm
                && [fm fileExistsAtPath:filePath isDirectory:&isDirectory]
                && !isDirectory) {
                NSData *data = [NSData dataWithContentsOfFile:filePath];
                NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
                NSDictionary *dict = [unarchiver decodeObjectForKey:@"data"];
                [unarchiver finishDecoding];
                hasDisplayedList = [[NSMutableArray alloc] initWithArray:[dict arrayValueForKey:@"items"]];
            }
            
            RedirectInfo *redirectInfoToShow = nil;
            
            for (RedirectInfo *redirectInfo in list) {
                BOOL hasDisplayed = NO;
                for (NSString *source in hasDisplayedList) {
                    if ([source length]>0 && [source isEqualToString:redirectInfo.source]) {
                        hasDisplayed = YES;
                        break;
                    }
                }
                if (hasDisplayed) {
                    continue;
                } else {
                    redirectInfoToShow = redirectInfo;
                    
                    if ([redirectInfoToShow.source length]>0) {
                        if (!hasDisplayedList) {
                            hasDisplayedList = [[NSMutableArray alloc] init];
                        }
                        [hasDisplayedList addObject:redirectInfoToShow.source];
                        NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                        [dict setObject:hasDisplayedList forKey:@"items"];
                        
                        NSMutableData *data = [[NSMutableData alloc] init];
                        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
                        [archiver encodeObject:dict forKey:@"data"];
                        [archiver finishEncoding];
                        [data writeToFile:[AppDirs recommendLaunchCacheFile] atomically:YES];
                    }
                    break;
                }
            }
            
            if (redirectInfoToShow
                && [redirectInfoToShow.imageUrl length]>0
                && redirectInfoToShow.width>0
                && redirectInfoToShow.height>0) {
                NSString *url = redirectInfoToShow.imageUrl;
                [[SDWebImageManager.sharedManager imageCache] removeImageForKey:url withCompletion:^{
                    if ([NetworkManager sharedInstance].isReachableViaWiFi) {
                        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:url]
                                                                        options:SDWebImageLowPriority
                                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                           NSLog(@"%@",[imageURL absoluteString]);
                                                                           [weakSelf showRecommendLauchImage:image redirectInfo:redirectInfoToShow];
                                                                       }];
                    }
                }];
            }
        }
    } failure:^(XMError *error) {
        
    }];
}



- (void)niceButtonAction
{
    if (!_niceButton.isSelect) {
        //埋点
        [ClientReportObject clientReportObjectWithViewCode:HomeChosenViewCode regionCode:HomeChosenRegionCode referPageCode:NoReferPageCode andData:nil];
        [UIView animateWithDuration:1 animations:^{
            _scrollLayer.frame = CGRectMake(10, kScreenWidth*35.f/320.f - 3, _niceButton.frame.size.width, 3);
        } completion:^(BOOL finished) {
            _niceButton.isSelect = YES;
            _followButton.isSelect = NO;
            [_niceButton setButtonStyle];
            [_followButton setButtonStyle];
            _isMyFollow = NO;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
}

- (void)followButtonAction
{
    if (!_followButton.isSelect) {
        
        //埋点
        [ClientReportObject clientReportObjectWithViewCode:HomeChosenMineAttentionViewCode regionCode:HomeChosenRegionCode referPageCode:NoReferPageCode andData:nil];
        [UIView animateWithDuration:1 animations:^{
            _scrollLayer.frame = CGRectMake(_niceButton.frame.size.width + 20, kScreenWidth*35.f/320.f - 1, _followButton.frame.size.width, 1);
        } completion:^(BOOL finished) {
            _followButton.isSelect = YES;
            _niceButton.isSelect = NO;
            [_niceButton setButtonStyle];
            [_followButton setButtonStyle];
            _isMyFollow = YES;
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        }];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _tempDataSource.count;
    } else {
        if (_isMyFollow) {
            return _followArray.count;
        } else {
            return _niceArray.count;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [UIView new];
    if (section == 0) {
        return view;
    } else {
        view.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*35.f/320.f);
        view.backgroundColor = [UIColor whiteColor];
        SelectButton *nice = [SelectButton buttonWithType:UIButtonTypeCustom];
        nice.titleLabel.font = [UIFont systemFontOfSize:16];
        nice.isSelect = !_isMyFollow;
        self.niceButton = nice;
        [nice setButtonStyle];
        [nice addTarget:self action:@selector(niceButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:nice];
        
        SelectButton *follow = [SelectButton buttonWithType:UIButtonTypeCustom];
        follow.selected = NO;
        follow.titleLabel.font = [UIFont systemFontOfSize:16];
        self.followButton = follow;
        self.followButton.isSelect = _isMyFollow;
        [follow setButtonStyle];
        [follow addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:follow];
        CALayer *layer = [[CALayer alloc] init];
        _scrollLayer = layer;
        layer.frame = CGRectZero;
        [view.layer addSublayer:layer];
        layer.backgroundColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
        
        if (_sectionInfo && [_sectionInfo isKindOfClass:[RecommendInfo class]]
            && [_sectionInfo.list count]>0) {
            RedirectInfo *niceDic = _sectionInfo.list[0];
            NSString *niceStr = niceDic.title;
            [_niceButton setTitle:niceStr forState:UIControlStateNormal];
            _niceButton.selectUrl = niceDic.url;
            
            
            RedirectInfo *followDic = _sectionInfo.list[1];
            NSString *followStr = followDic.title;
            [_followButton setTitle:followStr forState:UIControlStateNormal];
            _followButton.selectUrl = followDic.url;
            CGRect rect1 = [niceStr boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            _niceButton.frame = CGRectMake(10, (kScreenWidth*35.f/320.f - 20) /2.0 + 3, rect1.size.width + 20, 20);
            
            CGRect rect2 = [followStr boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            _followButton.frame = CGRectMake(10 + rect1.size.width + 20 + 10, (kScreenWidth*35.f/320.f - 20) /2.0 + 3, rect2.size.width + 20, 20);
            if (_isMyFollow) {
                _scrollLayer.frame = CGRectMake(10 + rect1.size.width + 20 + 10, kScreenWidth*35.f/320.f - 1, rect2.size.width + 20, 1);
            } else {
                _scrollLayer.frame = CGRectMake(10, kScreenWidth*35.f/320.f - 1 , rect1.size.width + 20, 1);
            }
        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return kScreenWidth*35.f/320.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BaseTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[RecommendForumCell class]]) {
        RecommendForumCell *celll = (RecommendForumCell *)cell;
        [celll didSelectThisCell];
    }
}

- (UITableViewHeaderFooterView *)footerViewForSection:(NSInteger)section {
    UITableViewHeaderFooterView * footer = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:@"footer"];
    footer.textLabel.text = @"Test";
    
    return footer;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    if (_isMyFollow) {
        if (self.followArray.count - 1 == indexPath.row) {
            [self loadMoreData];
        }
    }else if(self.niceArray.count - 1== indexPath.row){
        [self loadMoreData];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dict = [[NSDictionary alloc] init];
    
    if (indexPath.section == 0) {
        dict = [_tempDataSource objectAtIndex:[indexPath row]];
    } else {
        if (_isMyFollow) {
            dict = _followArray[indexPath.row];
        } else {
            dict = _niceArray[indexPath.row];
        }
    }
    if ([[dict allKeys] containsObject:@"type"]) {
        RecommendForumCell *cell = [tableView dequeueReusableCellWithIdentifier:[RecommendForumCell reuseIdentifier]];
        if (cell == nil) {
            cell = [[RecommendForumCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[RecommendForumCell reuseIdentifier]];
        }
        if (!_niceButton.isSelect) {
            cell.isChosen = 1;
        } else {
            cell.isChosen = 2;
        }
        WEAKSELF;
        cell.likeBlock = ^(NSInteger likeNum, BOOL islike, NSNumber *type, NSNumber *post_id) {
            
            NSMutableDictionary *dic;
            if (type.integerValue == 1) {
                dic = [NSMutableDictionary dictionaryWithDictionary:dict];
                NSMutableDictionary *goods_info = [NSMutableDictionary dictionaryWithDictionary:[dic dictionaryValueForKey:@"goods_info"]];
                [goods_info setValue:[NSNumber numberWithBool:islike] forKey:@"is_liked"];
                NSMutableDictionary *goods_stat = [NSMutableDictionary dictionaryWithDictionary:[goods_info dictionaryValueForKey:@"goods_stat"]];
                [goods_stat setObject:@(likeNum) forKey:@"like_num"];
                [goods_info setObject:goods_stat forKey:@"goods_stat"];
                [dic setObject:goods_info forKey:@"goods_info"];
                
                NSDictionary *data = [[NSDictionary alloc] init];
                if (islike) {
                    data = @{@"goodsId":post_id, @"isFollow":@1};
                } else {
                    data = @{@"goodsId":post_id, @"isFollow":@0};
                }
                NSLog(@"%@", data);
                if (!_followButton.isSelect) {
                    [ClientReportObject clientReportObjectWithViewCode:HomeChosenViewCode regionCode:HomeChosenSupportRegionCode referPageCode:NoReferPageCode andData:data];
                } else {
                    [ClientReportObject clientReportObjectWithViewCode:HomeChosenMineAttentionViewCode regionCode:HomeChosenSupportRegionCode referPageCode:NoReferPageCode andData:data];
                }
                
            } else {
                
                dic = [NSMutableDictionary dictionaryWithDictionary:dict];
                [dic setObject:[NSNumber numberWithBool:islike] forKey:@"is_like"];
                [dic setObject:@(likeNum) forKey:@"like_num"];
            }
            if (weakSelf.isMyFollow) {
                [self.followArray replaceObjectAtIndex:indexPath.row withObject:dic];
            } else {
                [self.niceArray replaceObjectAtIndex:indexPath.row withObject:dic];
            }
            //            [weakSelf.tableView reloadData];
        };
        cell.tagBlock = ^(NSNumber *type, NSNumber *topic_id) {
            if (type.integerValue==1) {
                
            } else {
                ForumPostListViewController *two = [[ForumPostListViewController alloc] init];
                two.topic_id = topic_id.integerValue;
                [self pushViewController:two animated:YES];
            }
        };
        cell.strBlock = ^(NSNumber *type,NSString *str) {
            if (type.integerValue == 1) {
                SearchViewController *search = [[SearchViewController alloc] init];
                search.searchKeywords = str;
                [self pushViewController:search animated:YES];
            } else {
                ForumPostListViewController *one = [[ForumPostListViewController alloc] init];
                one.tag = str;
                one.tagYes = YES;
                [self pushViewController:one animated:YES];
            }
        };
        cell.avatarBlock = ^(NSNumber *type, NSNumber *userid) {
            if (type.integerValue == 1) {
                UserHomeViewController *user = [[UserHomeViewController alloc] init];
                user.userId = userid.integerValue;
                NSDictionary *data = @{@"sellerUserId":userid};
                if (!_followButton.isSelect) {
                    [ClientReportObject clientReportObjectWithViewCode:HomeChosenViewCode regionCode:HomeChosenUserHomeRegionCode referPageCode:UserHomeReferPageCode andData:data];
                } else {
                    [ClientReportObject clientReportObjectWithViewCode:HomeChosenMineAttentionViewCode regionCode:HomeChosenUserHomeRegionCode referPageCode:UserHomeReferPageCode andData:data];
                }
                [self pushViewController:user animated:YES];
            } else {
                ForumOneSelfController *one  = [[ForumOneSelfController alloc] init];
                one.user_id = userid.integerValue;
                [self pushViewController:one animated:YES];
            }
        };
        cell.commentBlock = ^(NSNumber *type, NSNumber *post_id) {
            if (type.integerValue == 1) {
                GoodsDetailViewControllerContainer *goods = [[GoodsDetailViewControllerContainer alloc] init];
                goods.goodsId = [NSString stringWithFormat:@"%@", post_id];
                //                [goods setupTopBar];
                //                [goods setupTopBarBackButton];
                NSLog(@"%@", post_id);
                NSDictionary *data = @{@"goodsId":post_id};
                if (!_followButton.isSelect) {
                    [ClientReportObject clientReportObjectWithViewCode:HomeChosenViewCode regionCode:HomeChosenGoodsRegionCode referPageCode:GoodsDetailReferPageCode andData:data];
                } else {
                    [ClientReportObject clientReportObjectWithViewCode:HomeChosenMineAttentionViewCode regionCode:HomeChosenGoodsRegionCode referPageCode:GoodsDetailReferPageCode andData:data];
                }
                [self pushViewController:goods animated:YES];
            } else {
                ForumPostDetailViewController *forum = [[ForumPostDetailViewController alloc] init];
                forum.post_id = post_id.integerValue;
                [forum setupTopBar];
                [forum setupTopBarBackButton];
                [self pushViewController:forum animated:YES];
            }
        };
        cell.replyBlock = ^(NSNumber *type, NSNumber *post_id) {
            GoodsCommentsViewController *commentsViewController = [[GoodsCommentsViewController alloc] init];
            commentsViewController.goodsId = [NSString stringWithFormat:@"%@", post_id];
            commentsViewController.title = @"评论";
            [weakSelf pushViewController:commentsViewController animated:YES];
        };
        [cell updateCellWithDict:dict];
        return cell;
    } else {
        Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
        NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
        
        BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        if (tableViewCell == nil) {
            tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
            [tableViewCell setBackgroundColor:[UIColor whiteColor]];
            [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }
        [tableViewCell updateCellWithDict:dict];
        return tableViewCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict;
    if (indexPath.section == 0) {
        dict = [self.tempDataSource objectAtIndex:[indexPath row]];
    } else {
        
        if (_isMyFollow) {
            dict = _followArray[indexPath.row];
        } else {
            dict = _niceArray[indexPath.row];
        }
    }
    
    if ([[dict allKeys] containsObject:@"type"]) {
        return [RecommendForumCell rowHeightForPortrait:dict];
    }
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView scrollViewDidScroll:scrollView];
    
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommendTableViewScrollViewDidScroll:viewController:)]) {
        [self.delegate recommendTableViewScrollViewDidScroll:scrollView viewController:self];
    }
}

- (void)showRecommendLauchImage:(UIImage*)image redirectInfo:(RedirectInfo*)redirectInfo {
    
    WEAKSELF;
    
    [[self.view viewWithTag:65530] removeFromSuperview];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    view.tag =  65530;
    [self.view addSubview:view];
    [self.view bringSubviewToFront:view];
    
    CGFloat imageWidth = redirectInfo.width*kScreenWidth/320.f;
    CGFloat imageHeight = imageWidth*redirectInfo.height/redirectInfo.width;
    
    TapDetectingImageView *imageView = [[TapDetectingImageView alloc] initWithFrame:CGRectMake((self.view.width-imageWidth)/2, (self.view.height-imageHeight)/2, imageWidth, imageHeight)];
    imageView.backgroundColor =[UIColor clearColor];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [view addSubview:imageView];
    imageView.image = image;
    
    
    
    imageView.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer) {
        [[weakSelf.view viewWithTag:65530] removeFromSuperview];
        [URLScheme locateWithRedirectUri:redirectInfo.redirectUri andIsShare:YES];
    };
    
    UIImage *closeBtnImage = [UIImage imageNamed:@"recommend_launch_close_btn"];
    CommandButton *closeBtn = [[CommandButton alloc] initWithFrame:CGRectMake(imageView.right-closeBtnImage.size.width,imageView.top-closeBtnImage.size.height, closeBtnImage.size.width*2, closeBtnImage.size.height*2)];
    [closeBtn setImage:closeBtnImage forState:UIControlStateNormal];
    [view addSubview:closeBtn];
    closeBtn.handleClickBlock = ^(CommandButton *sender) {
        [[weakSelf.view viewWithTag:65530] removeFromSuperview];
        [[SDWebImageManager.sharedManager imageCache] removeImageForKey:redirectInfo.imageUrl];
    };
    
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    } completion:^(BOOL finished) {
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
    }];
}

@end

@interface DiscoveryViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate
,PullRefreshTableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,SearchBarViewDelegate>

//@property(nonatomic,weak) SearchBarView *searchBarView;

@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,weak) TopBarRightNewButton *myTopBarRightButton;

@property (nonatomic, strong) SearchCateBrandButton *searchButton;

@property (nonatomic, strong) UIButton *scrollTopBtn;
@end

@implementation DiscoveryViewController

-(UIButton *)scrollTopBtn{
    if (!_scrollTopBtn) {
        _scrollTopBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_scrollTopBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
        _scrollTopBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        [_scrollTopBtn setImage:[UIImage imageNamed:@"Back_Top_MF"] forState:UIControlStateNormal];
        _scrollTopBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
    }
    return _scrollTopBtn;
}

- (id)init {
    self = [super init];
    if (self) {
        self.dataSources = [NSMutableArray arrayWithCapacity:60];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*392426   F5F5F5 */
    
    //self.tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    
    CGFloat topBarHeight = 0.f;
    topBarHeight = [super setupTopBar];
    //    super.topBar.hidden = YES;
    //    [super setupTopBarLogo:[UIImage imageNamed:@"titlebar_logo"]];
    //[super setupTopBarBackButton:[UIImage imageNamed:@"category_normal.png"] imgPressed:nil];
    //    [super setupTopBarRightButton];
    //    [super setupTopBarBackButton:[UIImage imageNamed:@"qrcode_scan"] imgPressed:nil];
    
    
    //    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    //    [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    //    super.topBarRightButton.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    //    super.topBarRightButton.frame = CGRectMake(super.topBar.width-44, super.topBar.height-super.topBarRightButton.height, 44, super.topBarRightButton.height);
    
    //    [super.topBarRightButton setTitle:@"取消" forState:UIControlStateNormal];
    
//    SearchCateBrandButton *searchButton = [[SearchCateBrandButton alloc] initWithFrame:CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15.f-15-29, 29)];
//    searchButton.backgroundColor = [UIColor whiteColor];
    [self setupTopBarTitle:self.titleText];
    [super setupTopBarBackButton];
//    [super setupTopBarBackButton:[UIImage imageNamed:@"Idle_Search_MF"] imgPressed:[UIImage imageNamed:@"Idle_Search_MF"]];
//    [super setupTopBarRightButton:[UIImage imageNamed:@"ShopBag_New_MF"] imgPressed:[UIImage imageNamed:@"ShopBag_New_MF"]];
//    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    UIButton *goodsNumLbl = [self buildGoodsNumLbl];
    self.goodsNumLbl = goodsNumLbl;
//    [self.topBarRightButton addSubview:goodsNumLbl];
//    self.searchButton = searchButton;
    //    SearchBarView *searchBarView = [[SearchBarView alloc] initWithFrame:CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15.f-15-29, 29)];
    //    _searchBarView = searchBarView;
    //    _searchBarView.placeholder = @"搜索";
    //    _searchBarView.delegate = self;
    //    _searchBarView.searchBarDelegate = self;
    
//    CGFloat shoppingCartWidth = self.view.width-searchButton.right-4;
//    UIButton *shoppingCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.topBar.width-shoppingCartWidth+1, searchButton.top, shoppingCartWidth, searchButton.height)];
//    [shoppingCartBtn addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [shoppingCartBtn setImage:[UIImage imageNamed:@"ShopBag_New_MF"] forState:UIControlStateNormal];
//    [self.topBar addSubview:shoppingCartBtn];
//    _shoppingCartBtn = shoppingCartBtn;
//    
//    UIButton *goodsNumLbl = [self buildGoodsNumLbl];
//    [self.topBar addSubview:goodsNumLbl];
//    _goodsNumLbl = goodsNumLbl;
    
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
    
    //
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(super.topBar.width-46, _searchBarView.top, 46, 30)];
    //    view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    //
    
//    TopBarRightNewButton *myTopBarRightButton = [[TopBarRightNewButton alloc] initWithFrame:CGRectMake(searchButton.right-46, searchButton.top, 46, searchButton.height)];
//    _myTopBarRightButton = myTopBarRightButton;
//    _myTopBarRightButton.backgroundColor = [UIColor clearColor];
//    _myTopBarRightButton.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
//    _myTopBarRightButton.titleLabel.font = [UIFont systemFontOfSize:13.5f];
//    [_myTopBarRightButton addTarget:self action:@selector(handleMyTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_myTopBarRightButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
//    //    [_myTopBarRightButton setImage:[UIImage imageNamed:@"qrcode_scan"] forState:UIControlStateNormal];
//    [self.topBar addSubview:self.myTopBarRightButton];
//    
//    //    [_searchBarView enableCancelButton:NO];
//    [self.topBar addSubview:searchButton];
//    
//    searchButton.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
//    searchButton.layer.masksToBounds = YES;
//    searchButton.layer.cornerRadius = (searchButton.height)/6;
//    [searchButton addTarget:self action:@selector(pushSearchCateBvc) forControlEvents:UIControlEventTouchUpInside];
    //    [self.topBar addSubview:view];
    //
    _myTopBarRightButton.hidden = YES;
    [_myTopBarRightButton removeFromSuperview];
    [self.topBar addSubview:_myTopBarRightButton];
    
    
    PullRefreshTableView *tableView = [self createTableView];
    tableView.backgroundColor = [UIColor whiteColor];
    tableView.pullDelegate = self;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = YES;
    //    tableView.showsVerticalScrollIndicator = NO;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.contentMarginTop = topBarHeight ;;//kTopBarHeight-2;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    self.scrollTopBtn.frame = CGRectMake(kScreenWidth-50, kScreenHeight-60-50, 30, 30);
    self.scrollTopBtn.layer.masksToBounds = YES;
    self.scrollTopBtn.layer.cornerRadius = 15;
    [self.view addSubview:self.scrollTopBtn];
    [self.scrollTopBtn addTarget:self action:@selector(clickScrollTopBtn) forControlEvents:UIControlEventTouchUpInside];
    self.scrollTopBtn.hidden = YES;
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    
    //    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
    //    tapGesture.delegate = self;
    //    [self.view addGestureRecognizer:tapGesture];
}

-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
}

-(void)setUrlStr:(NSString *)urlStr{
    _urlStr = urlStr;
}

-(void)clickScrollTopBtn{
    [self.tableView scrollViewToTop:YES];
}

-(void)pushSearchCateBvc{
    SearchCateBrandViewController *viewColtroller = [[SearchCateBrandViewController alloc] init];
    [self pushViewController:viewColtroller animated:YES];
}

- (PullRefreshTableView*)createTableView {
    return [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)) isShowTopIndicatorImage:YES];
}

- (void)tappedCancel:(UIGestureRecognizer*)gesture
{
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    NSString *clsName = NSStringFromClass([touch.view class]);
    if ([clsName isEqualToString:@"UIButton"]) {
        clsName =  NSStringFromClass([touch.view.superview class]);
    }
    if ([clsName isEqualToString:@"UISearchBarTextField"]) {
        return NO;
    }
    if ([clsName isEqualToString:@"SearchBarCombBox"]) {
        return NO;
    }
    if ([clsName isEqualToString:@"SearchBarCommandButton"]) {
        return NO;
    }
    
    [self.view endEditing:YES];
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {//如果当前是tableView
        //做自己想做的事
        return NO;
    }
    
    return YES;
}

- (void)handleMyTopBarRightButtonClicked:(UIButton*)sender
{
    //    self.searchBarView.text = nil;
    [self.view endEditing:YES];
}

//点击首页右上角购物车
- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    
    //埋点
    [ClientReportObject clientReportObjectWithViewCode:HomeViewCode regionCode:HomeShopCarRegionCode referPageCode:ShopCarReferPageCode andData:nil];
    
    [self.view endEditing:YES];
    
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{ }];
    if (isLoggedIn) {
        [MobClick event:@"click_shopping_chart_from_recommend"];
        
        if ([self.navigationController.viewControllers count]>1) {
            UIViewController *viewController = [self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-2];
            if ([viewController isKindOfClass:[ShoppingCartViewController class]]) {
                [self dismiss];
                return;
            }
        }
        ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
        [super pushViewController:viewController animated:YES];
    }
    
}

- (UIButton*)buildGoodsNumLbl
{
    UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(27.5, 6, 14, 13)];
    goodsNumLbl.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    goodsNumLbl.layer.cornerRadius = 6.5f;
    goodsNumLbl.layer.masksToBounds = YES;
    [goodsNumLbl setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    goodsNumLbl.enabled = NO;
    goodsNumLbl.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    goodsNumLbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    goodsNumLbl.titleLabel.font = [UIFont systemFontOfSize:9.5f];
    return goodsNumLbl;
}

- (void)updateGoodsNumLbl:(NSInteger)goodsNum
{
    if (goodsNum > 0) {
        if (goodsNum<100) {
            NSString *title = [NSString stringWithFormat:@"%ld",(long)goodsNum];
            //            CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:9.5f]];
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            _goodsNumLbl.hidden = NO;
        } else {
            NSString *title = @"...";
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            _goodsNumLbl.hidden = NO;
        }
        
    } else {
        [_goodsNumLbl setTitle:@"" forState:UIControlStateDisabled];
        _goodsNumLbl.hidden = YES;
    }
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
    //    _searchHistoryView.hidden = NO;
    [ClientReportObject clientReportObjectWithViewCode:HomeViewCode regionCode:HomeSearchViewCode referPageCode:HomeSearchViewCode andData:nil];
    _myTopBarRightButton.hidden = NO;
    _myTopBarRightButton.isInEditing = YES;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    _myTopBarRightButton.isInEditing = NO;
    
    _myTopBarRightButton.hidden = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    //    _searchHistoryView.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSString *keywords = [searchBar.text trim];
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    if ([keywords length]>0 && [searchBar isKindOfClass:[SearchBarView class]]) {
        
        //埋点
        NSDictionary *data = @{@"keywords":keywords};
        [ClientReportObject clientReportObjectWithViewCode:HomeViewCode regionCode:SearchGoodsClickRegionCode referPageCode:NoReferPageCode andData:data];
        
        SearchViewController *viewController = [[SearchViewController alloc] init];
        viewController.searchKeywords = keywords;
        viewController.searchType = ((SearchBarView*)searchBar).currentSearchType;
        [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)handleReachabilityChanged:(id)notificationObject {
    //self.tableView.enableLoadingMore = [[NetworkManager sharedInstance] isReachableViaWiFi];
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    //    self.view = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    if (!_dataListLogic) {
        [self initDataListLogic];
    } else {
        self.tableView.pullTableIsLoadingMore = NO;
        self.tableView.pullTableIsLoadFinish = !self.dataListLogic.hasNextPage;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initDataListLogic {
    
    WEAKSELF;
    
    [weakSelf showLoadingView];
    
    DataListCacheArray *dataListCacheArray = [[DataListCacheArray alloc] init];
    [dataListCacheArray loadFromFile:[AppDirs recommendListCacheFile]];
    
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:self.urlStr path:@"" pageSize:15 fetchSize:30];
    _dataListLogic.cacheStrategy = dataListCacheArray;
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0 ) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        NSLog(@"%@", newList);
        for (int i=0;i<[addedItems count];i++) {
            RecommendInfo *recommendInfo = [RecommendInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
                //                if ([recommendInfo isRecommendTypeGoodsWithCover]
                //                    && [recommendInfo.list count]>0) {
                //                    for (NSInteger i=0;i<recommendInfo.list.count;i++) {
                //                        GoodsInfo *goodsInfo = recommendInfo.list[i];
                //                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                //                            GoodsInfo *goodsInfoTmp = [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                //                            [recommendInfo.list replaceObjectAtIndex:i withObject:goodsInfoTmp];
                //                        }
                //                    }
                //                }
                
                
                if ([recommendInfo recommendCellCls]==[RecommendGoodsWithCoverCell class]) {
                    [newList addObject:[RecommendGoodsWithCoverCell buildCellDict:recommendInfo isShowGoodsCover:YES isShowFollowBtn:NO pageIndex:0]];
                } else {
                    [newList addObject:[RecommendTableViewCell buildCellDict:recommendInfo]];
                }
                
            }
        }
//        if (addedItems.count > 0) {
//            for (int i = 0; i < addedItems.count; i++) {
//                NSDictionary *dict = addedItems[i];
//                if ([dict[@"type"] isEqual: @(9)]) {
//                    [newList addObject:[RecommendSegCell buildCellDict:dict]];
//                }
//            }
//        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
        [weakSelf.dataListLogic.cacheStrategy saveToFile:[AppDirs recommendListCacheFile] maxCount:50];
    };
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            
            RecommendInfo *recommendInfo = [RecommendInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
                if ([recommendInfo isRecommendTypeGoodsWithCover]
                    && [recommendInfo.list count]>0) {
                    for (NSInteger i=0;i<recommendInfo.list.count;i++) {
                        GoodsInfo *goodsInfo = recommendInfo.list[i];
                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                            GoodsInfo *goodsInfoTmp = [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                            [recommendInfo.list replaceObjectAtIndex:i withObject:goodsInfoTmp];
                        }
                    }
                }
                
                if ([recommendInfo recommendCellCls]==[RecommendGoodsWithCoverCell class]) {
                    [newList addObject:[RecommendGoodsWithCoverCell buildCellDict:recommendInfo isShowGoodsCover:YES isShowFollowBtn:NO pageIndex:0]];
                } else {
                    [newList addObject:[RecommendTableViewCell buildCellDict:recommendInfo]];
                }
            }
        }
        if ([newList count]>0) {
            //NSInteger count = [weakSelf.dataSources count];
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            [dataSources addObjectsFromArray:newList];
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        //        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton].handleRetryBtnClicked =^(LoadingView *view) {
            if ([weakSelf.dataSources count]==0 ) {
                [weakSelf showLoadingView];
            }
            [weakSelf.dataListLogic reloadDataListByForce];
        };
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    [self.dataListLogic firstLoadFromCache];
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

#pragma mark - qrcode
//- (void)handleTopBarBackButtonClicked:(UIButton*)sender
//{
////    QrCodeScanViewController *serviceWeb = [[QrCodeScanViewController alloc] init];
////    [super pushViewController:serviceWeb animated:YES];
//    SearchCateBrandViewController *searchCateBrandVC = [[SearchCateBrandViewController alloc] init];
//    [self pushViewController:searchCateBrandVC animated:YES];
//}


- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return(YES);
}

- (void)handleTopBarViewClicked {
    [_tableView scrollViewToTop:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
    
    if (scrollView.contentOffset.y > 300) {
        self.scrollTopBtn.hidden = NO;
    } else {
        self.scrollTopBtn.hidden = YES;
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(recommendTableViewScrollViewDidScroll:viewController:)]) {
        [_delegate recommendTableViewScrollViewDidScroll:scrollView viewController:self];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [_dataListLogic reloadDataListByForce];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [_dataListLogic nextPage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSources count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    if ([tableViewCell isKindOfClass:[RecommendDiscoverCell class]]) {
        WEAKSELF;
        RecommendDiscoverCell *segCell = (RecommendDiscoverCell *)tableViewCell;
        segCell.clickCell = ^(BOOL isYes){
            
            
            
        };
    }
    
    [tableViewCell updateCellWithDict:dict];
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //    [MobClick event:@"click_item_from_feeds"];
    //    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    //    GoodsInfo *goodsInfo = (GoodsInfo*)[dict objectForKey:[GoodsTableViewCell cellDictKeyForGoodsInfo]];
    //    [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:goodsInfo.goodsId animated:YES];
}

- (void)$$handleGoodsInfoChanged:(id<MBNotification>)notifi goodsIds:(NSArray*)goodsIds
{
    WEAKSELF;
    if (notifi.key == (NSUInteger)weakSelf) return;
    
    BOOL isNeedReload = NO;
    
    for (NSString *goodsId in goodsIds) {
        GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:goodsId];
        if (goodsInfo == nil) continue;
        
        for (NSDictionary *dict in self.dataSources) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                RecommendInfo *recommendInfo = [dict objectForKey:[RecommendTableViewCell cellKeyForRecommendInfo]];
                if ([recommendInfo isKindOfClass:[RecommendInfo class]]) {
                    
                    if ([recommendInfo isRecommendTypeActivityLimitPrice]) {
                        for (ActivityGoodsInfo *activityGoodsInfo in recommendInfo.list) {
                            if ([activityGoodsInfo isKindOfClass:[ActivityGoodsInfo class]]
                                && [activityGoodsInfo.recommendGoodsInfo.goodsId isEqualToString:goodsInfo.goodsId]) {
                                if ([activityGoodsInfo.recommendGoodsInfo updateWithGoodsInfo:goodsInfo]) {
                                    isNeedReload = YES;
                                }
                                break;
                            }
                        }
                    }
                    if ([recommendInfo isRecommendTypeGoods]) {
                        for (RecommendGoodsInfo *recommendGoodsInfo in recommendInfo.list) {
                            if ([recommendGoodsInfo isKindOfClass:[RecommendGoodsInfo class]]) {
                                if ([recommendGoodsInfo updateWithGoodsInfo:goodsInfo]) {
                                    isNeedReload = YES;
                                }
                            }
                        }
                    }
                    
                    if ([recommendInfo isRecommendTypeGoodsWithCover]) {
                        for (GoodsInfo *goodsInfoTmp in recommendInfo.list) {
                            if ([goodsInfoTmp isKindOfClass:[GoodsInfo class]]
                                && [goodsInfoTmp.goodsId isEqualToString:goodsInfo.goodsId]) {
                                if ([goodsInfoTmp isEqual:goodsInfo]||[goodsInfoTmp updateWithItem:goodsInfo]) {
                                    isNeedReload = YES;
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    if (isNeedReload) {
        [weakSelf.tableView reloadData];
    }
}

- (void)$$handleGoodsInfoUpdated:(id<MBNotification>)notifi goodsInfo:(GoodsInfo*)goodsInfo
{
    BOOL isNeedReload = NO;
    for (NSDictionary *dict in self.dataSources) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            RecommendInfo *recommendInfo = [dict objectForKey:[RecommendTableViewCell cellKeyForRecommendInfo]];
            if ([recommendInfo isKindOfClass:[RecommendInfo class]]) {
                
                if ([recommendInfo isRecommendTypeActivityLimitPrice]) {
                    for (ActivityGoodsInfo *activityGoodsInfo in recommendInfo.list) {
                        if ([activityGoodsInfo isKindOfClass:[ActivityGoodsInfo class]]
                            && [activityGoodsInfo.recommendGoodsInfo.goodsId isEqualToString:goodsInfo.goodsId]) {
                            if ([activityGoodsInfo.recommendGoodsInfo updateWithGoodsInfo:goodsInfo]) {
                                isNeedReload = YES;
                            }
                        }
                    }
                }
                if ([recommendInfo isRecommendTypeGoods]) {
                    for (RecommendGoodsInfo *recommendGoodsInfo in recommendInfo.list) {
                        if ([recommendGoodsInfo isKindOfClass:[RecommendGoodsInfo class]]) {
                            if ([recommendGoodsInfo updateWithGoodsInfo:goodsInfo]) {
                                isNeedReload = YES;
                            }
                        }
                    }
                }
                
                if ([recommendInfo isRecommendTypeGoodsWithCover]) {
                    for (GoodsInfo *goodsInfoTmp in recommendInfo.list) {
                        if ([goodsInfoTmp isKindOfClass:[GoodsInfo class]]
                            && [goodsInfoTmp.goodsId isEqualToString:goodsInfo.goodsId]) {
                            if ([goodsInfoTmp isEqual:goodsInfo]||[goodsInfoTmp updateWithItem:goodsInfo]) {
                                isNeedReload = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    if (isNeedReload) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)$$handleGoodsStatusUpdated:(id<MBNotification>)notifi goodStatusArray:(NSArray*)goodStatusArray
{
    BOOL isNeedReload = NO;
    for (GoodsStatusDO *statusDO in goodStatusArray) {
        
        for (NSDictionary *dict in self.dataSources) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                RecommendInfo *recommendInfo = [dict objectForKey:[RecommendTableViewCell cellKeyForRecommendInfo]];
                if ([recommendInfo isKindOfClass:[RecommendInfo class]]) {
                    
                    if ([recommendInfo isRecommendTypeActivityLimitPrice]) {
                        for (ActivityGoodsInfo *activityGoodsInfo in recommendInfo.list) {
                            if ([activityGoodsInfo isKindOfClass:[ActivityGoodsInfo class]]
                                && [activityGoodsInfo.recommendGoodsInfo.goodsId isEqualToString:statusDO.goodsId]) {
                                [activityGoodsInfo.recommendGoodsInfo updateWithStatusInfo:statusDO];
                                isNeedReload = YES;
                            }
                        }
                    }
                    if ([recommendInfo isRecommendTypeGoods]) {
                        for (RecommendGoodsInfo *recommendGoodsInfo in recommendInfo.list) {
                            if ([recommendGoodsInfo isKindOfClass:[RecommendGoodsInfo class]]
                                && [recommendGoodsInfo.goodsId isEqualToString:statusDO.goodsId]) {
                                [recommendGoodsInfo updateWithStatusInfo:statusDO];
                                isNeedReload = YES;
                            }
                        }
                    }
                    if ([recommendInfo isRecommendTypeGoodsWithCover]) {
                        for (GoodsInfo *goodsInfo in recommendInfo.list) {
                            if ([goodsInfo isKindOfClass:[GoodsInfo class]]
                                && [goodsInfo.goodsId isEqualToString:statusDO.goodsId]) {
                                [goodsInfo updateWithStatusInfo:statusDO];
                                isNeedReload = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    if (isNeedReload) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (void)$$handleFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    BOOL isNeedReload = NO;
    for (NSDictionary *dict in self.dataSources) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            RecommendInfo *recommendInfo = [dict objectForKey:[RecommendTableViewCell cellKeyForRecommendInfo]];
            if ([recommendInfo isKindOfClass:[RecommendInfo class]]) {
                
                if ([recommendInfo isRecommendTypeGoodsWithCover]) {
                    for (GoodsInfo *goodsInfo in recommendInfo.list) {
                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]
                            && goodsInfo.seller.userId == [userId integerValue]) {
                            goodsInfo.seller.isfollowing = YES;
                            isNeedReload = YES;
                        }
                    }
                }
            }
        }
    }
    if (isNeedReload) {
        [self.tableView reloadData];
    }
}

- (void)$$handleUnFollowUserNotification:(id<MBNotification>)notifi userId:(NSNumber*)userId
{
    BOOL isNeedReload = NO;
    for (NSDictionary *dict in self.dataSources) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            RecommendInfo *recommendInfo = [dict objectForKey:[RecommendTableViewCell cellKeyForRecommendInfo]];
            if ([recommendInfo isKindOfClass:[RecommendInfo class]]) {
                if ([recommendInfo isRecommendTypeGoodsWithCover]) {
                    for (GoodsInfo *goodsInfo in recommendInfo.list) {
                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]
                            && goodsInfo.seller.userId == [userId integerValue]) {
                            goodsInfo.seller.isfollowing = NO;
                            isNeedReload = YES;
                        }
                    }
                }
            }
        }
    }
    if (isNeedReload) {
        [self.tableView reloadData];
    }
}

- (void)$$handleGoodsLiked:(id<MBNotification>)notifi goodsId:(NSString*)goodsId
{
    [self handleGoodsLikedEvent:notifi goodsId:goodsId liked:YES];
}

- (void)$$handleGoodsUnLiked:(id<MBNotification>)notifi goodsId:(NSString*)goodsId
{
    [self handleGoodsLikedEvent:notifi goodsId:goodsId liked:NO];
}

- (void)handleGoodsLikedEvent:(id<MBNotification>)notifi goodsId:(NSString*)goodsId liked:(BOOL)isLiked
{
    BOOL isNeedReload = NO;
    for (NSDictionary *dict in self.dataSources) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            RecommendInfo *recommendInfo = [dict objectForKey:[RecommendTableViewCell cellKeyForRecommendInfo]];
            if ([recommendInfo isKindOfClass:[RecommendInfo class]]) {
                
                if ([recommendInfo isRecommendTypeActivityLimitPrice]) {
                    for (ActivityGoodsInfo *activityGoodsInfo in recommendInfo.list) {
                        if ([activityGoodsInfo isKindOfClass:[ActivityGoodsInfo class]]
                            && [activityGoodsInfo.recommendGoodsInfo.goodsId isEqualToString:goodsId]) {
                            if (activityGoodsInfo.recommendGoodsInfo.isLiked!=isLiked) {
                                activityGoodsInfo.recommendGoodsInfo.isLiked = isLiked;
                                isNeedReload = YES;
                            }
                        }
                    }
                }
                if ([recommendInfo isRecommendTypeGoods]) {
                    for (RecommendGoodsInfo *recommendGoodsInfo in recommendInfo.list) {
                        if ([recommendGoodsInfo isKindOfClass:[RecommendGoodsInfo class]]
                            && [recommendGoodsInfo.goodsId isEqualToString:goodsId]) {
                            if (recommendGoodsInfo.isLiked != isLiked) {
                                recommendGoodsInfo.isLiked = isLiked;
                                isNeedReload = YES;
                            }
                        }
                    }
                }
                if ([recommendInfo isRecommendTypeGoodsWithCover]) {
                    for (GoodsInfo *goodsInfo in recommendInfo.list) {
                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]
                            && [goodsInfo.goodsId isEqualToString:goodsId]) {
                            if (goodsInfo.isLiked != isLiked) {
                                goodsInfo.isLiked = isLiked;
                                if (isLiked) {
                                    goodsInfo.stat.likeNum += 1;
                                } else {
                                    goodsInfo.stat.likeNum -= 1;
                                }
                                isNeedReload = YES;
                            }
                        }
                    }
                }
            }
        }
    }
    
    if (isNeedReload) {
        [self.tableView reloadData];
    }
}


- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
}

- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi
{
    //    [self updateGoodsNumLbl:0];
}

- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    //    [self updateGoodsNumLbl:0];
}

- (void)$$handleShoppingCartSyncFinishedNotification:(id<MBNotification>)notifi
{
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
}

- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi addedItem:(ShoppingCartItem*)item
{
    [self $$handleShoppingCartSyncFinishedNotification:nil];
}

- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi removedGoodsIds:(NSArray*)goodsIds
{
    [self $$handleShoppingCartSyncFinishedNotification:nil];
}


@end



@implementation FeedsNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchButton.hidden = YES;
    self.myTopBarRightButton.hidden = YES;
    
    [self setupTopBarTitle:[self.title length]>0?self.title:@"最新"];
    [self setupTopBarBackButton];
    
}

- (PullRefreshTableView*)createTableView {
    return [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
}


- (void)handleTopBarBackButtonClicked:(UIButton *)sender
{
    [self dismiss];
}


- (void)initDataListLogic {
    
    
    WEAKSELF;
    
    DataListCacheArray *dataListCacheArray = [[DataListCacheArray alloc] init];
    [dataListCacheArray loadFromFile:[AppDirs feedListCacheFile]];
    
    self.dataListLogic = [[DataListLogic alloc] initWithModulePath:@"feeds" path:@"latest_list" pageSize:15 fetchSize:30];
    self.dataListLogic.cacheStrategy = dataListCacheArray;
    self.dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0 ) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    self.dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            RecommendInfo *recommendInfo = [RecommendInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
                //                if ([recommendInfo isRecommendTypeGoodsWithCover]
                //                    && [recommendInfo.list count]>0) {
                //                    for (NSInteger i=0;i<recommendInfo.list.count;i++) {
                //                        GoodsInfo *goodsInfo = recommendInfo.list[i];
                //                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                //                            GoodsInfo *goodsInfoTmp = [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                //                            [recommendInfo.list replaceObjectAtIndex:i withObject:goodsInfoTmp];
                //                        }
                //                    }
                //                }
                
                if ([newList count]>0) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                
                if ([recommendInfo recommendCellCls]==[RecommendGoodsWithCoverCell class]) {
                    [newList addObject:[RecommendGoodsWithCoverCell buildCellDict:recommendInfo isShowGoodsCover:NO isShowFollowBtn:NO pageIndex:2]];
                } else {
                    [newList addObject:[RecommendTableViewCell buildCellDict:recommendInfo]];
                }
            }
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
        [weakSelf.dataListLogic.cacheStrategy saveToFile:[AppDirs feedListCacheFile] maxCount:50];
    };
    self.dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    self.dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            
            RecommendInfo *recommendInfo = [RecommendInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
                //                if ([recommendInfo isRecommendTypeGoodsWithCover]
                //                    && [recommendInfo.list count]>0) {
                //                    for (NSInteger i=0;i<recommendInfo.list.count;i++) {
                //                        GoodsInfo *goodsInfo = recommendInfo.list[i];
                //                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                //                            GoodsInfo *goodsInfoTmp = [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                //                            [recommendInfo.list replaceObjectAtIndex:i withObject:goodsInfoTmp];
                //                        }
                //                    }
                //                }
                
                if ([newList count]>0) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                
                if ([recommendInfo recommendCellCls]==[RecommendGoodsWithCoverCell class]) {
                    [newList addObject:[RecommendGoodsWithCoverCell buildCellDict:recommendInfo isShowGoodsCover:NO isShowFollowBtn:NO pageIndex:2]];
                } else {
                    [newList addObject:[RecommendTableViewCell buildCellDict:recommendInfo]];
                }
            }
        }
        if ([newList count]>0) {
            //NSInteger count = [weakSelf.dataSources count];
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                [dataSources addObject:[SepTableViewCell buildCellDict]];
            }
            [dataSources addObjectsFromArray:newList];
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    self.dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    self.dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton].handleRetryBtnClicked =^(LoadingView *view) {
            if ([weakSelf.dataSources count]==0 ) {
                [weakSelf showLoadingView];
            }
            [weakSelf.dataListLogic reloadDataListByForce];
        };
    };
    self.dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    [self.dataListLogic loadFromCache];
    if ([self.dataSources count]==0) {
        [weakSelf showLoadingView];
    }
    [weakSelf.dataListLogic reloadDataListByForce];
}

@end


#import "LoginViewController.h"
#import "Session.h"

@interface FollowingsNewViewController () <AuthorizeChangedReceiver>
@property(nonatomic,strong) UIView *recommendLoginView;
@end

@implementation FollowingsNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.searchButton.hidden = YES;
    self.myTopBarRightButton.hidden = YES;
    
    [self setupTopBarTitle:[self.title length]>0?self.title:@"关注"];
    [self setupTopBarBackButton];
    
    
    self.recommendLoginView.frame = CGRectMake(0, self.tableView.contentMarginTop, kScreenWidth, 60);
    self.tableView.tableHeaderView = nil;
}

- (PullRefreshTableView*)createTableView {
    return [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
}


- (void)handleTopBarBackButtonClicked:(UIButton *)sender
{
    [self dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView*)recommendLoginView {
    if (!_recommendLoginView) {
        _recommendLoginView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _recommendLoginView.backgroundColor = [UIColor colorWithHexString:@"282828"];
        
        UIImage *img = [UIImage imageNamed:@"recommend_login_cat"];
        CALayer *layer = [CALayer layer];
        layer.contents = (id)img.CGImage;
        layer.frame = CGRectMake(13, (_recommendLoginView.height-img.size.height)/2, img.size.width, img.size.height);
        [_recommendLoginView.layer addSublayer:layer];
        
        CommandButton *loginBtn = [[CommandButton alloc] initWithFrame:CGRectMake(kScreenWidth-60-5, (_recommendLoginView.height-30)/2, 60, 30)];
        loginBtn.backgroundColor = [UIColor colorWithHexString:@"FFE8B0"];
        loginBtn.layer.masksToBounds = YES;
        loginBtn.layer.cornerRadius = 15.f;
        [loginBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:13.f];
        [_recommendLoginView addSubview:loginBtn];
        
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectNull];
        lbl.text = @"喵，你还没登陆呢～";
        lbl.font = [UIFont systemFontOfSize:13.f];
        lbl.textColor = [UIColor whiteColor];
        [lbl sizeToFit];
        lbl.frame = CGRectMake(67, 15, lbl.width, lbl.height);
        [_recommendLoginView addSubview:lbl];
        
        UILabel *lbl2 = [[UILabel alloc] initWithFrame:CGRectNull];
        lbl2.text = @"没登陆就想看你的关注，欺负喵呢你！";
        lbl2.font = [UIFont systemFontOfSize:10.f];
        lbl2.textColor = [UIColor colorWithHexString:@"666666"];
        [lbl2 sizeToFit];
        lbl2.frame = CGRectMake(67, lbl.top+lbl.height+2, lbl2.width, lbl2.height);
        [_recommendLoginView addSubview:lbl2];
        
        WEAKSELF;
        loginBtn.handleClickBlock = ^(CommandButton *sender) {
            [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:weakSelf completion:^{
                
            }];
        };
    }
    return _recommendLoginView;
}

- (void)$$handleRegisterDidFinishNotification:(id<MBNotification>)notifi
{
    [self handleAuthChangedEvent];
}
- (void)$$handleLoginDidFinishNotification:(id<MBNotification>)notifi
{
    [self handleAuthChangedEvent];
}
- (void)$$handleLogoutDidFinishNotification:(id<MBNotification>)notifi
{
    [self handleAuthChangedEvent];
}
- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    [self handleAuthChangedEvent];
}

- (void)handleAuthChangedEvent
{
    WEAKSELF;
    if (![Session sharedInstance].isLoggedIn) {
        weakSelf.tableView.tableHeaderView = [weakSelf recommendLoginView];
    } else {
        weakSelf.tableView.tableHeaderView = nil;
    }
}

- (void)initDataListLogic {
    
    
    WEAKSELF;
    
    DataListCacheArray *dataListCacheArray = [[DataListCacheArray alloc] init];
    [dataListCacheArray loadFromFile:[AppDirs followingsCacheFile]];
    
    self.dataListLogic = [[DataListLogic alloc] initWithModulePath:@"feeds" path:@"following_list" pageSize:15 fetchSize:30];
    self.dataListLogic.cacheStrategy = dataListCacheArray;
    self.dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0 ) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    self.dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        if (![Session sharedInstance].isLoggedIn) {
            weakSelf.tableView.tableHeaderView = [weakSelf recommendLoginView];
        } else {
            weakSelf.tableView.tableHeaderView = nil;
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            RecommendInfo *recommendInfo = [RecommendInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
                //                if ([recommendInfo isRecommendTypeGoodsWithCover]
                //                    && [recommendInfo.list count]>0) {
                //                    for (NSInteger i=0;i<recommendInfo.list.count;i++) {
                //                        GoodsInfo *goodsInfo = recommendInfo.list[i];
                //                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                //                            GoodsInfo *goodsInfoTmp = [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                //                            [recommendInfo.list replaceObjectAtIndex:i withObject:goodsInfoTmp];
                //                        }
                //                    }
                //                }
                
                if ([newList count]>0) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                
                if ([recommendInfo recommendCellCls]==[RecommendGoodsWithCoverCell class]) {
                    [newList addObject:[RecommendGoodsWithCoverCell buildCellDict:recommendInfo isShowGoodsCover:NO isShowFollowBtn:YES pageIndex:1]];
                } else {
                    [newList addObject:[RecommendTableViewCell buildCellDict:recommendInfo]];
                }
            }
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
        
        [weakSelf.dataListLogic.cacheStrategy saveToFile:[AppDirs followingsCacheFile] maxCount:50];
    };
    self.dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    self.dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        if (![Session sharedInstance].isLoggedIn) {
            weakSelf.tableView.tableHeaderView = [weakSelf recommendLoginView];
        } else {
            weakSelf.tableView.tableHeaderView = nil;
        }
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            
            RecommendInfo *recommendInfo = [RecommendInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
                //                if ([recommendInfo isRecommendTypeGoodsWithCover]
                //                    && [recommendInfo.list count]>0) {
                //                    for (NSInteger i=0;i<recommendInfo.list.count;i++) {
                //                        GoodsInfo *goodsInfo = recommendInfo.list[i];
                //                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                //                            GoodsInfo *goodsInfoTmp = [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                //                            [recommendInfo.list replaceObjectAtIndex:i withObject:goodsInfoTmp];
                //                        }
                //                    }
                //                }
                
                if ([newList count]>0) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                
                if ([recommendInfo recommendCellCls]==[RecommendGoodsWithCoverCell class]) {
                    [newList addObject:[RecommendGoodsWithCoverCell buildCellDict:recommendInfo isShowGoodsCover:NO isShowFollowBtn:YES pageIndex:1]];
                } else {
                    [newList addObject:[RecommendTableViewCell buildCellDict:recommendInfo]];
                }
            }
        }
        if ([newList count]>0) {
            //NSInteger count = [weakSelf.dataSources count];
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0) {
                [dataSources addObject:[SepTableViewCell buildCellDict]];
            }
            [dataSources addObjectsFromArray:newList];
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    self.dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        //        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    self.dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton].handleRetryBtnClicked =^(LoadingView *view) {
            if ([weakSelf.dataSources count]==0 ) {
                [weakSelf showLoadingView];
            }
            [weakSelf.dataListLogic reloadDataListByForce];
        };
    };
    self.dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    //    [self.dataListLogic loadFromCache];
    //    if ([self.dataSources count]==0)
    //    {
    //        [weakSelf showLoadingView];
    //        [self.dataListLogic reloadDataListByForce];
    //    }
    
    [self.dataListLogic loadFromCache];
    if ([self.dataSources count]==0) {
        [weakSelf showLoadingView];
    }
    [weakSelf.dataListLogic reloadDataListByForce];
}

@end




@interface DataListNewViewController ()

@end

@implementation DataListNewViewController

- (id)init {
    self = [super init];
    if (self) {
        _isShowTitleBar = YES;
        _tableViewContentMarginTop = kTopBarHeight-2;
        _isNeedShowSeperator = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (_isShowTitleBar) {
        super.topBar.hidden = NO;
        [super setupTopBar];
        [super setupTopBarTitle:[self.title length]>0?self.title:@""];
        [super setupTopBarBackButton];
    }
    else {
        super.topBar.hidden = YES;
    }
    self.searchButton.hidden = YES;
    self.myTopBarRightButton.hidden = YES;
    
    self.tableView.contentMarginTop = self.tableViewContentMarginTop;
    self.tableView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds));
    
    if (!self.dataListLogic) {
        [self initDataListLogic];
    } else {
        self.tableView.pullTableIsLoadingMore = NO;
        self.tableView.pullTableIsLoadFinish = !self.dataListLogic.hasNextPage;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTopBarBackButtonClicked:(UIButton *)sender
{
    [super dismiss];
}

- (void)initDataListLogic {
    
    WEAKSELF;
    
    DataListCacheArray *dataListCacheArray = [[DataListCacheArray alloc] init];
    
    self.dataListLogic = [[DataListLogic alloc] initWithModulePath:self.module path:self.path pageSize:15 fetchSize:30];
    self.dataListLogic.cacheStrategy = dataListCacheArray;
    self.dataListLogic.parameters = @{@"params":[self.params length]>0?self.params:@""};
    self.dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0 ) {
            weakSelf.tableView.pullTableIsRefreshing = YES; //列表中有数据的时候显示下拉刷新的箭头
        }
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    self.dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            RecommendInfo *recommendInfo = [RecommendInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
                //                if ([recommendInfo isRecommendTypeGoodsWithCover]
                //                    && [recommendInfo.list count]>0) {
                //                    for (NSInteger i=0;i<recommendInfo.list.count;i++) {
                //                        GoodsInfo *goodsInfo = recommendInfo.list[i];
                //                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                //                            GoodsInfo *goodsInfoTmp = [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                //                            [recommendInfo.list replaceObjectAtIndex:i withObject:goodsInfoTmp];
                //                        }
                //                    }
                //                }
                
                if ([newList count]>0 && weakSelf.isNeedShowSeperator) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                
                if ([recommendInfo recommendCellCls]==[RecommendGoodsWithCoverCell class]) {
                    [newList addObject:[RecommendGoodsWithCoverCell buildCellDict:recommendInfo isShowGoodsCover:NO isShowFollowBtn:NO pageIndex:100]];
                } else {
                    [newList addObject:[RecommendTableViewCell buildCellDict:recommendInfo]];
                }
            }
        }
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    };
    self.dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    self.dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        [weakSelf hideLoadingView];
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
        for (int i=0;i<[addedItems count];i++) {
            
            RecommendInfo *recommendInfo = [RecommendInfo createWithDict:[addedItems objectAtIndex:i]];
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
                //                if ([recommendInfo isRecommendTypeGoodsWithCover]
                //                    && [recommendInfo.list count]>0) {
                //                    for (NSInteger i=0;i<recommendInfo.list.count;i++) {
                //                        GoodsInfo *goodsInfo = recommendInfo.list[i];
                //                        if ([goodsInfo isKindOfClass:[GoodsInfo class]]) {
                //                            GoodsInfo *goodsInfoTmp = [[GoodsMemCache sharedInstance] storeData:goodsInfo isDataChanged:nil];
                //                            [recommendInfo.list replaceObjectAtIndex:i withObject:goodsInfoTmp];
                //                        }
                //                    }
                //                }
                
                if ([newList count]>0 && weakSelf.isNeedShowSeperator) {
                    [newList addObject:[SepTableViewCell buildCellDict]];
                }
                
                if ([recommendInfo recommendCellCls]==[RecommendGoodsWithCoverCell class]) {
                    [newList addObject:[RecommendGoodsWithCoverCell buildCellDict:recommendInfo isShowGoodsCover:NO isShowFollowBtn:NO pageIndex:100]];
                } else {
                    [newList addObject:[RecommendTableViewCell buildCellDict:recommendInfo]];
                }
            }
        }
        if ([newList count]>0) {
            //NSInteger count = [weakSelf.dataSources count];
            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
            if ([dataSources count]>0 && weakSelf.isNeedShowSeperator) {
                [dataSources addObject:[SepTableViewCell buildCellDict]];
            }
            [dataSources addObjectsFromArray:newList];
            weakSelf.dataSources = dataSources;
            [weakSelf.tableView reloadData];
        }
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    self.dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        [weakSelf hideLoadingView];
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked =^(LoadingView *view) {
                [weakSelf.dataListLogic reloadDataListByForce];
            };
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
        //        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    };
    self.dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = YES;
        [weakSelf loadEndWithNoContentWithRetryButton].handleRetryBtnClicked =^(LoadingView *view) {
            if ([weakSelf.dataSources count]==0 ) {
                [weakSelf showLoadingView];
            }
            [weakSelf.dataListLogic reloadDataListByForce];
        };
    };
    self.dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    
    [weakSelf showLoadingView];
    [self.dataListLogic reloadDataListByForce];
}

- (PullRefreshTableView*)createTableView {
    return [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
}


@end

