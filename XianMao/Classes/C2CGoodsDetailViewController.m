//
//  C2CGoodsDetailViewController.m
//  XianMao
//
//  Created by apple on 16/9/8.
//  Copyright © 2016年 XianMao. All rights reserved.
//

#import "C2CGoodsDetailViewController.h"
#import "PullRefreshTableView.h"
#import "BaseTableViewCell.h"
#import "DataListLogic.h"
#import "GoodsBasisCell.h"
#import "SepTableViewCell.h"
#import "GoodsPictureCell.h"
#import "GoodsLikeCell.h"
#import "GoodsExplainCell.h"
#import "GoodsDetailPictureCell.h"
#import "GoodsAttributesCell.h"
#import "GoodsDetailSelfEngageCell.h"
#import "GoodsDetailTableViewCell.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "GoodsDetailInfo.h"
#import "MessageTitleCell.h"
#import "MessageCell.h"
#import "SellerInfoTableViewCell.h"
#import "GoodsBottomView.h"
#import "Session.h"
#import "ServiceIconCell.h"
#import "ShoppingCartViewController.h"
#import "BlackView.h"
#import "WristInviteView.h"
#import "AddBagView.h"
#import "LoginViewController.h"
#import "SupportCell.h"
#import "GoodsMemCache.h"
#import "ForumInputToolBar.h"
#import "ForumAttachView.h"
#import "NSString+Addtions.h"
#import "GoodsService.h"
#import "GoodsCommentsViewController.h"
#import "BuyBackCell.h"
#import "MJPhotoBrowser.h"
#import "ASScroll.h"
#import "MJPhoto.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "AboutViewController.h"
#import "URLScheme.h"
#import "TagsExplanView.h"
#import "ExpectedDeliveryCell.h"
#import "PicSuccess.h"
#import "SYFireworksButton.h"
#import "ParabolaTool.h"
#import "C2CGoodsPriceView.h"
#import "DeliveryExplainCell.h"
#import "ActivityInfo.h"
#import "C2CActivityCell.h"
#import "PublishViewController.h"

@interface C2CGoodsDetailViewController () <UITableViewDataSource, UITableViewDelegate, PullRefreshTableViewDelegate, ForumInputToolBarDelegate, DXChatBarMoreViewDelegate, UIGestureRecognizerDelegate, ASScrollViewDelegate,ParabolaToolDelegate>

@property (nonatomic, strong) PullRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSources;
@property (nonatomic, strong) DataListLogic *dataListLogic;

@property (nonatomic, strong) GoodsBottomView *bottomView;
@property (nonatomic, strong) HTTPRequest *request;
@property (nonatomic, strong) UIButton *goodsNumLbl;
@property (nonatomic, assign) NSInteger canPay;

@property (nonatomic, strong) BlackView *inviteBlackView;
@property (nonatomic, strong) WristInviteView *wristInviteView;
@property (nonatomic, strong) AddBagView *addBagView;
@property (nonatomic, strong) BlackView *blackView;

@property (nonatomic, strong) GoodsDetailInfo *detailInfo;
@property (nonatomic, strong) GoodsInfo *goodsInfo;
@property (nonatomic, strong) ForumInputToolBar *toolBar;
@property (nonatomic, strong) ForumAttachContainerView *attachContainerView;
@property(nonatomic,assign) NSInteger reply_user_id;

@property (nonatomic, strong) NSMutableArray *commentsList;
@property (nonatomic, assign) NSInteger isOpen;
@property (nonatomic, strong) ASScroll *scrollImageView;
@property (nonatomic, strong) NSMutableArray *gallaryItems;
@property (nonatomic, strong) NSMutableArray *imageViews;

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;

@property(nonatomic, strong) TagsExplanView *tagsExplainView;
@property (nonatomic, strong) BlackView *bgView;
@property (nonatomic, assign) CGFloat topbarHeight;
@property (nonatomic, strong) PicSuccess *PicTextSuccessView;
@property (nonatomic, strong) CommandButton *disPicSuccessView;
@property (nonatomic, strong) UIImageView * animationImage;
@property (nonatomic, strong) C2CGoodsPriceView * goodsPriceView;
@end

@implementation C2CGoodsDetailViewController

-(AddBagView *)addBagView{
    if (!_addBagView) {
        _addBagView = [[AddBagView alloc] initWithFrame:CGRectZero];
        _addBagView.backgroundColor = [UIColor whiteColor];
    }
    return _addBagView;
}

-(C2CGoodsPriceView *)goodsPriceView
{
    if (!_goodsPriceView) {
        _goodsPriceView = [[C2CGoodsPriceView alloc] initWithFrame:CGRectMake(100, 20, kScreenWidth-100-100, 44)];
        _goodsPriceView.hidden = YES;
    }
    return _goodsPriceView;
}

-(BlackView *)blackView{
    if (!_blackView) {
        _blackView = [[BlackView alloc] initWithFrame:CGRectZero];
    }
    return _blackView;
}

