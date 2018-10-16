//
//  ShoppingCartViewController.m
//  XianMao
//
//  Created by simon on 11/27/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "PullRefreshTableView.h"
#import "ShoppingCartTableViewCell.h"
#import "NSMutableAttributedString+XMAttributedString.h"
#import "ShoppingCartItem.h"
#import "GoodsInfo.h"

#import "Session.h"
#import "NetworkAPI.h"
#import "Error.h"
#import "RecommendTableViewCell.h"
#import "GoodsDetailTableViewCell.h"
#import "CoordinatingController.h"
#import "ShoppingCartNocontentCell.h"
#import "PayViewController.h"
#import "ShoppingCartDelCell.h"
#import "Command.h"

#import "GoodsMemCache.h"

#import "BoughtViewController.h"
#import "BoughtCollectionViewController.h"
#import "GoodsService.h"
#import "PayManager.h"
#import "RecommendationView.h"
#import "WCAlertView.h"
#import "BlackView.h"
#import "WristInviteView.h"
#import "AdviserGoodsModel.h"
#import "GoodsDetailViewController.h"
#import "OrderDetailInfo.h"
#import "SuccessfulPayViewController.h"
#import "SepTableViewCell.h"

//#define kShoppingCartBottomBarHeight 59.f
#define kShoppingCartBottomBarHeight 45.f
#define KShoppingCartTableViewCell @"ShoppingCartTableViewCell"


@interface ShoppingCartViewController () <UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,PullRefreshTableViewDelegate,SwipeTableCellDelegate,ShoppingCartGoodChangedReceiver,ShoppingCartGoodChangedReceiver, WristViewDelegate>

@property(nonatomic,weak) PullRefreshTableView *tableView;
@property(nonatomic,weak) UIImageView *bottomView;
@property(nonatomic,weak) UIImageView *editView;
@property(nonatomic,retain) NSMutableArray *dataSources;
@property(nonatomic,strong) HTTPRequest *request;
@property (nonatomic, strong) RecommendationView * Recommendation;
@property (nonatomic, assign) NSInteger canPay;
@property (nonatomic, strong) BlackView *inviteBlackView;
@property (nonatomic, strong) WristInviteView *wristInviteView;
@property (nonatomic, strong) NSMutableArray * goodsRecommendList;

@end

@implementation ShoppingCartViewController

-(BlackView *)inviteBlackView{
    if (!_inviteBlackView) {
        _inviteBlackView = [[BlackView alloc] initWithFrame:self.view.bounds];
    }
    return _inviteBlackView;
}


-(WristInviteView *)wristInviteView{
    if (!_wristInviteView) {
        _wristInviteView = [[WristInviteView alloc] initWithFrame:CGRectZero];
        _wristInviteView.backgroundColor = [UIColor whiteColor];
        _wristInviteView.wristDissDelegate = self;
        _wristInviteView.layer.masksToBounds = YES;
        _wristInviteView.layer.cornerRadius = 5;
    }
    return _wristInviteView;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    WEAKSELF;
    if ([[Session sharedInstance] isLoggedIn]) {
        [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"repurchase" path:@"get_permission_value" parameters:nil completionBlock:^(NSDictionary *data) {
            NSInteger canpay = [data integerValueForKey:@"get_permission_value"];
            weakSelf.canPay = canpay;
        } failure:^(XMError *error) {
            
        } queue:nil]];
    }
    
    CGFloat topBarHeight = [super setupTopBar];
    [super setupTopBarTitle:@"购物袋"];
    [super setupTopBarBackButton];
    [super setupTopBarRightButton];
    [super.topBarRightButton setTitle:@"编辑" forState:UIControlStateNormal];
    [super.topBarRightButton setTitle:@"完成" forState:UIControlStateSelected];
    self.topBarRightButton.backgroundColor = [UIColor clearColor];
    [self.topBarRightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    PullRefreshTableView *tableView = [[PullRefreshTableView alloc] initWithFrame:CGRectMake(0, topBarHeight, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds)-topBarHeight-56)];
    self.tableView = tableView;
    self.tableView.pullDelegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"f2f2f2"];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.enableLoadingMore = NO;
    [self.view addSubview:self.tableView];
    
    UIImageView *bottomView = [self buildBottomView];
    bottomView.frame = CGRectMake(0, self.view.bounds.size.height - 56, self.view.bounds.size.width, 56);
    [self.view addSubview:bottomView];
    self.bottomView = bottomView;
    
    UIImageView *editView = [self buildEditView];
    editView.frame = CGRectMake(0, self.view.bounds.size.height - 56, self.view.bounds.size.width, 56);
    editView.hidden = YES;
    [self.view addSubview:editView];
    self.editView = editView;
    
    [self showLoadingView];
    self.topBarRightButton.hidden = YES;
    
    [self loadRecommandGoods];
    [self bringTopBarToTop];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)reloadData
{
    WEAKSELF;
    [_request cancel];
    
    _request = [[NetworkAPI sharedInstance] getShoppingCartGoods:^(NSArray *itemList) {
        [weakSelf hideLoadingView];
        weakSelf.tableView.pullTableIsRefreshing = NO;
        
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in itemList) {
            [items addObject:[ShoppingCartItem createWithDict:dict]];
        }
        
        [[Session sharedInstance] setShoppingCartItems:items];
        
        
    } failure:^(XMError *error) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
        
        if ([weakSelf.dataSources count]==0) {
            [weakSelf loadEndWithError].handleRetryBtnClicked = ^(LoadingView *view) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf loadRecommandGoods];
                });
            };
        }
        
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:[UIApplication sharedApplication].keyWindow];
    }];
}

