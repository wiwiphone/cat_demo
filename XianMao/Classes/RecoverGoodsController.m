//
//  RecoverGoodsController.m
//  XianMao
//
//  Created by apple on 16/3/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "RecoverGoodsController.h"
#import "TopTagView.h"
#import "ConfirmBackView.h"
#import "TagView.h"
#import "SettingFondController.h"
#import "DidPriceViewController.h"
#import "RecoverGoodsListCollectionCell.h"
#import "GoodsService.h"
#import "WCAlertView.h"

#import "Error.h"
#import "Masonry.h"

#import "RecommendView.h"
#import "IssueViewController.h"

@interface RecoverGoodsController () <ConfirmBackViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, RecoverLisdTableViewControllerDelegate>

@property (nonatomic, strong) UIButton *topTagBtn;
@property (nonatomic, strong) UIImageView *topTagImage;
@property (nonatomic, strong) TopTagView *topTagView;
@property (nonatomic, strong) ConfirmBackView *backView;
@property (nonatomic, strong) TagView *tagView;
@property (nonatomic, strong) UIView *classView;
@property (nonatomic, strong) UIButton *newsBtn;
@property (nonatomic, strong) UIButton *hotBtn;
@property (nonatomic, strong) UIButton *downBtn;
@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) CGFloat topBarHeigth;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) UIView *redCircleView;
@property (nonatomic, strong) NSMutableArray *preferenceInJsonArr;
@property (nonatomic, strong) RecoverGoodsListCollectionCell *collectionCell;
@property (nonatomic, assign) NSInteger topTag;


//修改UI&&逻辑 2016.3.31 Feng
@property (nonatomic, strong) RecommendView *recommendRecoeryView;
@property (nonatomic, strong) UIButton *offeredBtn;
@property (nonatomic, strong) UIView *erectView;
@property (nonatomic, strong) UIView *classBottomLineView;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property (nonatomic, assign) NSInteger scrollIndex;

@end

static NSString *RecoverCell = @"collectionCell";
@implementation RecoverGoodsController

-(UIView *)classBottomLineView{
    if (!_classBottomLineView) {
        _classBottomLineView = [[UIView alloc] initWithFrame:CGRectZero];
        _classBottomLineView.backgroundColor = [UIColor colorWithHexString:@"d7d7d7"];
    }
    return _classBottomLineView;
}

-(UIView *)erectView{
    if (!_erectView) {
        _erectView = [[UIView alloc] initWithFrame:CGRectZero];
        _erectView.backgroundColor = [UIColor colorWithHexString:@"727171"];
    }
    return _erectView;
}

-(UIButton *)offeredBtn{
    if (!_offeredBtn) {
        _offeredBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _offeredBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_offeredBtn setTitle:@"我的出价" forState:UIControlStateNormal];
        [_offeredBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        [_offeredBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        _offeredBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _offeredBtn.tag = 3;
    }
    return _offeredBtn;
}

-(RecommendView *)recommendRecoeryView{
    if (!_recommendRecoeryView) {
        _recommendRecoeryView = [[RecommendView alloc] initWithFrame:CGRectZero];
        _recommendRecoeryView.backgroundColor = [UIColor colorWithHexString:@"ffffff"];
        
    }
    return _recommendRecoeryView;
}



-(NSMutableArray *)preferenceInJsonArr{
    if (!_preferenceInJsonArr) {
        _preferenceInJsonArr = [[NSMutableArray alloc] init];
    }
    return _preferenceInJsonArr;
}

-(UIView *)redCircleView{
    if (!_redCircleView) {
        _redCircleView = [[UIView alloc] init];
        _redCircleView.layer.masksToBounds = YES;
        _redCircleView.layer.cornerRadius = 5;
        _redCircleView.backgroundColor = [UIColor redColor];
    }
    return _redCircleView;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.newsBtn.left + 10, self.classView.height - 2, self.newsBtn.width - 20, 2)];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
    }
    return _lineView;
}

