//
//  RecommendViewController.m
//  XianMao
//
//  Created by simon on 2/7/15.
//  Copyright (c) 2015 XianMao. All rights reserved.
//

#import "RecommendViewController.h"
#import "CoordinatingController.h"
#import "PullRefreshTableView.h"
#import "GoodsDetailViewController.h"
#import "GoodsTableViewCell.h"
#import "SepTableViewCell.h"
#import "PhotoBroswerVC.h"
#import "SearchViewController.h"
#import "SearchNewViewController.h"
#import "GoodsDetailViewController.h"
#import "ForumPostDetailViewController.h"
#import "GoodsCommentsViewController.h"
#import "ScanCodeViewController.h"
#import "DataListLogic.h"
#import "NetworkManager.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "Session.h"
#import "ForumOneSelfController.h"
#import "FeedsItem.h"
#import "GoodsInfo.h"
#import "GoodsMemCache.h"
#import "LBXScanViewStyle.h"
#import "DataSources.h"
#import "AssessViewController.h" //临时放
#import "AppDirs.h"
#import "ForumPostListViewController.h"
#import "RecommendTableViewCell.h"
#import "RecommendInfo.h"
#import "ActivityInfo.h"

#import "QrCodeScanViewController.h"
#import "NSString+Addtions.h"
#import "MeowCatVo.h"
#import "ShoppingCartViewController.h"
#import "MeowRecordVo.h"
#import "RecommendService.h"
#import "URLScheme.h"
#import "JSONKit.h"
#import "UserHomeViewController.h"
#import "GuideView.h"
#import "SearchCateBrandViewController.h"
#import "SearchCateBrandButton.h"
#import "KeywordMapdetail.h"
#import "RemindingPublishView.h"
#import "CateBrandViewController.h"
#import "RecommendSiftTitleView.h"
#import "LoadingCell.h"
#import "NoGoodsCell.h"
#import "GetDiamondView.h"

#import "PublishViewController.h"

@interface TopBarRightButton ()


@end

@implementation TopBarRightButton

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



@interface HomeRecommendViewController ()<UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate, PhotoModelDelegate>

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
@property (nonatomic, assign) double alpha;

@property (nonatomic, strong) RecommendForumCell *cell;
@property (nonatomic, assign) NSInteger indexSection;

@property (nonatomic, strong) TapDetectingImageView *scrollTopBtn;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) NSInteger sectionCount;

@property (nonatomic, strong) RecommendSiftTitleView *siftView;
@property (nonatomic, strong) GuideView * guideView;
@property (nonatomic, strong) NSMutableArray *nickArrCount;
@property (nonatomic, assign) CGFloat offSet_Y;

@property (nonatomic, assign) NSInteger addGuite;
@property (nonatomic, strong) TapDetectingImageView *adviserImageView;

@end

@implementation HomeRecommendViewController


-(TapDetectingImageView *)adviserImageView
{
    if (!_adviserImageView) {
        _adviserImageView = [[TapDetectingImageView alloc] init];
        _adviserImageView.image = [UIImage imageNamed:@"home_adm_adviser"];
    }
    return _adviserImageView;
}


-(NSMutableArray *)nickArrCount{
    if (!_nickArrCount) {
        _nickArrCount = [[NSMutableArray alloc] init];
    }
    return _nickArrCount;
}

-(RecommendSiftTitleView *)siftView{
    if (!_siftView) {
        _siftView = [[RecommendSiftTitleView alloc] init];
        _siftView.backgroundColor = [UIColor whiteColor];
    }
    return _siftView;
}

-(NSMutableArray *)niceArray{
    if (!_niceArray) {
        _niceArray = [[NSMutableArray alloc] init];
    }
    return _niceArray;
}

-(TapDetectingImageView *)scrollTopBtn{
    if (!_scrollTopBtn) {
        _scrollTopBtn = [[TapDetectingImageView alloc] initWithFrame:CGRectZero];
        _scrollTopBtn.image = [UIImage imageNamed:@"Back_Top_MF"];
    }
    return _scrollTopBtn;
}