- (void)loadRecommandGoods {
    WEAKSELF;
    [GoodsService shoppingCartRecommendGoods:^(NSArray *goods_list) {
        NSMutableArray *goodsRecommendList = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[goods_list count];i+=2) {
            NSMutableArray *array = [[NSMutableArray alloc] init];
            [array addObject:[goods_list objectAtIndex:i]];
            if (i+1>=[goods_list count]) {
                [goodsRecommendList addObject:array];
                break;
            }
            [array addObject:[goods_list objectAtIndex:i+1]];
            [goodsRecommendList addObject:array];
        }
        weakSelf.goodsRecommendList = goodsRecommendList;
        [weakSelf reloadData];
    } failure:^(XMError *error) {
        [self showHUD:[error errorMsg] hideAfterDelay:0.8];
    }];
}

-(void)wristDissBtn{
    WEAKSELF;
    [UIView animateWithDuration:0.25 animations:^{
        
        if (weakSelf.wristInviteView) {
            weakSelf.wristInviteView.alpha = 0;
        }
        
        if (weakSelf.inviteBlackView) {
            weakSelf.inviteBlackView.alpha = 0;
        }
        
    } completion:^(BOOL finished) {
        
        if (weakSelf.wristInviteView) {
            [weakSelf.wristInviteView removeFromSuperview];
        }
        
        if (weakSelf.inviteBlackView) {
            [weakSelf.inviteBlackView removeFromSuperview];
        }
    }];
}