-(UIButton *)hotBtn{
    if (!_hotBtn) {
        _hotBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _hotBtn = [[UIButton alloc] initWithFrame:CGRectZero];
//        [_hotBtn setTitle:@"最热" forState:UIControlStateNormal];
        [_hotBtn setTitle:@"即将下架" forState:UIControlStateNormal];
        [_hotBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        [_hotBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        _hotBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _hotBtn.tag = 2;
    }
    return _hotBtn;
}

-(UIButton *)newsBtn{
    if (!_newsBtn) {
        _newsBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_newsBtn setTitle:@"最新上架" forState:UIControlStateNormal];
        [_newsBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        [_newsBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        _newsBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _newsBtn.tag = 0;
    }
    return _newsBtn;
}

-(UIButton *)downBtn{
    if (!_downBtn) {
        _downBtn = [[UIButton alloc] initWithFrame:CGRectZero];
//        [_downBtn setTitle:@"即将下架" forState:UIControlStateNormal];
        [_downBtn setTitle:@"最热" forState:UIControlStateNormal];
        [_downBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        [_downBtn setTitleColor:[UIColor colorWithHexString:@"c2a79d"] forState:UIControlStateSelected];
        _downBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        _downBtn.tag = 1;
    }
    return _downBtn;
}

-(UIView *)classView{
    if (!_classView) {
        _classView = [[UIView alloc] initWithFrame:CGRectZero];
        _classView.backgroundColor = [UIColor whiteColor];
    }
    return _classView;
}

-(TagView *)tagView{
    if (!_tagView) {
        _tagView = [[TagView alloc] initWithFrame:CGRectZero];
        _tagView.backgroundColor = [UIColor whiteColor];
        _tagView.layer.masksToBounds = YES;
        _tagView.layer.cornerRadius = 5;
    }
    return _tagView;
}

-(ConfirmBackView *)backView{
    if (!_backView) {
        _backView = [[ConfirmBackView alloc] initWithFrame:CGRectZero];
        _backView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
    }
    return _backView;
}

-(TopTagView *)topTagView{
    if (!_topTagView) {
        _topTagView = [[TopTagView alloc] initWithFrame:CGRectZero];
    }
    return _topTagView;
}

-(UIImageView *)topTagImage{
    if (!_topTagImage) {
        _topTagImage = [[UIImageView alloc] initWithFrame:CGRectZero];
    }
    return _topTagImage;
}

-(UIButton *)topTagBtn{
    if (!_topTagBtn) {
        _topTagBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        _topTagBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [_topTagBtn setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
        [_topTagBtn setImage:[UIImage imageNamed:@"ArrImage_recoverGoods_MF"] forState:UIControlStateNormal];
        [_topTagBtn setTitle:@"所有" forState:UIControlStateNormal];
        [_topTagBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -_topTagBtn.imageView.image.size.width - 0, 0, _topTagBtn.imageView.image.size.width)];
        [_topTagBtn setImageEdgeInsets:UIEdgeInsetsMake(0, _topTagBtn.titleLabel.bounds.size.width + 40, 0, -_topTagBtn.titleLabel.bounds.size.width)];
        _topTagBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    }
    return _topTagBtn;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    [self.topTagView layoutSubviews];
    [self.tagView layoutSubviews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.recommendRecoeryView];
    
    
    CGFloat topBarHeigth = [super setupTopBar];
    self.topBarHeigth = topBarHeigth;
    [super setupTopBarBackButton];
    [super setupTopBarRightButton:[UIImage imageNamed:@"Add_Goods_recovery"] imgPressed:nil];
//    [super setupTopBarRightButton];
//    [self.topBarRightButton setTitle:@"我的出价" forState:UIControlStateNormal];
//    self.topBarRightButton.titleLabel.font = [UIFont systemFontOfSize:12.f];
//    self.topBarRightButton.backgroundColor = [UIColor clearColor];
//    [self.topBarRightButton setTitleColor:[UIColor colorWithHexString:@"595757"] forState:UIControlStateNormal];
//    [self.topBarRightButton sizeToFit];
    
    [self.view addSubview:self.classView];
    [self.classView addSubview:self.hotBtn];
    [self.classView addSubview:self.newsBtn];
    [self.classView addSubview:self.downBtn];
    [self.classView addSubview:self.offeredBtn];
    [self.classView addSubview:self.classBottomLineView];
    [self.classView addSubview:self.lineView];
    [self.classView addSubview:self.erectView];
    self.newsBtn.selected = YES;
    self.hotBtn.selected = NO;
    self.downBtn.selected = NO;
    [self.offeredBtn addTarget:self action:@selector(clickOfferedBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.newsBtn addTarget:self action:@selector(clickNewsBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.hotBtn addTarget:self action:@selector(clickHotBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.downBtn addTarget:self action:@selector(clickDowmBtn:) forControlEvents:UIControlEventTouchUpInside];
    
//    [self setupTopBarTitle:@"回收"];
    //修改 先去掉搜索  以后可能会添加
    [self.topBar addSubview:self.topTagBtn];
    [self.topBar addSubview:self.redCircleView];
    [self.topTagBtn addTarget:self action:@selector(clickTopTagBtn) forControlEvents:UIControlEventTouchUpInside];
//    [self.topBar addSubview:self.arrImageView];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - topBarHeigth - 42 - 138);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout = layout;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, topBarHeigth + 42   + 138, kScreenWidth, kScreenHeight - topBarHeigth - 42   - 138) collectionViewLayout:layout];
    [collectionView registerClass:[RecoverGoodsListCollectionCell class] forCellWithReuseIdentifier:RecoverCell];
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor  =[UIColor whiteColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.bounces = NO;
    collectionView.dataSource = self;
    collectionView.delegate = self;
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.view addSubview:self.backView];
    [self.view addSubview:self.topTagView];
    self.topTagView.hidden = YES;
    [self.topTagView bringSubviewToFront:self.backView];
    self.backView.hidden = YES;
    self.backView.alpha = 0;
    self.backView.confirmBackDelegate = self;
    
    [self.topTagView addSubview:self.tagView];
    
    WEAKSELF;
    [GoodsService getRecoverPreferenceCompletion:^(NSDictionary *dict) {
        NSMutableArray *preferenceInJsonArr = dict[@"get_recovery_preference_in_json"];
        if (preferenceInJsonArr.count > 0) {
            weakSelf.redCircleView.hidden = YES;
        } else {
            weakSelf.redCircleView.hidden = NO;
        }
    } failure:^(XMError *error) {
        
    }];
    
    self.tagView.pushFondControllerBlock = ^(){
        SettingFondController *fondController = [[SettingFondController alloc] init];
        [weakSelf pushViewController:fondController animated:YES];
    };
    
//    [self loadData];
    [self setUpUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadDataPreference];
    WEAKSELF;
    [GoodsService getRecoverPreferenceCompletion:^(NSDictionary *dict) {
        NSMutableArray *preferenceInJsonArr = dict[@"get_recovery_preference_in_json"];
        weakSelf.preferenceInJsonArr = preferenceInJsonArr;
        if (preferenceInJsonArr.count == 0) {
            [WCAlertView showAlertWithTitle:@"提示" message:@"当前没有设置偏好，是否进行设置" customizationBlock:^(WCAlertView *alertView) {
                
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex == 0) {
                    
                } else if (buttonIndex == 1) {
                    SettingFondController *fondController = [[SettingFondController alloc] init];
                    [weakSelf pushViewController:fondController animated:YES];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
            weakSelf.redCircleView.hidden = NO;
            [weakSelf.tagView clickAllBtn];
        } else {
            weakSelf.redCircleView.hidden = YES;
//            [weakSelf.collectionCell.listTableViewController getJsonArr:preferenceInJsonArr];
            //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPreferenceInJsonArr" object:preferenceInJsonArr];
        }
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
    }];
}

-(void)loadDataPreference{
    WEAKSELF;
    self.tagView.dismissTagViewBlock = ^(NSInteger index){
        [weakSelf dissMissConBackView];
        if (index == nil) {
            index = weakSelf.topTag;
        }
        if (index == 1) {
            [weakSelf.topTagBtn setTitle:@"所有" forState:UIControlStateNormal];
//            NSNumber *num = [NSNumber numberWithInteger:1];
            weakSelf.topTag = index;
            [weakSelf.collectionCell.listTableViewController getJsonArr:nil];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPreferenceInJsonArr" object:num];
        } else if (index == 2) {
            [weakSelf.topTagBtn setTitle:@"我偏好的" forState:UIControlStateNormal];
            weakSelf.topTag = index;
            BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkLoginStateAndPresentLoginController:self completion:^{
                
            }];
            if (isLoggedIn) {
                [GoodsService getRecoverPreferenceCompletion:^(NSDictionary *dict) {
                    NSMutableArray *preferenceInJsonArr = dict[@"get_recovery_preference_in_json"];
                    weakSelf.preferenceInJsonArr = preferenceInJsonArr;
                    if (preferenceInJsonArr.count == 0) {
                        [WCAlertView showAlertWithTitle:@"提示" message:@"当前没有设置偏好，是否进行设置" customizationBlock:^(WCAlertView *alertView) {
                            
                        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                            if (buttonIndex == 0) {
                                
                            } else if (buttonIndex == 1) {
                                SettingFondController *fondController = [[SettingFondController alloc] init];
                                [weakSelf pushViewController:fondController animated:YES];
                            }
                        } cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
                        weakSelf.redCircleView.hidden = NO;
                        [weakSelf.tagView clickAllBtn];
                    } else {
                        weakSelf.redCircleView.hidden = YES;
                        [weakSelf.collectionCell.listTableViewController getJsonArr:preferenceInJsonArr];
                        //                        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPreferenceInJsonArr" object:preferenceInJsonArr];
                    }
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                }];
            } else {
                
            }
        }
        weakSelf.index = index;
        [weakSelf.topTagBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, - weakSelf.topTagBtn.imageView.image.size.width - 5, 0, weakSelf.topTagBtn.imageView.image.size.width)];
        [weakSelf.topTagBtn setImageEdgeInsets:UIEdgeInsetsMake(0, weakSelf.topTagBtn.titleLabel.bounds.size.width + 5, 0, - weakSelf.topTagBtn.titleLabel.bounds.size.width)];
        weakSelf.topTagBtn.imageView.transform = CGAffineTransformMakeRotation(0);
    };
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getPrefereceData{
    WEAKSELF;
    if (self.index == 2) {
        [GoodsService getRecoverPreferenceCompletion:^(NSDictionary *dict) {
            NSMutableArray *preferenceInJsonArr = dict[@"get_recovery_preference_in_json"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"getPreferenceInJsonArr" object:preferenceInJsonArr];
            [weakSelf.collectionCell.listTableViewController getJsonArr:preferenceInJsonArr];
            if (preferenceInJsonArr.count > 0) {
                weakSelf.redCircleView.hidden = YES;
            } else {
                weakSelf.redCircleView.hidden = NO;
            }
        } failure:^(XMError *error) {
            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
        }];
    } else {
        NSNumber *num = [NSNumber numberWithInteger:1];
        NSMutableArray *emptyArr = [NSMutableArray array];
        [weakSelf.collectionCell.listTableViewController getJsonArr:emptyArr];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"getPreferenceInJsonArr" object:num];
    }
    
}

-(void)clickOfferedBtn:(UIButton *)sender{
    [ClientReportObject clientReportObjectWithViewCode:RecoveryGoodsViewCode regionCode:MineOfferedViewCode referPageCode:MineOfferedViewCode andData:nil];
    DidPriceViewController *priceViewController = [[DidPriceViewController alloc] init];
    [self pushViewController:priceViewController animated:YES];
}

-(void)clickNewsBtn:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.newsBtn.selected = YES;
        self.hotBtn.selected = NO;
        self.downBtn.selected = NO;
        self.lineView.frame = CGRectMake(self.newsBtn.left + 10, self.classView.height - 4, self.newsBtn.width - 20, 2);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)clickHotBtn:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.newsBtn.selected = NO;
        self.hotBtn.selected = YES;
        self.downBtn.selected = NO;
        self.lineView.frame = CGRectMake(self.hotBtn.left + 10, self.classView.height - 4, self.hotBtn.width - 20, 2);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)clickDowmBtn:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:sender.tag inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
    [UIView animateWithDuration:0.25 animations:^{
        self.newsBtn.selected = NO;
        self.hotBtn.selected = NO;
        self.downBtn.selected = YES;
        self.lineView.frame = CGRectMake(self.downBtn.left + 10, self.classView.height - 4, self.downBtn.width - 20, 2);
    } completion:^(BOOL finished) {
        
    }];
}

-(void) setUpUI{
//    [self.topBarRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.topBar.mas_right).offset(-5);
//        make.centerY.equalTo(self.topBar.mas_centerY).offset(10);
//        make.width.equalTo(@100);
//        make.height.equalTo(@30);
//    }];
    
    [self.topTagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@200);
        make.centerY.equalTo(self.topBarRightButton.mas_centerY);
        make.centerX.equalTo(self.topBar.mas_centerX);
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    self.topTagView.frame = CGRectMake(kScreenWidth/2 - 110, self.topBarHeigth, 220, 0);
    self.tagView.frame = CGRectMake(0, 9, self.topTagView.width, self.topTagView.height - 9);
    
    [self.redCircleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.topTagBtn.imageView.mas_right).offset(5);
        make.centerY.equalTo(self.topTagBtn.mas_centerY);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
    
    [self.recommendRecoeryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topBar.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@(138));
    }];
    
    [self.classView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.recommendRecoeryView.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(@42);
    }];
    
    [self.classBottomLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.classView.mas_left);
        make.right.equalTo(self.classView.mas_right);
        make.bottom.equalTo(self.classView.mas_bottom).offset(-2);
        make.height.equalTo(@1);
    }];
    
    [self.offeredBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classView.mas_centerY);
        make.right.equalTo(self.view.mas_right);
        make.width.equalTo(@(kScreenWidth / 4));
    }];
    
    [self.newsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classView.mas_centerY);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.hotBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classView.mas_centerY);
        make.right.equalTo(self.offeredBtn.mas_left);
        make.width.equalTo(@(kScreenWidth/4));
    }];
    
    [self.downBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.classView.mas_centerY);
        make.left.equalTo(self.newsBtn.mas_right);
        make.right.equalTo(self.hotBtn.mas_left);
    }];
    
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.newsBtn.mas_centerX);
        make.bottom.equalTo(self.classView.mas_bottom).offset(-2);
        make.height.equalTo(@2);
        make.width.equalTo(self.newsBtn.mas_width).offset(-20);
    }];
    
    [self.erectView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.classView.mas_top).offset(10);
        make.bottom.equalTo(self.classView.mas_bottom).offset(-10);
        make.left.equalTo(self.offeredBtn.mas_left);
        make.width.equalTo(@1);
    }];
