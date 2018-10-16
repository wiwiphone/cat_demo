//
//  SaleViewController.m
//  XianMao
//
//  Created by simon cai on 11/10/14.
//  Copyright (c) 2014 XianMao. All rights reserved.
//

#import "SaleViewController.h"
#import "WebViewController.h"
#import "Command.h"
#import "PublishGoodsViewController.h"

#import "CoordinatingController.h"

#import "ASScroll.h"
#import "TTTAttributedLabel.h"
#import "MainViewController.h"
#import "WebViewController.h"

#import "URLScheme.h"
#import "DMPagingScrollView.h"

#import "MyNavigationController.h"
#import "RecommendService.h"

#import "RecommendTableViewCell.h"
#import "SepTableViewCell.h"
#import "RecommendInfo.h"

#import "AppDirs.h"

@interface SaleViewController () <TTTAttributedLabelDelegate>

@property(nonatomic,weak) UIView *bottomView;

@end

@implementation SaleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    @property(nonatomic,readonly,weak) UIButton *topBarBackButton;
//    @property(nonatomic,readonly,weak) UIButton *topBarRightButton;
    
    [super.goodsNumLbl removeFromSuperview];
    [super.shoppingCartBtn removeFromSuperview];
    [super.topBarBackButton removeFromSuperview];
    [super.topBarRightButton removeFromSuperview];
    
    [super setupTopBarTitle:@"发布商品"];
    
    [super setupTopBarRightButton];
    super.topBarRightButton.backgroundColor = [UIColor clearColor];
    [self.topBarRightButton setTitle:@"更多帮助" forState:UIControlStateNormal];
    
    CGFloat hegight = self.topBarRightButton.height;
    [self.topBarRightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.topBarRightButton sizeToFit];
    self.topBarRightButton.frame = CGRectMake(self.topBar.width-15-self.topBarRightButton.width, self.topBarRightButton.top, self.topBarRightButton.width, hegight);
    
    
    self.tableView.enableLoadingMore = NO;
    self.tableView.enableRefreshing = YES;
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, self.view.height-95);
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-95, kScreenWidth, 95)];
    bottomView.backgroundColor = [UIColor colorWithHexString:@"f3f3f3"];
    [self.view addSubview:bottomView];
    _bottomView = bottomView;
    
    
    
    CommandButton *btn  = [[CommandButton alloc] initWithFrame:CGRectMake((self.view.width-270)/2, 0, 270, 36)];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitle:@"发布商品" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithHexString:@"c2a79d"];
    btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
    btn.tag = 800;
    [bottomView addSubview:btn];
    
    WEAKSELF;
    btn.handleClickBlock = ^(CommandButton *sender) {
        [weakSelf showPublishGoodsView];
        //        UIButton *agreeBtnTmp = (UIButton*)[weakSelf.view viewWithTag:500];
        //        BOOL isAgree = [agreeBtnTmp isSelected];
        //        if (isAgree) {
        //            PublishGoodsViewController *viewController = [[PublishGoodsViewController alloc] init];
        //            viewController.handlePublishGoodsFinished = ^(GoodsEditableInfo *goodsEditableInfo) {
        //                [weakSelf showHUD:@"发布成功，请等待审核" hideAfterDelay:1.2];
        //            };
        //            MyNavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
        //
        //            [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{
        //
        //            }];
        //        } else {
        //            [weakSelf showHUD:@"请先同意平台售卖协议" hideAfterDelay:0.8f];
        //        }
    };

    
    
    TTTAttributedLabel *agreementLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, bottomView.width, 0)];
    agreementLbl.delegate = self;
    agreementLbl.font = [UIFont systemFontOfSize:11.f];
    agreementLbl.textColor = [UIColor colorWithHexString:@"333333"];
    agreementLbl.lineBreakMode = NSLineBreakByWordWrapping;
    agreementLbl.userInteractionEnabled = YES;
    agreementLbl.highlightedTextColor = [UIColor colorWithHexString:@"06a6a6"];
    agreementLbl.numberOfLines = 0;
    //    agreementLbl.autoresizesSubviews = YES;
    agreementLbl.linkAttributes = nil;
    NSMutableDictionary* attributes = [NSMutableDictionary dictionaryWithDictionary:agreementLbl.activeLinkAttributes];
    [attributes setObject:(__bridge id)[UIColor colorWithHexString:@"D0B87F"].CGColor forKey:(NSString*)kCTForegroundColorAttributeName];
    agreementLbl.activeLinkAttributes = attributes;
    
    [agreementLbl setText:@"已阅读并同意《爱丁猫商品售卖协议》" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
        NSRange stringRange = NSMakeRange(mutableAttributedString.length-7,7);
        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"c2a79d"] CGColor] range:stringRange];//b28132
        return mutableAttributedString;
    }];
    
    [agreementLbl addLinkToURL:[NSURL URLWithString:@"http://activity.aidingmao.com/share/page/63"] withRange:NSMakeRange([agreementLbl.text length]-6,6)];
    [agreementLbl sizeToFit];
    agreementLbl.frame = CGRectMake((bottomView.width-agreementLbl.bounds.size.width)/2+16, bottomView.height-28, agreementLbl.bounds.size.width, agreementLbl.bounds.size.height);
    [bottomView addSubview:agreementLbl];
    
    CommandButton *agreeBtn = [[CommandButton alloc] initWithFrame:CGRectMake(agreementLbl.frame.origin.x-25, agreementLbl.frame.origin.y-(30.f-agreementLbl.bounds.size.height)/2-1, 30, 30)];
    
    agreeBtn.selected = YES;
    [agreeBtn setImage:[UIImage imageNamed:@"login_checked.png"] forState:UIControlStateNormal];
    [bottomView addSubview:agreeBtn];
    agreeBtn.handleClickBlock = ^(CommandButton *sender) {
        sender.selected = !sender.isSelected;
//        UIButton *btnTmp = (UIButton*)[weakSelf.bottomView viewWithTag:800];
        
        if ([sender isSelected]) {
            [sender setImage:[UIImage imageNamed:@"login_checked.png"] forState:UIControlStateNormal];
            //            btnTmp.layer.borderColor = [UIColor colorWithHexString:@"e5c98b"].CGColor;
            //            [btnTmp setTitleColor:[UIColor colorWithHexString:@"e5c98b"] forState:UIControlStateNormal];
            //            btnTmp.enabled = YES;
        } else {
            [sender setImage:[UIImage imageNamed:@"login_check.png"] forState:UIControlStateNormal];
            
            //            btnTmp.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
            //            [btnTmp setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
            //            btnTmp.enabled = NO;
        }
    };
    agreeBtn.tag = 500;
    
    btn.frame = CGRectMake((bottomView.width-btn.width)/2,agreeBtn.top-6-btn.height, btn.width, btn.height);
    
    if ([self.dataSources count]==0) {
        [self loadData];
    } else {
        [self.tableView reloadData];
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
 
    self.tableView.frame = CGRectMake(0, 0, kScreenWidth, self.view.height-95);
    _bottomView.frame = CGRectMake(0, self.view.height-95, kScreenWidth, 95);
}

