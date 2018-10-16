//
//  SearchViewController.m
//  XianMao
//
//  Created by simon cai on 11/9/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "SearchViewController.h"
#import "UIImage+Color1.h"

#import "NSString+Addtions.h"

#import "Command.h"
#import "PullRefreshTableView.h"

#import "DataListLogic.h"
#import "NetworkManager.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "Session.h"

#import "DataSources.h"

#import "GoodsTableViewCell.h"
#import "SepTableViewCell.h"
#import "RecommendTableViewCell.h"

#import "GoodsInfo.h"
#import "GoodsMemCache.h"

#import "SearchResultItem.h"
#import "NSString+URLEncoding.h"
#import "JSONKit.h"

#import "HotWord.h"
#import "AppDirs.h"
#import "SearchResultSellerItem.h"
#import "SearchResultSellerTableViewCell.h"
#import "RecommendButlerView.h"
#import "SearchRecommendButlerCell.h"
#import "KeyworldAssociateView.h"
#import "SearchTopNewView.h"
#import "SearchSiftView.h"
#import "BlackView.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "AboutViewController.h"
#import "FilterModel.h"
#import "FQTagsView.h"
#import "FqParamsModel.h"
#import "SearchBannerVo.h"
#import "FindADMAdviseView.h"
#import "URLScheme.h"
#import "SeekToPurchaseCell.h"
#import "IdleBannerTableViewCell.h"
#define kFilterInfoViewMinHeight 120

#define kSearchTypeGoods 0
#define kSearchTypeSeller 1

@implementation SearchTableSepViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SearchTableSepViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight = 6.f;
    return rowHeight;
}

+ (NSMutableDictionary*)buildCellDict
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SearchTableSepViewCell class]];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
@end

@interface SearchTableTotalNumViewCell : BaseTableViewCell
+ (NSString*)reuseIdentifier;
+ (CGFloat)rowHeightForPortrait;
+ (NSMutableDictionary*)buildCellDict:(NSInteger)totalNum keywords:(NSString*)keywords isForSeller:(BOOL)isForSeller;
- (void)updateCellWithDict:(NSDictionary*)dict;
@end

@implementation SearchTableTotalNumViewCell {
    UILabel *_totalNumLbl;
}
+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SearchTableTotalNumViewCell class]);
    });
    return __reuseIdentifier;
}
+ (CGFloat)rowHeightForPortrait {
    CGFloat rowHeight =25;
    return rowHeight;
}
+ (NSMutableDictionary*)buildCellDict:(NSInteger)totalNum keywords:(NSString*)keywords isForSeller:(BOOL)isForSeller
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SearchTableTotalNumViewCell class]];
    [dict setObject:[NSNumber numberWithInteger:totalNum] forKey:[self cellKeyForTotalNum]];
    if (keywords)[dict setObject:keywords forKey:[self cellKeyForKeywords]];
    [dict setObject:[NSNumber numberWithBool:isForSeller] forKey:[self cellKeyForSeller]];
    return dict;
}
+ (NSString*)cellKeyForTotalNum {
    return @"totalNum";
}
+ (NSString*)cellKeyForKeywords {
    return @"keywords";
}
+ (NSString*)cellKeyForSeller {
    return @"isForSeller";
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
        _totalNumLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        _totalNumLbl.backgroundColor = [UIColor clearColor];
        _totalNumLbl.font = [UIFont systemFontOfSize:12.f];
        _totalNumLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        [self.contentView addSubview:_totalNumLbl];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _totalNumLbl.text = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _totalNumLbl.frame = CGRectMake(12, 0, self.contentView.width-24, self.contentView.height);
}
- (void)updateCellWithDict:(NSDictionary*)dict
{
    BOOL isForSeller = [dict boolValueForKey:[[self class] cellKeyForSeller] defaultValue:NO];
    //    NSString *keywords = [dict stringValueForKey:[[self class] cellKeyForKeywords] defaultValue:@""];
    NSInteger totalNum = [dict integerValueForKey:[[self class] cellKeyForTotalNum] defaultValue:0];
    //    if ([keywords length]>0)
    //        _totalNumLbl.text = [NSString stringWithFormat:@"搜索 “%@” 共找到%d个宝贝",keywords, totalNum];
    //    else
    if (isForSeller) {
        _totalNumLbl.text = [NSString stringWithFormat:@"当前店铺共找到%ld个商品",totalNum];
    } else {
        _totalNumLbl.text = [NSString stringWithFormat:@"共为你找到%ld个商品",totalNum];
    }
    [self setNeedsLayout];
}

@end


@interface SearchViewController () <UISearchBarDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,KeyworldAssociateView>

@property(nonatomic,strong) SearchBarView *searchBarView;

@property(nonatomic,strong) UIView *contentView;
@property(nonatomic,strong) TapDetectingView *searchHistoryView;
@property(nonatomic,strong) PullRefreshTableView *tableView;
@property(nonatomic,strong) LoadingView *loadingView;

@property(nonatomic,strong) NSMutableArray *goodsArrayList;
@property(nonatomic,strong) NSMutableArray *dataSources;
@property(nonatomic,strong) NSMutableArray *dataSourcesSellers;
@property(nonatomic,strong) DataListLogic *dataListLogic;
@property(nonatomic,strong) HTTPRequest *request;

@property(nonatomic,strong) SearchFilterTopView *filterTopView;
@property(nonatomic,strong) SearchFilterContainerView *filterContainerView;

@property(nonatomic,copy) NSString *params;
@property(nonatomic,copy) NSString *keywords;

@property(nonatomic,assign) NSInteger totalNum;//搜索结果条数

@property(nonatomic,assign) BOOL isCancelCurFilter;

- (void)doSearch:(NSString*)keywords type:(NSInteger)type;
@property(nonatomic,assign) long long timestamp;

@property (nonatomic, strong) RecommendButlerView *guanjiaView;
@property (nonatomic, strong) KeyworldAssociateView * keyworldAssociate;

@property (nonatomic, copy) NSString *returnGoodsQk;
@property (nonatomic, copy) NSString *returnGoodsQv;

@property (nonatomic, strong) UIView *promptHeaderView;
@property (nonatomic, strong) UIView *promptSecionView;
@property (nonatomic, strong) XMWebImageView *headerImageView;
@property (nonatomic, strong) UIView *headerLineView;
@property (nonatomic, strong) UIView *headerLineView1;

@property (nonatomic, strong) FQTagsView *FQTagView;
@property (nonatomic, strong) SearchTopNewView *topNewView;
@property (nonatomic, strong) SearchSiftView *siftView;
@property (nonatomic, strong) BlackView *siftBgView;
@property (nonatomic, strong) NSString * mapText;
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) FilterModel * filterModel;
@property (nonatomic, strong) NSMutableArray *paramArr;
@property (nonatomic, strong) NSMutableArray *FQTagViewParam;
@property (nonatomic, strong) TagListModel *listModel;
@property (nonatomic, strong) FindADMAdviseView * admAdvise;
@property (nonatomic, strong) NSMutableArray *siftParamArr;
@property (nonatomic, copy) NSString * tempQv; //判断筛选判断 单选多选数组加元素 临时全局变量

@property (nonatomic, strong) NSMutableArray *saveParamArr;
@property (nonatomic, strong) TapDetectingImageView * adviserImg;
@property (nonatomic, assign) CGPoint originPoint;
@property (nonatomic, strong) UIPanGestureRecognizer *pgr;
@property (nonatomic, assign) CGFloat offsize;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, copy) NSString *changeSearchText;
@property (nonatomic, assign) NSInteger timerIndex;
@property (nonatomic, assign) NSInteger netIndex;
@property (nonatomic, strong) NSMutableArray * overridePriceArr;
@end

@implementation SearchViewController


-(TapDetectingImageView *)adviserImg
{
    if (!_adviserImg) {
        UIImage * image = [UIImage imageNamed:@"home_adm_adviser"];
        _adviserImg = [[TapDetectingImageView alloc] initWithFrame:CGRectMake(kScreenWidth-50, kScreenHeight-60-40-60, image.size.width, image.size.height)];
        _adviserImg.image = image;
        _adviserImg.handleSingleTapDetected = ^(TapDetectingImageView * view,UIGestureRecognizer * tgr){
            
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"adviser" path:@"get_adviser" parameters:nil completionBlock:^(NSDictionary *data) {
                
                AdviserPage *adviserPage = [[AdviserPage alloc] initWithJSONDictionary:data[@"adviser"]];
                [UserSingletonCommand chatWithUserHasWXNum:adviserPage.userId msg:[NSString stringWithFormat:@"%@", adviserPage.greetings] adviser:adviserPage nadGoodsId:nil];
                
            } failure:^(XMError *error) {
                
            } queue:nil]];
            
        };
    }
    return _adviserImg;
}

-(NSTimer *)timer{
    if (!_timer) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(searchThink) userInfo:nil repeats:YES];
    }
    return _timer;
}

-(NSMutableArray *)saveParamArr{
    if (!_saveParamArr) {
        _saveParamArr = [[NSMutableArray alloc] init];
    }
    return _saveParamArr;
}

-(FindADMAdviseView *)admAdvise
{
    if (!_admAdvise) {
        _admAdvise = [[FindADMAdviseView alloc] initWithFrame:CGRectMake(0, 65, kScreenWidth, kScreenHeight-65)];
        _admAdvise.backgroundColor = [UIColor whiteColor];
        _admAdvise.hidden = YES;
    }
    return _admAdvise;
}

-(NSMutableArray *)siftParamArr{
    if (!_siftParamArr) {
        _siftParamArr = [[NSMutableArray alloc] init];
    }
    return _siftParamArr;
}

-(NSMutableArray *)FQTagViewParam{
    if (!_FQTagViewParam) {
        _FQTagViewParam = [[NSMutableArray alloc] init];
    }
    return _FQTagViewParam;
}

-(NSMutableArray *)paramArr{
    if (!_paramArr) {
        _paramArr = [[NSMutableArray alloc] init];
    }
    return _paramArr;
}

-(FQTagsView *)FQTagView{
    if (!_FQTagView) {
        _FQTagView = [[FQTagsView alloc] initWithFrame:CGRectZero];
    }
    return _FQTagView;
}

-(BlackView *)siftBgView{
    if (!_siftBgView) {
        _siftBgView = [[BlackView alloc] initWithFrame:CGRectZero];
    }
    return _siftBgView;
}

-(SearchSiftView *)siftView{
    if (!_siftView) {
        _siftView = [[SearchSiftView alloc] initWithFrame:CGRectZero];
    }
    return _siftView;
}

-(SearchTopNewView *)topNewView{
    if (!_topNewView) {
        _topNewView = [[SearchTopNewView alloc] initWithFrame:CGRectZero];
        _topNewView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    }
    return _topNewView;
}

-(UIView *)promptSecionView{
    if (!_promptSecionView) {
        _promptSecionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44+42+7)];
        _promptSecionView.backgroundColor = [UIColor whiteColor];
    }
    return _promptSecionView;
}

-(UIView *)headerLineView1{
    if (!_headerLineView1) {
        _headerLineView1 = [[UIView alloc] initWithFrame:CGRectZero];
        _headerLineView1.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    }
    return _headerLineView1;
}

-(UIView *)headerLineView{
    if (!_headerLineView) {
        _headerLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _headerLineView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    }
    return _headerLineView;
}

-(XMWebImageView *)headerImageView{
    if (!_headerImageView) {
        _headerImageView = [[XMWebImageView alloc] initWithFrame:CGRectZero];
        _headerImageView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    }
    return _headerImageView;
}

-(UIView *)promptHeaderView{
    if (!_promptHeaderView) {
        _promptHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.01)];
        _promptHeaderView.backgroundColor = [UIColor whiteColor];
    }
    return _promptHeaderView;
}

-(RecommendButlerView *)guanjiaView{
    if (!_guanjiaView) {
        _guanjiaView = [[RecommendButlerView alloc] initWithFrame:CGRectMake(0, self.topBarHeight, kScreenWidth, kScreenHeight-self.topBarHeight)];
    }
    return _guanjiaView;
}