//    self.lineView.frame = CGRectMake(self.newsBtn.left + 10, self.classView.height - 2, self.newsBtn.width - 20, 2);
    [self.view setNeedsLayout];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 3;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecoverGoodsListCollectionCell *collectionCell = [collectionView dequeueReusableCellWithReuseIdentifier:RecoverCell forIndexPath:indexPath];
    self.collectionCell = collectionCell;
    collectionCell.listTableViewController.recovertListDelegate = self;
    if (indexPath.item == 0) {
        collectionCell.listTableViewController.qk = @"createTime";
        collectionCell.listTableViewController.qv = @"DESC";
        collectionCell.listTableViewController.seletedIndex = 0;
        [ClientReportObject clientReportObjectWithViewCode:RecoveryGoodsViewCode regionCode:RecoveryGoodsNewViewCode referPageCode:RecoveryGoodsNewViewCode andData:nil];
    } else if (indexPath.item == 2) {
        collectionCell.listTableViewController.qk = @"downTimeSlot";  //根据需求对调位置
        collectionCell.listTableViewController.qv = @"ASC";
        collectionCell.listTableViewController.seletedIndex = 2;
        [ClientReportObject clientReportObjectWithViewCode:RecoveryGoodsViewCode regionCode:RecoveryGoodsDownViewCode referPageCode:RecoveryGoodsDownViewCode andData:nil];
    } else if (indexPath.item == 1) {
        collectionCell.listTableViewController.qk = @"offerCount";
        collectionCell.listTableViewController.qv = @"DESC";
        collectionCell.listTableViewController.seletedIndex = 1;
        [ClientReportObject clientReportObjectWithViewCode:RecoveryGoodsViewCode regionCode:RecoveryGoodsHotViewCode referPageCode:RecoveryGoodsHotViewCode andData:nil];
    }
    
    [self getPrefereceData];
    