- (void)handleTopBarRightButtonClicked:(UIButton *)sender
{
    WebViewController *viewController = [[WebViewController alloc] init];
    viewController.title = @"";
    viewController.url = @"http://activity.aidingmao.com/share/page/384?_reflash=1";
    [self pushViewController:viewController animated:YES];
}

- (void)loadFromCache
{
    WEAKSELF;
    NSString *filePath = [AppDirs publishInfoListCacheFile];
    BOOL isDirectory = NO;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (fm
        && [fm fileExistsAtPath:filePath isDirectory:&isDirectory]
        && !isDirectory) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSDictionary *dict = [unarchiver decodeObjectForKey:@"data"];
        [unarchiver finishDecoding];
        NSMutableArray *list = [[NSMutableArray alloc] initWithArray:[dict arrayValueForKey:@"items"]];
        
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[list count]];
        for (int i=0;i<[list count];i++) {
            RecommendInfo *recommendInfo = [list objectAtIndex:i];
            if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                
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
    }
    
    if ([weakSelf.dataSources count]==0) {
        NSMutableArray *newList = [NSMutableArray arrayWithCapacity:3];
        [newList addObject:[SaleTableViewCell buildCellDict:[UIImage imageNamed:@"goods_publish_intro_1"]]];
        [newList addObject:[SaleTableViewCell buildCellDict:[UIImage imageNamed:@"goods_publish_intro_2"]]];
        [newList addObject:[SaleTableViewCell buildCellDict:[UIImage imageNamed:@"goods_publish_intro_3"]]];
        weakSelf.dataSources = newList;
        [weakSelf.tableView reloadData];
    }
}