- (void)initDataListLogic {
    
    WEAKSELF;
    
    [weakSelf showLoadingView];
    
    DataListCacheArray *dataListCacheArray = [[DataListCacheArray alloc] init];
    [dataListCacheArray loadFromFile:[AppDirs recommendListCacheFile]];
    
    self.dataListLogic = [[DataListLogic alloc] initWithModulePath:@"recommend" path:@"list" pageSize:1000 fetchSize:1000];
    self.dataListLogic.cacheStrategy = dataListCacheArray;
    self.dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        if ([weakSelf.dataSources count]>0 ) {
            weakSelf.nicePage = 1;
            weakSelf.followPage = 1;
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
            if (recommendInfo.type == 111) {
                weakSelf.sectionCount = 2;
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
        
        
        if (_sectionInfo.type == 111 && _sectionInfo.list.count >0) {//107
            RedirectInfo *redirInfo = weakSelf.sectionInfo.list[0];
            //            RedirectInfo *redirInfo1 = weakSelf.sectionInfo.list[1];
            weakSelf.niceUrl = redirInfo.url;
            //            weakSelf.followUrl = redirInfo1.url;
            NSDictionary *params = @{@"page":@(0), @"size":@(20), @"reqtype":@(0)};
            [weakSelf.niceArray removeAllObjects];
            [weakSelf.niceArray addObject:[LoadingCell buildCellDict:weakSelf.nickArrCount]];
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:redirInfo.url path:@"" parameters:params completionBlock:^(NSDictionary *data) {
                [weakSelf.niceArray removeAllObjects];
                NSMutableArray *arr = [[NSMutableArray alloc] init];
                NSString *str = [data JSONString];
                NSLog(@"%@", str);
                NSArray *array = data[@"list"];
                //                weakSelf.niceArray = [NSMutableArray arrayWithArray:array];
                [weakSelf.niceArray addObject:[SepWhiteTableViewCell buildCellDict]];
                if (array.count == 0) {
                    [weakSelf.niceArray addObject:[NoGoodsCell buildCellDict:nil]];
                }
                for (NSInteger i=0;i<[array count];i+=2) {
                    NSMutableArray *arrayL = [[NSMutableArray alloc] init];
                    [arrayL addObject:[RecommendGoodsInfo createWithDict:[array objectAtIndex:i]]];
                    if (i+1>=[array count]) {
                        [arr addObject:arrayL];
                        break;
                    }
                    [arrayL addObject:[RecommendGoodsInfo createWithDict:[array objectAtIndex:i+1]]];
                    [arr addObject:arrayL];
                }
                for (NSInteger i=0;i<[arr count];i++) {
                    if ([weakSelf.niceArray count]>0) {
                        [weakSelf.niceArray addObject:[SearchTableSepViewCell buildCellDict]];
                    }
                    NSArray *array = [arr objectAtIndex:i];
                    [weakSelf.niceArray addObject:[RecommendGoodsCellSearch buildCellDict:array]];
                    [weakSelf.nickArrCount removeAllObjects];
                    [weakSelf.nickArrCount addObjectsFromArray:weakSelf.niceArray];
                }
                [weakSelf.tableView reloadData];
            } failure:^(XMError *error) {
                
            } queue:nil]];
            //            NSDictionary *paramss = @{@"page":@(1), @"size":@(15), @"reqtype":@(0)};
            //            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:redirInfo1.url path:@"" parameters:paramss completionBlock:^(NSDictionary *data) {
            //                weakSelf.followArray = [NSMutableArray arrayWithArray:data[@"list"]];
            //            } failure:nil queue:nil]];
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

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.alpha>=1)
    {
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }else{
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
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
        NSDictionary *params = @{@"page":@(self.nicePage), @"size":@(20), @"reqtype":@(0)};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:self.niceUrl path:@"" parameters:params completionBlock:^(NSDictionary *data) {
            weakSelf.nicePage++;
            NSString *str = [data JSONString];
            NSLog(@"%@", str);
            NSArray *array = data[@"list"];
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            for (NSInteger i=0;i<[array count];i+=2) {
                NSMutableArray *arrayL = [[NSMutableArray alloc] init];
                [arrayL addObject:[RecommendGoodsInfo createWithDict:[array objectAtIndex:i]]];
                if (i+1>=[array count]) {
                    [arr addObject:arrayL];
                    break;
                }
                [arrayL addObject:[RecommendGoodsInfo createWithDict:[array objectAtIndex:i+1]]];
                [arr addObject:arrayL];
            }
            for (NSInteger i=0;i<[arr count];i++) {
                if ([weakSelf.niceArray count]>0) {
                    [weakSelf.niceArray addObject:[SearchTableSepViewCell buildCellDict]];
                }
                NSArray *array = [arr objectAtIndex:i];
                [weakSelf.niceArray addObject:[RecommendGoodsCellSearch buildCellDict:array]];
            }
            NSNumber *hasnext = data[@"hasNextPage"];
            if (hasnext.integerValue == 0) {
                self.isniceOver = YES;
            }else{
                self.isniceOver = NO;
            }
            [weakSelf.tableView reloadData];
        } failure:nil queue:nil]];
    }
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    
}

