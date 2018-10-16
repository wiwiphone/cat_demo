//
//  ForumPoatCatHouseControllerTwo.m
//  XianMao
//
//  Created by apple on 15/12/30.
//  Copyright © 2015年 XianMao. All rights reserved.
//

#import "ForumPoatCatHouseControllerTwo.h"
#import "ForumPostCatHouseTopView.h"
#import "ForumPublishViewController.h"
#import "ForumTopicVO.h"

#import "ForumService.h"
#import "Command.h"
#import "Session.h"

#import "ForumPostTableViewCell.h"
#import "ForumPostCatHouseCell.h"
#import "DataListLogic.h"

#import "ForumOneSelfController.h"

#import "Error.h"
#import "JSONKit.h"

#import "NSString+URLEncoding.h"
#import "WCAlertView.h"

#import "NSString+Addtions.h"
#import "UIActionSheet+Blocks.h"
#import "LoginViewController.h"

@interface ForumPoatCatHouseControllerTwo () <ForumPostCatHouseTopViewDelegate, UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic,strong) NSArray *topicArray;
@property (nonatomic, assign) NSInteger text;
@property (nonatomic, strong) ForumPostVO *postVO;

@property(nonatomic,strong) NSMutableArray *catHouseVOArray;
@property (nonatomic, assign) CGFloat topBarHeight;

@property (nonatomic, strong) NSMutableArray *cammerArray;
@property (nonatomic, copy) NSString *UrlStr;
@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSMutableArray *titles;
@end


static NSString *ID = @"MFCell";
@implementation ForumPoatCatHouseControllerTwo

{
    CGFloat _selectedTitlesWidth;
}

-(NSMutableArray *)titles{
    if (!_titles) {
        _titles = [[NSMutableArray alloc] init];
    }
    return _titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat topBarHeight = [super setupTopBar];
    self.topBarHeight = topBarHeight;
//    self.text = 0;
    [self setupTopBarTitle:@"喵窝"];
    
    [ForumService getTopicTopData:^(NSMutableArray *topic) {
        self.cammerArray = topic;
    } failure:^(XMError *error) {
        
    }];
    
    UIButton *backTopBtn = [[UIButton alloc] initWithFrame:CGRectMake(kScreenWidth / 2 - 50, 0, 100, topBarHeight)];
    [self.topBar addSubview:backTopBtn];
    [backTopBtn addTarget:self action:@selector(backTop) forControlEvents:UIControlEventTouchUpInside];
    
    _catHouseVOArray = [[NSMutableArray alloc] init];
    
    CommandButton *iconButton = [[CommandButton alloc] initWithFrame:CGRectMake(15, 23, 36, 36)];
    iconButton.layer.masksToBounds = YES;
    iconButton.layer.cornerRadius = 18;
    iconButton.backgroundColor = [UIColor grayColor];
    [iconButton addTarget:self action:@selector(clickIconButton) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:iconButton];
    self.iconButton = iconButton;
    [iconButton setImage:[UIImage imageNamed:@"placeholder_mine.png"] forState:UIControlStateNormal];
//    WEAKSELF;
//    [ForumService getTopicAvatar:^(ForumTopicAvatar *topic) {
//        [iconButton sd_setImageWithURL:[NSURL URLWithString:topic.avatar] forState:UIControlStateNormal completed:nil];
//    } failure:^(XMError *error) {
//        
//    }];
    
    //    CGFloat hegight = self.topBarRightButton.height;
    CommandButton *cammerButton = [[CommandButton alloc] initWithFrame:CGRectMake(self.topBar.width-15-47, 15, 80, 50)];
    cammerButton.imageEdgeInsets = UIEdgeInsetsMake(11, 21, 11, 31);
    //    cammerButton.backgroundColor = [UIColor lightGrayColor];
    [cammerButton setImage:[UIImage imageNamed:@"forum_publish_camera_icon"] forState:UIControlStateNormal];
    [cammerButton addTarget:self action:@selector(clickCammerButton) forControlEvents:UIControlEventTouchUpInside];

//    iconButton.handleClickBlock = ^(CommandButton *sender) {
//        
//    };
    [self.topBar addSubview:cammerButton];
    self.cammerButton = cammerButton;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(70, 35);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
//    [layout estimatedItemSize];
    
    ForumPostCatHouseTopView *topCollectionView = [[ForumPostCatHouseTopView alloc] initWithFrame:CGRectMake(0, topBarHeight, kScreenWidth, 35) collectionViewLayout:layout];
    topCollectionView.showsHorizontalScrollIndicator = NO;
//    topCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
//    topCollectionView.backgroundColor = [UIColor lightGrayColor];
    topCollectionView.userInteractionEnabled = YES;
    topCollectionView.catHouseDelegate = self;
    [self.view addSubview:topCollectionView];
    _topCollectionView = topCollectionView;
    
    UICollectionViewFlowLayout *layoutC = [[UICollectionViewFlowLayout alloc] init];
    layoutC.itemSize = CGSizeMake(kScreenWidth, self.view.height - topBarHeight - topCollectionView.height);
    layoutC.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layoutC.minimumInteritemSpacing = 0;
    layoutC.minimumLineSpacing = 0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:layoutC];
    collectionView.frame = CGRectMake(0, topBarHeight + topCollectionView.height, kScreenWidth, self.view.height - topBarHeight - topCollectionView.height);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor  =[UIColor whiteColor];
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[ForumPostCatHouseCell class] forCellWithReuseIdentifier:ID];
    [self.view addSubview:collectionView];
    _collectionView= collectionView;
    

    
    //没有登陆的“我关注的”页面