- (id)init {
    self = [super init];
    if (self) {
        _searchType = kSearchTypeGoods;
        _isForSelected = NO;
        _sellerId = 0;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat topBarHeight = [super setupTopBar];
    self.topBar.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    self.topBarlineView.backgroundColor = [UIColor colorWithHexString:@"f9f9f9"];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton:[UIImage imageNamed:@"more_wjh"] imgPressed:nil];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    
    _mapText = self.keywordMap.mapText;
    _searchBarView = [[SearchBarView alloc] initWithFrame:CGRectMake(45, topBarHeight-11.f-25, kScreenWidth-30-70.f, 29) isShowClearButton:YES isShowLeftCombBox:NO];
    _searchBarView.placeholder = _isForSelected?@"搜店铺商品":_mapText?_mapText:@"请输入关键词";
    _searchBarView.delegate = self;
    _searchBarView.mapText = self.keywordMap.showText;
    _searchBarView.currentSearchType = self.searchType;
    _titles = @[@"消息",@"首页",@"我要反馈",@"分享"];
    _images=@[@"pop_messgae",@"pop_home",@"pop_feedback",@"pop_share"];
    
    [_searchBarView enableCancelButton:NO];
    [self.topBar addSubview:_searchBarView];
    
    _searchBarView.backgroundColor = [UIColor colorWithHexString:@"ececec"];
    
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight)];
    _contentView.userInteractionEnabled = YES;
    [self.view addSubview:_contentView];
    
    _dataSourcesSellers = [[NSMutableArray alloc] init];
    _dataSources = [[NSMutableArray alloc] init];
    _goodsArrayList = [[NSMutableArray alloc] init];
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:_contentView.bounds];
    tableView.enableRefreshing = NO;
    tableView.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    tableView.pullDelegate = self;
    tableView.dataSource = self;
    tableView.delegate = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.alwaysBounceVertical = YES;
    //    tableView.showsVerticalScrollIndicator = NO;
    tableView.tableHeaderView = self.promptHeaderView;
    //    self.promptHeaderView.hidden = YES;
    tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_contentView addSubview:tableView];
    [_contentView addSubview:self.adviserImg];
    
    _tableView = tableView;
    _tableView.hidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
    
    CGFloat marginTop = 0.f;
    //    _filterTopView = [[SearchFilterTopView alloc] init];
    //    _filterTopView.frame = CGRectMake(0, marginTop, _filterTopView.width, _filterTopView.height);
    //    _filterTopView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];
    //
    //    marginTop += _filterTopView.height;
    //    _filterContainerView = [[SearchFilterContainerView alloc] init];
    //    _filterContainerView.frame = CGRectMake(0, marginTop, _filterContainerView.width, _contentView.height-marginTop);
    //    [_contentView addSubview:_filterContainerView];
    
    
    WEAKSELF;
    [self.promptHeaderView addSubview:self.headerImageView];
    self.headerImageView.frame = CGRectMake(12, 7, kScreenWidth-24, 65-13);
    [self.promptHeaderView addSubview:self.headerLineView];
    self.headerLineView.frame = CGRectMake(0, 63, kScreenWidth, 1);
    [self.promptSecionView addSubview:self.topNewView];
    self.topNewView.frame = CGRectMake(0, marginTop, kScreenWidth, 51);
    [self.promptSecionView addSubview:self.headerLineView1];
    self.headerLineView1.frame = CGRectMake(0, 44+7, kScreenWidth, 1);
    
    if (self.isXianzhi == 0) {
        [self.promptSecionView addSubview:self.FQTagView];
        self.FQTagView.frame = CGRectMake(0, 51+1, kScreenWidth, 44+42+7-51-1);
    }
    
    NSMutableArray *param = [[NSMutableArray alloc] init];
    self.FQTagView.serveTagTable = ^(TagListModel *listModel, NSInteger tagIndex, NSArray *tagList){
        [weakSelf.FQTagViewParam removeAllObjects];
        
        
        
        if (param.count == 0) {
            [param addObject:@(tagIndex)];
        }else{
            for (int i = 0; i < param.count; i++) {
                NSNumber *tagNum = param[i];
                if (tagNum.integerValue == tagIndex) {
                    [param removeObject:tagNum];
                } else {
                    if (i == param.count - 1) {
                        [param addObject:@(tagIndex)];
                        break;
                    }
                }
            }
        }
        
        NSLog(@"%@", param);
        
        for (int i = 0; i < param.count; i++) {
            NSNumber *tagNum = param[i];
            TagListModel *listModel = [[TagListModel alloc] initWithJSONDictionary:tagList[tagNum.integerValue]];
            for (int i = 0; i < listModel.fqParams.count; i++) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                FqParamsModel *paramModel = listModel.fqParams[i];
                [dict setObject:paramModel.qk forKey:@"qk"];
                [dict setObject:paramModel.qv forKey:@"qv"];
                [weakSelf.FQTagViewParam addObject:dict];
            }
        }
        
        [weakSelf.FQTagViewParam addObjectsFromArray:weakSelf.paramArr];
        [weakSelf.FQTagViewParam addObjectsFromArray:weakSelf.siftParamArr];
        
        //        for (int i = 0; i < listModel.fqParams.count; i++) {
        //            FqParamsModel *paramModel = listModel.fqParams[i];
        //            for (int i = 0; i < weakSelf.paramArr.count; i++) {
        //                NSDictionary *dict = weakSelf.paramArr[i];
        //                if ([dict[@"qk"] isEqualToString:paramModel.qk]) {
        //                    [weakSelf.paramArr removeObject:dict];
        //                }
        //            }
        //        }
        //
        //        //        NSLog(@"%@", weakSelf.paramArr);
        //        //        NSLog(@"%@", weakSelf.FQTagViewParam);
        ////        if ([listModel.title isEqualToString:weakSelf.listModel.title]) {
        ////            weakSelf.listModel = nil;
        ////            [weakSelf.FQTagViewParam removeAllObjects];
        ////            [weakSelf doSearch:weakSelf.keywords params:[[weakSelf.paramArr JSONString] URLEncodedString] timestamp:weakSelf.timestamp];
        ////        } else {
        ////            weakSelf.listModel = listModel;
        //            for (int i = 0; i < listModel.fqParams.count; i++) {
        //                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
        //                FqParamsModel *paramModel = listModel.fqParams[i];
        //
        //                [dict setObject:paramModel.qk forKey:@"qk"];
        //                [dict setObject:paramModel.qv forKey:@"qv"];
        //
        //                if (param.count > 0) {
        //                    for (int i = 0; i < param.count > 0; i++) {
        //                        NSDictionary *dic = param[i];
        //                        if ([dic[@"qk"] isEqualToString:paramModel.qk] && [dic[@"qv"] isEqualToString:paramModel.qv]) {
        //                            [param removeObject:dic];
        //                            break ;
        //                        } else {
        //                            if (i == param.count - 1) {
        //                                [param addObject:dict];
        //                                break;
        //                            }
        //                        }
        //                    }
        //                } else {
        //                    [param addObject:dict];
        //                }
        //
        //                for (int i = 0; i < weakSelf.siftParamArr.count; i++) {
        //                    NSDictionary *dict = weakSelf.siftParamArr[i];
        //                    if ([dict[@"qk"] isEqualToString:paramModel.qk]) {
        //                        [weakSelf.siftParamArr removeObject:dict];
        //                    }
        //                }
        //            }
        //
        //
        //            [param addObjectsFromArray:weakSelf.paramArr];
        //            [param addObjectsFromArray:weakSelf.siftParamArr];
        //        NSSet *set = [NSSet setWithArray:param];
        //        NSLog(@"%@", [set allObjects]);
        //        weakSelf.FQTagViewParam = [NSMutableArray arrayWithArray:[set allObjects]];//[set allObjects];
        //        NSMutableArray *paramList = [[NSMutableArray alloc] initWithArray:[set allObjects]];
        for (int i = 0; i < weakSelf.saveParamArr.count; i++) {
            SearchFilterKV *s = weakSelf.saveParamArr[i];
            if ([s.qk isEqualToString:@"sellerId"] && [s.qv isEqualToString:@"91425"]) {
                weakSelf.returnGoodsQk = s.qk;
                weakSelf.returnGoodsQv = s.qv;
            }
            NSDictionary *dict = [[NSDictionary alloc] init];
            dict = @{@"qk":s.qk, @"qv":s.qv};
            [weakSelf.FQTagViewParam addObject:dict];
        }
        
        NSLog(@"%@", weakSelf.FQTagViewParam);
        weakSelf.params = [[weakSelf.FQTagViewParam JSONString] URLEncodedString];
        [weakSelf doSearch:weakSelf.keywords params:weakSelf.params timestamp:weakSelf.timestamp];
        //                }
    };
    
    //    self.searchHistoryView.frame = _contentView.bounds;
    //    [_contentView addSubview:self.searchHistoryView];
    
    _loadingView = [[LoadingView alloc] initWithFrame:_contentView.bounds];
    _loadingView.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:0 green:0 blue:0 alpha:0.08f];
    _loadingView.hidden = YES;
    [_contentView addSubview:_loadingView];
    
    
    _keyworldAssociate = [[KeyworldAssociateView alloc] initWithFrame:CGRectMake(0, self.topBarHeight, kScreenWidth, kScreenHeight-self.topBarHeight)];
    _keyworldAssociate.hidden = YES;
    _keyworldAssociate.delegate = self;
    [self.view addSubview:_keyworldAssociate];
    [self bringTopBarToTop];
    
    _filterContainerView.hidden = YES;
    _topNewView.hidden = YES;
    
    _totalNum = 0;
    _isCancelCurFilter = NO;
    
    _topNewView.handleTopItemTapDetected = ^(SearchFilterTopItemView *view) {
        [weakSelf.view endEditing:YES];
        if ([view isSelected])
        {
            weakSelf.isCancelCurFilter = YES;
            if (view.filterInfo.type==0) {
                for (SearchFilterItem *item in view.filterInfo.items) {
                    if ([item isKindOfClass:[SearchFilterItem class]]) {
                        item.isYesSelected = YES;
                    }
                }
            } else if (view.filterInfo.type==1) {
                for (SearchFilterInfo *filterInfo in view.filterInfo.items) {
                    for (SearchFilterItem *item in filterInfo.items) {
                        if ([item isKindOfClass:[SearchFilterItem class]]) {
                            item.isYesSelected = YES;
                        }
                    }
                }
            }
            [view setSelected:NO];
            weakSelf.filterContainerView.hidden = YES;
            [weakSelf doSearch:weakSelf.keywords];
        }
        else {
            weakSelf.isCancelCurFilter = YES;
            weakSelf.filterContainerView.hidden = NO;
            [weakSelf.filterContainerView.superview bringSubviewToFront:weakSelf.filterContainerView];
            [weakSelf.filterContainerView.superview bringSubviewToFront:weakSelf.topNewView];
            [weakSelf.filterContainerView updateByFilterInfo:view.filterInfo];
        }
    };
    
    _topNewView.handleTopItemCancelTapDetected = ^(SearchFilterTopItemView *view){
        [view setSelected:NO];
        weakSelf.isCancelCurFilter = YES;
        weakSelf.filterContainerView.hidden = YES;
    };
    
    _filterContainerView.handleFilterCancelDetected = ^(SearchFilterContainerView *view) {
        weakSelf.isCancelCurFilter = YES;
        [weakSelf.view endEditing:YES];
        weakSelf.filterContainerView.hidden = YES;
        [weakSelf.filterTopView cancelFilter];
    };
    
    _filterContainerView.handleFilterItemsSelected = ^(SearchFilterContainerView *view, NSArray *filterInfos) {
        weakSelf.isCancelCurFilter = YES;
        [weakSelf.view endEditing:YES];
        [weakSelf.filterTopView cancelFilter];
        [weakSelf.filterTopView updateTopItemsSelectedState];
        weakSelf.filterContainerView.hidden = YES;
        
        [weakSelf doSearch:weakSelf.searchBarView.text];
    };
    
    //测试
    ////    [{"qk":"grade","qv":1},{"qk":"brand","qv":"Louis Vuitton/路易威登"}]
    //    NSMutableArray *array = [[NSMutableArray alloc] init];
    //    NSMutableDictionary *dictTmp = [[NSMutableDictionary alloc] init];
    //    [dictTmp setValue:@"grade" forKey:@"qk"];
    //    [dictTmp setValue:@"1" forKey:@"qv"];
    //    [array addObject:dictTmp];
    //
    //    NSMutableDictionary *dictTmp2 = [[NSMutableDictionary alloc] init];
    //    [dictTmp2 setValue:@"brand" forKey:@"qk"];
    //    [dictTmp2 setValue:@"Louis Vuitton/路易威登" forKey:@"qv"];
    //    [array addObject:dictTmp2];
    //
    //    NSString *paramsJsonData = [array JSONString];
    ////    NSString *strUrlEncode = [str URLEncodedString];
    ////    NSString *paramsJsonData = [strUrlEncode URLDecodedString];
    //
    //    NSError *error = nil;
    //    JSONDecoder *parser = [JSONDecoder decoder];
    //    NSData *data = [paramsJsonData dataUsingEncoding: NSUTF8StringEncoding];
    //    id result = [parser mutableObjectWithData:data error:&error];
    
    if ([self.searchKeywords length]>0) {
        self.keywords = self.searchKeywords;
        _searchHistoryView.hidden = YES;
        self.isCancelCurFilter = NO;
        _searchBarView.text = self.searchKeywords;
        [self doSearch:self.searchKeywords type:self.searchBarView.currentSearchType];
    }
    else if ((self.queryKey && self.filterItem && [self.filterItem.queryValue length]>0)|| self.queryKVItemsArray.count>0) {
        self.searchBarView.text = self.filterItem.title;;//self.filterItem.queryValue;
        self.keywords = self.filterItem.title;//[self.filterItem.title length]>0?self.filterItem.title:self.filterItem.queryValue;
        //        self.params = [NSString stringWithFormat:@"%@=%@",self.queryKey,self.filterItem.queryValue];
        NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
        if (self.queryKey && self.filterItem && [self.filterItem.queryValue length]>0) {
            //            if (self.returnGoodsQv && self.returnGoodsQk) {
            //                [paramsArray addObject:[[self class] createQueryParam:self.returnGoodsQk queryValue:self.returnGoodsQv]];
            //            }
            [paramsArray addObject:[[self class] createQueryParam:self.queryKey queryValue:self.filterItem.queryValue]];
        }
        if (self.queryKVItemsArray.count>0) {
            //            [paramsArray addObjectsFromArray:self.queryKVItemsArray];
            
            //修改遗留BUG 2016.5.13
            for (int i = 0; i < self.queryKVItemsArray.count; i++) {
                if ([self.queryKVItemsArray[i] isKindOfClass:[SearchFilterKV class]]) {
                    SearchFilterKV *s = self.queryKVItemsArray[i];
                    if ([s.qk isEqualToString:@"sellerId"] && [s.qv isEqualToString:@"91425"]) {
                        self.returnGoodsQk = s.qk;
                        self.returnGoodsQv = s.qv;
                    }
                    NSDictionary *dict = [[NSDictionary alloc] init];
                    dict = @{@"qk":s.qk, @"qv":s.qv};
                    [paramsArray addObject:dict];
                }
            }
            
        }
        [paramsArray addObject:@{@"qk":@"searchType",@"qv":[NSString stringWithFormat:@"%ld",(long)self.isXianzhi]}];
        self.params = [[paramsArray JSONString] URLEncodedString];
        [_loadingView showLoadingView];
        [self loadFilterData:self.keywords params:self.params sellerId:_sellerId];
    }
    else if (self.sellerId>0 || self.isForSelected) {
        NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
        [paramsArray addObject:@{@"qk":@"searchType",@"qv":[NSString stringWithFormat:@"%ld",(long)self.isXianzhi]}];
        self.params = [[paramsArray JSONString] URLEncodedString];
        [_loadingView showLoadingView];
        [self loadFilterData:self.keywords params:self.params sellerId:_sellerId];
    }
    else {
        [_searchBarView becomeFirstResponder];
    }
    
    [self.view addSubview:self.admAdvise];
    self.admAdvise.successBack = ^(){
        [weakSelf dismiss];
    };
    
    [weakSelf.view addSubview:weakSelf.siftBgView];
    [weakSelf.view addSubview:weakSelf.siftView];
    weakSelf.siftBgView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    weakSelf.siftBgView.alpha = 0;
    weakSelf.siftView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth-70, kScreenHeight);
    
    self.topNewView.showSiftView = ^(){
        [weakSelf loadSearchFilterData:nil];
    };
    self.siftBgView.dissMissBlackView = ^(){
        [weakSelf dismissSiftView];
    };
    
    self.siftView.handleFinishButtonClick = ^(CommandButton * sender){
        [weakSelf dismissSiftView];
    };
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadSearchView:) name:@"loadSearchView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(filterSearch:) name:@"filterSearch" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetSearchFilter:) name:@"resetSearchFilter" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(overridePriceFilterSearch:) name:@"overridePriceFilterSearch" object:nil];
    
    
}

- (void)pgr:(UIPanGestureRecognizer *)pgr
{
    CGPoint point = [pgr translationInView:self.view];
    
    static CGPoint originPoint;
    if (pgr.state == UIGestureRecognizerStateBegan)
    {
        originPoint = pgr.view.center;
    }
    
    pgr.view.center = CGPointMake(originPoint.x+point.x, originPoint.y+point.y);
    _originPoint = originPoint;
    _pgr = pgr;
    
    if (pgr.state == UIGestureRecognizerStateEnded) {
        originPoint = pgr.view.center;
        CGFloat x = originPoint.x;
        CGFloat y = originPoint.y;
        
        if (y < 100) {
            [UIView animateWithDuration:0.2 animations:^{
                pgr.view.center = CGPointMake(originPoint.x, 65/2);
            }];
            return;
        } else if (y > kScreenHeight-50) {
            [UIView animateWithDuration:0.2 animations:^{
                pgr.view.center = CGPointMake(originPoint.x, kScreenHeight-65/2);
            }];
            return;
        }
        
        if (x < kScreenWidth/2) {
            [UIView animateWithDuration:0.2 animations:^{
                pgr.view.center = CGPointMake(65/2, originPoint.y);
            }];
        } else if (x > kScreenWidth/2) {
            [UIView animateWithDuration:0.2 animations:^{
                pgr.view.center = CGPointMake(kScreenWidth-65/2, originPoint.y);
            }];
        }
    }
    pgr.view.alpha = 1;
    
}



-(void)dealloc{
    [self.timer invalidate];
    self.timer = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"loadSearchView" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"filterSearch" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"resetSearchFilter" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"overridePriceFilterSearch" object:nil];
}

-(void)setQueryKVItemsArray:(NSArray *)queryKVItemsArray{
    _queryKVItemsArray = queryKVItemsArray;
    [self.saveParamArr addObjectsFromArray:queryKVItemsArray];
}

-(void)dismissSiftView
{
    WEAKSELF;
    [UIView animateWithDuration:0.25 animations:^{
        weakSelf.siftBgView.alpha = 0;
        weakSelf.siftView.frame = CGRectMake(kScreenWidth, 0, kScreenWidth-70, kScreenHeight);
    } completion:^(BOOL finished) {
    }];
}

-(void)filterSearch:(NSNotification *)n
{
    
    NSDictionary * dict = n.userInfo;
    NSDictionary * buttonDict = n.object;
    
    //    for (int i = 0; i < self.overridePriceArr.count; i++) {
    //        NSDictionary * dic1 = [self.overridePriceArr objectAtIndex:i];
    //        for (int j = 0; j < self.siftParamArr.count; j++) {
    //          NSDictionary * dic2 = [self.siftParamArr objectAtIndex:i];
    //            if ([dic2[@"qk"] isEqualToString:@"shopPrice"]) {
    //                if ([dic1[@"qk"] isEqualToString:dic2[@"qk"]] && [dic1[@"qv"] isEqualToString:dic2[@"qv"]]) {
    //                    [self.siftParamArr removeObject:dic2];
    //                }
    //            }
    //        }
    //    }
    
    if (self.siftParamArr.count > 0) {
        
        if ([buttonDict[@"multisSelected"] integerValue] == 1) {//多选
            if ([buttonDict[@"buttonIsSeclected"] boolValue] == NO) {
                for (int i = 0; i < self.siftParamArr.count; i++) {
                    NSDictionary * dic = self.siftParamArr[i];
                    if ([dic[@"qk"] isEqualToString:dict[@"qk"]] && [dic[@"qv"] isEqualToString:dict[@"qv"]]) {
                        [self.siftParamArr removeObject:dic];
                    }
                }
            }else{
                [self.siftParamArr addObject:dict];
            }
        }else{//单选
            
            if (![_tempQv isEqualToString:dict[@"qv"]]) {
                for (int i = 0; i <self.siftParamArr.count; i++) {
                    NSDictionary * dic = [self.siftParamArr objectAtIndex:i];
                    
                    if ([_tempQv isEqualToString:dic[@"qv"]]) {
                        [self.siftParamArr removeObject:dic];
                    }
                }
                [self.siftParamArr addObject:dict];
            } else{
                if ([buttonDict[@"buttonIsSeclected"] boolValue] == NO) {
                    [self.siftParamArr removeObject:dict];
                }else{
                    [self.siftParamArr addObject:dict];
                }
            }
            _tempQv = dict[@"qv"];
        }
        
    }else{
        [self.siftParamArr addObject:dict];
        if ([buttonDict[@"multisSelected"] integerValue] != 1) {//传过来的按钮是否选中状态
            _tempQv = dict[@"qv"];
        }
    }
    
    [self.siftParamArr addObjectsFromArray:self.FQTagViewParam];
    for (int i = 0; i < self.paramArr.count; i++) {
        NSDictionary *paraDict = self.paramArr[i];
        if ([paraDict[@"qk"] isEqualToString:dict[@"qk"]]) {
            [self.paramArr removeObject:paraDict];
        }
    }
    
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:self.siftParamArr];
    for (int i = 0; i < arr.count; i++) {
        NSDictionary *dictSift = arr[i];
        for (int j = 0; j < self.paramArr.count; j++) {
            NSDictionary *dictParam = self.paramArr[j];
            if ([dictSift[@"qk"] isEqualToString:dictParam[@"qk"]]) {
                [self.siftParamArr removeObject:dictSift];
            }
        }
    }
    
    [self.siftParamArr addObjectsFromArray:self.paramArr];
    NSSet *set = [NSSet setWithArray:self.siftParamArr];
    self.siftParamArr = [[NSMutableArray alloc] initWithArray:[set allObjects]];
    NSLog(@"%@", self.siftParamArr);
    
    NSMutableArray *paramList = [[NSMutableArray alloc] initWithArray:self.siftParamArr];
    for (int i = 0; i < self.saveParamArr.count; i++) {
        SearchFilterKV *s = self.saveParamArr[i];
        if ([s.qk isEqualToString:@"sellerId"] && [s.qv isEqualToString:@"91425"]) {
            self.returnGoodsQk = s.qk;
            self.returnGoodsQv = s.qv;
        }
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = @{@"qk":s.qk, @"qv":s.qv};
        [paramList addObject:dict];
    }
    
    [paramList addObject:@{@"qk":@"searchType",@"qv":[NSString stringWithFormat:@"%ld",self.isXianzhi]}];
    self.params = [[paramList JSONString] URLEncodedString];
    [self doSearch:self.keywords params:self.params timestamp:self.timestamp];
    
    [self loadSearchFilterData:self.params];
    
    
}

- (void)overridePriceFilterSearch:(NSNotification *)n
{
    NSDictionary * dict = n.userInfo;
    NSDictionary * status = n.object;
    _tempQv = dict[@"qv"];
    if (self.siftParamArr.count > 0) {
        if ([status[@"multisSelected"] integerValue] == 1) {//多选
            
            for (int i = 0; i < self.siftParamArr.count; i++) {
                NSDictionary * dic = self.siftParamArr[i];
                if ([dic[@"qk"] isEqualToString:dict[@"qk"]] && [dic[@"qv"] isEqualToString:dict[@"qv"]]) {
                    [self.siftParamArr removeObject:dic];
                    [self.siftParamArr addObject:dict];
                }
            }
        }else{
            for (int i = 0; i < self.siftParamArr.count; i++) {
                NSDictionary * dic = self.siftParamArr[i];
                if ([dic[@"qk"] isEqualToString:dict[@"qk"]]) {
                    [self.siftParamArr removeObject:dic];
                    [self.siftParamArr addObject:dict];
                }
            }
        }
    }else{
        [self.siftParamArr addObject:dict];
    }
    
    self.overridePriceArr = self.siftParamArr;
    NSLog(@"self.siftParamArr === %@",self.siftParamArr);
    
    
    NSMutableArray *paramList = [[NSMutableArray alloc] initWithArray:self.siftParamArr];
    for (int i = 0; i < self.saveParamArr.count; i++) {
        SearchFilterKV *s = self.saveParamArr[i];
        if ([s.qk isEqualToString:@"sellerId"] && [s.qv isEqualToString:@"91425"]) {
            self.returnGoodsQk = s.qk;
            self.returnGoodsQv = s.qv;
        }
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = @{@"qk":s.qk, @"qv":s.qv};
        [paramList addObject:dict];
    }
    
    [paramList addObject:@{@"qk":@"searchType",@"qv":[NSString stringWithFormat:@"%ld",self.isXianzhi]}];
    self.params = [[paramList JSONString] URLEncodedString];
    [self doSearch:self.keywords params:self.params timestamp:self.timestamp];
    [self loadSearchFilterData:self.params];
}

-(void)resetSearchFilter:(NSNotification *)n
{
    [self.siftParamArr removeAllObjects];
    [self loadSearchFilterData:nil];
}