-(BlackView *)bgView{
    if (!_bgView) {
        _bgView = [[BlackView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    }
    return _bgView;
}

-(TagsExplanView *)tagsExplainView{
    if (!_tagsExplainView) {
        _tagsExplainView = [[TagsExplanView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, 310)];
        _tagsExplainView.backgroundColor = [UIColor whiteColor];
    }
    return _tagsExplainView;
}

-(NSArray *)titles{
    if (!_titles) {
        _titles = [[NSArray alloc] init];
    }
    return _titles;
}

-(NSArray *)images{
    if (!_images) {
        _images = [[NSArray alloc] init];
    }
    return _images;
}

-(NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = [[NSMutableArray alloc] init];
    }
    return _imageViews;
}

-(NSMutableArray *)gallaryItems{
    if (!_gallaryItems) {
        _gallaryItems = [[NSMutableArray alloc] init];
    }
    return _gallaryItems;
}

-(ASScroll *)scrollImageView{
    if (!_scrollImageView) {
        _scrollImageView = [[ASScroll alloc] initWithFrame:CGRectZero];
        _scrollImageView.delegate = self;
    }
    return _scrollImageView;
}

-(NSMutableArray *)commentsList{
    if (!_commentsList) {
        _commentsList = [[NSMutableArray alloc] init];
    }
    return _commentsList;
}

-(GoodsBottomView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[GoodsBottomView alloc] initWithFrame:CGRectZero];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(NSMutableArray *)dataSources{
    if (!_dataSources) {
        _dataSources = [[NSMutableArray alloc] init];
    }
    return _dataSources;
}

-(PicSuccess *)PicTextSuccessView{
    if (!_PicTextSuccessView) {
        _PicTextSuccessView = [[PicSuccess alloc] initWithFrame:CGRectZero];
        _PicTextSuccessView.backgroundColor = [UIColor whiteColor];
        _PicTextSuccessView.layer.masksToBounds = YES;
        _PicTextSuccessView.layer.cornerRadius = 5;
    }
    return _PicTextSuccessView;
}

-(CommandButton *)disPicSuccessView{
    if (!_disPicSuccessView) {
        _disPicSuccessView = [[CommandButton alloc] initWithFrame:CGRectZero];
        [_disPicSuccessView setImage:[UIImage imageNamed:@"Goods_Fenxiao_Dismiss"] forState:UIControlStateNormal];
        [_disPicSuccessView sizeToFit];
    }
    return _disPicSuccessView;
}

-(PullRefreshTableView *)tableView{
    if (!_tableView) {
        _tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor colorWithHexString:@"f1f1ed"];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.pullDelegate = self;
        _tableView.enableLoadingMore = NO;
        _tableView.enableRefreshing = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAKSELF;
    self.topbarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"商品详情"];
    [self.topBar addSubview:self.goodsPriceView];
    [super setupTopBarRightButton:[UIImage imageNamed:@"more_wjh"] imgPressed:nil];
    [super setupTopBarRightTwoButton:[UIImage imageNamed:@"Goods_TopRight_ShopBag"] imgPressed:nil];
    UIButton *goodsNumLbl = [self buildGoodsNumLbl];
    _goodsNumLbl = goodsNumLbl;
    [self.topBarRightTwoButton addSubview:goodsNumLbl];
    [ParabolaTool sharedTool].delegate = self;
    [weakSelf showLoadingView];
    _request = [[NetworkAPI sharedInstance] getGoodsDetail:self.goodsId completion:^(GoodsDetailInfo *detail) {
        
        weakSelf.detailInfo = detail;
        
        //        [self.gallaryItems addObject:detail.goodsInfo.coverItem];
        
        
        [self.gallaryItems addObjectsFromArray:weakSelf.detailInfo.gallaryItems];
        for (int i = 0; i < weakSelf.gallaryItems.count; i++) {
            PictureItem *item = weakSelf.gallaryItems[i];
            XMWebImageView *imageView = [[XMWebImageView alloc] init];
            [imageView setImageWithURL:item.picUrl placeholderImage:nil XMWebImageScaleType:XMWebImageScale480x480];
            [weakSelf.imageViews addObject:imageView];
        }
        
        _titles = @[@"消息",@"首页",@"我要反馈",@"分享"];
        _images= @[@"pop_messgae",@"pop_home",@"pop_feedback",@"pop_share"];
        
        if ([[Session sharedInstance] isLoggedIn]) {
            [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"repurchase" path:@"get_permission_value" parameters:nil completionBlock:^(NSDictionary *data) {
                NSInteger canpay = [data integerValueForKey:@"get_permission_value"];
                weakSelf.canPay = canpay;
            } failure:^(XMError *error) {
                
            } queue:nil]];
        }
        
        [weakSelf.view addSubview:weakSelf.tableView];
        [weakSelf.view addSubview:weakSelf.bottomView];
        [weakSelf.view addSubview:weakSelf.blackView];
        [weakSelf.view addSubview:weakSelf.addBagView];
        
        [weakSelf.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topBar.mas_bottom).offset(1);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(-56);
        }];
        //    self.tableView.frame = CGRectMake(0, self.topbarHeight+1, kScreenWidth, kScreenHeight-self.topbarHeight-1);
        
        [weakSelf.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
            make.height.equalTo(@56);
        }];
        
        
        [weakSelf.bottomView getGoodsInfo:weakSelf.detailInfo.goodsInfo];
        weakSelf.bottomView.goodsId = weakSelf.goodsId;
        [weakSelf.blackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.topBar.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
        [weakSelf.addBagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view.mas_centerX);
            make.centerY.equalTo(self.view.mas_centerY);
            make.width.equalTo(@(kScreenWidth-100));
            make.height.equalTo(@(kScreenWidth-(kScreenWidth/320*210)));
        }];
        weakSelf.addBagView.hidden = YES;
        weakSelf.blackView.hidden = YES;
        
        weakSelf.bottomView.clickLikeBtn = ^(){
            
            [weakSelf showProcessingHUD:@""];
            _request = [[NetworkAPI sharedInstance] getGoodsDetail:self.goodsId completion:^(GoodsDetailInfo *detail) {
                [weakSelf hideHUD];
                weakSelf.detailInfo = detail;
                [weakSelf.bottomView getGoodsInfo:detail.goodsInfo];
                [weakSelf setData:detail isOpen:NO];
                [weakSelf.tableView reloadData];
                
            } failure:^(XMError *error) {
                
            }];
            
        };
        
        weakSelf.addBagView.pushShopBag = ^(){
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.addBagView.alpha = 0;
                weakSelf.blackView.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf.addBagView removeFromSuperview];
                [weakSelf.blackView removeFromSuperview];
            }];
            ShoppingCartViewController *shopViewController = [[ShoppingCartViewController alloc] init];
            [weakSelf pushViewController:shopViewController animated:YES];
        };
        
        weakSelf.blackView.dissMissBlackView = ^(){
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.addBagView.alpha = 0;
                weakSelf.PicTextSuccessView.alpha = 0;
                weakSelf.disPicSuccessView.alpha = 0;
            } completion:^(BOOL finished) {
                [weakSelf.addBagView removeFromSuperview];
                [weakSelf.PicTextSuccessView removeFromSuperview];
                [weakSelf.disPicSuccessView removeFromSuperview];
            }];
        };
        
        
        ForumInputToolBar *toolBar = [[ForumInputToolBar alloc] initWithFrame:CGRectMake(0, self.view.height-[ForumInputToolBar defaultHeight], self.view.width, [ForumInputToolBar defaultHeight]) withInputTextView:nil];
        _toolBar = toolBar;
        _toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
        _toolBar.delegate = self;
        _toolBar.hiddenWhenNoEditing = YES;
        if ([_toolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
            DXChatBarMoreView *moreView = (DXChatBarMoreView*)(_toolBar.moreView);
            moreView.delegate = self;
        }
        _toolBar.inputTextView.placeHolder = @"评论";
        _toolBar.hiddenWhenNoEditing = YES;
        _toolBar.hidden = YES;
        [self.view addSubview:toolBar];
        
        //将self注册为chatToolBar的moreView的代理
        if ([self.toolBar.moreView isKindOfClass:[DXChatBarMoreView class]]) {
            [(DXChatBarMoreView *)self.toolBar.moreView setDelegate:self];
        }
        
        ForumAttachContainerView *attachContainerView = [[ForumAttachContainerView alloc] initWithFrame:CGRectMake(0, -40, kScreenWidth, 40)];
        [self.toolBar addSubview:attachContainerView];
        attachContainerView.hidden = YES;
        _attachContainerView = attachContainerView;
        _toolBar.attachContainerView = attachContainerView;
        
        UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(tapAnywhereToDismissKeyboard:)];
        singleTapGR.delegate = self;
        [self.view addGestureRecognizer:singleTapGR];
        
        //    if ([self.goodsId length]>0) {
        //        [[NetworkAPI sharedInstance] statForGoods:self.goodsId completion:nil failure:nil];
        //    }
        
        _reply_user_id = 0;
        
        
        
        weakSelf.bottomView.commentGoods = ^(){
            weakSelf.toolBar.inputTextView.placeHolder = @"评论";
            [weakSelf.toolBar beginEditing];
        };
        
        weakSelf.bottomView.handleEditGoodsBlock = ^(GoodsInfo *goodsInfo) {
            PublishViewController * viewController = [[PublishViewController alloc] init];
            viewController.goodsId = goodsInfo.goodsId;
            [weakSelf pushViewController:viewController animated:YES];
        };
        
        BOOL isDataChanged = NO;
        GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] storeData:weakSelf.detailInfo.goodsInfo isDataChanged:&isDataChanged];
        self.goodsInfo = goodsInfo;
        
        weakSelf.bottomView.handleAddShopBag = ^(){
            if ([weakSelf.detailInfo.goodsInfo isOnSale])
            {
                if ([[Session sharedInstance] isLoggedIn]) {
                    
                    
                    [weakSelf showProcessingHUD:nil];
                    weakSelf.request = [[NetworkAPI sharedInstance] addToShoppingCart:weakSelf.goodsId completion:^(NSInteger totalNum,ShoppingCartItem* addedItem) {
                        
                        [weakSelf hideHUD];
                        //                        weakSelf.bottomView.addShopBag.selected = YES;
                        weakSelf.bottomView.addShopBag.enabled = NO;
                        [weakSelf.bottomView.addShopBag setTitle:@"已加入购物袋" forState:UIControlStateNormal];
                        [weakSelf.bottomView.addShopBag setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
                        
                        [[Session sharedInstance] setShoppingCartGoods:totalNum addedItem:addedItem];
                        
                        //                    [WCAlertView showAlertWithTitle:@"恭喜您" message:@"加入购物袋成功" customizationBlock:^(WCAlertView *alertView) {
                        //
                        ////                        alertView.buttonTextColor = [UIColor colorWithHexString:@"c2a79d"];
                        ////                        alertView.style = WCAlertViewStyleCustomizationBlock;
                        //                    } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                        //                        if (buttonIndex == 0) {
                        //
                        //                        } else {
                        //                            //这里执行代码
                        //                            ShoppingCartViewController *shopViewController = [[ShoppingCartViewController alloc] init];
                        //                            [self pushViewController:shopViewController animated:YES];
                        //                        }
                        //                    } cancelButtonTitle:@"继续逛" otherButtonTitles:@"去付款", nil];
                        //                        weakSelf.blackView.alpha = 0;
                        //                        weakSelf.addBagView.alpha = 0;
                        //                        weakSelf.blackView.hidden = NO;
                        //                        weakSelf.addBagView.hidden = NO;
                        //                        [UIView animateWithDuration:0.25 animations:^{
                        //                            weakSelf.blackView.alpha = 0.7;
                        //                            weakSelf.addBagView.alpha = 1;
                        //                        }];
                        
                        _animationImage = [[UIImageView alloc] init];
                        _animationImage.image = [UIImage imageNamed:@"shoppingAnimation"];
                        [self.view addSubview:self.animationImage];
                        [self.animationImage mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.center.equalTo(self.view);
                        }];
                        
                        
                        self.animationImage.hidden = NO;
                        CGRect parentRectA = CGRectMake(kScreenWidth/2, kScreenHeight/2, 20, 20);
                        CGRect parentRectB = [self.view convertRect:self.topBarRightTwoButton.frame toView:self.view];
                        UIBezierPath *path= [UIBezierPath bezierPath];
                        [path moveToPoint:CGPointMake(parentRectA.origin.x, parentRectA.origin.y)];
                        [path addQuadCurveToPoint:CGPointMake(parentRectB.origin.x+25,  parentRectB.origin.y+25) controlPoint:CGPointMake(parentRectA.origin.x + 100, parentRectA.origin.y + 100)];
                        [[ParabolaTool sharedTool] throwObject:self.animationImage  path:path isRotation:YES endScale:0.3];
                        
                        
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f];
                    }];
                    
                } else {
                    LoginViewController *viewController = [[LoginViewController alloc] init];
                    //                CheckPhoneViewController *viewController = [[CheckPhoneViewController alloc] init];
                    viewController.title = @"登录";
                    UINavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
                    [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{
                        
                    }];
                }
            } else {
                [weakSelf showHUD:[NSString stringWithFormat:@"商品%@",[weakSelf.detailInfo.goodsInfo statusDescription]] hideAfterDelay:0.8f];
            }
            
            [MobClick event:@"click_add_to_chart_from_detail"];
        };
        
        
        //        [weakSelf setUpUI];
        
        
        [weakSelf loadGoodsCommends];
        
        
    } failure:^(XMError *error) {
        [weakSelf hideLoadingView];
        [weakSelf showHUD:error.errorMsg hideAfterDelay:0.8];
    }];
    
    
    
    [self.view addSubview:self.PicTextSuccessView];
    [self.view addSubview:weakSelf.disPicSuccessView];
    self.PicTextSuccessView.alpha = 0;
    self.disPicSuccessView.alpha = 0;
    [weakSelf.PicTextSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.centerY.equalTo(weakSelf.view.mas_centerY);
        make.left.equalTo(weakSelf.view.mas_left).offset(15);
        make.right.equalTo(weakSelf.view.mas_right).offset(-15);
        make.height.equalTo(@150);
    }];
    
    [weakSelf.disPicSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.PicTextSuccessView.mas_top);
        make.right.equalTo(weakSelf.PicTextSuccessView.mas_right).offset(-10);
    }];
    weakSelf.disPicSuccessView.handleClickBlock = ^(CommandButton *sender){
        weakSelf.blackView.alpha = 0;
        weakSelf.PicTextSuccessView.alpha = 0;
        weakSelf.disPicSuccessView.alpha = 0;
    };
    
    weakSelf.PicTextSuccessView.disPicView = ^(){
        weakSelf.blackView.alpha = 0;
        weakSelf.PicTextSuccessView.alpha = 0;
        weakSelf.disPicSuccessView.alpha = 0;
    };
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickLike:) name:@"clickLike" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(replayUserComment:) name:@"replayUserComment" object:nil];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.toolBar endEditing:YES];
    CGFloat offsize = scrollView.contentOffset.y;
    if (offsize > 50) {
        self.goodsPriceView.hidden = NO;
    }else{
        self.goodsPriceView.hidden = YES;
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"clickLike" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"replayUserComment" object:nil];
}