-(void)dealloc{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"adviserSwithStatusNotification" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"showPageImage" object:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tag = 100;
    self.sectionCount = 1;
    self.isMyFollow = NO;
//    self.topBar.backgroundColor = [UIColor clearColor];
//    self.topBarlineView.alpha = 1;
    //    self.topBar.alpha = 0;
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"footer"];
    WEAKSELF;
    if ([NetworkManager sharedInstance].isReachableViaWiFi) {
        
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf loadRecommendLauchImage];
        });
    }
    
    self.scrollTopBtn.frame = CGRectMake(kScreenWidth-50, kScreenHeight-60-50, self.scrollTopBtn.image.size.width, self.scrollTopBtn.image.size.height);
    [self.view addSubview:self.scrollTopBtn];
    self.scrollTopBtn.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer){
        [weakSelf clickScrollTopBtn];
    };
    self.scrollTopBtn.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPageImage) name:@"showPageImage" object:nil];
    
    
    [self.view addSubview:self.adviserImageView];
    NSNumber * swithStatus = [[NSUserDefaults standardUserDefaults] objectForKey:@"swithStatus"];
    self.adviserImageView.hidden = ![swithStatus boolValue];
    self.adviserImageView.frame = CGRectMake(kScreenWidth-50, kScreenHeight-60-40-60, self.adviserImageView.image.size
                                             .width, self.adviserImageView.image.size.height);
    
    self.adviserImageView.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer){
        
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
            
            AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
            [UserSingletonCommand chatWithUserHasWXNum:adviserPage.userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings] adviser:adviserPage nadGoodsId:nil];
            
        } failure:^(XMError *error) {
            
        } queue:nil]];
        
    };
    
    
    if ([GetDiamondView isNeedShowGetDiamondView] && [Session sharedInstance].isLoggedIn) {
        NSInteger userId = [Session sharedInstance].currentUserId;
        NSDictionary * parameters = @{@"user_id":[NSNumber numberWithInteger:userId]};
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"meow" path:@"get_cat_record" parameters:parameters completionBlock:^(NSDictionary *data) {
            MeowCatVo * meowCatVo = [[MeowCatVo alloc] initWithJSONDictionary:[data dictionaryValueForKey:@"MeowCatVo"]];
            if (meowCatVo) {
                if ([meowCatVo isNeedRemind]) {
                    GetDiamondView * diamondView = [[GetDiamondView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                    [diamondView showGetDiamondView:meowCatVo];
                }
            }
            
        } failure:^(XMError *error) {
            
        } queue:nil]];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adviserSwithStatusNotification:) name:@"adviserSwithStatusNotification" object:nil];
    
}

- (void)adviserSwithStatusNotification:(NSNotification *)n{
    NSNumber * swithStatus = n.object;
    self.adviserImageView.hidden = ![swithStatus boolValue];
}