-(void)loadSearchFilterData:(NSString *)paramsArr
{
    WEAKSELF;
    NSInteger user_id = [Session sharedInstance].currentUserId?[Session sharedInstance].currentUserId:0;
    NSString * keywords = weakSelf.searchBarView.text?weakSelf.searchBarView.text:@"";
    NSDictionary * params = @{@"keywords":keywords,@"user_id":[NSNumber numberWithInteger:user_id],@"params":paramsArr?paramsArr:@""};
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"filter" parameters:params completionBlock:^(NSDictionary *data) {
        
        NSArray * array = data[@"list"];
        if ([array count] > 0) {
            
            for (NSDictionary * dict in array) {
                if ([dict[@"name"] isEqualToString:@"筛选"]) {
                    FilterModel * filterModel = [FilterModel createWithDict:dict];
                    weakSelf.filterModel = filterModel;
                    break;
                }
            }
            [weakSelf.siftView getFilterModel:weakSelf.filterModel keyworlds:keywords array:self.siftParamArr];
        }
        [UIView animateWithDuration:0.25 animations:^{
            weakSelf.siftBgView.alpha = 0.7;
            weakSelf.siftView.frame = CGRectMake(70, 0, kScreenWidth-70, kScreenHeight);
        }];
        
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
}

-(void)loadSearchView:(NSNotification *)notify{
    NSDictionary *dict = notify.object;
    SearchFilterInfo *filterInfo = [dict objectForKey:@"filterInfo"];
    NSInteger itemNum = ((NSNumber *)[dict objectForKey:@"itemNum"]).integerValue;
    NSLog(@"saveParamArr1 == %@",self.saveParamArr);
    for (int i = 0 ; i< self.saveParamArr.count; i++) {
        SearchFilterKV *s = self.saveParamArr[i];
        if ([s.qk isEqualToString:filterInfo.queryKey]) {
            [self.saveParamArr removeObjectAtIndex:i];
        }
    }
    
    NSLog(@"saveParamArr2 == %@",self.saveParamArr);
    
    NSMutableArray *paramArr = [[NSMutableArray alloc] init];
    NSMutableDictionary *paramDict = [[NSMutableDictionary alloc] init];
    [paramDict setObject:filterInfo.queryKey forKey:@"qk"];
    [paramDict setObject:((SearchFilterItem *)(filterInfo.items[itemNum])).queryValue forKey:@"qv"];
    [paramArr addObject:paramDict];
    self.paramArr = paramArr;
    
    for (int i = 0; i < self.FQTagViewParam.count; i++) {
        NSDictionary *dictionary = self.FQTagViewParam[i];
        if ([dictionary[@"qk"] isEqualToString:filterInfo.queryKey]) {
            [self.FQTagViewParam removeObject:dictionary];
        }
    }
    
    [paramArr addObjectsFromArray:self.FQTagViewParam];
    
    for (int i = 0; i < self.siftParamArr.count; i++) {
        NSDictionary *dict = self.siftParamArr[i];
        if ([dict[@"qk"] isEqualToString:filterInfo.queryKey]) {
            [self.siftParamArr removeObject:dict];
        }
    }
    [paramArr addObjectsFromArray:self.siftParamArr];
    NSMutableArray *paramList = [[NSMutableArray alloc] initWithArray:paramArr];
    NSLog(@"saveParamArr3 == %@",self.saveParamArr);
    for (int i = 0; i < self.saveParamArr.count; i++) {
        SearchFilterKV *s = self.saveParamArr[i];
        if ([s.qk isEqualToString:@"sellerId"] && [s.qv isEqualToString:@"91425"]) {
            self.returnGoodsQk = s.qk;
            self.returnGoodsQv = s.qv;
        }
        NSDictionary *dict = [[NSDictionary alloc] init];
        dict = @{@"qk":s.qk, @"qv":s.qv};
        [paramList addObject:dict];
    }
    NSLog(@"paramList == %@", paramList);
    [paramList addObject:@{@"qk":@"searchType",@"qv":[NSString stringWithFormat:@"%ld",(long)self.isXianzhi]}];
    self.params = [[paramList JSONString] URLEncodedString];
    [self doSearch:self.keywords params:self.params timestamp:self.timestamp];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.promptSecionView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isXianzhi == 0) {
        return 44+42+7;
    } else {
        return 44+7;
    }
}

+ (NSDictionary*)createQueryParam:(NSString*)queryKey queryValue:(NSString*)queryValue {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    if (queryKey)[dict setObject:queryKey forKey:@"qk"];
    if (queryValue)[dict setObject:queryValue forKey:@"qv"];
    return dict;
}

+ (NSArray*)createQueryFilterKVs:(NSString*)paramsJsonData {
    if ([paramsJsonData length]>0) {
        NSError *error = nil;
        JSONDecoder *parser = [JSONDecoder decoder];
        NSData *data = [paramsJsonData dataUsingEncoding: NSUTF8StringEncoding];
        id result = [parser mutableObjectWithData:data error:&error];
        if ([result isKindOfClass:[NSArray class]]) {
            NSArray *array = (NSArray*)result;
            if ([array count]>0) {
                NSMutableArray *itemsArray = [[NSMutableArray alloc] init];
                for (NSDictionary *dict in array) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        [itemsArray addObject:[[SearchFilterKV alloc] initWithJSONDictionary:dict]];
                    }
                }
                return itemsArray;
            }
        }
    }
    
    return nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    
    [self createPopMenuView];
    
}

- (void)createPopMenuView
{
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < _titles.count; i++) {
        WBPopMenuModel * info = [WBPopMenuModel new];
        info.image = _images[i];
        info.title = _titles[i];
        [obj addObject:info];
    }
    
    [[WBPopMenuSingleton shareManager] showPopMenuSelecteWithFrame:kScreenWidth/375*150 item:obj action:^(NSInteger index) {
        //@[@"消息",@"首页",@"我要反馈",@"分享"];
        switch (index) {
            case 0:
            {
                [[CoordinatingController sharedInstance] popToRootViewControllerAnimated:YES];
                [[CoordinatingController sharedInstance].mainViewController setSelectedAtIndex:3];
            }
                break;
            case 1:
            {
                [[CoordinatingController sharedInstance] gotoHomeRecommendViewControllerAnimated:YES];
            }
                break;
            case 2:
            {
                FeedbackViewController * about = [[FeedbackViewController alloc] init];
                [[CoordinatingController sharedInstance] pushViewController:about animated:YES];
                break;
            }
            case 3:
                //                [self shareGoods];
                break;
                
            default:
                break;
        }
    }];
}

- (TapDetectingView*)searchHistoryView {
    if (!_searchHistoryView) {
        _searchHistoryView = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectNull];
        titleLbl.backgroundColor = [UIColor clearColor];
        titleLbl.font = [UIFont systemFontOfSize:13.f];
        titleLbl.text = @"搜索历史";
        [titleLbl sizeToFit];
        [_searchBarView addSubview:titleLbl];
        
        WEAKSELF;
        _searchHistoryView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            [weakSelf.searchBarView setShowsCancelButton:NO animated:YES];
            [weakSelf.searchBarView resignFirstResponder];
            weakSelf.searchHistoryView.hidden = YES;
        };
        
    }
    return _searchHistoryView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [_tableView scrollViewDidScroll:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    [_dataListLogic reloadDataList];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    [_dataListLogic nextPage];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSources count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
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
    
    WEAKSELF;
    if ([tableViewCell isKindOfClass:[RecommendGoodsCellSearch class]]) {
        RecommendGoodsCellSearch *recommendGoodsCellSearch = (RecommendGoodsCellSearch*)tableViewCell;
        recommendGoodsCellSearch.handleRecommendGoodsClickBlock = ^(RecommendGoodsInfo *recommendGoodsInfo) {
            if (weakSelf.isForSelected) {
                if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(searchViewGoodsSelected:recommendGoods:)]) {
                    [weakSelf.delegate searchViewGoodsSelected:weakSelf recommendGoods:recommendGoodsInfo];
                }
            } else {
                [ClientReportObject clientReportObjectWithViewCode:HomeSearchViewCode regionCode:GoodsDetailRegionCode referPageCode:GoodsDetailRegionCode andData:@{@"goodsId":recommendGoodsInfo.goodsId}];
                [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:recommendGoodsInfo.goodsId animated:YES];
            }
        };
    }
    
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
    
}

- (void)$$handleGoodsInfoChanged:(id<MBNotification>)notifi goodsIds:(NSArray*)goodsIds
{
    WEAKSELF;
    if (notifi.key == (NSUInteger)weakSelf) return;
    
    [weakSelf.tableView reloadData];
}

- (void)doSearch:(NSString*)keywords type:(NSInteger)type {
    
    NSDictionary *data = @{@"searchKey":keywords};
    if (type == 0) {
        [ClientReportObject clientReportObjectWithViewCode:HomeSearchViewCode regionCode:SearchGoodsHotRegionCode referPageCode:NoReferPageCode andData:data];
    } else if (type == 1) {
        [ClientReportObject clientReportObjectWithViewCode:HomeSearchViewCode regionCode:SearchSellHotRegionCode referPageCode:NoReferPageCode andData:data];
    }
    
    self.searchBarView.text = keywords;
    if (type == kSearchTypeGoods) {
        [self doSearch:keywords byForce:type!=self.searchType?YES:NO];
    } else {
        WEAKSELF;
        if ([weakSelf.dataSources count]>0) {
            weakSelf.loadingView.hidden = YES;
            [weakSelf showProcessingHUD:nil];
        } else {
            weakSelf.loadingView.hidden = NO;
            [weakSelf.loadingView showLoadingView];
        }
        
        //NSInteger requireFilter = 1;
        _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"search" path:@"sellers" pageSize:16 fetchSize:32];
        _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
        _dataListLogic.parameters = @{@"keywords":keywords?[keywords URLEncodedString]:@"",
                                      @"params":@""};
        
        // @"require_filter":[NSNumber numberWithInteger:requireFilter]
        
        _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
            weakSelf.tableView.pullTableIsRefreshing = NO;
            weakSelf.tableView.pullTableIsLoadingMore = NO;
        };
        
        _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
            
            [weakSelf hideHUD];
            weakSelf.guanjiaView.hidden = YES;
            weakSelf.tableView.pullTableIsRefreshing = NO;
            weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
            weakSelf.tableView.autoTriggerLoadMore = YES;
            
            [weakSelf.loadingView hideLoadingView];
            weakSelf.loadingView.hidden = YES;
            
            weakSelf.searchHistoryView.hidden = YES;
            weakSelf.tableView.hidden = NO;
            
            [weakSelf.goodsArrayList removeAllObjects];
            [weakSelf.dataSources removeAllObjects];
            
            weakSelf.admAdvise.hidden = YES;
            weakSelf.filterTopView.hidden = YES;
            weakSelf.filterContainerView.hidden = YES;
            weakSelf.tableView.frame = CGRectMake(0, 0, weakSelf.contentView.width, weakSelf.contentView.height);
            weakSelf.loadingView.frame = weakSelf.tableView.frame;
            
            
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (NSInteger i=0;i<[addedItems count];i+=1) {
                if ([array count]>0) {
                    [array addObject:[SearchTableSepViewCell buildCellDict]];
                }
                [array addObject:[SearchResultSellerTableViewCell buildCellDict:[SearchResultSellerItem createWithDict:[addedItems objectAtIndex:i]]]];
                
            }
            weakSelf.dataSources = array;
            
            [weakSelf.tableView reloadData];
            [weakSelf.tableView scrollViewToTop:YES];
        };
        
        _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
            weakSelf.tableView.pullTableIsRefreshing = NO;
            weakSelf.tableView.pullTableIsLoadingMore = YES;
        };
        _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
            
            [weakSelf hideHUD];
            
            [weakSelf.loadingView hideLoadingView];
            weakSelf.loadingView.hidden = YES;
            
            
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:weakSelf.dataSources];
            for (NSInteger i=0;i<[addedItems count];i+=1) {
                if ([array count]>0) {
                    [array addObject:[SearchTableSepViewCell buildCellDict]];
                }
                [array addObject:[SearchResultSellerTableViewCell buildCellDict:[SearchResultSellerItem createWithDict:[addedItems objectAtIndex:i]]]];
            }
            weakSelf.dataSources = array;
            
            if (loadFinished) {
                [weakSelf.dataSources addObject:[SearchTableSepViewCell buildCellDict]];
            }
            
            [weakSelf.tableView reloadData];
            
            weakSelf.tableView.pullTableIsLoadingMore = NO;
            weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
            weakSelf.tableView.autoTriggerLoadMore = YES;
        };
        _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
            weakSelf.tableView.pullTableIsRefreshing = NO;
            weakSelf.tableView.pullTableIsLoadingMore = NO;
            weakSelf.tableView.autoTriggerLoadMore = NO;
            
            if ([weakSelf.dataSources count]==0) {
                weakSelf.loadingView.hidden = NO;
                [weakSelf.loadingView loadEndWithError:nil];
                weakSelf.loadingView.handleRetryBtnClicked = ^(LoadingView *view) {
                    [weakSelf doSearch:keywords type:weakSelf.searchBarView.currentSearchType];
                };
            }
            
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f forView:weakSelf.view];
        };
        _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
            //            [weakSelf.dataSources removeAllObjects];
            //            [weakSelf.tableView reloadData];
            //            weakSelf.tableView.pullTableIsRefreshing = NO;
            //            weakSelf.tableView.pullTableIsLoadingMore = NO;
            //            weakSelf.tableView.pullTableIsLoadFinish = YES;
            //
            [weakSelf hideHUD];
            weakSelf.guanjiaView.hidden = YES;
            weakSelf.tableView.pullTableIsRefreshing = NO;
            weakSelf.tableView.pullTableIsLoadFinish = NO;
            weakSelf.tableView.autoTriggerLoadMore = YES;
            
            [weakSelf.loadingView hideLoadingView];
            weakSelf.loadingView.hidden = YES;
            
            weakSelf.searchHistoryView.hidden = YES;
            weakSelf.tableView.hidden = NO;
            
            [weakSelf.goodsArrayList removeAllObjects];
            [weakSelf.dataSources removeAllObjects];
            
            //            weakSelf.loadingView.hidden = NO;
            //             weakSelf.guanjiaView.hidden = NO;
            
            //            if (weakSelf.isForSelected && weakSelf.sellerId>0) {
            //                [weakSelf.loadingView loadEndWithNoContent:@"暂无商品" image:[UIImage imageNamed:@"no_content_icon.png"] withRetryButton:NO];
            //            } else {
            //                [weakSelf.loadingView loadEndWithNoContent:@"无搜索结果" image:[UIImage imageNamed:@"no_content_icon.png"] withRetryButton:NO];
            //            }
            
            weakSelf.topNewView.hidden = YES;
            weakSelf.filterContainerView.hidden = YES;
            weakSelf.tableView.frame = CGRectMake(0, 0, weakSelf.contentView.width, weakSelf.contentView.height);
            weakSelf.loadingView.frame = weakSelf.tableView.frame;
            
            [weakSelf.dataSources addObject:[SearchRecommendButlerCell buildCellDict]];
            [weakSelf.tableView reloadData];
            weakSelf.admAdvise.hidden = NO;
            weakSelf.admAdvise.searchKey = keywords;
        };
        _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
            
        };
        [_dataListLogic reloadDataListByForce];
    }
    
    self.searchType = type;
}

- (void)doSearch:(NSString*)keywords {
    [self doSearch:keywords byForce:YES];
}