- (UIImageView*)buildBottomView
{
    WEAKSELF;
    UIImage *bgImage = [UIImage imageNamed:@"bottombar_bg_white"];
    UIImageView*bottomView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 56)];
    bottomView.userInteractionEnabled = YES;
    bottomView.backgroundColor = [UIColor whiteColor];
    [bottomView setImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2]];
    
    CommandButton *selectAllBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 1, self.view.bounds.size.width, bottomView.bounds.size.height -1)];
    selectAllBtn.tag = 100;
    selectAllBtn.backgroundColor = [UIColor clearColor];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
    [selectAllBtn setImage:[UIImage imageNamed:@"shopping_cart_uncgoose_new"] forState:UIControlStateNormal];
    [selectAllBtn setImage:[UIImage imageNamed:@"shopping_cart_choosed_new"] forState:UIControlStateSelected];
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    selectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7.5, 0, 0);
    selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7.5, 0, 0);
    [selectAllBtn sizeToFit];
    selectAllBtn.frame = CGRectMake(15, 1, selectAllBtn.bounds.size.width+7.5, bottomView.bounds.size.height -1);
    [bottomView addSubview:selectAllBtn];
    
    CGFloat marginRight = 8.5f;
    CommandButton *payBtn = [[CommandButton alloc] init];
    payBtn.backgroundColor = [DataSources colorf9384c];
    payBtn.titleLabel.font = [UIFont systemFontOfSize:14.5f];
    [payBtn setTitle:@"去结算" forState:UIControlStateNormal];
    payBtn.layer.masksToBounds = YES;
    payBtn.layer.cornerRadius = 2;
    [payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [payBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateDisabled];
    [bottomView addSubview:payBtn];
    [payBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(bottomView.mas_centerY);
        make.right.equalTo(bottomView.mas_right).offset(-12);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth/375*108, 40));
    }];
    
    marginRight += payBtn.bounds.size.width;
    marginRight += 20.f;
    
    UILabel *priceLbl = [[UILabel alloc] initWithFrame:CGRectNull];
    priceLbl.tag = 200;
    priceLbl.text = [NSString stringWithFormat:@"合计: ¥%.2f", 0.00];
    priceLbl.textColor = [UIColor colorWithHexString:@"1a1a1a"];
    priceLbl.font = [UIFont boldSystemFontOfSize:14.f];
    priceLbl.textAlignment = NSTextAlignmentCenter;
    [priceLbl sizeToFit];
    [bottomView addSubview:priceLbl];
    [priceLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(payBtn.mas_top);
        make.right.equalTo(payBtn.mas_left).offset(-7);
    }];
    
    UILabel *mailInfoLbl = [[UILabel alloc] init];
    mailInfoLbl.textColor = [UIColor colorWithHexString:@"b2b2b2"];
    mailInfoLbl.font = [UIFont systemFontOfSize:14.f];
    mailInfoLbl.textAlignment = NSTextAlignmentRight;
    mailInfoLbl.text = @"包含邮费";
    [mailInfoLbl sizeToFit];
    [bottomView addSubview:mailInfoLbl];
    [mailInfoLbl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(payBtn.mas_bottom).offset(-2);
        make.right.equalTo(payBtn.mas_left).offset(-7);
    }];
    
    selectAllBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf doSelectAll:!sender.selected];
        [weakSelf doUpdateTotalPrice];
    };
    payBtn.handleClickBlock = ^(CommandButton *sender) {
        [MobClick event:@"click_settlement_from_shopping_chart"];
        //        if (weakSelf.canPay == 0) {
        //            [weakSelf.view addSubview:self.inviteBlackView];
        //            [weakSelf.view addSubview:self.wristInviteView];
        //            weakSelf.inviteBlackView.alpha = 0;
        //            weakSelf.wristInviteView.alpha = 0;
        //            [self.wristInviteView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.centerX.equalTo(self.view.mas_centerX);
        //                make.centerY.equalTo(self.view.mas_centerY);
        //                //                make.width.equalTo(@(kScreenWidth-58*2));
        //                make.left.equalTo(self.view.mas_left).offset(kScreenWidth/375*40);
        //                make.right.equalTo(self.view.mas_right).offset(-(kScreenWidth/375*40));
        //                make.height.equalTo(@(kScreenWidth/375*152));
        //            }];
        //
        //            self.wristInviteView.inviteDiss = ^(){
        //                [UIView animateWithDuration:0.25 animations:^{
        //                    weakSelf.wristInviteView.alpha = 0;
        //                    weakSelf.inviteBlackView.alpha = 0;
        //                } completion:^(BOOL finished) {
        //                    //                    [weakSelf.wristInviteView removeFromSuperview];
        //                    //                    [weakSelf.inviteBlackView removeFromSuperview];
        //                }];
        //            };
        //
        //            [UIView animateWithDuration:0.25 animations:^{
        //                weakSelf.inviteBlackView.alpha = 0.7;
        //                weakSelf.wristInviteView.alpha = 1;
        //            } completion:^(BOOL finished) {
        //
        //            }];
        //
        //            return ;
        //        }
        
        BOOL isExistInvalidGoods = NO;
        NSMutableArray *items = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[weakSelf.dataSources count];i+= 1) { //原来是+=2   不知道什么原因
            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
            NSLog(@"%@", dict);
            if ([dict[@"clsName"] isEqualToString:KShoppingCartTableViewCell]) {
                BOOL isSelected = [dict boolValueForKey:[ShoppingCartTableViewCell cellDictKeyForSeleted] defaultValue:NO];
                if (isSelected) {
                    ShoppingCartItem *item = [dict objectForKeyedSubscript:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
                    [items addObject:item];
                    if (![GoodsInfo goodsStatusIsOnSale:item.status]) {
                        isExistInvalidGoods = YES;
                    }
                }
            }
        }
        if ([items count]> 0) {
            if (isExistInvalidGoods) {
                [weakSelf showHUD:@"存在失效商品" hideAfterDelay:0.8f forView:weakSelf.tableView];
            } else {
                PayViewController *payViewController = [[PayViewController alloc] init];
                NSLog(@"%@", items);
                payViewController.items = items;
                payViewController.formShopCar = 1;
                payViewController.handlePayDidFnishBlock = ^(BaseViewController *payViewController, NSInteger index) {
                    
                    //                    [[NetworkManager sharedInstance] addRequest:[[NetworkManager sharedInstance] requestWithMethodGET:@"trade" path:@"goods_last_order" parameters:@{@"goods_sn":shopItem.goodsId} completionBlock:^(NSDictionary *data) {
                    
                    //                        OrderDetailInfo *detailInfo = data[@"order_detail"];
                    
                    //                        [controller getOrderDetailInfo:detailInfo];
                    
                    
                    //                    } failure:^(XMError *error) {
                    //
                    //                    } queue:nil]];
                    
                    //                    BoughtCollectionViewController *viewController = [[BoughtCollectionViewController alloc] init];
                    //                    for (int i = 0; i < items.count; i++) {
                    //                        ShoppingCartItem *shopItem = items[i];
                    //                        if (shopItem.service_type == 3 || shopItem.service_type == 4 || shopItem.service_type == 5) {
                    //                            viewController.selectSegmentIndex = 1;
                    //                            viewController.type = 1;
                    //                        } else {
                    //                            viewController.selectSegmentIndex = 0;
                    //                        }
                    //                    }
                    //                    [weakSelf pushViewController:viewController animated:YES];
                    if (index == 1) {
                        //                        SEL selector = @selector($$handlePayResultCompletionNotification:orderIds:);
                        //                        MBGlobalSendNotificationForSELWithBody(selector, [PayManager sharedInstance].orderIds);
                        [payViewController dismiss:NO];
                        
                        ShoppingCartItem *shopItem = items[0];
                        SuccessfulPayViewController *controller = [[SuccessfulPayViewController alloc] init];
                        controller.goodsId = shopItem.goodsId;
                        [weakSelf pushViewController:controller animated:YES];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"jumpAlert" object:nil];
                    }
                };
                [weakSelf.navigationController pushViewController:payViewController animated:YES];
            }
        } else {
            [weakSelf showHUD:@"请至少选择一个商品" hideAfterDelay:0.8f forView:weakSelf.tableView];
        }
    };
    return bottomView;
}