-(void)clickScrollTopBtn{
    [self.tableView scrollViewToTop:YES];
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
        } else {
            //            if (self.dataSources && self.dataSources.count > 0) {
            //                if ([GuideView isNeedShowWaitItGuideView]) {
            //                    GuideView * guide = [[GuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
            //                    [[CoordinatingController sharedInstance].mainViewController.view addSubview:guide];
            //                    [guide showNewUserGuideView:self.dataSources guideView:guide reOffset:self.offSet_Y addGuite:1];
            //                }
            //            }
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
    return self.sectionCount;
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
    //    RecommendSiftTitleView *view = [[RecommendSiftTitleView alloc] init];
    //    view.backgroundColor = [UIColor whiteColor];
    if (section == 0) {
        return self.siftView;
    } else {
        self.siftView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth*45.f/375.f);//kScreenWidth*50.f/320.f
        self.siftView.backgroundColor = [UIColor whiteColor];
        //        SelectButton *nice = [SelectButton buttonWithType:UIButtonTypeCustom];
        //        nice.titleLabel.font = [UIFont systemFontOfSize:16];
        //        nice.isSelect = !_isMyFollow;
        //        self.niceButton = nice;
        //        [nice setButtonStyle];
        //        [nice addTarget:self action:@selector(niceButtonAction) forControlEvents:UIControlEventTouchUpInside];
        //        [view addSubview:nice];
        //
        //        SelectButton *follow = [SelectButton buttonWithType:UIButtonTypeCustom];
        //        follow.selected = NO;
        //        follow.titleLabel.font = [UIFont systemFontOfSize:16];
        //        self.followButton = follow;
        //        self.followButton.isSelect = _isMyFollow;
        //        [follow setButtonStyle];
        //        [follow addTarget:self action:@selector(followButtonAction) forControlEvents:UIControlEventTouchUpInside];
        //        [view addSubview:follow];
        //        CALayer *layer = [[CALayer alloc] init];
        //        _scrollLayer = layer;
        //        layer.frame = CGRectZero;
        //        [view.layer addSublayer:layer];
        //        layer.backgroundColor = [UIColor colorWithHexString:@"c2a79d"].CGColor;
        //
        if (_sectionInfo && [_sectionInfo isKindOfClass:[RecommendInfo class]] && [_sectionInfo.list count]>0) {
            
            [self.siftView getRecommendInfo:_sectionInfo andTag:self.tag];
            
            //            RedirectInfo *niceDic = _sectionInfo.list[0];
            //            NSString *niceStr = niceDic.title;
            //            [_niceButton setTitle:niceStr forState:UIControlStateNormal];
            //            _niceButton.selectUrl = niceDic.url;
            //
            //
            //            RedirectInfo *followDic = _sectionInfo.list[1];
            //            NSString *followStr = followDic.title;
            //            [_followButton setTitle:followStr forState:UIControlStateNormal];
            //            _followButton.selectUrl = followDic.url;
            //            CGRect rect1 = [niceStr boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            //            _niceButton.frame = CGRectMake(10, (kScreenWidth*35.f/320.f - 20) /2.0 + 3, rect1.size.width + 20, 20);
            //
            //            CGRect rect2 = [followStr boundingRectWithSize:CGSizeMake(10000, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil];
            //            _followButton.frame = CGRectMake(10 + rect1.size.width + 20 + 10, (kScreenWidth*35.f/320.f - 20) /2.0 + 3, rect2.size.width + 20, 20);
            //            if (_isMyFollow) {
            //                _scrollLayer.frame = CGRectMake(10 + rect1.size.width + 20 + 10, kScreenWidth*35.f/320.f - 1, rect2.size.width + 20, 1);
            //            } else {
            //                _scrollLayer.frame = CGRectMake(10, kScreenWidth*35.f/320.f - 1 , rect1.size.width + 20, 1);
            //            }
        }
        WEAKSELF;
        self.siftView.handleRecommendBtn = ^(CommandButton *sender){
            //            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            //            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            weakSelf.nicePage = 1;
            weakSelf.isniceOver = NO;
            weakSelf.niceUrl = sender.recommendUrl;
            weakSelf.tag = sender.tag;
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            NSDictionary *params = @{@"page":@(0), @"size":@(20), @"reqtype":@(0)};
            [weakSelf.niceArray removeAllObjects];
            [weakSelf.niceArray addObject:[LoadingCell buildCellDict:weakSelf.nickArrCount]];
            [weakSelf.tableView reloadData];
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:sender.recommendUrl path:@"" parameters:params completionBlock:^(NSDictionary *data) {
                [weakSelf.niceArray removeAllObjects];
                NSString *str = [data JSONString];
                NSLog(@"%@", str);
                NSArray *array = data[@"list"];
                //                weakSelf.niceArray = [NSMutableArray arrayWithArray:array];
                [weakSelf.niceArray addObject:[SepWhiteTableViewCell buildCellDict]];
                if (array.count == 0) {
                    [weakSelf.niceArray addObject:[NoGoodsCell buildCellDict:nil]];
                }
                for (NSInteger i=0;i<[array count];i+=2) {
                    NSMutableArray *arrayL = [[NSMutableArray alloc] init];
                    [arrayL addObject:[RecommendGoodsInfo createWithDict:[array objectAtIndex:i]]];
                    if (i+1>=[array count]) {
                        [arr addObject:arrayL];
                        break;
                    }
                    [arrayL addObject:[RecommendGoodsInfo createWithDict:[array objectAtIndex:i+1]]];
                    [arr addObject:arrayL];
                }
                for (NSInteger i=0;i<[arr count];i++) {
                    if ([weakSelf.niceArray count]>0) {
                        [weakSelf.niceArray addObject:[SearchTableSepViewCell buildCellDict]];
                    }
                    NSArray *array = [arr objectAtIndex:i];
                    [weakSelf.niceArray addObject:[RecommendGoodsCellSearch buildCellDict:array]];
                    [weakSelf.nickArrCount removeAllObjects];
                    [weakSelf.nickArrCount addObjectsFromArray:weakSelf.niceArray];
                }
                [weakSelf.siftView scrollTitleLabelSelectededCenter:sender];
                [UIView animateWithDuration:0.25 animations:^{
                    [weakSelf.tableView reloadData];
                    NSIndexPath * dayOne = [NSIndexPath indexPathForRow:0 inSection:weakSelf.sectionCount-1];
                    [weakSelf.tableView scrollToRowAtIndexPath:dayOne atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }];
            } failure:^(XMError *error) {
                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
            } queue:nil]];
            
        };
    }
    return self.siftView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return kScreenWidth*45.f/375.f;
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
        if (self.followArray.count - 1 == indexPath.row && indexPath.row > 0) {
            [self loadMoreData];
        }
    }else if(self.niceArray.count - 1== indexPath.row && indexPath.row > 0){
        [self loadMoreData];
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAKSELF;
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSInteger section = indexPath.section;
    if (section == 0) {
        dict = [self.tempDataSource objectAtIndex:[indexPath row]];
    } else {
        dict = [self.niceArray objectAtIndex:[indexPath row]];
    }
    //    NSDictionary *dict = [self.tempDataSource objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    if ([tableViewCell isKindOfClass:[RecommendGoodsCellSearch class]]) {
        RecommendGoodsCellSearch *goodsCellSearch = (RecommendGoodsCellSearch *)tableViewCell;
        goodsCellSearch.handleRecommendGoodsClickBlock = ^(RecommendGoodsInfo *recommendGoodsInfo){
            GoodsDetailViewControllerContainer *viewController = [[GoodsDetailViewControllerContainer alloc] init];
            viewController.goodsId = recommendGoodsInfo.goodsId;
            [weakSelf pushViewController:viewController animated:YES];
        };
    }
    [tableViewCell updateCellWithDict:dict];
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [[NSDictionary alloc] init];
    NSInteger section = indexPath.section;
    if (section == 0) {
        dict = [self.tempDataSource objectAtIndex:[indexPath row]];
    } else {
        dict = [self.niceArray objectAtIndex:[indexPath row]];
    }
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView scrollViewDidScroll:scrollView];
    
    if (scrollView.contentOffset.y > 600) {
        self.scrollTopBtn.hidden = NO;
        CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
        if (translation.y > 0) {//tableView下滑
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollTopBtn.frame = CGRectMake(kScreenWidth-50, kScreenHeight-60-50, self.scrollTopBtn.image.size.width, self.scrollTopBtn.image.size.height);
            }];
        }else{//tableView上滑
            [UIView animateWithDuration:0.5 animations:^{
                self.scrollTopBtn.frame = CGRectMake(kScreenWidth-50, kScreenHeight, self.scrollTopBtn.image.size.width, self.scrollTopBtn.image.size.height);
            }];
        }
    } else {
        self.scrollTopBtn.hidden = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(recommendTableViewScrollViewDidScroll:viewController:)]) {
        [self.delegate recommendTableViewScrollViewDidScroll:scrollView viewController:self];
    }
    
    //
    /*
     首页tableview置顶,以及NavigationBar的alpha渐变的效果
     
     CGFloat offSet_Y = self.tableView.contentOffset.y;
     self.offSet_Y = offSet_Y;
     CGFloat reOffset = offSet_Y;
     CGFloat alpha = reOffset/64;
     self.alpha = alpha;
     if (alpha>=1)
     {
     alpha = 1;
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
     
     [self.shoppingCartBtn setImage:[[SkinIconManager manager] isValidWithPath:KTopbar_RightImg_Black]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTopbar_RightImg_Black]]:[UIImage imageNamed:@"ShoppingBad_Black_wjh"] forState:UIControlStateNormal];
     [self.TopBarLeftButton setImage:[[SkinIconManager manager] isValidWithPath:KTopbar_LeftImg_Black]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTopbar_LeftImg_Black]]:[UIImage imageNamed:@"sweep_black"] forState:UIControlStateNormal];
     
     }else{
     [self.shoppingCartBtn setImage:[[SkinIconManager manager] isValidWithPath:KTopbar_RightImg_White]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTopbar_RightImg_White]]:[UIImage imageNamed:@"ShoppingBad_White_wjh"] forState:UIControlStateNormal];
     [self.TopBarLeftButton setImage:[[SkinIconManager manager] isValidWithPath:KTopbar_LeftImg_White]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTopbar_LeftImg_White]]:[UIImage imageNamed:@"sweep_white"] forState:UIControlStateNormal];
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
     
     }
     
     CGFloat r = 0.0;
     CGFloat g = 0.0;
     CGFloat b = 0.0;
     NSScanner *scanner = [NSScanner scannerWithString:[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@19", SKIN]]?[[SkinIconManager manager] skin:[NSString stringWithFormat:@"%@19", SKIN]]:@"ffffff"];
     unsigned hexNum;
     if ([scanner scanHexInt:&hexNum]){
     r = (hexNum >> 16) & 0xFF;
     g = (hexNum >> 8) & 0xFF;
     b = (hexNum) & 0xFF;
     }
     
     // 设置导航条的背景图片 其透明度随  alpha 值 而改变
     if ([[SkinIconManager manager] isValidWithPath:KTopbar_BackgroudImg]) {
     UIImage * image = [UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTopbar_BackgroudImg]];
     self.topBar.image = [self imageByApplyingAlpha:alpha image:image];
     }else{
     UIImage *image = [self imageWithColor:[UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:alpha]];
     self.topBar.image = image;
     }
     self.topBarlineView.alpha = alpha;
     
     
     //适配首页商品池
     if (scrollView.contentOffset.y >= 64*10) {
     self.tableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-50);
     } else if (scrollView.contentOffset.y < 64*10 && scrollView.contentOffset.y > -63) {
     self.tableView.frame = CGRectMake(0, -63+scrollView.contentOffset.y/10, kScreenWidth, (  kScreenHeight+63)-scrollView.contentOffset.y/10);
     }
     if (offSet_Y < -64) {
     }
     */
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    CGFloat offSet_Y = self.tableView.contentOffset.y;
//    if (self.dataSources && self.dataSources.count > 0) {
//        if ([GuideView isNeedShowWaitItGuideView]) {
//            
//            CGFloat height = 0;
//            for (NSDictionary * dict in self.dataSources) {
//                RecommendInfo * recommendInfo = [dict objectForKey:@"recommendInfo"];
//                Class clsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
//                if (recommendInfo.type == kRecommendTypeWaterFollow) {
//                    break;
//                }else{
//                    height += [clsTableViewCell rowHeightForPortrait:dict];
//                }
//            }
//            
//            if (height - offSet_Y > 400 || height - offSet_Y < 100) {
//                self.addGuite = 0;
//            } else {
//                self.addGuite = 1;
//            }
//            
//            GuideView * guide = [[GuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//            [[CoordinatingController sharedInstance].mainViewController.view addSubview:guide];
//            [guide showNewUserGuideView:self.dataSources guideView:guide reOffset:self.offSet_Y addGuite:self.addGuite];
//        }
//    }

}