- (void)pullTableViewDidTriggerRefresh:(PullRefreshTableView*)pullTableView {
    self.tableView.pullTableIsRefreshing  =YES;
    [self loadData];
}


- (void)loadData
{
    
    [self loadFromCache];
    
    WEAKSELF;
    [RecommendService publish_info:^(NSArray *list) {
        
        if ([list count]>0) {
            NSMutableArray *newList = [NSMutableArray arrayWithCapacity:[list count]];
            for (int i=0;i<[list count];i++) {
                RecommendInfo *recommendInfo = [list objectAtIndex:i];
                if ([recommendInfo isCompatible] && [recommendInfo isValid] && [recommendInfo recommendCellCls]) {
                    
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
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:[NSNumber numberWithInteger:[list count]] forKey:@"count"];
            [dict setObject:list forKey:@"items"];
            
            NSMutableData *data = [[NSMutableData alloc] init];
            NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
            [archiver encodeObject:dict forKey:@"data"];
            [archiver finishEncoding];
            [data writeToFile:[AppDirs publishInfoListCacheFile] atomically:YES];
        }
        
        weakSelf.tableView.pullTableIsRefreshing = NO;
    } failure:^(XMError *error) {
        weakSelf.tableView.pullTableIsRefreshing = NO;
    }];
}

- (void)initDataListLogic
{
    
}

- (void)showPublishGoodsView
{
    WEAKSELF;
    UIButton *agreeBtnTmp = (UIButton*)[weakSelf.view viewWithTag:500];
    BOOL isAgree = [agreeBtnTmp isSelected];
    if (isAgree) {

        WEAKSELF;
        BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkBindingStateAndPresentLoginController:self bindingAlert:@"请绑定手机号，当您错过买家的消息时，我们将会给您手机短信通知。" completion:^{ }];
        if (isLoggedIn) {
            PublishGoodsViewController *viewController = [[PublishGoodsViewController alloc] init];
            viewController.handlePublishGoodsFinished = ^(GoodsEditableInfo *goodsEditableInfo) {
                [weakSelf showHUD:@"发布成功" hideAfterDelay:2.f];
            };
            MyNavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];

            [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{

            }];
        }
    } else {
        [weakSelf showHUD:@"请先同意平台售卖协议" hideAfterDelay:0.8f];
    }

    [MobClick event:@"click_sell_button"];
}

- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    //    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
    if ([[url absoluteString] length]>0) {
        WebViewController *viewController = [[WebViewController alloc] init];
        viewController.title = @"平台售卖协议";
        viewController.url = [url absoluteString];
        [self pushViewController:viewController animated:YES];
    }
}

@end



@interface SaleTableViewCell ()

@property(nonatomic,weak) UIImageView *saleImageView;

@end

@implementation SaleTableViewCell

+ (NSString *)reuseIdentifier {
    static NSString *__reuseIdentifier = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __reuseIdentifier = NSStringFromClass([SaleTableViewCell class]);
    });
    return __reuseIdentifier;
}

+ (CGFloat)rowHeightForPortrait:(NSDictionary*)dict {
    CGFloat height = 0.f;
    UIImage *image = (UIImage*)[dict objectForKey:@"image"];
    if ([image isKindOfClass:[UIImage class]]) {
        height = image.size.height*kScreenWidth/320.f;
    }
    return height;
}

+ (NSMutableDictionary*)buildCellDict:(UIImage*)image
{
    NSMutableDictionary *dict = [[super class] buildBaseCellDict:[SaleTableViewCell class]];
    if (image)[dict setObject:image forKey:@"image"];
    return dict;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIImageView *saleImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.contentView addSubview:saleImageView];
        _saleImageView = saleImageView;
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _saleImageView.image = nil;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _saleImageView.frame = self.contentView.bounds;
}

- (void)updateCellWithDict:(NSDictionary*)dict
{
    UIImage *image = (UIImage*)[dict objectForKey:@"image"];
    if ([image isKindOfClass:[UIImage class]]) {
        _saleImageView.image = image;
        [self setNeedsLayout];
    }
}

@end