- (void)doSelectAll:(BOOL)selectAll
{
    for (NSInteger i=0;i<[self.dataSources count];i++) {
        NSMutableDictionary *dict = [self.dataSources objectAtIndex:i];
        ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
        if ([item isOnSale]) {
            [dict setObject:[NSNumber numberWithBool:selectAll] forKey:[ShoppingCartTableViewCell cellDictKeyForSeleted]];
        }
    }
    [self.tableView reloadData];
    
    UIButton *sender = (UIButton*)[self.bottomView viewWithTag:100];
    sender.selected = selectAll;
    UILabel *priceLbl = (UILabel*)[self.bottomView viewWithTag:200];
    [priceLbl sizeToFit];
}



- (void)doUpdateTotalPrice {
    double totalPrice = 0.f;
    WEAKSELF;
    for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
        NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
        ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
        if ([item isOnSale]) {
            BOOL isSelected = [dict boolValueForKey:[ShoppingCartTableViewCell cellDictKeyForSeleted] defaultValue:NO];
            if (isSelected) {
                ShoppingCartItem *item = (ShoppingCartItem*)[dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
                totalPrice += item.shopPrice;
            }
        }
    }
    UILabel *priceLbl = (UILabel*)[self.bottomView viewWithTag:200];
    priceLbl.text = [NSString stringWithFormat:@"合计: ¥%.2f", totalPrice];
    priceLbl.attributedText = [NSMutableAttributedString AttributedStringWith:priceLbl.text RangeOfString:[NSString stringWithFormat:@"¥%.2f",totalPrice] UIcolor:[UIColor redColor]];
    [priceLbl sizeToFit];
}

- (UIImageView*)buildEditView
{
    WEAKSELF;
    UIImage *bgImage = [UIImage imageNamed:@"bottombar_bg_white"];
    UIImageView *editView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 56)];
    editView.userInteractionEnabled = YES;
    [editView setImage:[bgImage stretchableImageWithLeftCapWidth:bgImage.size.width/2 topCapHeight:bgImage.size.height/2]];
    editView.backgroundColor = [UIColor whiteColor];
    
    CommandButton *selectAllBtn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 1, self.view.bounds.size.width, editView.bounds.size.height -1)];
    selectAllBtn.tag = 100;
    selectAllBtn.backgroundColor = [UIColor clearColor];
    [selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [selectAllBtn setTitleColor:[UIColor colorWithHexString:@"181818"] forState:UIControlStateNormal];
    [selectAllBtn setImage:[UIImage imageNamed:@"shopping_cart_uncgoose_new"] forState:UIControlStateNormal];
    [selectAllBtn setImage:[UIImage imageNamed:@"shopping_cart_choosed_new"] forState:UIControlStateSelected];
    selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    selectAllBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -7.5, 0, 0);
    selectAllBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 7.5, 0, 0);
    [selectAllBtn sizeToFit];
    selectAllBtn.frame = CGRectMake(15, 1, selectAllBtn.bounds.size.width+7.5, editView.bounds.size.height -1);
    [editView addSubview:selectAllBtn];
    
    CGFloat marginRight = 8.5f;
    CommandButton *delBtn = [[CommandButton alloc] initWithFrame:CGRectMake(kScreenWidth - kScreenWidth/375*104 - 12, 8, kScreenWidth/375*104, 40)];
    delBtn.backgroundColor = [UIColor colorWithHexString:@"f9384c"];
    delBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    delBtn.layer.masksToBounds = YES;
    delBtn.layer.cornerRadius = 2;
    [delBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editView addSubview:delBtn];
    
    marginRight += delBtn.bounds.size.width;
    marginRight += 10.f;
    