// 使用颜色填充图片
- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    CGContextSetAlpha(ctx, alpha);
    CGContextDrawImage(ctx, area, image.CGImage);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
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
        
        //        if (self.dataSources && self.dataSources.count > 0) {
        //            if ([GuideView isNeedShowWaitItGuideView]) {
        //                GuideView * guide = [[GuideView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        //                [[CoordinatingController sharedInstance].mainViewController.view addSubview:guide];
        //                [guide showNewUserGuideView:self.dataSources guideView:guide reOffset:self.offSet_Y addGuite:1];
        //            }
        //        }
        
    };
    
    [UIView animateWithDuration:0.3 animations:^{
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    } completion:^(BOOL finished) {
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        
    }];
}

@end

@interface RecommendViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate
,PullRefreshTableViewDelegate,UISearchBarDelegate,UIGestureRecognizerDelegate,SearchBarViewDelegate>

//@property(nonatomic,weak) SearchBarView *searchBarView;

@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,weak) TopBarRightButton *myTopBarRightButton;

@property (nonatomic, strong) SearchCateBrandButton *searchButton;
@property (nonatomic, strong) KeywordMapdetail * keywordMap;
@property (nonatomic, assign) CGFloat topBarHeight;
@property (nonatomic, strong) RemindingPublishView * remindingPublishView;
@property (nonatomic, strong) TapDetectingImageView *adviserImageView;