- (void)doSearch:(NSString*)keywords byForce:(BOOL)byForce
{
    [MobClick event:@"click_filter_from_search"];
    NSArray *filterInfos = [self.topNewView filterInfos];
    for (SearchFilterInfo *filterInfo in filterInfos) {
        if ([filterInfo isKindOfClass:[SearchFilterInfo class]]) {
            if (filterInfo.type == 0) {
                if ([filterInfo.queryKey isEqualToString:self.queryKey]) {
                    for (SearchFilterItem *filterItem in filterInfo.items) {
                        if ([filterItem isKindOfClass:[SearchFilterItem class]]
                            && [filterItem.queryValue isEqualToString:self.filterItem.queryValue]) {
                            filterItem.isYesSelected = YES;
                        }
                    }
                }
            }
            else if (filterInfo.type == 1) {
                
                for (SearchFilterInfo *filterInfoSub in filterInfo.items) {
                    if ([filterInfoSub isKindOfClass:[SearchFilterInfo class]]) {
                        if (filterInfoSub.type == 0) {
                            
                            if (filterInfoSub.queryKey && [filterInfoSub.queryKey length]>0) {
                                for (SearchFilterItem *filterItem in filterInfoSub.items) {
                                    if ([filterItem isKindOfClass:[SearchFilterItem class]] && [filterItem.queryValue isEqualToString:self.filterItem.queryValue]) {
                                        filterItem.isYesSelected = YES;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    NSString *params = [self queryParams];
    NSLog(@"%@", params);
    if (![self.keywords isEqualToString:keywords] || ![self.params isEqualToString:params] || byForce)
    {
        self.keywords = keywords;
        self.params = params;
        [self loadFilterData:keywords params:params sellerId:_sellerId];
    }
}

- (NSString*)queryParams {
    NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
    //    NSMutableString *params = [[NSMutableString alloc] initWithString:@""];
    NSArray *filterInfos = [self.topNewView filterInfos];
    for (SearchFilterInfo *filterInfo in filterInfos) {
        if ([filterInfo isKindOfClass:[SearchFilterInfo class]]) {
            if (filterInfo.type == 0) {
                if (filterInfo.queryKey && [filterInfo.queryKey length]>0) {
                    for (SearchFilterItem *filterItem in filterInfo.items) {
                        if ([filterItem isKindOfClass:[SearchFilterItem class]] && filterItem.isYesSelected && filterItem.queryValue && [filterItem.queryValue length]>0) {
                            
                            //                            if ([params length]>0) {
                            //                                [params appendString:@"&"];
                            //                            }
                            //
                            //                            [params appendString:filterInfo.queryKey];
                            //                            [params appendString:@"="];
                            //                            [params appendString:filterItem.queryValue];
                            [paramsArray addObject:[[self class] createQueryParam:filterInfo.queryKey queryValue:filterItem.queryValue]];
                        }
                    }
                }
            } else if (filterInfo.type == 1) {
                for (SearchFilterInfo *filterInfoSub in filterInfo.items) {
                    if ([filterInfoSub isKindOfClass:[SearchFilterInfo class]]) {
                        if (filterInfoSub.type == 0) {
                            
                            if (filterInfoSub.queryKey && [filterInfoSub.queryKey length]>0) {
                                
                                for (SearchFilterItem *filterItem in filterInfoSub.items) {
                                    if ([filterItem isKindOfClass:[SearchFilterItem class]] && filterItem.isYesSelected && filterItem.queryValue && [filterItem.queryValue length]>0) {
                                        //                                        if ([params length]>0) {
                                        //                                            [params appendString:@"&"];
                                        //                                        }
                                        //
                                        //                                        [params appendString:filterInfoSub.queryKey];
                                        //                                        [params appendString:@"="];
                                        //                                        [params appendString:filterItem.queryValue];
                                        [paramsArray addObject:[[self class] createQueryParam:filterInfoSub.queryKey queryValue:filterItem.queryValue]];
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    //调整搜索逻辑 适配原价回收项目
    if (self.returnGoodsQv && self.returnGoodsQk) {
        [paramsArray addObject:[[self class] createQueryParam:self.returnGoodsQk queryValue:self.returnGoodsQv]];
    }
    [paramsArray addObject:@{@"qk":@"searchType",@"qv":[NSString stringWithFormat:@"%ld",(long)self.isXianzhi]}];
    return [[paramsArray JSONString] URLEncodedString];
    //    return params;
}

- (SearchFilterInfo*)mergeFilterInfoState:(SearchFilterInfo*)newFilterInfo fromFilterInfos:(NSArray*)filterInfos {
    
    //NSArray *filterInfos = [self.filterTopView filterInfos];
    for (SearchFilterInfo *filterInfo in filterInfos) {
        if ([filterInfo isKindOfClass:[SearchFilterInfo class]]) {
            if (filterInfo.type == newFilterInfo.type) {
                if (filterInfo.type == 0) {
                    if ([filterInfo.queryKey isEqualToString:newFilterInfo.queryKey]) {
                        for (SearchFilterItem *filterItem in filterInfo.items) {
                            if ([filterItem isKindOfClass:[SearchFilterItem class]] && filterItem.isYesSelected && filterItem.queryValue && [filterItem.queryValue length]>0) {
                                
                                for (SearchFilterItem *newFilterItem in newFilterInfo.items) {
                                    if ([newFilterItem isKindOfClass:[SearchFilterItem class]] && [newFilterItem.queryValue isEqualToString:filterItem.queryValue]) {
                                        newFilterItem.isYesSelected = filterItem.isYesSelected;
                                        break;
                                    }
                                }
                            }
                        }
                        break;
                    }
                } else if (filterInfo.type == 1) {
                    for (SearchFilterInfo *filterInfoSub in filterInfo.items) {
                        if ([filterInfoSub isKindOfClass:[SearchFilterInfo class]]) {
                            if (filterInfoSub.type == 0) {
                                for (SearchFilterItem *filterItem in filterInfoSub.items) {
                                    if ([filterItem isKindOfClass:[SearchFilterItem class]] && filterItem.isYesSelected && filterItem.queryValue && [filterItem.queryValue length]>0) {
                                        
                                        for (SearchFilterInfo *newFilterInfoSub in newFilterInfo.items) {
                                            if (newFilterInfoSub.type == 0) {
                                                if ([newFilterInfoSub.queryKey isEqualToString:filterInfoSub.queryKey]) {
                                                    
                                                    for (SearchFilterItem *newFilterItem in newFilterInfoSub.items) {
                                                        if ([newFilterItem isKindOfClass:[SearchFilterItem class]] && [newFilterItem.queryValue isEqualToString:filterItem.queryValue]) {
                                                            newFilterItem.isYesSelected = filterItem.isYesSelected;
                                                            break;
                                                        }
                                                    }
                                                    break;
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
            
        }
    }
    return newFilterInfo;
}

- (void)loadFilterData:(NSString*)keywords params:(NSString*)params sellerId:(NSInteger)sellerId {
    
    WEAKSELF;
    
    //上方banner
    if (keywords.length > 0) {
        WEAKSELF;
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"get_map_text" parameters:@{@"keyword":keywords} completionBlock:^(NSDictionary *data) {
            
            SearchBannerVo *bannerVo = [[SearchBannerVo alloc] initWithJSONDictionary:data[@"result"]];
            weakSelf.promptHeaderView.frame = CGRectMake(0, 0, kScreenWidth, bannerVo.height/375*320);
            self.headerImageView.frame = CGRectMake(12, 7, kScreenWidth-24, bannerVo.height/375*320-13);
            self.headerLineView.frame = CGRectMake(0, bannerVo.height/375*320-1, kScreenWidth, 1);
            weakSelf.tableView.tableHeaderView = weakSelf.promptHeaderView;
            [weakSelf.headerImageView setImageWithURL:bannerVo.image_url placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
            weakSelf.headerImageView.handleSingleTapDetected = ^(XMWebImageView *view, UITouch *touch){
                [URLScheme locateWithRedirectUri:bannerVo.redirect_uri andIsShare:YES];
            };
            
        } failure:^(XMError *error) {
            weakSelf.promptHeaderView.frame = CGRectMake(0, 0, kScreenWidth, 0.01);
            weakSelf.tableView.tableHeaderView = weakSelf.promptHeaderView;
        } queue:nil]];
    }
    
    
    if ([weakSelf.dataSources count]>0) {
        weakSelf.loadingView.hidden = YES;
        [weakSelf showProcessingHUD:nil];
    } else {
        weakSelf.loadingView.hidden = NO;
        [weakSelf.loadingView showLoadingView];
    }
    
    [_request cancel];
    _request = nil;
    _request = [[NetworkAPI sharedInstance] getFilterInfoList:[keywords URLEncodedString] params:params sellerId:sellerId completion:^(NSInteger totalNum, NSString *queryKey, NSString *standardWords, NSArray *filterInfoDictArray,long long timestamp) {
        
        weakSelf.timestamp = timestamp;
        
        NSArray *originFilterInfos = nil;//[weakSelf.topNewView filterInfos];//[weakSelf.filterTopView filterInfos];
        NSMutableArray *filterInfos = [[NSMutableArray alloc] initWithCapacity:filterInfoDictArray.count];
        for (NSDictionary *dict in filterInfoDictArray) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                [filterInfos addObject:[weakSelf mergeFilterInfoState:[SearchFilterInfo createWithDict:dict] fromFilterInfos:originFilterInfos]];
            }
        }
        
        if ([filterInfos count]==0) {
            filterInfos = [NSMutableArray arrayWithArray:originFilterInfos];
        }
        
        // 只使用一次
        if ([weakSelf.queryKey length]>0 && weakSelf.filterItem) {
            for (SearchFilterInfo *filterInfo in filterInfos) {
                if (filterInfo.type == 0 && [filterInfo.queryKey isEqualToString:weakSelf.queryKey]) {
                    for (SearchFilterItem *item in filterInfo.items) {
                        if ([item isKindOfClass:[SearchFilterItem class]]
                            && [item.queryValue isEqualToString:weakSelf.filterItem.queryValue]) {
                            item.isYesSelected = YES;
                            break;
                        }
                    }
                    break;
                }
                else if (filterInfo.type==1) {
                    for (SearchFilterInfo *filterInfo2 in filterInfo.items) {
                        if ([filterInfo2 isKindOfClass:[SearchFilterInfo class]]) {
                            if (filterInfo2.type == 0 && [filterInfo2.queryKey isEqualToString:weakSelf.queryKey]) {
                                for (SearchFilterItem *item2 in filterInfo2.items) {
                                    if ([item2 isKindOfClass:[SearchFilterItem class]]
                                        && [item2.queryValue isEqualToString:weakSelf.filterItem.queryValue]) {
                                        item2.isYesSelected = YES;
                                        break;
                                    }
                                }
                                break;
                            }
                        }
                    }
                }
            }
        }
        weakSelf.queryKey = nil;
        weakSelf.filterItem = nil;
        
        // 只使用一次
        if ([weakSelf.queryKVItemsArray count]>0) {
            for (SearchFilterInfo *filterInfo in filterInfos) {
                if (filterInfo.type == 0) {
                    for (SearchFilterKV *filterKV in weakSelf.queryKVItemsArray) {
                        if ([filterInfo.queryKey isEqualToString:filterKV.qk]) {
                            for (SearchFilterItem *item in filterInfo.items) {
                                if ([item isKindOfClass:[SearchFilterItem class]]
                                    && [item.queryValue isEqualToString:filterKV.qv]) {
                                    item.isYesSelected = YES;
                                    break;
                                }
                            }
                            break;
                        }
                    }
                }
                else if (filterInfo.type==1) {
                    for (SearchFilterInfo *filterInfo2 in filterInfo.items) {
                        if ([filterInfo2 isKindOfClass:[SearchFilterInfo class]]) {
                            if (filterInfo2.type == 0) {
                                for (SearchFilterKV *filterKV in weakSelf.queryKVItemsArray) {
                                    if ([filterInfo2.queryKey isEqualToString:filterKV.qk]) {
                                        for (SearchFilterItem *item2 in filterInfo2.items) {
                                            if ([item2 isKindOfClass:[SearchFilterItem class]]
                                                && [item2.queryValue isEqualToString:filterKV.qv]) {
                                                item2.isYesSelected = YES;
                                                break;
                                            }
                                        }
                                        break;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        weakSelf.queryKVItemsArray = nil;
        
        weakSelf.totalNum = totalNum;
        
        if ([queryKey length]>0 && [standardWords length]>0 && !weakSelf.isCancelCurFilter) {
            for (SearchFilterInfo *filterInfo in filterInfos) {
                if (filterInfo.type == 0 && [filterInfo.queryKey isEqualToString:queryKey]) {
                    for (SearchFilterItem *item in filterInfo.items) {
                        if ([item isKindOfClass:[SearchFilterItem class]]
                            && [item.queryValue isEqualToString:standardWords]) {
                            item.isYesSelected = YES;
                            break;
                        }
                    }
                    break;
                }
            }
        }
        
        
        if ([filterInfos count]>0) {
            [weakSelf.topNewView updateByFilterInfos:filterInfos];
            weakSelf.topNewView.hidden = NO;
            //在这里调整tableview的大小
            weakSelf.tableView.frame = CGRectMake(0, 0, weakSelf.contentView.width, weakSelf.contentView.height);//CGRectMake(0, weakSelf.filterTopView.height,weakSelf.contentView.width, weakSelf.contentView.height-weakSelf.filterTopView.height);
        } else {
            weakSelf.topNewView.hidden = YES;
            weakSelf.filterContainerView.hidden = YES;
            weakSelf.tableView.frame = CGRectMake(0, 0, weakSelf.contentView.width, weakSelf.contentView.height);
        }
        
        weakSelf.loadingView.frame = weakSelf.tableView.frame;
        
        [weakSelf doSearch:keywords params:params timestamp:timestamp];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.view];
        weakSelf.loadingView.hidden = YES;
    }];
}

- (void)doSearch:(NSString*)keywords params:(NSString*)params timestamp:(long long)timestamp
{
    WEAKSELF;
    //NSInteger requireFilter = 1;
    
    
    
    [weakSelf.view addSubview:self.guanjiaView];
    weakSelf.guanjiaView.hidden = YES;
    _dataListLogic = nil;
    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"search" path:@"list" pageSize:16 fetchSize:32];
    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
    _dataListLogic.parameters = @{@"keywords":keywords?[keywords URLEncodedString]:@"",
                                  @"params":params?params:@"",
                                  @"seller_id":[NSNumber numberWithInteger:self.sellerId],
                                  @"timestamp":[NSNumber numberWithLongLong:timestamp]};
    
    // @"require_filter":[NSNumber numberWithInteger:requireFilter]
    
    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
    };
    
    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
        
        [weakSelf hideHUD];
        weakSelf.guanjiaView.hidden = YES;
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
        
        [weakSelf.loadingView hideLoadingView];
        weakSelf.loadingView.hidden = YES;
        weakSelf.admAdvise.hidden = YES;
        weakSelf.searchHistoryView.hidden = YES;
        weakSelf.tableView.hidden = NO;
        weakSelf.adviserImg.hidden = NO;
        
        [weakSelf.goodsArrayList removeAllObjects];
        [weakSelf.dataSources removeAllObjects];
        NSLog(@"addedItems.count == %lu",(unsigned long)addedItems.count);
        //        if (weakSelf.totalNum>0) {
        //            [weakSelf.dataSources addObject:[SearchTableTotalNumViewCell buildCellDict:weakSelf.totalNum keywords:weakSelf.keywords isForSeller:weakSelf.sellerId>0?YES:NO]];
        ////            [weakSelf.dataSources addObject:[SearchRecommendButlerCell buildCellDict]];
        //        }
        
        for (NSInteger i=0;i<[addedItems count];i+=2) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            RecommendGoodsInfo *info = [RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]];
            
            if (info.listType == 1) {
                [weakSelf.goodsArrayList addObject:info];
//                break;
            }else{
                [array addObject:info];
            }
            
            
            if (i+1>=[addedItems count]) {
                [weakSelf.goodsArrayList addObject:array];
                break;
            }
            
             RecommendGoodsInfo *info2 = [RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]];
            if (info2.listType == 1) {
                [weakSelf.goodsArrayList addObject:info2];
                //                break;
            }else{
                [array addObject:info2];
            }
            
            [weakSelf.goodsArrayList addObject:array];
        }
        RecommendGoodsInfo *info = nil;
        for (NSInteger i=0;i<[weakSelf.goodsArrayList count];i++) {
            
            if ([[weakSelf.goodsArrayList objectAtIndex:i] isKindOfClass:[RecommendGoodsInfo class]]) {
                info = [weakSelf.goodsArrayList objectAtIndex:i];
//                break;
            }else{
                if ([weakSelf.dataSources count]>0) {
                    [weakSelf.dataSources addObject:[SearchTableSepViewCell buildCellDict]];
                }
                NSArray *array = [weakSelf.goodsArrayList objectAtIndex:i];
                [weakSelf.dataSources addObject:[RecommendGoodsCellSearch buildCellDict:array]];
            }
        }
        if (info) {
            [weakSelf.dataSources addObject:[IdleBannerTableViewCell buildCellDict:info.recommendVo]];
        }
        [weakSelf.dataSources insertObject:[SearchTableSepViewCell buildCellDict] atIndex:0];
        if (loadFinished) {
            [weakSelf.dataSources addObject:[SearchTableSepViewCell buildCellDict]];
        }
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView scrollViewToTop:YES];
    };
    
    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = YES;
    };
    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
        
        [weakSelf hideHUD];
        
        [weakSelf.loadingView hideLoadingView];
        weakSelf.loadingView.hidden = YES;
        weakSelf.admAdvise.hidden = YES;
        BOOL ignoreCount = 0;
        if ([addedItems count]>0) {
            NSMutableArray *array = nil;
            if ([weakSelf.goodsArrayList count]>0) {
                array = [weakSelf.goodsArrayList objectAtIndex:[weakSelf.goodsArrayList count]-1];
            }
            if ([[weakSelf.goodsArrayList objectAtIndex:[weakSelf.goodsArrayList count]-1] isKindOfClass:[NSMutableArray class]]) {
                if (array && [array count]==1) {
                    [array addObject: [RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:0]]];
                    ignoreCount = 1;
                }
            }
            
        }
        
        NSMutableArray *addedGoodsArrayList = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[addedItems count]-ignoreCount;i+=2) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            RecommendGoodsInfo *info = [RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i]];
            
            if (info.listType == 1) {
                [addedGoodsArrayList addObject:info];
                break;
            }
            [array addObject:info];
            if (i+1>=[addedItems count]-ignoreCount) {
                //                [weakSelf.goodsArrayList addObject:array];
                [addedGoodsArrayList addObject:array];
                break;
            }
            [array addObject:[RecommendGoodsInfo createWithDict:[addedItems objectAtIndex:i+1]]];
            //[weakSelf.goodsArrayList addObject:array];
            [addedGoodsArrayList addObject:array];
        }
        
        [weakSelf.goodsArrayList addObjectsFromArray:addedGoodsArrayList];
        
        for (NSInteger i=0;i<[addedGoodsArrayList count];i++) {
            
            if ([[addedGoodsArrayList objectAtIndex:i] isKindOfClass:[RecommendGoodsInfo class]]) {
                RecommendGoodsInfo *info = [addedGoodsArrayList objectAtIndex:i];
                [weakSelf.dataSources addObject:[IdleBannerTableViewCell buildCellDict:info.recommendVo]];//[SeekToPurchaseCell buildCellDict]];
                break;
            }
            
            if ([weakSelf.dataSources count]>0) {
                [weakSelf.dataSources addObject:[SearchTableSepViewCell buildCellDict]];
            }
            NSArray *array = [addedGoodsArrayList objectAtIndex:i];
            [weakSelf.dataSources addObject:[RecommendGoodsCellSearch buildCellDict:array]];
        }
        if (loadFinished) {
            [weakSelf.dataSources addObject:[SearchTableSepViewCell buildCellDict]];
        }
        
        [weakSelf.tableView reloadData];
        
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
        weakSelf.tableView.autoTriggerLoadMore = YES;
    };
    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadingMore = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        
        if ([weakSelf.dataSources count]==0) {
            weakSelf.loadingView.hidden = NO;
            [weakSelf.loadingView loadEndWithError:nil];
            weakSelf.loadingView.handleRetryBtnClicked = ^(LoadingView *view) {
                [weakSelf doSearch:keywords params:params timestamp:weakSelf.timestamp];
            };
        }
        
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f forView:weakSelf.view];
    };
    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
        [weakSelf hideHUD];
        weakSelf.guanjiaView.hidden = YES;
        weakSelf.tableView.pullTableIsRefreshing = NO;
        weakSelf.tableView.pullTableIsLoadFinish = NO;
        weakSelf.tableView.autoTriggerLoadMore = NO;
        
        [weakSelf.loadingView hideLoadingView];
        weakSelf.loadingView.hidden = YES;
        
        weakSelf.searchHistoryView.hidden = YES;
        weakSelf.tableView.hidden = NO;
        
        [weakSelf.goodsArrayList removeAllObjects];
        [weakSelf.dataSources removeAllObjects];
        
        //        if (weakSelf.isForSelected && weakSelf.sellerId>0) {
        //            [weakSelf.loadingView loadEndWithNoContent:@"暂无商品" image:[UIImage imageNamed:@"no_content_icon.png"] withRetryButton:NO];
        //        } else {
        //            [weakSelf.loadingView loadEndWithNoContent:@"无搜索结果" image:[UIImage imageNamed:@"no_content_icon.png"] withRetryButton:NO];
        //        }
        
        [weakSelf.dataSources addObject:[SearchRecommendButlerCell buildCellDict]];
        [weakSelf.tableView reloadData];
        weakSelf.admAdvise.hidden = NO;
        weakSelf.admAdvise.searchKey = keywords;
    };
    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
        
    };
    [_dataListLogic reloadDataListByForce];
}

//- (void)doSearch:(NSString*)keywords
//{
//    [DataLoadingView showLoadingView:self.contentView];
//
//    WEAKSELF;
//    _dataListLogic = [[DataListLogic alloc] initWithModulePath:@"search" path:@"search_goods" pageSize:10];
//    _dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
//    _dataListLogic.parameters = @{@"keywords":keywords?keywords:@""};
//    _dataListLogic.dataListLogicStartRefreshList = ^(DataListLogic *dataListLogic) {
//        weakSelf.tableView.pullTableIsRefreshing = YES;
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//    };
//    _dataListLogic.dataListLogicDidRefresh = ^(DataListLogic *dataListLogic, BOOL needReloadList, const NSArray* addedItems, BOOL loadFinished) {
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
//
//        [DataLoadingView hideLoadingView:weakSelf.contentView];
//        weakSelf.searchHistoryView.hidden = YES;
//        weakSelf.tableView.hidden = NO;
//
//        if (needReloadList) {
//            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
//            for (int i=0;i<[addedItems count];i++) {
//                if (i>0) {
//                    [newList addObject:[SepTableViewCell buildCellDict]];
//                }
//
//                BOOL isDataChanged = NO;
//                SearchResultItem *resultItem = [SearchResultItem createWithDict:[addedItems objectAtIndex:i]];
//                if (resultItem.type==0) {
//                    GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:(GoodsInfo*)resultItem.item isDataChanged:&isDataChanged];
//                    [newList addObject:[GoodsTableViewCell buildCellDict:goodsInfo]];
//                }
//            }
//            weakSelf.dataSources = newList;
//            [weakSelf.tableView reloadData];
//        } else {
//            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
//            for (int i=0;i<[addedItems count];i++) {
//                if (i>0) {
//                    [newList addObject:[SepTableViewCell buildCellDict]];
//                }
//
//                BOOL isDataChanged = NO;
//                SearchResultItem *resultItem = [SearchResultItem createWithDict:[addedItems objectAtIndex:i]];
//                if (resultItem.type==0) {
//                    GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:(GoodsInfo*)resultItem.item isDataChanged:&isDataChanged];
//                    [newList addObject:[GoodsTableViewCell buildCellDict:goodsInfo]];
//                }
//            }
//
//            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
//            if ([dataSources count]>0 && [newList count]>0) {
//                [newList addObject:[SepTableViewCell buildCellDict]];
//            }
//            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[newList count]];
//            for (int i=0;i<[newList count];i++) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                [indexPaths addObject:indexPath];
//                [dataSources insertObject:[newList objectAtIndex:i] atIndex:i];
//            }
//
//            weakSelf.dataSources = dataSources;
//            [weakSelf.tableView beginUpdates];
//            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf.tableView endUpdates];
//        }
//    };
//    _dataListLogic.dataListLogicStartLoadMore = ^(DataListLogic *dataListLogic) {
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = YES;
//    };
//    _dataListLogic.dataListLogicDidDataReceived = ^(DataListLogic *dataListLogic, const NSArray *addedItems, BOOL loadFinished) {
//
//        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[addedItems count]];
//        for (int i=0;i<[addedItems count];i++) {
//            BOOL isDataChanged = NO;
//            SearchResultItem *resultItem = [SearchResultItem createWithDict:[addedItems objectAtIndex:i]];
//            if (resultItem.type==0) {
//                if ([newList count]>0) {
//                    [newList addObject:[SepTableViewCell buildCellDict]];
//                }
//                GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:(GoodsInfo*)resultItem.item isDataChanged:&isDataChanged];
//                [newList addObject:[GoodsTableViewCell buildCellDict:goodsInfo]];
//            }
//        }
//        if ([newList count]>0) {
//            NSInteger count = [weakSelf.dataSources count];
//            NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
//            if ([dataSources count]>0) {
//                [newList insertObject:[SepTableViewCell buildCellDict] atIndex:0];
//            }
//            [dataSources addObjectsFromArray:newList];
//
//
//            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:[newList count]];
//            for (int i=0;i<[newList count];i++) {
//                NSInteger index = count+i;
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
//                [indexPaths addObject:indexPath];
//            }
//
//            weakSelf.dataSources = dataSources;
//            [weakSelf.tableView beginUpdates];
//            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
//            [weakSelf.tableView endUpdates];
//        }
//
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = loadFinished;
//    };
//    _dataListLogic.dataListLogicDidErrorOcurred = ^(DataListLogic *dataListLogic, XMError *error) {
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//
//        [DataLoadingView loadEndWithFailed:weakSelf.contentView].handleRetryBtnClicked = ^(DataLoadingView *view) {
//            [weakSelf doSearch:keywords];
//        };
//
//        [weakSelf showHUD:[error errorMsg] hideAfterDelay:1.2f forView:weakSelf.view];
//    };
//    _dataListLogic.dataListLoadFinishWithNoContent = ^(DataListLogic *dataListLogic) {
//        [weakSelf.dataSources removeAllObjects];
//        [weakSelf.tableView reloadData];
//        weakSelf.tableView.pullTableIsRefreshing = NO;
//        weakSelf.tableView.pullTableIsLoadingMore = NO;
//        weakSelf.tableView.pullTableIsLoadFinish = YES;
//
//        [DataLoadingView loadEndWithNoContent:weakSelf.contentView];
//
//    };
//    _dataListLogic.dataListLogicDidCancel = ^(DataListLogic *dataListLogic) {
//
//    };
//    [_dataListLogic reloadDataListByForce];
//}

#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar becomeFirstResponder];
    _searchHistoryView.hidden = NO;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    //self.keywords = [searchBar.text trim];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    _searchHistoryView.hidden = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.timer setFireDate:[NSDate distantFuture]];
    NSString *keywords = [searchBar.text trim];
    if ([keywords length]>0) {
        [searchBar resignFirstResponder];
        _searchHistoryView.hidden = YES;
        _keyworldAssociate.hidden = YES;
        self.isCancelCurFilter = NO;
        if (![keywords isEqualToString:self.keywords]) {
            self.filterContainerView.hidden = YES;
        }
        [self doSearch:keywords type:_searchBarView.currentSearchType];
    }else{
        [self doSearch:_mapText?_mapText:@"" type:_searchBarView.currentSearchType];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    self.timerIndex = 0;
    self.changeSearchText = searchText;
    [self.timer setFireDate:[NSDate distantFuture]];
    if (self.searchBarView.currentSearchType == kSearchTypeGoods) {
        if (searchText.length > 0) {
            [self.timer setFireDate:[NSDate distantPast]];
            
            [self.view bringSubviewToFront:_keyworldAssociate];
        }else{
            _keyworldAssociate.hidden = YES;
        }
    }
}

-(void)searchThink{
    if (self.timerIndex == 0) {
        self.timerIndex = 1;
        return;
    }
    
    NSDictionary * parm = @{@"keyword":self.changeSearchText};
    [self showProcessingHUD:nil];
    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"search" path:@"suggest" parameters:parm completionBlock:^(NSDictionary *data) {
        self.timerIndex = 0;
        [self.timer setFireDate:[NSDate distantFuture]];
        [self hideHUD];
        _keyworldAssociate.hidden = NO;
        NSArray * keyworldsArr = data[@"result"];
        [_keyworldAssociate getKeyworldsArr:keyworldsArr keyworlds:self.changeSearchText];
        
    } failure:^(XMError *error) {
        self.timerIndex = 0;
        [self.timer setFireDate:[NSDate distantFuture]];
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    } queue:nil]];
}

-(void)doSearchWithKeyworlds:(NSString *)keyworlds
{
    
    NSString *keywords = [keyworlds trim];
    if ([keywords length]>0) {
        _searchHistoryView.hidden = YES;
        _keyworldAssociate.hidden = YES;
        self.isCancelCurFilter = NO;
        if (![keywords isEqualToString:self.keywords]) {
            self.filterContainerView.hidden = YES;
        }
        [self doSearch:keywords type:_searchBarView.currentSearchType];
    }
}

-(void)keybordResignFirstResponder
{
    [self.searchBarView resignFirstResponder];
}

- (void)$$handleGoodsInfoUpdated:(id<MBNotification>)notifi goodsInfo:(GoodsInfo*)goodsInfo
{
    BOOL isNeedReload = NO;
    for (NSDictionary *dict in self.dataSources) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            NSArray *recommendGoodsInfoArray = [dict objectForKey:[RecommendGoodsCellSearch cellKeyForGoodsInfoArray]];
            for (RecommendGoodsInfo *recommendGoodsInfo in recommendGoodsInfoArray) {
                
                if ([recommendGoodsInfo isKindOfClass:[RecommendGoodsInfo class]]
                    && [recommendGoodsInfo.goodsId isEqualToString:goodsInfo.goodsId]) {
                    
                    if ([recommendGoodsInfo updateWithGoodsInfo:goodsInfo]) {
                        isNeedReload = YES;
                    }
                }
            }
        }
    }
    if (isNeedReload) {
        [self.tableView reloadData];
    }
}

- (void)$$handleGoodsStatusUpdated:(id<MBNotification>)notifi goodStatusArray:(NSArray*)goodStatusArray
{
    BOOL isNeedReload = NO;
    
    for (GoodsStatusDO *statusDO in goodStatusArray) {
        
        for (NSDictionary *dict in self.dataSources) {
            if ([dict isKindOfClass:[NSDictionary class]]) {
                NSArray *recommendGoodsInfoArray = [dict objectForKey:[RecommendGoodsCellSearch cellKeyForGoodsInfoArray]];
                for (RecommendGoodsInfo *recommendGoodsInfo in recommendGoodsInfoArray) {
                    
                    if ([recommendGoodsInfo isKindOfClass:[RecommendGoodsInfo class]]
                        && [recommendGoodsInfo.goodsId isEqualToString:statusDO.goodsId]) {
                        if ([recommendGoodsInfo updateWithStatusInfo:statusDO]) {
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


@class SearchPromptingView;
@protocol SearchPromptingViewDelegate <NSObject>
- (void)searchPromptingViewCanceled:(SearchPromptingView*)view;
- (void)searchPromptingViewClearHistory:(SearchPromptingView*)view;
- (void)searchPromptingViewDoSearch:(SearchPromptingView*)view keywords:(NSString*)keywords;
@end

@interface SearchPromptingView : UIScrollView <UIGestureRecognizerDelegate>
@property(nonatomic,assign) id<SearchPromptingViewDelegate> myDelegate;
@property(nonatomic,strong) NSArray *historyItems;
@property(nonatomic,strong) NSArray *hotItems;
@end

@implementation SearchPromptingView {
    UILabel *_historyLbl;
    CommandButton *_clearHistoryBtn;
    UIView *_historyView;
    UILabel *_hotWordsLbl;//
    UIView *_hotWordsView;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel:)];
        tapGesture.delegate = self;
        [self addGestureRecognizer:tapGesture];
        
        _historyLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _historyLbl.font = [UIFont boldSystemFontOfSize:20];
        _historyLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _historyLbl.text = @"最近搜索";
        _historyLbl.hidden = YES;
        [self addSubview:_historyLbl];
        
        _clearHistoryBtn = [[CommandButton alloc] initWithFrame:CGRectZero];
        _clearHistoryBtn.backgroundColor = [UIColor clearColor];
        _clearHistoryBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        _clearHistoryBtn.hidden = YES;
        _clearHistoryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        //        [_clearHistoryBtn setTitleColor:[UIColor colorWithHexString:@"ac7e33"] forState:UIControlStateNormal];
        //        [_clearHistoryBtn setTitle:@"清除历史" forState:UIControlStateNormal];
        [_clearHistoryBtn setImage:[UIImage imageNamed:@"Search_Delet_New"] forState:UIControlStateNormal];
        [self addSubview:_clearHistoryBtn];
        
        _historyView = [[UIView alloc] initWithFrame:CGRectZero];
        _historyView.backgroundColor = [UIColor clearColor];
        _historyView.hidden = YES;
        [self addSubview:_historyView];
        
        _hotWordsLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _hotWordsLbl.font = [UIFont boldSystemFontOfSize:20];
        _hotWordsLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
        _hotWordsLbl.text = @"热门搜索";
        _hotWordsLbl.hidden = YES;
        [self addSubview:_hotWordsLbl];
        
        _hotWordsView = [[UIView alloc] initWithFrame:CGRectZero];
        _hotWordsView.backgroundColor = [UIColor clearColor];
        _hotWordsView.hidden = YES;
        [self addSubview:_hotWordsView];
        
        WEAKSELF;
        _clearHistoryBtn.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.myDelegate && [weakSelf.myDelegate respondsToSelector:@selector(searchPromptingViewClearHistory:)]) {
                [weakSelf.myDelegate searchPromptingViewClearHistory:weakSelf];
            }
        };
    }
    return self;
}

- (void)dealloc
{
    _historyItems = nil;
    _hotItems = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat marginTop = 0.f;
    
    
    if (![_hotWordsLbl isHidden] && ![_hotWordsView isHidden]) {
        
        marginTop += 15.f;
        
        _hotWordsLbl.frame = CGRectMake(15, marginTop, kScreenWidth, 0);
        [_hotWordsLbl sizeToFit];
        _hotWordsLbl.frame = CGRectMake(15, marginTop, _hotWordsLbl.width, _hotWordsLbl.height);
        
        marginTop += _hotWordsLbl.height;
        marginTop += 12;
        
        /*
         *button自适应文字大小布局
         CGFloat btnHeight = 27;
         CGFloat X = 15.f;
         CGFloat Y = 0;
         NSArray *subviews = [_hotWordsView subviews];
         _hotWordsView.backgroundColor = [UIColor orangeColor];
         NSInteger lineNums = 0;
         for (CommandButton *btn in subviews) {
         btn.frame = CGRectMake(X, Y, kScreenWidth-30, btnHeight);
         [btn sizeToFit];
         CGFloat btnWidth = btn.width+20;
         if (btnWidth>kScreenWidth-30) {
         btnWidth = kScreenWidth-30;
         }
         if (X+btnWidth+15>kScreenWidth) {
         if (++lineNums>=4) {
         break;
         }
         Y += btnHeight;
         Y += 10;
         X = 15.f;
         }
         btn.hidden = NO;
         btn.frame = CGRectMake(X, Y, btnWidth, btnHeight);
         X += btnWidth;
         X += 10;
         }
         Y += btnHeight;
         
         _hotWordsView.frame = CGRectMake(0, marginTop, self.width, Y);
         marginTop += _hotWordsView.height;
         */
        
        
        
        
        CGFloat btnHeight = 30;
        CGFloat hotWordsViewHeight = 0;
        CGFloat marginLeft = 20;
        NSArray *subviews = [_hotWordsView subviews];
        for (int i = 0; i < subviews.count; i++) {
            CommandButton *btn = (CommandButton *)[subviews objectAtIndex:i];
            btn.frame = CGRectMake(0, 0, kScreenWidth-30, btnHeight);
            [btn sizeToFit];
            CGFloat btnWidth = kScreenWidth/375*98;
            btn.hidden = NO;
            btn.frame = CGRectMake(marginLeft+i%3*(btnWidth+24), i/3*(btnHeight+18), btnWidth, btnHeight);
        }
        NSInteger row = 0;
        NSInteger count = subviews.count;
        if (count > 3*(count/3)) {
            row = count/3+1;
        }else{
            row = count/3;
        }
        hotWordsViewHeight += row*(btnHeight+18);
        _hotWordsView.frame = CGRectMake(0, marginTop, self.width, hotWordsViewHeight);
        marginTop += _hotWordsView.height;
    }
    
    
    
    if (![_historyLbl isHidden] && ![_clearHistoryBtn isHidden] && ![_historyView isHidden])
    {
        marginTop += 15.f;
        
        _historyLbl.frame = CGRectMake(15, marginTop, kScreenWidth, 0);
        [_historyLbl sizeToFit];
        _historyLbl.frame = CGRectMake(15, marginTop, _historyLbl.width, _historyLbl.height);
        
        _clearHistoryBtn.frame = CGRectMake(15, marginTop, kScreenWidth, 0);
        [_clearHistoryBtn sizeToFit];
        _clearHistoryBtn.frame = CGRectMake(self.width-15-_clearHistoryBtn.width, marginTop, _clearHistoryBtn.width, _historyLbl.height);
        
        marginTop += _historyLbl.height;
        marginTop += 20;
        
        _historyView.frame = CGRectMake(0, marginTop, self.width, 0);
        
        
        /*
         *button自适应文字大小布局
         CGFloat btnHeight = 27;
         CGFloat X = 15.f;
         CGFloat Y = 0;
         NSArray *subviews = [_historyView subviews];
         _historyView.backgroundColor = [DataSources colorf9384c];
         NSInteger lineNums = 0;
         for (CommandButton *btn in subviews) {
         btn.frame = CGRectMake(X, Y, kScreenWidth-30, btnHeight);
         [btn sizeToFit];
         CGFloat btnWidth = btn.width+20;
         if (btnWidth>kScreenWidth-30) {
         btnWidth = kScreenWidth-30;
         }
         if (X+btnWidth+15>kScreenWidth) {
         if (++lineNums>=4) {
         break;
         }
         Y += btnHeight;
         Y += 10;
         X = 15.f;
         }
         btn.hidden = NO;
         btn.frame = CGRectMake(X, Y, btnWidth, btnHeight);
         X += btnWidth;
         X += 10;
         }
         Y += btnHeight;
         
         _historyView.frame = CGRectMake(0, marginTop, self.width, Y);
         marginTop += _historyView.height;
         */
        
        CGFloat btnHeight = 50;
        CGFloat historyViewHeight = 0;
        CGFloat marginLeft = 20;
        NSArray *subviews = [_historyView subviews];
        for (int i = 0; i < subviews.count; i++) {
            CommandButton *btn = (CommandButton *)[subviews objectAtIndex:i];
            btn.frame = CGRectMake(marginLeft, i*btnHeight, kScreenWidth-40, btnHeight);
            btn.hidden = NO;
        }
        
        NSInteger row = 0;
        NSInteger count = subviews.count;
        row = count;
        historyViewHeight += row*btnHeight;
        _historyView.frame = CGRectMake(0, marginTop, self.width, historyViewHeight);
        marginTop += _historyView.height;
    }
    
    
    marginTop += 20.f;
    
    self.contentSize = CGSizeMake(self.width, marginTop);
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setHistoryItems:(NSArray *)historyItems {
    if (_historyItems!=historyItems) {
        _historyItems = historyItems;
        
        NSArray *subviews = [_historyView subviews];
        for (UIView *view in subviews) {
            [view removeFromSuperview];
        }
        for (NSString *keyword in historyItems) {
            if ([keyword isKindOfClass:[NSString class]]) {
                CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectZero];
                btn.hidden = YES;
                btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
                [btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
                [btn setTitle:keyword forState:UIControlStateNormal];
                btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                [_historyView addSubview:btn];
                
                WEAKSELF;
                btn.handleClickBlock = ^(CommandButton *sender) {
                    if (weakSelf.myDelegate && [weakSelf.myDelegate respondsToSelector:@selector(searchPromptingViewDoSearch:keywords:)]) {
                        [weakSelf.myDelegate searchPromptingViewDoSearch:weakSelf keywords:[sender titleForState:UIControlStateNormal]];
                        
                    }
                };
            }
        }
        
        if ([historyItems count]>0) {
            _historyLbl.hidden = NO;
            _clearHistoryBtn.hidden = NO;
            _historyView.hidden = NO;
        } else {
            _historyLbl.hidden = YES;
            _clearHistoryBtn.hidden = YES;
            _historyView.hidden = YES;
        }
        
        [self setNeedsLayout];
    }
}

- (void)setHotItems:(NSArray *)hotItems {
    if (_hotItems != hotItems) {
        _hotItems = hotItems;
        NSArray *subviews = [_hotWordsView subviews];
        for (UIView *view in subviews) {
            [view removeFromSuperview];
        }
        
        for (HotWord *hotWord in hotItems) {
            if ([hotWord isKindOfClass:[HotWord class]]) {
                CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectZero];
                btn.hidden = YES;
                btn.titleLabel.font = [UIFont systemFontOfSize:14.f];
                [btn setTitleColor:[UIColor colorWithHexString:@"1a1a1a"] forState:UIControlStateNormal];
                [btn setTitle:hotWord.keyword forState:UIControlStateNormal];
                btn.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
                [_hotWordsView addSubview:btn];
                
                WEAKSELF;
                btn.handleClickBlock = ^(CommandButton *sender) {
                    if (weakSelf.myDelegate && [weakSelf.myDelegate respondsToSelector:@selector(searchPromptingViewDoSearch:keywords:)]) {
                        [weakSelf.myDelegate searchPromptingViewDoSearch:weakSelf keywords:[sender titleForState:UIControlStateNormal]];
                    }
                };
            }
        }
        
        if ([hotItems count]>0) {
            _hotWordsLbl.hidden = NO;
            _hotWordsView.hidden = NO;
        } else {
            _hotWordsLbl.hidden = YES;
            _hotWordsView.hidden = YES;
        }
        [self setNeedsLayout];
    }
}

- (void)tappedCancel:(UIGestureRecognizer*)gesture
{
    if (_myDelegate && [_myDelegate respondsToSelector:@selector(searchPromptingViewCanceled:)]) {
        [_myDelegate searchPromptingViewCanceled:self];
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

@end


@interface SearchBarCombListItem : NSObject
@property(nonatomic,assign) NSInteger type;
@property(nonatomic,assign) BOOL isSelected;
@property(nonatomic,copy) NSString *title;
+ (SearchBarCombListItem*)allocCombListItem:(NSInteger)itemId title:(NSString*)title isSelected:(BOOL)isSelected;
@end

@implementation SearchBarCombListItem

- (id)init {
    self = [super init];
    if (self) {
        _type = -1;
        _isSelected = NO;
    }
    return self;
}

+ (SearchBarCombListItem*)allocCombListItem:(NSInteger)type title:(NSString*)title isSelected:(BOOL)isSelected {
    SearchBarCombListItem *item = [[SearchBarCombListItem alloc] init];
    item.type = type;
    item.title = title;
    item.isSelected = isSelected;
    return item;
}
@end


@interface SearchBarCommandButton : CommandButton
@end
@implementation SearchBarCommandButton
@end

@class SearchBarCombListView;
@protocol SearchBarCombListViewDelegate <NSObject>
@optional
- (void)searchBarCombList:(SearchBarCombListView*)view selectedListItem:(SearchBarCombListItem*)item;
@end

@interface SearchBarCombListView : UIImageView

@property(nonatomic,assign) id<SearchBarCombListViewDelegate> delegate;
@property(nonatomic,strong) NSArray *combListItems;

@end

@implementation SearchBarCombListView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        UIImage *bg = [UIImage imageNamed:@"searchbar_dropdown_bg"];
        
        self.image = [bg stretchableImageWithLeftCapWidth:bg.size.width/2 topCapHeight:bg.size.height/2];
    }
    return self;
}

- (void)setCombListItems:(NSArray *)combListItems {
    if (_combListItems!=combListItems) {
        _combListItems = combListItems;
        
        NSArray *subviews = [self subviews];
        for (UIView *view in subviews) {
            [view removeFromSuperview];
        }
        
        WEAKSELF;
        for (NSInteger i=0;i<_combListItems.count;i++) {
            SearchBarCombListItem *item  = [_combListItems objectAtIndex:i];
            if ([item isKindOfClass:[SearchBarCombListItem class]]) {
                //if (!item.isSelected)
                {
                    SearchBarCommandButton *btn = [[SearchBarCommandButton alloc] initWithFrame:CGRectZero];
                    [btn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
                    [btn setTitle:item.title forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont systemFontOfSize:12.f];
                    btn.tag = i;
                    [self addSubview:btn];
                    btn.handleClickBlock = ^(CommandButton *sender) {
                        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(searchBarCombList:selectedListItem:)]) {
                            if (sender.tag < weakSelf.combListItems.count) {
                                SearchBarCombListItem *clickedItem = [weakSelf.combListItems objectAtIndex:sender.tag];
                                for (SearchBarCombListItem *tmpItem in weakSelf.combListItems) {
                                    tmpItem.isSelected = NO;
                                }
                                clickedItem.isSelected = YES;
                                [weakSelf.delegate searchBarCombList:weakSelf selectedListItem:[weakSelf.combListItems objectAtIndex:sender.tag]];
                            }
                        }
                    };
                }
            }
        }
        [self setNeedsLayout];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat Y = 8.f;
    NSArray *subviews = [self subviews];
    for (UIView *view in subviews) {
        view.frame = CGRectMake(0, Y, self.width, 32);
        Y += view.height;
    }
}

@end

@class SearchBarCombBox;
@protocol SearchBarCombBoxDelegate <NSObject>
@optional
- (void)searchBarCombBoxSelectChanged:(SearchBarCombBox*)combBox;
@end

@interface SearchBarCombBox : CommandButton <SearchBarCombListViewDelegate>
@property(nonatomic,assign) id<SearchBarCombBoxDelegate> delegate;
@property(nonatomic,strong) NSArray *combListItems;
- (NSInteger)currentSelectedType;
@end

@implementation SearchBarCombBox {
    SearchBarCombListView *_listView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImage *dropDownImg = [UIImage imageNamed:@"searchbar_dropdown"];
        [self setImage:dropDownImg forState:UIControlStateNormal];
        
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel.font = [UIFont systemFontOfSize:12.f];
        [self setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
        if ([self.combListItems count]>0) {
            SearchBarCombListItem *item = [self.combListItems objectAtIndex:0];
            [self setTitle:item.title forState:UIControlStateNormal];
        }
        
        WEAKSELF;
        self.handleClickBlock = ^(CommandButton *sender) {
            [weakSelf toggleListItemView];
        };
    }
    return self;
}

- (void)dealloc
{
    
}

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
}

- (NSInteger)currentSelectedType {
    for (SearchBarCombListItem *item in [self combListItems]) {
        if (item.isSelected) {
            return item.type;
        }
    }
    return kSearchTypeGoods;
}

- (void)setCurrentSelectedType:(NSInteger)type {
    for (SearchBarCombListItem *item in [self combListItems]) {
        if (item.type==type) {
            item.isSelected = YES;
            [self setTitle:item.title forState:UIControlStateNormal];
        }else {
            item.isSelected = NO;
        }
    }
}

- (NSArray*)combListItems {
    if (!_combListItems) {
        NSMutableArray *items = [[NSMutableArray alloc] init];
        [items addObject:[SearchBarCombListItem allocCombListItem:kSearchTypeGoods title:@"商品" isSelected:YES]];
        [items addObject:[SearchBarCombListItem allocCombListItem:kSearchTypeSeller title:@"卖家" isSelected:NO]];
        _combListItems = items;
    }
    return _combListItems;
}

- (void)toggleListItemView
{
    if (!_listView) {
        _listView = [[SearchBarCombListView alloc] initWithFrame:CGRectZero];
        _listView.backgroundColor = [UIColor clearColor];
        _listView.hidden = YES;
        _listView.delegate = self;
        _listView.combListItems = self.combListItems;
    }
    
    if ([_listView isHidden]) {
        [_listView removeFromSuperview];
        _listView.hidden = NO;
        UIViewController *viewController = [[self class] findViewController:self];
        [viewController.view addSubview:_listView];
        
        CGPoint pt = [viewController.view convertPoint:CGPointMake(self.left, self.bottom) fromView:self];
        _listView.frame = CGRectMake(pt.x, pt.y, 100, 75);
        [viewController.view addSubview:_listView];
    } else {
        [_listView removeFromSuperview];
        _listView = nil;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state {
    [super setTitle:title forState:state];
    
    CGSize size = [title sizeWithFont:[UIFont systemFontOfSize:12.f] constrainedToSize:CGSizeMake(kScreenWidth, 100)];
    UIImage *dropDownImg = [self imageForState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -dropDownImg.size.width-5, 0, 0)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, size.width+dropDownImg.size.width+10, 0, 0)];
}

- (void)searchBarCombList:(SearchBarCombListView*)view selectedListItem:(SearchBarCombListItem*)item
{
    [self setTitle:item.title forState:UIControlStateNormal];
    [_listView removeFromSuperview];
    _listView = nil;
    if (item.type == 0) {
        NSDictionary *data = @{@"type":@2};
        [ClientReportObject clientReportObjectWithViewCode:HomeSearchViewCode regionCode:SearchCutRegionCode referPageCode:NoReferPageCode andData:data];
    } else if (item.type == 1) {
        NSDictionary *data = @{@"type":@1};
        [ClientReportObject clientReportObjectWithViewCode:HomeSearchViewCode regionCode:SearchCutRegionCode referPageCode:NoReferPageCode andData:data];
    }
    if (_delegate && [_delegate respondsToSelector:@selector(searchBarCombBoxSelectChanged:)]) {
        [_delegate searchBarCombBoxSelectChanged:self];
    }
}

+ (UIViewController *)findViewController:(UIView *)sourceView
{
    id target=sourceView;
    while (target) {
        target = ((UIResponder *)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

- (void)toggleCombBox:(BOOL)isShow {
    if (isShow) {
        if (self.isHidden) {
            WEAKSELF;
            //            weakSelf.alpha = 0.3f;
            //            weakSelf.hidden = NO;
            //            [UIView animateWithDuration:0.3f animations:^{
            //                weakSelf.alpha = 1.0f;
            //            } completion:^(BOOL finished) {
            //                weakSelf.alpha = 1.0f;
            //            }];
            weakSelf.hidden = NO;
            weakSelf.alpha = 1.0f;
        }
    } else {
        WEAKSELF;
        //        [UIView animateWithDuration:0.3f animations:^{
        //            weakSelf.alpha = 0.3f;
        //        } completion:^(BOOL finished) {
        //            weakSelf.hidden = YES;
        //        }];
        weakSelf.alpha = 0.3f;
        weakSelf.hidden = YES;
        [_listView removeFromSuperview];
        _listView = nil;
    }
}

@end

@interface SearchBarView () <SearchPromptingViewDelegate,SearchBarCombBoxDelegate>
@property(nonatomic,strong) HTTPRequest *requestHotWords;
@property(nonatomic,strong) SearchPromptingView *promptingView;
@property(nonatomic,assign) id<UISearchBarDelegate> delegateProxy;

@property(nonatomic,assign) BOOL isShowClearButton;
@property(nonatomic,assign) BOOL isShowLeftCombBox;
@property(nonatomic,assign) BOOL isShowHotWords;

@property(nonatomic,strong) SearchBarCombBox *combBox;
@property(nonatomic,strong) UITextField *searchTextField;
@property(nonatomic,strong) UIImageView *leftView;

@end

@implementation SearchBarView  {
    //    SearchBarCombBox *_combBox;
    //    UITextField* _searchField;
    //    UIImageView *_leftView;
}

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    _requestHotWords = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setText:(NSString *)text {
    [super setText:text];
    
    if ([text length]>0) {
        [self setNeedsLayout];
        
        WEAKSELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            _searchTextField.leftView = nil;
            [_combBox toggleCombBox:YES];
            _combBox.hidden = NO;
            CGFloat marginLeft = _isShowLeftCombBox?53.f:0;
            CGRect searchFieldFrame = weakSelf.bounds;
            searchFieldFrame.origin.x = marginLeft;
            searchFieldFrame.size.width = searchFieldFrame.size.width-marginLeft;
            _searchTextField.frame = searchFieldFrame;
            [weakSelf setNeedsLayout];
        });
    }
}


- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame isShowClearButton:NO];
}

- (id)initWithFrame:(CGRect)frame isShowClearButton:(BOOL)isShowClearButton {
    return [self initWithFrame:frame isShowClearButton:isShowClearButton isShowLeftCombBox:YES];
}

- (id)initWithFrame:(CGRect)frame isShowClearButton:(BOOL)isShowClearButton isShowLeftCombBox:(BOOL)isShowLeftCombBox {
    return [self initWithFrame:frame isShowClearButton:isShowClearButton isShowLeftCombBox:isShowLeftCombBox isShowHotWords:YES];
}

- (id)initWithFrame:(CGRect)frame isShowClearButton:(BOOL)isShowClearButton isShowLeftCombBox:(BOOL)isShowLeftCombBox isShowHotWords:(BOOL)isShowHotWords {
    self = [super initWithFrame:frame];
    if (self) {
        _isShowLeftCombBox = isShowLeftCombBox;
        _isShowClearButton = isShowClearButton;
        _isShowHotWords = isShowHotWords;
        
        //        self.backgroundColor = [UIColor colorWithHexString:@"F7F7F7"];
        //        self.layer.masksToBounds = YES;
        //        self.layer.cornerRadius = 2.f;
        //
        //        UIImage * textFieldBg= [UIImage imageWithColor:[UIColor colorWithHexString:@"F7F7F7"]];
        //        [searchField setBackground:[textFieldBg stretchableImageWithLeftCapWidth:textFieldBg.size.width/2 topCapHeight:0]];
        //
        //
        //        // 替换UISearchBar键盘上的搜索按钮
        //        for (UIView *searchBarSubview in self.subviews) {
        //            if ([searchBarSubview conformsToProtocol:@protocol(UITextInputTraits)]) {
        //                [(UITextField *)searchBarSubview setReturnKeyType:UIReturnKeyDone];
        //                [(UITextField *)searchBarSubview setKeyboardAppearance:UIKeyboardAppearanceAlert];
        //                // always force return key to be enabled
        //                [(UITextField *)searchBarSubview setEnablesReturnKeyAutomatically:NO];
        //            }
        //        }
        
        for (UIView *view in self.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                [view removeFromSuperview];
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                NSArray *subviews = view.subviews;
                if ([subviews count]>0 && [[subviews objectAtIndex:0] isKindOfClass:NSClassFromString(@"UISearchBarBackground")] ) {
                    [[subviews objectAtIndex:0] removeFromSuperview];
                    break;
                }
            }
        }
        
        
        
        self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.85];//[UIColor colorWithHexString:@"F7F7F7"];
        
        if (_isShowLeftCombBox) {
            _combBox = [[SearchBarCombBox alloc] initWithFrame:CGRectZero];
            _combBox.delegate = self;
            _combBox.hidden = YES;
            [self addSubview:_combBox];
        }
        
        self.enablesReturnKeyAutomatically = NO;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
        // 键盘高度变化通知，ios5.0新增的
#ifdef __IPHONE_5_0
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 5.0) {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
        }
#endif
        //
        
    }
    return self;
}

- (void)keyboardWillShow:(NSNotification *)notification {
    
    /*
     Reduce the size of the text view so that it's not obscured by the keyboard.
     Animate the resize so that it's in sync with the appearance of the keyboard.
     */
    
    NSDictionary *userInfo = [notification userInfo];
    
    // Get the origin of the keyboard when it's displayed.
    NSValue* aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    // Get the top of the keyboard as the y coordinate of its origin in self's view's coordinate system. The bottom of the text view's frame should align with the top of the keyboard's final position.
    CGRect keyboardRect = [aValue CGRectValue];
    
    // Get the duration of the animation.
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    // Animate the resize of the text view's frame in sync with the keyboard's appearance.
    //[self moveInputBarWithKeyboardHeight:keyboardRect.size.height withDuration:animationDuration];
    
    if (_promptingView) {
        UIViewController *viewController = [SearchBarCombBox findViewController:self];
        if ([viewController isKindOfClass:[BaseViewController class]]) {
            BaseViewController *baseViewController = ((BaseViewController*)viewController);
            _promptingView.frame = CGRectMake(0, baseViewController.topBarHeight, kScreenWidth, kScreenHeight-baseViewController.topBarHeight-keyboardRect.size.height);
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
    NSDictionary* userInfo = [notification userInfo];
    
    /*
     Restore the size of the text view (fill self's view).
     Animate the resize so that it's in sync with the disappearance of the keyboard.
     */
    NSValue *animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval animationDuration;
    [animationDurationValue getValue:&animationDuration];
    
    //[self moveInputBarWithKeyboardHeight:0.0 withDuration:animationDuration];
    
    [self toggleWordsView:NO];
}

- (void)toggleWordsView:(BOOL)isShow {
    if (isShow) {
        if (!_promptingView) {
            _promptingView = [[SearchPromptingView alloc] initWithFrame:CGRectZero];
            _promptingView.backgroundColor = [UIColor whiteColor];
            _promptingView.hidden = YES;
            _promptingView.myDelegate = self;
            
            [_promptingView removeFromSuperview];
            UIViewController *viewController = [SearchBarCombBox findViewController:self];
            if ([viewController isKindOfClass:[BaseViewController class]]) {
                BaseViewController *baseViewController = ((BaseViewController*)viewController);
                _promptingView.hidden = NO;
                _promptingView.frame = CGRectMake(0, baseViewController.topBarHeight, kScreenWidth, kScreenHeight-baseViewController.topBarHeight);
                
                [viewController.view addSubview:_promptingView];
                //                [baseViewController bringTopBarToTop];
            }
        }
        NSMutableDictionary *itemsDict = [[self class] loadSearchHisotryItems];
        NSString *key = _combBox.currentSelectedType==kSearchTypeGoods?[[self class] archiveGoodsKey]:[[self class] archiveSellerKey];
        [_promptingView setHistoryItems:[itemsDict arrayValueForKey:key]];
        NSString *hotWordsKey = _combBox.currentSelectedType==kSearchTypeGoods?[[self class] archiveHotWordsGoodsKey]:[[self class] archiveHotWordsSellerKey];
        NSArray *array = [itemsDict arrayValueForKey:hotWordsKey];
        if (_isShowHotWords) [_promptingView setHotItems:array];
        
        
        if ( _combBox.currentSelectedType == kSearchTypeGoods) {
            self.placeholder = self.mapText;
        }else if ( _combBox.currentSelectedType == kSearchTypeSeller){
            self.placeholder = @"请输入关键词";
        }
        
        BOOL bForceUpdate = NO;
        NSDate *date = [itemsDict objectForKey:[[self class] archiveHotWordsTimestampKey]];
        if (date) {
            NSTimeInterval timestamp = [date timeIntervalSince1970];
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            if (now-timestamp>20*60) {
                bForceUpdate = YES;
            }
        }
        if ([array count]==0 || !date || bForceUpdate) {
            WEAKSELF;
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf loadHotWords];
            });
        }
    } else {
        [_promptingView removeFromSuperview];
        _promptingView = nil;
    }
}

//-(void)setPlaceholder:(NSString *)placeholder
//{
//    if ( _combBox.currentSelectedType == kSearchTypeGoods) {
//        self.placeholder = placeholder;
//    }else if ( _combBox.currentSelectedType == kSearchTypeSeller){
//        self.placeholder = @"请输入关键词";
//    }
//}

- (void)loadHotWords {
    WEAKSELF;
    _requestHotWords = [[NetworkAPI sharedInstance] getHotWords:^(NSDictionary *data) {
        
        {
            NSMutableArray *hotWords = [[NSMutableArray alloc] init];
            NSArray *array = [data arrayValueForKey:@"goods_hot_words"];
            if ([array isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in array) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        HotWord *hotWord = [HotWord createWithDict:dict];
                        if ([hotWord.keyword length]>0) {
                            [hotWords addObject:hotWord];
                        }
                    }
                }
            }
            [[weakSelf class] saveHotWords:hotWords forKey:[[weakSelf class] archiveHotWordsGoodsKey]];
            
            if (weakSelf.currentSearchType==kSearchTypeGoods) {
                //                [weakSelf.promptingView setHotItems:hotWords];
                if (weakSelf.isShowHotWords)[weakSelf.promptingView setHotItems:hotWords];
            }
        }
        {
            NSMutableArray *hotWords = [[NSMutableArray alloc] init];
            NSArray *array = [data arrayValueForKey:@"seller_hot_words"];
            if ([array isKindOfClass:[NSArray class]]) {
                for (NSDictionary *dict in array) {
                    if ([dict isKindOfClass:[NSDictionary class]]) {
                        HotWord *hotWord = [HotWord createWithDict:dict];
                        if ([hotWord.keyword length]>0) {
                            [hotWords addObject:hotWord];
                        }
                    }
                }
            }
            [[weakSelf class] saveHotWords:hotWords forKey:[[weakSelf class] archiveHotWordsSellerKey]];
            
            if (weakSelf.currentSearchType==kSearchTypeSeller) {
                if (weakSelf.isShowHotWords)[weakSelf.promptingView setHotItems:hotWords];
            }
        }
        
        [[weakSelf class] saveHotWordsTimestamp:[NSDate date]];
        
        weakSelf.requestHotWords = nil;
    } failure:^(XMError *error) {
        
        weakSelf.requestHotWords = nil;
    }];
}

- (void)searchPromptingViewCanceled:(SearchPromptingView*)view
{
    [self endEditing:YES];
}

- (void)searchPromptingViewClearHistory:(SearchPromptingView*)view
{
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:[AppDirs searchHistoryCacheFile] isDirectory:&isDirectory]
        && !isDirectory) {
        [[NSFileManager defaultManager] removeItemAtPath:[AppDirs searchHistoryCacheFile] error:nil];
        if (_combBox.currentSelectedType == 0) {
            [ClientReportObject clientReportObjectWithViewCode:HomeSearchViewCode regionCode:SearchGoodsDeleHistoryRegionCode referPageCode:NoReferPageCode andData:nil];
        } else if (_combBox.currentSelectedType == 1) {
            [ClientReportObject clientReportObjectWithViewCode:HomeSearchViewCode regionCode:SearchSellDeleHistoryRegionCode referPageCode:NoReferPageCode andData:nil];
        }
        
    }
    
    [view setHistoryItems:nil];
}

- (void)searchPromptingViewDoSearch:(SearchPromptingView*)view keywords:(NSString*)keywords
{
    BOOL isHandled = NO;
    if (self.searchBarDelegate && [self.searchBarDelegate respondsToSelector:@selector(searchBarPromptingWordsDoSearch:keywords:)]) {
        isHandled = [self.searchBarDelegate searchBarPromptingWordsDoSearch:self keywords:keywords];
    }
    if (!isHandled) {
        UIViewController *viewController = [SearchBarCombBox findViewController:self];
        if ([viewController isKindOfClass:[SearchViewController class]]) {
            [viewController.view endEditing:YES];
            [((SearchViewController*)viewController) doSearch:keywords type:_combBox.currentSelectedType];
            
        } else {
            self.text = nil;
            [viewController.view endEditing:YES];
            SearchViewController *viewController = [[SearchViewController alloc] init];
            viewController.searchKeywords = keywords;
            viewController.searchType = _combBox.currentSelectedType;
            //            NSDictionary *data = @{@"searchKey":keywords};
            //            if (_combBox.currentSelectedType == 0) {
            //                [ClientReportObject clientReportObjectWithViewCode:HomeSearchViewCode regionCode:SearchGoodsHotRegionCode referPageCode:NoReferPageCode andData:data];
            //            } else if (_combBox.currentSelectedType == 1) {
            //                [ClientReportObject clientReportObjectWithViewCode:HomeSearchViewCode regionCode:SearchSellHotRegionCode referPageCode:NoReferPageCode andData:data];
            //            }
            [[CoordinatingController sharedInstance] pushViewController:viewController animated:YES];
        }
    }
}

- (void)searchBarCombBoxSelectChanged:(SearchBarCombBox*)combBox
{
    [self becomeFirstResponder];
    
    [self toggleWordsView:YES];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (!_searchTextField) {
        UITextField* searchField = nil;
        for (UIView *view in self.subviews) {
            // for before iOS7.0
            if ([view isKindOfClass:[UITextField class]]) {
                searchField = (UITextField*)view;
                break;
            }
            // for later iOS7.0(include)
            if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
                for (UIView* subview in view.subviews) {
                    if ([subview isKindOfClass:[UITextField class]]) {
                        searchField = (UITextField*)subview;
                        break;
                    }
                }
                break;
            }
        }
        _searchTextField = searchField;
    }
    
    if (_searchTextField) {
        _searchTextField.backgroundColor = [UIColor clearColor];
        _searchTextField.font = [UIFont systemFontOfSize:14.f];
        _searchTextField.textColor = [UIColor colorWithHexString:@"181818"];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        if (_isShowClearButton) {
            _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        } else {
            _searchTextField.clearButtonMode = UITextFieldViewModeNever;
        }
        
        if (!_leftView) {
            //searchField.frame = CGRectMake(0, 0, 50, 50);
            UIImage *image = [UIImage imageNamed: @"search_wjh"];
            _leftView = [[UIImageView alloc] initWithFrame:_searchTextField.leftView.frame];
            _leftView.image = image;
            _leftView.contentMode = UIViewContentModeScaleAspectFit;
            
        }
        
        if ([self.text length]>0) {
            _searchTextField.leftView = nil;
            
            CGFloat marginLeft = _isShowLeftCombBox?53.f:0;
            CGRect searchFieldFrame = self.bounds;
            searchFieldFrame.origin.x = marginLeft;
            searchFieldFrame.size.width = searchFieldFrame.size.width-marginLeft;
            _searchTextField.frame = searchFieldFrame;
        } else {
            _searchTextField.leftView = _leftView;
            CGFloat marginLeft = 0.f;
            CGRect searchFieldFrame = self.bounds;
            searchFieldFrame.origin.x = marginLeft;
            searchFieldFrame.size.width = searchFieldFrame.size.width-marginLeft;
            _searchTextField.frame = searchFieldFrame;
        }
    }
    
    _combBox.frame = CGRectMake(0, 0, 55, self.height);
    
}

- (BOOL)becomeFirstResponder {
    BOOL ret = [super becomeFirstResponder];
    [_combBox toggleCombBox:YES];
    _combBox.hidden = NO;
    return ret;
}

- (void)setDelegate:(id<UISearchBarDelegate>)delegate {
    if (_delegateProxy != delegate && delegate != self) {
        _delegateProxy = delegate;
        [super setDelegate:self];
    }
}

- (NSInteger)currentSearchType {
    return _combBox?_combBox.currentSelectedType:kSearchTypeGoods;
}

- (void)setCurrentSearchType:(NSInteger)currentSearchType {
    [_combBox setCurrentSelectedType:currentSearchType];
}

-(void)enableCancelButton:(BOOL)enable
{
    for (UIView *subview in self.subviews)
    {
        if ([subview isKindOfClass:[UIButton class]])
        {
            UIButton *cancelButton = (UIButton*)subview;
            cancelButton.enabled = enable;
            break;
        }
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    if (_delegateProxy && [_delegateProxy respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        return [_delegateProxy searchBarShouldBeginEditing:searchBar];
    }
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    WEAKSELF;
    
    if (weakSelf.searchBarDelegate && [_searchBarDelegate respondsToSelector:@selector(searchBarTextDidBeginEditingBefore:)]) {
        [weakSelf.searchBarDelegate searchBarTextDidBeginEditingBefore:weakSelf];
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        //取消搜索商品和店铺选择 显示leftView
        //        weakSelf.searchTextField.leftView = nil;
        [weakSelf.combBox toggleCombBox:YES];
        weakSelf.combBox.hidden = NO;
        CGFloat marginLeft = _isShowLeftCombBox?53.f:0;
        CGRect searchFieldFrame = weakSelf.bounds;
        searchFieldFrame.origin.x = marginLeft;
        searchFieldFrame.size.width = searchFieldFrame.size.width-marginLeft;
        weakSelf.searchTextField.frame = searchFieldFrame;
        
        if (weakSelf.delegateProxy && [weakSelf.delegateProxy respondsToSelector:@selector(searchBarTextDidBeginEditing:)]) {
            [weakSelf.delegateProxy searchBarTextDidBeginEditing:searchBar];
        }
    });
    
    [self toggleWordsView:YES];
    
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    if (_delegateProxy && [_delegateProxy respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        return [_delegateProxy searchBarShouldEndEditing:searchBar];
    }
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if ([self.text trim].length>0) {
        
    } else {
        self.text = nil;
        _searchTextField.leftView = _leftView;
        [_combBox toggleCombBox:NO];
        _combBox.hidden = YES;
        
        CGFloat marginLeft = 0.f;
        CGRect searchFieldFrame = self.bounds;
        searchFieldFrame.origin.x = marginLeft;
        searchFieldFrame.size.width = searchFieldFrame.size.width-marginLeft;
        _searchTextField.frame = searchFieldFrame;
    }
    
    
    [self toggleWordsView:NO];
    
    if (_delegateProxy && [_delegateProxy respondsToSelector:@selector(searchBarTextDidEndEditing:)]) {
        [_delegateProxy searchBarTextDidEndEditing:searchBar];
    }
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (_delegateProxy && [_delegateProxy respondsToSelector:@selector(searchBar:textDidChange:)]) {
        [_delegateProxy searchBar:searchBar textDidChange:searchText];
    }
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (_delegateProxy && [_delegateProxy respondsToSelector:@selector(searchBar:shouldChangeTextInRange:replacementText:)]) {
        return [_delegateProxy searchBar:searchBar shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

+ (NSString*)archiveHotWordsTimestampKey {
    return @"hotwords_timestamp";
}
+ (NSString*)archiveHotWordsGoodsKey {
    return @"hotwords_goods";
}
+ (NSString*)archiveHotWordsSellerKey {
    return @"hotwords_seller";
}
+ (NSString*)archiveGoodsKey {
    return @"goods";
}
+ (NSString*)archiveSellerKey {
    return @"seller";
}

+ (void)saveHotWordsTimestamp:(NSDate*)date
{
    if (date) {
        NSMutableDictionary *itemsDict = [[self class] loadSearchHisotryItems];
        [itemsDict setObject:date forKey:[self archiveHotWordsTimestampKey]];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:itemsDict forKey:@"history"];
        [archiver finishEncoding];
        [data writeToFile:[AppDirs searchHistoryCacheFile] atomically:YES];
    }
}

+ (void)saveHotWords:(NSArray*)items forKey:(NSString*)key
{
    if ([key length]>0) {
        NSMutableDictionary *itemsDict = [[self class] loadSearchHisotryItems];
        [itemsDict setObject:items?items:[NSArray array] forKey:key];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:itemsDict forKey:@"history"];
        [archiver finishEncoding];
        [data writeToFile:[AppDirs searchHistoryCacheFile] atomically:YES];
    }
}
+ (NSMutableDictionary*)loadSearchHisotryItems {
    NSMutableDictionary *itemsDict = nil;
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:[AppDirs searchHistoryCacheFile] isDirectory:&isDirectory]
        && !isDirectory) {
        NSData *data = [NSData dataWithContentsOfFile:[AppDirs searchHistoryCacheFile]];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *historyItemsDict = [unarchiver decodeObjectForKey:@"history"];
        if ([historyItemsDict isKindOfClass:[NSDictionary class]]) {
            itemsDict = [[NSMutableDictionary alloc] initWithDictionary:historyItemsDict];
        }
        [unarchiver finishDecoding];
    }
    if (!itemsDict) {
        itemsDict = [[NSMutableDictionary alloc] init];
    }
    return itemsDict;
}
+ (void)saveSearchHisotryWord:(NSString*)word forKey:(NSString*)key
{
    if ([word length]>0 && [key length]>0) {
        NSMutableDictionary *itemsDict = [self loadSearchHisotryItems];
        NSMutableArray *items = [[NSMutableArray alloc] initWithArray:[itemsDict arrayValueForKey:key]];
        if ([items count]>0) {
            //merge
            for (NSString *tmpWord in items) {
                if ([tmpWord isEqualToString:word]) {
                    [items removeObject:tmpWord];
                    break;
                }
            }
            [items insertObject:word atIndex:0];
            while (true) {
                if ([items count]>12) {
                    [items removeObjectAtIndex:[items count]-1];
                } else {
                    break;
                }
            }
        } else {
            items = [[NSMutableArray alloc] init];
            [items addObject:word];
        }
        [itemsDict setObject:items forKey:key];
        NSMutableData *data = [[NSMutableData alloc] init];
        NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
        [archiver encodeObject:itemsDict forKey:@"history"];
        [archiver finishEncoding];
        [data writeToFile:[AppDirs searchHistoryCacheFile] atomically:YES];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    NSString *word = [self.text trim];
    [[self class] saveSearchHisotryWord:word forKey:[_combBox currentSelectedType]==kSearchTypeGoods?[[self class] archiveGoodsKey]:[[self class] archiveSellerKey]];
    self.promptingView.hidden = YES;
    [self resignFirstResponder];
    if (_delegateProxy && [_delegateProxy respondsToSelector:@selector(searchBarSearchButtonClicked:)]) {
        [_delegateProxy searchBarSearchButtonClicked:searchBar];
    }
}
- (void)searchBarBookmarkButtonClicked:(UISearchBar *)searchBar {
    if (_delegateProxy && [_delegateProxy respondsToSelector:@selector(searchBarBookmarkButtonClicked:)]) {
        [_delegateProxy searchBarBookmarkButtonClicked:searchBar];
    }
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    if (_delegateProxy && [_delegateProxy respondsToSelector:@selector(searchBarCancelButtonClicked:)]) {
        [_delegateProxy searchBarCancelButtonClicked:searchBar];
    }
}
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar NS_AVAILABLE_IOS(3_2) {
    if (_delegateProxy && [_delegateProxy respondsToSelector:@selector(searchBarResultsListButtonClicked:)]) {
        [_delegateProxy searchBarResultsListButtonClicked:searchBar];
    }
}
- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope NS_AVAILABLE_IOS(3_0) {
    if (_delegateProxy && [_delegateProxy respondsToSelector:@selector(searchBar:selectedScopeButtonIndexDidChange:)]) {
        [_delegateProxy searchBar:searchBar selectedScopeButtonIndexDidChange:selectedScope];
    }
}

@end

@implementation SearchFilterItemView {
    UIImageView *_bgView;
    UIImageView *_closeIcon;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        //        UIImage *filterBtnBg = [UIImage imageNamed:@"filter_btn.png"];
        //        [self setBackgroundImage:[filterBtnBg stretchableImageWithLeftCapWidth:filterBtnBg.size.width/2 topCapHeight:filterBtnBg.size.height/2] forState:UIControlStateNormal];
        //
        //        UIImage *filterBtnChosenBg = [UIImage imageNamed:@"filter_btn_chosen.png"];
        //        [self setBackgroundImage:[filterBtnChosenBg stretchableImageWithLeftCapWidth:filterBtnChosenBg.size.width/2 topCapHeight:filterBtnChosenBg.size.height/2] forState:UIControlStateSelected];
        //
        //        UIImage *filterBtnPressBg = [UIImage imageNamed:@"filter_btn_press.png"];
        //        [self setBackgroundImage:[filterBtnPressBg stretchableImageWithLeftCapWidth:filterBtnPressBg.size.width/2 topCapHeight:filterBtnPressBg.size.height/2] forState:UIControlStateHighlighted];
        
        [self setTitleColor:[UIColor colorWithHexString:@"b7b7b7"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"333333"] forState:UIControlStateSelected];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13.f];
        
        //        UIImage *closeImg = [UIImage imageNamed:@"filter_btn_chosen_close.png"];
        //        _closeIcon = [[UIImageView alloc] initWithImage:closeImg];
        //        _closeIcon.frame = CGRectMake(0, 0, closeImg.size.width, closeImg.size.height);
        //        [self addSubview:_closeIcon];
        _closeIcon.hidden = YES;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _closeIcon.frame = CGRectMake(self.width-_closeIcon.bounds.size.width, 0, _closeIcon.bounds.size.width, _closeIcon.bounds.size.height);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        _closeIcon.hidden = NO;
    } else {
        _closeIcon.hidden = YES;
    }
    
    self.filterItem.isYesSelected = selected;
}

- (void)updateByFilterItem:(SearchFilterItem*)filterItem
{
    self.filterItem = filterItem;
    self.selected = filterItem.isYesSelected;
    [self setTitle:filterItem.title forState:UIControlStateNormal];
}

@end


@interface SearchFilterTopItemView ()



@end

@implementation SearchFilterTopItemView {
    
}

- (NSInteger)itemViewTag {
    return self.tag;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = NO;
        
        _chosingView = [[TapDetectingImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height+10+1)];
        _chosingView.userInteractionEnabled = YES;
        //        [self addSubview:_chosingView];
        //        [self sendSubviewToBack:_chosingView];
        
        [self insertSubview:_chosingView belowSubview:self.titleLabel];
        
        
        UIImage *filterChosingBg = [UIImage imageNamed:@"filter_btn_choosing.png"];
        [_chosingView setImage:[filterChosingBg stretchableImageWithLeftCapWidth:filterChosingBg.size.width/2 topCapHeight:filterChosingBg.size.height/2]];
        
        _chosingView.hidden = YES;
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self setChosingState:NO];
    if (!selected) {
        [self setTitle:self.filterInfo.name forState:UIControlStateNormal];
    }
    
    [self setNeedsDisplay];
}

- (void)setChosingState:(BOOL)chosing {
    _chosingView.hidden = !chosing;
}

- (BOOL)isChosingState {
    return !_chosingView.hidden;
}

@end


@implementation SearchFilterTopView

- (void)dealloc
{
    _handleTopItemTapDetected = nil;
}

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat X = 8.f;
        CGFloat height = 30.f;
        CGFloat Y = (self.height-height)/2;
        CGFloat width = (self.width-5*8)/4;
        
        WEAKSELF;
        for (NSInteger i=0;i<4;i++) {
            SearchFilterTopItemView *itemView = [[SearchFilterTopItemView alloc] initWithFrame:CGRectMake(X, Y, width, height)];
            [self addSubview:itemView];
            X += width;
            X += 8.f;
            [itemView addTarget:self action:@selector(topItemClicked:) forControlEvents:UIControlEventTouchUpInside];
            itemView.hidden = YES;
            
            typeof(SearchFilterTopItemView*) __weak weakTopItemView = itemView;
            itemView.chosingView.handleSingleTapDetected = ^(TapDetectingImageView *view, UIGestureRecognizer *recognizer) {
                if (weakTopItemView
                    && weakSelf.handleTopItemCancelTapDetected) {
                    weakSelf.handleTopItemCancelTapDetected(weakTopItemView);
                }
            };
        }
    }
    return self;
}