//    CommandButton *clearBtn = [[CommandButton alloc] initWithFrame: CGRectMake(kScreenWidth - kScreenWidth/375*104*2 - 12 - 8, 8, kScreenWidth/375*104, 40)];
//    clearBtn.backgroundColor = [UIColor colorWithHexString:@"1a1a1a"];
//    clearBtn.layer.borderColor = [UIColor colorWithHexString:@"1a1a1a"].CGColor;
//    clearBtn.layer.borderWidth = 1;
//    clearBtn.layer.masksToBounds = YES;
//    clearBtn.layer.cornerRadius = 2;
//    clearBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
//    [clearBtn setTitle:@"清除失效商品" forState:UIControlStateNormal];
//    [clearBtn setTitleColor:[UIColor colorWithHexString:@"ffffff"] forState:UIControlStateNormal];
//    [editView addSubview:clearBtn];
    
    selectAllBtn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf doSelectAllInEditMode:!sender.selected];
    };
    delBtn.handleClickBlock = ^(CommandButton *sender) {
        
        //add code弹出删除确认框
        
        NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
        for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
            if ([dict[@"clsName"] isEqualToString:KShoppingCartTableViewCell]) {
                BOOL isSelected = [dict boolValueForKey:[ShoppingCartTableViewCell cellDictKeyForSeleted] defaultValue:NO];
                if (isSelected) {
                    ShoppingCartItem *item = (ShoppingCartItem*)[dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
                    [goodsIds addObject:item.goodsId];
                }
            }
        }
        if ([goodsIds count]>0) {
            [WCAlertView showAlertWithTitle:@"" message:@"您确定要删除这件商品么?" customizationBlock:^(WCAlertView *alertView) {
                
            } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                if (buttonIndex == 1) {
                    [weakSelf showProcessingHUD:nil forView:weakSelf.tableView];
                    weakSelf.request = [[NetworkAPI sharedInstance] removeFromShoppingCart:goodsIds completion:^(NSInteger totalNum) {
                        [[Session sharedInstance] setShoppingCartGoods:totalNum removedGoodsIds:goodsIds];
                        [weakSelf hideHUD];
                    } failure:^(XMError *error) {
                        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
                    }];
                }
            } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            
        } else {
            [weakSelf showHUD:@"请选择要删除的商品" hideAfterDelay:0.8f forView:weakSelf.tableView];
        }
    };
//    clearBtn.handleClickBlock = ^(CommandButton *sender) {
//        NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
//        for (NSInteger i=0;i<[weakSelf.dataSources count];i+=1) {//之前是+=2，不知道是因为什么这么写 现在调整为+=1
//            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
//            if ([dict[@"clsName"] isEqualToString:KShoppingCartTableViewCell]) {
//                ShoppingCartItem *item = [dict objectForKeyedSubscript:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
//                if (![GoodsInfo goodsStatusIsOnSale:item.status]) {
//                    [goodsIds addObject:item.goodsId];
//                }
//            }
//            
//        }
//        if ([goodsIds count]>0) {
//            [weakSelf showProcessingHUD:nil forView:weakSelf.tableView];
//            weakSelf.request = [[NetworkAPI sharedInstance] removeFromShoppingCart:goodsIds completion:^(NSInteger totalNum) {
//                [[Session sharedInstance] setShoppingCartGoods:totalNum removedGoodsIds:goodsIds];
//                [weakSelf hideHUD];
//            } failure:^(XMError *error) {
//                [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
//            }];
//        }
//    };
    return editView;
}

- (void)doSelectAllInEditMode:(BOOL)selectAll
{
    for (NSInteger i=0;i<[self.dataSources count];i++) {
        NSMutableDictionary *dict = [self.dataSources objectAtIndex:i];
        // [dict setObject:[NSNumber numberWithBool:selectAll] forKey:[ShoppingCartTableViewCell cellDictKeyForSeletedInEditMode]];
        ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
        if ([item isOnSale]) {
            [dict setObject:[NSNumber numberWithBool:selectAll] forKey:[ShoppingCartTableViewCell cellDictKeyForSeleted]];
        }
    }
    [self.tableView reloadData];
    
    UIButton *sender = (UIButton*)[self.editView viewWithTag:100];
    sender.selected = selectAll;
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    //    self.bottomView.hidden = sender.selected;
    self.editView.hidden = !sender.selected;
    self.editing = sender.selected;

    [self checkIsEditing];
    [self doCheckIFSelectedAll];
    [self.tableView reloadData];
}

- (void)handleTopBarViewClicked {
    [_tableView scrollViewToTop:YES];
}