@end

@implementation RecommendViewController

- (id)init {
    self = [super init];
    if (self) {
        self.dataSources = [NSMutableArray arrayWithCapacity:60];
    }
    return self;
}


-(RemindingPublishView *)remindingPublishView
{
    if (!_remindingPublishView) {
        _remindingPublishView = [[RemindingPublishView alloc] initWithFrame:CGRectZero];
        _remindingPublishView.hidden = YES;
    }
    return _remindingPublishView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*392426   F5F5F5 */
    
    //self.tableView.backgroundColor = [UIColor colorWithHexString:@"F5F5F5"];
    
    CGFloat topBarHeight = 0.f;
    topBarHeight = [super setupTopBar];
    self.topBarHeight = topBarHeight;
    self.topBar.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    self.topBarlineView.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
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
    
    [self getKeywordMapdetail];
    SearchCateBrandButton *searchButton = [[SearchCateBrandButton alloc] initWithFrame:CGRectMake(54, topBarHeight-11.f-25, kScreenWidth/375*266, 29)];
    self.searchButton = searchButton;
    //    SearchBarView *searchBarView = [[SearchBarView alloc] initWithFrame:CGRectMake(15, topBarHeight-11.f-25, kScreenWidth-15.f-15-29, 29)];
    //    _searchBarView = searchBarView;
    //    _searchBarView.placeholder = @"搜索";
    //    _searchBarView.delegate = self;
    //    _searchBarView.searchBarDelegate = self;
    
    CGFloat shoppingCartWidth = 38;
    UIButton *shoppingCartBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.topBar.width-shoppingCartWidth, searchButton.top, shoppingCartWidth, searchButton.height)];
    [shoppingCartBtn addTarget:self action:@selector(handleTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [shoppingCartBtn setImage:[[SkinIconManager manager] isValidWithPath:22]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:22]]:[UIImage imageNamed:@"ShoppingBad_White_wjh"] forState:UIControlStateNormal];
    [self.topBar addSubview:shoppingCartBtn];
    _shoppingCartBtn = shoppingCartBtn;
    
    
    UIButton *goodsNumLbl = [self buildGoodsNumLbl];
    [self.topBar addSubview:goodsNumLbl];
    _goodsNumLbl = goodsNumLbl;
    
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
    
    //
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(super.topBar.width-46, _searchBarView.top, 46, 30)];
    //    view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    //
    
    TopBarRightButton *myTopBarRightButton = [[TopBarRightButton alloc] initWithFrame:CGRectMake(searchButton.right-46, searchButton.top, 46, searchButton.height)];
    _myTopBarRightButton = myTopBarRightButton;
    _myTopBarRightButton.backgroundColor = [UIColor clearColor];
    _myTopBarRightButton.contentHorizontalAlignment = UIControlContentVerticalAlignmentCenter;
    _myTopBarRightButton.titleLabel.font = [UIFont systemFontOfSize:13.5f];
    [_myTopBarRightButton addTarget:self action:@selector(handleMyTopBarRightButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_myTopBarRightButton setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateNormal];
    //    [_myTopBarRightButton setImage:[UIImage imageNamed:@"qrcode_scan"] forState:UIControlStateNormal];
    [self.topBar addSubview:self.myTopBarRightButton];
    
    //    [_searchBarView enableCancelButton:NO];
    [self.topBar addSubview:searchButton];
    
    searchButton.backgroundColor = [UIColor whiteColor];
    [searchButton addTarget:self action:@selector(pushSearchCBvc) forControlEvents:UIControlEventTouchUpInside];
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
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    tableView.frame = CGRectMake(0, topBarHeight, kScreenWidth, kScreenHeight-topBarHeight);
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    CommandButton * tobbarLeftButton = [[CommandButton alloc] init];
    [tobbarLeftButton setBackgroundImage:[[SkinIconManager manager] isValidWithPath:KTopbar_LeftImg_White]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTopbar_LeftImg_White]]:[UIImage imageNamed:@"sweep_white"] forState:UIControlStateNormal];
    self.TopBarLeftButton = tobbarLeftButton;
    [self.topBar addSubview:self.TopBarLeftButton];
    [self.TopBarLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchButton.mas_centerY);
        make.left.equalTo(self.view.mas_left).offset(14);
    }];
    
    WEAKSELF;
    self.TopBarLeftButton.handleClickBlock = ^(CommandButton * button){
        [ClientReportObject clientReportObjectWithViewCode:HomeViewCode regionCode:CatalogueViewCode referPageCode:CatalogueViewCode andData:nil];
        [weakSelf pushSearchCateBvc];
    };
    
    self.tableView.autoTriggerLoadMore = [[NetworkManager sharedInstance] isReachable];
    
    [super bringTopBarToTop];
    
    [self setupReachabilityChangedObserver];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(54);
        make.top.equalTo(self.view.mas_top).offset(topBarHeight-11.f-25);
        make.height.mas_equalTo(@29);
        make.right.equalTo(self.shoppingCartBtn.mas_left).offset(-17);
    }];
    
    [self.view addSubview:self.remindingPublishView];
    
    if ([RemindingPublishView isNeedShowRemindingPublishView]) {
        self.remindingPublishView.hidden = NO;
    }
    
    [self customUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadView) name:@"reloadView" object:nil];
}