- (void)topItemClicked:(SearchFilterTopItemView*)sender {
    if (![sender isChosingState]) {
        for (SearchFilterTopItemView *itemView in [self subviews]) {
            [itemView setChosingState:NO];
        }
        [sender setChosingState:YES];
        
        if (self.handleTopItemTapDetected) {
            self.handleTopItemTapDetected(sender);
        }
    }
}

- (void)updateByFilterInfos:(NSArray*)filterInfos
{
    for (UIView *view in [self subviews]) {
        view.hidden = YES;
    }
    for (NSInteger i=0;i<[filterInfos count];i++) {
        SearchFilterInfo * filterInfo = [filterInfos objectAtIndex:i];
        if (i<[self.subviews count]) {
            SearchFilterTopItemView *itemView = (SearchFilterTopItemView*)[self.subviews objectAtIndex:i];
            itemView.hidden = NO;
            itemView.tag = i+10;
            itemView.filterInfo = filterInfo;
            [itemView setTitle:filterInfo.name forState:UIControlStateNormal];
        }
    }
    
    [self updateTopItemsSelectedState];
}

- (void)updateTopItemsSelectedState
{
    for (SearchFilterTopItemView *itemView in [self subviews]) {
        [itemView setChosingState:NO];
        [itemView setSelected:NO];
        
        if (![itemView isHidden]) {
            SearchFilterInfo * filterInfo = itemView.filterInfo;
            if (filterInfo.type == 0) {
                for (SearchFilterItem *item in filterInfo.items) {
                    if (item.isYesSelected) {
                        [itemView setTitle:item.title forState:UIControlStateNormal];
                        [itemView setChosingState:NO];
                        [itemView setSelected:YES]; //removed
                        break;
                    }
                }
            }
            else if (filterInfo.type == 1) {
                [itemView setChosingState:NO];
                BOOL selected = NO;
                for (SearchFilterInfo *filterInfoSub in filterInfo.items)  {
                    if (filterInfoSub.type == 0) {
                        for (SearchFilterItem *item in filterInfoSub.items) {
                            if (item.isYesSelected && [item isKindOfClass:[SearchFilterItem class]]) {
                                selected = YES; //removed
                                [itemView setTitle:item.title forState:UIControlStateNormal];
                                [itemView setSelected:selected];
                                break;
                            }
                        }
                    } else if (filterInfoSub.type == 1) {
                        for (SearchFilterInfo *filterInfoSubT in filterInfo.items)  {
                            if (filterInfoSubT.type == 0) {
                                for (SearchFilterItem *item in filterInfoSubT.items) {
                                    if (item.isYesSelected && [item isKindOfClass:[SearchFilterItem class]]) {
                                        selected = YES; //removed
                                        [itemView setTitle:item.title forState:UIControlStateNormal];
                                        [itemView setSelected:selected];
                                        break;
                                    }
                                }
                            } else if (filterInfoSub.type == 1) {
                                for (SearchFilterInfo *filterInfoSubT in filterInfo.items)  {
                                    if (filterInfoSubT.type == 0) {
                                        for (SearchFilterItem *item in filterInfoSubT.items) {
                                            if (item.isYesSelected && [item isKindOfClass:[SearchFilterItem class]]) {
                                                selected = YES; //removed
                                                [itemView setTitle:item.title forState:UIControlStateNormal];
                                                [itemView setSelected:selected];
                                                break;
                                            }
                                        }
                                    } else if (filterInfoSub.type == 1) {
                                        
                                    }
                                    if (selected) break;
                                }
                            }
                            if (selected) break;
                        }
                    }
                    if (selected) break;
                }
            }
        }
    }
}