-(void)clickLike:(NSNotification *)notify{
    WEAKSELF;
    //    NSNumber *likeNum = notify.object;
    [weakSelf showProcessingHUD:@""];
    _request = [[NetworkAPI sharedInstance] getGoodsDetail:self.goodsId completion:^(GoodsDetailInfo *detail) {
        [weakSelf hideHUD];
        weakSelf.detailInfo = detail;
        [weakSelf.bottomView getGoodsInfo:detail.goodsInfo];
        [weakSelf setData:detail isOpen:NO];
        [weakSelf.tableView reloadData];
        
    } failure:^(XMError *error) {
        
    }];
    
}

- (void)animationDidFinish
{
    [self.animationImage removeFromSuperview];
}

-(void)replayUserComment:(NSNotification *)notify{
    
    CommentVo *comment = notify.object;
    
    if (comment.user_id == [Session sharedInstance].currentUserId) {
        self.reply_user_id = 0;
        self.toolBar.inputTextView.placeHolder = @"评论";
        [self.toolBar beginEditing];
    } else {
        self.reply_user_id = comment.user_id;
        self.toolBar.inputTextView.placeHolder = [NSString stringWithFormat:@"回复 %@", comment.username];
        [self.toolBar beginEditing];
    }
    
}

- (void)loadGoodsCommends {
    WEAKSELF;
    [GoodsService comment_list:self.goodsId size:10000 completion:^(NSArray *comments) {
        [weakSelf hideLoadingView];
        NSMutableArray *commentsList = [[NSMutableArray alloc] initWithArray:comments];
        weakSelf.commentsList = commentsList;
        
        
        [weakSelf setData:weakSelf.detailInfo isOpen:NO];
        [weakSelf.tableView reloadData];
    } failure:^(XMError *error) {
        [weakSelf hideLoadingView];
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
    }];
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
                [self shareGoods];
                break;
                
            default:
                break;
        }
    }];
}