//    [collectionCell.listTableViewController initDataListLogic];
//    [collectionCell.listTableViewController.tableView reloadData];
    
    return collectionCell;
}

-(void)changeTableViewHeight:(CGFloat)scrollIndex{
    self.scrollIndex = scrollIndex;
    if (scrollIndex > 500) {
        if (scrollIndex >= 0+500 && scrollIndex < 545+500) {
            self.collectionView.frame = CGRectMake(0, self.topBarHeigth + 42   + 138 - (scrollIndex-500) / 4, kScreenWidth, kScreenHeight - self.topBarHeigth - 42   - 138 + (scrollIndex-500) / 2);
            //        self.layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - self.topBarHeigth - 42 - 138 + scrollIndex / 2);
            self.classView.frame = CGRectMake(0, self.topBarHeigth + 138 - (scrollIndex-500)/4, self.classView.width, self.classView.height);
            self.recommendRecoeryView.frame = CGRectMake(0, self.topBarHeight - (scrollIndex-500) / 4, self.recommendRecoeryView.width, self.recommendRecoeryView.height);
        }
    } else {
        self.collectionView.frame = CGRectMake(0, self.topBarHeigth + 42   + 138, kScreenWidth, kScreenHeight - self.topBarHeigth - 42   - 138 );
        //        self.layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight - self.topBarHeigth - 42 - 138 + scrollIndex / 2);
        self.classView.frame = CGRectMake(0, self.topBarHeigth + 138, self.classView.width, self.classView.height);
        self.recommendRecoeryView.frame = CGRectMake(0, self.topBarHeight, self.recommendRecoeryView.width, self.recommendRecoeryView.height);
    }
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    [self getPrefereceData];
    NSInteger index = scrollView.contentOffset.x / kScreenWidth;
    if (index == 2) {
        [UIView animateWithDuration:0.25 animations:^{
            self.newsBtn.selected = NO;
            self.hotBtn.selected = YES;
            self.downBtn.selected = NO;
            self.lineView.frame = CGRectMake(self.hotBtn.left + 10, self.classView.height - 4, self.hotBtn.width - 20, 2);
        } completion:^(BOOL finished) {
            
        }];
    } else if (index == 1) {
        [UIView animateWithDuration:0.25 animations:^{
            self.newsBtn.selected = NO;
            self.hotBtn.selected = NO;
            self.downBtn.selected = YES;
            self.lineView.frame = CGRectMake(self.downBtn.left + 10, self.classView.height - 4, self.downBtn.width - 20, 2);
        } completion:^(BOOL finished) {
            
        }];
    } else if (index == 0) {
        [UIView animateWithDuration:0.25 animations:^{
            self.newsBtn.selected = YES;
            self.hotBtn.selected = NO;
            self.downBtn.selected = NO;
            self.lineView.frame = CGRectMake(self.newsBtn.left + 10, self.classView.height - 4, self.newsBtn.width - 20, 2);
        } completion:^(BOOL finished) {
            
        }];
    }
}