//    if (![Session sharedInstance].currentUserId) {
//        UIView *deSuportView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight + self.topCollectionView.height, kScreenWidth, self.view.height - topBarHeight - self.topCollectionView.height)];
//        deSuportView.backgroundColor = [UIColor orangeColor];
//        [self.collectionView addSubview:deSuportView];
//    }
    
    [self showLoadingView];
    
    WEAKSELF;
    [ForumService getTopiccompletion:^(NSMutableArray *topicArray, NSString *avatarUrl) {
        [weakSelf hideLoadingView];
        weakSelf.topicArray = [[NSMutableArray alloc] initWithArray:topicArray];
        [weakSelf.topCollectionView reloadData:topicArray];
        
        for (ForumTopicVO *forumTopicVO in topicArray) {
            ForumPostCatHouseVO *catHouseVO = [[ForumPostCatHouseVO alloc] init];
            catHouseVO.topicVO = forumTopicVO;
//            self.topic_id = forumTopicVO.topic_id;
            catHouseVO.dataSources = [[NSMutableArray alloc] init];
            NSMutableArray *paramsArray = [[NSMutableArray alloc] init];
            
            [self.titles addObject:forumTopicVO.title];
            
            if (forumTopicVO.filterList.count == 0) {
                
            } else {
//                [paramsArray addObjectsFromArray:forumTopicVO.filterList[0]];
                [paramsArray addObject:forumTopicVO.filterList[0]];
            }
            
            NSString *paramsJsonData = [[[paramsArray toJSONArray] JSONString] URLEncodedString];
            NSString *keywords = @"";
            catHouseVO.dataListLogic  = [[DataListLogic alloc] initWithModulePath:@"forum" path:@"post_list" pageSize:20];
            catHouseVO.dataListLogic.parameters = @{@"params":paramsJsonData, @"topic_id":[NSNumber numberWithInteger:forumTopicVO.topic_id],@"keywords":keywords};
            catHouseVO.dataListLogic.cacheStrategy = [[DataListCacheArray alloc] init];
            [weakSelf.catHouseVOArray addObject:catHouseVO];
        }
        
        [self getButtonsWidthWithTitles:self.titles];
        [weakSelf.collectionView reloadData];
        
        [weakSelf.iconButton sd_setImageWithURL:[NSURL URLWithString:avatarUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_mine.png"]];
        NSString *UrlStr = avatarUrl;
        self.UrlStr = UrlStr;
    } failure:^(XMError *error) {
        
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickCammer) name:@"pushCammerTopIconCortroller" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setIconImage:) name:@"setIconImageView" object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.iconButton sd_setImageWithURL:[NSURL URLWithString:self.UrlStr] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_mine.png"]];
}

//-(void)setIconImage:(NSString *)avatar{
//    [self.iconButton sd_setImageWithURL:[NSURL URLWithString:avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"placeholder_mine.png"]];
//}

//-(CGSize)preferredContentSize{
//    [super preferredContentSize];
//    
//    
//    
//}

-(void)clickCammer{
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{
        
    }];
    if (!isLoggedIn) {
        return;
    }
    ForumPublishViewController *viewController = [[ForumPublishViewController alloc] init];
    viewController.topic_id = 1;
    viewController.topic_array = self.cammerArray;
    [self pushViewController:viewController animated:YES];
    viewController.handlePublishedBlock = ^(ForumPostVO *postVO) {
//        NSDictionary *dict = @{@"topicArr" : topic};
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushCammerController" object:postVO];
    };
    
}