-(NSArray*)createRightButtons
{
    int number = 2;
    NSMutableArray * result = [NSMutableArray array];
    NSString* titles[2] = {@"删除", @"移入心动列表"};
    UIColor * colors[2] = {[UIColor redColor], [UIColor lightGrayColor]};
    UIImage * image[2] = {[UIImage imageNamed:@"shoppingCartDel"],[UIImage imageNamed:@"shoppingCartLike"]};
    for (int i = 0; i < number; ++i)
    {
        SwipeCellButton * button = [SwipeCellButton buttonWithTitle:titles[i] icon:image[i] backgroundColor:colors[i] padding:5 callback:^BOOL(SwipeTableViewCell * _Nonnull cell) {
            return YES;
        }];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        [button centerIconOverText];
        [result addObject:button];
    }
    return result;
}

-(NSArray*)swipeTableCell:(SwipeTableViewCell*) cell swipeButtonsForDirection:(SwipeDirection)direction
            swipeSettings:(SwipeSettings*) swipeSettings expansionSettings:(SwipeExpansionSettings*) expansionSettings{
    swipeSettings.transition = SwipeTransitionBorder;
    cell.allowsButtonsWithDifferentWidth = YES;
    if (direction == SwipeDirectionLeftToRight) {
        return nil;
    }
    else {
        expansionSettings.buttonIndex = -1;
        expansionSettings.fillOnTrigger = YES;
        return [self createRightButtons];
    }
}