-(void)reloadView{
    [self.shoppingCartBtn setImage:[[SkinIconManager manager] isValidWithPath:KTopbar_RightImg_White]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTopbar_RightImg_White]]:[UIImage imageNamed:@"ShoppingBad_White_wjh"] forState:UIControlStateNormal];
    [self.TopBarLeftButton setBackgroundImage:[[SkinIconManager manager] isValidWithPath:KTopbar_LeftImg_White]?[UIImage imageWithContentsOfFile:[[SkinIconManager manager] getPicturePath:KTopbar_LeftImg_White]]:[UIImage imageNamed:@"sweep_white"] forState:UIControlStateNormal];
}

-(void)customUI{
    [self.remindingPublishView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.view.mas_bottom).offset(-16);
    }];
    
}

-(void)getKeywordMapdetail
{
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"get_search_text_map" parameters:nil completionBlock:^(NSDictionary *data) {
        
        NSDictionary * dict = [data objectForKey:@"result"];
        if (![dict isEqual:[NSNull null]]) {
            KeywordMapdetail * keywordMap = [KeywordMapdetail createWithDict:[data objectForKey:@"result"]];
            self.keywordMap = keywordMap;
            [self.searchButton getShowText:keywordMap.showText];
        }
        
    } failure:^(XMError *error) {
        
    } queue:nil]];
    
}