//@interface SaleViewController () <UIScrollViewDelegate,TTTAttributedLabelDelegate>
//
//@property(nonatomic,weak) UIScrollView *scrollView;
//@property(nonatomic,weak) ASScrollPageIndicatorView *pageIndicatorView;
//
//@end
//
//@implementation SaleViewController
//
//
//- (void)showPublishGoodsView
//{
//    WEAKSELF;
//    UIButton *agreeBtnTmp = (UIButton*)[weakSelf.view viewWithTag:500];
//    BOOL isAgree = [agreeBtnTmp isSelected];
//    if (isAgree) {
//        
//        WEAKSELF;
//        BOOL isLoggedIn = [[CoordinatingController sharedInstance] checkBindingStateAndPresentLoginController:self bindingAlert:@"请绑定手机号，当您错过买家的消息时，我们将会给您手机短信通知。" completion:^{ }];
//        if (isLoggedIn) {
//            PublishGoodsViewController *viewController = [[PublishGoodsViewController alloc] init];
//            viewController.handlePublishGoodsFinished = ^(GoodsEditableInfo *goodsEditableInfo) {
//                [weakSelf showHUD:@"发布成功" hideAfterDelay:2.f];
//            };
//            MyNavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
//            
//            [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{
//                
//            }];
//        }
//    } else {
//        [weakSelf showHUD:@"请先同意平台售卖协议" hideAfterDelay:0.8f];
//    }
//    
//    [MobClick event:@"click_sell_button"];
//}
//
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    self.view.backgroundColor = [UIColor colorWithHexString:@"181818"];
//    
//    CGFloat topBarHeight = [super setupTopBar];
//    [super setupTopBarTitle:@"发布商品"];
//    self.topBar.image = nil;
//    self.topBar.backgroundColor = [UIColor colorWithHexString:@"181818"];
//    self.topBarTitleLbl.textColor = [UIColor whiteColor];
//    
//    
//    DMPagingScrollView *scrollView = [[DMPagingScrollView alloc] initWithFrame:CGRectMake(0, topBarHeight, self.view.width, self.view.height-topBarHeight-kBottomTabBarHeight)];
//    _scrollView = scrollView;
//    _scrollView.delegate = self;
//    _scrollView.showsVerticalScrollIndicator = NO;
//    _scrollView.showsHorizontalScrollIndicator = NO;
//    _scrollView.pagingEnabled = YES;
//    _scrollView.scrollsToTop = NO;
//    _scrollView.clipsToBounds = NO;
//    _scrollView.backgroundColor = [UIColor clearColor];
//    [self.view addSubview:_scrollView];
//    ///[_scrollView setContentSize:CGSizeMake(6*pageWidth, pageHeight)];
//    
//    
//    CommandButton *btn  = [[CommandButton alloc] initWithFrame:CGRectMake((self.view.width-180)/2, 0, 180, 45)];
//    btn.layer.masksToBounds = YES;
//    btn.layer.cornerRadius = 45.f/2;
//    btn.layer.borderWidth  = 1.f;
//    btn.layer.borderColor = [UIColor colorWithHexString:@"e5c98b"].CGColor;
//    [btn setTitleColor:[UIColor colorWithHexString:@"e5c98b"] forState:UIControlStateNormal];
//    [btn setTitle:@"发布商品" forState:UIControlStateNormal];
//    btn.titleLabel.font = [UIFont systemFontOfSize:17.f];
//    btn.tag = 800;
//    [self.view addSubview:btn];
//    
//    WEAKSELF;
//    btn.handleClickBlock = ^(CommandButton *sender) {
//        [weakSelf showPublishGoodsView];
////        UIButton *agreeBtnTmp = (UIButton*)[weakSelf.view viewWithTag:500];
////        BOOL isAgree = [agreeBtnTmp isSelected];
////        if (isAgree) {
////            PublishGoodsViewController *viewController = [[PublishGoodsViewController alloc] init];
////            viewController.handlePublishGoodsFinished = ^(GoodsEditableInfo *goodsEditableInfo) {
////                [weakSelf showHUD:@"发布成功，请等待审核" hideAfterDelay:1.2];
////            };
////            MyNavigationController *navController = [[MyNavigationController alloc] initWithRootViewController:viewController];
////            
////            [[CoordinatingController sharedInstance] presentViewController:navController animated:YES completion:^{
////                
////            }];
////        } else {
////            [weakSelf showHUD:@"请先同意平台售卖协议" hideAfterDelay:0.8f];
////        }
//    };
//    
//    
//    TTTAttributedLabel *agreementLbl = [[TTTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 0)];
//    agreementLbl.delegate = self;
//    agreementLbl.font = [UIFont systemFontOfSize:11.f];
//    agreementLbl.textColor = [UIColor whiteColor];
//    agreementLbl.lineBreakMode = NSLineBreakByWordWrapping;
//    agreementLbl.userInteractionEnabled = YES;
//    agreementLbl.highlightedTextColor = [UIColor colorWithHexString:@"06a6a6"];
//    agreementLbl.numberOfLines = 0;
////    agreementLbl.autoresizesSubviews = YES;
//    agreementLbl.linkAttributes = nil;
//    NSMutableDictionary* attributes = [NSMutableDictionary dictionaryWithDictionary:agreementLbl.activeLinkAttributes];
//    [attributes setObject:(__bridge id)[UIColor colorWithHexString:@"D0B87F"].CGColor forKey:(NSString*)kCTForegroundColorAttributeName];
//    agreementLbl.activeLinkAttributes = attributes;
//    
//    [agreementLbl setText:@"已阅读并同意平台售卖协议" afterInheritingLabelAttributesAndConfiguringWithBlock:^NSMutableAttributedString *(NSMutableAttributedString *mutableAttributedString) {
//        NSRange stringRange = NSMakeRange(mutableAttributedString.length-6,6);
//        [mutableAttributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[[UIColor colorWithHexString:@"D0B87F"] CGColor] range:stringRange];
//        return mutableAttributedString;
//    }];
//    
//    [agreementLbl addLinkToURL:[NSURL URLWithString:kURLSale] withRange:NSMakeRange([agreementLbl.text length]-6,6)];
//    [agreementLbl sizeToFit];
//    agreementLbl.frame = CGRectMake((self.view.width-agreementLbl.bounds.size.width)/2+16, self.view.height-kBottomTabBarHeight-agreementLbl.bounds.size.height-20, agreementLbl.bounds.size.width, agreementLbl.bounds.size.height);
//    [self.view addSubview:agreementLbl];
//    
//    CommandButton *agreeBtn = [[CommandButton alloc] initWithFrame:CGRectMake(agreementLbl.frame.origin.x-30, agreementLbl.frame.origin.y-(30.f-agreementLbl.bounds.size.height)/2-2, 30, 30)];
//    
//    agreeBtn.selected = YES;
//    [agreeBtn setImage:[UIImage imageNamed:@"login_checked.png"] forState:UIControlStateNormal];
//    [self.view addSubview:agreeBtn];
//    agreeBtn.handleClickBlock = ^(CommandButton *sender) {
//        sender.selected = !sender.isSelected;
//        UIButton *btnTmp = (UIButton*)[weakSelf.view viewWithTag:800];
//
//        if ([sender isSelected]) {
//            [sender setImage:[UIImage imageNamed:@"login_checked.png"] forState:UIControlStateNormal];
////            btnTmp.layer.borderColor = [UIColor colorWithHexString:@"e5c98b"].CGColor;
////            [btnTmp setTitleColor:[UIColor colorWithHexString:@"e5c98b"] forState:UIControlStateNormal];
////            btnTmp.enabled = YES;
//        } else {
//            [sender setImage:[UIImage imageNamed:@"login_check.png"] forState:UIControlStateNormal];
//            
////            btnTmp.layer.borderColor = [UIColor colorWithHexString:@"aaaaaa"].CGColor;
////            [btnTmp setTitleColor:[UIColor colorWithHexString:@"aaaaaa"] forState:UIControlStateNormal];
////            btnTmp.enabled = NO;
//        }
//    };
//    agreeBtn.tag = 500;
//    
//    btn.frame = CGRectMake((self.view.width-180)/2,agreeBtn.top-10-btn.height, 180, 45);
//    
//    CGFloat pageWidth = [self pageWidth];
//    CGFloat pageHeight = [self pageWidth];
//    CGFloat Y = (btn.top-topBarHeight-pageHeight)/2;
//    
//    CGFloat sepWidth = (self.view.frame.size.width-pageWidth)/4;
//    ((DMPagingScrollView*)_scrollView).pageWidth = pageWidth+(self.view.frame.size.width-pageWidth)/4;
//    
//    __weak UIView *lastView = nil;
//    for (NSInteger i=0;i<8;i++) {
//        UIView *newView = nil;
//        if (i==0 || i==7) {
//            newView = [[UIView alloc] init];
//            newView.backgroundColor = [UIColor clearColor];
//            newView.translatesAutoresizingMaskIntoConstraints = NO;
//            [newView addConstraint:[NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:sepWidth]];
//        } else {
//            newView = [self pageAtIndex:i-1];
//            newView.translatesAutoresizingMaskIntoConstraints = NO;
//            [newView addConstraint:[NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:newView.width]];;
//        }
//        [_scrollView addSubview:newView];
//        
//        NSMutableArray *constraints = [[NSMutableArray alloc] init];
//        if (lastView) {
//            NSString *str = [NSString stringWithFormat:@"[lastView]-%f-[newView]",sepWidth];
//            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:str options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView, newView)]];
//        } else {
//            [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|[newView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(newView)]];
//        }
//        
////        [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[newView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(newView)]];
//        
//        [constraints addObject:[NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_scrollView attribute:NSLayoutAttributeTop multiplier:1 constant:Y]];
//        
//        [constraints addObject:[NSLayoutConstraint constraintWithItem:newView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:pageHeight]];
//        
//        [_scrollView addConstraints:constraints];
//        lastView = newView;
//    }
//    if (lastView)
//        [_scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[lastView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lastView)]];
////    CGFloat Y = (btn.top-topBarHeight-pageHeight)/2;
////    CGFloat itemViewX = 0;
////    for (NSInteger i=0;i<6;i++) {
////        UIView *view = [self pageAtIndex:i-1];
////        [_scrollView addSubview:view];
////        view.frame = CGRectMake(itemViewX+10.f, Y, view.width, view.height);
////        itemViewX += pageWidth;
////    }
//    
//    ASScrollPageIndicatorView *pageIndicatorView = [[ASScrollPageIndicatorView alloc] initWithFrame:CGRectMake((self.view.width-120)/2, _scrollView.top+Y+pageHeight-32, 120, 2)];
//    _pageIndicatorView = pageIndicatorView;
//    _pageIndicatorView.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:_pageIndicatorView];
//    _pageIndicatorView.numberOfPages = 6;
//    _pageIndicatorView.currentPage = 0;
//}
//
//- (void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//    self.view = nil;
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    CGFloat pageWidth = [self pageWidth];
//    CGFloat sepWidth = (self.view.frame.size.width-pageWidth)/4;
//    int page = floor((self.scrollView.contentOffset.x - sepWidth- pageWidth / 2) / pageWidth) + 1;
//    _pageIndicatorView.currentPage = page;
//    _scrollView.userInteractionEnabled = YES;
//}
//
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
//{
//    
//}
//
//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    _scrollView.userInteractionEnabled = YES;
//}
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat pageWidth = [self pageWidth];
//    CGFloat sepWidth = (self.view.frame.size.width-pageWidth)/4;
//    int page = floor((self.scrollView.contentOffset.x - pageWidth -sepWidth / 2) / pageWidth) + 1;
//    if (page>=0&&page<8) {
//        _pageIndicatorView.currentPage = page;
//        _scrollView.userInteractionEnabled = NO;
//    } else {
//        if (page<0) page=0;
//        _pageIndicatorView.currentPage = page;
//    }
//}
//
//- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
//{
//    _scrollView.userInteractionEnabled = YES;
//}
//
//- (void)attributedLabel:(__unused TTTAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
//{
//    //    [[[UIActionSheet alloc] initWithTitle:[url absoluteString] delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Open Link in Safari", nil), nil] showInView:self.view];
//    if ([[url absoluteString] length]>0) {
//        WebViewController *viewController = [[WebViewController alloc] init];
//        viewController.title = @"平台售卖协议";
//        viewController.url = [url absoluteString];
//        [self pushViewController:viewController animated:YES];
//    }
//}
//
//- (CGFloat)pageWidth {
//    return kScreenWidth*240.f/320.f;
//}
//
//
//- (UIView*)pageAtIndex:(NSInteger)pageIndex {
//    
//    CGFloat pageWidth = [self pageWidth];
//    CGFloat pageHeight = pageWidth;
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, pageWidth, pageHeight)];
//    view.backgroundColor = [UIColor colorWithHexString:@"222222"];
//    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = kScreenWidth*90.f/320.f;
//    
//    NSArray *array = [NSArray arrayWithObjects:
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"你可以卖的", @"title",@"保存较好 状态较好的包和配饰", @"summary",@"sale_icon1",@"imageName",nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"我们筛选", @"title",@"我们知道大家在寻找什么样的商品", @"summary",@"sale_icon2",@"imageName",nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"当你的商品被售出", @"title",@"把商品寄到鉴定中心进行鉴定", @"summary",@"sale_icon3",@"imageName",nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"售前鉴定", @"title",@"保证每款商品都是正品且与图片描述一致", @"summary",@"sale_icon4",@"imageName",nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"发货给买家", @"title",@"我们会把成功通过鉴定的商品发货给买家", @"summary",@"sale_icon5",@"imageName",nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"你收到货款", @"title",@"买家确认收货后你将得到货款", @"summary",@"sale_icon6",@"imageName",nil],
//                      nil];
//    
//    CGFloat marginTop = 20.f;
//    NSDictionary *dict = [array objectAtIndex:pageIndex];
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 0)];
//    titleLbl.font = [UIFont systemFontOfSize:19.5f];
//    titleLbl.textColor = [UIColor colorWithHexString:@"c8b68b"];
//    titleLbl.text = [dict stringValueForKey:@"title"];
//    titleLbl.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:titleLbl];
//    [titleLbl sizeToFit];
//    titleLbl.frame = CGRectMake(0, marginTop, view.width, titleLbl.height);
//    
//    marginTop += titleLbl.height;
//    marginTop += 15;
//    
//    UILabel *summaryLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, view.width-30, 0)];
//    summaryLbl.font = [UIFont systemFontOfSize:12.f];
//    summaryLbl.textColor = [UIColor whiteColor];
//    summaryLbl.text = [dict stringValueForKey:@"summary"];
//    summaryLbl.textAlignment = NSTextAlignmentCenter;
//    summaryLbl.numberOfLines = 0;
//    [view addSubview:summaryLbl];
//    [summaryLbl sizeToFit];
//    summaryLbl.frame = CGRectMake(15, marginTop, view.width-30, summaryLbl.height);
//    
//    marginTop += summaryLbl.height;
//    marginTop += 38.f;
//    
//    
//    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[dict stringValueForKey:@"imageName"]]];
//    imageView.frame = CGRectMake((view.width-imageView.width)/2, marginTop, imageView.width, imageView.height);
//    [view addSubview:imageView];
//    
//    TapDetectingView *overlayView = [self pageOverlayAtIndex:pageIndex];
//    overlayView.tag = 1000;
//    overlayView.hidden = YES;
//    [view addSubview:overlayView];
//    
//    CommandButton *btn = [[CommandButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [btn setImage:[UIImage imageNamed:@"sale_icon_question"] forState:UIControlStateNormal];
//    btn.selected = NO;
//    [view addSubview:btn];
//    btn.frame = CGRectMake(view.width-60, view.height-80, 40, 40);
//    btn.tag = 2000;
//    
//    
//    btn.handleClickBlock = ^(CommandButton *sender) {
//        sender.selected = ![sender isSelected];
//        if ([sender isSelected]) {
//            [sender setImage:[UIImage imageNamed:@"sale_icon_close"] forState:UIControlStateNormal];
//        } else {
//            [sender setImage:[UIImage imageNamed:@"sale_icon_question"] forState:UIControlStateNormal];
//        }
//        [[sender superview] viewWithTag:1000].hidden = ![sender isSelected];
//    };
//    
//    overlayView.handleSingleTapDetected = ^(TapDetectingView *view, UIGestureRecognizer *recognizer) {
//        [[view superview] viewWithTag:1000].hidden = YES;
//        CommandButton *btnTmp = (CommandButton*)[[view superview] viewWithTag:2000];
//        btnTmp.selected = NO;
//        [btnTmp setImage:[UIImage imageNamed:@"sale_icon_question"] forState:UIControlStateNormal];
//    };
//    
//    return view;
//}
//
//- (TapDetectingView*)pageOverlayAtIndex:(NSInteger)pageIndex
//{
//    CGFloat pageWidth = [self pageWidth];
//    CGFloat pageHeight = pageWidth;
//    TapDetectingView *view = [[TapDetectingView alloc] initWithFrame:CGRectMake(0, 0, pageWidth, pageHeight)];
//    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8f];
//    view.layer.masksToBounds = YES;
//    view.layer.cornerRadius = kScreenWidth*90.f/320.f;
//    
//    
//    NSArray *array = [NSArray arrayWithObjects:
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"1.高品质商品交易平台", @"title",@"所有上架的商品\n都会经过我们仔细的筛选", @"summary",nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"2.买家众多", @"title",@"大量的时尚奢品爱好者聚集在此\n寻找他们感兴趣的宝贝", @"summary",nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"3.定价规范，自由买卖", @"title",@"由你定价，我们会提供各种参数以及成功售出的商品价格给你作为参考，你可以直接与客户进行在线沟通", @"summary",nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"4.全程包邮", @"title",@"在交易过程中，\n你只需承担发货给爱丁猫的费用", @"summary",nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"5.卖家保障", @"title",@"宝贝在物流售卖等过程中产生损坏，我们将出面为你洽谈赔偿", @"summary",nil],
//                      [NSDictionary dictionaryWithObjectsAndKeys:@"6.担保交易，轻松赚钱", @"title",@"用户确认收货之后货款将会打入你的爱丁猫账户，你可以随时提现，我们将根据成交价格收取7%的服务费，例如商品出售1000元，最终打入你的爱丁猫账户的钱数是1000*0.93=930元", @"summary",nil],
//                      nil];
//    
//    CGFloat marginTop = 50.f;
//    NSDictionary *dict = [array objectAtIndex:pageIndex];
//    UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, view.width, 0)];
//    titleLbl.font = [UIFont boldSystemFontOfSize:14.f];
//    titleLbl.textColor = [UIColor colorWithHexString:@"c8b68b"];
//    titleLbl.text = [dict stringValueForKey:@"title"];
//    titleLbl.textAlignment = NSTextAlignmentCenter;
//    [view addSubview:titleLbl];
//    [titleLbl sizeToFit];
//    titleLbl.frame = CGRectMake(0, marginTop, view.width, titleLbl.height);
//    
//    marginTop += titleLbl.height;
//    marginTop += 15;
//    
//    UILabel *summaryLbl = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, view.width-30, 0)];
//    summaryLbl.font = [UIFont systemFontOfSize:12.f];
//    summaryLbl.textColor = [UIColor whiteColor];
//    summaryLbl.text = [dict stringValueForKey:@"summary"];
//    summaryLbl.textAlignment = NSTextAlignmentCenter;
//    summaryLbl.numberOfLines = 0;
//    [view addSubview:summaryLbl];
//    [summaryLbl sizeToFit];
//    summaryLbl.frame = CGRectMake(15, marginTop, view.width-30, summaryLbl.height);
//    
//    marginTop += summaryLbl.height;
//    
//    
////    marginTop = (view.height-marginTop)/2;
////    titleLbl.frame = CGRectMake(0, marginTop, view.width, titleLbl.height);
////    marginTop += titleLbl.height;
////    marginTop += 15;
////    summaryLbl.frame = CGRectMake(0, marginTop, view.width, summaryLbl.height);
//    
//    return view;
//}
//
//@end