-(BOOL) swipeTableCell:(SwipeTableViewCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(SwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
          direction == SwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    if (direction == SwipeDirectionRightToLeft && index == 0) {
        //delete button
        
        [WCAlertView showAlertWithTitle:@"" message:@"确定要删除这件商品么?" customizationBlock:^(WCAlertView *alertView) {
            
        } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
            if (buttonIndex == 1) {
                NSIndexPath * path = [self.tableView indexPathForCell:cell];
                NSDictionary *dict = [_dataSources objectAtIndex:path.row];
                ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
                
                WEAKSELF;
                NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
                [goodsIds addObject:item.goodsId];
                [_request cancel];
                _request = [[NetworkAPI sharedInstance] removeFromShoppingCart:goodsIds completion:^(NSInteger totalNum) {
                    
                    //[weakSelf.dataSources removeObjectAtIndex:path.row];
                    //[self.tableView deleteRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
                    [[Session sharedInstance] setShoppingCartGoods:totalNum removedGoodsIds:goodsIds];
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
                }];
            }
        } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        
    } else if (direction == SwipeDirectionRightToLeft && index == 1){
        NSIndexPath * path = [self.tableView indexPathForCell:cell];
        NSDictionary *dict = [_dataSources objectAtIndex:path.row];
        ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
        [GoodsSingletonCommand likeGoods:item.goodsId];
    }
    
    return YES;
}

- (void)$$handleGoodsLiked:(id<MBNotification>)notifi goodsId:(NSString*)goodsId{
    WEAKSELF;
    NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
    [goodsIds addObject:goodsId];
    [_request cancel];
    _request = [[NetworkAPI sharedInstance] removeFromShoppingCart:goodsIds completion:^(NSInteger totalNum) {
        
        [self showHUD:@"成功移入心动列表,你可以\n在我的--心动中查找" hideAfterDelay:1.2];
        [[Session sharedInstance] setShoppingCartGoods:totalNum removedGoodsIds:goodsIds];
    } failure:^(XMError *error) {
        [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
    }];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [_tableView scrollViewDidEndDragging:scrollView];
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    _tableView.pullTableIsRefreshing = YES;
    [self loadRecommandGoods];
}

- (void)pullTableViewDidTriggerLoadMore:(PullRefreshTableView*)pullTableView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView scrollViewDidScroll:scrollView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSources count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = [BaseTableViewCell clsTableViewCell:dict];
    NSString *reuseIdentifier = [ClsTableViewCell reuseIdentifier];
    
    BaseTableViewCell *tableViewCell = (BaseTableViewCell*)[tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (tableViewCell == nil) {
        tableViewCell = [[ClsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        [tableViewCell setBackgroundColor:[tableView backgroundColor]];
        [tableViewCell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
        if ([tableViewCell isKindOfClass:[SwipeTableViewCell class]]) {
            ((SwipeTableViewCell*)tableViewCell).swipeCellDelegate = self;
        }
    if ([tableViewCell isKindOfClass:[ShoppingCartTableViewCell class]]) {
        WEAKSELF;
        ((ShoppingCartTableViewCell*)tableViewCell).selectedHandlerBlock = ^(ShoppingCartTableViewCell *cell, NSInteger index) {
            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:index];
            
            if ([dict[@"clsName"] isEqualToString:KShoppingCartTableViewCell]) {
                BOOL isSelected = [dict boolValueForKey:[ShoppingCartTableViewCell cellDictKeyForSeleted] defaultValue:NO];
                [dict setObject:[NSNumber numberWithBool:!isSelected] forKey:[ShoppingCartTableViewCell cellDictKeyForSeleted]];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                
                [weakSelf doCheckIFSelectedAll];
                [weakSelf doCheckIFSelectedAllInEditMode];
                [weakSelf doUpdateTotalPrice];
            }
            
            
        };
        
        ((ShoppingCartTableViewCell *)tableViewCell).delGoodsBlock = ^(ShoppingCartTableViewCell * cell,NSInteger index){
            
            NSDictionary * dict = [weakSelf.dataSources objectAtIndex:index];
            
            if ([dict[@"clsName"] isEqualToString:KShoppingCartTableViewCell]) {
                
                [WCAlertView showAlertWithTitle:@"" message:@"确定要删除这件商品么?" customizationBlock:^(WCAlertView *alertView) {
                    
                } completionBlock:^(NSUInteger buttonIndex, WCAlertView *alertView) {
                    if (buttonIndex == 1) {
                        NSIndexPath * path = [self.tableView indexPathForCell:cell];
                        NSDictionary *dict = [self.dataSources objectAtIndex:path.row];
                        ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
                        
                        WEAKSELF;
                        NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
                        [goodsIds addObject:item.goodsId];
                        [_request cancel];
                        _request = [[NetworkAPI sharedInstance] removeFromShoppingCart:goodsIds completion:^(NSInteger totalNum) {
                            [[Session sharedInstance] setShoppingCartGoods:totalNum removedGoodsIds:goodsIds];
                        } failure:^(XMError *error) {
                            [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
                        }];
                    }
                } cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            }
            
        };
        
        [tableViewCell updateCellWithDict:dict index:[indexPath row]];
    }
    
    if ([tableViewCell isKindOfClass:[ShoppingCartDelCell class]]) {
        WEAKSELF;
        ((ShoppingCartDelCell *)tableViewCell).handleShoppingCartDeleteBlcok = ^{
            NSMutableArray *goodsIds = [[NSMutableArray alloc] init];
            for (NSInteger i=0;i<[weakSelf.dataSources count];i+=1) {//之前是+=2，不知道是因为什么这么写 现在调整为+=1
                NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
                if ([dict[@"clsName"] isEqualToString:KShoppingCartTableViewCell]) {
                    ShoppingCartItem *item = [dict objectForKeyedSubscript:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
                    if (![GoodsInfo goodsStatusIsOnSale:item.status]) {
                        [goodsIds addObject:item.goodsId];
                    }
                }
                
            }

            if ([goodsIds count]>0) {
                [weakSelf showProcessingHUD:nil forView:weakSelf.tableView];
                weakSelf.request = [[NetworkAPI sharedInstance] removeFromShoppingCart:goodsIds completion:^(NSInteger totalNum) {
                    [[Session sharedInstance] setShoppingCartGoods:totalNum removedGoodsIds:goodsIds];
                    [weakSelf hideHUD];
                } failure:^(XMError *error) {
                    [weakSelf showHUD:[error errorMsg] hideAfterDelay:0.8f forView:weakSelf.tableView];
                }];
            }
        };
    }
    
    if ([tableViewCell isKindOfClass:[RecommendGoodsCell class]]) {
        [tableViewCell updateCellWithDict:dict];
    }
    
    
    return tableViewCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
    
    Class ClsTableViewCell = NSClassFromString([dict stringValueForKey:[BaseTableViewCell dictKeyOfClsName]]);
    return [ClsTableViewCell rowHeightForPortrait:dict];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[[self.dataSources objectAtIndex:[indexPath row]] objectForKey:@"clsName"] isEqualToString:KShoppingCartTableViewCell]) {
        if ([self isEditing]) {
            NSMutableDictionary *dict = [self.dataSources objectAtIndex:[indexPath row]];
            BOOL isSelected = [dict boolValueForKey:[ShoppingCartTableViewCell cellDictKeyForSeleted] defaultValue:NO];
            [dict setObject:[NSNumber numberWithBool:!isSelected] forKey:[ShoppingCartTableViewCell cellDictKeyForSeleted]];
            
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[indexPath row] inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            [self doCheckIFSelectedAllInEditMode];
            
        } else {
            NSDictionary *dict = [_dataSources objectAtIndex:[indexPath row]];
            ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
            [[CoordinatingController sharedInstance] gotoGoodsDetailViewController:item.goodsId animated:YES];
        }
    }
    
}

- (void)doCheckIFSelectedAll {
    WEAKSELF;
    BOOL isSelcectedAll = YES;
    if ([weakSelf.dataSources count]==0) {
        isSelcectedAll = NO;
    }
    else {
        for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
            ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
            if ([item isOnSale]) {
                if ([dict[@"clsName"] isEqualToString:KShoppingCartTableViewCell]){
                    isSelcectedAll = [dict boolValueForKey:[ShoppingCartTableViewCell cellDictKeyForSeleted] defaultValue:NO];
                    if (!isSelcectedAll) break;
                }
            }
        }
    }
    CommandButton *selectedAllBtn = (CommandButton*)[weakSelf.bottomView viewWithTag:100];
    selectedAllBtn.selected = isSelcectedAll;
    
    CommandButton *editSelectedAllBtn = (CommandButton*)[weakSelf.editView viewWithTag:100];
    editSelectedAllBtn.selected = isSelcectedAll;
}

- (void)doCheckIFSelectedAllInEditMode {
    WEAKSELF;
    BOOL isSelcectedAll = YES;
    if ([weakSelf.dataSources count]==0) {
        isSelcectedAll = NO;
    } else {
        for (NSInteger i=0;i<[weakSelf.dataSources count];i++) {
            NSMutableDictionary *dict = [weakSelf.dataSources objectAtIndex:i];
            ShoppingCartItem *item = [dict objectForKey:[ShoppingCartTableViewCell cellDictKeyForShoppingCartItem]];
            if ([item isOnSale]) {
                if ([dict[@"clsName"] isEqualToString:KShoppingCartTableViewCell]){
                    isSelcectedAll = [dict boolValueForKey:[ShoppingCartTableViewCell cellDictKeyForSeleted] defaultValue:NO];
                    if (!isSelcectedAll) break;
                }
            }
        }
    }
    
    CommandButton *selectedAllBtn = (CommandButton*)[weakSelf.editView viewWithTag:100];
    selectedAllBtn.selected = isSelcectedAll;
}


- (void)$$handleTokenDidExpireNotification:(id<MBNotification>)notifi
{
    
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

    NSMutableArray *dataSources = [[NSMutableArray alloc] init];
    NSArray *items = [Session sharedInstance].shoppingCartItems;
    if (items.count > 0){
        for (ShoppingCartItem *item in items) {
            if ([item isKindOfClass:[ShoppingCartItem class]]) {
                [dataSources addObject:[ShoppingCartTableViewCell buildCellDict:item]];
            }
        }

        self.topBarRightButton.hidden = NO;
        self.bottomView.hidden = NO;
        self.tableView.frame = CGRectMake(0, self.topBarHeight, kScreenWidth, kScreenHeight- self.topBarHeight-56);
    }else{
        self.topBarRightButton.hidden = YES;
        self.topBarRightButton.hidden = YES;
        self.bottomView.hidden = YES;
        self.editView.hidden = YES;
        self.tableView.frame = CGRectMake(0, self.topBarHeight, kScreenWidth, kScreenHeight- self.topBarHeight);
        [dataSources addObject:[ShoppingCartNocontentCell buildCellDict]];
    }

    if ([self.goodsRecommendList count]>0) {
        [dataSources addObject:[ShoppingCartDelCell buildCellDict]];
        [dataSources addObject:[GoodsRecommendSepCell buildCellDict]];
        for (NSInteger i=0;i<[self.goodsRecommendList count];i++) {
            NSArray *array = [self.goodsRecommendList objectAtIndex:i];
            [dataSources addObject:[RecommendGoodsCell buildCellDict:array]];
            [dataSources addObject:[SepWhiteTableViewCell buildCellDict]];
        }
    }
    
    self.dataSources = dataSources;

    if ([items count]==1) {
        [self doSelectAll:YES];
    } else {
        [self doSelectAll:NO];
    }
    
    [self checkIsEditing];
    [self doCheckIFSelectedAll];
    [self doCheckIFSelectedAllInEditMode];
    [self doUpdateTotalPrice];
    
    
    [self.tableView reloadData];
}

- (void)checkIsEditing{
    if ([self isEditing]) {
        self.tableView.enableRefreshing = NO;
        for (int i = 0 ; i < self.dataSources.count; i++) {
            NSMutableDictionary * dict = [self.dataSources objectAtIndex:i];
            if ([dict[@"clsName"] isEqualToString:KShoppingCartTableViewCell]) {
                [dict setObject:[NSNumber numberWithBool:NO] forKey:[ShoppingCartTableViewCell cellDictKeyForInEdit]];
            }
        }
        
    }else{
        self.tableView.enableRefreshing = YES;
        for (int i = 0 ; i < self.dataSources.count; i++) {
            NSMutableDictionary * dict = [self.dataSources objectAtIndex:i];
            if ([dict[@"clsName"] isEqualToString:KShoppingCartTableViewCell]) {
                [dict setObject:[NSNumber numberWithBool:YES] forKey:[ShoppingCartTableViewCell cellDictKeyForInEdit]];
            }
        }
    }
}

@end