-(void)backTop{
//    if ([self.delegateCatHouse respondsToSelector:@selector(backTopMethod)]) {
//        [self.delegateCatHouse backTopMethod];
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"backTop" object:nil];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.catHouseVOArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ForumPostCatHouseCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    

    ForumPostCatHouseVO *catHouseVO = [self.catHouseVOArray objectAtIndex:[indexPath row]];
    
    [cell updateWithTopic:catHouseVO];
    
    return cell;
}


-(void)clickIconButton{
    NSLog(@"点击了iconButton");
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{
        
    }];
    if (!isLoggedIn) {
        return;
    }
    
    ForumOneSelfController *oneSelfController = [[ForumOneSelfController alloc] init];
    oneSelfController.user_id = [Session sharedInstance].currentUserId;
    [self pushViewController:oneSelfController animated:YES];
}

-(void)clickCammerButton{
    NSLog(@"点击了cammerButton");
    BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{
        
    }];
    if (!isLoggedIn) {
        return;
    }
    WEAKSELF;
    [ForumService getTopicTopData:^(NSMutableArray *topic) {
        NSLog(@"%@", topic);
        NSMutableArray *arr = [NSMutableArray array];
        ForumCatHouseTopData *topData;
        for (ForumCatHouseTopData *topDatas in topic) {
            topData = topDatas;
            [arr addObject:topDatas.title];
        }
        [UIActionSheet showInView:self.view
                        withTitle:nil
                cancelButtonTitle:@"取消"
           destructiveButtonTitle:nil
                otherButtonTitles:arr
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex) {
                             
                             if (buttonIndex<[arr count]) {
                                 ForumPublishViewController *viewController = [[ForumPublishViewController alloc] init];
                                 ForumCatHouseTopData *topData = [topic objectAtIndex:buttonIndex];
                                 
                                 viewController.title = topData.title;
                                 viewController.topic_id = topData.topic_id;
                                 viewController.topic_array = topic;
                                 viewController.prompt = topData.bottom_tips;
                                 
                                 [weakSelf pushViewController:viewController animated:YES];
                                 viewController.handlePublishedBlock = ^(ForumPostVO *postVO) {
                                     NSDictionary *dict = @{@"topicArr" : topic};
                                     [[NSNotificationCenter defaultCenter] postNotificationName:@"pushCammerController" object:postVO userInfo:dict];
                                 };
                             }
                             
                         }];
        
        
//这个方法只是支持ios7以上
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
//        for (ForumCatHouseTopData *topData in topic) {
//            UIAlertAction *action = [UIAlertAction actionWithTitle:topData.title style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
////                NSLog(@"回调相机");
//                WEAKSELF;
//                ForumPublishViewController *viewController = [[ForumPublishViewController alloc] init];
//                
//                viewController.title = topData.title;
//                viewController.topic_id = topData.topic_id;
//                viewController.topic_array = topic;
//                viewController.prompt = topData.enter_tip;
//                
//                [weakSelf pushViewController:viewController animated:YES];
//                
//                viewController.handlePublishedBlock = ^(ForumPostVO *postVO) {
//                NSDictionary *dict = @{@"topicArr" : topic};
////                [[NSNotificationCenter defaultCenter] postNotificationName:@"pushCammerController" object:topData userInfo:dict];
//                    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushCammerController" object:postVO userInfo:dict];
//
//                };
//            }];
//            [alert addAction:action];
//        }
//        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alert addAction:action1];
//        [self presentViewController:alert animated:YES completion:nil];
//        [self pushViewController:alert animated:YES];
        
    } failure:^(XMError *error) {
        
    }];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    