- (void)shareGoods
{
    WEAKSELF;
    GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:weakSelf.goodsId];
    if (goodsInfo) {
        NSString *_shareImageUrl = goodsInfo.mainPicUrl;
        if ([_shareImageUrl mag_isEmpty] && goodsInfo.gallaryItems && [goodsInfo.gallaryItems count] >0) {
            _shareImageUrl = ((GoodsGallaryItem *)[goodsInfo.gallaryItems objectAtIndex:0]).picUrl;
        }
        
        UIImage *shareImage = [[SDWebImageManager.sharedManager imageCache] imageFromMemoryCacheForKey:
                               [SDWebImageManager lw_cacheKeyForURL:
                                [NSURL URLWithString:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale480x480]]]];
        
        
        if (shareImage == nil) {
            
            
            shareImage = [weakSelf getImageFromURL:[XMWebImageView imageUrlToQNImageUrl:_shareImageUrl isWebP:NO scaleType:XMWebImageScale200x200]];
        }
        
        //        [[CoordinatingController sharedInstance] shareWithTitle:@"来自爱丁猫的分享"
        //                                                          image:shareImage
        //                                                            url:kURLGoodsDetailFormat(goodsInfo.goodsId)
        //                                                        content:goodsInfo.goodsName];
        [[CoordinatingController sharedInstance] shareWithTitle:[NSString stringWithFormat:@"%@",goodsInfo.goodsName]
                                                          image:shareImage
                                                            url:kURLGoodsDetailFormat(goodsInfo.goodsId)
                                                        content:goodsInfo.summary
                                                     isTeletext:YES];
        
        [MobClick event:@"click_share_from_detail"];
        
        weakSelf.request = [[NetworkAPI sharedInstance] shareGoodsWith:weakSelf.goodsId completion:^(int shareNum) {
            dispatch_async(dispatch_get_main_queue(), ^{
                GoodsInfo *goodsInfo = [[GoodsMemCache sharedInstance] dataForKey:weakSelf.goodsId];
                if (goodsInfo) {
                    goodsInfo.stat.shareNum = shareNum;
                }
                MBGlobalSendGoodsInfoChangedNotification(0,weakSelf.goodsId);
            });
            _$hideHUD();
        } failure:^(XMError *error) {
            _$showHUD([error errorMsg], 0.8f);
        }];
    }
    
    
    //获取图文
    [CoordinatingController sharedInstance].getImageAndText = ^(){
        
        for (int i = 0; i < weakSelf.detailInfo.gallaryItems.count; i++) {
            GoodsGallaryItem * gallary = weakSelf.detailInfo.gallaryItems[i];
            UIImage * image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:gallary.picUrl]]];
            UIImageWriteToSavedPhotosAlbum(image, weakSelf, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        NSString * shareText = [NSString stringWithFormat:@"%@,%.2f,%@",weakSelf.goodsInfo.goodsName,weakSelf.goodsInfo.shopPrice,weakSelf.goodsInfo.summary];
        UIPasteboard * pastebpard = [UIPasteboard generalPasteboard];
        pastebpard.string = shareText;
    };
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    
    if (error == nil) {
        //        [[CoordinatingController sharedInstance] showHUD:@"获取图文成功" hideAfterDelay:0.8];
        self.blackView.hidden = NO;
        self.PicTextSuccessView.alpha = 1;
        self.blackView.alpha = 0.7;
        self.disPicSuccessView.alpha = 1;
    }else{
        [[CoordinatingController sharedInstance] showHUD:@"获取图文失败" hideAfterDelay:0.8];
    }
}