/**
 ScanCodeViewController  二维码扫描Ctril----暂时下线
 */
-(void)pushSearchCateBvc{
    ScanCodeViewController *viewContrller = [[ScanCodeViewController alloc] init];
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 0;
    if ([UIScreen mainScreen].bounds.size.height <= 480 ){
        //3.5inch 显示的扫码缩小
        style.centerUpOffset = 0;
        style.xScanRetangleOffset = 0;
    }
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_On;
    style.photoframeLineW = 2;
    style.colorAngle = [UIColor whiteColor];
    style.photoframeAngleW = 16;
    style.photoframeAngleH = 16;
    style.isNeedShowRetangle = NO;
    style.anmiationStyle = LBXScanViewAnimationStyle_NetGrid;
    UIImage *imgFullNet = [UIImage imageNamed:@"qrcode_scan_full_net"];
    style.animationImage = imgFullNet;
    viewContrller.style = style;
    
    //分类CateBrandViewController
    //CateBrandViewController * viewContrller = [[CateBrandViewController alloc] init];
    [self pushViewController:viewContrller animated:YES];
}

-(void)pushSearchCBvc
{
    [ClientReportObject clientReportObjectWithViewCode:HomeViewCode regionCode:HomeSearchViewCode referPageCode:HomeSearchViewCode andData:nil];
    SearchViewController * searchView = [[SearchViewController alloc] init];
    searchView.keywordMap = self.keywordMap;
    [self pushViewController:searchView animated:YES];
}

- (PullRefreshTableView*)createTableView {
    return [[PullRefreshTableView alloc] initWithFrame:CGRectZero isShowTopIndicatorImage:YES];
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
    UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 14, 13)];
    goodsNumLbl.backgroundColor = [UIColor whiteColor];
    goodsNumLbl.layer.cornerRadius = 6.5f;
    goodsNumLbl.layer.masksToBounds = YES;
    goodsNumLbl.layer.borderWidth = 1;
    goodsNumLbl.layer.borderColor = [DataSources colorf9384c].CGColor;
    [goodsNumLbl setTitleColor:[DataSources colorf9384c] forState:UIControlStateDisabled];
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
            CGSize size = [title sizeWithFont: [UIFont systemFontOfSize:9.5f]];
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            CGFloat goodsNumLblWidth = size.width+8;
            CGFloat goodsNumLblHeight = 14.f;
            UIView *shoppingCartBtn = _shoppingCartBtn;
            self.goodsNumLbl.frame = CGRectMake(shoppingCartBtn.right-shoppingCartBtn.width/2+1, shoppingCartBtn.top-1, 14, 13);
            _goodsNumLbl.hidden = NO;
        } else {
            NSString *title = @"...";
            CGSize size = [title sizeWithFont: [UIFont systemFontOfSize:9.5f]];
            [_goodsNumLbl setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 4, 0)];
            [_goodsNumLbl setTitle:title forState:UIControlStateDisabled];
            CGFloat goodsNumLblWidth = size.width+8;
            CGFloat goodsNumLblHeight = 13.f;
            UIView *shoppingCartBtn = _shoppingCartBtn;
            self.goodsNumLbl.frame = CGRectMake(shoppingCartBtn.right-shoppingCartBtn.width/2+1, shoppingCartBtn.top-1, 14, 13);
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
    
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"recommend" path:@"list" pageSize:15 fetchSize:30];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadView" object:nil];
}

#pragma mark - qrcode
- (void)handleTopBarBackButtonClicked:(UIButton*)sender
{
    QrCodeScanViewController *serviceWeb = [[QrCodeScanViewController alloc] init];
    [super pushViewController:serviceWeb animated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation
{
    return(YES);
}

- (void)handleTopBarViewClicked {
    [_tableView scrollViewToTop:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
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
                                if (isLiked) {
                                    recommendGoodsInfo.goodsStat.likeNum += 1;
                                } else {
                                    recommendGoodsInfo.goodsStat.likeNum -= 1;
                                }
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



@implementation FeedsViewController

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
    
    [self.dataListLogic loadFromCache];
    if ([self.dataSources count]==0) {
        [weakSelf showLoadingView];
    }
    [weakSelf.dataListLogic reloadDataListByForce];
}

@end


#import "LoginViewController.h"
#import "Session.h"

@interface FollowingsViewController () <AuthorizeChangedReceiver>
@property(nonatomic,strong) UIView *recommendLoginView;
@end

@implementation FollowingsViewController

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




@interface DataListViewController ()

@end

@implementation DataListViewController

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