//}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//- (void)publishPostImpl {
//    ForumPublishViewController *viewController = [[ForumPublishViewController alloc] init];
//    viewController.title = self.topicVO.publish_title;
//    viewController.topic_id = self.topicVO.topic_id;
//    [self pushViewController:viewController animated:YES];
//    WEAKSELF;
//    viewController.handlePublishedBlock = ^(ForumPostVO *postVO) {
//        [weakSelf showHUD:@"发布成功" hideAfterDelay:0.8f];
//        NSMutableArray *dataSources = [NSMutableArray arrayWithArray:weakSelf.dataSources];
//        if ([dataSources count]>=2 && [weakSelf.topicVO.head_text length]>0) {
//            [dataSources insertObject:[ForumPostTableSepCell buildCellDict] atIndex:2];
//            [dataSources insertObject:[ForumPostTableViewCellWithReply buildCellDict:postVO forumTopicVO:weakSelf.topicVO] atIndex:2];
//        } else {
//            [dataSources insertObject:[ForumPostTableSepCell buildCellDict] atIndex:0];
//            [dataSources insertObject:[ForumPostTableViewCellWithReply buildCellDict:postVO forumTopicVO:weakSelf.topicVO] atIndex:0];
//            [dataSources insertObject:[ForumPostSearchTableCell buildCellDict] atIndex:0];
//        }
//        weakSelf.dataSources = dataSources;
//        [weakSelf.tableView reloadData];
//        [weakSelf hideLoadingView];
//    };
//}


- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
//    [self.topCollectionView selectAtIndex:indexPath.row];
//    NSLog(@"%ld", indexPath.row);
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
//    self.index = index;
    [self.topCollectionView selectAtIndex:index];
}

- (NSArray *)getButtonsWidthWithTitles:(NSArray *)titles;
{
    NSMutableArray *widths = [@[] mutableCopy];
    _selectedTitlesWidth = 0;
    for (NSString *title in titles)
    {
        CGSize size = [title boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} context:nil].size;
        CGFloat eachButtonWidth = size.width + 20.f;
        _selectedTitlesWidth += eachButtonWidth;
        NSNumber *width = [NSNumber numberWithFloat:eachButtonWidth];
        [widths addObject:width];
    }
    if (_selectedTitlesWidth < kScreenWidth) {
        [widths removeAllObjects];
        NSNumber *width = [NSNumber numberWithFloat:kScreenWidth / titles.count];
        for (int index = 0; index < titles.count; index++) {
            [widths addObject:width];
        }
    }
    return widths;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x/kScreenWidth;
    
    UILabel *label = [[UILabel alloc] init];
    
    
    NSInteger seletedWidth = 20;
    for (int i = 0; i < index + 1; i++) {
        ForumTopicVO *topicVo = self.topicArray[i];
        label.text = topicVo.title;
        label.font = [UIFont systemFontOfSize:16.f];
        [label sizeToFit];
        seletedWidth += label.centerX;
    }
    
    CGFloat offsetX = seletedWidth + 50 - kScreenWidth * 0.5;
    NSLog(@"%.2f", offsetX);
    CGFloat offsetMax = _selectedTitlesWidth - kScreenWidth + 10;
    if (offsetX < 0 || offsetMax < 0) {
        offsetX = 0;
    } else if (offsetX > offsetMax){
        offsetX = offsetMax;
    }
    
    if (index >= 0 && index < self.topicArray.count / 2) {
        [self.topCollectionView setContentOffset:CGPointMake(-10, 0) animated:YES];
    } else {
        [self.topCollectionView setContentOffset:CGPointMake(offsetMax + 2, 0) animated:YES];
    }
    self.text = index;
    self.topCollectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
}

-(void)scrollCollectionViewCell:(ForumTopicVO *)topic andIndexPath:(NSIndexPath *)indexPath{
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

/*
 //    if (index > self.text) {
 //        [UIView animateWithDuration:0.25 animations:^{
 //            weakSelf.topCollectionView.contentInset = UIEdgeInsetsMake(0, -index * 21 + 10, 0, -100);
 //        }];
 //
 //    }
 //    if (index < self.text) {
 //        [UIView animateWithDuration:0.25 animations:^{
 //            weakSelf.topCollectionView.contentInset = UIEdgeInsetsMake(0, -index * 21 + 10, 0, -100);
 //        }];
 //
 //    }
 //
 //    NSLog(@"%ld, %ld", self.text, index);
 //    self.text = index;
 */
@end