- (void)cancelFilter {
    for (SearchFilterTopItemView *itemView in [self subviews]) {
        [itemView setChosingState:NO];
    }
}

- (NSArray*)filterInfos {
    NSMutableArray *array = [[NSMutableArray alloc] init];
    for (SearchFilterTopItemView *itemView in [self subviews]) {
        if ([itemView isKindOfClass:[SearchFilterTopItemView class]]) {
            if (![itemView isHidden] && itemView.filterInfo) {
                [array addObject:itemView.filterInfo];
            }
        }
    }
    return array;
}

@end

@interface SearchFilterInfoTableViewCell : BaseTableViewCell
@property(nonatomic,weak) UIView *itemsView;
@end

@implementation SearchFilterInfoTableViewCell
+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SearchFilterInfoTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = ( 90.f * kScreenWidth ) / 320.f;
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(NSInteger)columnNum {
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SearchFilterInfoTableViewCell class]];
    [dict setObject:[NSNumber numberWithInteger:columnNum] forKey:[self cellKeyForColumnNum]];
    return dict;
}

+ (NSString*)cellKeyForColumnNum {
    return @"columnNum";
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *itemsView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:itemsView];
        _itemsView = itemsView;
        
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    for (UIView *view in _itemsView.subviews) {
        view.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    NSInteger columnNum = [[dict objectForKey:[[self class] cellKeyForColumnNum]] integerValue];
    
    
    [self setNeedsLayout];
}