//为什么来爱丁猫转售你的爱物？
//1. 高品质商品交易平台
//所有上架的商品都会经过我们仔细的筛选
//2. 买家众多
//大量的时尚奢品爱好者聚集在此寻找他们感兴趣的宝贝
//3. 定价规范，自由买卖
//由你定价，我们会提供各种参数以及成功售出的商品价格给你作为参考，你可以直接与客户进行在线沟通
//4. 全程包邮
//在交易过程中，你无需承担任何运输费用
//5. 卖家保障
//宝贝在物流售卖等过程中产生损坏，我们将出面为你洽谈赔偿
//6. 担保交易，轻松赚钱
//用户确认收货之后货款将会打入你的爱丁猫账户，你可以随时提现，我们将根据成交价格收取7%的服务费，例如商品出售1000元，最终打入你的爱丁猫账户的钱数是1000*0.93=930元


//出售流程
//1. 你可以卖的
//保存较好 状态较好的包和配饰
//2. 我们筛选
//我们知道大家在寻找什么样的商品
//3. 当你的商品被售出
//把商品寄到鉴定中心进行鉴定
//4. 售前鉴定
//保证每款商品都是正品 且与图片描述一致
//5. 发货给买家
//我们会把成功通过鉴定的商品发货给买家
//6. 你收到货款
//买家确认收货后你将得到货款
//
//