- (UIImage *) getImageFromURL:(NSString *)fileURL {
    UIImage * result;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:fileURL]];
    result = [UIImage imageWithData:data];
    return result;
}

-(void)handleTopBarRightTwoButtonClicked:(UIButton *)sender{
    
    ShoppingCartViewController *viewController = [[ShoppingCartViewController alloc] init];
    [self pushViewController:viewController animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
}


- (void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer {
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    [self.toolBar endEditing:YES];
}

- (void)didSendFaceWithText:(NSString *)text
{
    WEAKSELF;
    if ([weakSelf.toolBar.inputTextView isFirstResponder]) {
        [weakSelf.view endEditing:YES];
        [weakSelf.toolBar endEditing:YES];
    }
    
    NSString *content = [self.toolBar.inputTextView.text trim];
    if ([content length]>0|| [weakSelf.attachContainerView.attachments count]>0) {
        [weakSelf showProcessingHUD:nil];
        
        [GoodsService comment_publish:weakSelf.goodsId
                        reply_user_id:weakSelf.reply_user_id
                              content:content
                          attachments:weakSelf.attachContainerView.attachments completion:^(CommentVo *commentVo)
         {
             [weakSelf showHUD:@"评论成功" hideAfterDelay:0.8];
             
             [weakSelf.attachContainerView clear];
             
             GoodsCommentVoWrapper *obj = [[GoodsCommentVoWrapper alloc] init];
             obj.goodsId = weakSelf.goodsId;
             obj.comment = commentVo;
             SEL selector = @selector($$handleGoodsCommentAdd:comment:);
             MBGlobalSendNotificationForSELWithBody(selector, obj);
             
             weakSelf.reply_user_id = 0;
             
             weakSelf.toolBar.inputTextView.placeHolder = @"评论";
             weakSelf.toolBar.inputTextView.text = @"";
             [weakSelf.toolBar textViewDidChange:weakSelf.toolBar.inputTextView];
             
             [weakSelf.view endEditing:YES];
             [weakSelf.toolBar endEditing:YES];
             
         } failure:^(XMError *error) {
             [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8];
         }];
    }
}

- (void)$$handleGoodsCommentAdd:(id<MBNotification>)notifi comment:(GoodsCommentVoWrapper*)commentWrapper
{
    WEAKSELF;
    if ([commentWrapper.goodsId isEqualToString:self.goodsId]) {
        if (!weakSelf.commentsList) {
            weakSelf.commentsList  = [[NSMutableArray alloc] init];
        }
        [weakSelf.commentsList insertObject:commentWrapper.comment atIndex:0];
        self.detailInfo.comment_num += 1;
        [weakSelf setData:self.detailInfo isOpen:NO];
        [weakSelf.tableView reloadData];
    }
}



- (UIButton*)buildGoodsNumLbl
{
    //        UIButton *goodsNumLbl = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
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

-(void)setData:(GoodsDetailInfo *)detail isOpen:(BOOL)isOpen{
    
    if ([detail.goodsInfo.goodsId  isEqual: @""] || detail.goodsInfo == nil) {
        [self loadEndWithNoContent:@"暂无此商品"];
    }
    
    if (detail) {
        [self.dataSources removeAllObjects];
        [self.dataSources addObject:[GoodsBasisCell buildCellDict:detail.goodsInfo]];
        [self.goodsPriceView getGoodsDetailInfo:detail.goodsInfo];
        //        [self.dataSources addObject:[GoodsPictureCell buildCellDict:detail.goodsInfo.coverItem index:1]];
        if (detail.goodsInfo.isLimitActivity && detail.goodsInfo.activityBaseInfo && !detail.goodsInfo.activityBaseInfo.isFinished && (detail.goodsInfo.status == GOODS_STATUS_ON_SALE|| detail.goodsInfo.status == GOODS_STATUS_LOCKED)) {
            [self.dataSources addObject:[C2CActivityCell buildCellDict:detail.goodsInfo]];   
        }
        [self.dataSources addObject:[SepWhiteTableViewCell1 buildCellDict]];
        if (detail.gallaryItems.count > 0) {
            for (int i = 0; i < detail.gallaryItems.count; i++) {
                [self.dataSources addObject:[GoodsPictureCell buildCellDict:detail.gallaryItems[i] index:i+1]];
                [self.dataSources addObject:[SepWhiteTableViewCell1 buildCellDict]];
            }
        }
        [self.dataSources addObject:[GoodsLikeCell buildCellDict:detail]];
        [self.dataSources addObject:[SepTableViewCell buildCellDict]];
        //    [self.dataSources addObject:[GoodsExplainCell buildCellDict:detail]];
        
        if (detail.goodsInfo.goodsBenefitInfo.count > 0) {
            NSArray * array = detail.goodsInfo.goodsBenefitInfo;
            GoodsGuarantee * goodsGuarantee = array[0];
            [self.dataSources addObject:[ServiceIconCell buildCellDict:goodsGuarantee]];
            [self.dataSources addObject:[SepTableViewCell buildCellDict]];
        }
        
//        if (detail.goodsInfo.goods_guarantee.count > 0) {
//            for (GoodsGuarantee * goodsGuarantee in detail.goodsInfo.goods_guarantee) {
//                [self.dataSources addObject:[DeliveryExplainCell buildGoodsGuaranteeCellDict:goodsGuarantee]];
//            }
//        }
        if (detail.goodsInfo.goods_guarantee.count > 0) {
            [self.dataSources addObject:[SepSWTableViewCell buildCellDict]];
            for (int i = 0; i < detail.goodsInfo.goods_guarantee.count; i++) {
                GoodsGuarantee *goodsGuarantee = detail.goodsInfo.goods_guarantee[i];
                [self.dataSources addObject:[DeliveryExplainCell buildGoodsGuaranteeCellDict:goodsGuarantee]];
                if (i == detail.goodsInfo.goods_guarantee.count - 1) {
                    
                } else {
                    [self.dataSources addObject:[SepSWTableViewCell1 buildCellDict]];
                }
            }
            [self.dataSources addObject:[SepSWTableViewCell buildCellDict]];
        }
        
        [self.dataSources addObject:[SepTableViewCell buildCellDict]];
        [self.dataSources addObject:[GoodsDetailTitleCell buildCellDict:@"商品参数" isOpen:2 b2cOrc2c:1]];
//        if (isOpen) {
            [self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
            [self.dataSources addObject:[GoodsAttributesCell buildCellDict:detail.attrItems]];
//        } else {
//            
//        }
//        [self.dataSources addObject:[SepTableViewCell buildCellDict]];
//        [self.dataSources addObject:[SupportCell buildCellDict]];
//        if ([detail.goodsInfo approveTags].count>0) {
//            if (detail.goodsInfo.goodsType == 1) {// || (detail.goodsInfo.supportType & GOODSINDEX) == GOODSINDEX
//                //            [self.dataSources addObject:[GoodsDetailSelfEngageCell buildCellDict]];
//            }
//            [self.dataSources addObject:[GoodsDetailAppoveTagsCell buildCellDict:detail.goodsInfo]];
//        }
        [self.dataSources addObject:[SepTableViewCell buildCellDict]];
        [self.dataSources addObject:[MessageTitleCell buildCellDict:detail]];
        [self.dataSources addObject:[SegTabViewCellSmallTwo buildCellDict]];
        [self.dataSources addObject:[MessageCell buildCellDict:self.commentsList andSellerId:detail.goodsInfo.seller.userId]];
        [self.dataSources addObject:[SepTableViewCell buildCellDict]];
//        [self.dataSources addObject:[GoodsDetailTitleCell buildCellDict:@"交易流程" isOpen:2 b2cOrc2c:1]];
//        [self.dataSources addObject:[SepPictureViewCell buildCellDict]];
        [self.dataSources addObject:[DealguaranteCell buildCellDict:detail.imageDescGroupItems]];
    }
    
}

-(void)setUpUI{
    
    
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSources.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[UIColor whiteColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    WEAKSELF;
    if ([tableViewCell isKindOfClass:[GoodsLikeCell class]]) {
        GoodsLikeCell *likeCell = (GoodsLikeCell *)tableViewCell;
        likeCell.clickLikeBtn = ^(){
            [[CoordinatingController sharedInstance] gotoGoodsLikesViewController:weakSelf.goodsId animated:YES];
        };
    } else if ([tableViewCell isKindOfClass:[GoodsPictureCell class]]) {
        GoodsPictureCell *pictureCell = (GoodsPictureCell *)tableViewCell;
        pictureCell.showPicDetail = ^(XMWebImageView *imageView){
            [weakSelf didClickViewPage:imageView imageViewArray:weakSelf.imageViews];
        };
    } else if ([tableViewCell isKindOfClass:[GoodsDetailAppoveTagsCell class]]) {
        GoodsDetailAppoveTagsCell *tagsCell = (GoodsDetailAppoveTagsCell *)tableViewCell;
        tagsCell.handleMoreBtnClicked = ^(){
            
            [weakSelf.view addSubview:weakSelf.bgView];
            [weakSelf.view addSubview:weakSelf.tagsExplainView];
            [weakSelf.tagsExplainView getTagsArr:weakSelf.detailInfo.goodsInfo.certTags];
            weakSelf.bgView.alpha = 0;
            weakSelf.bgView.dissMissBlackView = ^(){
                [UIView animateWithDuration:0.25 animations:^{
                    weakSelf.tagsExplainView.frame = CGRectMake(0, kScreenHeight, kScreenWidth, 310);
                    weakSelf.bgView.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf.tagsExplainView removeFromSuperview];
                    [weakSelf.bgView removeFromSuperview];
                }];
            };
            
            [UIView animateWithDuration:0.25 animations:^{
                weakSelf.bgView.alpha = 0.7;
                weakSelf.tagsExplainView.frame = CGRectMake(0, kScreenHeight-310, kScreenWidth, 310);
            }];
            
        };
    }else if ([tableViewCell isKindOfClass:[DeliveryExplainCell class]]){
        DeliveryExplainCell * deliver =(DeliveryExplainCell *)tableViewCell;
        deliver.handleWashBlock = ^(NSString * url){
            WebViewController *viewController = [[WebViewController alloc] init];
            viewController.url = url;
            [self pushViewController:viewController animated:YES];
        };
    }
    
    [tableViewCell updateCellWithDict:dict];
    return tableViewCell;
}



- (void)photoBrowser:(MJPhotoBrowser *)photoBrowser didChangedToPageAtIndex:(NSUInteger)index
{
    [_scrollImageView setCurrentPage:index];
}

- (void)didClickViewPage:(UIImageView *)imageView imageViewArray:(NSArray*)imageViewArray
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:[self.gallaryItems count]];
    //    for (NSInteger i=0;i< [self.gallaryItems count];i++) {
    //
    //        GoodsGallaryItem *item = (GoodsGallaryItem*)[self.gallaryItems objectAtIndex:i];
    //        MJPhoto *photo = [[MJPhoto alloc] init];
    //        NSString *QNDownloadUrl = nil;
    //        //        if (item.width>0&&item.height>0) {
    //        //            QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO size:CGSizeMake(kScreenWidth*2.5, item.width/kScreenWidth*item.height*2.5)];
    //        //        } else {
    //        QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO scaleType:XMWebImageScale750x750];
    //        //        }
    //
    //        //        QNDownloadUrl = item.picUrl;
    //
    //        photo.url = [NSURL URLWithString:QNDownloadUrl]; // 图片路径
    //        if (i<imageViewArray.count) {
    //            photo.srcImageView = [imageViewArray objectAtIndex:i];
    //        } else {
    //            photo.srcImageView = imageView; // 来源于哪个UIImageView
    //        }
    //        [photos addObject:photo];
    //    }
    
    for (GoodsGallaryItem *item in self.gallaryItems) {
        MJPhoto *photo = [[MJPhoto alloc] init];
        
        NSString *QNDownloadUrl = nil;
        if (item.width>0&&item.height>0) {
            QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO size:CGSizeMake(kScreenWidth*2.5, item.width/kScreenWidth*item.height*2.5)];
        } else {
            QNDownloadUrl = [XMWebImageView imageUrlToQNImageUrl:item.picUrl isWebP:NO scaleType:XMWebImageScale640x640];
        }
        
        QNDownloadUrl = item.picUrl;
        
        photo.url = [NSURL URLWithString:QNDownloadUrl]; // 图片路径
        photo.srcImageView = imageView; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    if ([photos count]>0) {
        // 2.显示相册
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.isHaveGoodsDetailBtn = 1;
        browser.currentPhotoIndex = imageView.tag-1; // 弹出相册时显示的第一张图片是？
        browser.photos = photos; // 设置所有的图片
        browser.delegate = self;
        [browser show];
    }
}


- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"CommentView"]) {
        return NO;
    }
    
    return  YES;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    if (ClsTableViewCell == [MessageTitleCell class]) {
        GoodsCommentsViewController *viewController = [[GoodsCommentsViewController alloc] init];
        viewController.goodsId = self.goodsId;
        [self pushViewController:viewController animated:YES];
    } else if (ClsTableViewCell == [GoodsDetailTitleCell class]) {
        
        if (self.isOpen == 1) {
            self.isOpen = 0;
        } else {
            self.isOpen = 1;
        }
        
        [self setData:self.detailInfo isOpen:self.isOpen];
        [self.tableView reloadData];
        
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    NSLog(@"%@==========%.2f",ClsTableViewCell , [ClsTableViewCell rowHeightForPortrait:dict]);
    
    
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi addedItem:(ShoppingCartItem*)item
{
    [self $$handleShoppingCartSyncFinishedNotification:nil];
}

- (void)$$handleShoppingCartGoodsChangedNotification:(id<MBNotification>)notifi removedGoodsIds:(NSArray*)goodsIds
{
    [self $$handleShoppingCartSyncFinishedNotification:nil];
}

- (void)$$handleShoppingCartSyncFinishedNotification:(id<MBNotification>)notifi
{
    [self updateGoodsNumLbl:[Session sharedInstance].shoppingCartNum];
}

@end