@end

@interface SearchFilterInfoView ()

@property(nonatomic,strong) UILabel *nameLbl;
@property(nonatomic,strong) UIView *itemsView;
@property(nonatomic,strong) CALayer *bottomLine;
@property(nonatomic,assign) NSInteger columnNum;
@end

@implementation SearchFilterInfoView

- (instancetype)init {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isShowBottomeLine = NO;
        _isShowTitle = NO;
        _isAllowMultiSelected = NO;
        
        _itemsView = [[UIView alloc] initWithFrame:CGRectZero];
        _itemsView.backgroundColor = [UIColor clearColor];
        [self addSubview:_itemsView];
        
        _nameLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        _nameLbl.font = [UIFont systemFontOfSize:15.f];
        _nameLbl.textColor = [UIColor colorWithHexString:@"AAAAAA"];
        _nameLbl.numberOfLines = 1;
        _nameLbl.hidden = YES;
        [self addSubview:_nameLbl];
        
        _bottomLine = [CALayer layer];
        _bottomLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_bottomLine];
        
        _columnNum = 3;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [[self class] calculteAndLayoutSubviews:self filterInfo:nil isShowTitle:self.isShowTitle columnNum:_columnNum];
    
    self.bottomLine.frame = CGRectMake(0, self.height-0.5f, self.width, 0.5f);
}