-(void)clickTopTagBtn{
    [self.tagView getPreferenceArr:self.preferenceInJsonArr];
    self.backView.hidden = NO;
    self.topTagView.hidden = NO;
    [UIView animateWithDuration:0.25 animations:^{
        self.topTagBtn.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        self.backView.alpha = 1;
        self.topTagView.frame = CGRectMake(kScreenWidth/2 - 110, self.topBarHeigth, 220, 174);
        self.tagView.frame = CGRectMake(0, 9, self.topTagView.width, self.topTagView.height - 9);
    }];
    
}

-(void)handleTopBarRightButtonClicked:(UIButton *)sender{
    NSDictionary *data = @{@"type":@0};
    [ClientReportObject clientReportObjectWithViewCode:RecoveryGoodsViewCode regionCode:PublishRecoveryRegionCode referPageCode:PublishRecoveryRegionCode andData:data];
    IssueViewController *issureViewController = [[IssueViewController alloc] init];
    issureViewController.titleText = @"求回收";
    issureViewController.releaseIndex = YES;
    [self pushViewController:issureViewController animated:YES];
}

-(void)dissMissConBackView{
    [UIView animateWithDuration:0.25 animations:^{
        self.topTagBtn.imageView.transform = CGAffineTransformMakeRotation(0);
        self.backView.alpha = 0;
        self.topTagView.frame = CGRectMake(kScreenWidth/2 - 110, self.topBarHeigth, 220, 0);
        self.tagView.frame = CGRectMake(0, 9, self.topTagView.width, 0);
    } completion:^(BOOL finished) {
        self.backView.hidden = YES;
        self.topTagView.hidden = YES;
    }];
}

@end