+ (CGFloat)calculteAndLayoutSubviews:(SearchFilterInfoView*)view filterInfo:(SearchFilterInfo*)filterInfo isShowTitle:(BOOL)isShowTitle columnNum:(NSInteger)columnNum
{
    if (columnNum==0)columnNum=3;
    CGFloat marginTop = 0.f;
    marginTop = 15.f;
    
    if (isShowTitle) {
        NSString *nameString = view?view.nameLbl.text:filterInfo.name;
        if (nameString && [nameString length]>0) {
            CGSize nameSize = [nameString sizeWithFont:[UIFont systemFontOfSize:15.f]
                                     constrainedToSize:CGSizeMake(kScreenWidth-28,MAXFLOAT)
                                         lineBreakMode:NSLineBreakByWordWrapping];
            
            if (view) {
                view.nameLbl.frame = CGRectMake(16, marginTop, nameSize.width, nameSize.height);
            }
            
            marginTop += nameSize.height;
            marginTop += 14.f;
        }
        if (view) {
            view.nameLbl.hidden = !isShowTitle;
        }
    }
    
    if (view) {
        CGFloat sepWidth = 15.f;
        CGFloat marginLeft = sepWidth;
        
        view.itemsView.frame= view.bounds;
        
        NSInteger count = 0;
        for (UIView *itemView in view.itemsView.subviews) {
            if (![itemView isHidden]) {
                if (count>0 && count%columnNum==0) {
                    marginTop += itemView.height;
                    marginTop += 15.f;
                    marginLeft = sepWidth;
                }
                itemView.frame = CGRectMake(marginLeft, marginTop, itemView.width, itemView.height);
                marginLeft += itemView.width;
                marginLeft += sepWidth;
                count += 1;
            }
        }
        marginTop += 15.f;
        
    } else {
        NSInteger numOfLines = [filterInfo.items count]%columnNum>0?[filterInfo.items count]/columnNum+1:[filterInfo.items count]/columnNum;
        if (numOfLines>0) {
            marginTop += (numOfLines*30+(numOfLines-1)*15.f);
        }
        marginTop += 15.f;
    }
    
    marginTop += 1;
    
    return marginTop;
}

+ (CGFloat)rowHeightForPortrait:(SearchFilterInfo*)filterInfo isShowTitle:(BOOL)isShowTitle columnNum:(NSInteger)columnNum
{
    return [self calculteAndLayoutSubviews:nil filterInfo:filterInfo isShowTitle:isShowTitle columnNum:columnNum];
}

- (void)updateByFilterInfo:(SearchFilterInfo*)filterInfo columnNum:(NSInteger)columnNum
{
    if (columnNum==0)columnNum=3;
    
    _columnNum = columnNum;
    _filterInfo = filterInfo;
    
    _bottomLine.hidden = !_isShowBottomeLine;
    _nameLbl.hidden = !_isShowTitle;
    _nameLbl.text = filterInfo.name;
    
    WEAKSELF;
    CGFloat width = (self.width-30-15*(columnNum-1))/columnNum;
    CGFloat height = 30.f;
    NSInteger count = [_itemsView subviews].count;
    for (NSInteger i=count;i<[filterInfo.items count];i++) {
        SearchFilterItemView *itemView = [[SearchFilterItemView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        
        [itemView setBackgroundImage:nil forState:UIControlStateNormal];
        UIImage *filterBtnPressBg = [UIImage imageNamed:@"filter_btn_press2.png"];
        [itemView setBackgroundImage:[filterBtnPressBg stretchableImageWithLeftCapWidth:filterBtnPressBg.size.width/2 topCapHeight:filterBtnPressBg.size.height/2] forState:UIControlStateHighlighted];
        
        itemView.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        itemView.contentEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 0);
        
        [_itemsView addSubview:itemView];
        itemView.handleClickBlock = ^(CommandButton *sender) {
            if (weakSelf.filterInfo.isMultiSelected) {
                sender.selected = !sender.isSelected;
                if (weakSelf.handleFilterItemTapDetected) {
                    weakSelf.handleFilterItemTapDetected((SearchFilterItemView*)sender);
                }
            }
            else
            {
                sender.selected = !sender.isSelected;
                if (sender.selected) {
                    for (SearchFilterItemView *view in [_itemsView subviews]) {
                        if (view!= sender) {
                            view.selected = NO;
                        }
                    }
                }
                if (weakSelf.handleFilterItemTapDetected) {
                    weakSelf.handleFilterItemTapDetected((SearchFilterItemView*)sender);
                }
            }
        };
    }
    
    for (UIView *view in [_itemsView subviews]) {
        view.hidden = YES;
        view.frame = CGRectMake(0, 0, width, height);
    }
    
    [self setNeedsLayout];
    
    for (NSInteger i=0;i<[filterInfo.items count];i++) {
        SearchFilterItemView *itemView = [[_itemsView subviews] objectAtIndex:i];
        itemView.hidden = NO;
        [itemView updateByFilterItem:[filterInfo.items objectAtIndex:i]];
    }
}

- (NSArray*)selectedFilterItems
{
    NSMutableArray *items = [[NSMutableArray alloc] init];
    for (SearchFilterItemView *view in [_itemsView subviews]) {
        if ([view isSelected] && !view.isHidden) {
            [items addObject:view.filterItem];
        }
    }
    return items;
}

- (NSArray*)filterItemViews {
    return _itemsView?[_itemsView subviews]:nil;
}

- (void)cancelFilter
{
    for (SearchFilterItemView *view in [_itemsView subviews]) {
        if ([view isKindOfClass:[SearchFilterItemView class]]) {
            view.selected = NO;
        }
    }
}

@end

@interface SearchFilterContainerView ()
@property(nonatomic,strong) UIImageView *bottomBar;
@property(nonatomic,strong) NSMutableArray *multiFilterItems;
@property(nonatomic,strong) UIScrollView *scrollView;
@end

@implementation SearchFilterContainerView {
    CALayer *_topLine;
    TapDetectingView *_bgView;
}

- (id)init {
    return [self initWithFrame:CGRectMake(0, 0, kScreenWidth, 0)];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        self.userInteractionEnabled = YES;
        
        _bgView = [[TapDetectingView alloc] initWithFrame:CGRectNull];
        _bgView.backgroundColor = [UIColor clearColor];
        [self addSubview:_bgView];
        
        _topLine = [CALayer layer];
        _topLine.backgroundColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
        [self.layer addSublayer:_topLine];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.alwaysBounceVertical = YES;
        [self addSubview:_scrollView];
        
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectNull];
        contentView.tag = 100;
        contentView.backgroundColor = [UIColor clearColor];
        [_scrollView addSubview:contentView];
        
        self.bottomBar.hidden = YES;
        [self addSubview:self.bottomBar];
        
        WEAKSELF;
        _bgView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
            if (weakSelf.handleFilterCancelDetected) {
                weakSelf.handleFilterCancelDetected(weakSelf);
            }
        };
    }
    return self;
}

- (UIView*)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44.f)];
        _bottomBar.userInteractionEnabled = YES;
        _bottomBar.backgroundColor = [UIColor whiteColor];
        _bottomBar.tag = 200;
        [self addSubview:_bottomBar];
        UIImage *bgImage = [UIImage imageNamed:@"bottombar_bg_white"];
        [_bottomBar setImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2]];
        
        CommandButton *confirmBtn = [[CommandButton alloc] initWithFrame:CGRectNull];
        [_bottomBar addSubview:confirmBtn];
        confirmBtn.backgroundColor = [UIColor colorWithHexString:@"282828"];
        [confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
        [confirmBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        confirmBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        confirmBtn.frame = CGRectMake(_bottomBar.width-104, 0.5f, 104, _bottomBar.height-0.5f);
        
        CommandButton *resetBtn = [[CommandButton alloc] initWithFrame:CGRectNull];
        [_bottomBar addSubview:resetBtn];
        resetBtn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
        [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
        [resetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [resetBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
        resetBtn.titleLabel.font = [UIFont systemFontOfSize:14.f];
        resetBtn.frame = CGRectMake(_bottomBar.width-104-104, 0.5f, 104, _bottomBar.height-0.5f);
        
        WEAKSELF;
        confirmBtn.handleClickBlock = ^(CommandButton *sender) {
            UIView *contentView = [weakSelf.scrollView viewWithTag:100];
            NSMutableArray *filterInfos = [[NSMutableArray alloc] init];
            for (UIView *view in [contentView subviews]) {
                SearchFilterInfoView *filterInfoView = (SearchFilterInfoView*)view;
                NSArray *selectedFilterItems = [filterInfoView selectedFilterItems];
                if ([selectedFilterItems count]>0) {
                    SearchFilterInfo* filterInfo = [filterInfoView.filterInfo clone];
                    filterInfo.items = selectedFilterItems;
                    [filterInfos addObject:filterInfo];
                }
            }
            if (weakSelf.handleFilterItemsSelected) {
                weakSelf.handleFilterItemsSelected(weakSelf, filterInfos);
            }
        };
        
        resetBtn.handleClickBlock = ^(CommandButton *sender) {
            UIView *contentView = [weakSelf.scrollView viewWithTag:100];
            for (UIView *view in [contentView subviews]) {
                SearchFilterInfoView *filterInfoView = (SearchFilterInfoView*)view;
                [filterInfoView cancelFilter];
            }
        };
    }
    return _bottomBar;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _bgView.frame = self.bounds;
    
    _topLine.frame = CGRectMake(0, 0, self.width, 1.f);
}

- (NSArray*)selectedFilterInfos {
    return nil;
}

- (void)cancelFilter
{
    UIView *contentView = [_scrollView viewWithTag:100];
    
    for (UIView *view in [contentView subviews]) {
        SearchFilterInfoView *filterInfoView = (SearchFilterInfoView*)view;
        filterInfoView.hidden = YES;
        filterInfoView.handleFilterItemTapDetected = nil;
        [filterInfoView cancelFilter];
    }
}

- (void)updateByFilterInfo:(SearchFilterInfo*)filterInfo
{
    self.filterInfo = filterInfo;
    
    UIView *contentView = [_scrollView viewWithTag:100];
    
    if (filterInfo.type == 0) {
        NSInteger count = [contentView subviews].count;
        if (count <= 0) {
            SearchFilterInfoView *filterInfoView = [[SearchFilterInfoView alloc] initWithFrame:CGRectNull];
            filterInfoView.backgroundColor = [UIColor clearColor];
            [contentView addSubview:filterInfoView];
        }
    } else if (filterInfo.type == 1){
        NSInteger count = [contentView subviews].count;
        for (NSInteger i=count;i<[filterInfo.items count];i++) {
            SearchFilterInfoView *filterInfoView = [[SearchFilterInfoView alloc] initWithFrame:CGRectNull];
            filterInfoView.backgroundColor = [UIColor clearColor];
            [contentView addSubview:filterInfoView];
        }
    }
    
    for (UIView *view in [contentView subviews]) {
        SearchFilterInfoView *filterInfoView = (SearchFilterInfoView*)view;
        filterInfoView.hidden = YES;
        filterInfoView.handleFilterItemTapDetected = nil;
    }
    
    if (filterInfo.type == 0) {
        NSInteger columnNum = [filterInfo.queryKey isEqualToString:@"brand"]||[filterInfo.queryKey isEqualToString:@"brandId"]?1:3;
        CGFloat height = [SearchFilterInfoView rowHeightForPortrait:filterInfo isShowTitle:NO columnNum:columnNum];
        self.bottomBar.hidden = filterInfo.isMultiSelected>0?NO:YES;
        
        SearchFilterInfoView *filterInfoView = (SearchFilterInfoView*)[contentView.subviews objectAtIndex:0];
        filterInfoView.isShowTitle = NO;
        filterInfoView.isShowBottomeLine = NO;
        filterInfoView.hidden = NO;
        filterInfoView.frame = CGRectMake(0, 0, _scrollView.width, height);
        [filterInfoView updateByFilterInfo:filterInfo columnNum:columnNum];
        
        
        if (height+(self.bottomBar.hidden?0:self.bottomBar.height)<kFilterInfoViewMinHeight) {
            height = kFilterInfoViewMinHeight;
        }
        contentView.frame = CGRectMake(0, 0, _scrollView.width, height);
        
        if (contentView.height < self.height-80-(self.bottomBar.hidden?0:self.bottomBar.height)) {
            _scrollView.frame = CGRectMake(0, 1.f, self.width, contentView.height);
            _scrollView.contentSize = CGSizeMake(_scrollView.width, contentView.height);
        } else {
            _scrollView.frame = CGRectMake(0, 1.f, self.width, self.height-80-(self.bottomBar.hidden?0:self.bottomBar.height));
            _scrollView.contentSize = CGSizeMake(_scrollView.width, contentView.height);
        }
        
        self.bottomBar.frame = CGRectMake(0, _scrollView.top+_scrollView.height, self.width, self.bottomBar.height);
        
        WEAKSELF;
        filterInfoView.handleFilterItemTapDetected = ^(SearchFilterItemView *filterItemView) {
            if (weakSelf.handleFilterItemsSelected) {
                SearchFilterInfo *filterInfo = [weakSelf.filterInfo clone];
                NSMutableArray *items = [[NSMutableArray alloc] init];
                [items addObject:filterItemView.filterItem];
                filterInfo.items = items;
                
                if (!filterInfo.isMultiSelected) {
                    NSMutableArray *filterInfos = [[NSMutableArray alloc] init];
                    [filterInfos addObject:filterInfo];
                    weakSelf.handleFilterItemsSelected(weakSelf,filterInfos);
                }
            }
        };
        
    } else if (filterInfo.type == 1) {
        CGFloat marginTop = 0.f;
        WEAKSELF;
        _multiFilterItems = [[NSMutableArray alloc] init];
        
        typeof(SearchFilterInfo) __weak *weak_filterInfo = filterInfo;
        
        for (NSInteger i=0;i<[filterInfo.items count];i++) {
            SearchFilterInfo *temp = [filterInfo.items objectAtIndex:i];
            if (!filterInfo.isMultiSelected) {
                temp.isMultiSelected = NO;//过滤一下，如果父FilterInfo不支持多选，那么子FilterInfo不应该是多选
            }
            
            NSInteger columnNum = [temp.queryKey isEqualToString:@"brand"]||[filterInfo.queryKey isEqualToString:@"brandId"]?1:3;
            
            CGFloat height = [SearchFilterInfoView rowHeightForPortrait:temp isShowTitle:YES columnNum:columnNum];
            
            SearchFilterInfoView *filterInfoView = (SearchFilterInfoView*)[contentView.subviews objectAtIndex:i];
            filterInfoView.isShowTitle = YES;
            filterInfoView.isShowBottomeLine = i<[filterInfo.items count]-1?YES:NO;
            filterInfoView.hidden = NO;
            filterInfoView.frame = CGRectMake(0, marginTop, _scrollView.width, height);
            [filterInfoView updateByFilterInfo:temp columnNum:columnNum];
            
            filterInfoView.handleFilterItemTapDetected = ^(SearchFilterItemView *filterItemView) {
                if (weak_filterInfo && weak_filterInfo.isMultiSelected) {
                    if (filterItemView.selected) {
                        [weakSelf.multiFilterItems addObject:filterItemView.filterItem];
                    } else {
                        [weakSelf.multiFilterItems removeObject:filterItemView.filterItem];
                    }
                }
                else {
                    UIView *contentView = [weakSelf.scrollView viewWithTag:100];
                    NSMutableArray *filterInfos = [[NSMutableArray alloc] init];
                    for (UIView *view in [contentView subviews]) {
                        SearchFilterInfoView *filterInfoView = (SearchFilterInfoView*)view;
                        if ([filterInfoView.filterItemViews containsObject:filterItemView]) {
                            SearchFilterInfo *filterInfo = [filterInfoView.filterInfo clone];
                            NSMutableArray *items = [[NSMutableArray alloc] init];
                            [items addObject:filterItemView.filterItem];
                            filterInfo.items = items;
                        } else {
                            [filterInfoView cancelFilter];
                        }
                    }
                    if (weakSelf.handleFilterItemsSelected) {
                        weakSelf.handleFilterItemsSelected(weakSelf, filterInfos);
                    }
                }
            };
            marginTop += height;
        }
        
        if (marginTop+(self.bottomBar.hidden?0:self.bottomBar.height)<kFilterInfoViewMinHeight) {
            marginTop = kFilterInfoViewMinHeight;
        }
        
        contentView.frame = CGRectMake(0, 0, _scrollView.width, marginTop);
        self.bottomBar.hidden = filterInfo.isMultiSelected>0?NO:YES;
        
        if (contentView.height < self.height-80-(self.bottomBar.hidden?0:self.bottomBar.height)) {
            _scrollView.frame = CGRectMake(0, 1.f, self.width, contentView.height);
            _scrollView.contentSize = CGSizeMake(_scrollView.width, contentView.height);
        } else {
            _scrollView.frame = CGRectMake(0, 1.f, self.width, self.height-80-(self.bottomBar.hidden?0:self.bottomBar.height));
            _scrollView.contentSize = CGSizeMake(_scrollView.width, contentView.height);
        }
        
        self.bottomBar.frame = CGRectMake(0, _scrollView.top+_scrollView.height, self.width, self.bottomBar.height);
    }
}

@end




